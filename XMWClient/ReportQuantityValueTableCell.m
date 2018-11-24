//
//  ReportQuantityValueTableCell.m
//  QCMSProject
//
//  Created by Pradeep Singh on 9/5/16.
//  Copyright © 2016 dotvik. All rights reserved.
//

#import "ReportQuantityValueTableCell.h"
#import "LayoutClass.h"
@implementation ReportQuantityValueTableCell

- (void)awakeFromNib {
    // Initialization code
    [self autoLayout];
    [super awakeFromNib];
    
}
-(void)autoLayout{
    [LayoutClass setLayoutForIPhone6:self.view1];
     [LayoutClass setLayoutForIPhone6:self.view2];
     [LayoutClass setLayoutForIPhone6:self.view3];
     [LayoutClass setLayoutForIPhone6:self.view4];
     [LayoutClass setLayoutForIPhone6:self.view5];
    [LayoutClass setLayoutForIPhone6:self.containerView];
    
    [LayoutClass labelLayout:self.fieldLabel forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.firstValue forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.firstQuantity forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.secondValue forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.secondQuantity forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.thirdValue forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.thirdQuantity forFontWeight:UIFontWeightRegular];
    
      [LayoutClass labelLayout:self.cons1 forFontWeight:UIFontWeightRegular];
      [LayoutClass labelLayout:self.cons2 forFontWeight:UIFontWeightRegular];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
