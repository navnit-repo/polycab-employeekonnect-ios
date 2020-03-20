//
//  CompareReportTableCell.h
//  QCMSProject
//
//  Created by Pradeep Singh on 9/5/16.
//  Copyright © 2016 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompareReportTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* fieldLabel;
@property (weak, nonatomic) IBOutlet UILabel* firstLabel;
@property (weak, nonatomic) IBOutlet UILabel* secondLabel;
@property (weak, nonatomic) IBOutlet UILabel* thirdLabel;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
