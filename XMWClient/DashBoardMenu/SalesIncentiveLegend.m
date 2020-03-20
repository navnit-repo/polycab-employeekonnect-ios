//
//  SalesIncentiveLegend.m
//  QCMSProject
//
//  Created by Pradeep Singh on 2/6/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import "SalesIncentiveLegend.h"

@implementation SalesIncentiveLegend

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(SalesIncentiveLegend*) createInstance
{
    
    SalesIncentiveLegend *view = (SalesIncentiveLegend *)[[[NSBundle mainBundle] loadNibNamed:@"SalesIncentiveLegend" owner:self options:nil] objectAtIndex:0];
    
    return view;
}

@end
