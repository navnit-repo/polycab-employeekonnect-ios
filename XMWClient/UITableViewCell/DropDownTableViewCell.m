//
//  DropDownTableViewCell.m
//  EMSV3CommonMobilet
//
//  Created by Puneet on 28-Mar-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DropDownTableViewCell.h"
#import "Styles.h"
#import <QuartzCore/QuartzCore.h>

@implementation DropDownTableViewCell


@synthesize keyValue,textValue;

@synthesize dropDownField,dropDownButton;

@synthesize dataDictionary,dataList;

@synthesize titleLabel,mandatoryLabel;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.mandatoryLabel = [[MXLabel alloc] initWithFrame:CGRectMake(16, 11, 8, 16)];
        self.mandatoryLabel.textColor = [UIColor colorWithRed:0.968f green:0.0f blue:0.0f alpha:1.0];
        self.mandatoryLabel.backgroundColor = [UIColor clearColor];
        self.mandatoryLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.mandatoryLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        self.mandatoryLabel.textAlignment = UITextAlignmentLeft;
        self.mandatoryLabel.text = @"*";
        
        self.titleLabel = [[MXLabel alloc] initWithFrame:CGRectMake(24, 11, 240, 20)];
        self.titleLabel.textColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.minimumFontSize = 10.0;
        self.titleLabel.textAlignment = UITextAlignmentLeft;
        self.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:16.0];
        
       
        
        UIImage *dropImage = [UIImage imageNamed:@"downarrow_right_arrow.png"];
        UIImageView *buttonIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        buttonIcon.contentMode = UIViewContentModeCenter;
        [buttonIcon setImage:dropImage];

        self.dropDownButton = [MXButton buttonWithType:UIButtonTypeCustom];
        
       // [self.dropDownButton setImage:dropImage forState:UIControlStateNormal];
    
//        [self.dropDownButton setFrame:CGRectMake(0, 0, 40, 40)];
//        [self.dropDownButton setBounds:CGRectMake(10, 0, 40, 40)];
        
                [self.dropDownButton setFrame:CGRectMake(16, 33, self.bounds.size.width-32, 40)];
                [self.dropDownButton setBounds:CGRectMake(16, 33, self.bounds.size.width-32, 40)];
        

        //current working
        
        self.dropDownField = [[MXTextField alloc] initWithFrame:CGRectMake(16, 35, self.bounds.size.width-32, 40)];
        
        
        //        self.dropDownField = [[MXTextField alloc] initWithFrame:CGRectMake(144, 6, 169, self.frame.size.height-4)];
        
        
        self.dropDownField.borderStyle = UITextBorderStyleRoundedRect;
        self.dropDownField.returnKeyType = UIReturnKeyDefault;
        self.dropDownField.minimumFontSize = 10.0;
        self.dropDownField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.dropDownField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        self.dropDownField.font = [UIFont fontWithName:@"Helvetica-Light" size:16.0];
        self.dropDownField.adjustsFontSizeToFitWidth = TRUE;
        self.dropDownField.text = textValue;
        self.dropDownField.adjustsFontSizeToFitWidth = YES;
        self.dropDownField.textColor =[UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
       
        
        //set textfield border
        self.dropDownField.layer.masksToBounds=YES;
         self.dropDownField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
         self.dropDownField.layer.cornerRadius=5.0f;
        self.dropDownField.layer.borderWidth= 1.0f;
        [self.dropDownField setRightView:buttonIcon];
        
        [self.dropDownField setRightViewMode:UITextFieldViewModeAlways];
        [self.dropDownField setPlaceholder:@"Select a row.."];
        
     
        
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:mandatoryLabel];
        [self addSubview:dropDownField];
        [self addSubview:titleLabel];
        [self addSubview:dropDownButton];
    }
    return self;
}


- (void)layoutSubviews 
{	
	[super layoutSubviews];		
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
    //[super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}




@end

