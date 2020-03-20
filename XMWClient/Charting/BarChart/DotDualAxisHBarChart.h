//
//  DotDualAxisHBarChart.h
//  QCMSProject
//
//  Created by Pradeep Singh on 2/3/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DotBarChartDataSource.h"

@interface DotDualAxisHBarChart : UIView  <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView* horizontalAxisView;
@property (weak, nonatomic) IBOutlet UIView* legendView;
@property (weak, nonatomic) IBOutlet UITableView* barChartsTableView;


@property (weak, nonatomic) id<DotDualHAxisDataSource> chartDataSource;
@property (weak, nonatomic) id<DotDualHAxisDelegate> chartDelegate;


+(DotDualAxisHBarChart*) createInstance;

-(void) updateLayout;


-(void) updateLeftHorizontalAxis:(double) minValue :(double) maxValue;
-(void) updateRightHorizontalAxis:(double) minValue :(double) maxValue;


@end
