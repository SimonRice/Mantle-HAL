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

@interface MTLHALLink : MTLModel<MTLJSONSerializing>

/** This required value is either a URI or a URI Template.
 *
 *  If the value is a URI Template then @see isTemplated should be true.
 */
@property (nonatomic, strong, readonly) NSString *href;


/** The expected MIME type at the target resource. */
@property (nonatomic, strong, readonly) NSString *type;


/** An indication that the link is deprecated.  Its value is a URL that 
 *  should provide further information about the deprecation. 
 */
@property (nonatomic, strong, readonly) NSString *deprecation;


/** A URL string that hints about the profile (@see 
 * https://tools.ietf.org/html/draft-wilde-profile-link-04 ) of the
 * target resource.
 */
@property (nonatomic, strong, readonly) NSString *profile;


/** A human-readable identifier for the link. */
@property (nonatomic, strong, readonly) NSString *title;


/** A secondary key for selecting Link Objects which share the 
 *  same relation. 
 */
@property (nonatomic, strong, readonly) NSString *name;


/** The language of the target resource. */
@property (nonatomic, strong, readonly) NSString *hreflang;


/** When the @see href property is a URI Template, this value
 *  should be true.  Otherwise, it is false
 */
@property (nonatomic, readonly) BOOL isTemplated;

@end
