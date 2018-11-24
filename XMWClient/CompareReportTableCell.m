//
//  CompareReportTableCell.m
//  QCMSProject
//
//  Created by Pradeep Singh on 9/5/16.
//  Copyright © 2016 dotvik. All rights reserved.
//

#import "CompareReportTableCell.h"
#import "LayoutClass.h"
@implementation CompareReportTableCell

- (void)awakeFromNib {
    // Initialization code
    
    [self autoLayout];
}

-(void)autoLayout{
    [LayoutClass setLayoutForIPhone6:self.view1];
     [LayoutClass setLayoutForIPhone6:self.view2];
     [LayoutClass setLayoutForIPhone6:self.view3];
     [LayoutClass setLayoutForIPhone6:self.view4];
    [LayoutClass setLayoutForIPhone6:self.containerView];
    
    [LayoutClass labelLayout:self.fieldLabel forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.firstLabel forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.secondLabel forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.thirdLabel forFontWeight:UIFontWeightRegular];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
