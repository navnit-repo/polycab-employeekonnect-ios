//
//  ForthDashView.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 14/01/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpEventListener.h"
#import "DashBoardMenuViewController.h"
@interface ForthDashView : UIView<HttpEventListener>

+(ForthDashView*) createInstance;
-(void) updateData;
-(void) refreshData;


-(void)setViewContent:(ReportPostResponse *)responsePayTotaleAmt;


@property (weak, nonatomic) ReportPostResponse* payableSummary;
@property (weak, nonatomic) IBOutlet UILabel *dataLable;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UILabel *lacLabel;
@property DashBoardMenuViewController *dashViewContlr;
@end
