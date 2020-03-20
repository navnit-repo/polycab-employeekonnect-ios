//
//  DualAxisHorizontalBarCell.h
//  QCMSProject
//
//  Created by Pradeep Singh on 2/4/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DualAxisHorizontalBarCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* rowLabel;
@property (weak, nonatomic) IBOutlet UIView* leftBarParent;
@property (weak, nonatomic) IBOutlet UIView* leftBar;
@property (weak, nonatomic) IBOutlet UIView* rightBarParent;
@property (weak, nonatomic) IBOutlet UIView* rightBar;


-(void) configureLeftWithValue:(double) barValue maxValue:(double) maxValue;
-(void) configureRightWithValue:(double) barValue maxValue:(double) maxValue;

-(void) displayLeftBarValue:(NSString*) barValue;
-(void) displayRightBarValue:(NSString*) barValue;


@end
