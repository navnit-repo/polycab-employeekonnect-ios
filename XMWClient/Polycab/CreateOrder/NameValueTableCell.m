//
//  NameValueTableCell.m
//  XMWClient
//
//  Created by Pradeep Singh on 30/05/21.
//  Copyright © 2021 dotvik. All rights reserved.
//

#import "NameValueTableCell.h"
#import "LayoutClass.h"

@implementation NameValueTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self autoLayout];
}

-(void)autoLayout{
   //  [LayoutClass setLayoutForIPhone6:self.leftLabel];
   //  [LayoutClass setLayoutForIPhone6:self.rightLabel];
    [LayoutClass setLayoutForIPhone6:self.contentView];
    [LayoutClass labelLayout:self.leftLabel forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.rightLabel forFontWeight:UIFontWeightRegular];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
