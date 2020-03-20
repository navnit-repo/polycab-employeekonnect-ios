//
//  ThirdDashView.m
//  QCMSProject
//
//  Created by Ashish Tiwari on 14/01/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import "ThirdDashView.h"
#import "LoadingView.h"
#import "NetworkHelper.h"
#import "DVAsynchImageView.h"
#import "ClientVariable.h"
#import "DotNotificationSend.h"
#import "NotificationRequestStorage.h"
#import "DVAppDelegate.h"



@interface ThirdDashView ()
{
    LoadingView* loadingView;
     NetworkHelper* networkHelper;
   
}

@end


@implementation ThirdDashView
@synthesize notificationLbl;
int notificationUnread = 0;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        
               
        
    }
    return self;
}


+(ThirdDashView*) createInstance
{
    
    ThirdDashView *view = (ThirdDashView *)[[[NSBundle mainBundle] loadNibNamed:@"ThirdDashView" owner:self options:nil] objectAtIndex:0];
    
    
    return view;
}

- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject {
    [loadingView removeFromSuperview];
    if([callName isEqualToString: XmwcsConst_CALL_NAME_FOR_FETCH_NOTIFICATION_LIST])
    {
        [self recievedNotificationPullData : respondedObject];
    }
}

- (void) httpFailureHandler : (NSString*) callName : (NSString*) message
{
    [loadingView removeFromSuperview];
    
}
-(void) updateData
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchPendingNotifications:) name:@"FETCH_PENDING_NOTF" object:nil];
    [self fetchPendingNotifications];
}



-(void)fetchPendingNotifications : (NSNotification*) notification
{
    NSString *bundleIdentifier =   [[NSBundle mainBundle] bundleIdentifier];
    NSString* deviceTokenString =[[NSUserDefaults standardUserDefaults] objectForKey:@"PUSH_TOKEN"];
    
    if(deviceTokenString!=nil && (deviceTokenString.length > 0)) {
        NSMutableDictionary* requestData = [[NSMutableDictionary alloc] init];
        [requestData setObject:bundleIdentifier forKey:@"APP_ID"];
        [requestData setObject:deviceTokenString forKey:@"DEVICE_TOKEN"];
        
        ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
        
        if(clientVariables.CLIENT_USER_LOGIN != nil)
        {
            [requestData setObject:clientVariables.CLIENT_USER_LOGIN.userName forKey:@"USER_ID"];
            [requestData setObject:XmwcsConst_DEVICE_TYPE_IPHONE forKey:@"OS"];
        
            networkHelper = [[NetworkHelper alloc] init];
            [networkHelper genericRequestWith:requestData :self :XmwcsConst_CALL_NAME_FOR_FETCH_NOTIFICATION_LIST];
        }
    }
    
        
}
#pragma mark - pending notification stuff is here


-(void) fetchPendingNotifications
{
    NSString *bundleIdentifier =   [[NSBundle mainBundle] bundleIdentifier];
    NSString* deviceTokenString =[[NSUserDefaults standardUserDefaults] objectForKey:@"PUSH_TOKEN"];
    
    if(deviceTokenString!=nil && (deviceTokenString.length > 0)) {
        NSMutableDictionary* requestData = [[NSMutableDictionary alloc] init];
        [requestData setObject:bundleIdentifier forKey:@"APP_ID"];
        [requestData setObject:deviceTokenString forKey:@"DEVICE_TOKEN"];
        
        ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
        
        [requestData setObject:clientVariables.CLIENT_USER_LOGIN.userName forKey:@"USER_ID"];
        [requestData setObject:XmwcsConst_DEVICE_TYPE_IPHONE forKey:@"OS"];
        
        networkHelper = [[NetworkHelper alloc] init];
        [networkHelper genericRequestWith:requestData :self :XmwcsConst_CALL_NAME_FOR_FETCH_NOTIFICATION_LIST];
    }
}

-(void)recievedNotificationPullData : (NSMutableArray *)notificationData
{
    notificationUnread = 0;
    
    [NotificationRequestStorage createInstance : @"NOTIFICATION_STORAGE" : true];
    NotificationRequestStorage *notificationStorage = [NotificationRequestStorage getInstance];
    NSMutableArray *notificationStorageData = [notificationStorage getRecentDocumentsData : @"False"];
    
    if([notificationStorageData count] >0)
    {
        for(int i=0; i<[notificationStorageData count];i++) {
            NotificationRequestItem* item = (NotificationRequestItem*)[notificationStorageData objectAtIndex:i];
            if([item.KEY_READ caseInsensitiveCompare:@"UnRead"]==NSOrderedSame) {
                notificationUnread = notificationUnread + 1;
            }
        }
    }
    
    
    
    //data inserted in Storage
    for(int i =0; i<[notificationData count];i++)
    {
        DotNotificationSend* notificationObject = (DotNotificationSend* )[notificationData objectAtIndex:i];
        NSString *notifyContentTitle = notificationObject.notifyContentTitle;
        NSString *notifyContentUrl = notificationObject.notifyContentUrl;
        NSString *notifyCreateDate = notificationObject.notifyCreateDate;
        NSString *notifyContentType = notificationObject.notifyContentType;
        NSString *notifyContentMsg = notificationObject.notifyContentMsg;
        
        NSNumber *notifyLogIdIntegerValue = notificationObject.notifyLogId;
        NSString *notifyLogId =  [NSString stringWithFormat:@"%d", [notifyLogIdIntegerValue intValue]];//convert int value to string
        
        NSMutableArray *notifyLogIdDataFromDataBase = [notificationStorage getRecentDocuments :notifyLogId];
        if([notifyLogIdDataFromDataBase count]>0)
        {
            //then skip Insert this Alert in to storage
            NotificationRequestItem* notificationRequestItem = ( NotificationRequestItem*)[notifyLogIdDataFromDataBase objectAtIndex:0];
            if([notificationRequestItem.KEY_READ caseInsensitiveCompare:@"Read"]==NSOrderedSame) {
                NSLog(@"Already read");
            } else if([notificationRequestItem.KEY_READ caseInsensitiveCompare:@"UnRead"]==NSOrderedSame) {
                NSLog(@"Unread item");
            }
        }
        else
        {
            //insert data in to storage
            NotificationRequestItem* notificationRequestItem = [[NotificationRequestItem alloc] init];
            notificationRequestItem.KEY_ID = 0;
            notificationRequestItem.KEY_READ = @"UnRead";
            notificationRequestItem.KEY_DELETE = @"False";
            notificationRequestItem.KEY_NOTIFY_CONTENT_TYPE = notifyContentType;
            notificationRequestItem.KEY_NOTIFY_CONTENT_TITLE =  notifyContentTitle;
            notificationRequestItem.KEY_NOTIFY_COTENT_MSG = notifyContentMsg;
            notificationRequestItem.KEY_NOTIFY_CONTENT_URL = notifyContentUrl;
            notificationRequestItem.KEY_NOTIFY_CONTENT_DATA = @"";
            notificationRequestItem.KEY_NOTIFY_CALLBACK_DATA = @"";
            notificationRequestItem.KEY_NOTIFY_FIELD1 = @"";
            notificationRequestItem.KEY_NOTIFY_FIELD2 =@"";
            notificationRequestItem.KEY_RESPOND_TO_BACK = @"";
            notificationRequestItem.KEY_REQUIRE_LOGIN = @"";
            notificationRequestItem.KEY_NOTIFY_CREATE_DATE = notifyCreateDate;
            notificationRequestItem.KEY_NOTIFY_LOGID = notifyLogId;
            notificationRequestItem.KEY_CALLNAME = @"";
            [notificationStorage insertDoc:notificationRequestItem];
            
            notificationUnread = notificationUnread + 1;
        }
    }
    
    [self updateNotificationMenuStyle];
    
    //storage close
}


-(void) updateNotificationMenuStyle
{
   // notificationUnread = 50;
    
        if(notificationUnread>0) {
            // Notification
            notificationLbl.hidden = NO;
             notificationLbl.text = [NSString stringWithFormat:@"%d", notificationUnread ];
             notificationLbl.font = [UIFont boldSystemFontOfSize:17];
            //notificationLbl.layer.cornerRadius = 15;
            notificationLbl.backgroundColor = [self colorWithHexString:@"db3131"];
           // notificationLbl.layer.masksToBounds = YES;
            
        } else {
            notificationLbl.hidden = YES;
            // notificationLbl.text = @"";
            // notificationLbl.font = [UIFont systemFontOfSize:17];
            
        }
        
   }

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+(void) removeObsr
{
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name: @"FETCH_PENDING_NOTF" object:nil];
    
}



@end
