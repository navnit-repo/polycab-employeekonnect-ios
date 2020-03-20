//
//  ProductResponse.m
//  QCMSProject
//
//  Created by Pradeep Singh on 3/24/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import "ProductResponse.h"

#import "JSONStructureConstant.h"
#import "JSONDataExchange.h"



@implementation ProductResponse



@synthesize jsonStructureId;
@synthesize moduleId;
@synthesize sessionDetail;
@synthesize userId;
@synthesize productList;


-(id) init
{
    self = [super init];
    if(self!=nil) {
        self.jsonStructureId = 303;
    }
    return self;
}


- (id) toJSON {
    NSMutableDictionary* jsonObject = [[NSMutableDictionary alloc] init];
    @try {
        [jsonObject setObject:moduleId forKey:JsonStrucConst_MODULE_ID];
        [jsonObject setObject:[JSONDataExchange convertDSToJSONObject:self.productList] forKey:@"PRODUCT_LIST"];
        return jsonObject;
    }
    @catch (NSException* nse) {
        NSLog(@"Exception: %@", nse);
    }
    
    return nil;
    
}

- (int) getJsonStructureId {
    self.jsonStructureId = 303;
    return self.jsonStructureId;
}

- (id) toBean:(id) jsonObject {
    
    ProductResponse* myself  = [[ProductResponse alloc] init];
    
    myself.moduleId = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_MODULE_ID : true];
    myself.productList = (NSMutableArray*) [JSONDataExchange toBeanObject : jsonObject :@"PRODUCT_LIST" : false];
    
    return myself;
    
}


@end
