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
    
    int numberOfTotal;
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
    NSLog(@"Data count : %lu",(unsigned long)dataArray.count);
    NSString *rupee=@"\u20B9";
    NSString *allData = [self formateCurrency:[[dataArray objectAtIndex:0]objectAtIndex:2]];
    creditDetailsDisplayNameLbl.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:allData];
    if (dataArray.count >=6) {
        numberOfTotal =5;
        
        user1 = [[[dataArray objectAtIndex:1]objectAtIndex:2] floatValue];
        user2 = [[[dataArray objectAtIndex:2]objectAtIndex:2] floatValue];
        user3 = [[[dataArray objectAtIndex:3]objectAtIndex:2] floatValue];
        user4 = [[[dataArray objectAtIndex:4]objectAtIndex:2] floatValue];
        user5 = [[[dataArray objectAtIndex:5]objectAtIndex:2] floatValue];
        totalAmmount = user1+user2+user3+user4+user5;
        
        
        
        self.user1.text = [[dataArray objectAtIndex:1]objectAtIndex:0];
        self.user2.text = [[dataArray objectAtIndex:2]objectAtIndex:0];
        self.user3.text = [[dataArray objectAtIndex:3]objectAtIndex:0];
        self.user4.text = [[dataArray objectAtIndex:4]objectAtIndex:0];
        self.user5.text = [[dataArray objectAtIndex:5]objectAtIndex:0];
        
        
        self.value1.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:[self formateCurrency:[NSString stringWithFormat:@"%f", user1]]];
        
        self.value2.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:[self formateCurrency:[NSString stringWithFormat:@"%f", user2]]];
        self.value3.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:[self formateCurrency:[NSString stringWithFormat:@"%f", user3]]];
        self.value4.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:[self formateCurrency:[NSString stringWithFormat:@"%f", user4]]];
        self.value5.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:[self formateCurrency:[NSString stringWithFormat:@"%f", user5]]];
    }
    
    
    if (dataArray.count ==1) {
        numberOfTotal=0;
        UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(0, self.mainView.frame.size.height/2, self.mainView.frame.size.width, 0)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor: [UIColor colorWithRed:(204.0/255) green:(43.0/255) blue:(43.0/255) alpha:(1)]];
        [label setFont:[UIFont fontWithName:@"Helvetica-Light" size:14.0]];
        [label setText: @"No Data Available"];
        
        [label setNumberOfLines: 0];
        [label sizeToFit];
        [label setCenter: CGPointMake(self.mainView.center.x, label.center.y)];
        [self.mainView addSubview:label];
        
        [self.pieChart removeFromSuperview];
        
        [self.constantView1 removeFromSuperview];
        [self.constantView2 removeFromSuperview];
        [self.constantView3 removeFromSuperview];
        [self.constantView4 removeFromSuperview];
        [self.constantView5 removeFromSuperview];
        
        
    }
    
    if (dataArray.count <6 && dataArray.count >1) {
       
        //numberOfTotal
        if (dataArray.count ==5) {
            numberOfTotal=4;
            
            user1 = [[[dataArray objectAtIndex:1]objectAtIndex:2] floatValue];
            user2 = [[[dataArray objectAtIndex:2]objectAtIndex:2] floatValue];
            user3 = [[[dataArray objectAtIndex:3]objectAtIndex:2] floatValue];
            user4 = [[[dataArray objectAtIndex:4]objectAtIndex:2] floatValue];
            
            totalAmmount = user1+user2+user3+user4;
            
            
            self.user1.text = [[dataArray objectAtIndex:1]objectAtIndex:0];
            self.user2.text = [[dataArray objectAtIndex:2]objectAtIndex:0];
            self.user3.text = [[dataArray objectAtIndex:3]objectAtIndex:0];
            self.user4.text = [[dataArray objectAtIndex:4]objectAtIndex:0];
            
            
            
            self.value1.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:[self formateCurrency:[NSString stringWithFormat:@"%f", user1]]];
            
            self.value2.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:[self formateCurrency:[NSString stringWithFormat:@"%f", user2]]];
            self.value3.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:[self formateCurrency:[NSString stringWithFormat:@"%f", user3]]];
            self.value4.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:[self formateCurrency:[NSString stringWithFormat:@"%f", user4]]];
            
            
            [self.constantView5 removeFromSuperview];
            
            
            
        }
        if (dataArray.count ==4) {
            numberOfTotal=3;
            
            user1 = [[[dataArray objectAtIndex:1]objectAtIndex:2] floatValue];
            user2 = [[[dataArray objectAtIndex:2]objectAtIndex:2] floatValue];
            user3 = [[[dataArray objectAtIndex:3]objectAtIndex:2] floatValue];
            
            totalAmmount = user1+user2+user3;
            
            
            self.user1.text = [[dataArray objectAtIndex:1]objectAtIndex:0];
            self.user2.text = [[dataArray objectAtIndex:2]objectAtIndex:0];
            self.user3.text = [[dataArray objectAtIndex:3]objectAtIndex:0];
            
            self.value1.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:[self formateCurrency:[NSString stringWithFormat:@"%f", user1]]];
            
            self.value2.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:[self formateCurrency:[NSString stringWithFormat:@"%f", user2]]];
            self.value3.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:[self formateCurrency:[NSString stringWithFormat:@"%f", user3]]];
            
            
            
            [self.constantView4 removeFromSuperview];
            [self.constantView5 removeFromSuperview];
            
        }
        if (dataArray.count ==3) {
            numberOfTotal=2;
            user1 = [[[dataArray objectAtIndex:1]objectAtIndex:2] floatValue];
            user2 = [[[dataArray objectAtIndex:2]objectAtIndex:2] floatValue];
            totalAmmount = user1+user2;
            
            
            
            
            self.user1.text = [[dataArray objectAtIndex:1]objectAtIndex:0];
            self.user2.text = [[dataArray objectAtIndex:2]objectAtIndex:0];
            
            self.value1.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:[self formateCurrency:[NSString stringWithFormat:@"%f", user1]]];
            
            self.value2.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:[self formateCurrency:[NSString stringWithFormat:@"%f", user2]]];
            
            
            [self.constantView3 removeFromSuperview];
            [self.constantView4 removeFromSuperview];
            [self.constantView5 removeFromSuperview];
            
            
            
        }
        if (dataArray.count ==2) {
            numberOfTotal=1;
            user1 = [[[dataArray objectAtIndex:1]objectAtIndex:2] floatValue];
            totalAmmount = user1;
            
            
            self.user1.text = [[dataArray objectAtIndex:1]objectAtIndex:0];
            self.value1.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:[self formateCurrency:[NSString stringWithFormat:@"%f", user1]]];
            
            
            
            [self.constantView2 removeFromSuperview];
            [self.constantView3 removeFromSuperview];
            [self.constantView4 removeFromSuperview];
            [self.constantView5 removeFromSuperview];
            
        }
        
    }
    [self configurePieView];
}
-(void)configurePieView
{
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
    suffix = @"Cr";
    shortenedAmount /=100.0f;
    
    //    if(currency >= 10000000.0f) {
    //        suffix = @"Cr";
    //        shortenedAmount /= 10000000.0f;
    //    }
    //    else if(currency >= 100000.0f) {
    //        suffix = @"Cr";
    //        shortenedAmount /= 100000.0f;
    //    }
    //    else if(currency >= 1000.0f) {
    //        suffix = @"K";
    //        shortenedAmount /= 1000.0f;
    //    }
    
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setPositiveFormat:@"##,##,###.#"];
    NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithFloat:shortenedAmount]];
    NSString *requiredString = [formatted stringByAppendingString:suffix];
    
    //  NSString *requiredString = [NSString stringWithFormat:@"%0.1f%@", shortenedAmount, suffix];
    return requiredString;
    
}

//Specify the number of Sectors in the chart
- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return numberOfTotal;
}
//Specify the Value for each sector

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    
    CGFloat value = 0.0;
    if (totalAmmount!=0) {
        if(index%numberOfTotal == 0)
        {   value = ((user1 /totalAmmount) * 100);
      
        }
        if(index%numberOfTotal == 1)
        {
            
            value = ((user2 /totalAmmount) * 100);
        
        }
        
        
        if(index%numberOfTotal == 2)
        {
            
            value = ((user3 /totalAmmount) * 100);
           
        }
        
        if(index%numberOfTotal == 3)
        {
            
            value = ((user4 /totalAmmount) * 100);
        
        }
        if(index%numberOfTotal == 4)
        {
            
            value = ((user5 /totalAmmount) * 100);
          
        }
        
        
    }
  
    return value;
}

//Specify color for each sector
- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    UIColor *color;
    if(index%numberOfTotal == 0)
    {
       
        color  = [self colorWithHexString:@"c7f6ed"];
        
    }
    if(index%numberOfTotal == 1)
    {
       
        color  = [self colorWithHexString:@"d6dff5"];
    }
    
    if(index%numberOfTotal == 2)
    {
        
        color  = [self colorWithHexString:@"f6f4c7"];
    }
    if(index%numberOfTotal == 3)
    {
        
        color  = [self colorWithHexString:@"B89AFE"];
    }
    if(index%numberOfTotal == 4)
    {
        color  = [self colorWithHexString:@"BBEBFF"];
    }
    
    
    return color;
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}



@end
