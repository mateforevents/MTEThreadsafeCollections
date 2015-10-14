//
//  MTEThreadsafeArray.m
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



#import "MTEThreadsafeArray.h"
#define MTEThreadsafeArrayCodingKeyInnerArray @"MTEThreadsafeArrayCodingKeyInnerArray"

@interface MTEThreadsafeArray ()
@property (atomic, strong, readonly) dispatch_queue_t queue;
@property (atomic, strong, readonly) NSMutableArray* backingStore;
@end

@implementation MTEThreadsafeArray
@synthesize queue = _queue, backingStore = _backingStore;

- (void) createQueue {
    if (self.queue != nil) {
        return;
    }
    
    @synchronized(self) {
        if (self.queue == nil) {
            NSString *name = [NSString stringWithFormat:@"com.mateforevents.MTEThreadsafeArray.%ld",
                              (unsigned long)self.hash];
            _queue = dispatch_queue_create([name cStringUsingEncoding:NSASCIIStringEncoding],
                                           DISPATCH_QUEUE_CONCURRENT);
        }
    }
}

- (NSMutableArray*) backingStore {
    if (_backingStore != nil) {
        return _backingStore;
    }
    
    @synchronized(self) {
        if (_backingStore == nil) {
            _backingStore = [[NSMutableArray alloc] init];
        }
    }
    
    return _backingStore;
}


- (NSString*) description {
    return [NSString stringWithFormat:@"MTEThreadsafeArray: %@", [self.backingStore description]];
}

#pragma mark - Initializer

- (instancetype)init {
    self = [super init];
    if (self) {
        _backingStore = [[NSMutableArray alloc] init];
        [self createQueue];
    }
    return self;
}

- (instancetype)initWithObjects:(const id [])objects count:(NSUInteger)cnt {
    self = [super init];
    if (self) {
        _backingStore = [[NSMutableArray alloc] initWithObjects:objects count:cnt];
        [self createQueue];
    }
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)numItems {
    self = [super init];
    if (self) {
        _backingStore = [[NSMutableArray alloc] initWithCapacity: numItems];
        [self createQueue];
    }
    return self;
}

- (instancetype) initWithArray:(NSArray *)array {
    self = [self init];
    if (self) {
        _backingStore = [array mutableCopy];
        [self createQueue];
    }
    return self;
}


#pragma mark Class Macros

+ (instancetype)arrayWithSet:(NSSet *)set {
    return [self arrayWithArray: [set allObjects]];
}

+ (instancetype)arrayWithArray:(NSArray *)array {
    return [(MTEThreadsafeArray*)[self alloc] initWithArray: array];
}

#pragma mark NSCoding/Copying

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _backingStore = [[aDecoder decodeObjectOfClass:[NSArray class] forKey:MTEThreadsafeArrayCodingKeyInnerArray] mutableCopy];
        [self createQueue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *) aCoder {
    [aCoder encodeObject:[_backingStore copy] forKey:MTEThreadsafeArrayCodingKeyInnerArray];
}

- (id)copyWithZone:(NSZone *) __unused zone {
    return [(MTEThreadsafeArray*)[[self class] alloc] initWithArray: self.array];
}

- (instancetype) copy {
    return [self copyWithZone: nil];
}

- (id)mutableCopyWithZone:(NSZone *) __unused  zone {
    return [(MTEThreadsafeArray*)[[self class] alloc] initWithArray: self.array];
}

- (instancetype) mutableCopy {
    return [self mutableCopyWithZone: nil];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

#pragma mark - Read methods

- (id)objectAtIndex:(NSUInteger)index {
    __block id object = nil;
    
    [self runSynchronousReadBlock:^(NSMutableArray* backingStore) {
        if (index < [self count]) {
            object = [backingStore objectAtIndex: index];
        }
        else {
            NSAssert(NO, @"out of range exception: index %d to large for %@", (int) index, backingStore);
        }
    }];
    
    return object;
}

- (id)lastObject {
    __block id object = nil;
    
    [self runSynchronousReadBlock:^(NSMutableArray* backingStore) {
        object = [backingStore lastObject];
    }];
    
    return object;
}

- (id) popLastObject {
    __block id object = nil;
    
    [self runSynchronousReadBlock:^(NSMutableArray* backingStore) {
        object = [backingStore lastObject];
        [backingStore removeObject: object];
    }];
    
    return object;
}

- (id)firstObject {
    __block id object = nil;
    
    [self runSynchronousReadBlock:^(NSMutableArray* backingStore) {
        object = [backingStore firstObject];
    }];
    
    return object;
}

- (id) popFirstObject {
    __block id object = nil;
    
    [self runSynchronousReadBlock:^(NSMutableArray* backingStore) {
        object = [backingStore firstObject];
        [backingStore removeObject: object];
    }];
    
    return object;
}


- (NSArray*) array {
    __block NSArray* array = nil;
    
    [self runSynchronousReadBlock:^(NSMutableArray* backingStore) {
        array = [backingStore copy];
    }];
    
    return array;
}

- (NSSet*) set {
    return [NSSet setWithArray: [self array]];
}

- (NSUInteger) count {
    __block NSUInteger count = 0;
    
    [self runSynchronousReadBlock:^(NSMutableArray* backingStore) {
        count = [backingStore count];
    }];
    
    return count;
}

- (NSEnumerator *)objectEnumerator {
    return [[self array] objectEnumerator];
}


#pragma mark - Write Methods

- (void) addObject:(id)object {
    [self runAsynchronousWriteBlock:^(NSMutableArray* backingStore) {
        [backingStore addObject: object];
    }];
}

- (void)addObjects:(NSArray*)objects {
    [self runAsynchronousWriteBlock:^(NSMutableArray* backingStore) {
        [backingStore addObjectsFromArray:objects];
    }];
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    [self runAsynchronousWriteBlock:^(NSMutableArray* backingStore) {
        [backingStore insertObject:anObject atIndex:index];
    }];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    [self runAsynchronousWriteBlock:^(NSMutableArray* backingStore) {
        [backingStore replaceObjectAtIndex:index withObject:anObject];
    }];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    [self runAsynchronousWriteBlock:^(NSMutableArray* backingStore) {
        [backingStore removeObjectAtIndex:index];
    }];
}

- (void)removeLastObject {
    [self runAsynchronousWriteBlock:^(NSMutableArray* backingStore) {
        [backingStore removeLastObject];
    }];
}

- (void)removeObject:(id)object {
    [self runAsynchronousWriteBlock:^(NSMutableArray* backingStore) {
        [backingStore removeObject: object];
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

- (void)runAsynchronousReadBlock:(void(^)(NSMutableArray* backingStore))operationBlock
{
    [self createQueue];
    
    __weak __typeof(self) weakSelf = self;
    dispatch_async(self.queue, ^{
        operationBlock && weakSelf.backingStore ? operationBlock(weakSelf.backingStore) : nil;
    });
}

- (void)runAsynchronousWriteBlock:(void(^)(NSMutableArray* backingStore))operationBlock
{
    [self createQueue];
    
    __weak __typeof(self) weakSelf = self;
    dispatch_barrier_async(self.queue, ^{
        operationBlock && weakSelf.backingStore ? operationBlock(weakSelf.backingStore) : nil;
    });
}

- (void)runSynchronousReadBlock:(void(^)(NSMutableArray* backingStore))operationBlock
{
    [self createQueue];
    
    __weak __typeof(self) weakSelf = self;
    dispatch_sync(self.queue, ^{
        operationBlock && weakSelf.backingStore ? operationBlock(weakSelf.backingStore) : nil;
    });
}


@end
