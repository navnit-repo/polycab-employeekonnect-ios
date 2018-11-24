//
//  ManageSubUserVC.h
//  XMWClient
//
//  Created by dotvikios on 23/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormVC.h"

@interface ManageSubUserVC : FormVC<UITextFieldDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *constantView1;
@property (weak, nonatomic) IBOutlet UILabel *constantView2;
@property (weak, nonatomic) IBOutlet UITextField *constantView3;
@property (weak, nonatomic) IBOutlet UIButton *constantView4;
@property (weak, nonatomic) IBOutlet UILabel *constantView5;



@property (weak, nonatomic) IBOutlet UITextField *passwordFiled;
@end
