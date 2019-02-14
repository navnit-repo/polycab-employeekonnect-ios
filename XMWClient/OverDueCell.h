//
//  OverDueCell.h
//  XMWClient
//
//  Created by dotvikios on 13/12/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"

@interface OverDueCell : UIView<XYPieChartDataSource, XYPieChartDelegate>
{
    UILabel *creditDetailsDisplayNameLbl;
    float creditLimit;
    float remaining;
    float payable;
    
    float user1;
    float user2;
    float user3;
    float user4;
    float user5;
    
    float totalAmmount;
    
    
}
+(OverDueCell*) createInstance;
@property (weak, nonatomic) IBOutlet XYPieChart *pieChart;
@property (strong, nonatomic) IBOutlet UILabel *creditDetailsDisplayNameLbl;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *constantLbl1;
-(void)configure :(NSArray *)dataArray;
-(void)autoLayout;
-(NSString*)formateCurrency:(NSString *)actualAmount;

@property (weak, nonatomic) IBOutlet UIView *constantView1;
@property (weak, nonatomic) IBOutlet UIView *constantView2;
@property (weak, nonatomic) IBOutlet UIView *constantView3;
@property (weak, nonatomic) IBOutlet UIView *constantView4;
@property (weak, nonatomic) IBOutlet UIView *constantView5;

@property (weak, nonatomic) IBOutlet UILabel *user1;

@property (weak, nonatomic) IBOutlet UILabel *user2;
@property (weak, nonatomic) IBOutlet UILabel *user3;
@property (weak, nonatomic) IBOutlet UILabel *user4;
@property (weak, nonatomic) IBOutlet UILabel *user5;



@property (weak, nonatomic) IBOutlet UILabel *value1;
@property (weak, nonatomic) IBOutlet UILabel *value2;
@property (weak, nonatomic) IBOutlet UILabel *value3;
@property (weak, nonatomic) IBOutlet UILabel *value4;
@property (weak, nonatomic) IBOutlet UILabel *value5;

@end
