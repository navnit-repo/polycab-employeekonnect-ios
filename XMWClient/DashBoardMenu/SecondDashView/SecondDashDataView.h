//
//  SecondDashDataView.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 06/02/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashBoardMenuViewController.h"

@interface SecondDashDataView : UIView

+(SecondDashDataView*) createInstance;
-(void) updateData;

-(void)setSecondCellFlippedDataTextNotifications : (NSNotification*) notification;// : (NSMutableArray *)dataArray;

@property (weak, nonatomic) IBOutlet UILabel *setteledLabelValue;
@property (weak, nonatomic) IBOutlet UILabel *achivedLabelValue;
@property (weak, nonatomic) IBOutlet UILabel *targetLabelValue;

@property (weak, nonatomic) IBOutlet UIButton* pauseFlipButton;

@property DashBoardMenuViewController *dashBoardMenuViewCtrl;
@end
