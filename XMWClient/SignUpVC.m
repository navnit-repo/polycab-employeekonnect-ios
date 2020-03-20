//
//  SignUpVC.m
//  PolyCab
//
//  Created by dotvikios on 16/07/18.
//  Copyright © 2018 DotvikSol. All rights reserved.
//

#import "SignUpVC.h"
#import "NetworkHelper.h"
#import "LoadingView.h"
#import "ClientUserLogin.h"
#import "ClientLoginResponse.h"
#import "SBJson.h"
#import "JSONNetworkRequestData.h"
#import "JSONDataExchange.h"
#import "XmwcsConstant.h"
#import "MenuVC.h"
#import "LoginUtils.h"
#import "ObjectStorage.h"
#import "ClientVariable.h"
#import "DVAppDelegate.h"
#import "AppConstants.h"
#import "NetworkHelper.h"
#import "HavellsMenuScreenVC.h"
#import "XMWAbout.h"
#import "XMWFaqWebViewController.h"
#import "Styles.h"

#import "NotificationDeviceRegister.h"

#import "DashBoardMenuViewController.h"

#import "NotificationRequestStorage.h"
#import "NotificationRequestItem.h"
#import "SelectServerVC.h"
#import "TermsVC.h"
#import "XmwcsConstant.h"
#import "LayoutClass.h"
@interface SignUpVC ()

@end

@implementation SignUpVC
{
    int totalSeconds;
    NSTimer *twoMinTimer;
    NSDateFormatter *dateFormatter;
    NetworkHelper *networkHelper;
    LoadingView *loadingView;
    bool isKeyboardOpen;
    CGSize keyboardSize;
    int movedbyHeight;
    UITextField* activeTextField;
}
@synthesize passwordView;
@synthesize otpView;
@synthesize timerLbl;
@synthesize userIdTextField;
@synthesize otpTextField;
@synthesize passwordTextField;
@synthesize confirmPasswordTextField;
@synthesize resendButtonHideView;
-(void)autoLayout{
    [LayoutClass setLayoutForIPhone6:self.constant1];
    [LayoutClass labelLayout:self.constant2 forFontWeight:UIFontWeightBold];
    [LayoutClass textfieldLayout:self.userIdTextField forFontWeight:UIFontWeightRegular];
    [LayoutClass buttonLayout:self.constant3 forFontWeight:UIFontWeightBold];
    [LayoutClass setLayoutForIPhone6:self.otpView];
    [LayoutClass textfieldLayout:self.otpTextField forFontWeight:UIFontWeightRegular];
    [LayoutClass buttonLayout:self.constant4 forFontWeight:UIFontWeightRegular];
    [LayoutClass setLayoutForIPhone6:self.resendButtonHideView];
    [LayoutClass buttonLayout:self.constant5 forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.timerLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass setLayoutForIPhone6:self.passwordView];
    [LayoutClass textfieldLayout:self.passwordTextField forFontWeight:UIFontWeightRegular];
    [LayoutClass textfieldLayout:self.confirmPasswordTextField forFontWeight:UIFontWeightRegular];
    [LayoutClass buttonLayout:self.constant6 forFontWeight:UIFontWeightBold];
    
     [LayoutClass labelLayout:self.constantView7 forFontWeight:UIFontWeightLight];
    [LayoutClass labelLayout:self.constantView8 forFontWeight:UIFontWeightLight];
    [LayoutClass labelLayout:self.constantView9 forFontWeight:UIFontWeightLight];
    [LayoutClass labelLayout:self.constantView10 forFontWeight:UIFontWeightLight];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.constant3.layer.masksToBounds = YES;
    self.constant3.layer.cornerRadius =5.0f;
    
    self.constant5.layer.masksToBounds = YES;
    self.constant5.layer.cornerRadius =5.0f;
    
    self.constant6.layer.masksToBounds = YES;
    self.constant6.layer.cornerRadius =5.0f;
    
    
    [self autoLayout];
    // Do any additional setup after loading the view from its nib.
  
    // Show opaque navigation bar 
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage
                                                                          imageNamed:@"back-button.png"] style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(backHandler:)];
    
     backButton.tintColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
    
    
    [self.navigationItem setLeftBarButtonItem:backButton];
    
    
    [self configureServerUrls];

    totalSeconds = 120;
    NSLog(@"SignVC call");
    self.userIdTextField.delegate = self;
    self.otpTextField.delegate =self;
    self.passwordTextField.delegate = self;
    self.confirmPasswordTextField.delegate = self;
    self.userIdTextField.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor colorWithRed:(240/255.0) green:(240/255.0) blue:(240/255.0) alpha:1]);
    self.otpTextField.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor colorWithRed:(240/255.0) green:(240/255.0) blue:(240/255.0) alpha:1]);
    self.passwordTextField.layer.borderColor= (__bridge CGColorRef _Nullable)([UIColor colorWithRed:(240/255.0) green:(240/255.0) blue:(240/255.0) alpha:1]);
    self.confirmPasswordTextField.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor colorWithRed:(240/255.0) green:(240/255.0) blue:(240/255.0) alpha:1]);
    
    [self registerForKeyboardNotifications];
    
}

- (void) backHandler : (id) sender
{
    
    
    [ [self navigationController]  popViewControllerAnimated:YES];
    
}



- (void)timer {
    totalSeconds = totalSeconds - 1;
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    timerLbl.text = [NSString stringWithFormat:@"%02i:%02i",minutes,seconds];
    if ( totalSeconds == 0 ) {
        [twoMinTimer invalidate];
        resendButtonHideView.hidden = YES;
    }
}
- (IBAction)resendButton:(id)sender {
    resendButtonHideView.hidden = NO;
    totalSeconds = 120;
    twoMinTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                   target:self
                                                 selector:@selector(timer)
                                                 userInfo:nil
                                                  repeats:YES];
    
    loadingView= [LoadingView loadingViewInView:self.view];
    //Network Call
    NSString *user= userIdTextField.text;
    NSMutableDictionary *userId = [[NSMutableDictionary alloc]init];
    [userId setObject:user forKey:@"registry_id"];
    NSMutableDictionary * otpCall = [[NSMutableDictionary  alloc]init];
    [otpCall setObject:@"genertedotp" forKey:@"opcode"];
    [otpCall setObject:userId forKey:@"data"];
    [otpCall setObject:@"" forKey:@"authToken"];
    
    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=XmwcsConst_OPCODE_URL;
    networkHelper.serviceURLString = url;
    [networkHelper genericJSONPayloadRequestWith:otpCall :self :@"resendOTP"];
    
}

- (IBAction)submitButton:(id)sender {
   
    
    twoMinTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                   target:self
                                                 selector:@selector(timer)
                                                 userInfo:nil
                                                  repeats:YES];




    if ([userIdTextField.text isEqualToString:@""]) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Authentication!" message:@"Blank Field" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        [myAlertView show];
    }
    else{
        loadingView= [LoadingView loadingViewInView:self.view];
    //Network Call
    NSString *user= userIdTextField.text;
    NSMutableDictionary *userId = [[NSMutableDictionary alloc]init];
    [userId setObject:user forKey:@"registry_id"];
    NSMutableDictionary * otpCall = [[NSMutableDictionary  alloc]init];
    [otpCall setObject:@"genertedotp" forKey:@"opcode"];
    [otpCall setObject:userId forKey:@"data"];
    [otpCall setObject:@"" forKey:@"authToken"];

    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=XmwcsConst_OPCODE_URL;
    networkHelper.serviceURLString = url;
    [networkHelper genericJSONPayloadRequestWith:otpCall :self :@"RegId"];

    }
}

- (IBAction)otpNextButton:(id)sender {
    if ([userIdTextField.text isEqualToString:@""]|| [otpTextField.text isEqualToString:@""]) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Authentication!" message:@"Blank Field" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        [myAlertView show];
    }
    else{
    loadingView= [LoadingView loadingViewInView:self.view];
    //Network Call
    NSString *user= userIdTextField.text;
    NSString *otp = otpTextField.text;
    NSMutableDictionary *userId = [[NSMutableDictionary alloc]init];
    [userId setObject:user forKey:@"registry_id"];
    [userId setObject:otp forKey:@"pinotp"];
    NSMutableDictionary * otpCall = [[NSMutableDictionary  alloc]init];
    [otpCall setObject:@"verifyotp" forKey:@"opcode"];
    [otpCall setObject:userId forKey:@"data"];
    [otpCall setObject:@"" forKey:@"authToken"];
    
    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=XmwcsConst_OPCODE_URL;
    networkHelper.serviceURLString = url;
    [networkHelper genericJSONPayloadRequestWith:otpCall :self :@"verifyotp"];
    
    
    }
    
}
- (IBAction)passwordNextButton:(id)sender {
    if ([userIdTextField.text isEqualToString:@""]) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Authentication!" message:@"Blank Field" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        [myAlertView show];
    }
//    else if (passwordTextField.text.length==0||confirmPasswordTextField.text.length ==0){
//        
//        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Authentication!" message:@"Blank Field" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
//        [myAlertView show];
//    }
   else if (passwordTextField.text.length<8||confirmPasswordTextField.text.length<8) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Authentication!" message:@"The Password should be of minimum 8 characters." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        [myAlertView show];
    }
    else if([passwordTextField.text isEqualToString:confirmPasswordTextField.text]){
        
   
    NSLog(@"Password Match");
    loadingView= [LoadingView loadingViewInView:self.view];
    //Network Call
    NSString *user= userIdTextField.text;
    NSString *password = passwordTextField.text;
    NSMutableDictionary *userId = [[NSMutableDictionary alloc]init];
    [userId setObject:user forKey:@"registry_id"];
    [userId setObject:password forKey:@"password"];
    NSMutableDictionary * otpCall = [[NSMutableDictionary  alloc]init];
    [otpCall setObject:@"setpassword" forKey:@"opcode"];
    [otpCall setObject:userId forKey:@"data"];
    [otpCall setObject:@"" forKey:@"authToken"];
    
    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=XmwcsConst_OPCODE_URL;
    networkHelper.serviceURLString = url;
    [networkHelper genericJSONPayloadRequestWith:otpCall :self :@"setpassword"];
    }
    else{
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Authentication!" message:@"Passowrd does not match." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        [myAlertView show];
        
    }
}

- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    [loadingView removeView];
  
   
    if([callName isEqualToString:@"RegId"]) {
       
       if ([[respondedObject objectForKey:@"status"] isEqualToString:@"SUCCESS"]) {
            NSLog(@"OTP: %@",respondedObject);
            otpView.hidden = NO;
       }
        
       else{
            [XmwUtils toastView:@"User already exist."];
       }
   }
    if([callName isEqualToString:@"verifyotp"]) {
      
        if ([[respondedObject objectForKey:@"status"] isEqualToString:@"SUCCESS"]) {
            passwordView.hidden=NO;
        }
        else{
             [XmwUtils toastView:@"Otp does not match, Please re-enter it"];
        }
        
    }
     if([callName isEqualToString:@"resendOTP"]) {
         //do nothing
     }
    
    if([callName isEqualToString:@"setpassword"]) {
        
        if ([[respondedObject objectForKey:@"status"] isEqualToString:@"SUCCESS"]) {
            
            TermsVC *vc = [[TermsVC alloc]init];
            vc.regID = userIdTextField.text;
            vc.password = passwordTextField.text;
        
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
        
    }
}
- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Authentication!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
    
}
-(void) configureServerUrls
{
    NSString* currentServerStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_SERVER"];
    if([currentServerStr isEqualToString:@"Dev"]) {
        XmwcsConst_SERVICE_URL = XmwcsConst_SERVICE_URL_DEV;
        XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT = XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT_DEV;
        XmwcsConst_PRODUCT_TREE_SERVICE_URL = XmwcsConst_PRODUCT_TREE_SERVICE_URL_DEV;
        XmwcsConst_SERVICE_URL_APP_CONTROL = XmwcsConst_SERVICE_URL_APP_CONTROL_DEV;
        XmwcsConst_SERVICE_URL_DEAL_STORE = XmwcsConst_SERVICE_URL_DEAL_STORE_DEV;
        XmwcsConst_OPCODE_URL = XmwcsConst_SERVICE_URL_OPCODE_SERVICE_DEV;
        XmwcsConst_FILE_UPLOAD_URL = XmwcsConst_SERVICE_URL_FILE_UPLOAD_SERVICE_DEV;
    } else if([currentServerStr isEqualToString:@"QA"]) {
        XmwcsConst_SERVICE_URL = XmwcsConst_SERVICE_URL_DEMO;
        XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT = XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT_DEMO;
        XmwcsConst_PRODUCT_TREE_SERVICE_URL = XmwcsConst_PRODUCT_TREE_SERVICE_URL_DEMO;
        XmwcsConst_SERVICE_URL_APP_CONTROL = XmwcsConst_SERVICE_URL_APP_CONTROL_DEMO;
        XmwcsConst_SERVICE_URL_DEAL_STORE = XmwcsConst_SERVICE_URL_DEAL_STORE_DEMO;
        XmwcsConst_OPCODE_URL = XmwcsConst_SERVICE_URL_OPCODE_SERVICE_DEMO;
        XmwcsConst_FILE_UPLOAD_URL =XmwcsConst_SERVICE_URL_FILE_UPLOAD_SERVICE_DEMO;
    } else {
        // also set production server URLs here.
        XmwcsConst_SERVICE_URL = XmwcsConst_SERVICE_URL_PROD;
        XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT = XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT_PROD;
        XmwcsConst_PRODUCT_TREE_SERVICE_URL = XmwcsConst_PRODUCT_TREE_SERVICE_URL_PROD;
        XmwcsConst_SERVICE_URL_APP_CONTROL = XmwcsConst_SERVICE_URL_APP_CONTROL_PROD;
        XmwcsConst_SERVICE_URL_DEAL_STORE = XmwcsConst_SERVICE_URL_DEAL_STORE_PROD;
        XmwcsConst_OPCODE_URL = XmwcsConst_SERVICE_URL_OPCODE_SERVICE_PROD;
        XmwcsConst_FILE_UPLOAD_URL = XmwcsConst_SERVICE_URL_FILE_UPLOAD_SERVICE_PROD;
    }
}
- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if(isKeyboardOpen){
        //Cursor on textbox1
        self.view.frame  = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + movedbyHeight, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    isKeyboardOpen=true;
    
    
    NSDictionary* info = [aNotification userInfo];
    keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    
    CGRect textFieldRect = [self.view.window convertRect:activeTextField.bounds fromView:activeTextField];
    
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    NSLog(@"FormVC keyboardWasShown");
    NSLog(@"activeTextField.frame.origin.y = %f", activeTextField.frame.origin.y);
    NSLog(@"self.view.frame.size.height = %f", self.view.frame.size.height);
    
    if(textFieldRect.origin.y > (viewRect.size.height - keyboardSize.height)) {
        movedbyHeight =  textFieldRect.origin.y - (viewRect.size.height  - keyboardSize.height);
        movedbyHeight = movedbyHeight+35;
        //movedbyHeight =  textFieldRect.origin.y - keyboardSize.height ;
        
        self.view.frame  = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - movedbyHeight, self.view.frame.size.width, self.view.frame.size.height);
        
        
        
    }
    
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
    
    isKeyboardOpen=false;
    NSLog(@"FormVC keyboardWillBeHidden");
    
    
    self.view.frame  = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + movedbyHeight, self.view.frame.size.width, self.view.frame.size.height);
    
    
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
    
    
    return YES;
}




@end
