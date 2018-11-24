//
//  SalesComparisonChart.h
//  QCMSProject
//
//  Created by Pradeep Singh on 1/18/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DotBarChartDataSource.h"
#import "DotFormPost.h"

#define MTD_SALES 0
#define YTD_SALES 1


@interface SalesComparisonChart : UIViewController <DotHBarChartDataSource, DotHBarChartDelegate>

@property NSInteger chartType;
@property (weak, nonatomic) IBOutlet UISegmentedControl* segmentControl;
-(DotFormPost*) salesReportFormPost:(NSString*) fromDate toDate:(NSString*) toDate;
@end
