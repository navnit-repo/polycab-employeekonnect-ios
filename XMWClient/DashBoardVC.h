//
//  DashBoardVC.h
//  XMWClient
//
//  Created by dotvikios on 17/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "LeftViewVC.h"
#import "MarqueeLabel.h"

@interface DashBoardVC : UIViewController <SlideBarDelegate,UITableViewDelegate,UITableViewDataSource,UITabBarDelegate>
{
    NSString *auth_Token;
}
@property (weak, nonatomic) IBOutlet MarqueeLabel* marqueeText;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSString *auth_Token;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (strong, nonatomic) SWRevealViewController *viewController;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabbarBottomConstraint;

@end

