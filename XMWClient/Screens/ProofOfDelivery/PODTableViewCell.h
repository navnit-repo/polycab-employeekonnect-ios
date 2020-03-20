//
//  PODTableViewCell.h
//  QCMSProject
//
//  Created by Pradeep Singh on 3/29/17.
//  Copyright © 2017 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PODTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIView* topRowView;
@property (weak, nonatomic) IBOutlet UIButton* accessoryButton;
@property (weak, nonatomic) IBOutlet UIView* expandedView;
@property (weak, nonatomic) IBOutlet UIView* formContainerView;
@property (weak, nonatomic) IBOutlet UILabel* yesNoLabel;
@property (weak, nonatomic) IBOutlet UITextField* yesNoDropdownField;
@property (weak, nonatomic) IBOutlet UILabel* remarkLabel;
@property (weak, nonatomic) IBOutlet UITextView* remarkTextView;

@property (weak, nonatomic) IBOutlet UIView* separatorLine;

@end
