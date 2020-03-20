//
//  SalesIncentiveChart.h
//  QCMSProject
//
//  Created by Pradeep Singh on 2/3/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DotBarChartDataSource.h"


@interface SalesIncentiveChart : UIViewController <DotDualHAxisDataSource, DotDualHAxisDelegate>


@property (weak, nonatomic) IBOutlet UISegmentedControl* segmentControl;

@end
