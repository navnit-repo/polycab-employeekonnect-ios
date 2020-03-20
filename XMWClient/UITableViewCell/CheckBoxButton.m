//
//  CheckBoxButton.m
//  QCMSProject
//
//  Created by Ashish Tiwari on 13/06/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "CheckBoxButton.h"

@implementation CheckBoxButton


@synthesize elementId;
@synthesize textValue;

@synthesize checkBoxField,checkBoxButton;
@synthesize titleLabel,mandatoryLabel;


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        mandatoryLabel = [[MXLabel alloc] initWithFrame:CGRectMake(16, 11, 8, 16)];
        mandatoryLabel.textColor = [UIColor colorWithRed:0.968f green:0.0f blue:0.0f alpha:1.0];
        mandatoryLabel.backgroundColor = [UIColor clearColor];
        mandatoryLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [mandatoryLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        mandatoryLabel.textAlignment = UITextAlignmentLeft;
        mandatoryLabel.text = @"*";
        
        self.titleLabel = [[MXLabel alloc] initWithFrame:CGRectMake(24, 11, self.bounds.size.width-120, 30)];
        self.titleLabel.textColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.numberOfLines = 3;
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.minimumFontSize = 10.0;
        self.titleLabel.textAlignment = UITextAlignmentLeft;
        self.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:11.0];

    
        
        checkBoxButton = [MXButton buttonWithType:UIButtonTypeCustom];
        
        [checkBoxButton setFrame:CGRectMake( self.bounds.size.width-130, 6.0f, 200.0f, 40.0f)];
        [checkBoxButton setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        checkBoxButton.parent = self;
        
        [self addSubview:mandatoryLabel];
        [self addSubview:checkBoxButton];
        [self addSubview:titleLabel];
    }
    return self;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
   // [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(IBAction) checkBoxClicked :(id) sender {
    
    MXButton *mxButton  = (MXButton*) sender;
    CheckBoxButton* checkBoxCell = (CheckBoxButton*)mxButton.parent;
    
    
    if(checkBoxCell.isChecked ==NO){
        checkBoxCell.isChecked =YES;
        
        //[checkBoxCell setFrame:CGRectMake( 190.0f, 6.0f, 169.0f, 31.0f)];
        [checkBoxCell.checkBoxButton setImage:[UIImage imageNamed:@"checkedbox.png"] forState:UIControlStateNormal];
    }else{
        checkBoxCell.isChecked =NO;
        
        //[checkBoxButton setFrame:CGRectMake( 190.0f, 6.0f, 169.0f, 31.0f)];
        [checkBoxCell.checkBoxButton setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    }
}

-(void) setChecked
{
    self.isChecked = YES;
    
    //[checkBoxCell setFrame:CGRectMake( 190.0f, 6.0f, 169.0f, 31.0f)];
    [self.checkBoxButton setImage:[UIImage imageNamed:@"checkbox-checked.png"] forState:UIControlStateNormal];
    
}

-(void) setUnchecked
{
    self.isChecked = NO;
    
    //[checkBoxButton setFrame:CGRectMake( 190.0f, 6.0f, 169.0f, 31.0f)];
    [self.checkBoxButton setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    
}

@end
