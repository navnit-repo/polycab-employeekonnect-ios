//
//  NotificationService.m
//  PushNotificationExtension
//
//  Created by dotvikios on 30/04/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "NotificationService.h"
#import "PushNotificationHandler.h"
#import "KeychainItemWrapper.h"
@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
   
    // Modify the notification content here...
    //self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
    [PushNotificationHandler notificationDict:self.bestAttemptContent.userInfo];
    self.contentHandler(self.bestAttemptContent);
  
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
