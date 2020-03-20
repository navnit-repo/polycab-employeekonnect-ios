//
//  CreateOrderStatusCell.m
//  XMWClient
//
//  Created by dotvikios on 25/01/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "CreateOrderStatusCell.h"
#import "LayoutClass.h"
@implementation CreateOrderStatusCell
@synthesize orderedItemLbl,orderedItemValueLbl,descLbl,descValueLbl,qntyLbl,qntyValueLbl,statusFlgLbl,statusFlgValueLbl,listPriceLbl,listPriceValueLbl,unitSellPriceLbl,unitSellPriceValueLbl,lineAmntLbl,lineAmntValueLbl,linTaxAmntLbl,linTaxAmntValueLbl,totlLineAmntLbl,totlLineAmntValueLbl,prcntDiscntLbl,prcntDiscntValueLbl,isCodeLbl,isCodeValueLbl;

@synthesize spaPriceTextLbl,spaPriceValueLbl;

-(void)autoLayout
{
    [LayoutClass labelLayout:self.orderedItemLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.orderedItemValueLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.descLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.descValueLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.qntyLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.qntyValueLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.statusFlgLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.statusFlgValueLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.listPriceLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.listPriceValueLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.unitSellPriceLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.unitSellPriceValueLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.lineAmntLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.lineAmntValueLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.linTaxAmntLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.linTaxAmntValueLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.totlLineAmntLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.totlLineAmntValueLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.prcntDiscntLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.prcntDiscntValueLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.isCodeLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.isCodeValueLbl forFontWeight:UIFontWeightRegular];
    
    [LayoutClass labelLayout:self.spaPriceValueLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.spaPriceTextLbl forFontWeight:UIFontWeightRegular];
    
    
 
 
    self.descValueLbl.minimumFontSize = 10.0;
    self.descValueLbl.adjustsFontSizeToFitWidth = TRUE;
    self.descValueLbl.adjustsFontSizeToFitWidth = YES;
    
}


+ (CreateOrderStatusCell *)CreateInstance :(BOOL) spaFlag{
    
    NSString *nibName;
    if (spaFlag) {
        nibName = @"CreateOrderStatusSPACell";
    }
    else
    {
         nibName = @"CreateOrderStatusCell";
    }
    
    CreateOrderStatusCell *view = (CreateOrderStatusCell *) [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] objectAtIndex:0];
    return view;
}

- (void)configure:(NSArray *)array :(NSString *)verticalName
{
    [self autoLayout];
    NSString *ordItm;
    NSString *desc;
    NSString *qnty;
    NSString *statsFlg;
    NSString *lstPrc;
    NSString *untSellPrc;
    NSString *lneAmt;
    NSString *lneTxAmt;
    NSString *TotlLneAmt;
    NSString *prcDsc;
    NSString *isCode;
    NSString *spaPrice;

    ordItm = [array valueForKey:@"ORDERED_ITEM"];
    desc = [array valueForKey:@"DESCRIPTION"];
    qnty = [array valueForKey:@"QUANTITY"];
    statsFlg = [array valueForKey:@"STATUS_FLAG"];
    lstPrc = [array valueForKey:@"LIST_PRICE"];
    untSellPrc = [array valueForKey:@"UNIT_SELLING_PRICE"];
    lneAmt = [array valueForKey:@"LINE_AMOUNT"];
    lneTxAmt = [array valueForKey:@"LINE_TAX_AMOUNT"];
    TotlLneAmt = [array valueForKey:@"TOT_LINE_AMOUNT"];
    prcDsc = [array valueForKey:@"PERCENT_DISCOUNT"];
    isCode =[array valueForKey:@"ISCODE"];
    spaPrice = [array valueForKey:@"SPA_UNIT_PRICE"];
    if (isCode == nil || [isCode isKindOfClass:[NSNull class]]) {
        isCode =@"";
    }
    if (ordItm == nil || [ordItm isKindOfClass:[NSNull class]]) {
        ordItm =@"";
    }
    if (desc == nil || [desc isKindOfClass:[NSNull class]]) {
        desc =@"";
    }
    if (qnty == nil || [qnty isKindOfClass:[NSNull class]]) {
        qnty =@"";
    }
    if (statsFlg == nil || [statsFlg isKindOfClass:[NSNull class]]) {
        statsFlg =@"";
    }
    if (lstPrc == nil || [lstPrc isKindOfClass:[NSNull class]]) {
        lstPrc =@"";
    }
    if (untSellPrc == nil || [untSellPrc isKindOfClass:[NSNull class]]) {
        untSellPrc =@"";
    }
    if (lneAmt == nil || [lneAmt isKindOfClass:[NSNull class]]) {
        lneAmt =@"";
    }
    if (lneTxAmt == nil || [lneTxAmt isKindOfClass:[NSNull class]]) {
        lneTxAmt =@"";
    }
    if (TotlLneAmt == nil || [TotlLneAmt isKindOfClass:[NSNull class]]) {
        TotlLneAmt =@"";
    }
    if (prcDsc == nil || [prcDsc isKindOfClass:[NSNull class]]) {
        prcDsc =@"";
    }
    
    if ([verticalName isEqualToString:@"Cables"]) {
        isCodeValueLbl.text = isCode;
    }
    else
    {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height - isCodeLbl.frame.size.height);
        isCodeValueLbl.hidden = YES;
        isCodeLbl.hidden = YES;
    }
    
    orderedItemValueLbl.text = ordItm;
    descValueLbl.text = desc;
    qntyValueLbl.text = qnty;
    statusFlgValueLbl.text = statsFlg;
    listPriceValueLbl.text = lstPrc;
    unitSellPriceValueLbl.text = untSellPrc;
    lineAmntValueLbl.text = lneAmt;
    linTaxAmntValueLbl.text = lneTxAmt;
    totlLineAmntValueLbl.text = TotlLneAmt;
    prcntDiscntValueLbl.text = prcDsc;
    spaPriceValueLbl.text = spaPrice;
}

-(void)configure:(NSArray *)array
{
   
    
}
@end
