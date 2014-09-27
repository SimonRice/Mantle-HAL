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

#import "OrderList.h"
#import "Order.h"

SpecBegin(Order)

describe(@"Order List", ^{
    __block OrderList *list = nil;
    __block NSArray *orders = nil;
    
    beforeAll(^{
        [MTLHALResource registerClassesForRelations:@{ @"ea:order" : Order.class }];
        
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *filePath = [bundle pathForResource:@"orders" ofType:@"json" inDirectory:@"Fixtures"];
        NSData* data = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *listDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        list = [MTLJSONAdapter modelOfClass:OrderList.class
                         fromJSONDictionary:listDictionary
                                      error:nil];
        
        orders = list.orders;
    });
    
    it(@"should be an order list", ^{
        expect(list).toNot.beNil;
        expect(list).to.beKindOf(list.class);
    });
    
    it(@"should have 2 orders", ^{
        expect(list).toNot.beNil;
        expect(list).to.beKindOf(list.class);
    });
    
    it(@"should have its own fields populated correctly", ^{
        expect(list.currentlyProcessing).to.equal(14);
        expect(list.shippedToday).to.equal(20);
    });
    
    it(@"should have its links populated correctly", ^{
        expect([list.links[@"self"][0] href]).to.equal(@"/orders");
        expect([list.links[@"next"][0] href]).to.equal(@"/orders?page=2");
        expect([list.links[@"ea:find"][0] href]).to.beginWith(@"/orders");
        expect([list.links[@"ea:find"][0] isTemplated]).to.beTruthy;
    });
    
    it(@"should have its documentation URL expanded correctly", ^{
        expect([list extendedHrefForRelation:@"ea:order"]).to.equal(@"http://example.com/docs/rels/order");
        expect([list extendedHrefForRelation:@"ea:find"]).to.equal(@"http://example.com/docs/rels/find");
        expect([list extendedHrefForRelation:@"ea:admin"]).to.equal(@"http://example.com/docs/rels/admin");
        expect([list extendedHrefForRelation:@"ea:basket"]).to.equal(@"http://example.com/docs/rels/basket");
        expect([list extendedHrefForRelation:@"ea:customer"]).to.equal(@"http://example.com/docs/rels/customer");
    });
    
    describe(@"First Order", ^{
        __block Order *order = nil;
        
        beforeAll(^{
            order = orders[0];
        });
        
        it(@"should be an order", ^{
            expect(order).toNot.beNil;
            expect(order).to.beKindOf(Order.class);
        });
        
        it(@"should have its own fields populated correctly", ^{
            expect(order.total).to.equal(30);
            expect(order.currency).to.equal(@"USD");
            expect(order.status).to.equal(OrderStatusShipped);
        });
        
        it(@"should have its links populated correctly", ^{
            expect([order.links[@"self"][0] href]).to.equal(@"/orders/123");
            expect([order.links[@"ea:basket"][0] href]).to.equal(@"/baskets/98712");
            expect([order.links[@"ea:customer"][0] href]).to.equal(@"/customers/7809");
        });
        
        it(@"should have its overriding documentation URL expanded correctly", ^{
            expect([order extendedHrefForRelation:@"ea:order"]).to.equal(@"http://alt-example.com/docs/rels/order");
            expect([order extendedHrefForRelation:@"ea:find"]).to.equal(@"http://alt-example.com/docs/rels/find");
            expect([order extendedHrefForRelation:@"ea:admin"]).to.equal(@"http://alt-example.com/docs/rels/admin");
            expect([order extendedHrefForRelation:@"ea:basket"]).to.equal(@"http://alt-example.com/docs/rels/basket");
            expect([order extendedHrefForRelation:@"ea:customer"]).to.equal(@"http://alt-example.com/docs/rels/customer");
        });
    });
    
    describe(@"Second Order", ^{
        __block Order *order = nil;
        
        beforeAll(^{
            order = orders[1];
        });
        
        it(@"should be an order", ^{
            expect(order).toNot.beNil;
            expect(order).to.beKindOf(Order.class);
        });
        
        it(@"should have its own fields populated correctly", ^{
            expect(order.total).to.equal(20);
            expect(order.currency).to.equal(@"USD");
            expect(order.status).to.equal(OrderStatusProcessing);
        });
        
        it(@"should have its links populated correctly", ^{
            expect([order.links[@"self"][0] href]).to.equal(@"/orders/124");
            expect([order.links[@"ea:basket"][0] href]).to.equal(@"/baskets/97213");
            expect([order.links[@"ea:customer"][0] href]).to.equal(@"/customers/12369");
        });
    });
});

SpecEnd
