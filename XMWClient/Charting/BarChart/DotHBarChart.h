//
//  DotHBarChart.h
//  QCMSProject
//
//  Created by Pradeep Singh on 1/7/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

/*
 * In horizontal chart representation, we will have vertical axis as a part of the table
 * row cell view.
 *
 */
#import <UIKit/UIKit.h>
#import "DotBarChartDataSource.h"


@interface DotHBarChart : UIView <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView* horizontalAxisView;
@property (weak, nonatomic) IBOutlet UIView* legendView;
@property (weak, nonatomic) IBOutlet UITableView* barChartsTableView;


@property (weak, nonatomic) id<DotHBarChartDataSource> chartDataSource;
@property (weak, nonatomic) id<DotHBarChartDelegate> chartDelegate;
@property BOOL needLeftAxis;


+(DotHBarChart*) createInstance;
-(void) updateLayout;

-(void) updateHorizontalAxis:(double) minValue :(double) maxValue;

@end
