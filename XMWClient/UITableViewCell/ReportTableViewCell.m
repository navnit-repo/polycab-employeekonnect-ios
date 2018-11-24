//
//  ReportTableViewCell.m
//  EMSV3CommonMobilet
//
//  Created by Puneet on 27-Apr-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ReportTableViewCell.h"

//#import "MitrString.h"


@implementation ReportTableViewCell


@synthesize isAccessory;
@synthesize titleArray,valueArray;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) 
	{
        // Initialization code
		titleArray = [[NSMutableArray alloc] init];
		valueArray = [[NSMutableArray alloc] init];
		//		self.contentView.backgroundColor = [UIColor colorWithRed:0.768f green:0.77f blue:1.0 alpha:1.0];
		self.backgroundColor	= [UIColor colorWithRed:0.768f green:0.77f blue:1.0 alpha:1.0];
    }
    return self;
}

- (void)layoutSubviews 
{			
	int label_y				= 0;
	NSString *titleText;
	NSString *valueText;
	CGSize titleConstraintSize;
	CGSize valueConstraintSize;
	UIFont *titleFont		= [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
	UIFont *valueFont		= [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
	
	for (int i = 0; i < [titleArray count]; i++) 
	{
		UILabel *titleLabel			= [self newLabelWithPrimaryColor:[UIColor colorWithRed:0.227f green:0.227f blue:0.227f alpha:1.0f] selectedColor:[UIColor whiteColor] fontSize:13.0 bold:YES];
		titleLabel.textAlignment	= UITextAlignmentLeft;
		
		label_y = label_y + 2;
		
		titleText = [titleArray objectAtIndex:i];				
		titleConstraintSize = CGSizeMake(130, MAXFLOAT);
		CGSize titleLabelSize = [titleText sizeWithFont:titleFont constrainedToSize:titleConstraintSize lineBreakMode:UILineBreakModeWordWrap];
		
		titleLabel.frame	= CGRectMake(3, label_y, 130, titleLabelSize.height);
		titleLabel.text		= titleText;			
		[self.contentView addSubview:titleLabel];
		//[titleLabel release];
		
		UILabel *valueLabel			= [self newLabelWithPrimaryColor:[UIColor colorWithRed:0.254f green:0.0f blue:0.0f alpha:1.0f] selectedColor:[UIColor whiteColor] fontSize:13.0 bold:NO];
		valueLabel.textAlignment	= UITextAlignmentRight;
		
		valueText = (NSString *)[valueArray objectAtIndex:i];
		valueConstraintSize = CGSizeMake(140, MAXFLOAT);
		CGSize valueLabelSize = [valueText sizeWithFont:valueFont constrainedToSize:valueConstraintSize lineBreakMode:UILineBreakModeWordWrap];
		
		valueLabel.frame	= CGRectMake(141, label_y, 140, valueLabelSize.height);
		valueLabel.text		= valueText;			
		[self.contentView addSubview:valueLabel];
		//[valueLabel release];
		
		label_y = label_y + MAX(titleLabelSize.height,valueLabelSize.height) + 3;
	}
	
	[super layoutSubviews];		
}

- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold
{
    UIFont *font;
    if (bold) {
        font = [UIFont fontWithName:@"Helvetica-Bold" size:fontSize];
    } else {
        font = [UIFont fontWithName:@"Helvetica-Bold" size:fontSize];
    }
    
    /*
	 Views are drawn most efficiently when they are opaque and do not have a clear background, so set these defaults.  To show selection properly, however, the views need to be transparent (so that the selection color shows through).  This is handled in setSelected:animated:.
	 */
	UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	newLabel.backgroundColor = [UIColor colorWithRed:0.768f green:0.77f blue:1.0 alpha:1.0];
	newLabel.backgroundColor = [UIColor clearColor];
	newLabel.opaque = YES;
	newLabel.textColor = primaryColor;
	newLabel.lineBreakMode	= UILineBreakModeWordWrap;
	newLabel.numberOfLines	= 0;
	
	newLabel.highlightedTextColor = selectedColor;
	newLabel.font = font;
	
	return newLabel;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
	//	for(UIView *view in self.contentView.subviews)
	//	{
	//		if ([view isKindOfClass:[UIView class]]) 
	//			[view removeFromSuperview];
	//	}
	
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


@end
