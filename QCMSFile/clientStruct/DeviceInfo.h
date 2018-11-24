//
//  DeviceInfo.h
//  QCMSProject
//
//  Created by Pradeep Singh on 5/21/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Network/JSONStructure.h"

@interface DeviceInfo : NSObject
{
    NSString* deviceType;//Black Berry/Iphone/Andorid
	NSString* imei;
	NSString* imsi;
	NSString* deviceId;
	NSMutableDictionary* deviceDtail;
    
}


@property NSString* deviceType;
@property NSString* imei;
@property NSString* imsi;
@property NSString* deviceId;
@property NSMutableDictionary* deviceDtail;

@end
