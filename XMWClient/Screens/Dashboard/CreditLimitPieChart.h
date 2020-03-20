//
//  CreditLimitPieChart.h
//  XYPieChart
//
//  Created by Ashish Tiwari on 28/01/15.
//  Copyright (c) 2015 Xiaoyang Feng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"
#import "HttpEventListener.h"
#import "NetworkHelper.h"
#import "LoadingView.h"

#import "ReportPostResponse.h"

@interface CreditLimitPieChart : UIViewController<XYPieChartDataSource, XYPieChartDelegate,HttpEventListener>
{
    
    LoadingView* loadingView;
    NetworkHelper* networkHelper;
    
}
@property (strong, nonatomic) IBOutlet XYPieChart *pieChartRight;
@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSArray        *sliceColors;
@property (strong, nonatomic) IBOutlet UILabel *selectedSliceLabel;

@property (strong, nonatomic) IBOutlet UILabel *paybleAmt;
@property (weak, nonatomic) IBOutlet UILabel *paybleAmtValue;
@property (strong, nonatomic) IBOutlet UILabel *remainCredit;
@property (weak, nonatomic) IBOutlet UILabel *remainCrtValue;

@property ReportPostResponse *graphData;

@end