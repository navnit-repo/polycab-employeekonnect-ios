//
//  CalendarTableViewCell.m
//  EMSV3CommonMobilet
//
//  Created by Puneet on 28-Mar-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CalendarTableViewCell.h"
#import "Styles.h"



@implementation CalendarTableViewCell

@synthesize textValue;

@synthesize calendarField,calendarButton;

@synthesize titleLabel,mandatoryLabel;
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame])
    {
        // Initialization code
        mandatoryLabel = [[MXLabel alloc] initWithFrame:CGRectMake(16, 11, 8, 16)];
        mandatoryLabel.textColor = [UIColor colorWithRed:0.968f green:0.0f blue:0.0f alpha:1.0];
        mandatoryLabel.backgroundColor = [UIColor clearColor];
        mandatoryLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [mandatoryLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        mandatoryLabel.textAlignment = UITextAlignmentLeft;
        mandatoryLabel.text = @"*";
        
        titleLabel = [[MXLabel alloc] initWithFrame:CGRectMake(24, 11, 137, 15)];
        titleLabel.textColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        titleLabel.adjustsFontSizeToFitWidth = NO;
        titleLabel.minimumFontSize = 10.0;
        titleLabel.textAlignment = UITextAlignmentLeft;
        titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:16.0];
    
        
        
        UIImage *calendarImage = [UIImage imageNamed:@"calendar.png"];
        
        UIImageView *calanderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 27, 27)];
        [calanderImageView setImage:calendarImage];
        
        calanderImageView.contentMode = UIViewContentModeCenter;
        
        calendarButton = [MXButton buttonWithType:UIButtonTypeCustom];
        [calendarButton setFrame:CGRectMake( 16, 33, self.bounds.size.width-32,40)];
       // [calendarButton setImage:calendarImage forState:UIControlStateNormal];
        
        //current working
        
        calendarField = [[MXTextField alloc] initWithFrame:CGRectMake(16, 33, self.bounds.size.width-32, 40)];
        
        // calendarField = [[MXTextField alloc] initWithFrame:CGRectMake(144, 6, 169, self.frame.size.height-4)];
        
        
        
        calendarField.borderStyle = UITextBorderStyleRoundedRect;
        calendarField.returnKeyType = UIReturnKeyDefault;
        calendarField.minimumFontSize = 10.0;
        calendarField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        calendarField.font = [UIFont fontWithName:@"Helvetica-Light" size:16.0];
        calendarField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        calendarField.adjustsFontSizeToFitWidth = TRUE;
        calendarField.text = textValue;
        calendarField.adjustsFontSizeToFitWidth = YES;
        calendarField.textColor =[UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
        //set textfield border
        
        self.calendarField.layer.masksToBounds=YES;
        self.calendarField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
        self.calendarField.layer.borderWidth= 1.0f;
        self.calendarField.layer.cornerRadius = 5.0f;
        
        
        
        
        [calendarField setRightView:calanderImageView];
        [calendarField setRightViewMode:UITextFieldViewModeAlways];
        [calendarField setPlaceholder:@"Select a date.."];
        

        
        //self.contentView.backgroundColor = [Styles formBackgroundColor];
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:mandatoryLabel];
        [self addSubview:calendarField];
        [self addSubview:titleLabel];
        [self addSubview:calendarButton];
    }
    return self;
}


- (void)layoutSubviews 
{	
	[super layoutSubviews];		
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
   // [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}



@end
