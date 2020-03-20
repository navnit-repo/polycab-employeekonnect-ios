//
//  ForgotPasswordVC.h
//  XMWClient
//
//  Created by dotvikios on 18/02/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ForgotPasswordVC : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *forgotPasswordLbl;
@property (weak, nonatomic) IBOutlet UILabel *enterRegCodeLbl;
@property (weak, nonatomic) IBOutlet UITextField *enterRegCodeTextField;
@property (weak, nonatomic) IBOutlet UILabel *enterCustomeAccountLbl;
@property (weak, nonatomic) IBOutlet UITextField *enterCustomerAccountTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *orLbl;

@end

NS_ASSUME_NONNULL_END
