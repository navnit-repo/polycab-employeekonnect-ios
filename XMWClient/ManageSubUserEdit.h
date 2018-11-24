//
//  ManageSubUserEdit.h
//  XMWClient
//
//  Created by dotvikios on 24/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ManageSubUserEdit : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
    NSString * userid;
    NSString * regID;
    NSString * authToken;
    NSString * subuserrefid;
}
@property (weak, nonatomic) IBOutlet UILabel *constantView1;
@property (weak, nonatomic) IBOutlet UILabel *constantView2;
@property (weak, nonatomic) IBOutlet UILabel *constantView3;
@property (weak, nonatomic) IBOutlet UITextField *constantView4;
@property (weak, nonatomic) IBOutlet UILabel *constantView5;
@property (weak, nonatomic) IBOutlet UITextField *constantView6;
@property (weak, nonatomic) IBOutlet UIButton *constantView7;
@property (weak, nonatomic) IBOutlet UIButton *constantView8;
@property (weak, nonatomic) IBOutlet UIButton *constantView9;



@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *userNameFiled;
@property (weak, nonatomic) IBOutlet UILabel *regcodeLable;
@property NSString * userid;
@property NSString * regID;
@property NSString * authToken;
@property NSString * subuserrefid;
@end
