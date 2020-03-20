//
//  CommonRequestStruct.m
//  QCMSProject
//
//  Created by Pradeep Singh on 4/22/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//

#import "CommonRequestStruct.h"
#import "JSONStructureConstant.h"
#import "JSONDataExchange.h"


@implementation CommonRequestStruct


@synthesize requestId;
@synthesize postData;
@synthesize extraData;
@synthesize extraString;


- (id) toJSON {
    NSMutableDictionary* jsonObject = [[NSMutableDictionary alloc] init];
    @try
    {
        [jsonObject setObject:requestId forKey:JsonStrucConst_COMMON_REQ_REQUEST_ID];
        [jsonObject setObject:[JSONDataExchange convertDSToJSONObject :postData] forKey:JsonStrucConst_COMMON_REQ_POST_DATA];
        [jsonObject setObject:[JSONDataExchange convertDSToJSONObject :extraData] forKey:JsonStrucConst_COMMON_REQ_EXTRA_DATA];
        [jsonObject setObject:extraString forKey:JsonStrucConst_COMMON_REQ_EXTRA_STRING];
    }
    @catch (NSException* nse)
    {
        NSLog(@"Exception: %@", nse);
    }
    return jsonObject;

}

- (int) getJsonStructureId {
    jsonStructureId = 10;
    return jsonStructureId;
}


- (id) toBean:(id) jsonObject {
    CommonRequestStruct* myself = [[CommonRequestStruct alloc] init];
    
    myself.requestId = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_COMMON_REQ_REQUEST_ID :true];
    myself.postData = (NSMutableDictionary*)  [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_COMMON_REQ_POST_DATA :false];
    myself.extraData =  [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_COMMON_REQ_EXTRA_DATA :false];
    myself.extraString =  (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_COMMON_REQ_EXTRA_STRING :true];
    
    return myself;
}

@end
