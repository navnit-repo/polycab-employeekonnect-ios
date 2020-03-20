//
//  DotNotificationSend.m
//  QCMSProject
//
//  Created by Pradeep Singh on 4/22/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//

#import "DotNotificationSend.h"
#import "JSONStructureConstant.h"
#import "JSONDataExchange.h"

@implementation DotNotificationSend

@synthesize notifyId;
@synthesize operation;
@synthesize isRequireLogin;
@synthesize respondtoback;
@synthesize appRestart;
@synthesize contentSendAsBytes;

@synthesize notifyContentType;
@synthesize notifyContentTitle;
@synthesize notifyContentMsg;
@synthesize notifyContentUrl;
@synthesize notifyContentData;
@synthesize notifyCallBackData;
@synthesize notifyExtraInfo;

@synthesize notifyCreateDate;
@synthesize notifyLogId;


- (id) toJSON {
    
    NSMutableDictionary* jsonObject = [[NSMutableDictionary alloc] init];
    @try
    {
        [jsonObject setObject:notifyId forKey:JsonStrucConst_NOTIFY_ID];
        [jsonObject setObject:operation forKey:JsonStrucConst_NOTIFY_OPERATION];
        [jsonObject setObject:isRequireLogin forKey:JsonStrucConst_NOTIFY_IS_REQUIRE_LOGIN];
        [jsonObject setObject:respondtoback forKey:JsonStrucConst_NOTIFY_IS_RESPOND_BACK];
        [jsonObject setObject:appRestart forKey:JsonStrucConst_NOTIFY_IS_APP_RESTART];
        [jsonObject setObject:contentSendAsBytes forKey:JsonStrucConst_NOTIFY_IS_CONTENT_SEND_AS_BYTES];
        [jsonObject setObject:notifyContentType forKey:JsonStrucConst_NOTIFY_CONTENT_TYPE];
        [jsonObject setObject:notifyContentTitle forKey:JsonStrucConst_NOTIFY_CONTENT_TITLE];
        [jsonObject setObject:notifyContentMsg forKey:JsonStrucConst_NOTIFY_CONTENT_MSG];
        [jsonObject setObject:notifyContentUrl forKey:JsonStrucConst_NOTIFY_CONTENT_URL];
        [jsonObject setObject:[JSONDataExchange convertDSToJSONObject:notifyExtraInfo] forKey:JsonStrucConst_NOTIFY_EXTRA_INFO];
        [jsonObject setObject:[JSONDataExchange convertDSToJSONObject:notifyContentData] forKey:JsonStrucConst_NOTIFY_CONTENT_DATA];
        [jsonObject setObject:[JSONDataExchange convertDSToJSONObject:notifyCallBackData] forKey:JsonStrucConst_NOTIFY_CONTENT_CALL_BACK_DATA];
        [jsonObject setObject:notifyCreateDate forKey:JsonStrucConst_NOTIFY_CREATE_DATE];
        [jsonObject setObject:notifyLogId forKey:JsonStrucConst_NOTIFY_LOG_ID];
        
        
        
        
    }
    @catch (NSException* nse)
    {
        NSLog(@"Exception: %@", nse);
    }
    return jsonObject;
}

- (int) getJsonStructureId {
    jsonStructureId = 301;
    return jsonStructureId;
}


- (id) toBean:(id) jsonObject {
    DotNotificationSend* myself = [[DotNotificationSend alloc] init];
    
    myself.notifyId = (NSNumber*) [JSONDataExchange  toBeanObject :jsonObject :JsonStrucConst_NOTIFY_ID :true];
    myself.operation =  (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_NOTIFY_OPERATION :true];
    myself.isRequireLogin = (NSNumber*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_NOTIFY_IS_REQUIRE_LOGIN :true];
    myself.respondtoback = (NSNumber*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_NOTIFY_IS_RESPOND_BACK :true];
    myself.appRestart = (NSNumber*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_NOTIFY_IS_APP_RESTART :true];
    myself.contentSendAsBytes = (NSNumber*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_NOTIFY_IS_CONTENT_SEND_AS_BYTES :true];
    
    myself.notifyContentType = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_NOTIFY_CONTENT_TYPE :true];
    myself.notifyContentTitle = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_NOTIFY_CONTENT_TITLE :true];
    myself.notifyContentMsg = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_NOTIFY_CONTENT_MSG :true];
    myself.notifyContentUrl = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_NOTIFY_CONTENT_URL :true];
    myself.notifyExtraInfo =  [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_NOTIFY_EXTRA_INFO :true];
    myself.notifyContentData =  [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_NOTIFY_CONTENT_DATA :false];
    myself.notifyCallBackData =   [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_NOTIFY_CONTENT_CALL_BACK_DATA :true];
    
    myself.notifyLogId = (NSNumber*) [JSONDataExchange  toBeanObject :jsonObject :JsonStrucConst_NOTIFY_LOG_ID :true];
    myself.notifyCreateDate = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_NOTIFY_CREATE_DATE :true];
    
    return myself;
}

@end
