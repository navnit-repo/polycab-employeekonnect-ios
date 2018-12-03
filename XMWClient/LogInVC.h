//
//  LogInVC.h
//  PolyCab
//
//  Created by dotvikios on 13/07/18.
//  Copyright © 2018 DotvikSol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
extern NSMutableDictionary *masterDataForEmployee;
@interface LogInVC : UIViewController<UITextFieldDelegate>
{
    NSMutableDictionary* menuDetailsDict;
    NSString *authToken;
}
@property NSString *authToken;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property NSMutableDictionary* menuDetailsDict;
@property (weak, nonatomic) IBOutlet UIImageView *changeImage;
@property (weak, nonatomic) IBOutlet UIImageView *constant1;
@property (weak, nonatomic) IBOutlet UIButton *constant2;
@property (weak, nonatomic) IBOutlet UIImageView *constant3;
@property (weak, nonatomic) IBOutlet UIButton *constant4;
@property (weak, nonatomic) IBOutlet UILabel *constant5;
@property (weak, nonatomic) IBOutlet UIButton *constant6;
@property (weak, nonatomic) IBOutlet UILabel *constant7;
@property (weak, nonatomic) IBOutlet UILabel *costant8;
@property (weak, nonatomic) IBOutlet UILabel *constant9;

@property (strong, nonatomic) SWRevealViewController *viewController;
@end
