//
//  CreateDetailsCell.m
//  XMWClient
//
//  Created by dotvikios on 24/08/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "CreateDetailsCell.h"
#import "LayoutClass.h"
#import "detailsTableView.h"
@implementation CreateDetailsCell
{
    float creditLimit;
    float remaining;
    float payable;
    
    float user1;
    float user2;
    float user3;
    float user4;
    float user5;
    
    float totalAmmount;
    
    
}
@synthesize creditDetailsDisplayNameLbl;
+(CreateDetailsCell*) createInstance

{
    CreateDetailsCell *view = (CreateDetailsCell *)[[[NSBundle mainBundle] loadNibNamed:@"CreateDetailsCell" owner:self options:nil] objectAtIndex:0];
    
    return view;
}
-(void)autoLayout{
    [LayoutClass setLayoutForIPhone6:self.mainView];
    [LayoutClass setLayoutForIPhone6:self.pieChart];
    [LayoutClass labelLayout:self.creditDetailsDisplayNameLbl forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.constantLbl1 forFontWeight:UIFontWeightBold];
    
    
    [LayoutClass setLayoutForIPhone6:self.constantView1];
    [LayoutClass setLayoutForIPhone6:self.constantView2];
    [LayoutClass setLayoutForIPhone6:self.constantView3];
    [LayoutClass setLayoutForIPhone6:self.constantView4];
    [LayoutClass setLayoutForIPhone6:self.constantView5];
    
    
    [LayoutClass labelLayout:self.user1 forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.user2 forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.user3 forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.user4 forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.user5 forFontWeight:UIFontWeightRegular];
    
    [LayoutClass labelLayout:self.value1 forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.value2 forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.value3 forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.value4 forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.value5 forFontWeight:UIFontWeightBold];
    
    
    
 
}
- (void)configure:(NSArray *)dataArray{
    
    [self autoLayout];
    
    NSLog(@"Data : %@",dataArray);
    NSString *rupee=@"\u20B9";
    NSString *allData = [self formateCurrency:[[dataArray objectAtIndex:0]objectAtIndex:2]];
    creditDetailsDisplayNameLbl.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:allData];
    

    
    
    user1 = [[[dataArray objectAtIndex:1]objectAtIndex:2] floatValue];
    user2 = [[[dataArray objectAtIndex:2]objectAtIndex:2] floatValue];
    user3 = [[[dataArray objectAtIndex:3]objectAtIndex:2] floatValue];
    user4 = [[[dataArray objectAtIndex:4]objectAtIndex:2] floatValue];
    user5 = [[[dataArray objectAtIndex:5]objectAtIndex:2] floatValue];
    
//    if (user1<=0) {
//        user1=0.0;
//    }
//    if (user2<=0) {
//        user2=0.0;
//    }
//    if (user3<=0) {
//        user3=0.0;
//    }
//    if (user4<=0) {
//        user4=0.0;
//    }
//    if (user5<=0) {
//        user5=0.0;
//    }
    
        totalAmmount = user1+user2+user3+user4+user5;
    


    self.user1.text = [@"RegID "stringByAppendingString:[[dataArray objectAtIndex:1]objectAtIndex:0]];
    self.user2.text = [@"RegID "stringByAppendingString:[[dataArray objectAtIndex:2]objectAtIndex:0]];
    self.user3.text = [@"RegID "stringByAppendingString:[[dataArray objectAtIndex:3]objectAtIndex:0]];
    self.user4.text = [@"RegID "stringByAppendingString:[[dataArray objectAtIndex:4]objectAtIndex:0]];
    self.user5.text = [@"RegID "stringByAppendingString:[[dataArray objectAtIndex:5]objectAtIndex:0]];
    
    
    self.value1.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:[self formateCurrency:[NSString stringWithFormat:@"%f", user1]]];
    
    self.value2.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:[self formateCurrency:[NSString stringWithFormat:@"%f", user2]]];
    self.value3.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:[self formateCurrency:[NSString stringWithFormat:@"%f", user3]]];
    self.value4.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:[self formateCurrency:[NSString stringWithFormat:@"%f", user4]]];
    self.value5.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:[self formateCurrency:[NSString stringWithFormat:@"%f", user5]]];
    
    
    
    
    
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
    return 5;
}
//Specify the Value for each sector

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    
    CGFloat value = 0.0;
    if (totalAmmount!=0) {
        if(index%5 == 0)
        {   value = ((user1 /totalAmmount) * 100);
           
            
//            NSString *rupee=@"\u20B9";
//            NSString *used = [self formateCurrency:[NSString stringWithFormat:@"%f",(creditLimit - remaining)]];
//            displayUsedLbl.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:used];
            
            
            
        }
        if(index%5 == 1)
        {
           
            value = ((user2 /totalAmmount) * 100);
//            NSString *rupee=@"\u20B9";
//            NSString *remain = [self formateCurrency:[NSString stringWithFormat:@"%f",(creditLimit-payable)]];
//            displayRemainingLbl.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:remain];
        }
        
        
        if(index%5 == 2)
        {
            
            value = ((user3 /totalAmmount) * 100);
            //            NSString *rupee=@"\u20B9";
            //            NSString *remain = [self formateCurrency:[NSString stringWithFormat:@"%f",(creditLimit-payable)]];
            //            displayRemainingLbl.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:remain];
        }
        
        if(index%5 == 3)
        {
            
            value = ((user4 /totalAmmount) * 100);
            //            NSString *rupee=@"\u20B9";
            //            NSString *remain = [self formateCurrency:[NSString stringWithFormat:@"%f",(creditLimit-payable)]];
            //            displayRemainingLbl.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:remain];
        }
        if(index%5 == 4)
        {
            
            value = ((user5 /totalAmmount) * 100);
            //            NSString *rupee=@"\u20B9";
            //            NSString *remain = [self formateCurrency:[NSString stringWithFormat:@"%f",(creditLimit-payable)]];
            //            displayRemainingLbl.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:remain];
        }
        
        
    }
    
    
    
    
//    else{
//        UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(0, self.pieChart.frame.size.height/2, self.pieChart.frame.size.width, 0)];
//        [label setBackgroundColor:[UIColor clearColor]];
//        [label setTextColor: [UIColor colorWithRed:(204.0/255) green:(43.0/255) blue:(43.0/255) alpha:(1)]];
//        [label setFont:[UIFont fontWithName:@"Helvetica-Light" size:14.0]];
//        [label setText: @"No Data Available"];
//
//        [label setNumberOfLines: 0];
//        [label sizeToFit];
//        [label setCenter: CGPointMake(self.pieChart.center.x, label.center.y)];
//        [self.pieChart addSubview:label];
//
////        [creditDetailsPriceLbl removeFromSuperview];
////        [overdueLbl removeFromSuperview];
////        [self.creditHideAccordingTOCondition removeFromSuperview];
////        [self.overDueHideAccordingTOCondition removeFromSuperview];
//
//
//        [displayRemainingLbl removeFromSuperview];
//        [displayUsedLbl removeFromSuperview];
//        [self.used removeFromSuperview];
//        [self.usedView1 removeFromSuperview];
//        [self.remaining removeFromSuperview];
//        [self.remainingView1 removeFromSuperview];
//
//    }
    
    return value;
}

//Specify color for each sector
- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    UIColor *color;
    if(index%5 == 0)
    {
        //color = [UIColor colorWithRed:(49.0/255) green:(221.0/255) blue:(179.0/255) alpha:(1)];
        color = [UIColor redColor];
        
    }
    if(index%5 == 1)
    {
      //  color =[UIColor colorWithRed:(79.0/255) green:(121.0/255) blue:(219.0/255) alpha:(1)];
        color = [UIColor yellowColor];
    }
    
    if(index%5 == 2)
    {
     //   color = [UIColor colorWithRed:(90.0/255) green:(221.0/255) blue:(179.0/255) alpha:(1)];
        color = [UIColor blueColor];
    }
    if(index%5 == 3)
    {
       // color = [UIColor colorWithRed:(160.0/255) green:(221.0/255) blue:(179.0/255) alpha:(1)];
        color = [UIColor darkGrayColor];
    }
    if(index%5 == 4)
    {
       // color = [UIColor colorWithRed:(106.0/255) green:(221.0/255) blue:(179.0/255) alpha:(1)];
        color = [UIColor brownColor];
    }
    
    
    return color;
}


@end
