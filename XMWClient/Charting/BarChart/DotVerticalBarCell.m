//
//  DotVerticalBarCell.m
//  QCMSProject
//
//  Created by Pradeep Singh on 1/16/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import "DotVerticalBarCell.h"

@implementation DotVerticalBarCell

- (void)awakeFromNib {
    // Initialization code
}


+(DotVerticalBarCell*) createInstance
{
    
    DotVerticalBarCell *view = (DotVerticalBarCell *)[[[NSBundle mainBundle] loadNibNamed:@"DotVerticalBarCell" owner:self options:nil] objectAtIndex:0];
    
    return view;
}


-(void)updateLayout
{
    CGRect bottomPartFrame = self.bottomAxisPartView.frame;
    self.bottomAxisPartView.frame = CGRectMake(bottomPartFrame.origin.x, self.frame.size.height - bottomPartFrame.size.height, bottomPartFrame.size.width, bottomPartFrame.size.height);

    
    CGRect barFrame = self.barView.frame;
    self.barView.frame = CGRectMake(barFrame.origin.x, self.frame.size.height - barFrame.size.height - bottomPartFrame.size.height, barFrame.size.width, barFrame.size.height);    
    
}

@end
