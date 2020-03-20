//
//  RMAVC2.h
//  XMWClient
//
//  Created by dotvikios on 24/09/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormVC.h"
#import "RMACardCell.h"
@interface RMAVC2 : FormVC<UITextFieldDelegate,RMACardButtonDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *constant1;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *invoiceTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *costan2;

@end
