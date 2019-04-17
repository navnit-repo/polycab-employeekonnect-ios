//
//  ChatThreadCell.m
//  XMWClient
//
//  Created by dotvikios on 12/04/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "ChatThreadCell.h"
#import "LayoutClass.h"
#import "DVAppDelegate.h"
@implementation ChatThreadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [LayoutClass labelLayout:self.subjectLbl forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.timeStampLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.chatPersonLbl forFontWeight:UIFontWeightRegular];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
