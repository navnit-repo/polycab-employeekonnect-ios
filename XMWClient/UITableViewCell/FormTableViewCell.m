//
//  FormTableViewCell.m
//  EMSV3CommonMobilet
//
//  Created by Puneet on 17-Mar-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FormTableViewCell.h"
#import "Styles.h"


@implementation FormTableViewCell


@synthesize titleLabel,mandatoryLabel;

@synthesize cellTextField;

- (instancetype)initWithFrame:(CGRect)frame{
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
        
        titleLabel = [[MXLabel alloc] initWithFrame:CGRectMake(24, 11, 137, 15)];
        titleLabel.textColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        titleLabel.minimumFontSize = 10.0;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.textAlignment = UITextAlignmentLeft;
        titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:16.0];
        
        //current change working
        cellTextField = [[MXTextField alloc] initWithFrame:CGRectMake(16, 33, self.bounds.size.width-32, 40)];
        //        cellTextField = [[MXTextField alloc] initWithFrame:CGRectMake(144, 6, 169, 31)];
        
        
        
        
        cellTextField.borderStyle = UITextBorderStyleRoundedRect;
        cellTextField.returnKeyType = UIReturnKeyDefault;
        cellTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        cellTextField.adjustsFontSizeToFitWidth = TRUE;
        cellTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        cellTextField.minimumFontSize = 10;
        cellTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        cellTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        cellTextField.font = [UIFont systemFontOfSize:16.0];
        [cellTextField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
        cellTextField.adjustsFontSizeToFitWidth = YES;
        cellTextField.textColor =[UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
        
        
        //set textfield border
        
        self.cellTextField.layer.masksToBounds=YES;
        self.cellTextField.layer.cornerRadius = 5.0f;
        self.cellTextField.layer.borderColor= [[UIColor lightGrayColor]CGColor];
        self.cellTextField.layer.borderWidth= 1.0f;
        
        
//        self.backgroundColor = [Styles formBackgroundColor];
        self.backgroundColor = [UIColor clearColor];
        
        
        [self addSubview:mandatoryLabel];
        [self addSubview:titleLabel];
        [self addSubview:cellTextField];
        
    }
    return  self;
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

-(IBAction) textFieldDone:(id) sender
{
	[sender resignFirstResponder];
	
}



@end
