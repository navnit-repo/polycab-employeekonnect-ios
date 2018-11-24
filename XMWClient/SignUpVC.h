//
//  SignUpVC.h
//  PolyCab
//
//  Created by dotvikios on 16/07/18.
//  Copyright © 2018 DotvikSol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpVC : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *passwordView;

@property (weak, nonatomic) IBOutlet UIView *otpView;
@property (weak, nonatomic) IBOutlet UILabel *timerLbl;
@property (weak, nonatomic) IBOutlet UITextField *userIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *otpTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UIView *resendButtonHideView;
@property (weak, nonatomic) IBOutlet UIImageView *constant1;
@property (weak, nonatomic) IBOutlet UILabel *constant2;
@property (weak, nonatomic) IBOutlet UIButton *constant3;
@property (weak, nonatomic) IBOutlet UIButton *constant4;
@property (weak, nonatomic) IBOutlet UIButton *constant5;
@property (weak, nonatomic) IBOutlet UIButton *constant6;

@property (weak, nonatomic) IBOutlet UILabel *constantView7;
@property (weak, nonatomic) IBOutlet UILabel *constantView8;
@property (weak, nonatomic) IBOutlet UILabel *constantView9;
@property (weak, nonatomic) IBOutlet UILabel *constantView10;




@end
