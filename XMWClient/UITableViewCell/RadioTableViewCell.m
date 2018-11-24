//
//  RadioTableViewCell.m
//  EMSV3CommonMobilet
//
//  Created by Puneet on 09-May-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RadioTableViewCell.h"
#import "Styles.h"


@implementation RadioTableViewCell


@synthesize titleLabel;
@synthesize radioGroup;


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        titleLabel = [[MXLabel alloc] initWithFrame:CGRectMake(7, 6, 137, 28)];
        titleLabel.textColor = [UIColor colorWithRed:0.227f green:0.227f blue:0.227f alpha:1.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        titleLabel.minimumFontSize = 10.0;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.textAlignment = UITextAlignmentLeft;
        titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
        
        //    radioGroup = [[RadioGroup alloc]initWithFrame:<#(CGRect)#>];
        
        
        
        
        //radioButton = [[MXButton alloc] init];
        //[radioButton setFrame:CGRectMake( 30.0f, 15.0f, 24.0f, 24.0f)];
        //[radioButton setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
        
        
        //self.contentView.backgroundColor = [Styles formBackgroundColor];
        
        [self addSubview:titleLabel];
        //    [self.contentView addSubview:radioButton];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
    //[super setSelected:selected animated:animated];
	// Configure the view for the selected state
	if(selected)
	{
		titleLabel.textColor = [UIColor redColor];
		//[radioButton setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
	}
}



@end
