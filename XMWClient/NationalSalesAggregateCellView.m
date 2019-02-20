//
//  NationalSalesAggregateCellView.m
//  XMWClient
//
//  Created by dotvikios on 14/02/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "NationalSalesAggregateCellView.h"

@implementation NationalSalesAggregateCellView

+(NationalSalesAggregateCellView*) createInstance

{
    NationalSalesAggregateCellView *view = (NationalSalesAggregateCellView *)[[[NSBundle mainBundle] loadNibNamed:@"NationalSalesAggregateCellView" owner:self options:nil] objectAtIndex:0];
    
    return view;
}




- (void)configure:(NSArray *)ftdData :(NSArray *)mtdData :(NSArray *)ytdData{
    [self autoLayout];
    NSString *rupee=@"\u20B9";
    
    NSString *ftd = [self formateCurrency:[ftdData objectAtIndex:2]];
    NSString *mtd = [self formateCurrency:[mtdData objectAtIndex:2]];
    NSString *ytd = [self formateCurrency:[ytdData objectAtIndex:2]];
    
    
    self.displayName.text   = [ytdData objectAtIndex:0];
    self.ftdDataSetLbl.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:ftd];
    self.mtdDataSetLbl.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:mtd];
    self.ytdDataSetLbl.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:ytd];
    
    
}
-(NSString*)formateCurrency:(NSString *)actualAmount{
    
    float shortenedAmount = [actualAmount floatValue];
    NSString *suffix = @"";
    float currency = [actualAmount floatValue];
    if(currency >= 100.0f) {
        suffix = @"Cr";
        shortenedAmount /= 100.0f;
    }
//    if (currency <=0.0) {
//        suffix=@"";
//    }
    else {
        suffix = @"L";
     
    }
    //    else if(currency >= 1000.0f) {
    //        suffix = @"K";
    //        shortenedAmount /= 1000.0f;
    //    }
    
    NSString *requiredString = [NSString stringWithFormat:@"%0.1f%@", shortenedAmount, suffix];
    return requiredString;
    
}

@end
