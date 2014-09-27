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

#import <Specta/Specta.h>

#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

#import "Contact.h"
#import "Address.h"

SpecBegin(Contact)

describe(@"Contact", ^{
    __block Contact *contact = nil;
    
    beforeAll(^{
        [MTLHALResource registerClass:Address.class forRelation:@"addr:home"];
        [MTLHALResource registerClass:Address.class forRelation:@"addr:work"];
        
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *filePath = [bundle pathForResource:@"contacts" ofType:@"json" inDirectory:@"Fixtures"];
        NSData* data = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *contactDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        contact = [MTLJSONAdapter modelOfClass:Contact.class
                            fromJSONDictionary:contactDictionary
                                         error:nil];
    });
    
    it(@"should be a contact", ^{
        expect(contact).toNot.beNil;
        expect(contact).to.beKindOf(Contact.class);
    });
    
    it(@"should have its own fields populated correctly", ^{
        expect(contact.firstName).to.equal(@"Henry");
        expect(contact.lastName).to.equal(@"Ford");
    });
    
    it(@"should have its links populated correctly", ^{
        expect([contact.links[@"self"][0] href]).to.equal(@"http://tempuri.org/contacts/1234");
        expect([contact.links[@"addr:home"][0] href]).to.equal(@"http://tempuri.org/address/827");
        expect([contact.links[@"addr:work"][0] href]).to.equal(@"http://tempuri.org/address/6421");
    });
    
    it(@"should have its documentation URL expanded correctly", ^{
        expect([contact extendedHrefForRelation:@"addr:home"]).to.equal(@"http://tempuri.org/rels/address/home");
        expect([contact extendedHrefForRelation:@"addr:work"]).to.equal(@"http://tempuri.org/rels/address/work");
    });
    
    it(@"should have its home address (embedded resource) correctly set up", ^{
        Address *homeAddress = contact.homeAddress;
        
        expect(homeAddress).toNot.beNil;
        expect(homeAddress.street).to.equal(@"123 Main Street");
        expect(homeAddress.city).to.equal(@"Detroit");
        expect(homeAddress.state).to.equal(@"MI");
    });
    
    it(@"should have its work address (embedded resource) correctly set up", ^{
        Address *workAddress = contact.workAddress;
        
        expect(workAddress).toNot.beNil;
        expect(workAddress.street).to.equal(@"1 Ford Drive");
        expect(workAddress.city).to.equal(@"Detroit");
        expect(workAddress.state).to.equal(@"MI");
    });
});

SpecEnd
