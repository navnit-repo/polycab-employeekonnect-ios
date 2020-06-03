//
//  GrowthIndicatorTableCell.h
//  QCMSProject
//
//  Created by Pradeep Singh on 9/5/16.
//  Copyright © 2016 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GrowthIndicatorTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* fieldLabel;
@property (weak, nonatomic) IBOutlet UILabel* firstLabel;
@property (weak, nonatomic) IBOutlet UILabel* secondLabel;
@property (weak, nonatomic) IBOutlet UILabel* thirdLabel;
@property (weak, nonatomic) IBOutlet UILabel* growthLabel;
@property (weak, nonatomic) IBOutlet UIImageView* growthIcon;


@end
