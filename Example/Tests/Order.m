#import "Order.h"

@implementation Order

+ (NSValueTransformer *)statusJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @"processing": @(OrderStatusProcessing),
                                                                           @"shipped": @(OrderStatusShipped)
                                                                           }];
}

@end
