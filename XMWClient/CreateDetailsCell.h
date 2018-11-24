//
//  CreateDetailsCell.h
//  XMWClient
//
//  Created by dotvikios on 24/08/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"
@interface CreateDetailsCell : UIView<XYPieChartDataSource, XYPieChartDelegate>
+(CreateDetailsCell*) createInstance;
@property (weak, nonatomic) IBOutlet XYPieChart *pieChart;
@property (weak, nonatomic) IBOutlet UILabel *creditDetailsDisplayNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *creditDetailsPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *overdueLbl;
@property (weak, nonatomic) IBOutlet UILabel *creditHideAccordingTOCondition;
@property (weak, nonatomic) IBOutlet UILabel *overDueHideAccordingTOCondition;
-(void)configure :(NSArray *)dataArray;
@property (weak, nonatomic) IBOutlet UILabel *used;
@property (weak, nonatomic) IBOutlet UILabel *displayUsedLbl;
@property (weak, nonatomic) IBOutlet UILabel *remaining;
@property (weak, nonatomic) IBOutlet UILabel *displayRemainingLbl;
@property (weak, nonatomic) IBOutlet UIView *usedView1;
@property (weak, nonatomic) IBOutlet UIView *remainingView1;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *constantLbl1;
@property (weak, nonatomic) IBOutlet UILabel *constantLbl2;
@property (weak, nonatomic) IBOutlet UILabel *constantLbl3;
@property (weak, nonatomic) IBOutlet UILabel *constantLbl4;
@property (weak, nonatomic) IBOutlet UILabel *constantLbl5;


@end
