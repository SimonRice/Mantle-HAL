//
//  ContactTestCase.m
//  Mantle-HAL.Tests
//
//  Created by Simon Rice on 17/09/2014.
//  Copyright (c) 2014 Simon Rice. All rights reserved.
//

#import <Specta/Specta.h>

#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

#import "Contact.h"
#import "Address.h"

SpecBegin(Thing)

describe(@"Contact", ^{
    __block Contact *contact = nil;
    
    beforeAll(^{
        [MTLHALResource registerClass:Address.class forRelation:@"addr:home"];
        [MTLHALResource registerClass:Address.class forRelation:@"addr:work"];
        
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *filePath = [bundle pathForResource:@"contact" ofType:@"json" inDirectory:@"Fixtures"];
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
});

SpecEnd
