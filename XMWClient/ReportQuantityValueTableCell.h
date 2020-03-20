//
//  ReportQuantityValueTableCell.h
//  QCMSProject
//
//  Created by Pradeep Singh on 9/5/16.
//  Copyright © 2016 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportQuantityValueTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* fieldLabel;
@property (weak, nonatomic) IBOutlet UILabel* firstValue;
@property (weak, nonatomic) IBOutlet UILabel* firstQuantity;
@property (weak, nonatomic) IBOutlet UILabel* secondValue;
@property (weak, nonatomic) IBOutlet UILabel* secondQuantity;
@property (weak, nonatomic) IBOutlet UILabel* thirdValue;
@property (weak, nonatomic) IBOutlet UILabel* thirdQuantity;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;

@property (weak, nonatomic) IBOutlet UILabel *cons1;
@property (weak, nonatomic) IBOutlet UILabel *cons2;

@property (weak, nonatomic) IBOutlet UIView *containerView;


@end
