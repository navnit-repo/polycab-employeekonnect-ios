//
//  PageViewController.h
//  XMWCS_iphone
//
//  Created by Ashish Tiwari on 07/05/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "HttpEventListener.h"
#import "LoadingView.h"
#import "NetworkHelper.h"
#import "XMWAbout.h"





@interface PageViewController : UIViewController <HttpEventListener, XMWAboutCloseDelegate, UITextFieldDelegate, MFMailComposeViewControllerDelegate>
{
    int screenId;
    IBOutlet UIButton *button;
    LoadingView* loadingView;
    NetworkHelper* networkHelper;
    NSMutableArray* menuList;
    NSString* m_username;
    
}

@property int screenId;
@property(weak, nonatomic) IBOutlet UITextField *userName;
@property(weak, nonatomic) IBOutlet UITextField *password;
@property(weak, nonatomic) IBOutlet UIView* cbView;
@property(weak, nonatomic) IBOutlet UILabel *forgotPasswordLabel;

@property (nonatomic, retain) NSString *Name;
@property (nonatomic, retain) NSString *Pass;

@property (nonatomic, strong) NSMutableData *responseData;
@property  NSMutableArray* menuList;
@property (weak, nonatomic) IBOutlet UITextField *otpTextField;


@property (weak, nonatomic) IBOutlet UIView *phoneNumberView;


-(IBAction) SignInButtonPressed : (id) sender;
-(IBAction) CancleButtonPressed : (id) sender;


-(void)registerDeviceToken;


@end
