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

CGFloat deviceWidthRation;
CGFloat deviceHeightRation;
CGFloat bottomBarHeight;
BOOL regIDCheck;
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


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  
   
    
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
    
    
    NSArray *versionCompatibility = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ( 11 == [[versionCompatibility objectAtIndex:0] intValue] || [[versionCompatibility objectAtIndex:0] intValue] > 11 )
    {
        bottomBarHeight = self.window.safeAreaInsets.bottom;
        
    } else {
        bottomBarHeight = 0.0;
        
    }
    
   
    
 
    
    
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
    
    
    
    NSString *sixLabelVal = [[NSUserDefaults standardUserDefaults] objectForKey:@"SixCellDashKey"];
    NSString *fifthLabelVal = [[NSUserDefaults standardUserDefaults] objectForKey:@"FifthCellDashKey"];
    
    if(sixLabelVal == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"SixCellDashKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if(fifthLabelVal == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"FifthCellDashKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSString *sixCellImageName = [[NSUserDefaults standardUserDefaults] objectForKey:@"SixCellImageDashKey"];
    NSString *fifthCellImageName =  [[NSUserDefaults standardUserDefaults] objectForKey:@"FifthCellImageDashKey"];
    
    if(fifthCellImageName == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"FifthCellImageDashKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if(sixCellImageName == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"SixCellImageDashKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    
    }
    
    
    NSString* fifthCellDataObjectStr =  [[NSUserDefaults standardUserDefaults] objectForKey:@"fifthCellDotMenuObjectDataKey"];
    
    
    DotMenuObject *selectedMenuData = [[DotMenuObject alloc]init];
    NSMutableDictionary *fifthCellMenuObjectDicData = [[NSMutableDictionary alloc]init];
    [fifthCellMenuObjectDicData setObject:selectedMenuData forKey:@"fifthCellMenuDataDicKey"];
    
    
    SBJsonWriter* jsonWriter = [[SBJsonWriter alloc] init];
    NSString* fifthCellDataObjectJsonStr = [jsonWriter stringWithObject: fifthCellMenuObjectDicData ];
    
    if(fifthCellDataObjectStr == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:fifthCellDataObjectJsonStr forKey:@"fifthCellDotMenuObjectDataKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
     NSString* sixCellDataObjectStr =  [[NSUserDefaults standardUserDefaults] objectForKey:@"sixCellDotMenuObjectDataKey"];
    
    NSMutableDictionary *sixCellMenuObjectDicData = [[NSMutableDictionary alloc]init];
    [sixCellMenuObjectDicData setObject:selectedMenuData forKey:@"sixCellMenuDataDicKey"];   
    
    
    NSString* sixCellDataObjectJsonStr = [jsonWriter stringWithObject: sixCellMenuObjectDicData ];
    
    if(sixCellDataObjectStr == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:sixCellDataObjectJsonStr forKey:@"sixCellDotMenuObjectDataKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
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
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
    launchUrlString = nil;
   launchUrlString = [userInfo objectForKey:@"URL"];
    if(launchUrlString !=nil)
    {
        if(launchUrlString.length > 0)
        {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Would you like to open notification." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel" , nil];
            myAlertView.tag = 1015;
            [myAlertView show];
        }
       /* if([self isDownloadable:launchUrlString]) {
            NSRange rangeVideoMp4 =  [launchUrlString rangeOfString:@".mp4"];
            NSRange rangeImagePng =  [launchUrlString rangeOfString:@".png"];
            NSRange rangeImageJpg =  [launchUrlString rangeOfString:@".jpg"];
            if(rangeVideoMp4.length>0)
            {
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Would you like to download video." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel" , nil];
                myAlertView.tag = 700;
                [myAlertView show];
                
            }
            else if(rangeImagePng.length>0)
            {
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Would you like to download image." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel" , nil];
                myAlertView.tag = 701;
                [myAlertView show];
                
                
            }
            else if (rangeImageJpg.length>0)
            {
                
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Would you like to download image." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel" , nil];
                myAlertView.tag = 702;
                [myAlertView show];
                
            }
        } else {
            if(launchUrlString.length > 0)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //code to be executed in the background
                    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:launchUrlString]];
                    [self pushNotificationNetworkCall : launchUrlString];
                });
            }
        }*/
    }
    NSString* xmwPushContentType = [userInfo objectForKey:@"notifyContentType"];
    
}

//
// to support multiple module so that we can use client variables based on the current module context
//
+ (NSString*) currentModuleContext {
    if(DVAppDelegate_moduleContextStack != nil) {
        return [DVAppDelegate_moduleContextStack objectAtIndex: [DVAppDelegate_moduleContextStack count] - 1 ];
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
        [DVAppDelegate_moduleContextStack removeObjectAtIndex: [DVAppDelegate_moduleContextStack count] - 1];
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

@end
