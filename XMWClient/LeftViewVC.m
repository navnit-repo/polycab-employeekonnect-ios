//
//  LeftViewVC.m
//  XMWClient
//
//  Created by dotvikios on 18/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "LeftViewVC.h"
#import "SWRevealViewController.h"
#import "HamBurgerMenuView.h"
#import "XmwUtils.h"
#import "XmwcsConstant.h"
#import "ClientVariable.h"
#import "DVAppDelegate.h"

@interface LeftViewVC ()

@end

@implementation LeftViewVC
{
    NSMutableArray *keyIdName;
    NSMutableArray *menuItems;
    
}
@synthesize menuDetailsDict;
@synthesize auth_Token;
static HamBurgerMenuView* rightSlideMenu = nil;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (isiPhoneXSMAX) {
        self.view.frame = CGRectMake(0, 64, 414, 832);
    }
    else if(isiPhoneXR) {
        self.view.frame = CGRectMake(0, 64, 414, 832);
    }
    
    else if(isiPhoneXS) {
        self.view.frame = CGRectMake(0, 64, 375, 748);
    }
    else if(isiPhone10) {
        self.view.frame = CGRectMake(0, 64, 375, 748);
    }
    
    else if(isiPhone6Plus) {
        self.view.frame = CGRectMake(0, 64, 414, 672);
    }
    else if(isiPhone6) {
        self.view.frame = CGRectMake(0, 64, 375, 600);
    } else if(isiPhone5) {
        self.view.frame = CGRectMake(0, 64, 320, 504);
    } else {
        // 0, 64, 320, 416
        self.view.frame = CGRectMake(0, 64, 320, 416);
    }
    
    NSLog(@"%@",menuDetailsDict);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getMenuItems];
        [self configureSideBar];
    });
    
   
    
    
}
-(void) getMenuItems
{
    // Pradeep: 2020-06-05, if there are no booking verticals, then we need to remove create order menus
    // Same already working on Portal
    
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    NSArray* bookingVerticals = [clientVariables.CLIENT_LOGIN_RESPONSE.clientMasterDetail.masterDataRefresh objectForKey:@"BOOKING_VERTICALS"];
    
    
    menuItems           = [[NSMutableArray alloc] init];
    keyIdName           = [[NSMutableArray alloc] initWithArray:[XmwUtils sortHashtableKey : menuDetailsDict : XmwcsConst_SORT_AS_INTEGER]];
    //add log out filed in dictionary
    NSMutableDictionary *CHILD_MENU_DETAIL = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *logOutEmptyData = [[NSMutableDictionary alloc]init];
    [logOutEmptyData setValue:CHILD_MENU_DETAIL forKey:@"CHILD_MENU_DETAIL"];
    [logOutEmptyData setValue:@"DOT_FORM_Log_Out" forKey:@"FORM_ID"];
    [logOutEmptyData setValue:@"LOGOUT" forKey:@"FORM_TYPE"];
    [logOutEmptyData setValue:@"Logout" forKey:@"MENU_NAME"];
    [logOutEmptyData setValue:@"xmwpcdealer" forKey:@"MODULE"];
    [menuDetailsDict setObject:logOutEmptyData forKey:@"1000"];
    
    
    NSMutableDictionary *dashboardEmptyData = [[NSMutableDictionary alloc]init];
    [dashboardEmptyData setValue:CHILD_MENU_DETAIL forKey:@"CHILD_MENU_DETAIL"];
    [dashboardEmptyData setValue:@"DOT_FORM_DASHBOARD" forKey:@"FORM_ID"];
    [dashboardEmptyData setValue:@"DASHBOARD" forKey:@"FORM_TYPE"];
    [dashboardEmptyData setValue:@"Dashboard" forKey:@"MENU_NAME"];
    [dashboardEmptyData setValue:@"xmwpcdealer" forKey:@"MODULE"];
    [menuDetailsDict setObject:dashboardEmptyData forKey:@"10"];
    
    [keyIdName addObject:@"10"];
    [keyIdName addObject:@"1000"];
    
    NSMutableArray *keys= [[NSMutableArray alloc]init];
    for (int i=0; i<keyIdName.count; i++) {
        NSInteger b = [[keyIdName objectAtIndex:i]integerValue];
        NSNumber *number = [NSNumber numberWithInt:b];
        [keys addObject:number];
    }
    
    keys = [NSMutableArray arrayWithArray:[keys sortedArrayUsingSelector: @selector(compare:)]];
    [keys sortedArrayUsingSelector: @selector(compare:)];
    keyIdName = [[NSMutableArray alloc]init];
    for(int i=0; i<keys.count;i++)
    {
        NSString* tempKeyIdName = [NSString stringWithFormat:@"%@",[keys objectAtIndex:i]];
        NSMutableDictionary* menuItemDetail = [menuDetailsDict objectForKey:tempKeyIdName];
        NSString* menuTitle = [menuItemDetail objectForKey: XmwcsConst_MENU_CONSTANT_MENU_NAME ];
        
        if(([menuTitle compare:@"Create Order" options:NSCaseInsensitiveSearch]==NSOrderedSame)
           || ([menuTitle compare:@"Create Order - SPA" options:NSCaseInsensitiveSearch]==NSOrderedSame)
           || ([menuTitle compare:@"My Orders" options:NSCaseInsensitiveSearch]==NSOrderedSame) ) {
            if(bookingVerticals!=nil && [bookingVerticals count]>0) {
                [keyIdName addObject: tempKeyIdName];
            }
        } else {
            [keyIdName addObject: tempKeyIdName];
        }
    }
    
    NSLog(@"menuDetail = %@",menuDetailsDict);
    long int sizeOfKeyVec    = [keyIdName count];
    NSString *menuTitle;
    
    for (int idx = 0; idx < sizeOfKeyVec; idx++)
    {
        NSMutableDictionary* menuItemDetail = [menuDetailsDict objectForKey:[keyIdName objectAtIndex:idx]];
        menuTitle = [menuItemDetail objectForKey: XmwcsConst_MENU_CONSTANT_MENU_NAME ];
        
        if(([menuTitle compare:@"Create Order" options:NSCaseInsensitiveSearch]==NSOrderedSame)
           || ([menuTitle compare:@"Create Order - SPA" options:NSCaseInsensitiveSearch]==NSOrderedSame)
           || ([menuTitle compare:@"My Orders" options:NSCaseInsensitiveSearch]==NSOrderedSame)) {
            if(bookingVerticals!=nil && [bookingVerticals count]>0) {
                [menuItems addObject:menuTitle];
            }
        } else {
            [menuItems addObject:menuTitle];
        }
    }
    NSLog(@"menuDetailAfter = %@",menuItems);
}
-(void)configureSideBar{
    
    rightSlideMenu = [[HamBurgerMenuView alloc] initWithFrame:CGRectMake(0,0, 300, self.view.bounds.size.height+64) withMenu:menuItems handler:self :menuDetailsDict : keyIdName];
    [self.view addSubview : rightSlideMenu];
    [UIView beginAnimations:@"TableAnimation" context:NULL];
    [UIView setAnimationCurve:self];
    [UIView setAnimationDuration:0.2];
    [UIView commitAnimations];
    
}
-(void) humbergerMenuClicked : (int) idx : (DotMenuObject *)selectedMenuData
{
    
    [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    [self.delegate clickedDashBoardDelegate:idx :selectedMenuData :auth_Token];
    NSLog(@"Hamburger menu clicked with idx %d", idx);
    
}

@end
