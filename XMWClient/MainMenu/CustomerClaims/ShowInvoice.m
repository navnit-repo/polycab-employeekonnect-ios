//
//  ShowInvoice.m
//  XMWClient
//
//  Created by dotvikios on 11/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "ShowInvoice.h"

@implementation ShowInvoice
@synthesize invoiceNo;
@synthesize date;
@synthesize billingItem;
@synthesize division;
@synthesize productInfo;
@synthesize salesUnit;
@synthesize invoiceQty;
@synthesize netValue;
@synthesize ratePerUnit;
@synthesize perUnitCustomerValue;
@synthesize nwNetValue;
@synthesize claimedAmount;
@synthesize remark;

+(ShowInvoice*) createInstance:(CGFloat)yOrigin

{
    
    ShowInvoice *view = (ShowInvoice *)[[[NSBundle mainBundle] loadNibNamed:@"ShowInvoice" owner:self options:nil] objectAtIndex:0];
    
    CGRect frame = view.frame;
    frame.origin.y = yOrigin;
    view.frame = frame;
    
    return view;
}
- (void)configure:(NSDictionary *)dict{
    
    self.invoiceNo.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"IN"]];
    self.date.text =[NSString stringWithFormat:@"%@",[dict objectForKey:@"D"]];
    self.billingItem.text =[NSString stringWithFormat:@"%@",[dict objectForKey:@"BI"]];
    self.division.text =[NSString stringWithFormat:@"%@",[dict objectForKey:@"DIV"]];
    self.productInfo.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"PI"]];
    self.salesUnit.text =[NSString stringWithFormat:@"%@",[dict objectForKey:@"SU"]];
    self.invoiceQty.text =[NSString stringWithFormat:@"%@",[dict objectForKey:@"IQ"]];
    self.netValue.text =[NSString stringWithFormat:@"%@",[dict objectForKey:@"NV"]];
    self.ratePerUnit.text =[NSString stringWithFormat:@"%@",[dict objectForKey:@"RPU"]];
    self.perUnitCustomerValue.text =[NSString stringWithFormat:@"%@",[dict objectForKey:@"PUCV"]];
    self.nwNetValue.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"NNV"]];
    self.claimedAmount.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"CA"]];
    self.remark.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"R"]];
    
}

@end
