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
    NSString *rupee=@"\u20B9";
    NSString *allData = [self formateCurrency:[[dataArray objectAtIndex:0]objectAtIndex:2]];
    creditDetailsDisplayNameLbl.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:allData];
    
    
    
    
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
    
    NSString *requiredString = [NSString stringWithFormat:@"%0.1f%@", shortenedAmount, suffix];
    return requiredString;
    
}

@end
