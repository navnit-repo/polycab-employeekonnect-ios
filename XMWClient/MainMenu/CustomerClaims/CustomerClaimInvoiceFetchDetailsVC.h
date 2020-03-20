//
//  CustomerClaimInvoiceFetchDetailsVC.h
//  XMWClient
//
//  Created by dotvikios on 22/06/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvoiceView.h"

@interface CustomerClaimInvoiceFetchDetailsVC : UIViewController <UITextFieldDelegate,UIAlertViewDelegate,InvoiceDelegate>
@property NSMutableDictionary *InvoiceData;
@property (weak, nonatomic) IBOutlet UITextField *invoiceSearchField;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIButton *search;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property NSString *previousInvoice;
@property (weak, nonatomic) IBOutlet UILabel *rateDifference;
@property (weak, nonatomic) IBOutlet UITextField *claimReason;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *ccLableName;
@property   NSMutableDictionary *requestData;
@property NSString *cclable;
@end
