//
//  SalesComparisonLegend.h
//  QCMSProject
//
//  Created by Pradeep Singh on 2/3/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalesComparisonLegend : UIView

@property (weak, nonatomic) IBOutlet UIView* firstLegend;
@property (weak, nonatomic) IBOutlet UILabel* firstLegendLabel;
@property (weak, nonatomic) IBOutlet UIView* secondLegend;
@property (weak, nonatomic) IBOutlet UILabel* secondLegendLabel;
@property (weak, nonatomic) IBOutlet UILabel* mtdCurrentTotal;
@property (weak, nonatomic) IBOutlet UILabel* mtdLastTotal;
@property (weak, nonatomic) IBOutlet UILabel *constantView1;
@property (weak, nonatomic) IBOutlet UILabel *constantView2;
@property (weak, nonatomic) IBOutlet UIView *constantView3;
@property (weak, nonatomic) IBOutlet UIView *constantView4;
@property (weak, nonatomic) IBOutlet UIView *constantView5;
@property (weak, nonatomic) IBOutlet UIView *constantView6;
@property (weak, nonatomic) IBOutlet UILabel *constantView7;


+(SalesComparisonLegend*) createInstance;
-(void)autoLayout;

@end
