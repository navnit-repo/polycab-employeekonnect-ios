//
//  CreateSubUserVC.h
//  XMWClient
//
//  Created by dotvikios on 23/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateSubUserVC : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
    NSString *auth_Token;
}
@property (weak, nonatomic) IBOutlet UILabel *constantView1;
@property (weak, nonatomic) IBOutlet UILabel *constantView2;
@property (weak, nonatomic) IBOutlet UILabel *constantView3;
@property (weak, nonatomic) IBOutlet UILabel *constantView4;
@property (weak, nonatomic) IBOutlet UITextField *constantView5;
@property (weak, nonatomic) IBOutlet UILabel *constantView6;
@property (weak, nonatomic) IBOutlet UITextField *constantView7;
@property (weak, nonatomic) IBOutlet UIButton *constantView8;




@property (weak, nonatomic) IBOutlet UILabel *subUserRegID;
@property NSString *auth_Token;
@property (weak, nonatomic) IBOutlet UITextField *setSubUserName;
@property (weak, nonatomic) IBOutlet UITextField *setSubUserPassword;

@end
