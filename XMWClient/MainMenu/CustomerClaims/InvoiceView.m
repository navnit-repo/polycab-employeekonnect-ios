//
//  InvoiceView.m
//  XMWClient
//
//  Created by dotvikios on 25/06/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "InvoiceView.h"
#import "CustomerClaimInvoiceFetchDetailsVC.h"

@implementation InvoiceView
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
@synthesize delegate;
+(InvoiceView*) createInstance:(CGFloat)yOrigin

{

    InvoiceView *view = (InvoiceView *)[[[NSBundle mainBundle] loadNibNamed:@"InvoiceView" owner:self options:nil] objectAtIndex:0];
   
    CGRect frame = view.frame;
    frame.origin.y = yOrigin;
    view.frame = frame;
   
    return view;
}
- (void)configure:(NSDictionary *)dict{
    self.perUnitCustomerValue.delegate = self;
    self.remark.delegate= self;
    self.invoiceNo.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"VBELN"]];
    self.date.text =[NSString stringWithFormat:@"%@",[dict objectForKey:@"FKDAT"]];
    self.billingItem.text =[NSString stringWithFormat:@"%@",[dict objectForKey:@"POSNR"]];
    self.division.text =[NSString stringWithFormat:@"%@",[dict objectForKey:@"SPART"]];
    
    
    NSString * info1 = [dict objectForKey:@"MATNR"];
    NSString * info2 = [dict objectForKey:@"ARKTX"];
    NSString *productInformation = [NSString stringWithFormat: @"%@, %@", info1, info2];
    self.productInfo.text=productInformation;
    self.salesUnit.text =[NSString stringWithFormat:@"%@",[dict objectForKey:@"VRKME"]];
    self.invoiceQty.text =[NSString stringWithFormat:@"%@",[dict objectForKey:@"FKIMG"]];
    self.netValue.text =[NSString stringWithFormat:@"%@",[dict objectForKey:@"NETWR_ITM"]];
    
    
    
    NSString  * netValue =[NSString stringWithFormat:@"%@",[dict objectForKey:@"NETWR_ITM"]];
    nw = netValue;
    NSString *invoiceQty =[NSString stringWithFormat:@"%@",[dict objectForKey:@"FKIMG"]];
    qty = invoiceQty;
    self.ratePerUnit.text = [NSString stringWithFormat:@"%0.2f", [netValue doubleValue] / [invoiceQty doubleValue]];
    
    self.perUnitCustomerValue.text = @"";
    self.remark.text = @"";

}

-(void)updateValues:(long int  )viewTag{
    NSString *neNetValue;
    neNetValue =[NSString stringWithFormat:@"%d", [perUnitCustomervalue intValue]  * [qty intValue]];
    self.nwNetValue.text = neNetValue;
    claimAmo = [NSString stringWithFormat:@"%0.2f",[nw doubleValue] - [neNetValue doubleValue]];
    self.claimedAmount.text = claimAmo;
    [self.delegate didTextFieldLoad:self Rate:claimAmo];
   
    
    
}


//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{

//    return true;
//}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.tag == 1)
    {
        [textField resignFirstResponder];
        double perUnitText = [textField.text doubleValue];
        double ratePerUnitText = [ratePerUnit.text doubleValue];
        if(perUnitText >= ratePerUnitText)
        {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"mKonnect Authentication!" message:@"Per Unit Customer Value should be lesser than Rate Per Unit" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
           
            [myAlertView show];
            self.nwNetValue.text = @"0.00";
            self.claimedAmount.text = @"0.00";
            [self.delegate didTextFieldLoad:self Rate:claimedAmount.text];
           
        }
        else{
    tag = self.tag;
    NSLog(@"Select Cart View Tag %ld",tag);
    perUnitCustomervalue = textField.text;
    NSLog(@"%@",perUnitCustomervalue);
        
    if ([perUnitCustomerValue.text isEqualToString:@""]||[perUnitCustomerValue.text isEqualToString:@"0"]) {
        self.nwNetValue.text = @"0.00";
        self.claimedAmount.text = @"0.00";
        [self.delegate didTextFieldLoad:self Rate:claimedAmount.text];
    }
    else{
    [self updateValues:tag];
    }
    }
    }
    else if (textField.tag == 2)
    {
         [textField resignFirstResponder];
    }
    
    return true;
}


@end
