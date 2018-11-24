//
//  CheckBoxGroup.m
//  QCMSProject
//
//  Created by Ashish Tiwari on 19/06/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "CheckBoxGroup.h"

@implementation CheckBoxGroupItem
@synthesize checkBoxGroupButton;
@synthesize titleLabel;
@synthesize isChecked;


-(void) setChecked
{
    isChecked = YES;
    [checkBoxGroupButton setImage:[UIImage imageNamed:@"checkbox-checked.png"] forState:UIControlStateNormal];
    
}


-(void) setUnChecked
{
    isChecked = NO;
    [checkBoxGroupButton setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
}


@end


@implementation CheckBoxGroup

@synthesize elementId;
@synthesize textValue;
@synthesize checkBoxItems;
@synthesize titleLabel;
@synthesize mandatoryLabel;
@synthesize attachedData;



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
		mandatoryLabel.textAlignment = NSTextAlignmentRight;
		mandatoryLabel.text = @"*";
        
        [self.contentView addSubview:mandatoryLabel];
		
        
		titleLabel = [[MXLabel alloc] initWithFrame:CGRectMake(24, 6, 137, 28)];
		titleLabel.textColor = [UIColor colorWithRed:0.227f green:0.227f blue:0.227f alpha:1.0];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
		titleLabel.adjustsFontSizeToFitWidth = YES;
		titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
		
		[self.contentView addSubview:titleLabel];
        
        checkBoxItems = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(IBAction) checkBoxClicked :(id) sender {
    
    MXButton *mxButton  = (MXButton*) sender;
    CheckBoxGroupItem* checkBoxItem = (CheckBoxGroupItem*)mxButton.parent;
    
    if(checkBoxItem.isChecked == NO) {
        checkBoxItem.isChecked = YES;
        [mxButton setImage:[UIImage imageNamed:@"checkbox-checked.png"] forState:UIControlStateNormal];
    } else{
        checkBoxItem.isChecked = NO;
        [mxButton setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    }
}


@end
