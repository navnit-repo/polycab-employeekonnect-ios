//
//  DocPostResponse.m
//  QCMSProject
//
//  Created by Pradeep Singh on 5/21/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "JSONStructureConstant.h"
#import "JSONDataExchange.h"
#import "DocPostResponse.h"

@implementation DocPostResponse


@synthesize trackerNumber;
@synthesize submittedMessage;
@synthesize submitStatus;
@synthesize submittedData;



- (id) toJSON {
    NSMutableDictionary* jsonObject = [[NSMutableDictionary alloc] init];
    
    @try
    {
        
        [jsonObject setObject:trackerNumber forKey:JsonStrucConst_TRACKER_NO];
        [jsonObject setObject:submittedMessage forKey:JsonStrucConst_SUBMIT_MESSAGE];
        [jsonObject setObject:submitStatus forKey:JsonStrucConst_SUBMIT_STATUS];
        [jsonObject setObject:submittedData forKey:JsonStrucConst_SUBMIT_DATA];
        return jsonObject;
    }
    @catch (NSException* nse)
    {
        NSLog(@"Exception: %@", nse);
    }
    return nil;
    
    
    
}

- (int) getJsonStructureId {
    jsonStructureId = 6;
    return jsonStructureId;
}

- (id) toBean:(id) jsonObject {
    
    DocPostResponse* myself  = [[DocPostResponse alloc] init];
    
    
    myself.trackerNumber = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_TRACKER_NO : true];
    myself.submittedMessage = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_SUBMIT_MESSAGE : true];
    myself.submitStatus= (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_SUBMIT_STATUS : true];
    myself.submittedData = (NSDictionary*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_SUBMIT_DATA : false];
         
    return myself;
}

@end
