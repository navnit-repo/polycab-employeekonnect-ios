//
//  AlertButtonTableViewCell.m
//  EMSV3CommonMobilet
//
//  Created by Puneet Arora on 23/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlertButtonTableViewCell.h"


@implementation AlertButtonTableViewCell

@synthesize questionLabel;
@synthesize leftButton,rightButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) 
	{
		questionLabel = [[UILabel alloc] init];
		questionLabel.textColor = [UIColor blackColor];
		questionLabel.backgroundColor = [UIColor clearColor];
		
		questionLabel.lineBreakMode = UILineBreakModeWordWrap;
		questionLabel.numberOfLines = 0;
		questionLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
		
        // Initialization code
		UIImage *blueImage = [UIImage imageNamed:@"blueButton.png"];
		UIImage *blueButtonImage = [blueImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
		
		leftButton = [[MXButton alloc] init];
		[leftButton setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
		[leftButton setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] forState: UIControlStateNormal];
		
		rightButton = [[MXButton alloc] init];
		[rightButton setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
		[rightButton setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] forState: UIControlStateNormal];
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.contentView.backgroundColor = [UIColor colorWithRed:0.768f green:0.77f blue:1.0 alpha:1.0];
		
		[self.contentView addSubview:questionLabel];
		[self.contentView addSubview:leftButton];
		[self.contentView addSubview:rightButton];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}



@end
