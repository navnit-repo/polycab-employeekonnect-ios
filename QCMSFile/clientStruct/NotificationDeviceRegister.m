//
//  NotificationDeviceRegister.m
//  QCMSProject
//
//  Created by Pradeep Singh on 4/22/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//

#import "NotificationDeviceRegister.h"
#import "JSONStructureConstant.h"
#import "JSONDataExchange.h"

@implementation NotificationDeviceRegister


@synthesize deviceRegisterId;
@synthesize devicePort;
@synthesize appId;
@synthesize moduleId;
@synthesize sessionDetail;
@synthesize userId;
@synthesize imei;
@synthesize os;

@synthesize NOTIFY_ID;
@synthesize NOTIFY_CONFIG_ID;



- (id) toJSON {
  NSMutableDictionary* jsonObject = [[NSMutableDictionary alloc] init];
    @try
    {
        [jsonObject setObject:deviceRegisterId forKey:JsonStrucConst_NOTIFY_DEVICE_REGISTER_ID];
        [jsonObject setObject:devicePort forKey:JsonStrucConst_NOTIFY_DEVICE_PORT];
        [jsonObject setObject:appId forKey:JsonStrucConst_NOTIFY_APP_ID];
        [jsonObject setObject:moduleId forKey:JsonStrucConst_NOTIFY_MODULE_ID];
        [jsonObject setObject:sessionDetail forKey:JsonStrucConst_NOTIFY_SESSION_DETAIL];
        [jsonObject setObject:userId forKey:JsonStrucConst_NOTIFY_USER_ID];
        [jsonObject setObject:imei forKey:JsonStrucConst_NOTIFY_IMEI];
        [jsonObject setObject:os forKey:JsonStrucConst_NOTIFY_OS];
        
        [jsonObject setObject:NOTIFY_ID forKey:JsonStrucConst_NOTIFY_ID];
        [jsonObject setObject:NOTIFY_CONFIG_ID forKey:JsonStrucConst_NOTIFY_CONFIG_ID];
    }
    @catch (NSException* nse)
    {
            NSLog(@"Exception: %@", nse);
    }
    return jsonObject;
}

- (int) getJsonStructureId {
    jsonStructureId = 300;
    return jsonStructureId;
}


- (id) toBean:(id) jsonObject {
    NotificationDeviceRegister* myself = [[NotificationDeviceRegister alloc] init];
 
    myself.deviceRegisterId =  (NSString*) [JSONDataExchange toBeanObject :jsonObject : JsonStrucConst_NOTIFY_DEVICE_REGISTER_ID :true];
    myself.devicePort =  (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_NOTIFY_DEVICE_PORT :true];
    myself.appId =  (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_NOTIFY_APP_ID :true];
    myself.moduleId =  (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_NOTIFY_MODULE_ID :true];
    myself.sessionDetail =  (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_NOTIFY_SESSION_DETAIL :true];
    myself.userId =  (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_NOTIFY_USER_ID :true];
    myself.imei =  (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_NOTIFY_IMEI :true];
    myself.os =  (NSString*) [JSONDataExchange toBeanObject :jsonObject :JsonStrucConst_NOTIFY_OS :true];
    
    return myself;
}

@end
