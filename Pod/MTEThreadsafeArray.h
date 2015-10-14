//
//  MTEThreadsafeArray.h
//  MTEThreadsafeCollections
//
//  Created by Matthias Heicke on 15.10.15.
//  Copyright (c) 2015 MATE (mateforevents.com). All rights reserved.
//
//  TODO: NSFastEnumeration implementation (https://www.mikeash.com/pyblog/friday-qa-2010-04-16-implementing-fast-enumeration.html)
//

#import <Foundation/Foundation.h>

@interface MTEThreadsafeArray : NSObject <NSCopying, NSMutableCopying, NSSecureCoding>
@property (readonly) NSUInteger count;

@property (readonly, copy) NSArray *array;
@property (readonly, copy) NSSet *set;

+ (instancetype)arrayWithArray:(NSArray *)array;
+ (instancetype)arrayWithSet:(NSSet *)set;

- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithObjects:(const id [])objects count:(NSUInteger)cnt NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCapacity:(NSUInteger)numItems NS_DESIGNATED_INITIALIZER;
- (instancetype) initWithArray:(NSArray *)array;

- (id)objectAtIndex:(NSUInteger)index;
- (id)lastObject;
- (id)popLastObject;
- (id)firstObject;
- (id)popFirstObject;


- (void)addObject:(id)anObject;
- (void)addObjects:(NSArray*)objects;
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

- (void)removeLastObject;
- (void)removeObject:(id)object;
- (void)removeObjectAtIndex:(NSUInteger)index;

- (instancetype) copy;
- (instancetype) mutableCopy;

@end
