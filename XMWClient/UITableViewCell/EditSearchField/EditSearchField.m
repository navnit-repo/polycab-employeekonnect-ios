//
//  EditSearchField.m
//  QCMSProject
//
//  Created by Pradeep Singh on 11/30/16.
//  Copyright © 2016 dotvik. All rights reserved.
//

#import "EditSearchField.h"
#import "MXButton.h"

@interface EditSearchField ()
{
    DotFormElement* dotFormElement;
    
}

@property (strong, nonatomic) UIView* rightView;

@end


@implementation EditSearchField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



-(void) configureViewCellFor:(DotFormElement*) formElement
{
    dotFormElement = formElement;
    
    
    UIView* upperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    upperView.backgroundColor = [UIColor clearColor];
    
    // Initialization code
    self.mandatoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 11, 8, 16)];
    self.mandatoryLabel.textColor = [UIColor colorWithRed:0.968f green:0.0f blue:0.0f alpha:1.0];
    self.mandatoryLabel.backgroundColor = [UIColor clearColor];
    self.mandatoryLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.mandatoryLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    self.mandatoryLabel.textAlignment = NSTextAlignmentLeft;
    self.mandatoryLabel.text = @"*";
    [upperView addSubview:self.mandatoryLabel];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 137, self.frame.size.height - 4)];
    self.titleLabel.textColor = [UIColor colorWithRed:0.227f green:0.227f blue:0.227f alpha:1.0];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
    [upperView addSubview:self.titleLabel];
    
    
    if([dotFormElement isOptionalBool])
        self.mandatoryLabel.hidden	= YES;
    else
        self.mandatoryLabel.hidden	= NO;
    
    self.titleLabel.text = dotFormElement.displayText;
    
    
    self.rightView = [[UIView alloc] initWithFrame:CGRectMake( 144, 6, 169, self.frame.size.height-8)];
    self.rightView.backgroundColor = [UIColor clearColor];
    // [self.rightView.layer setCornerRadius:5.0f];
    // [self.rightView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    // [self.rightView.layer setBorderWidth:0.5f];
    
    self.editText = [[MXTextField alloc] initWithFrame:CGRectMake(2, 6, 167, 30)];
    self.editText.borderStyle = UITextBorderStyleRoundedRect;
    self.editText.returnKeyType = UIReturnKeyDefault;
    self.editText.minimumFontSize = 10.0;
    self.editText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.editText.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.editText.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    self.editText.adjustsFontSizeToFitWidth = YES;
    [self.editText setRightViewMode:UITextFieldViewModeAlways];

    UIImage *iconImage = [UIImage imageNamed:@"Icon_search"];
    
    self.searchButton = [MXButton buttonWithType:UIButtonTypeCustom];
    self.searchButton.frame = CGRectMake( 0.0f, 0.0f, self.frame.size.height-8, self.frame.size.height-8);
    self.searchButton.backgroundColor = [UIColor clearColor];
    [self.searchButton setImage:iconImage forState:UIControlStateNormal];
    self.searchButton.elementId = dotFormElement.elementId;
    
    [self.editText setRightView:self.searchButton];
    [self.rightView addSubview:self.editText];
    
    [upperView addSubview:self.rightView];
    
    [self addSubview:upperView];
    
}


@end
