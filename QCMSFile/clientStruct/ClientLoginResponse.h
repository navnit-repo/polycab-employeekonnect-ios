//
//  ClientLoginResponse.h
//  QCMSProject
//
//  Created by Pradeep Singh on 5/21/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "../Network/JSONStructure.h"
#import "ClientMasterDetail.h"


@interface ClientLoginResponse : NSObject <JSONStructure>
{
@private
    int jsonStructureId;
    
    NSString* userLoginStatus;
    NSString* userLoginMessage;
    NSString* passwrdState;
    NSString* passwrdStateMessage;
    NSNumber* maxUserDocNumber;
    NSMutableArray*  serverDateTime;
    NSMutableDictionary* menuDetail;
    ClientMasterDetail* clientMasterDetail;
    NSMutableDictionary* dashboardData;
    NSString* authToken;
    
}


@property NSString* userLoginStatus;
@property NSString* userLoginMessage;
@property NSString* passwrdState;
@property NSString* passwrdStateMessage;
@property NSNumber* maxUserDocNumber;
@property NSMutableArray*  serverDateTime;
@property NSMutableDictionary* menuDetail;
@property ClientMasterDetail* clientMasterDetail;
@property NSMutableDictionary* dashboardData;
@property NSString* authToken;


@end
