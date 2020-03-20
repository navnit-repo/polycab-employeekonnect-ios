//
//  OrderPendencyCell.m
//  XMWClient
//
//  Created by dotvikios on 04/09/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "OrderPendencyCell.h"
#import "LayoutClass.h"
#import "CurrencyConversationClass.h"
@implementation OrderPendencyCell
{
    double totalAmount;
    double activeAmount;
    double blockedAmount;
}
@synthesize displayName;
@synthesize totalView,activeView,blockedView;
+(OrderPendencyCell*) createInstance

{
    OrderPendencyCell *view = (OrderPendencyCell *)[[[NSBundle mainBundle] loadNibNamed:@"OrderPendencyCell" owner:self options:nil] objectAtIndex:0];
    
    return view;
}
-(void)autoLayout{
    [LayoutClass setLayoutForIPhone6:self.mainView];
    [LayoutClass setLayoutForIPhone6:self.chartView];
    [LayoutClass setLayoutForIPhone6:self.totalView];
    [LayoutClass setLayoutForIPhone6:self.activeView];
    [LayoutClass setLayoutForIPhone6:self.blockedView];
   
    
    [LayoutClass labelLayout:self.constantLbl1 forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.constantLbl2 forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.constantLbl3 forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.constantLbl4 forFontWeight:UIFontWeightBold];
    
    [LayoutClass labelLayout:self.displayName forFontWeight:UIFontWeightBold];
    
    [LayoutClass labelLayout:self.totalLblDisplayTop forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.activeLblDisplayTop forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.blockedLblDisplayTop forFontWeight:UIFontWeightRegular];
    
    [LayoutClass labelLayout:self.totalLblHide forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.activeLblHide forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.blockedLblHide forFontWeight:UIFontWeightRegular];
    
    [LayoutClass labelLayout:self.totalPriceLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.activePriceLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.blockedPriceLbl forFontWeight:UIFontWeightRegular];
    
    
}
- (void)config:(NSArray *)array{
    [self autoLayout];
    NSLog(@"Data: %@",array);
    displayName.text = [array objectAtIndex:1];
    
    totalAmount = [[array objectAtIndex:2] doubleValue];
    blockedAmount = [[array objectAtIndex:4] doubleValue];
    activeAmount = [[array objectAtIndex:3] doubleValue];
    
    CurrencyConversationClass *currencyFormate  = [[CurrencyConversationClass alloc]init];
    
     NSString *rupee=@"\u20B9";
     NSString *totalLbl = [currencyFormate formateCurrency:[array objectAtIndex:2]];
     NSString *blockedLbl = [currencyFormate formateCurrency:[array objectAtIndex:4]];
     NSString *activeLbl = [currencyFormate formateCurrency:[array objectAtIndex:3]];
    
    
    
    
    self.totalLblDisplayTop.text =[[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:totalLbl];
    self.activeLblDisplayTop.text =[[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:activeLbl];
    self.blockedLblDisplayTop.text =  [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:blockedLbl];
    
    
  
    if (totalAmount == 0) { // if total amount is 0 then show view No Data Available
         [self.totalLblHide removeFromSuperview];
         [self.blockedLblHide removeFromSuperview];
         [self.activeLblHide removeFromSuperview];
        
        UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(0, self.chartView.frame.size.height/2, self.chartView.frame.size.width, 0)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor: [UIColor colorWithRed:(204.0/255) green:(43.0/255) blue:(43.0/255) alpha:(1)]];
        [label setFont:[UIFont fontWithName:@"Helvetica-Light" size:18.0]];
        [label setText: @"No Data Available"];
        
        [label setNumberOfLines: 0];
        [label sizeToFit];
        [label setCenter: CGPointMake(self.chartView.center.x, label.center.y)];
        [self.chartView addSubview:label];
    }
    if (blockedAmount == 0) {
        [self.blockedLblHide removeFromSuperview];
    }
    if (activeAmount == 0) {
        [self.activeLblHide removeFromSuperview];
    }
    
    if (totalAmount !=0){
       double calBlockedView = (blockedAmount/totalAmount)*self.blockedView.frame.size.height;
       double calActiveView  = (activeAmount / totalAmount)*self.activeView.frame.size.height;
       
       
       
       UIView *view = [[UIView alloc]init];
       view.frame = CGRectMake(0, 0, self.totalView.frame.size.width, self.totalView.frame.size.height);
       view.backgroundColor = [UIColor colorWithRed:67.0/255 green:67.0/255 blue:67.0/255 alpha:1];
       
       [view addSubview:self.totalPriceLbl];
       [self.totalView addSubview:view];
       
       
       UIView *view2 = [[UIView alloc]init];
       view2.frame = CGRectMake(0, self.totalView.frame.size.height-calActiveView, self.totalView.frame.size.width, calActiveView);
       view2.backgroundColor = [UIColor colorWithRed:49.0/255 green:221.0/255 blue:179.0/255 alpha:1];
       [view2 addSubview:self.activePriceLbl];
       [self.activeView addSubview:view2];
       
       
       UIView *view3 = [[UIView alloc]init];
       view3.frame = CGRectMake(0, self.totalView.frame.size.height-calBlockedView, self.totalView.frame.size.width, calBlockedView);
       view3.backgroundColor = [UIColor colorWithRed:235.0/255 green:145.0/255 blue:138.0/255 alpha:1];
       [view3 addSubview:self.blockedPriceLbl];
       [self.blockedView addSubview:view3];
       
       NSString *rupee=@"\u20B9";
       
       NSString *totalLbl = [currencyFormate formateCurrency:[array objectAtIndex:2]];
       NSString *blockedLbl = [currencyFormate formateCurrency:[array objectAtIndex:4]];
       NSString *activeLbl = [currencyFormate formateCurrency:[array objectAtIndex:3]];
       
       self.totalPriceLbl.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:totalLbl];
       self.activePriceLbl.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:activeLbl];
       self.blockedPriceLbl.text = [[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:blockedLbl];
        
        
        
     
        
   }
    
    
   
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
