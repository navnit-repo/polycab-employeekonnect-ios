//
//  NotificationDeviceRegister.h
//  QCMSProject
//
//  Created by Pradeep Singh on 4/22/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Network/JSONStructure.h"

@interface NotificationDeviceRegister : NSObject <JSONStructure>
{
@private
    int jsonStructureId;   // for this class, its value is 300
    
    NSString* deviceRegisterId;
	NSString* devicePort;
	NSString* appId;
	NSString* moduleId;
	NSString* sessionDetail;
	NSString* userId;
	NSString* imei;
	NSString* os;
    
    NSString *NOTIFY_ID;
    NSString * NOTIFY_CONFIG_ID;
    
    
}

@property NSString* deviceRegisterId;
@property NSString* devicePort;
@property NSString* appId;
@property NSString* moduleId;
@property NSString* sessionDetail;
@property NSString* userId;
@property NSString* imei;
@property NSString* os;

@property NSString *NOTIFY_ID;
@property NSString * NOTIFY_CONFIG_ID;


@end

