//
//  SalesCell.m
//  XMWClient
//
//  Created by dotvikios on 04/09/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "SalesCell.h"
#import "LayoutClass.h"

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
    [LayoutClass setLayoutForIPhone6:self.ftdView];
    [LayoutClass setLayoutForIPhone6:self.mtdView];
    [LayoutClass setLayoutForIPhone6:self.ytdView];
    [LayoutClass labelLayout:displayName forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.constantLbl1 forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.constantLbl2 forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.constantLbl3 forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.constantLbl4 forFontWeight:UIFontWeightRegular];
    
      [LayoutClass labelLayout:self.ftdDataSetLbl forFontWeight:UIFontWeightBold];
     [LayoutClass labelLayout:self.mtdDataSetLbl forFontWeight:UIFontWeightBold];
     [LayoutClass labelLayout:self.ytdDataSetLbl forFontWeight:UIFontWeightBold];
    
    
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
//    if(currency >= 10000000.0f) {
//        suffix = @"Cr";
//        shortenedAmount /= 10000000.0f;
//    }
//    else
    if(currency >= 100000.0f) {
        suffix = @"L";
        shortenedAmount /= 100000.0f;
    }
//    else if(currency >= 1000.0f) {
//        suffix = @"K";
//        shortenedAmount /= 1000.0f;
//    }

    NSString *requiredString = [NSString stringWithFormat:@"%0.2f%@", shortenedAmount, suffix];
    return requiredString;
    
}

@end
