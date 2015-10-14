//
//  MTEThreadsafeDictionary.h
//  MTEThreadsafeCollections
//
//  Created by Matthias Heicke on 15.10.15.
//  Copyright (c) 2015 MATE (mateforevents.com). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTEThreadsafeDictionary : NSObject
@property (readonly) NSUInteger count;
@property (readonly, copy) NSArray *allKeys;
@property (readonly, copy) NSArray *allValues;
@property (readonly, copy) NSDictionary *dictionary;

- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithObjects:(const id [])objects forKeys:(const id <NSCopying> [])keys count:(NSUInteger)cnt NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCapacity:(NSUInteger)numItems NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary;

- (id)objectForKey:(id)aKey;
- (NSArray *)allKeysForObject:(id)anObject;
- (NSEnumerator *)keyEnumerator;
- (NSEnumerator *)objectEnumerator;

- (void)setObject:(id)anObject forKey:(id <NSCopying>)aKey;
- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary;
- (void)removeObjectForKey:(id)aKey;
- (void)removeObjectsForKeys:(NSArray *)keyArray;
- (void)removeAllObjects;

//Callback Methods
- (void)objectsCountCallback:(void(^)(NSUInteger count))callback;
- (void)objectForKey:(id <NSCopying>)key callback:(void(^)(id <NSCopying> key, id object))callback;
- (void)allObjectsCallback:(void(^)(NSArray *objects))callback;
@end
