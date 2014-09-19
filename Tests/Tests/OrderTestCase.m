//
//  OrderTestCase.m
//  Mantle-HAL.Tests
//
//  Created by Simon Rice on 17/09/2014.
//  Copyright (c) 2014 Simon Rice. All rights reserved.
//

#import <Specta/Specta.h>

#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

#import "OrderList.h"
#import "Order.h"

SpecBegin(Order)

describe(@"Order List", ^{
    __block OrderList *orderList = nil;
    __block NSArray *orders = nil;
    
    beforeAll(^{
        [MTLHALResource registerClass:Order.class forRelation:@"orders"];
        
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *filePath = [bundle pathForResource:@"orders" ofType:@"json" inDirectory:@"Fixtures"];
        NSData* data = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *orderListDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        orderList = [MTLJSONAdapter modelOfClass:OrderList.class
                              fromJSONDictionary:orderListDictionary
                                           error:nil];
        
        orders = [orderList resourcesForRelation:@"orders"];
    });
    
    it(@"should be an order list", ^{
        expect(orderList).toNot.beNil;
        expect(orderList).to.beKindOf(OrderList.class);
    });
    
    it(@"should have 2 orders", ^{
        expect(orderList).toNot.beNil;
        expect(orderList).to.beKindOf(OrderList.class);
    });
    
    it(@"should have its own fields populated correctly", ^{
        expect(orderList.currentlyProcessing).to.equal(14);
        expect(orderList.shippedToday).to.equal(20);
    });
    
    it(@"should have its links populated correctly", ^{
        expect([orderList.links[@"self"][0] href]).to.equal(@"/orders");
        expect([orderList.links[@"api-root:next"][0] href]).to.equal(@"/orders?page=2");
        expect([orderList.links[@"api-root:find"][0] href]).to.beginWith(@"/orders");
        expect([orderList.links[@"api-root:find"][0] isTemplated]).to.beTruthy;
    });
    
    describe(@"First Order", ^{
        __block Order *order = nil;
        
        beforeAll(^{
            order = orderList.orders[0];
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
            expect([order.links[@"api-root:basket"][0] href]).to.equal(@"/baskets/98712");
            expect([order.links[@"api-root:customer"][0] href]).to.equal(@"/customers/7809");
        });
    });
    
    describe(@"Second Order", ^{
        __block Order *order = nil;
        
        beforeAll(^{
            order = orderList.orders[1];
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
            expect([order.links[@"api-root:basket"][0] href]).to.equal(@"/baskets/97213");
            expect([order.links[@"api-root:customer"][0] href]).to.equal(@"/customers/12369");
        });
    });
});

SpecEnd
