//
//  CustomerClaimInvoiceDetailsVC.h
//  XMWClient
//
//  Created by dotvikios on 20/06/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormVC.h"
#import "NetworkHelper.h"
@interface CustomerClaimInvoiceDetailsVC : UIViewController<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *reasonLable;
@property (weak, nonatomic) IBOutlet UILabel *claimSubTypeLable;
@property (weak, nonatomic) IBOutlet UILabel *claimTypeLable;
@property NSString *claimType;
@property NSString *claimSubType;
@property NSString *reason;
@property (weak, nonatomic) IBOutlet UITextField *invoiceNumber;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *ccLableName;
@property  NSMutableDictionary *requestData;

@end
