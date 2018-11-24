//
//  RGUserRequestItem.h
//  RateGain
//
//  Created by RateGain on 3/27/14.
//  Copyright (c) 2014 RateGain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationRequestItem : NSObject
{
@private
    
    int KEY_ID;
	NSString* KEY_READ;
	NSString* KEY_DELETE;
	NSString* KEY_NOTIFY_CONTENT_TYPE;
	NSString* KEY_NOTIFY_CONTENT_TITLE;
	NSString* KEY_NOTIFY_COTENT_MSG;
	NSString* KEY_NOTIFY_CONTENT_URL;
	NSString* KEY_NOTIFY_CONTENT_DATA;
	NSString* KEY_NOTIFY_CALLBACK_DATA;
	NSString* KEY_NOTIFY_FIELD1;
    NSString* KEY_NOTIFY_FIELD2;
    NSString* KEY_RESPOND_TO_BACK;
    NSString* KEY_REQUIRE_LOGIN;
    NSString* KEY_NOTIFY_CREATE_DATE;
    NSString* KEY_NOTIFY_LOGID;
    NSString* KEY_CALLNAME;
    

}
@property int KEY_ID;
@property NSString* KEY_READ;
@property NSString* KEY_DELETE;
@property NSString* KEY_NOTIFY_CONTENT_TYPE;
@property NSString* KEY_NOTIFY_CONTENT_TITLE;
@property NSString* KEY_NOTIFY_COTENT_MSG;
@property NSString* KEY_NOTIFY_CONTENT_URL;
@property NSString* KEY_NOTIFY_CONTENT_DATA;
@property NSString* KEY_NOTIFY_CALLBACK_DATA;
@property NSString* KEY_NOTIFY_FIELD1;
@property NSString* KEY_NOTIFY_FIELD2;
@property NSString* KEY_RESPOND_TO_BACK;
@property NSString* KEY_REQUIRE_LOGIN;
@property NSString* KEY_NOTIFY_CREATE_DATE;
@property NSString* KEY_NOTIFY_LOGID;
@property NSString* KEY_CALLNAME;
@end
