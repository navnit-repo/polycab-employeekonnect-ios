//
//  OTPVC.h
//  XMWClient
//
//  Created by dotvikios on 12/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTPVC : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITextField *nwPassword;
@property (weak, nonatomic) IBOutlet UITextField *confirmNewPassword;

@end
