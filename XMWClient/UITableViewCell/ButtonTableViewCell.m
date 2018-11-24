//
//  ButtonTableViewCell.m
//  EMSV3CommonMobilet
//
//  Created by Puneet on 28-Mar-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ButtonTableViewCell.h"


@implementation ButtonTableViewCell


@synthesize button;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *blueImage = [UIImage imageNamed:@"blueButton.png"];
        UIImage *blueButtonImage = [blueImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
        
        button = [[MXButton alloc] init];
        button.backgroundColor = [UIColor colorWithRed:204.0/255 green:41.0/255 blue:43.0/255 alpha:1.0];
      //  [button setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1.0] forState: UIControlStateNormal];
        button.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5.0f;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [button setFrame:CGRectMake( 16, 20, self.bounds.size.width-32, 40)];
            button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        }
        else
            [button setFrame:CGRectMake( 16, 20, self.bounds.size.width-32, 40)];
   

        self.alpha = 1.0f;
        [self addSubview:button];
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
  //  [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}

- (void)layoutSubviews 
{	
	[super layoutSubviews];		
}


@end
