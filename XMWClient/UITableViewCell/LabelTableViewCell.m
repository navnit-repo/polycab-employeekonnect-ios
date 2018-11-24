//
//  LabelTableViewCell.m
//  EMSV3CommonMobilet
//
//  Created by Puneet on 01-Apr-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LabelTableViewCell.h"
#import "Styles.h"


@implementation LabelTableViewCell

@synthesize titleLabel,valueLabel,mandatoryLabel;
@synthesize cellKey;

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
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = UITextAlignmentLeft;
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:16.0];
        
        valueLabel = [[MXLabel alloc] initWithFrame:CGRectMake(16, 33, self.bounds.size.width-32, 40)];
//        valueLabel.textColor = [UIColor colorWithRed:0.227f green:0.227f blue:0.227f alpha:1.0];
        valueLabel.backgroundColor = [UIColor clearColor];
        valueLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        valueLabel.lineBreakMode = UILineBreakModeWordWrap;
        valueLabel.minimumFontSize = 10.0;
        valueLabel.adjustsFontSizeToFitWidth = YES;
        valueLabel.numberOfLines = 2;
        valueLabel.textAlignment = UITextAlignmentLeft;
        valueLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:16.0];
        valueLabel.textColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
        
    
        
 
        //set label border
        
        self.valueLabel.layer.masksToBounds=YES;
        self.valueLabel.layer.borderColor= [[UIColor lightGrayColor]CGColor];
        self.valueLabel.layer.borderWidth= 1.0f;
        self.valueLabel.layer.cornerRadius = 5.0f;
        
     //   self.backgroundColor = [Styles formBackgroundColor];
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:mandatoryLabel];
        [self addSubview:titleLabel];
        [self addSubview:valueLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
  //  [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}
@end
