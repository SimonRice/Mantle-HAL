//
//  Mantle-HALTests.m
//  Mantle-HALTests
//
//  Created by Simon Rice on 07/18/2015.
//  Copyright (c) 2015 Simon Rice. All rights reserved.
//

// https://github.com/Specta/Specta

#import "Address.h"
#import "Contact.h"
#import "Mantle-HAL.h"

SpecBegin(ContactTestCase)

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
        expect(contact).notTo.beNil();
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
        
        expect(homeAddress).notTo.beNil();
        expect(homeAddress.street).to.equal(@"123 Main Street");
        expect(homeAddress.city).to.equal(@"Detroit");
        expect(homeAddress.state).to.equal(@"MI");
    });
    
    it(@"should have its work address (embedded resource) correctly set up", ^{
        Address *workAddress = contact.workAddress;
        
        expect(workAddress).notTo.beNil();
        expect(workAddress.street).to.equal(@"1 Ford Drive");
        expect(workAddress.city).to.equal(@"Detroit");
        expect(workAddress.state).to.equal(@"MI");
    });
});


SpecEnd
