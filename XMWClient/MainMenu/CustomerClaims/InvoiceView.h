//
//  InvoiceView.h
//  XMWClient
//
//  Created by dotvikios on 25/06/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol InvoiceDelegate;


@interface InvoiceView : UIView <UITextFieldDelegate,UIAlertViewDelegate>

{
    NSString*perUnitCustomervalue;
    NSString * qty;
    NSString * claimAmo;
    NSString *nw;
    long int tag;
}
+(InvoiceView*) createInstance:(CGFloat)yOrigin;
@property (weak, nonatomic) IBOutlet UILabel *invoiceNo;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *billingItem;
@property (weak, nonatomic) IBOutlet UILabel *division;
@property (weak, nonatomic) IBOutlet UILabel *productInfo;
@property (weak, nonatomic) IBOutlet UILabel *salesUnit;
@property (weak, nonatomic) IBOutlet UILabel *invoiceQty;
@property (weak, nonatomic) IBOutlet UILabel *netValue;
@property (weak, nonatomic) IBOutlet UILabel *ratePerUnit;
@property (weak, nonatomic) IBOutlet UITextField *perUnitCustomerValue;
@property (weak, nonatomic) IBOutlet UILabel *nwNetValue;
@property (weak,nonatomic) IBOutlet UILabel *claimedAmount;
@property (weak, nonatomic) IBOutlet UITextField *remark;


-(void)configure:(NSDictionary *)dict;
@property (weak,nonatomic) id<InvoiceDelegate>delegate;
@end


@protocol InvoiceDelegate<NSObject>
-(void)didTextFieldLoad:(InvoiceView *)Difference Rate:(NSString *)claimAmount;
@end
