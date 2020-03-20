//
//  TimeTableViewCell.m
//  QCMSProject
//
//  Created by Ashish Tiwari on 15/10/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "TimeTableViewCell.h"
#import "Styles.h"

@implementation TimeTableViewCell

@synthesize textValue;

@synthesize timeField,timeButton;

@synthesize titleLabel,mandatoryLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
	{
        // Initialization code
		mandatoryLabel = [[MXLabel alloc] initWithFrame:CGRectMake(16, 11, 8, 16)];
		mandatoryLabel.textColor = [UIColor colorWithRed:0.968f green:0.0f blue:0.0f alpha:1.0];
		mandatoryLabel.backgroundColor = [UIColor clearColor];
		mandatoryLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[mandatoryLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
		mandatoryLabel.textAlignment = UITextAlignmentLeft;
		mandatoryLabel.text = @"*";
		
		titleLabel = [[MXLabel alloc] initWithFrame:CGRectMake(24, 6, 137, 28)];
		titleLabel.textColor = [UIColor colorWithRed:0.227f green:0.227f blue:0.227f alpha:1.0];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		titleLabel.adjustsFontSizeToFitWidth = NO;
		titleLabel.minimumFontSize = 10.0;
		titleLabel.textAlignment = UITextAlignmentLeft;
		titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
        
        
		
		UIImage *timeImage = [UIImage imageNamed:@"timefield.png"];
		
		timeButton = [MXButton buttonWithType:UIButtonTypeCustom];
        [timeButton setFrame:CGRectMake( 0.0f, 0.0f, self.frame.size.height-8, self.frame.size.height-8)];
		[timeButton setImage:timeImage forState:UIControlStateNormal];
		
		
		timeField = [[MXTextField alloc] initWithFrame:CGRectMake(144, 6, 169, self.frame.size.height-4)];
		timeField.borderStyle = UITextBorderStyleRoundedRect;
		timeField.returnKeyType = UIReturnKeyDefault;
		timeField.minimumFontSize = 10.0;
        timeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		timeField.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
		timeField.autocapitalizationType = UITextAutocapitalizationTypeWords;
		timeField.adjustsFontSizeToFitWidth = TRUE;
		timeField.text = textValue;
		timeField.adjustsFontSizeToFitWidth = YES;
		
		
		[timeField setRightView:timeButton];
		[timeField setRightViewMode:UITextFieldViewModeAlways];
		[timeField setPlaceholder:@"Select a time.."];
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.contentView.backgroundColor = [Styles formBackgroundColor];
		
		[self.contentView addSubview:mandatoryLabel];
		[self.contentView addSubview:timeField];
		[self.contentView addSubview:titleLabel];
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}



@end
