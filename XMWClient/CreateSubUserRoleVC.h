//
//  CreateSubUserRoleVC.h
//  XMWClient
//
//  Created by dotvikios on 24/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoleList.h"
@interface CreateSubUserRoleVC : UIViewController
{
    NSString *authToken;
    NSString *subUserReffenceID;
     BOOL networkCallFlag;
}
@property (weak, nonatomic) IBOutlet UILabel *constantView1;
@property (weak, nonatomic) IBOutlet UIView *constantView2;
@property (weak, nonatomic) IBOutlet UIButton *constantView3;



@property (weak, nonatomic) IBOutlet UIView *submitButtonView;
@property NSString *authToken;
@property NSString *subUserReffenceID;
@property BOOL networkCallFlag;
@end
