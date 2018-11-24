//
//  MenuTableViewCell.m
//  XMW Base client
//
//  Created by Ashish Tiwari on 22/05/2013.
//  Copyright (c) 2013 Dotvik Solutions. All rights reserved.
//

#import "MenuTVCell.h"
#import "Styles.h"


@implementation MenuTVCell


@synthesize keyValue;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        // Initialization code
        self.contentView.backgroundColor = [Styles tabMenuBackgroundColor];
        self.textLabel.textColor = [Styles tabMenuTextColor];
        self.backgroundColor = [Styles tabMenuBackgroundColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
