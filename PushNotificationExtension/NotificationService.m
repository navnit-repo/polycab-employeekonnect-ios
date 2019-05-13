//
//  NotificationService.m
//  PushNotificationExtension
//
//  Created by dotvikios on 30/04/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "NotificationService.h"
#import "PushNotificationHandler.h"
@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService
{
    int count ;
}

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    count =[[[[NSUserDefaults standardUserDefaults] initWithSuiteName:@"group.com.polycab.xmw.employee.push.group"] valueForKey:@"Notification_Count"] intValue];
    count = count +1;
    [[[NSUserDefaults standardUserDefaults] initWithSuiteName:@"group.com.polycab.xmw.employee.push.group"] setObject:[NSString stringWithFormat:@"%d",count] forKey:@"Notification_Count"];
    
    NSNumber *n=[NSNumber numberWithInteger:count];
    self.bestAttemptContent.badge =n;
    // Modify the notification content here...
    //self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
//  [PushNotificationHandler notificationDict:self.bestAttemptContent.userInfo];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [PushNotificationHandler notificationDict:self.bestAttemptContent.userInfo];
    });
    
    self.contentHandler(self.bestAttemptContent);
  
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
