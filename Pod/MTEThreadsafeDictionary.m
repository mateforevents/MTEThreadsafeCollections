//
//  MTEThreadsafeDictionary.m
//  MTEThreadsafeCollections
//
//  Created by Matthias Heicke on 15.10.15.
//  Copyright (c) 2015 MATE (mateforevents.com). All rights reserved.
//
//  The MIT License (MIT)
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  TODO: NSFastEnumeration implementation (https://www.mikeash.com/pyblog/friday-qa-2010-04-16-implementing-fast-enumeration.html)


#import "MTEThreadsafeDictionary.h"
#define MTEThreadsafeDictionaryCodingKeyBackingStore @"MTEThreadsafeDictionaryCodingKeyBackingStore"

@interface MTEThreadsafeDictionary ()
@property (atomic, strong, readonly) dispatch_queue_t queue;
@property (atomic, strong, readonly) NSMutableDictionary* backingStore;
@end

@implementation MTEThreadsafeDictionary
@synthesize queue = _queue, backingStore = _backingStore;

- (void) createQueue {
	if (self.queue != nil) {
		return;
	}

	@synchronized(self) {
		if (self.queue == nil) {
			NSString *name = [NSString stringWithFormat:@"com.mateforevents.MTEThreadsafeDictionary.%ld",
							  (unsigned long)self.hash];
			_queue = dispatch_queue_create([name cStringUsingEncoding:NSASCIIStringEncoding],
										   DISPATCH_QUEUE_CONCURRENT);
		}
	}
}

- (NSMutableDictionary*) backingStore {
	if (_backingStore != nil) {
		return _backingStore;
	}

	@synchronized(self) {
		if (_backingStore == nil) {
			_backingStore = [[NSMutableDictionary alloc] init];
		}
	}

	return _backingStore;
}

- (NSString*) description {
	return [NSString stringWithFormat:@"MTEThreadsafeDictionary: %@", [self.backingStore description]];
}

#pragma mark - Initializer

- (instancetype)init {
	self = [super init];
	if (self) {
		_backingStore = [[NSMutableDictionary alloc] init];
		[self createQueue];
	}
	return self;
}


- (instancetype)initWithCapacity:(NSUInteger)numItems {
	self = [super init];
	if (self) {
		_backingStore = [[NSMutableDictionary alloc] initWithCapacity: numItems];
		[self createQueue];
	}
	return self;
}

- (instancetype)initWithObjects:(const id [])objects forKeys:(const id <NSCopying> [])keys count:(NSUInteger)cnt {
	self = [super init];
	if (self) {
		_backingStore = [[NSMutableDictionary alloc] initWithObjects:objects forKeys:keys count:cnt];
		[self createQueue];
	}
	return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)otherDictionary {
	self = [self init];
	if (self) {
		_backingStore = [otherDictionary mutableCopy];
		[self createQueue];
	}
	return self;
}

#pragma mark Class Macros

+ (instancetype)dictionaryWithDictionary:(NSDictionary *)dict {
	return [(MTEThreadsafeDictionary*)[self alloc] initWithDictionary: dict];
}

#pragma mark NSCoding/Copying

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	if (self) {
		_backingStore = [[aDecoder decodeObjectOfClass:[NSDictionary class] forKey:MTEThreadsafeDictionaryCodingKeyBackingStore] mutableCopy];
		[self createQueue];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:[_backingStore copy] forKey:MTEThreadsafeDictionaryCodingKeyBackingStore];
}

- (id)copyWithZone:(NSZone *)  zone {
	return [(MTEThreadsafeDictionary*)[[self class] alloc] initWithDictionary: [self.dictionary copy]];
}

- (instancetype) copy {
	return [self copyWithZone: nil];
}

- (id)mutableCopyWithZone:(NSZone *)  zone {
	return [(MTEThreadsafeDictionary*)[[self class] alloc] initWithDictionary: [self.dictionary copy]];
}

- (instancetype) mutableCopy {
	return [self mutableCopyWithZone: nil];
}

+ (BOOL)supportsSecureCoding {
	return YES;
}

#pragma mark - Read methods

- (id)objectForKey:(id)aKey {
	__block id object = nil;

	[self runSynchronousReadBlock:^(NSMutableDictionary* backingStore) {
		object = [backingStore objectForKey: aKey];
	}];

	return object;
}

- (id) valueForKey:(NSString *)key {
	__block id object = nil;

	[self runSynchronousReadBlock:^(NSMutableDictionary* backingStore) {
		object = [backingStore valueForKey: key];
	}];

	return object;
}

- (NSArray *)allKeysForObject:(id)anObject {
	__block NSArray* array = nil;

	[self runSynchronousReadBlock:^(NSMutableDictionary* backingStore) {
		array = [backingStore allKeysForObject: anObject];
	}];

	return array;
}

- (NSArray*) allKeys {
	__block NSArray* array = nil;

	[self runSynchronousReadBlock:^(NSMutableDictionary* backingStore) {
		array = [backingStore allKeys];
	}];

	return array;
}

- (NSArray*) allValues {
	__block NSArray* array = nil;

	[self runSynchronousReadBlock:^(NSMutableDictionary* backingStore) {
		array = [backingStore allValues];
	}];

	return array;
}

- (NSDictionary*) dictionary {
	__block NSDictionary* dictionary = nil;

	[self runSynchronousReadBlock:^(NSMutableDictionary* backingStore) {
		dictionary = [backingStore copy];
	}];

	return dictionary;
}

- (NSUInteger) count {
	__block NSUInteger count = 0;

	[self runSynchronousReadBlock:^(NSMutableDictionary* backingStore) {
		count = [backingStore count];
	}];

	return count;
}

- (NSEnumerator *)keyEnumerator {
	return [[self dictionary] keyEnumerator];
}

- (NSEnumerator *)objectEnumerator {
	return [[self dictionary] objectEnumerator];
}

#pragma mark Callbacks

- (void)objectsCountCallback:(void(^)(NSUInteger count))callback {
	__weak NSThread *weakThread = NSThread.currentThread;
	[self runAsynchronousReadBlock:^(NSMutableDictionary *dictionary)
	 {
		 NSUInteger count = dictionary.count;
		 [MTEThreadsafeDictionary performOnThread: weakThread block:^ {
			 callback ? callback(count) : nil;
		 }];
	 }];
}

- (void)objectForKey:(id <NSCopying>)key callback:(void(^)(id <NSCopying> key, id object))callback {

	__weak NSThread *weakThread = NSThread.currentThread;
	[self runAsynchronousReadBlock:^(NSMutableDictionary *dictionary)
	 {
		 id object = [dictionary objectForKey:key];
		 [MTEThreadsafeDictionary performOnThread: weakThread block:^ {
			 callback ? callback(key, object) : nil;
		 }];
	 }];

}

- (void)allObjectsCallback:(void(^)(NSArray *objects))callback {
	__weak NSThread *weakThread = NSThread.currentThread;
	[self runAsynchronousReadBlock:^(NSMutableDictionary *dictionary)
	 {
		 NSArray *array = [dictionary allKeys];
		 [MTEThreadsafeDictionary performOnThread: weakThread block:^ {
			 callback ? callback(array) : nil;
		 }];
	 }];
}


#pragma mark - Write Methods

- (void)setObject:(id)anObject forKey:(id <NSCopying>)aKey {
	[self runAsynchronousWriteBlock:^(NSMutableDictionary* backingStore) {
		[backingStore setObject:anObject forKey: aKey];
	}];
}

- (void)setValue:(id)value forKey:(NSString *)key {
	[self runAsynchronousWriteBlock:^(NSMutableDictionary* backingStore) {
		[backingStore setValue:value forKey: key];
	}];
}

- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary {
	[self runAsynchronousWriteBlock:^(NSMutableDictionary* backingStore) {
		[backingStore addEntriesFromDictionary: otherDictionary];
	}];
}

- (void)removeObjectForKey:(id)aKey {
	[self runAsynchronousWriteBlock:^(NSMutableDictionary* backingStore) {
		[backingStore removeObjectForKey:aKey];
	}];
}

- (void)removeObjectsForKeys:(NSArray *)keyArray {
	[self runAsynchronousWriteBlock:^(NSMutableDictionary* backingStore) {
		[backingStore removeObjectsForKeys: keyArray];
	}];
}

- (void)removeAllObjects {
	[self runAsynchronousWriteBlock:^(NSMutableDictionary* backingStore) {
		[backingStore removeAllObjects];
	}];
}

- (BOOL) isEqual:(id)object {
	if ([object isKindOfClass:[self class]]) {
		return [self.backingStore isEqual: [object backingStore]];
	}
	else {
		return [object isEqual: self.backingStore];
	}
}

#pragma mark - private

- (void)runAsynchronousReadBlock:(void(^)(NSMutableDictionary* backingStore))operationBlock
{
	[self createQueue];

	__weak __typeof(self) weakSelf = self;
	dispatch_async(self.queue, ^{
		operationBlock && weakSelf.backingStore ? operationBlock(weakSelf.backingStore) : nil;
	});
}

- (void)runAsynchronousWriteBlock:(void(^)(NSMutableDictionary* backingStore))operationBlock
{
	[self createQueue];

	__weak __typeof(self) weakSelf = self;
	dispatch_barrier_async(self.queue, ^{
		operationBlock && weakSelf.backingStore ? operationBlock(weakSelf.backingStore) : nil;
	});
}

- (void)runSynchronousReadBlock:(void(^)(NSMutableDictionary* backingStore))operationBlock
{
	[self createQueue];

	__weak __typeof(self) weakSelf = self;
	dispatch_sync(self.queue, ^{
		operationBlock && weakSelf.backingStore ? operationBlock(weakSelf.backingStore) : nil;
	});
}

+ (void) performOnThread:(NSThread *)thread block:(void (^)(void))block
{
	if (block) {
		thread = thread ?: [NSThread mainThread];

		// it is the same thread, so we just run it without 'performSelector'
		if (thread == NSThread.currentThread) {
			block();
		}
		else {
			[self performSelector: @selector(performBlock:)
						 onThread: thread
					   withObject: (id)block
					waitUntilDone: NO];
		}
	}
}

+ (void) performBlock:(void (^)(void))block
{
	if (block) {
		block();
	}
}

@end

