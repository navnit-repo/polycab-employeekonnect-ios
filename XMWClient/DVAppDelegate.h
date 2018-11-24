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
extern CGFloat deviceWidthRation;
extern CGFloat deviceHeightRation;
extern CGFloat bottomBarHeight;
@interface DVAppDelegate : UIResponder <UIApplicationDelegate, HttpEventListener>
{
     NSString *launchUrlString;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LogInVC *viewController;
@property (nonatomic, retain) UINavigationController *navController;


+ (NSString*) currentModuleContext;
+ (void) pushModuleContext : (NSString*) moduleCtx;
+ (void) popModuleContext;

@end
