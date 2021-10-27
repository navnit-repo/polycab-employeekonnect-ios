//
//  itemListDetailModel.h
//  polycab
//
//  Created by Shivangi on 25/10/21.
//

#import <Foundation/Foundation.h>

@interface itemListDetailModel : NSObject

//@property (nonatomic, strong) NSNumber *date;
//@property (nonatomic, strong) NSString * day;
//@property (nonatomic, strong) NSString * hours;
//@property (nonatomic, strong) NSString * minutes;
//@property (nonatomic, strong) NSString * month;
//@property (nonatomic, strong) NSString * nanos;
//@property (nonatomic, strong) NSNumber *seconds;
//@property (nonatomic, strong) NSString * time;
//@property (nonatomic, strong) NSString * timezoneOffset;
//@property (nonatomic, strong) NSString * year;


@property (nonatomic, strong) NSString * color;
@property (nonatomic, strong) NSNumber * core;
@property (nonatomic, strong) NSString * createdate;
@property (nonatomic, strong) NSString * field1;
@property (nonatomic, strong) NSString * field2;
@property (nonatomic, strong) NSString * listprice;
@property (nonatomic, strong) NSNumber * listpricemtr;
@property (nonatomic, strong) NSString * longDesc;
@property (nonatomic, strong) NSString * modifieddate;
@property (nonatomic, strong) NSString * posnr;
@property (nonatomic, strong) NSString * primary_category;
@property (nonatomic, strong) NSString * product;
@property (nonatomic, strong) NSString * qty_mtr;
@property (nonatomic, strong) NSString * quantityInUOM;
@property (nonatomic, strong) NSString * revisionno;
@property (nonatomic, strong) NSString * secondary_category;
@property (nonatomic, strong) NSString * shortDesc;
@property (nonatomic, strong) NSString * size;
@property (nonatomic, strong) NSString * spaDiscount;
@property (nonatomic, strong) NSString * spaTotalAmount;
@property (nonatomic, strong) NSString * spaUnitRate;
@property (nonatomic, strong) NSString * spaapproved;
@property (nonatomic, strong) NSString * spalrefid;
@property (nonatomic, strong) NSString * sparate;
@property (nonatomic, strong) NSString * spatype;
@property (nonatomic, strong) NSString * spavalue;
@property (nonatomic, strong) NSString * unit_mtr;
@property (nonatomic, strong) NSString * version;

- (instancetype)initWithDictionary: (NSDictionary *) dictionary;

@end
