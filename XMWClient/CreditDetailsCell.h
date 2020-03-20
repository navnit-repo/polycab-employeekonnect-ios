//
//  CreditDetailsCell.h
//  XMWClient
//
//  Created by dotvikios on 09/08/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"
@interface CreditDetailsCell : UICollectionViewCell<XYPieChartDataSource, XYPieChartDelegate>
@property (weak, nonatomic) IBOutlet XYPieChart *pieChart;
-(void)configure :(NSArray *)dataArray;
@end
