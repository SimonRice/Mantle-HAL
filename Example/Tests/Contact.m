#import "Contact.h"

@implementation Contact

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *keyPaths = [super JSONKeyPathsByPropertyKey].mutableCopy;
    
    [keyPaths addEntriesFromDictionary:@{
                                         @"firstName": @"first_name",
                                         @"lastName": @"last_name"
                                         }];
    
    return keyPaths;
}

- (Address *)homeAddress {
    return (Address *)[self resourceForRelation:@"addr:home"];
}

- (Address *)workAddress {
    return (Address *)[self resourceForRelation:@"addr:work"];
}

@end
