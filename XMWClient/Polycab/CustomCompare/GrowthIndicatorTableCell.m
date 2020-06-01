//
//  GrowthIndicatorTableCell.m
//  QCMSProject
//
//  Created by Pradeep Singh on 9/5/16.
//  Copyright © 2016 dotvik. All rights reserved.
//

#import "GrowthIndicatorTableCell.h"
#import "LayoutClass.h"

@implementation GrowthIndicatorTableCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self autolayout];
}

-(void)autolayout
{
    
    [LayoutClass labelLayout:self.fieldLabel];
    [LayoutClass labelLayout:self.firstLabel];
    [LayoutClass labelLayout:self.secondLabel];
    [LayoutClass labelLayout:self.thirdLabel];
    [LayoutClass labelLayout:self.growthLabel];
    
     [LayoutClass setLayoutForIPhone6:self.contentView];
    
    [LayoutClass setLayoutForIPhone6:[self.contentView viewWithTag:101]];
    
    
   
   
    
    for(int i=1001; i<1006; i++) {
        [LayoutClass setLayoutForIPhone6: [[self.contentView viewWithTag:101] viewWithTag:i]];
    }
    
    [LayoutClass setLayoutForIPhone6: [[[self.contentView viewWithTag:101] viewWithTag:1005] viewWithTag:5001]] ;
    [self.contentView viewWithTag:101].layer.cornerRadius = 5.0;
    [self.contentView viewWithTag:101].layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
