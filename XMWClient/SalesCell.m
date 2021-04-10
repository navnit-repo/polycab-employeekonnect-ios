//
//  SalesCell.m
//  XMWClient
//
//  Created by dotvikios on 04/09/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "SalesCell.h"
#import "LayoutClass.h"
#import "CurrencyConversationClass.h"
@implementation SalesCell
@synthesize ftdDataSetLbl,ytdDataSetLbl,mtdDataSetLbl;
@synthesize displayName;

+(SalesCell*) createInstance

{
    SalesCell *view = (SalesCell *)[[[NSBundle mainBundle] loadNibNamed:@"SalesCell" owner:self options:nil] objectAtIndex:0];
    
    return view;
}
-(void)autoLayout{
    [LayoutClass setLayoutForIPhone6:self.mainView];
    [LayoutClass setLayoutForIPhone6:self.dividerLine];
    [LayoutClass setLayoutForIPhone6:self.mtdDividerLine];
    [LayoutClass setLayoutForIPhone6:self.ftdView];
    [LayoutClass setLayoutForIPhone6:self.mtdView];
    [LayoutClass setLayoutForIPhone6:self.ytdView];
    [LayoutClass labelLayout:displayName forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.constantLbl1 forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.constantLbl2 forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.lftdConstantLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.lmtdConstantLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.constantLbl3 forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.constantLbl4 forFontWeight:UIFontWeightRegular];
    
      [LayoutClass labelLayout:self.ftdDataSetLbl forFontWeight:UIFontWeightBold];
    
     [LayoutClass labelLayout:self.lftdDisplacyLbl forFontWeight:UIFontWeightBold];
     [LayoutClass labelLayout:self.lmtdDisplayLbl forFontWeight:UIFontWeightBold];
     [LayoutClass labelLayout:self.mtdDataSetLbl forFontWeight:UIFontWeightBold];
     [LayoutClass labelLayout:self.ytdDataSetLbl forFontWeight:UIFontWeightBold];
    
    
}

- (void)configure:(NSArray *)ftdData :(NSArray *)mtdData :(NSArray *)ytdData :(NSArray *)lftdData :(NSArray*)lmtddData
{
    [self autoLayout];
    NSString *rupee=@"\u20B9";
    
    //    NSString *ftd = [self formateCurrency:[ftdData objectAtIndex:2]];
    //    NSString *mtd = [self formateCurrency:[mtdData objectAtIndex:2]];
    //    NSString *ytd = [self formateCurrency:[ytdData objectAtIndex:2]];
    //
    CurrencyConversationClass *currencyFormate = [[CurrencyConversationClass alloc]init];
    
    NSString *ftd=  [currencyFormate formateCurrency:[ftdData objectAtIndex:2]];
    NSString *mtd = [currencyFormate formateCurrency:[mtdData objectAtIndex:2]];
    NSString *ytd = [currencyFormate formateCurrency:[ytdData objectAtIndex:2]];
    NSString *lftd =[currencyFormate formateCurrency:[lftdData objectAtIndex:2]];
    NSString *lmtd =[currencyFormate formateCurrency:[lmtddData objectAtIndex:2]];
    self.displayName.text   = [[[ytdData objectAtIndex:0]stringByAppendingString:@"-"]stringByAppendingString:[ytdData objectAtIndex:1]];
    self.ftdDataSetLbl.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:ftd];
    self.mtdDataSetLbl.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:mtd];
    self.ytdDataSetLbl.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:ytd];
    self.lftdDisplacyLbl.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:lftd];
    self.lmtdDisplayLbl.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:lmtd];
}

- (void)configureFor:(NSString*) name ftd:(NSString*)ftd mtd:(NSString *)mtd ytd:(NSString *)ytd lftd:(NSString *)lftd lmtd:(NSString*)lmtd
{
    [self autoLayout];
    NSString *rupee=@"\u20B9";
    
    self.displayName.text   = name;
    self.ftdDataSetLbl.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:ftd];
    self.mtdDataSetLbl.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:mtd];
    self.ytdDataSetLbl.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:ytd];
    self.lftdDisplacyLbl.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:lftd];
    self.lmtdDisplayLbl.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:lmtd];
}

//- (void)configure:(NSArray *)ftdData :(NSArray *)mtdData :(NSArray *)ytdData{
//    [self autoLayout];
//    NSString *rupee=@"\u20B9";
//    
////    NSString *ftd = [self formateCurrency:[ftdData objectAtIndex:2]];
////    NSString *mtd = [self formateCurrency:[mtdData objectAtIndex:2]];
////    NSString *ytd = [self formateCurrency:[ytdData objectAtIndex:2]];
////
//    CurrencyConversationClass *currencyFormate = [[CurrencyConversationClass alloc]init];
//    
//  NSString *ftd=  [currencyFormate formateCurrency:[ftdData objectAtIndex:2]];
//  NSString *mtd = [currencyFormate formateCurrency:[mtdData objectAtIndex:2]];
//  NSString *ytd = [currencyFormate formateCurrency:[ytdData objectAtIndex:2]];
//    
//    self.displayName.text   = [[[ytdData objectAtIndex:0]stringByAppendingString:@"-"]stringByAppendingString:[ytdData objectAtIndex:1]];
//    self.ftdDataSetLbl.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:ftd];
//    self.mtdDataSetLbl.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:mtd];
//    self.ytdDataSetLbl.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:ytd];
//
//
//}

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
