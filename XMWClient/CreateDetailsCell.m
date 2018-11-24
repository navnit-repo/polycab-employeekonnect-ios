//
//  CreateDetailsCell.m
//  XMWClient
//
//  Created by dotvikios on 24/08/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "CreateDetailsCell.h"
#import "LayoutClass.h"

@implementation CreateDetailsCell
{
    float creditLimit;
    float remaining;
    float payable;
    
}
@synthesize creditDetailsDisplayNameLbl,creditDetailsPriceLbl,overdueLbl;
@synthesize displayUsedLbl,displayRemainingLbl;
+(CreateDetailsCell*) createInstance

{
    CreateDetailsCell *view = (CreateDetailsCell *)[[[NSBundle mainBundle] loadNibNamed:@"CreateDetailsCell" owner:self options:nil] objectAtIndex:0];
    
    return view;
}
-(void)autoLayout{
    [LayoutClass setLayoutForIPhone6:self.mainView];
    [LayoutClass setLayoutForIPhone6:self.pieChart];
    [LayoutClass setLayoutForIPhone6:self.usedView1];
    [LayoutClass setLayoutForIPhone6:self.remainingView1];
    [LayoutClass labelLayout:self.constantLbl1 forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.constantLbl2 forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.constantLbl3 forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.constantLbl4 forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.constantLbl5 forFontWeight:UIFontWeightRegular];
    
    [LayoutClass labelLayout:self.creditDetailsDisplayNameLbl forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.creditDetailsPriceLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.overdueLbl forFontWeight:UIFontWeightRegular];
    
     [LayoutClass labelLayout:self.displayUsedLbl forFontWeight:UIFontWeightRegular];
     [LayoutClass labelLayout:self.displayRemainingLbl forFontWeight:UIFontWeightRegular];
    
 
}
- (void)configure:(NSArray *)dataArray{
    
    [self autoLayout];
    
    NSLog(@"Data : %@",dataArray);
    
    creditDetailsDisplayNameLbl.text = [dataArray objectAtIndex:1];
    
    NSString *rupee=@"\u20B9";
    NSString *credit = [self formateCurrency:[dataArray objectAtIndex:2]];
    creditDetailsPriceLbl.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:credit];

    NSString *check = [dataArray objectAtIndex:5];
    NSLog(@"overduew :%@",check);
    if (check==NULL) {
        NSString *overdue = [self formateCurrency:@"0"];
        overdueLbl.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:overdue];
    }
    else if ([check isKindOfClass:[NSNull class]]){
        NSString *overdue = [self formateCurrency:@"0"];
        overdueLbl.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:overdue];
    }
    else{
        NSString *overdue = [self formateCurrency:[dataArray objectAtIndex:5]];
        overdueLbl.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:overdue];
    }
    creditLimit = [[dataArray objectAtIndex:2] floatValue];
    remaining =  [[dataArray objectAtIndex:3] floatValue];
    payable =    [[dataArray objectAtIndex:4] floatValue];
    
    
    
    
    float viewWidth = self.pieChart.bounds.size.width / 2;
    float viewHeight = self.pieChart.bounds.size.height / 2;
    [self.pieChart setDelegate:self];
    [self.pieChart setDataSource:self];
    [self.pieChart setStartPieAngle:M_PI_2];
    [self.pieChart setAnimationSpeed:1.5];
    [self.pieChart setLabelColor:[UIColor whiteColor]];
    [self.pieChart setLabelShadowColor:[UIColor blackColor]];
    [self.pieChart setShowPercentage:NO];
    [self.pieChart setUserInteractionEnabled:NO];
    [self.pieChart setPieBackgroundColor:[UIColor whiteColor]];
    
 
    //To make the chart at the center of view
    [self.pieChart setPieCenter:CGPointMake(self.pieChart.bounds.origin.x + viewWidth, self.pieChart.bounds.origin.y + viewHeight)];
    self.pieChart.clipsToBounds = YES;
    
    //Method to display the pie chart with values.
    [self.pieChart reloadData];
    
    
    
}

-(NSString*)formateCurrency:(NSString *)actualAmount{
    
    float shortenedAmount = [actualAmount floatValue];
    NSString *suffix = @"";
    float currency = [actualAmount floatValue];
//    if(currency >= 10000000.0f) {
//        suffix = @"Cr";
//        shortenedAmount /= 10000000.0f;
//    }
  //  else
        if(currency >= 100000.0f) {
        suffix = @"L";
        shortenedAmount /= 100000.0f;
    }
//    else if(currency >= 1000.0f) {
//        suffix = @"K";
//        shortenedAmount /= 1000.0f;
//    }
//    
    NSString *requiredString = [NSString stringWithFormat:@"%0.2f%@", shortenedAmount, suffix];
    return requiredString;
    
}

//Specify the number of Sectors in the chart
- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return 2;
}
//Specify the Value for each sector
- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    
    CGFloat value = 0.0;
    if (creditLimit!=0) {
        if(index%2 == 0)
        {   value = ((payable /creditLimit) * 100);
           
            
            NSString *rupee=@"\u20B9";
            NSString *used = [self formateCurrency:[NSString stringWithFormat:@"%f",(creditLimit - remaining)]];
            displayUsedLbl.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:used];
            
            
            
        }
        if(index%2 == 1)
        {
           
            value = ((remaining /creditLimit) * 100);
            NSString *rupee=@"\u20B9";
            NSString *remain = [self formateCurrency:[NSString stringWithFormat:@"%f",(creditLimit-payable)]];
            displayRemainingLbl.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:remain];
        }
    }
    
    
    else{
        UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(0, self.pieChart.frame.size.height/2, self.pieChart.frame.size.width, 0)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor: [UIColor colorWithRed:(204.0/255) green:(43.0/255) blue:(43.0/255) alpha:(1)]];
        [label setFont:[UIFont fontWithName:@"Helvetica-Light" size:14.0]];
        [label setText: @"No Data Available"];
        
        [label setNumberOfLines: 0];
        [label sizeToFit];
        [label setCenter: CGPointMake(self.pieChart.center.x, label.center.y)];
        [self.pieChart addSubview:label];
        
//        [creditDetailsPriceLbl removeFromSuperview];
//        [overdueLbl removeFromSuperview];
//        [self.creditHideAccordingTOCondition removeFromSuperview];
//        [self.overDueHideAccordingTOCondition removeFromSuperview];
        
        
        [displayRemainingLbl removeFromSuperview];
        [displayUsedLbl removeFromSuperview];
        [self.used removeFromSuperview];
        [self.usedView1 removeFromSuperview];
        [self.remaining removeFromSuperview];
        [self.remainingView1 removeFromSuperview];
        
    }
    
    return value;
}

//Specify color for each sector
- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    UIColor *color;
    if(index%2 == 0)
    {
        color = [UIColor colorWithRed:(49.0/255) green:(221.0/255) blue:(179.0/255) alpha:(1)];
    }
    if(index%2 == 1)
    {
        color =[UIColor colorWithRed:(79.0/255) green:(121.0/255) blue:(219.0/255) alpha:(1)];
    }
    return color;
}


@end
