//
//  ClientLoginResponse.m
//  QCMSProject
//
//  Created by Pradeep Singh on 5/21/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ClientLoginResponse.h"
#import "JSONStructureConstant.h"
#import "JSONDataExchange.h"
#import "ClientMasterDetail.h"

@implementation ClientLoginResponse


@synthesize userLoginStatus;
@synthesize userLoginMessage;
@synthesize passwrdState;
@synthesize passwrdStateMessage;
@synthesize maxUserDocNumber;
@synthesize serverDateTime;
@synthesize menuDetail;
@synthesize clientMasterDetail;
@synthesize dashboardData;
@synthesize authToken;

- (id) toJSON {
    NSMutableDictionary* jsonObject = [[NSMutableDictionary alloc] init];
    @try {
        [jsonObject setObject:userLoginStatus forKey:JsonStrucConst_USER_LOGIN_STATUS];
        [jsonObject setObject:userLoginMessage forKey:JsonStrucConst_USER_LOGIN_MSG];
        [jsonObject setObject:passwrdState forKey:JsonStrucConst_PASS_STATE];

        [jsonObject setObject:passwrdStateMessage forKey:JsonStrucConst_PASS_STATE_MSG];

        [jsonObject setObject:[JSONDataExchange convertDSToJSONObject:menuDetail] forKey:JsonStrucConst_MENU_DETAIL];
        [jsonObject setObject:maxUserDocNumber forKey:JsonStrucConst_MAX_DOC_NO];
        
        [jsonObject setObject:[JSONDataExchange convertDSToJSONObject :serverDateTime] forKey:JsonStrucConst_SERVER_DATE_TIME];

        [jsonObject setObject:[JSONDataExchange convertDSToJSONObject: clientMasterDetail] forKey:JsonStrucConst_CLIENT_MASTER_DETAIL];
        
        
        [jsonObject setObject:[JSONDataExchange convertDSToJSONObject:dashboardData] forKey:JsonStrucConst_USER_DASHBOARD_DATA];
         [jsonObject setObject:[JSONDataExchange convertDSToJSONObject: authToken] forKey:JsonStrucConst_AUTH_TOKEN];
        
        return jsonObject;
    }
    @catch (NSException* nse) {
        NSLog(@"Exception: %@", nse);
    }

     return nil;

}

- (int) getJsonStructureId {
    jsonStructureId = 2;
    return jsonStructureId;
}

- (id) toBean:(id) jsonObject {
    
    ClientLoginResponse* myself  = [[ClientLoginResponse alloc] init];
    
    myself.userLoginStatus = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_USER_LOGIN_STATUS : true];
    myself.userLoginMessage = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_USER_LOGIN_MSG : true];
    myself.passwrdState = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_PASS_STATE : true];
    myself.authToken = (NSString*)[JSONDataExchange toBeanObject:jsonObject : JsonStrucConst_AUTH_TOKEN:true];
    myself.passwrdStateMessage = (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_PASS_STATE_MSG : true];
    myself.menuDetail = (NSMutableDictionary*) [JSONDataExchange toBeanObject : jsonObject :JsonStrucConst_MENU_DETAIL : false];
    
    myself.maxUserDocNumber = (NSNumber*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_MAX_DOC_NO : true];
    
    myself.serverDateTime = (NSMutableArray*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_SERVER_DATE_TIME : false];
    
    myself.clientMasterDetail = (ClientMasterDetail*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_CLIENT_MASTER_DETAIL : false];
    
    myself.dashboardData = (NSMutableDictionary*) [JSONDataExchange toBeanObject : jsonObject :JsonStrucConst_USER_DASHBOARD_DATA : false];
    
    return myself;
    
}

@end
