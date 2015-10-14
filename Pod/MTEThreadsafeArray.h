//
//  MTEThreadsafeArray.h
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
