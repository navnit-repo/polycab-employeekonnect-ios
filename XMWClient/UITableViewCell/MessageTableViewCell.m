//
//  MessageTableViewCell.m
//  EMSV3CommonMobilet
//
//  Created by Puneet on 19-May-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MessageTableViewCell.h"


@implementation MessageTableViewCell


@synthesize messageLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
	{
        // Initialization code.
		
		messageLabel = [[UILabel alloc] init];
		messageLabel.textColor = [UIColor colorWithRed:0.254f green:0.0f blue:0.0f alpha:1.0f];
		messageLabel.backgroundColor = [UIColor colorWithRed:0.768f green:0.77f blue:1.0 alpha:1.0];
		
		messageLabel.lineBreakMode = UILineBreakModeWordWrap;
		messageLabel.numberOfLines = 0;
		messageLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
		
		self.accessoryType = UITableViewCellAccessoryNone;
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.contentView.backgroundColor = [UIColor colorWithRed:0.768f green:0.77f blue:1.0 alpha:1.0];
		
		[self.contentView addSubview:messageLabel];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}


@end
