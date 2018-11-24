//
//  CategoryResponse.m
//  QCMSProject
//
//  Created by Pradeep Singh on 3/24/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import "CategoryResponse.h"
#import "JSONStructureConstant.h"
#import "JSONDataExchange.h"

@implementation CategoryResponse

@synthesize jsonStructureId;
@synthesize moduleId;
@synthesize sessionDetail;
@synthesize userId;
@synthesize categoryList;


-(id) init
{
    self = [super init];
    if(self!=nil) {
        self.jsonStructureId = 302;
    }
    return self;
}


- (id) toJSON {
    NSMutableDictionary* jsonObject = [[NSMutableDictionary alloc] init];
    @try {
        [jsonObject setObject:moduleId forKey:JsonStrucConst_MODULE_ID];
        [jsonObject setObject:[JSONDataExchange convertDSToJSONObject:self.categoryList] forKey:@"CATEGORY_LIST"];
        return jsonObject;
    }
    @catch (NSException* nse) {
        NSLog(@"Exception: %@", nse);
    }
    
    return nil;
    
}

- (int) getJsonStructureId {
    self.jsonStructureId = 302;
    return self.jsonStructureId;
}

- (id) toBean:(id) jsonObject {
    
    CategoryResponse* myself  = [[CategoryResponse alloc] init];
    
    myself.moduleId = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_MODULE_ID : true];
    myself.categoryList = (NSMutableArray*) [JSONDataExchange toBeanObject : jsonObject :@"CATEGORY_LIST" : false];
    
    return myself;
    
}



@end
