//
//  itemsListModel.m
//  polycab
//
//  Created by Shivangi on 25/10/21.
//

#import "ItemListModel.h"

@implementation itemsListModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
      // self.dictionary = dictionary;
    }
    return self;
}

//- (void)setDictionary:(NSDictionary *)dictionary{
////    self.id = dictionary[@“id”] ? : @“”;
////    self.salutation = dictionary[@“salutation"] ? : @“”;
////    self.firstName = dictionary[@"first_name"] ? : @“”;
////
////    self.vehicleRegNo = dictionary[@"vehicle_reg_no"] ? : @“”;
//}

@end
