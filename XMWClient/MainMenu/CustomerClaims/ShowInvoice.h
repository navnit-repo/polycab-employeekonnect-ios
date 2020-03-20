//
//  ShowInvoice.h
//  XMWClient
//
//  Created by dotvikios on 11/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowInvoice : UIView
+(ShowInvoice*) createInstance:(CGFloat)yOrigin;

@property (weak, nonatomic) IBOutlet UILabel *invoiceNo;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *billingItem;
@property (weak, nonatomic) IBOutlet UILabel *division;
@property (weak, nonatomic) IBOutlet UILabel *productInfo;
@property (weak, nonatomic) IBOutlet UILabel *salesUnit;
@property (weak, nonatomic) IBOutlet UILabel *invoiceQty;
@property (weak, nonatomic) IBOutlet UILabel *netValue;
@property (weak, nonatomic) IBOutlet UILabel *ratePerUnit;
@property (weak, nonatomic) IBOutlet UILabel *perUnitCustomerValue;

@property (weak, nonatomic) IBOutlet UILabel *nwNetValue;
@property (weak,nonatomic) IBOutlet UILabel *claimedAmount;
@property (weak, nonatomic) IBOutlet UILabel *remark;


-(void)configure:(NSDictionary *)dict;
@end
