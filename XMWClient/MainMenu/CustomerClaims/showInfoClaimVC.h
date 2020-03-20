//
//  showInfoClaimVC.h
//  XMWClient
//
//  Created by dotvikios on 29/06/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerClaimInvoiceFetchDetailsVC.h"
#import "InvoiceView.h"

@interface showInfoClaimVC : UIViewController
@property (weak, nonatomic) IBOutlet UIView *navigationTopViewChnage;
@property (weak, nonatomic) IBOutlet UILabel *ccLableName;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UILabel *totalClaimAmount;
@property (weak, nonatomic) IBOutlet UILabel *claimReason;
@property NSString *totalAmount;
@property NSString *reason;
@property NSMutableArray * invoiceTagNumber;
@property NSString *ccLable;
@property NSMutableDictionary *showViewData;
@property NSMutableDictionary *chagedData;
@property  NSMutableDictionary *requestData;
@end
