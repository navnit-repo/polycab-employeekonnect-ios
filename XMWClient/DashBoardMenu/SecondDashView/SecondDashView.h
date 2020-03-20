//
//  SecondDashView.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 14/01/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpEventListener.h"
#import "XYPieChart.h"
#import "DashBoardMenuViewController.h"


@interface SecondDashView : UIView<HttpEventListener,XYPieChartDataSource, XYPieChartDelegate>

+(SecondDashView*) createInstance;


-(void) updateData;
-(void) refreshData;


-(void)setViewContent:(ReportPostResponse *)reportPostResponse;

@property (weak, nonatomic) IBOutlet UILabel *incentiveLabel;

@property (weak, nonatomic) ReportPostResponse* salesIncentiveSummary;

@property (strong, nonatomic) IBOutlet XYPieChart *pieChartLeft;

@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSArray        *sliceColors;

@property (weak, nonatomic) IBOutlet UIView* centerView;
@property (weak, nonatomic) IBOutlet UILabel *lacLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (weak, nonatomic) IBOutlet UIButton* pauseFlipButton;

@property DashBoardMenuViewController *dashBoardMenuViewCtrl;

@property(nonatomic, strong) NSMutableArray *slicesDataArray;


@end
