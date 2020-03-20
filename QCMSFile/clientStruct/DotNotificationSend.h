//
//  DotNotificationSend.h
//  QCMSProject
//
//  Created by Pradeep Singh on 4/22/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Network/JSONStructure.h"

@interface DotNotificationSend : NSObject <JSONStructure>
{
@private
    int jsonStructureId;    // structure id is 301
    
    NSNumber* notifyId;
	NSString* operation;
	NSNumber* isRequireLogin;
	NSNumber* respondtoback;
	NSNumber* appRestart;
	NSNumber* contentSendAsBytes;
    
	NSString* notifyContentType;
	NSString* notifyContentTitle;
	NSString* notifyContentMsg;
	NSString* notifyContentUrl;
	id notifyContentData;
	id notifyCallBackData;
	id notifyExtraInfo;
    
    NSString* notifyCreateDate;
    NSNumber* notifyLogId;
      
}



@property NSNumber* notifyId;
@property NSString* operation;
@property NSNumber* isRequireLogin;
@property NSNumber* respondtoback;
@property NSNumber* appRestart;
@property NSNumber* contentSendAsBytes;

@property NSString* notifyContentType;
@property NSString* notifyContentTitle;
@property NSString* notifyContentMsg;
@property NSString* notifyContentUrl;
@property id notifyContentData;
@property id notifyCallBackData;
@property id notifyExtraInfo;
@property NSString* notifyCreateDate;
@property NSNumber* notifyLogId;



@end
