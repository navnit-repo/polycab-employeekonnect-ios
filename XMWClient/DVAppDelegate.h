//
//  DVAppDelegate.h
//  XMWClient
//
//  Created by Pradeep Singh on 5/22/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageViewController.h"
#import "LogInVC.h"
#import "SWRevealViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "ChatHistory_Object.h"
extern ChatHistory_Object *puchNotifiactionChatHistory_Object;
extern CGFloat deviceWidthRation;
extern CGFloat deviceHeightRation;
extern CGFloat bottomBarHeight;
extern BOOL ChatBoxPushNotifiactionFlag;
extern BOOL ChatRoomPushNotifiactionFlag;
extern BOOL regIDCheck;
@interface DVAppDelegate : UIResponder <UIApplicationDelegate, HttpEventListener,UNUserNotificationCenterDelegate>
{
     NSString *launchUrlString;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LogInVC *viewController;
@property (nonatomic, retain) UINavigationController *navController;
- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler;

+ (NSString*) currentModuleContext;
+ (void) pushModuleContext : (NSString*) moduleCtx;
+ (void) popModuleContext;

@end
