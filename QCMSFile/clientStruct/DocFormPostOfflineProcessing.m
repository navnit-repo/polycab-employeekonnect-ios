//
//  DocFormPostOfflineProcessing.m
//  QCMSProject
//
//  Created by Pradeep Singh on 5/21/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "JSONStructureConstant.h"
#import "JSONDataExchange.h"
#import "DocFormPostOfflineProcessing.h"

@implementation DocFormPostOfflineProcessing

@synthesize statusClientSubmit;
@synthesize statusServerSubmit;
@synthesize recordStatus;
@synthesize docSubmitDate;
@synthesize trackerNumber;
@synthesize formPostedResponse;
@synthesize serverResponseIdOnFirstSink;
@synthesize dotFormPostObj;


- (id) toJSON {
    @try
    {
    NSMutableDictionary* jsonObject = [[NSMutableDictionary alloc] init];
 
        [jsonObject setObject:statusClientSubmit forKey:JsonStrucConst_STATUS_CLIENT_SUBMIT];
        [jsonObject setObject:statusServerSubmit forKey:JsonStrucConst_STATUS_SERVER_SUBMIT];
        [jsonObject setObject:recordStatus forKey:JsonStrucConst_RECORD_STATUS];
        [jsonObject setObject:docSubmitDate forKey:JsonStrucConst_DOC_SUBMIT_DATE];
        
        [jsonObject setObject:trackerNumber forKey:JsonStrucConst_TRACKER_NO];
        [jsonObject setObject:formPostedResponse forKey:JsonStrucConst_FORM_POST_RESPONSE];
        [jsonObject setObject:serverResponseIdOnFirstSink forKey:JsonStrucConst_SERVER_RESPONSE_ID_ON_FIRST_SINK];

        [jsonObject setObject:[JSONDataExchange convertDSToJSONObject : dotFormPostObj] forKey:JsonStrucConst_DOT_FORM_POST_OBJ];
        return jsonObject;
    }
    @catch (NSException* nse) {
        NSLog(@"Exception: %@", nse);
    }
    return nil;
}
    




- (int) getJsonStructureId {
    jsonStructureId = 7;
    return jsonStructureId;
}

- (id) toBean:(id) jsonObject {
    
    DocFormPostOfflineProcessing* myself  = [[DocFormPostOfflineProcessing alloc] init];
    
    myself.statusClientSubmit = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_STATUS_CLIENT_SUBMIT : true];
    myself.statusServerSubmit = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_STATUS_SERVER_SUBMIT : true];
    myself.recordStatus = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_RECORD_STATUS : true];
    myself.docSubmitDate = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_DOC_SUBMIT_DATE : true];
    myself.trackerNumber = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_TRACKER_NO : true];
    myself.formPostedResponse = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_FORM_POST_RESPONSE : true];
    myself.serverResponseIdOnFirstSink = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_SERVER_RESPONSE_ID_ON_FIRST_SINK : true];

    myself.dotFormPostObj = (DotFormPost*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_DOT_FORM_POST_OBJ : false];
        return myself;
}

@end
