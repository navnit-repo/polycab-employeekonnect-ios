//
//  NationalSalesAggregatePieCellView.m
//  XMWClient
//
//  Created by dotvikios on 14/02/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "NationalSalesAggregatePieCellView.h"

@implementation NationalSalesAggregatePieCellView

+(OverDueCell*) createInstance

{
    NationalSalesAggregatePieCellView *view = (NationalSalesAggregatePieCellView *)[[[NSBundle mainBundle] loadNibNamed:@"NationalSalesAggregatePieCellView" owner:self options:nil] objectAtIndex:0];
    
    return view;
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
        // pending
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

@end
