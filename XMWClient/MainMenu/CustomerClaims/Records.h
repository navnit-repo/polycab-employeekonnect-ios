//
//  Records.h
//  XMWClient
//
//  Created by dotvikios on 10/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Records : UIView
@property (weak, nonatomic) IBOutlet UILabel *invoiceCRD_No;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *billingItem;
@property (weak, nonatomic) IBOutlet UILabel *productInfo;
@property (weak, nonatomic) IBOutlet UILabel *invoiceQty;
@property (weak, nonatomic) IBOutlet UILabel *ratePerUnit;
@property (weak, nonatomic) IBOutlet UILabel *netValue;
@property (weak, nonatomic) IBOutlet UILabel *perUnitCustomerValue;
@property (weak, nonatomic) IBOutlet UILabel *nwNetValue;
@property (weak, nonatomic) IBOutlet UILabel *claimAmount;
@property (weak, nonatomic) IBOutlet UILabel *remarks;




+(Records *) createInstance:(CGFloat)yOrigin;
-(void)configure:(NSArray *)dict;
@end
