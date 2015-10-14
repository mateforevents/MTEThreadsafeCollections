//
//  MTEThreadsafeSet.h
//  MTEThreadsafeCollections
//
//  Created by Matthias Heicke on 15.10.15.
//  Copyright (c) 2015 MATE (mateforevents.com). All rights reserved.
//
//  TODO: NSFastEnumeration implementation (https://www.mikeash.com/pyblog/friday-qa-2010-04-16-implementing-fast-enumeration.html)
//

#import <Foundation/Foundation.h>
@class NSEnumerator;

@interface MTEThreadsafeSet : NSObject <NSCopying, NSMutableCopying, NSSecureCoding, NSFastEnumeration>

@property (readonly, copy) NSSet *set;
@property (readonly, copy) NSArray *array;

@property (readonly, copy) NSArray *allObjects;
@property (readonly) NSUInteger count;

+ (instancetype)setWithSet:(NSSet *)set;
+ (instancetype)setWithArray:(NSArray *)array;

- (NSEnumerator *)objectEnumerator;
- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithObjects:(const id [])objects count:(NSUInteger)cnt NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCapacity:(NSUInteger)numItems NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithSet:(NSSet *)set;

- (void)addObject:(id)object;
- (void)removeObject:(id)object;
- (void)removeAllObjects;

- (id)anyObject;
- (BOOL)containsObject:(id)anObject;

- (instancetype) copy;
- (instancetype) mutableCopy;

- (instancetype) mergeWithNewerSet: (MTEThreadsafeSet*) newThreadsafeSet basedOnOriginalSet: (MTEThreadsafeSet*) originalThreadsafeSet;

@end
