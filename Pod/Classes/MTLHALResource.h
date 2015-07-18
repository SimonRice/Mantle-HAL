/*
 Copyright (C) 2014 Simon Rice
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import <Mantle/Mantle.h>
#import "MTLHALLink.h"

@interface MTLHALResource : MTLModel<MTLJSONSerializing>

/** Contains @see MTLHALLink objects pointing to other resources. */
@property (nonatomic, strong, readonly) NSDictionary *links;


/** The relation key for the resource when embedded in another resource */
@property (nonatomic, strong, readonly) NSString *resourceRelation;

/** 
 *  An embedded resource as specified by the relation key.
 *
 *  @warning Embedded Resources may be a full, partial, or inconsistent 
 *  version of the representation served from the target URI.  The self
 *  link will point to the full version of the resource.
 *
 *  @param relation The key of the link's relation.
 */
- (MTLHALResource *)resourceForRelation:(NSString *)relation;


/**
 *  A list of embedded resources as specified by the relation key.
 *
 *  @warning Embedded Resources may be a full, partial, or inconsistent
 *  version of the representation served from the target URI.  The self
 *  link will point to the full version of the resource.
 *
 *  @param relation The key of the link's relation.
 */
- (NSArray *)resourcesForRelation:(NSString *)relation;


/** 
 *  A URL string as specified by the relation's CURIE pointing to 
 *  documentation about the relation.
 *
 *  @param relation The CURIEd relation key.
 */
- (NSString *)extendedHrefForRelation:(NSString *)relation;

/**
 *  Assigns a relation key to a particular class.  This means all embedded 
 *  objects in a particular relation for all resources will automatically be 
 *  serialised to this class.
 *
 *  @param relation The relation key to assign
 *  @param targetClass The class to assign the relation to.
 */
+ (void)registerClass:(__unsafe_unretained Class)targetClass forRelation:(NSString *)relation;


/**
 *  Assigns relation keys to corresponding classes.  This means all embedded
 *  objects in a particular relation for all resources will automatically be
 *  serialised to this class.
 *
 *  @param classesForRelations Dictionary containing the class (value) to assign
 *  the relation (key) to.
 */
+ (void)registerClassesForRelations:(NSDictionary *)classesForRelations;

@end
