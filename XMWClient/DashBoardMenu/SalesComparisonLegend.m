//
//  SalesComparisonLegend.m
//  QCMSProject
//
//  Created by Pradeep Singh on 2/3/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import "SalesComparisonLegend.h"
#import "LayoutClass.h"
@implementation SalesComparisonLegend
@synthesize firstLegend;


+(SalesComparisonLegend*) createInstance
{
    
    SalesComparisonLegend *view = (SalesComparisonLegend *)[[[NSBundle mainBundle] loadNibNamed:@"SalesComparisonLegend" owner:self options:nil] objectAtIndex:0];
    
    
    
    return view;
}

-(void)autoLayout{
    
    [LayoutClass labelLayout:self.constantView1 forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.constantView2 forFontWeight:UIFontWeightRegular];
    
    [LayoutClass setLayoutForIPhone6:self.constantView3];
    [LayoutClass setLayoutForIPhone6:self.constantView4];
    [LayoutClass setLayoutForIPhone6:self.constantView5];
    [LayoutClass setLayoutForIPhone6:self.constantView6];
    
      [LayoutClass labelLayout:self.constantView7 forFontWeight:UIFontWeightBold];
    
}

@end
