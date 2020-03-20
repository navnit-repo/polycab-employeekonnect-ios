//
//  MyClaimResponse.m
//  XMWClient
//
//  Created by dotvikios on 09/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "MyClaimResponse.h"
#import "TrackClaimVC.h"
#define InvoiceStartTag 1000

@implementation MyClaimResponse
@synthesize refNoLbl;
@synthesize dateLbl;
@synthesize claimTypeLbl;
@synthesize createdByLbl;
@synthesize commentLbl;
@synthesize statusLbl;
@synthesize track;




+(MyClaimResponse*) createInstance:(CGFloat)yOrigin

{
    
    MyClaimResponse *view = (MyClaimResponse *)[[[NSBundle mainBundle] loadNibNamed:@"MyClaimResponseView" owner:self options:nil] objectAtIndex:0];
    
    CGRect frame = view.frame;
    frame.origin.y = yOrigin;
    view.frame = frame;
    
    return view;
}

-(void)configure:(NSDictionary *)dict{
  
    self.refNoLbl.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"CLAIM_NO"]];
    self.dateLbl.text =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"CTIMESTAMP"]];
    self.claimTypeLbl.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"SUBTYPE_CODE"]];
    self.createdByLbl.text =[NSString stringWithFormat:@"%@",[dict objectForKey:@"CUSTOMER_ID"]];
    self.commentLbl.text= [NSString stringWithFormat:@"%@",[dict objectForKey:@"REASON"]];

NSString *date=[NSString stringWithFormat:@"%@",[dict objectForKey:@"CTIMESTAMP"]];
   
    // response formate 20180621
    date=[date substringToIndex:8];
    NSString *dash =@"-";
    NSString *year =[date substringToIndex:4];
      date = [date substringFromIndex:4];
    NSString *month =[date substringToIndex:2];
    date = [date substringFromIndex:2];
    NSString *day =date;
    
   self.dateLbl.text =[NSString stringWithFormat: @"%@%@%@%@%@",day,dash,month,dash,year];

    if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"ZSTATUS1"]] isEqualToString:@"REJECTED" ]|| [[NSString stringWithFormat:@"%@",[dict objectForKey:@"ZSTATUS2"]] isEqualToString:@"REJECTED"] ||[[NSString stringWithFormat:@"%@",[dict objectForKey:@"ZSTATUS3"]] isEqualToString:@"REJECTED" ]) {
        self.statusLbl.text= @"REJECTED";
    }
    else{
        if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"STATUS"]] isEqualToString:@"A" ]) {
             self.statusLbl.text= @"APPROVED";
        }
        else if([[NSString stringWithFormat:@"%@",[dict objectForKey:@"STATUS"]] isEqualToString:@"R" ]){
            
             self.statusLbl.text= @"OPEN";
        }
    }
}
- (IBAction)trackClaimButton:(id)sender {
    UIView *t = self;
    long int tag = t.tag;
    NSLog(@"%ld", tag);
     [ self.delegate clickButtonView:self Buttontag:tag];
    
}



@end
