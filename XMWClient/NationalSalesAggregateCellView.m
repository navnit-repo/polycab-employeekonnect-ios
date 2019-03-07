//
//  NationalSalesAggregateCellView.m
//  XMWClient
//
//  Created by dotvikios on 14/02/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "NationalSalesAggregateCellView.h"
#import "CurrencyConversationClass.h"
@implementation NationalSalesAggregateCellView

+(NationalSalesAggregateCellView*) createInstance

{
    NationalSalesAggregateCellView *view = (NationalSalesAggregateCellView *)[[[NSBundle mainBundle] loadNibNamed:@"NationalSalesAggregateCellView" owner:self options:nil] objectAtIndex:0];
    
    return view;
}




- (void)configure:(NSArray *)ftdData :(NSArray *)mtdData :(NSArray *)ytdData{
    [self autoLayout];
    CurrencyConversationClass *currencyFormate = [[CurrencyConversationClass alloc]init];
    NSString *rupee=@"\u20B9";
    
    NSString *ftd = [currencyFormate formateCurrency:[ftdData objectAtIndex:2]];
    NSString *mtd = [currencyFormate formateCurrency:[mtdData objectAtIndex:2]];
    NSString *ytd = [currencyFormate formateCurrency:[ytdData objectAtIndex:2]];
    
    if ([[ytdData objectAtIndex:1] isEqualToString:@""] || [[ytdData objectAtIndex:1] length] ==0 || [ytdData objectAtIndex:1] == nil || [[ytdData objectAtIndex:1] isKindOfClass:[NSNull class]] ) {
      self.displayName.text   = [ytdData objectAtIndex:0];
    }
    else
    {
          self.displayName.text   =  [[[ytdData objectAtIndex:0]stringByAppendingString:@"-"]stringByAppendingString:[ytdData objectAtIndex:1]];
    }
    

  
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
    
    else if (currency==0.0f)
    {
        suffix = @"";
    }
    
    else {
        suffix = @"L";
     
    }
    //    else if(currency >= 1000.0f) {
    //        suffix = @"K";
    //        shortenedAmount /= 1000.0f;
    //    }
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setPositiveFormat:@"##,##,###.#"];
    NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithFloat:shortenedAmount]];
    NSString *requiredString = [formatted stringByAppendingString:suffix];

//   NSString *requiredString = [NSString stringWithFormat:@"%0.1f%@", shortenedAmountFinal, suffix];
    return requiredString;
    
}

@end
