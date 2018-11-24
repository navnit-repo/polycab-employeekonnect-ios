//
//  SearchTableViewCell.m
//  EMSV3CommonMobilet
//
//  Created by Puneet on 11-May-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchTableViewCell.h"


@implementation SearchTableViewCell

@synthesize mandatoryLabel,titleLabel;
@synthesize radioGroupButton;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) 
	{
        
        // Initialization code
		mandatoryLabel = [[MXLabel alloc] initWithFrame:CGRectMake(4, 11, 8, 16)];
		mandatoryLabel.textColor = [UIColor colorWithRed:0.968f green:0.0f blue:0.0f alpha:1.0];
		mandatoryLabel.backgroundColor = [UIColor clearColor];
		mandatoryLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[mandatoryLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
		mandatoryLabel.textAlignment = UITextAlignmentLeft;
		mandatoryLabel.text = @"*";
		
		titleLabel = [[MXLabel alloc] initWithFrame:CGRectMake(10, 6, 137, 28)];
		titleLabel.textColor = [UIColor colorWithRed:0.227f green:0.227f blue:0.227f alpha:1.0];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		titleLabel.minimumFontSize = 10.0;
		titleLabel.adjustsFontSizeToFitWidth = YES;
		titleLabel.textAlignment = UITextAlignmentLeft;
		titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
		
		UIImage *blueImage = [UIImage imageNamed:@"blueButton.png"];
		UIImage *blueButtonImage = [blueImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
		
		radioGroupButton = [[MXButton alloc] init];
		[radioGroupButton setFrame:CGRectMake( 130.0f, 6.0f, 160.0f, 32.0f)];
		[radioGroupButton setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
		[radioGroupButton setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] forState: UIControlStateNormal];
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.contentView.backgroundColor = [UIColor colorWithRed:0.768f green:0.77f blue:1.0 alpha:1.0];
		
		[self.contentView addSubview:mandatoryLabel];
		[self.contentView addSubview:titleLabel];
		[self.contentView addSubview:radioGroupButton];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}



@end
