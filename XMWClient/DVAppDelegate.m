//
//  DVAppDelegate.m
//  XMWClient
//
//  Created by Pradeep Singh on 5/22/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <objc/runtime.h>
#import "DVAppDelegate.h"
#import "PageViewController.h"
#import "AppConstants.h"
//#import "MenuViewController.h"
#import "MenuVC.h"
#import "ObjectStorage.h"
#import "ClientVariable.h"
#import "SearchRequestStorage.h"
#import "RecentRequestStorage.h"
#import "SBJsonParser.h"
#import "NotificationDeviceRegister.h"
#import "DotNotificationSend.h"
#import "XmwNotificationWebViewController.h"

#import "XmwHttpFileDownloader.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>


#import "SBJson.h"

#import <Crashlytics/Crashlytics.h>
#import "SWRevealViewController.h"
#import "DashBoardVC.h"
#import "LeftViewVC.h"
#import <Fabric/Fabric.h>
#import "ChatBoxVC.h"
#import "ChatRoomsVC.h"
#import "ChatHistory_Object.h"
#import "ChatHistory_DB.h"
#import "ChatThreadList_Object.h"
#import "ChatThreadList_DB.h"
#import "ContactList_DB.h"
#import "ContactList_Object.h"
#import <UserNotifications/UserNotifications.h>
#import "NewInstanceNsUserDefault.h"
#import "KeychainWrapper.h"
#import "ExpendObjectClass.h"
#import "NationalDashboardVC.h"

#import "UncaughtExceptionHandler.h"

CGFloat deviceWidthRation;
CGFloat deviceHeightRation;
CGFloat bottomBarHeight;
BOOL ChatBoxPushNotifiactionFlag;
BOOL ChatRoomPushNotifiactionFlag;
BOOL SELF_EXTEND;
BOOL regIDCheck;
ChatHistory_Object *puchNotifiactionChatHistory_Object;
ChatThreadList_Object *puchNotifiactionChatThreadList_Object;
static NSMutableArray*  DVAppDelegate_moduleContextStack = nil;

#define LOCAL_PLAY_ALERT_TAG 9001

@interface UIAlertView (Play)
@property NSURL* localPlayURL;
@end

@implementation UIAlertView (Play)
- (NSURL*)localPlayURL;
{
    return objc_getAssociatedObject(self, "localPlayURL");
}

- (void)setLocalPlayURL:(NSURL*)property;
{
    objc_setAssociatedObject(self, "localPlayURL", property, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end



@interface DVAppDelegate ()
{
    LoadingView* loadingView;
    NetworkHelper* networkHelper;
    
}



@end

@implementation DVAppDelegate
@synthesize navController;


- (void)installUncaughtExceptionHandler
{
    InstallUncaughtExceptionHandler();
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  if (granted) {
                                      NSLog(@"Notifications permission granted.");
                                  }
                                  else
                                  {
                                      NSLog(@"Notifications permission denied because: %@.",error.localizedDescription);
                                  }
                               
                                  
                                  // Enable or disable features based on authorization.
                              }];
        // IOS8 and 9 was:
        /*
         [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
         [application registerForRemoteNotifications];
         */
    }


    [NSThread sleepForTimeInterval:3.0];
    [Crashlytics startWithAPIKey:@"cc9f075af7ebdd5493d67c5fc8b720e55f346463"];
    
    // Let the device know we want to receive push notifications
    
    // for iOS 8 onwards this function available
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
#if TARGET_IPHONE_SIMULATOR
    [[NSUserDefaults standardUserDefaults] setObject:@"d816e5f1785e936ae51f350b45ae47daf856124ae621683090133711ed2911b5" forKey:@"PUSH_TOKEN"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
#endif
    
    
    // initializing SearchRequestStorage
    [SearchRequestStorage createInstance];
    [ObjectStorage createInstance : @"MAIN_OBJECT_STORAGE" : true];
    
    
    //initializing RecentRequestStorage
    [RecentRequestStorage createInstance : @"RECENT_REQUEST_STORAGE" : true];
    
    self.viewController = [[LogInVC alloc] initWithNibName:@"LogInVC" bundle:nil];
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];

    
    deviceWidthRation = self.window.frame.size.width/320;
    deviceHeightRation = self.window.frame.size.width/320;
    // deviceHeightRation = self.window.frame.size.height/568;
    
    
    NSArray *versionCompatibility = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ( 11 == [[versionCompatibility objectAtIndex:0] intValue] || [[versionCompatibility objectAtIndex:0] intValue] > 11 )
    {
        bottomBarHeight = self.window.safeAreaInsets.bottom;
        
    } else {
        bottomBarHeight = 0.0;
        
    }
    
   
    //for polycab push handling
    
    if (launchOptions != nil)
    {
        // for remote push notification launch
        NSDictionary *remotePayLoad = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (remotePayLoad != nil) {
            NSLog(@"Appliction Launched from push notification: %@", remotePayLoad);
            // we got the remote notification here, do here what to do
            NSDictionary* apsContent = [remotePayLoad objectForKey:@"aps"];
            if(apsContent!=nil) {
                id alertContent = [apsContent objectForKey:@"alert"];
                NSString* messageString = [apsContent objectForKey:@"message"];
            }
            
            NSString* pushURL = [remotePayLoad objectForKey:@"URL"];
            if(pushURL!=nil) {
                [self pushNotificationNetworkCall : pushURL];
            }
        }
    

        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"launchOptions"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // opened from a push notification when the app is closed
        NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo != nil)
        {
            NSLog(@"userInfo->%@", [userInfo objectForKey:@"aps"]);
            NSLog(@"didReceiveRemoteNotification :%@", userInfo);
            
            NSDictionary *mainDict = nil;
            
            // polycab notification code
            NSObject* contentMsg = [userInfo objectForKey:@"CONTENT_MSG"];
            if(contentMsg!=nil) {
                if([contentMsg isKindOfClass:[NSString class]]) {
                    NSString* jsonStr = (NSString*) contentMsg;
                    NSData *webData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
                    NSError *error;
                    mainDict = [NSJSONSerialization JSONObjectWithData:webData options:0 error:&error];
                } else if([contentMsg isKindOfClass:[NSDictionary class]]) {
                    mainDict = (NSDictionary*) contentMsg;
                }
            }
            
            NSLog(@"%@",mainDict);
            
            if ([[mainDict objectForKey:@"OPERATION"] isEqualToString:@"8"] ) {
                if ([[mainDict objectForKey:@"NOTIFY_CALLNAME"] isEqualToString:@"NEW_MESSAGE"]) {
                    
                    NSMutableDictionary *responsedict = [[NSMutableDictionary alloc]init];
                    [responsedict setDictionary:[mainDict objectForKey:@"NOTIFY_MESSAGE_KEY"]];
                    ChatHistory_Object* chatHistory_Object = [[ChatHistory_Object alloc] init];
                    chatHistory_Object.chatThreadId =  [[responsedict valueForKey:@"chatThread"] integerValue] ;
                    puchNotifiactionChatHistory_Object = chatHistory_Object;
                    ChatRoomPushNotifiactionFlag = YES;
//                     [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:[NSString stringWithFormat:@"NEW_PUSH_%d",chatHistory_Object.chatThreadId]];

                }  else if ([[mainDict valueForKey:@"NOTIFY_CALLNAME"] isEqualToString:@"NEW_THREAD"]) {

                    NSMutableDictionary *responsedict = [[NSMutableDictionary alloc]init];
                    [responsedict setDictionary:[mainDict objectForKey:@"NOTIFY_MESSAGE_KEY"]];
                    ChatThreadList_Object* chatThreadList_Object = [[ChatThreadList_Object alloc] init];
                    chatThreadList_Object.chatThreadId = [[[responsedict valueForKey:@"message"] valueForKey:@"chatThread"] integerValue];
                    puchNotifiactionChatThreadList_Object= chatThreadList_Object;
                    ChatBoxPushNotifiactionFlag = YES;
//                    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:[NSString stringWithFormat:@"NEW_PUSH_%d",chatThreadList_Object.chatThreadId]];

                } else if ([[mainDict valueForKey:@"NOTIFY_CALLNAME"] isEqualToString:@"CHAT_THREAD_STATUS_UPDATE"]) {
                    NSMutableDictionary *responsedict = [[NSMutableDictionary alloc]init];
                    [responsedict setDictionary:[mainDict objectForKey:@"NOTIFY_MESSAGE_KEY"]];
                    ChatThreadList_Object* chatThreadList_Object = [[ChatThreadList_Object alloc] init];
                    chatThreadList_Object.chatThreadId =  [[responsedict valueForKey:@"chatThreadId"]  integerValue];
                    puchNotifiactionChatThreadList_Object= chatThreadList_Object;
                    ChatBoxPushNotifiactionFlag = YES;
                }
            }
            
        }
        
        NSDictionary* urlInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
        
        if(urlInfo!=nil) {
            NSLog(@"launching using url: %@" , [urlInfo description]);
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[urlInfo description] preferredStyle:UIAlertControllerStyleAlert];
               
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault
                       handler:^(UIAlertAction * action)
                       {
                            
                       }];
            [alertController addAction:defaultAction];
            
            [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
        }
    }
   
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    for notification count
        [[[NSUserDefaults standardUserDefaults] initWithSuiteName:XmwcsConst_APPGROUP_IDENTIFIER] setObject:[NSString stringWithFormat:@"%d",0] forKey:@"Notification_Count"];
    
    
    // handling VAPT Scenario: Automatic background snapshot
    UIImageView* bgImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"01_splash.jpg"]];
    bgImageView.frame = self.window.bounds;
    bgImageView.contentMode = UIViewContentModeCenter;
    bgImageView.tag = 11111;
    
    [self.window addSubview:bgImageView];
    
    // handling VAPT Scenario:  Side Channel Leakage Through Pasteboard
    // UIPasteboard.general.items = []
    [UIPasteboard generalPasteboard].items =  [[NSMutableArray alloc] init];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    UIView* bgView =  [self.window viewWithTag:11111];
    if(bgView!=nil) [bgView removeFromSuperview];
 
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    
    // Since server may have expired user session, if user not logged out, then make user log in
    
    NSString* isChecked = [[NSUserDefaults standardUserDefaults] objectForKey:@"ISCHECKED"];   // it should be YES
    NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
    NSString* password = [[NSUserDefaults standardUserDefaults] objectForKey:@"PASSWORD"];
    
    if(isChecked!=nil && [isChecked isEqualToString:@"YES"]) {
        if(username!=nil && [username length]>0 && password!=nil && [password length]>0) {
            NSDate* lastLoggedTime = (NSDate*)[[NSUserDefaults standardUserDefaults] objectForKey:@"LAST_AUTO_LOGGED_IN_TIME"];
            
            if(lastLoggedTime!=nil) {
                NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:lastLoggedTime];
                // signed in user automatically
                NSLog(@"last logged in time interval = %f", interval);
                if(interval > 30*60) {
                    if(interval < 24*3600) {
                        [self signedUsingUsername:username havingPassword:password];
                    } else {
                        // we need to ask user to enter login password again.
                        
                    }
                }
            }
        }
    }

    UIViewController *root;
    root = [[[[UIApplication sharedApplication]windows]objectAtIndex:0]rootViewController];
    if ([root isKindOfClass:[SWRevealViewController class]]) {
        SWRevealViewController *reveal = (SWRevealViewController*)root;
        UINavigationController *check =(UINavigationController*)reveal.frontViewController;
        NSArray* viewsList = check.viewControllers;
        UIViewController *checkView = (UIViewController *) [viewsList objectAtIndex:viewsList.count - 1];
        if ([checkView isKindOfClass:[ChatBoxVC class]]) {
            ChatBoxVC *vc  = (ChatBoxVC *) checkView;
            [ChatThreadList_DB createInstance : @"ChatThread_DB_STORAGE" : true];
            ChatThreadList_DB *chatThreadListStorage = [ChatThreadList_DB getInstance];
            NSMutableArray *chatThreadListStorageData = [chatThreadListStorage getRecentDocumentsData : @"False"];
            vc.chatThreadDict = [[NSMutableArray alloc]init];
            [vc.chatThreadDict addObjectsFromArray:[self groupData:chatThreadListStorageData]];
            [vc.threadListTableView reloadData];
        }
        else if ([checkView isKindOfClass:[ChatRoomsVC class]]) {
            
            ChatRoomsVC *vc  = (ChatRoomsVC *) checkView;
            
            [ChatHistory_DB createInstance : @"ChatHistory_DB_STORAGE" : true :[vc.chatThreadId integerValue]];
            ChatHistory_DB *chatHistory_DBStorage = [ChatHistory_DB getInstance];
            NSMutableArray *chatHistoryStorageData = [chatHistory_DBStorage getRecentDocumentsData : @"False"];
            vc.chatHistoryArray = [[NSMutableArray alloc]init];
            vc.chatHistoryArray =chatHistoryStorageData;
            [vc.chatRoomTableView reloadData];
            [vc.chatRoomTableView layoutIfNeeded];
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow: ([vc.chatRoomTableView numberOfRowsInSection:([vc.chatRoomTableView numberOfSections]-1)]-1) inSection: ([vc.chatRoomTableView numberOfSections]-1)];
            [vc.chatRoomTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            [vc unreadMessageNetworkCall];
        }
        else if ([checkView isKindOfClass:[DashBoardVC class]])
        {
            DashBoardVC *vc = (DashBoardVC*) checkView;
            [vc viewWillAppear:false];
        }
        else
        {
            
        }
        
        //    for notification count
        [[[NSUserDefaults standardUserDefaults] initWithSuiteName:XmwcsConst_APPGROUP_IDENTIFIER] setObject:[NSString stringWithFormat:@"%d",0] forKey:@"Notification_Count"];
    }
   
    [[NSNotificationCenter defaultCenter] postNotificationName:XmwcsConst_DASHBOARD_FOREGROUND_AUTOREFRESH_IDENTIFIER object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FETCH_PENDING_NOTF" object:nil];
    
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
//    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    for (NSString *key in [userDef dictionaryRepresentation].allKeys) {
        if ([key hasPrefix:@"CHAT_HISTORY_FIRST_TIME_FETCH_"]) {
            [userDef removeObjectForKey:key];
        }
    }
     [userDef synchronize];
    
    //    for notification count
    [[[NSUserDefaults standardUserDefaults] initWithSuiteName:XmwcsConst_APPGROUP_IDENTIFIER] setObject:[NSString stringWithFormat:@"%d",0] forKey:@"Notification_Count"];
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"NewsMobile device token is: %@", deviceToken);
    
    const unsigned *tokenBytes = [deviceToken bytes];
    
    
    NSString *tokenStr = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    
    NSString *postData = [NSString stringWithFormat:@"type=ios&token=%@",tokenStr];
    
     NSLog(@"Device Token is: %@", postData);
     KeychainWrapper* keychainWrapper = [[KeychainWrapper alloc]init];
    
     [keychainWrapper mySetObject:tokenStr forKey:(__bridge id)(kSecAttrAccount)];
    
    [[NSUserDefaults standardUserDefaults] setObject:tokenStr forKey:@"PUSH_TOKEN"];
     [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"DVAppDelegate: Failed to get token, error: %@", error);
}

// for remote notifications
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"didReceiveRemoteNotification :%@", userInfo);
     [[NSNotificationCenter defaultCenter] postNotificationName:@"FETCH_PENDING_NOTF" object:nil];
    // we got the remote notification here, do here what to do
    NSDictionary* apsContent = [userInfo objectForKey:@"aps"];
    if(apsContent!=nil) {
        id alertContent = [apsContent objectForKey:@"alert"];
        NSString* messageString = [apsContent objectForKey:@"message"];
        SBJsonParser* sbparser = [[SBJsonParser alloc] init];
        NSDictionary* message = [sbparser objectWithString:messageString];
        
        if(message!=nil) {
            
        }
    }
    launchUrlString = [userInfo objectForKey:@"URL"];
    if(launchUrlString !=nil)
    {
        if(launchUrlString.length > 0)
        {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Would you like to open notification." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel" , nil];
            myAlertView.tag = 1015;
            [myAlertView show];
        }
    }
    
    // polycab notification code
    NSString *jsonStr =[userInfo objectForKey:@"CONTENT_MSG"];
    if(jsonStr!=nil) {
        SBJsonParser* sbparser = [[SBJsonParser alloc] init];
        NSDictionary* mainDict = [sbparser objectWithString:jsonStr];
        // NSDictionary* mainDict = [userInfo objectForKey:@"CONTENT_MSG"];
        NSLog(@"%@",mainDict);
        
        if ([[mainDict objectForKey:@"OPERATION"] isEqualToString:@"8"] ) {
            if ([[mainDict objectForKey:@"NOTIFY_CALLNAME"] isEqualToString:@"NEW_MESSAGE"]) {
                
                NSMutableDictionary *responsedict = [[NSMutableDictionary alloc]init];
                [responsedict setDictionary:[mainDict objectForKey:@"NOTIFY_MESSAGE_KEY"]];
                ChatHistory_Object* chatHistory_Object = [[ChatHistory_Object alloc] init];
                chatHistory_Object.chatThreadId =  [[responsedict valueForKey:@"chatThread"] integerValue] ;
                puchNotifiactionChatHistory_Object = chatHistory_Object;
                ChatRoomPushNotifiactionFlag = YES;
                //                     [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:[NSString stringWithFormat:@"NEW_PUSH_%d",chatHistory_Object.chatThreadId]];
                
            }  else if ([[mainDict valueForKey:@"NOTIFY_CALLNAME"] isEqualToString:@"NEW_THREAD"]) {
                
                NSMutableDictionary *responsedict = [[NSMutableDictionary alloc]init];
                [responsedict setDictionary:[mainDict objectForKey:@"NOTIFY_MESSAGE_KEY"]];
                ChatThreadList_Object* chatThreadList_Object = [[ChatThreadList_Object alloc] init];
                chatThreadList_Object.chatThreadId = [[[responsedict valueForKey:@"message"] valueForKey:@"chatThread"] integerValue];
                ChatBoxPushNotifiactionFlag = YES;
                //                    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:[NSString stringWithFormat:@"NEW_PUSH_%d",chatThreadList_Object.chatThreadId]];
                
            } else if ([[mainDict valueForKey:@"NOTIFY_CALLNAME"] isEqualToString:@"CHAT_THREAD_STATUS_UPDATE"]) {
                ChatBoxPushNotifiactionFlag = YES;
            }
        }
    }
    
}



- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *) options
{
    
    NSLog(@"openURL: url =  %@", [url description]);
    
    NSLog(@"openURL: options %@", [options description]);
    
    return YES;
}

//
// receives the launch event when click on the url from another app
//
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> *  restorableObjects))restorationHandler
{
    NSLog(@"continueUserActivity using url: %@" , [userActivity description]);
    
    NSLog(@"userActivity.activityType : %@" , userActivity.activityType);
    
    if([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {

        if(userActivity.webpageURL !=nil) {
            
            NSString* deepLinkUrl = [userActivity.webpageURL absoluteString];
            
            [[NSUserDefaults standardUserDefaults] setObject:deepLinkUrl forKey:@"deepLinkUrl"];

            /*
            if([deepLinkUrl containsString:@"/employee/cobapproval"]) {
                [[NSUserDefaults standardUserDefaults] setObject:deepLinkUrl forKey:@"/employee/cobapproval"];
            }*/
            
            UIViewController* root = [[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController];
            if ([root isKindOfClass:[SWRevealViewController class]]) {
                SWRevealViewController *reveal = (SWRevealViewController*)root;
                UINavigationController *check =(UINavigationController*)reveal.frontViewController;
                NSArray* viewsList = check.viewControllers;
                UIViewController *checkView = (UIViewController *) [viewsList objectAtIndex:viewsList.count - 1];
                if ([checkView isKindOfClass:[DashBoardVC class]])
                {
                    DashBoardVC *vc = (DashBoardVC*) checkView;
                    [vc viewWillAppear:false];
                }
                else
                {
                    // explicit open the URL in the WebView
                    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
                    NSString* launchedUrl = [deepLinkUrl stringByAppendingFormat:@"&authToken=%@", clientVariables.CLIENT_LOGIN_RESPONSE.authToken ];
                    [self pushNotificationNetworkCall: launchedUrl];
                    // remove it
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"deepLinkUrl"];
                }
            } else {
                // Most likely use is on LoginVC screen, and trying to get logged in.
                // then on post logged in, DashBoardVC shall take care of it.
            }
        }
    }
    
#if 0
    
    // below code for testing only
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[userActivity description] preferredStyle:UIAlertControllerStyleAlert];
       
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault
               handler:^(UIAlertAction * action)
               {
                    
               }];
    [alertController addAction:defaultAction];
    
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
#endif
    
    return YES;
}


#pragma mark - XMW

//
// to support multiple module so that we can use client variables based on the current module context
//
+ (NSString*) currentModuleContext {
    if(DVAppDelegate_moduleContextStack != nil) {
//        return [DVAppDelegate_moduleContextStack objectAtIndex: [DVAppDelegate_moduleContextStack count] - 1 ];
        if([DVAppDelegate_moduleContextStack count]>0) {
            return [DVAppDelegate_moduleContextStack objectAtIndex: [DVAppDelegate_moduleContextStack count] - 1 ];
        }

    }
    
    return @"";
}


+ (void) pushModuleContext : (NSString*) moduleCtx {
    if(DVAppDelegate_moduleContextStack == nil) {
        DVAppDelegate_moduleContextStack = [[NSMutableArray alloc] init];
    }
    [DVAppDelegate_moduleContextStack addObject:moduleCtx];
}

+ (void) popModuleContext {
    if(DVAppDelegate_moduleContextStack != nil) {
//        [DVAppDelegate_moduleContextStack removeObjectAtIndex: [DVAppDelegate_moduleContextStack count] - 1];
        if([DVAppDelegate_moduleContextStack count]>0) {
            [DVAppDelegate_moduleContextStack removeObjectAtIndex: [DVAppDelegate_moduleContextStack count] - 1];
        }

    }
}

-(void) downloadCompleted :(NSString*) savedFilename
{
    NSLog(@"Video Download Completed");
    
    NSURL *url=[[NSURL alloc] initFileURLWithPath:savedFilename];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    if([library videoAtPathIsCompatibleWithSavedPhotosAlbum:url])
    {
        [library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error)
         {
             if(error)
             {
                 NSLog(@"error=%@",error.localizedDescription);
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"File Downloader" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
                 [alertView show];
             } else {
                 NSLog(@"URL = %@",assetURL);
                 NSLog(@"Download completed...");
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"File Downloader" message:@"Video Saved. Do you want to play it." delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No" , nil];
                 alertView.localPlayURL = assetURL;
                 alertView.tag = LOCAL_PLAY_ALERT_TAG;
                 [alertView show];
             }
         }];
    } else
    {
        NSLog(@"error, video not saved...");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"File Downloader" message:@"error, video not saved..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        [alertView show];
    }
    
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:savedFilename];
    if(image!=nil)
    {
        [library writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation                          completionBlock:^(NSURL* assetURL, NSError* error)
         {
             if (error) {
                 NSLog(@"Image not saved");
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
                 [alertView show];
             } else {
                 NSLog(@"Image saved ");
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Save image" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
                 [alertView show];
             }
         }];
    }
    [XmwUtils toastView:@"Download Complete"];
}

-(void) percentDownloadComplete : (float) percent
{
    // NSLog( @"Some Percent Download ");
}


-(void) failedToDownlad:(NSString*) message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"File Downloader Error" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [alertView show];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ((alertView.tag == 701) || (alertView.tag == 702) || (alertView.tag == 700))
    {
        NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
        if([title isEqualToString:@"OK"])
        {
            [XmwUtils toastView:@"Your Downloading Start"];
            
            XmwHttpFileDownloader* fileDownloader = [[XmwHttpFileDownloader alloc] initWithUrl:launchUrlString];
            
            [fileDownloader downloadStart:self];
        }
    } else if(alertView.tag == LOCAL_PLAY_ALERT_TAG) {
        NSURL* localSavedURL = alertView.localPlayURL;
        if(buttonIndex==0) {
            dispatch_async(dispatch_get_main_queue(), ^() {
                MPMoviePlayerViewController *moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:localSavedURL];
                [self.navController presentMoviePlayerViewControllerAnimated:moviePlayerController];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieFinishedCallback:)
                                                             name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayerController];
            });
        }
    }
   else if(alertView.tag == 1015)
    {
        NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
        if([title isEqualToString:@"OK"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //code to be executed in the background
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:launchUrlString]];
                [self pushNotificationNetworkCall : launchUrlString];
            });
        }
        
    }
    
    
}



#pragma  mark - HttpEventListener


// device registration network call response

- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject {
    if(respondedObject)
    {
        if([callName isEqualToString: XmwcsConst_CALL_NAME_FOR_NOTIFY_PUSH_SEND])
        {
            //store pull data in Notification storage
            //after fetch data from storage
            //and launch URl
            
        } else if([callName isEqualToString:XmwcsConst_CALL_NAME_FOR_LOGIN]) {
            [loadingView removeView];
            
            ClientLoginResponse* clientLoginResponse = (ClientLoginResponse*)respondedObject;
            
            if(![clientLoginResponse.userLoginStatus isEqualToString:@"0"])
            {
                if(![clientLoginResponse.passwrdState isEqualToString:@"1"]) {
                    ClientLoginResponse* clientLoginResponse =  (ClientLoginResponse*) respondedObject;
            
                    [LoginUtils setClientVariables :  clientLoginResponse : [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"]];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"LAST_AUTO_LOGGED_IN_TIME"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
        }
    
    else if ([callName isEqualToString:@"requestUserList"])
    {
        NSMutableArray * contactsList = [[NSMutableArray alloc]init];
        
        if ([[respondedObject objectForKey:@"status"] boolValue] == YES) {
            [contactsList addObjectsFromArray:[[respondedObject valueForKey:@"responseData"] valueForKey:@"contacts"]];
            
            [ContactList_DB createInstance : @"ContactList_DB_STORAGE" : true];
            ContactList_DB *contactListStorage = [ContactList_DB getInstance];
            [contactListStorage dropTable:@"ContactList_DB_STORAGE"];
            
            for(int i =0; i<[contactsList count];i++) //for unhidden contact  insert into db
            {
                ContactList_Object* contactList_Object = [[ContactList_Object alloc] init];
                contactList_Object.emailId = [[contactsList objectAtIndex:i] valueForKey:@"emailId"];
                contactList_Object.name =    [[contactsList objectAtIndex:i] valueForKey:@"name"];
                contactList_Object.userId =  [[contactsList objectAtIndex:i] valueForKey:@"userId"];
                contactList_Object.isHidden = 0;
                [contactListStorage insertDoc:contactList_Object];
            }
            
            contactsList = [[NSMutableArray alloc]init];
            [contactsList addObjectsFromArray:[[respondedObject valueForKey:@"responseData"] valueForKey:@"hiddenContacts"]];
            
            for(int i =0; i<[contactsList count];i++) //for hidden contact  insert into db
            {
                ContactList_Object* contactList_Object = [[ContactList_Object alloc] init];
                contactList_Object.emailId = [[contactsList objectAtIndex:i] valueForKey:@"emailId"];
                contactList_Object.name =    [[contactsList objectAtIndex:i] valueForKey:@"name"];
                contactList_Object.userId =  [[contactsList objectAtIndex:i] valueForKey:@"userId"];
                contactList_Object.isHidden = 1;
                [contactListStorage insertDoc:contactList_Object];
            }
            
            NSMutableArray *contactListStorageData = [contactListStorage getRecentDocumentsData : @"False"];
            contactsList = [[NSMutableArray alloc]init];
            [contactsList addObjectsFromArray:contactListStorageData];
            
        }
    }
    else if ([callName isEqualToString:@"chatThreadRequestData"])
    {
      NSMutableArray *  chatThreadDict = [[NSMutableArray alloc]init];
        if ([[respondedObject objectForKey:@"status"] boolValue] == YES) {
            
            [ContactList_DB createInstance : @"ContactList_DB_STORAGE" : true];
            ContactList_DB *contactListStorage = [ContactList_DB getInstance];
            
            
            
            chatThreadDict = [[NSMutableArray alloc]init];
            [chatThreadDict addObjectsFromArray:[[respondedObject valueForKey:@"responseData"] valueForKey:@"list"]];
            // [threadListTableView reloadData];
            [ChatThreadList_DB createInstance : @"ChatThread_DB_STORAGE" : true];
            ChatThreadList_DB *chatThreadListStorage = [ChatThreadList_DB getInstance];
            [chatThreadListStorage dropTable:@"ChatThread_DB_STORAGE"];
            for(int i =0; i<[chatThreadDict count];i++)
            {
                  NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
                
                NSString *ownUserId = [chatPersonUserID stringByAppendingString:@"@employee"];
                NSString *parseId= @"";// for get username from contact db
                if ([[[chatThreadDict objectAtIndex:i] valueForKey:@"fromUserId"] isEqualToString:ownUserId]) {
                    parseId =[[chatThreadDict objectAtIndex:i] valueForKey:@"toUserId"];
                }
                else{
                    parseId =[[chatThreadDict objectAtIndex:i] valueForKey:@"fromUserId"];
                }
                ContactList_Object *obj;
                NSArray *contactListStorageData = [contactListStorage getContactDisplayName:@"False" :parseId];
                if (contactListStorageData.count==0) {
                    obj = [[ContactList_Object alloc]init];
                }
                else{
                    obj = (ContactList_Object*) [contactListStorageData objectAtIndex:0];
                    
                }
                ChatThreadList_Object* chatThreadList_Object = [[ChatThreadList_Object alloc] init];
                chatThreadList_Object.chatThreadId =[[[chatThreadDict objectAtIndex:i] valueForKey:@"id"] integerValue] ;
                chatThreadList_Object.from =   [ NSString stringWithFormat:@"%@", [[chatThreadDict objectAtIndex:i] valueForKey:@"fromUserId"]];
                chatThreadList_Object.to =  [ NSString stringWithFormat:@"%@",[[chatThreadDict objectAtIndex:i] valueForKey:@"toUserId"]];
                chatThreadList_Object.subject =[ NSString stringWithFormat:@"%@",[[chatThreadDict objectAtIndex:i] valueForKey:@"subject"]];
                chatThreadList_Object.lastMessageOn =[ NSString stringWithFormat:@"%@",[[chatThreadDict objectAtIndex:i] valueForKey:@"lastMessageOn"]];
                chatThreadList_Object.status =[ NSString stringWithFormat:@"%@",[[chatThreadDict objectAtIndex:i] valueForKey:@"status"]];
                chatThreadList_Object.displayName = obj.userName;
                [chatThreadListStorage insertDoc:chatThreadList_Object];
                
            }
            NSMutableArray *chatThreadListStorageData = [chatThreadListStorage getRecentDocumentsData : @"False"];
            chatThreadDict = [[NSMutableArray alloc]init];
            [chatThreadDict addObjectsFromArray:chatThreadListStorageData];
        }
    }
        
    }
}


- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    
    [loadingView removeView];
}

- (void) httpInterruptHandler : (NSString*) callName : (NSString*) message {
    
    [loadingView removeView];
    
}

-(void)pushNotificationNetworkCall : (NSString *)launchUrlString
{
    dispatch_async(dispatch_get_main_queue(), ^{
        XmwNotificationWebViewController *notificationWebViewController = [[XmwNotificationWebViewController alloc]initWithNibName:@"XmwNotificationWebViewController" bundle:nil];
        notificationWebViewController.urlString = launchUrlString;
        [self.navController pushViewController:notificationWebViewController animated:YES];
    });
}

-(BOOL) isDownloadable:(NSString*) urlString
{
    BOOL retVal = NO;
    
    NSRange rangeVideoMp4 =  [urlString rangeOfString:@".mp4"];
    NSRange rangeImagePng =  [urlString rangeOfString:@".png"];
    NSRange rangeImageJpg =  [urlString rangeOfString:@".jpg"];
    if(rangeVideoMp4.length>0)
    {
        return YES;
    } else if(rangeImagePng.length>0) {
        return YES;
    } else if (rangeImageJpg.length>0) {
        return YES;
    } else {
        return NO;
    }
    return retVal;
}


// When the movie is done, release the controller.
-(void)myMovieFinishedCallback:(NSNotification*)aNotification {
    [self.navController dismissMoviePlayerViewControllerAnimated];
    MPMoviePlayerController* theMovie = [aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                            name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];
}

-(void) signedUsingUsername:(NSString*)username havingPassword:(NSString*)password
{
        ClientUserLogin* userLogin = [[ClientUserLogin alloc] init];
        
        if([username isEqualToString:XmwcsConst_DEMO_USER]) {
            userLogin.userName = XmwcsConst_DEMO_USER_MAPPED;
            // also set developer / qa server URLs here
            XmwcsConst_SERVICE_URL = XmwcsConst_SERVICE_URL_DEMO;
            XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT = XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT_DEMO;
            XmwcsConst_PRODUCT_TREE_SERVICE_URL = XmwcsConst_PRODUCT_TREE_SERVICE_URL_DEMO;
        } else {
            userLogin.userName = username;
            // also set production server URLs here.
            XmwcsConst_SERVICE_URL = XmwcsConst_SERVICE_URL_PROD;
            XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT = XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT_PROD;
            XmwcsConst_PRODUCT_TREE_SERVICE_URL = XmwcsConst_PRODUCT_TREE_SERVICE_URL_PROD;
        }
    
        userLogin.password = password;
        userLogin.deviceInfoMap = [[NSMutableDictionary alloc]init];
    
        //start for default auth, for bypassing device auth
        // NSString* uniqueID = @"000000000000000";
        // [userLogin.deviceInfoMap setObject:uniqueID forKey:XmwcsConst_IMEI];
        //close
    
        NSUUID* vendorId = [UIDevice currentDevice].identifierForVendor;
        
        // [userLogin.deviceInfoMap setObject:XmwcsConst_IMEI forKey:vendorId.UUIDString];
        [userLogin.deviceInfoMap setObject:vendorId.UUIDString forKey:XmwcsConst_IMEI];
        [userLogin.deviceInfoMap setObject:@"1" forKey:@"IS_NOT_IMEI"];
        
        [userLogin.deviceInfoMap setObject:@"IPhone" forKey:XmwcsConst_DEVICE_MODEL];
        [userLogin.deviceInfoMap setObject:@"DEVICE_DETAIL" forKey:XmwcsConst_DEVICE_DETAIL];
        
        userLogin.language = AppConst_LANGUAGE_DEFAULT;
        userLogin.moduleId = AppConst_MOBILET_ID_DEFAULT;
        
        loadingView = [LoadingView loadingViewInView:self.window];
        ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
        clientVariables.CLIENT_USER_LOGIN = userLogin;
        
        
        networkHelper = [[NetworkHelper alloc] init];
        [networkHelper resetDeviceSessionId];
        [networkHelper makeXmwNetworkCall:userLogin :self : vendorId.UUIDString :XmwcsConst_CALL_NAME_FOR_LOGIN];
    
}




#pragma  - mark UNUserNotificationCenter methods
//Called when a notification is delivered to a foreground app.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    NSLog(@"User Info : %@",notification.request.content.userInfo);
    NSDictionary *mainDict = nil;
    
    // polycab notification code
    NSObject* contentMsg = [notification.request.content.userInfo objectForKey:@"CONTENT_MSG"];
    if(contentMsg!=nil) {
        if([contentMsg isKindOfClass:[NSString class]]) {
            NSString* jsonStr = (NSString*) contentMsg;
            NSData *webData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            mainDict = [NSJSONSerialization JSONObjectWithData:webData options:0 error:&error];
        } else if([contentMsg isKindOfClass:[NSDictionary class]]) {
            mainDict = (NSDictionary*) contentMsg;
        }
    }
    
    NSMutableDictionary *responsedict2 = [[NSMutableDictionary alloc]init];
    [responsedict2 setDictionary:[mainDict objectForKey:@"NOTIFY_MESSAGE_KEY"]];
    
    UIViewController *root;
    root = [[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController];
    if ([root isKindOfClass:[UINavigationController class]]) {// this condition for check reveal view controller is already configured or not
        
    }
    else if ([[mainDict objectForKey:@"OPERATION"] isEqualToString:@"8"] ) {
        [self handlePushChatMessageFromPresent:mainDict];
    }

 //   completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}

//Called to let your app know which action was selected by the user for a given notification.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)()) completionHandler {
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"launchOptions"] isEqualToString:@"YES"]) { // this check for check application launch option
        // do nothing
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"launchOptions"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSDictionary *mainDict = nil;
        
        // polycab notification code
        NSObject* contentMsg = [response.notification.request.content.userInfo objectForKey:@"CONTENT_MSG"];
        if(contentMsg!=nil) {
            if([contentMsg isKindOfClass:[NSString class]]) {
                NSString* jsonStr = (NSString*) contentMsg;
                NSData *webData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
                NSError *error;
                mainDict = [NSJSONSerialization JSONObjectWithData:webData options:0 error:&error];
            } else if([contentMsg isKindOfClass:[NSDictionary class]]) {
                mainDict = (NSDictionary*) contentMsg;
            }
        }
        
        if ([[mainDict objectForKey:@"OPERATION"] isEqualToString:@"8"] ) {
            [self handlePushChatMessageFromRecieve:mainDict];
        }
    }
    
    completionHandler();
}

-(NSMutableArray*)groupData :(NSArray*)dataArray
{
    NSMutableArray* distinctName = [[NSMutableArray alloc]init];
    for (int i=0; i<dataArray.count; i++) {
        ChatThreadList_Object* obj = (ChatThreadList_Object*) [dataArray objectAtIndex:i];
        
        if (![distinctName  containsObject:obj.displayName]) {
            [distinctName addObject:obj.displayName];
        }
    }
    
    NSMutableArray* groupObject = [[NSMutableArray alloc]init];
    for (int i=0; i<distinctName.count; i++) {
        NSMutableArray* array = [[NSMutableArray alloc]init];
        ExpendObjectClass* expendObj = [[ExpendObjectClass alloc]init];
        for (int j=0; j<dataArray.count; j++) {
            ChatThreadList_Object* obj = (ChatThreadList_Object*) [dataArray objectAtIndex:j];
            if ([obj.displayName isEqualToString:[distinctName objectAtIndex:i]] ) {
                [array addObject:obj];
            }
        }
        expendObj.MENU_NAME =[distinctName objectAtIndex:i];
        expendObj.childCategories = array;
        [groupObject addObject:expendObj];
    }
    return groupObject;
}


#pragma mark - Update UIViewControllers Array
-(void)updateUIViewControllersArray
{

    UIViewController *root;
    root = [[[[UIApplication sharedApplication]windows]objectAtIndex:0]rootViewController];
    SWRevealViewController *reveal = (SWRevealViewController*)root;
    UINavigationController *check =(UINavigationController*)reveal.frontViewController;
    NSArray* viewsList = check.viewControllers;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[viewsList objectAtIndex:0]];
    [check setViewControllers:array];
    [reveal setFrontViewController:check];
}
#pragma mark - PushChatMessage Handlers

-(void) handlePushChatMessageFromRecieve:(NSDictionary*) mainDict
{
        if ([[mainDict objectForKey:@"NOTIFY_CALLNAME"] isEqualToString:@"NEW_MESSAGE"]) {
            
            ChatRoomPushNotifiactionFlag = YES;
            
            [self handlePushChatNewMessage:mainDict];
            
        } else if ([[mainDict valueForKey:@"NOTIFY_CALLNAME"] isEqualToString:@"NEW_THREAD"]) {
            ChatBoxPushNotifiactionFlag = YES;
            
            [self handlePushChatNewThread:mainDict];
            
        } else if ([[mainDict valueForKey:@"NOTIFY_CALLNAME"] isEqualToString:@"CHAT_THREAD_STATUS_UPDATE"]) {
            ChatBoxPushNotifiactionFlag = YES;
            [self handlePushChatNewThreadStatusUpdate:mainDict];
        
        }
    
}


-(void) handlePushChatMessageFromPresent:(NSDictionary*) mainDict
{
    if ([[mainDict objectForKey:@"NOTIFY_CALLNAME"] isEqualToString:@"NEW_MESSAGE"]) {
        
        [self handlePushChatNewMessageWillPresent:mainDict];
        
    } else if ([[mainDict valueForKey:@"NOTIFY_CALLNAME"] isEqualToString:@"NEW_THREAD"]) {
        
        [self handlePushChatNewThreadWillPresent:mainDict];
        
    } else if ([[mainDict valueForKey:@"NOTIFY_CALLNAME"] isEqualToString:@"CHAT_THREAD_STATUS_UPDATE"]) {
        
        [self handlePushChatNewThreadStatusUpdateWillPresent:mainDict];
        
    }
    
}
-(void)handlePushChatNewMessageWillPresent:(NSDictionary*) mainDict
{
    NSMutableDictionary *responsedict = [[NSMutableDictionary alloc] init];
    [responsedict setDictionary:[mainDict objectForKey:@"NOTIFY_MESSAGE_KEY"]];
    [ChatHistory_DB createInstance : @"ChatHistory_DB_STORAGE" : true :[[responsedict valueForKey:@"chatThread"] integerValue]];
    ChatHistory_DB *chatHistory_DBStorage = [ChatHistory_DB getInstance];
    NSMutableArray *chatHistoryStorageData = [chatHistory_DBStorage getRecentDocumentsData : @"False"];
    
    UIViewController* root = [[[[UIApplication sharedApplication]windows]objectAtIndex:0] rootViewController];
    SWRevealViewController *reveal = (SWRevealViewController*)root;
    UINavigationController *check =(UINavigationController*)reveal.frontViewController;
    NSArray* viewsList = check.viewControllers;
    UIViewController *checkView = (UIViewController *) [viewsList objectAtIndex:viewsList.count - 1];
    
    if ([checkView isKindOfClass:[DashBoardVC class]]) {
        // work in progress
        DashBoardVC *vc = (DashBoardVC*) checkView;
        [vc viewWillAppear:false];
        
        NSInteger threadId = [[responsedict valueForKey:@"chatThread"] integerValue];
        
        
        UINavigationController *check =(UINavigationController*)reveal.frontViewController;
        NSArray* viewsList = check.viewControllers;
        UIViewController *current = (UIViewController *) [viewsList objectAtIndex:0];
        
        UIBarButtonItem *item = (UIBarButtonItem*) [current.navigationItem.rightBarButtonItems objectAtIndex:1];
        
        UIButton *chatButton = (UIButton *) item.customView;
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake( 15.0f, -5.0f, 10.0f, 10.0f)];
        view.tag = 10000000;
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 5;
        CALayer *myLayer = view.layer;
        
        [chatButton.layer addSublayer:myLayer];
        
        
    } else if ([checkView isKindOfClass:[ChatRoomsVC class]]) {
        ChatRoomsVC *vc = (ChatRoomsVC*) checkView;
        if ([vc.chatThreadId integerValue]==[[responsedict valueForKey:@"chatThread"] integerValue]) { // check for same chatthread ID
            vc.chatHistoryArray = [[NSMutableArray alloc]init];
            [vc.chatHistoryArray addObjectsFromArray:chatHistoryStorageData];
            //                    vc.popupTextView.text = @"";
            [vc.chatRoomTableView reloadData];
            [vc.chatRoomTableView layoutIfNeeded];
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow: ([vc.chatRoomTableView numberOfRowsInSection:([vc.chatRoomTableView numberOfSections]-1)]-1) inSection: ([vc.chatRoomTableView numberOfSections]-1)];
            [vc.chatRoomTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            [vc unreadMessageNetworkCall];
        } else {
            [ChatThreadList_DB createInstance : @"ChatThread_DB_STORAGE" : true];
            ChatThreadList_DB *chatThreadListStorage = [ChatThreadList_DB getInstance];
            NSMutableArray *chatThreadListStorageData = [chatThreadListStorage getRecentDocumentsData : @"False"];
            UIViewController *checkView = (UIViewController *) [viewsList objectAtIndex:viewsList.count - 2];
            ChatBoxVC *vc =  (ChatBoxVC*) checkView;
            vc.chatThreadDict = [self groupData:chatThreadListStorageData];
            [vc.threadListTableView reloadData];
            
        }
    } else  if ([checkView isKindOfClass:[ChatBoxVC class]]) {
        
        [ChatThreadList_DB createInstance : @"ChatThread_DB_STORAGE" : true];
        ChatThreadList_DB *chatThreadListStorage = [ChatThreadList_DB getInstance];
        NSMutableArray *chatThreadListStorageData = [chatThreadListStorage getRecentDocumentsData : @"False"];
        ChatBoxVC *vc =  (ChatBoxVC*) checkView;
        vc.chatThreadDict = [self groupData:chatThreadListStorageData];
        [vc.threadListTableView reloadData];
        ExpendObjectClass *obj = (ExpendObjectClass *) [vc.chatThreadDict objectAtIndex:0];
        ChatThreadList_Object *obj2 = (ChatThreadList_Object *)[obj.childCategories objectAtIndex:0];
        
        NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];

        NSString *ownUserId = chatPersonUserID;
        NSString *parseId= @"";// for get username from contact db
        NSArray *array = [obj2.from componentsSeparatedByString:@"@"];
        if ([[array objectAtIndex:0] isEqualToString:ownUserId]) {
            parseId =obj2.to;
        }
        else{
            parseId =obj2.from;
        }
        NSArray *array2 = [parseId componentsSeparatedByString:@"@"];//// for accept button check.
        if ([[array2 objectAtIndex:1] isEqualToString:@"employee"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"Accept_Chat_Button"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"Accept_Chat_Button"];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        // ChatThreadList_Object *obj = (ChatThreadList_Object *)[chatThreadDict objectAtIndex:indexPath.row];
        if(ChatBoxPushNotifiactionFlag == YES || ChatRoomPushNotifiactionFlag == YES) {
            ChatRoomsVC *vc2 = [[ChatRoomsVC alloc] init];
            NSString*objString = obj2.subject;
            //  Base64 string to original string
            NSData *base64Data = [[NSData alloc] initWithBase64EncodedString:objString options:NSDataBase64DecodingIgnoreUnknownCharacters];
            NSString *originalString =[[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
            vc2.subject =originalString;
            vc2.withChatPersonName = parseId;
            vc2.chatThreadId =[NSString stringWithFormat:@"%d",obj2.chatThreadId];
            vc2.chatStatus = obj2.status;
            vc2.nameLbltext = obj2.displayName;
            vc2.chatThreadObj = obj2;
            [[checkView navigationController ] pushViewController:vc2 animated:YES];
        }
        
    } else {
        if ( ChatRoomPushNotifiactionFlag == YES)
        {
            [self updateUIViewControllersArray];
        }
        else
        {
            UIViewController *root;
            root = [[[[UIApplication sharedApplication]windows]objectAtIndex:0]rootViewController];
            SWRevealViewController *reveal = (SWRevealViewController*)root;
            UINavigationController *check =(UINavigationController*)reveal.frontViewController;
            NSArray* viewsList = check.viewControllers;
            UIViewController *current = (UIViewController *) [viewsList objectAtIndex:0];
            
            UIBarButtonItem *item = (UIBarButtonItem*) [current.navigationItem.rightBarButtonItems objectAtIndex:1];
            
            UIButton *chatButton = (UIButton *) item.customView;
            //  [[chatButton.layer.sublayers objectAtIndex:1] removeFromSuperlayer];
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake( 15.0f, -5.0f, 10.0f, 10.0f)];
            view.tag = 10000000;
            view.backgroundColor = [UIColor whiteColor];
            view.layer.cornerRadius = 5;
            CALayer *myLayer = view.layer;
            
            [chatButton.layer addSublayer:myLayer];
        }
    }
}

-(void) handlePushChatNewMessage:(NSDictionary*) mainDict
{
    NSMutableDictionary *responsedict = [[NSMutableDictionary alloc] init];
    [responsedict setDictionary:[mainDict objectForKey:@"NOTIFY_MESSAGE_KEY"]];
    ChatHistory_Object* chatHistory_Object = [[ChatHistory_Object alloc] init];
    chatHistory_Object.chatThreadId =  [[responsedict valueForKey:@"chatThread"] integerValue] ;
    puchNotifiactionChatHistory_Object = chatHistory_Object;
    
    
    [ChatHistory_DB createInstance : @"ChatHistory_DB_STORAGE" : true :[[responsedict valueForKey:@"chatThread"] integerValue]];
    ChatHistory_DB *chatHistory_DBStorage = [ChatHistory_DB getInstance];
    NSMutableArray *chatHistoryStorageData = [chatHistory_DBStorage getRecentDocumentsData : @"False"];
    
    UIViewController* root = [[[[UIApplication sharedApplication]windows]objectAtIndex:0] rootViewController];
    SWRevealViewController *reveal = (SWRevealViewController*)root;
    UINavigationController *check =(UINavigationController*)reveal.frontViewController;
    NSArray* viewsList = check.viewControllers;
    UIViewController *checkView = (UIViewController *) [viewsList objectAtIndex:viewsList.count - 1];
    
    if ([checkView isKindOfClass:[DashBoardVC class]]) {
        // work in progress
        DashBoardVC *vc = (DashBoardVC*) checkView;
        [vc viewWillAppear:false];
        
        NSInteger threadId = [[responsedict valueForKey:@"chatThread"] integerValue];


        UINavigationController *check =(UINavigationController*)reveal.frontViewController;
        NSArray* viewsList = check.viewControllers;
        UIViewController *current = (UIViewController *) [viewsList objectAtIndex:0];

        UIBarButtonItem *item = (UIBarButtonItem*) [current.navigationItem.rightBarButtonItems objectAtIndex:1];

        UIButton *chatButton = (UIButton *) item.customView;

        UIView *view = [[UIView alloc]initWithFrame:CGRectMake( 15.0f, -5.0f, 10.0f, 10.0f)];
        view.tag = 10000000;
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 5;
        CALayer *myLayer = view.layer;

        [chatButton.layer addSublayer:myLayer];

        
    } else if ([checkView isKindOfClass:[ChatRoomsVC class]]) {
        ChatRoomsVC *vc = (ChatRoomsVC*) checkView;
        if ([vc.chatThreadId integerValue]==[[responsedict valueForKey:@"chatThread"] integerValue]) { // check for same chatthread ID
            vc.chatHistoryArray = [[NSMutableArray alloc]init];
            [vc.chatHistoryArray addObjectsFromArray:chatHistoryStorageData];
            //                    vc.popupTextView.text = @"";
            [vc.chatRoomTableView reloadData];
            [vc.chatRoomTableView layoutIfNeeded];
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow: ([vc.chatRoomTableView numberOfRowsInSection:([vc.chatRoomTableView numberOfSections]-1)]-1) inSection: ([vc.chatRoomTableView numberOfSections]-1)];
            [vc.chatRoomTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            [vc unreadMessageNetworkCall];
        } else {
            [ChatThreadList_DB createInstance : @"ChatThread_DB_STORAGE" : true];
            ChatThreadList_DB *chatThreadListStorage = [ChatThreadList_DB getInstance];
            NSMutableArray *chatThreadListStorageData = [chatThreadListStorage getRecentDocumentsData : @"False"];
            UIViewController *checkView = (UIViewController *) [viewsList objectAtIndex:viewsList.count - 2];
            ChatBoxVC *vc =  (ChatBoxVC*) checkView;
            vc.chatThreadDict = [self groupData:chatThreadListStorageData];
            [vc.threadListTableView reloadData];
            NSMutableArray *viewControllersArray = [NSMutableArray arrayWithArray:checkView.navigationController.viewControllers];
            NSMutableArray *dummyViewControllers= [[NSMutableArray alloc]init];
            [dummyViewControllers addObjectsFromArray:viewControllersArray];
            [dummyViewControllers removeObjectAtIndex:dummyViewControllers.count -1];
            [checkView.navigationController setViewControllers:dummyViewControllers animated:YES];
            
        }
    } else  if ([checkView isKindOfClass:[ChatBoxVC class]]) {
        
        [ChatThreadList_DB createInstance : @"ChatThread_DB_STORAGE" : true];
        ChatThreadList_DB *chatThreadListStorage = [ChatThreadList_DB getInstance];
        NSMutableArray *chatThreadListStorageData = [chatThreadListStorage getRecentDocumentsData : @"False"];
        ChatBoxVC *vc =  (ChatBoxVC*) checkView;
        vc.chatThreadDict = [self groupData:chatThreadListStorageData];
        [vc.threadListTableView reloadData];
        ExpendObjectClass *obj = (ExpendObjectClass *) [vc.chatThreadDict objectAtIndex:0];
        ChatThreadList_Object *obj2 = (ChatThreadList_Object *)[obj.childCategories objectAtIndex:0];
        
        NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
        
        NSString *ownUserId = chatPersonUserID;
        NSString *parseId= @"";// for get username from contact db
        NSArray *array = [obj2.from componentsSeparatedByString:@"@"];
        if ([[array objectAtIndex:0] isEqualToString:ownUserId]) {
            parseId =obj2.to;
        }
        else{
            parseId =obj2.from;
        }
        NSArray *array2 = [parseId componentsSeparatedByString:@"@"];//// for accept button check.
        if ([[array2 objectAtIndex:1] isEqualToString:@"employee"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"Accept_Chat_Button"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"Accept_Chat_Button"];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        // ChatThreadList_Object *obj = (ChatThreadList_Object *)[chatThreadDict objectAtIndex:indexPath.row];
        if(ChatBoxPushNotifiactionFlag == YES || ChatRoomPushNotifiactionFlag == YES) {
            ChatRoomsVC *vc2 = [[ChatRoomsVC alloc] init];
            NSString*objString = obj2.subject;
            //  Base64 string to original string
            NSData *base64Data = [[NSData alloc] initWithBase64EncodedString:objString options:NSDataBase64DecodingIgnoreUnknownCharacters];
            NSString *originalString =[[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
            vc2.subject =originalString;
            vc2.withChatPersonName = parseId;
            vc2.chatThreadId =[NSString stringWithFormat:@"%d",obj2.chatThreadId];
            vc2.chatStatus = obj2.status;
            vc2.nameLbltext = obj2.displayName;
            vc2.chatThreadObj = obj2;
            [[checkView navigationController ] pushViewController:vc2 animated:YES];
        }
        
    } else {
        if ( ChatRoomPushNotifiactionFlag == YES)
        {
            [self updateUIViewControllersArray];
        }
        else
        {
        UIViewController *root;
        root = [[[[UIApplication sharedApplication]windows]objectAtIndex:0]rootViewController];
        SWRevealViewController *reveal = (SWRevealViewController*)root;
        UINavigationController *check =(UINavigationController*)reveal.frontViewController;
        NSArray* viewsList = check.viewControllers;
        UIViewController *current = (UIViewController *) [viewsList objectAtIndex:0];
        
        UIBarButtonItem *item = (UIBarButtonItem*) [current.navigationItem.rightBarButtonItems objectAtIndex:1];
        
        UIButton *chatButton = (UIButton *) item.customView;
        //  [[chatButton.layer.sublayers objectAtIndex:1] removeFromSuperlayer];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake( 15.0f, -5.0f, 10.0f, 10.0f)];
        view.tag = 10000000;
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 5;
        CALayer *myLayer = view.layer;
        
        [chatButton.layer addSublayer:myLayer];
    }
    }
}

-(void)handlePushChatNewThreadWillPresent:(NSDictionary*) mainDict
{
    
    NSMutableDictionary *responsedict = [[NSMutableDictionary alloc]init];
    [responsedict setDictionary:[mainDict objectForKey:@"NOTIFY_MESSAGE_KEY"]];
    [ChatThreadList_DB createInstance : @"ChatThread_DB_STORAGE" : true];
    ChatThreadList_DB *chatThreadListStorage = [ChatThreadList_DB getInstance];
    NSMutableArray *chatThreadListStorageData = [chatThreadListStorage getRecentDocumentsData : @"False"];
    UIViewController *root;
    root = [[[[UIApplication sharedApplication]windows]objectAtIndex:0]rootViewController];
    SWRevealViewController *reveal = (SWRevealViewController*)root;
    UINavigationController *check =(UINavigationController*)reveal.frontViewController;
    NSArray* viewsList = check.viewControllers;
    UIViewController *checkView = (UIViewController *) [viewsList objectAtIndex:viewsList.count - 1];
    
    if ([checkView isKindOfClass:[ChatBoxVC class]]) {
        // do this
        ChatBoxVC *vc = (ChatBoxVC*) checkView;
        vc.chatThreadDict = [[NSMutableArray alloc]init];
        [vc.chatThreadDict addObjectsFromArray:[self groupData:chatThreadListStorageData]];
        [vc.threadListTableView reloadData];
        
    } else {
        // do nothing
        if ([checkView isKindOfClass:[ChatRoomsVC class]]) {
            UIViewController *checkView = (UIViewController *) [viewsList objectAtIndex:viewsList.count - 2];
            ChatBoxVC *vc = (ChatBoxVC*) checkView;
            vc.chatThreadDict = [[NSMutableArray alloc]init];
            [vc.chatThreadDict addObjectsFromArray:[self groupData:chatThreadListStorageData]];
            [vc.threadListTableView reloadData];
        }
        
        if ( ChatBoxPushNotifiactionFlag == YES)
        {
            [self updateUIViewControllersArray];
        }
        
        
        
        UIViewController *root;
        root = [[[[UIApplication sharedApplication]windows]objectAtIndex:0]rootViewController];
        SWRevealViewController *reveal = (SWRevealViewController*)root;
        UINavigationController *check =(UINavigationController*)reveal.frontViewController;
        NSArray* viewsList = check.viewControllers;
        UIViewController *current = (UIViewController *) [viewsList objectAtIndex:0];
        
        UIBarButtonItem *item = (UIBarButtonItem*) [current.navigationItem.rightBarButtonItems objectAtIndex:1];
        
        UIButton *chatButton = (UIButton *) item.customView;
        //  [[chatButton.layer.sublayers objectAtIndex:1] removeFromSuperlayer];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake( 15.0f, -5.0f, 10.0f, 10.0f)];
        view.tag = 10000000;
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 5;
        CALayer *myLayer = view.layer;
        
        [chatButton.layer addSublayer:myLayer];
        
    }
    
}
-(void) handlePushChatNewThread:(NSDictionary*) mainDict
{
    
    NSMutableDictionary *responsedict = [[NSMutableDictionary alloc]init];
    [responsedict setDictionary:[mainDict objectForKey:@"NOTIFY_MESSAGE_KEY"]];
    
    ChatThreadList_Object* chatThreadList_Object = [[ChatThreadList_Object alloc] init];
    chatThreadList_Object.chatThreadId = [[[responsedict valueForKey:@"message"] valueForKey:@"chatThread"] integerValue];
    puchNotifiactionChatThreadList_Object= chatThreadList_Object;
    
    [ChatThreadList_DB createInstance : @"ChatThread_DB_STORAGE" : true];
    ChatThreadList_DB *chatThreadListStorage = [ChatThreadList_DB getInstance];
    NSMutableArray *chatThreadListStorageData = [chatThreadListStorage getRecentDocumentsData : @"False"];
    UIViewController *root;
    root = [[[[UIApplication sharedApplication]windows]objectAtIndex:0]rootViewController];
    SWRevealViewController *reveal = (SWRevealViewController*)root;
    UINavigationController *check =(UINavigationController*)reveal.frontViewController;
    NSArray* viewsList = check.viewControllers;
    UIViewController *checkView = (UIViewController *) [viewsList objectAtIndex:viewsList.count - 1];
    
    
    if ([checkView isKindOfClass:[DashBoardVC class]]) {
        // work in progress
        DashBoardVC *vc = (DashBoardVC*) checkView;
        [vc viewWillAppear:false];
        
        UINavigationController *check =(UINavigationController*)reveal.frontViewController;
        NSArray* viewsList = check.viewControllers;
        UIViewController *current = (UIViewController *) [viewsList objectAtIndex:0];

        UIBarButtonItem *item = (UIBarButtonItem*) [current.navigationItem.rightBarButtonItems objectAtIndex:1];

        UIButton *chatButton = (UIButton *) item.customView;

        UIView *view = [[UIView alloc]initWithFrame:CGRectMake( 15.0f, -5.0f, 10.0f, 10.0f)];
        view.tag = 10000000;
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 5;
        CALayer *myLayer = view.layer;

        [chatButton.layer addSublayer:myLayer];
        
        
    }
    
    
   else if ([checkView isKindOfClass:[ChatBoxVC class]]) {
        // do this
        ChatBoxVC *vc = (ChatBoxVC*) checkView;
        vc.chatThreadDict = [[NSMutableArray alloc]init];
        [vc.chatThreadDict addObjectsFromArray:[self groupData:chatThreadListStorageData]];
        [vc.threadListTableView reloadData];
        ExpendObjectClass *obj = (ExpendObjectClass *) [vc.chatThreadDict objectAtIndex:0];
        ChatThreadList_Object *obj2 = (ChatThreadList_Object *)[obj.childCategories objectAtIndex:0];
    
       
       NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];

       
        NSString *ownUserId = chatPersonUserID;
        NSString *parseId= @"";// for get username from contact db
        NSArray *array = [obj2.from componentsSeparatedByString:@"@"];
        if ([[array objectAtIndex:0] isEqualToString:ownUserId]) {
            parseId =obj2.to;
        }
        else{
            parseId =obj2.from;
        }
        NSArray *array2 = [parseId componentsSeparatedByString:@"@"];//// for accept button check.
        if ([[array2 objectAtIndex:1] isEqualToString:@"employee"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"Accept_Chat_Button"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"Accept_Chat_Button"];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        // ChatThreadList_Object *obj = (ChatThreadList_Object *)[chatThreadDict objectAtIndex:indexPath.row];
        ChatRoomsVC *vc2 = [[ChatRoomsVC alloc]init];
        NSString*objString = obj2.subject;
        //  Base64 string to original string
        NSData *base64Data = [[NSData alloc] initWithBase64EncodedString:objString options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSString *originalString =[[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
        vc2.subject =originalString;
        vc2.withChatPersonName = parseId;
        vc2.chatThreadId =[NSString stringWithFormat:@"%d",obj2.chatThreadId];
        vc2.chatStatus = obj2.status;
        vc2.nameLbltext = obj2.displayName;
       vc2.chatThreadObj = obj2;
        [[checkView navigationController ] pushViewController:vc2 animated:YES];
        
    } else {
        // do nothing
        if ([checkView isKindOfClass:[ChatRoomsVC class]]) {
            UIViewController *checkView = (UIViewController *) [viewsList objectAtIndex:viewsList.count - 2];
            ChatBoxVC *vc = (ChatBoxVC*) checkView;
            vc.chatThreadDict = [[NSMutableArray alloc]init];
            [vc.chatThreadDict addObjectsFromArray:[self groupData:chatThreadListStorageData]];
            [vc.threadListTableView reloadData];
        }
        
        if ( ChatBoxPushNotifiactionFlag == YES)
        {
            [self updateUIViewControllersArray];
        }
        
        UIViewController *root;
        root = [[[[UIApplication sharedApplication]windows]objectAtIndex:0]rootViewController];
        SWRevealViewController *reveal = (SWRevealViewController*)root;
        UINavigationController *check =(UINavigationController*)reveal.frontViewController;
        NSArray* viewsList = check.viewControllers;
        UIViewController *current = (UIViewController *) [viewsList objectAtIndex:0];

        UIBarButtonItem *item = (UIBarButtonItem*) [current.navigationItem.rightBarButtonItems objectAtIndex:1];

        UIButton *chatButton = (UIButton *) item.customView;
        //  [[chatButton.layer.sublayers objectAtIndex:1] removeFromSuperlayer];

        UIView *view = [[UIView alloc]initWithFrame:CGRectMake( 15.0f, -5.0f, 10.0f, 10.0f)];
        view.tag = 10000000;
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 5;
        CALayer *myLayer = view.layer;

        [chatButton.layer addSublayer:myLayer];

    }
    
}
-(void)handlePushChatNewThreadStatusUpdateWillPresent:(NSDictionary*) mainDict
{
    NSMutableDictionary *responsedict = [[NSMutableDictionary alloc]init];
    [responsedict setDictionary:[mainDict objectForKey:@"NOTIFY_MESSAGE_KEY"]];
    
    [ChatThreadList_DB createInstance : @"ChatThread_DB_STORAGE" : true];
    ChatThreadList_DB *chatThreadListStorage = [ChatThreadList_DB getInstance];
    
    NSMutableArray *chatThreadListStorageData = [chatThreadListStorage getRecentDocumentsData : @"False"];
    
    UIViewController *root;
    root = [[[[UIApplication sharedApplication]windows]objectAtIndex:0]rootViewController];
    SWRevealViewController *reveal = (SWRevealViewController*)root;
    UINavigationController *check =(UINavigationController*)reveal.frontViewController;
    NSArray* viewsList = check.viewControllers;
    UIViewController *checkView = (UIViewController *) [viewsList objectAtIndex:viewsList.count - 1];
    
    if ([checkView isKindOfClass:[ChatBoxVC class]]) {
        // do this
        ChatBoxVC *vc = (ChatBoxVC*) checkView;
        vc.chatThreadDict = [[NSMutableArray alloc]init];
        [vc.chatThreadDict addObjectsFromArray:[self groupData:chatThreadListStorageData]];
        [vc.threadListTableView reloadData];
        
    }
    else if ([checkView isKindOfClass:[ChatRoomsVC class]])
    {
        ChatRoomsVC *vc = (ChatRoomsVC*) checkView;
        if ([vc.chatThreadId integerValue]== [[responsedict valueForKey:@"chatThreadId"] integerValue]) {
            //                    [vc.bottomView removeFromSuperview];
        }
    } else {
        // do nothing
        if ( ChatBoxPushNotifiactionFlag == YES)
        {
            [self updateUIViewControllersArray];
        }
        else
        {
            
            
            UIViewController *root;
            root = [[[[UIApplication sharedApplication]windows]objectAtIndex:0]rootViewController];
            SWRevealViewController *reveal = (SWRevealViewController*)root;
            UINavigationController *check =(UINavigationController*)reveal.frontViewController;
            NSArray* viewsList = check.viewControllers;
            UIViewController *current = (UIViewController *) [viewsList objectAtIndex:0];
            
            UIBarButtonItem *item = (UIBarButtonItem*) [current.navigationItem.rightBarButtonItems objectAtIndex:1];
            
            UIButton *chatButton = (UIButton *) item.customView;
            //  [[chatButton.layer.sublayers objectAtIndex:1] removeFromSuperlayer];
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake( 15.0f, -5.0f, 10.0f, 10.0f)];
            view.tag = 10000000;
            view.backgroundColor = [UIColor whiteColor];
            view.layer.cornerRadius = 5;
            CALayer *myLayer = view.layer;
            
            [chatButton.layer addSublayer:myLayer];
        }
    }
}
-(void) handlePushChatNewThreadStatusUpdate:(NSDictionary*) mainDict
{
        NSMutableDictionary *responsedict = [[NSMutableDictionary alloc]init];
        [responsedict setDictionary:[mainDict objectForKey:@"NOTIFY_MESSAGE_KEY"]];
    ChatThreadList_Object* chatThreadList_Object = [[ChatThreadList_Object alloc] init];
    chatThreadList_Object.chatThreadId = [[responsedict valueForKey:@"chatThreadId"]  integerValue];
    puchNotifiactionChatThreadList_Object= chatThreadList_Object;
        [ChatThreadList_DB createInstance : @"ChatThread_DB_STORAGE" : true];
        ChatThreadList_DB *chatThreadListStorage = [ChatThreadList_DB getInstance];
        
        NSMutableArray *chatThreadListStorageData = [chatThreadListStorage getRecentDocumentsData : @"False"];
        
        UIViewController *root;
        root = [[[[UIApplication sharedApplication]windows]objectAtIndex:0]rootViewController];
        SWRevealViewController *reveal = (SWRevealViewController*)root;
        UINavigationController *check =(UINavigationController*)reveal.frontViewController;
        NSArray* viewsList = check.viewControllers;
        UIViewController *checkView = (UIViewController *) [viewsList objectAtIndex:viewsList.count - 1];
    
    if ([checkView isKindOfClass:[DashBoardVC class]]) {
        // work in progress
        DashBoardVC *vc = (DashBoardVC*) checkView;
        [vc viewWillAppear:false];
        
        UINavigationController *check =(UINavigationController*)reveal.frontViewController;
        NSArray* viewsList = check.viewControllers;
        UIViewController *current = (UIViewController *) [viewsList objectAtIndex:0];
        
        UIBarButtonItem *item = (UIBarButtonItem*) [current.navigationItem.rightBarButtonItems objectAtIndex:1];
        
        UIButton *chatButton = (UIButton *) item.customView;
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake( 15.0f, -5.0f, 10.0f, 10.0f)];
        view.tag = 10000000;
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 5;
        CALayer *myLayer = view.layer;
        
        [chatButton.layer addSublayer:myLayer];
        
        
    } else if ([checkView isKindOfClass:[ChatBoxVC class]]) {
            // do this
            ChatBoxVC *vc = (ChatBoxVC*) checkView;
            vc.chatThreadDict = [[NSMutableArray alloc]init];
            [vc.chatThreadDict addObjectsFromArray:[self groupData:chatThreadListStorageData]];
            [vc.threadListTableView reloadData];
            [vc viewWillAppear:false];
            
        }
        else if ([checkView isKindOfClass:[ChatRoomsVC class]])
        {
            ChatRoomsVC *vc = (ChatRoomsVC*) checkView;
            if ([vc.chatThreadId integerValue]== [[responsedict valueForKey:@"chatThreadId"] integerValue]) {
                //                    [vc.bottomView removeFromSuperview];
            }
            else
            {
                [ChatThreadList_DB createInstance : @"ChatThread_DB_STORAGE" : true];
                ChatThreadList_DB *chatThreadListStorage = [ChatThreadList_DB getInstance];
                NSMutableArray *chatThreadListStorageData = [chatThreadListStorage getRecentDocumentsData : @"False"];
                UIViewController *checkView = (UIViewController *) [viewsList objectAtIndex:viewsList.count - 2];
                ChatBoxVC *vc =  (ChatBoxVC*) checkView;
                vc.chatThreadDict = [self groupData:chatThreadListStorageData];
                [vc.threadListTableView reloadData];
                NSMutableArray *viewControllersArray = [NSMutableArray arrayWithArray:checkView.navigationController.viewControllers];
                NSMutableArray *dummyViewControllers= [[NSMutableArray alloc]init];
                [dummyViewControllers addObjectsFromArray:viewControllersArray];
                [dummyViewControllers removeObjectAtIndex:dummyViewControllers.count -1];
                [checkView.navigationController setViewControllers:dummyViewControllers animated:YES];
            }
            
        }
    
        else {
            // do nothing
            if ( ChatBoxPushNotifiactionFlag == YES)
            {
                [self updateUIViewControllersArray];
            }
            else
            {
            
            
            UIViewController *root;
            root = [[[[UIApplication sharedApplication]windows]objectAtIndex:0]rootViewController];
            SWRevealViewController *reveal = (SWRevealViewController*)root;
            UINavigationController *check =(UINavigationController*)reveal.frontViewController;
            NSArray* viewsList = check.viewControllers;
            UIViewController *current = (UIViewController *) [viewsList objectAtIndex:0];
            
            UIBarButtonItem *item = (UIBarButtonItem*) [current.navigationItem.rightBarButtonItems objectAtIndex:1];
            
            UIButton *chatButton = (UIButton *) item.customView;
            //  [[chatButton.layer.sublayers objectAtIndex:1] removeFromSuperlayer];
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake( 15.0f, -5.0f, 10.0f, 10.0f)];
            view.tag = 10000000;
            view.backgroundColor = [UIColor whiteColor];
            view.layer.cornerRadius = 5;
            CALayer *myLayer = view.layer;
            
            [chatButton.layer addSublayer:myLayer];
        }
        }
}

@end
