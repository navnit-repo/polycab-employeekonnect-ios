//
//  DualAxisHorizontalBarCell.m
//  QCMSProject
//
//  Created by Pradeep Singh on 2/4/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import "DualAxisHorizontalBarCell.h"

#define LEFT_BAR_LABEL_TAG  7950
#define RIGHT_BAR_LABEL_TAG  7951

@implementation DualAxisHorizontalBarCell

- (void)awakeFromNib {
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) configureLeftWithValue:(double) barValue maxValue:(double) maxValue
{
    CGRect leftFrame = self.leftBar.frame;
    
    if(maxValue!=0.0f) {
        self.leftBar.frame = CGRectMake(leftFrame.origin.x, leftFrame.origin.y, self.leftBarParent.frame.size.width*barValue/maxValue,    leftFrame.size.height);
    } else {
        self.leftBar.frame = CGRectMake(leftFrame.origin.x, leftFrame.origin.y, 0,    leftFrame.size.height);
    }

}

-(void) configureRightWithValue:(double) barValue maxValue:(double) maxValue
{
    CGRect rightFrame = self.rightBar.frame;
    CGRect rightParentFrame = self.rightBarParent.frame;
    double rightBarWidth = 0.0f;
    
    if(maxValue!=0.0f) {
        rightBarWidth = rightParentFrame.size.width*barValue/maxValue;
    }
    
    
    self.rightBar.frame = CGRectMake(rightParentFrame.size.width-rightBarWidth, rightFrame.origin.y, rightBarWidth, rightFrame.size.height);
}



-(void) displayLeftBarValue:(NSString*) barValue
{
    CGRect leftFrame = self.leftBar.frame;
    CGRect leftParentFrame = self.leftBarParent.frame;
    
    CGSize  rectSize = [barValue boundingRectWithSize:CGSizeMake(leftParentFrame.size.width, leftFrame.size.height) options: NSStringDrawingUsesLineFragmentOrigin attributes: @{ NSFontAttributeName: [UIFont systemFontOfSize:11] } context: nil].size;
    
    
    UILabel* barLabel = (UILabel*)[self.leftBarParent viewWithTag:LEFT_BAR_LABEL_TAG ];
    if(barLabel!=nil) {
        [barLabel removeFromSuperview];
    }

    
    if(rectSize.width > leftFrame.size.width) {
        // it cannot be fit inside the bar
        UILabel* barLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftFrame.size.width, leftFrame.origin.y, rectSize.width, rectSize.height)];
        barLabel.text = barValue;
        barLabel.textAlignment = NSTextAlignmentLeft;
        barLabel.font = [UIFont systemFontOfSize:11];
        barLabel.tag = LEFT_BAR_LABEL_TAG;
        [self.leftBarParent addSubview:barLabel];
    } else {
        // it can fit inside the bar
        UILabel* barLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, leftFrame.origin.y, leftFrame.size.width, rectSize.height)];
        barLabel.text = barValue;
        barLabel.textAlignment = NSTextAlignmentCenter;
        barLabel.tag = LEFT_BAR_LABEL_TAG;
        barLabel.font = [UIFont systemFontOfSize:11];
        [self.leftBarParent addSubview:barLabel];
    }

    
    
}

-(void) displayRightBarValue:(NSString*) barValue
{
    CGRect rightFrame = self.rightBar.frame;
    CGRect rightParentFrame = self.rightBarParent.frame;
    
    
    CGSize  rectSize = [barValue boundingRectWithSize:CGSizeMake(rightParentFrame.size.width, rightFrame.size.height) options: NSStringDrawingUsesLineFragmentOrigin attributes: @{ NSFontAttributeName: [UIFont systemFontOfSize:11] } context: nil].size;
    
    
    UILabel* barLabel = (UILabel*)[self.rightBarParent viewWithTag:RIGHT_BAR_LABEL_TAG ];
    if(barLabel!=nil) {
        [barLabel removeFromSuperview];
    }
    
    
    if(rectSize.width > rightFrame.size.width) {
        // it cannot be fit inside the bar
        UILabel* barLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, rightFrame.origin.y, rightParentFrame.size.width-rightFrame.size.width, rectSize.height)];
        barLabel.text = barValue;
        barLabel.textAlignment = NSTextAlignmentRight;
        barLabel.font = [UIFont systemFontOfSize:11];
        barLabel.tag = RIGHT_BAR_LABEL_TAG;
        [self.rightBarParent addSubview:barLabel];
    } else {
        // it can fit inside the bar
        UILabel* barLabel = [[UILabel alloc] initWithFrame:CGRectMake(rightFrame.origin.x, rightFrame.origin.y, rightFrame.size.width, rectSize.height)];
        barLabel.text = barValue;
        barLabel.textAlignment = NSTextAlignmentCenter;
        barLabel.textColor = [UIColor whiteColor];
        barLabel.tag = RIGHT_BAR_LABEL_TAG;
        barLabel.font = [UIFont systemFontOfSize:11];
        [self.rightBarParent addSubview:barLabel];
    }
}

@end
