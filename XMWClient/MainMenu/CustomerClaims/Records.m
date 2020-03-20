//
//  Records.m
//  XMWClient
//
//  Created by dotvikios on 10/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "Records.h"

@implementation Records
@synthesize invoiceCRD_No,date,billingItem,productInfo,invoiceQty,ratePerUnit,netValue,perUnitCustomerValue,nwNetValue,claimAmount,remarks;

+(Records*) createInstance:(CGFloat)yOrigin

{
    
    Records *view = (Records *)[[[NSBundle mainBundle] loadNibNamed:@"Records" owner:self options:nil] objectAtIndex:0];
    
    CGRect frame = view.frame;
    frame.origin.y = yOrigin;
    view.frame = frame;
    
    return view;
}

-(void)configure:(NSArray *)dict{
    self.invoiceCRD_No.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"INV_CRD_NO"]];
    
    NSString *date=[NSString stringWithFormat:@"%@",[dict valueForKey:@"CTIMESTAMP"]];
    
    // response formate 20180621
    date=[date substringToIndex:8];
    NSString *dash =@"-";
    NSString *year =[date substringToIndex:4];
    date = [date substringFromIndex:4];
    NSString *month =[date substringToIndex:2];
    date = [date substringFromIndex:2];
    NSString *day =date;
    
    self.date.text =[NSString stringWithFormat: @"%@%@%@%@%@",day,dash,month,dash,year];
  
    self.billingItem.text =[NSString stringWithFormat:@"%@",[dict valueForKey:@"ITEM_NO"]];
    self.productInfo.text =[NSString stringWithFormat: @"%@ %@",  [NSString stringWithFormat:@"%@",[dict valueForKey:@"MATERIAL"]],  [NSString stringWithFormat:@"%@",[dict valueForKey:@"ITEM_TXT"]]];
    self.invoiceQty.text =[NSString stringWithFormat:@"%@",[dict valueForKey:@"ITEM_VALUE"]];
    self.ratePerUnit.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"ACTUAL_RATE"]];
    self.netValue.text = [NSString stringWithFormat:@"%2.0f",[[dict valueForKey:@"ITEM_VALUE"] doubleValue] * [[dict valueForKey:@"ACTUAL_RATE"] doubleValue]];
    self.perUnitCustomerValue.text =[NSString stringWithFormat:@"%2.0f",[ratePerUnit.text doubleValue] -[[dict valueForKey:@"RATE_DIFF"] doubleValue]];
    self.nwNetValue.text = [NSString stringWithFormat:@"%2.0f",[perUnitCustomerValue.text doubleValue] * [[dict valueForKey:@"ITEM_VALUE"] doubleValue]];
    self.claimAmount.text =[NSString stringWithFormat:@"%@",[dict valueForKey:@"CLAIM_AMOUNT"]];
    self.remarks.text =[NSString stringWithFormat:@"%@",[dict valueForKey:@"REASON"]];

    
  
    
    
}
@end
