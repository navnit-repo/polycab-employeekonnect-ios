//
//  itemListDetailModel.m
//  polycab
//
//  Created by Shivangi on 25/10/21.
//

#import "itemListDetailModel.h"

@implementation itemListDetailModel : NSObject

//- (instancetype)initWithDictionary:(NSDictionary *)dict;
//
//@end
//
//@implementation MyClass

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.color = dictionary[@"color"] ;
        self.core = [dictionary valueForKey:@"core"] ;
        
        //[NSString stringWithFormat:@"%d", dictionary[@"core"]];
        self.createdate = dictionary[@"createdate"] ;
        self.field1 = dictionary[@"field1"] ;
        self.field2 = dictionary[@"field2"] ;
        self.listprice = dictionary[@"listprice"] ;
        self.listpricemtr = [dictionary valueForKey:@"listpricemtr"] ; 
        self.modifieddate = dictionary[@"modifieddate"] ;
        self.posnr = dictionary[@"posnr"];
        self.primary_category = dictionary[@"primary_category"];
        self.product = dictionary[@"product"];
        self.qty_mtr = dictionary[@"qty_mtr"];
        self.quantityInUOM = dictionary[@"quantityInUOM"];
        self.revisionno = dictionary[@"revisionno"];
        self.secondary_category = dictionary[@"secondary_category"];
        self.shortDesc = dictionary[@"shortDesc"];
        self.size = dictionary[@"size"];
        self.spaDiscount = dictionary[@"spaDiscount"];
        self.spaTotalAmount = dictionary[@"spaTotalAmount"];
        self.spaUnitRate = dictionary[@"spaUnitRate"];
        self.spaapproved = dictionary[@"spaapproved"];
        self.spalrefid = dictionary[@"spalrefid"];
        self.sparate = dictionary[@"sparate"];
        self.spatype = dictionary[@"spatype"];
        self.spavalue = dictionary[@"spavalue"];
        self.unit_mtr = dictionary[@"unit_mtr"];
        self.version = dictionary[@"version"];
    }
    return self;
}

//- (instancetype)initWithDictionary:(NSDictionary *)dictionary
//{
//    self = [super init];
//    if (self) {
//       self.dictionary = dictionary;
//    }
//    return self;
//}
//
//- (void)setDictionary:(NSDictionary *)dictionary
//{
//
//
//}

@end
