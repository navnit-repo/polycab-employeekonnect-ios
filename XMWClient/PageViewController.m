//
//  PageViewController.m
//  XMWCS_iphone
//
//  Created by Ashish Tiwari on 07/05/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//



#import <MessageUI/MessageUI.h>
#import "OTPVC.h"

#import "PageViewController.h"
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


@interface PageViewController()
{
    BOOL isShowingLandscapeView;
    CGSize keyboardSize;
    UITextField* activeTextField;
    int movedbyHeight;
    DVCheckbox* checkBox;
    
    BOOL hasUserInitiatedSignin;
    bool isKeyboardOpen;
}

@end

@implementation PageViewController

@synthesize screenId;
@synthesize Name, Pass;
@synthesize responseData = _responseData;
// @synthesize navigationController;
@synthesize userName,password;
@synthesize menuList;
@synthesize phoneNumberView;
@synthesize otpTextField;

static bool showMenu = true;
static HamBurgerMenuView* rightSlideMenu = nil;
static  XMWAbout* aboutBox = nil;
static XMWFaqWebViewController* faqWebView = nil;



- (void)viewDidLoad
{
    [super viewDidLoad];
    //my code
    self.otpTextField.delegate = self;
    phoneNumberView.hidden = YES;

    [self awakeFromNib];
    
    [self configureServerUrls];
    
    
    hasUserInitiatedSignin = YES;
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    // self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    UILabel*  titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 40)];
    titleLabel.text = @"Havells mKonnect";
    titleLabel.textColor = [Styles headerTextColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.navigationItem setTitleView: titleLabel];
    
    self.navigationItem.hidesBackButton = YES;
    
    
    checkBox = [[DVCheckbox alloc] initWithFrame:CGRectMake(0, 0, 30, 30) check:YES enable:YES];
    [self.cbView addSubview:checkBox];
    
    
    menuList = [[NSMutableArray alloc] init];
    
    [menuList addObject:@"About"];
    [menuList addObject:@"FAQ"];
    [menuList addObject:@"Forgot Password"];
    [menuList addObject:@"Exit"];
    
    // end of right side menu button and content
    

    [DVAppDelegate pushModuleContext : AppConst_MOBILET_ID_DEFAULT];
    [ClientVariable createInstance : AppConst_MOBILET_ID_DEFAULT : true];
    
    
    userName.delegate           = self;
    password.delegate           = self;
    
   	[userName setPlaceholder:@"UserName"];
    [password setPlaceholder:@"Password"];
    password.secureTextEntry = YES;
    
    self.title = @"mKonnect Login";
    

    // initialize with pre stored username
    m_username = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
	if(m_username!=nil && ![m_username isEqualToString:@""]) {
        userName.text = m_username;
	}
    
    
    NSString* savedPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"PASSWORD"];
    NSString* signedInChecked = [[NSUserDefaults standardUserDefaults] objectForKey:@"ISCHECKED"];
    if(signedInChecked!=nil && [signedInChecked isEqualToString:@"YES"]) {
        if(savedPassword!=nil && [savedPassword length]>0) {
            password.text = savedPassword;
        }
    }
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnForgotPassword:)];
    
    [self.forgotPasswordLabel addGestureRecognizer:tapGesture];
    
    [self registerForKeyboardNotifications];


    NSString* welcomeFlag = [[NSUserDefaults standardUserDefaults] objectForKey:@"welcomeMessageFlag"];
    
    if( (welcomeFlag==nil) || [welcomeFlag isEqualToString:@"NO"] ) {
        [self addWelcomeMessageNotification];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"welcomeMessageFlag"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    if(signedInChecked!=nil && [signedInChecked isEqualToString:@"YES"]) {
        if(savedPassword!=nil && [savedPassword length]>0) {
            NSDate* lastLoggedInTime =  [[NSUserDefaults standardUserDefaults] objectForKey:@"LAST_LOGGED_IN_TIME"];
            NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:lastLoggedInTime];
            if(interval < 3600*24) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self SignInButtonPressed:nil];
                });
            }
        }
    }
}


-(void) addWelcomeMessageNotification
{
    [NotificationRequestStorage createInstance : @"NOTIFICATION_STORAGE" : true];
    NotificationRequestStorage *notificationStorage = [NotificationRequestStorage getInstance];
    
    //insert data in to storage
    NotificationRequestItem* notificationRequestItem = [[NotificationRequestItem alloc] init];
    notificationRequestItem.KEY_ID = 0;
    notificationRequestItem.KEY_READ = @"UnRead";
    notificationRequestItem.KEY_DELETE = @"False";
    notificationRequestItem.KEY_NOTIFY_CONTENT_TYPE = @"Other";
    notificationRequestItem.KEY_NOTIFY_CONTENT_TITLE =  @"Havells mKonnect";
    notificationRequestItem.KEY_NOTIFY_COTENT_MSG = @"Welcome to Havells mKonnect";
    notificationRequestItem.KEY_NOTIFY_CONTENT_URL = @"";
    notificationRequestItem.KEY_NOTIFY_CONTENT_DATA = @"";
    notificationRequestItem.KEY_NOTIFY_CALLBACK_DATA = @"";
    notificationRequestItem.KEY_NOTIFY_FIELD1 = @"";
    notificationRequestItem.KEY_NOTIFY_FIELD2 =@"";
    notificationRequestItem.KEY_RESPOND_TO_BACK = @"";
    notificationRequestItem.KEY_REQUIRE_LOGIN = @"";
    
    notificationRequestItem.KEY_NOTIFY_CREATE_DATE = @"2099-01-11 00:00:00";
    notificationRequestItem.KEY_NOTIFY_LOGID = @"0";
    notificationRequestItem.KEY_CALLNAME = @"";
    [notificationStorage insertDoc:notificationRequestItem];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)SignInButtonPressed:(id)sender
{
    if(sender==nil) {
        hasUserInitiatedSignin = NO;
        
    }
    
    if([userName.text isEqualToString:@"DotVik#123"]) {
        SelectServerVC* selectServerVC =[[SelectServerVC alloc] initWithNibName:@"SelectServerVC" bundle:nil];
        [[self navigationController] pushViewController:selectServerVC  animated:YES];
        return;
    }
    
    NSLog(@"Login Button Pressed");
    NSLog(@ "name = %@" ,userName.text);
    NSLog (@"pass = %@", password.text);
    
    NSString* trimmedString = [userName.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    m_username = trimmedString;
    if( [trimmedString length] > 0) {
        ClientUserLogin* userLogin = [[ClientUserLogin alloc] init];
        
        if([trimmedString isEqualToString:XmwcsConst_DEMO_USER]) {
            userLogin.userName = XmwcsConst_DEMO_USER_MAPPED;
            // also set developer / qa server URLs here
            XmwcsConst_SERVICE_URL = XmwcsConst_SERVICE_URL_DEMO;
            XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT = XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT_DEMO;
            XmwcsConst_PRODUCT_TREE_SERVICE_URL = XmwcsConst_PRODUCT_TREE_SERVICE_URL_DEMO;
            XmwcsConst_SERVICE_URL_APP_CONTROL = XmwcsConst_SERVICE_URL_APP_CONTROL_DEMO;
        } else {
            userLogin.userName = trimmedString;
        }
        
        userLogin.password = password.text;
        userLogin.deviceInfoMap = [[NSMutableDictionary alloc]init];
        //start for default auth
        NSString* uniqueID = @"000000000000000";
        [userLogin.deviceInfoMap setObject:uniqueID forKey:XmwcsConst_IMEI];
        //close
        NSUUID* vendorId = [UIDevice currentDevice].identifierForVendor;
    
       // [userLogin.deviceInfoMap setObject:XmwcsConst_IMEI forKey:vendorId.UUIDString];
        [userLogin.deviceInfoMap setObject:vendorId.UUIDString forKey:XmwcsConst_IMEI];
        [userLogin.deviceInfoMap setObject:@"1" forKey:@"IS_NOT_IMEI"];
    
        [userLogin.deviceInfoMap setObject:@"IPhone" forKey:XmwcsConst_DEVICE_MODEL];
        [userLogin.deviceInfoMap setObject:@"DEVICE_DETAIL" forKey:XmwcsConst_DEVICE_DETAIL];
    
        userLogin.language = AppConst_LANGUAGE_DEFAULT;
        userLogin.moduleId = AppConst_MOBILET_ID_DEFAULT;
    
        loadingView = [LoadingView loadingViewInView:self.view];
        ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
        clientVariables.CLIENT_USER_LOGIN = userLogin;
        
        
        networkHelper = [[NetworkHelper alloc] init];
        [networkHelper makeXmwNetworkCall:userLogin :self : vendorId.UUIDString :XmwcsConst_CALL_NAME_FOR_LOGIN];
    
    
        
        // store it in the default local storage
        
        NSMutableDictionary* credMap = [[NSMutableDictionary alloc]init];
        [credMap setObject:trimmedString forKey:@"USERNAME"];
        // [credMap setObject:password.text forKey:@"PASSWORD"];
        [[ObjectStorage getInstance] writeJsonObject:@"ESS_LOGIN" :credMap];
        [[ObjectStorage getInstance] flushStorage];
        
    
    } else {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"mKonnect Authentication!" message: @"Please enter username." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        [myAlertView show];
        
    
    }

}

-(IBAction) settingsButtonHandler:(id)sender
{
    NSLog(@"Settings Button Pressed");
     float calcHeight = [menuList count] * 32;
    if(showMenu)
    {
        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
          //  rightSlideMenu = [[HamBurgerMenuView alloc] initWithFrame:CGRectMake(  [UIScreen mainScreen].bounds.size.height - 160.0f, -250, 160.0f, calcHeight) withMenu:menuList handler:self];
        } else {
          //  rightSlideMenu = [[HamBurgerMenuView alloc] initWithFrame:CGRectMake(  [UIScreen mainScreen].bounds.size.width - 160.0f, -250, 160.0f, calcHeight) withMenu:menuList handler:self];
        }
        
        [self.view addSubview : rightSlideMenu];
        
        [UIView beginAnimations:@"rightSlideMenu" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];

        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
            rightSlideMenu.frame = CGRectMake( [UIScreen mainScreen].bounds.size.height - 160.0f, 0.0f, 160.0f, calcHeight);
        } else {
            rightSlideMenu.frame = CGRectMake( [UIScreen mainScreen].bounds.size.width - 160.0f, 0.0f, 160.0f, calcHeight);
        }
        
        [UIView commitAnimations];
        
        showMenu = false;
    } else {
        [UIView beginAnimations:@"rightSlideMenu" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(menuRemoved:)];
        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
            rightSlideMenu.frame = CGRectMake( [UIScreen mainScreen].bounds.size.height - 160.0f, -250, 160.0f, calcHeight);
        } else {
            rightSlideMenu.frame = CGRectMake( [UIScreen mainScreen].bounds.size.width - 160.0f, -250, 160.0f, calcHeight);
        }
        [UIView commitAnimations];

        showMenu = true;
    }
    
}

-(IBAction)menuRemoved:(id)sender
{
    NSLog(@"menuRemoved");
    [rightSlideMenu removeFromSuperview];
    
}
    
-(IBAction)CancleButtonPressed:(id)sender
{
    
    NSLog(@"Cancel Button Pressed");
    
    exit(0);
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    return TRUE;
}


-(BOOL)doesString:(NSString *)string containCharacter:(char)character
{
    if ([string rangeOfString:[NSString stringWithFormat:@"%c",character]].location != NSNotFound)
    {
        return YES;
    }
    return NO;
}

// protocol implementation of HttpEventListener
- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject {
    
    [loadingView removeView];
   
    
    //MY CODE
    if ([callName isEqualToString:@"otpCall"])
    {
        phoneNumberView.hidden = NO;

    }
    if ([callName isEqualToString:@"otpResend"])
    {
       phoneNumberView.hidden = NO;
        
    }
    
    if(respondedObject)
    {
        if([callName isEqualToString: XmwcsConst_CALL_NAME_FOR_LOGIN]) {
        
            ClientLoginResponse* clientLoginResponse = (ClientLoginResponse*)respondedObject;
            if([clientLoginResponse.userLoginStatus isEqualToString:@"0"])
            {
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"mKonnect Authentication!" message:clientLoginResponse.userLoginMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
                [myAlertView show];
                
            } else {
                if([clientLoginResponse.passwrdState isEqualToString:@"1"])
                {
                    [LoginUtils setClientVariables:clientLoginResponse : m_username];
                    // we need to show password change screen
                   //  NSMutableDictionary*  attachedData = [[NSMutableDictionary alloc]init];
                   // [attachedData setObject:@"DOT_FORM_1" forKey:XmwcsConst_MENU_CONSTANT_FORM_ID];
                    NSMutableDictionary* forwardedDataDisplay = [[NSMutableDictionary alloc]init];
                    NSMutableDictionary* forwardedDataPost = [[NSMutableDictionary alloc]init];
                    DotFormPost* dotFormPost = [[DotFormPost alloc]init];
                    
                    DotMenuObject* formMenuObject = [[DotMenuObject alloc] init];
                    formMenuObject.FORM_ID = @"DOT_FORM_1";
                
              
                    FormVC* formController = [[FormVC alloc] initWithData : formMenuObject
                                                                      : dotFormPost
                                                                      : false
                                                                      : forwardedDataDisplay
                                                                      : forwardedDataPost];
                
                    [[self navigationController] pushViewController:formController  animated:YES];
                    formController.headerStr	= @"Change Password";
                                   
                } else {
                    ClientLoginResponse* clientLoginResponse =  (ClientLoginResponse*) respondedObject;
                    [LoginUtils setClientVariables :  clientLoginResponse : m_username];
                    
            
                    // default context (MAIN)
                    ClientVariable* clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
                    
                    [self registerCustomReportVC];
                    [self registerCustomFormVC];
                    
                    
                    // @@@@Pradeep@@@@@ we would like to save username and password as per keep me signed in flag
                    
                    if([checkBox isChecked] == YES) {
                        // save username and password in the User Defaults;
                       // m_username
                        [[NSUserDefaults standardUserDefaults] setObject:m_username forKey:@"USERNAME"];
                        [[NSUserDefaults standardUserDefaults] setObject:self.password.text forKey:@"PASSWORD"];
                        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"ISCHECKED"];
                        
                        if(hasUserInitiatedSignin==YES) {
                            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"LAST_LOGGED_IN_TIME"];
                        }
                        
                        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"LAST_AUTO_LOGGED_IN_TIME"];
                    } else {
                        [[NSUserDefaults standardUserDefaults] setObject:m_username forKey:@"USERNAME"];
                        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"PASSWORD"];
                        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"ISCHECKED"];
                    }
                    
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    if (userName.text.length >7) {
                        MenuVC *menuVC = [[MenuVC alloc] initWithNibName:@"MenuVC" bundle:nil];
                        menuVC.screenId = XmwcsConst_EssMenuScreen;
                        menuVC.isFirstScreen                = YES;
                        menuVC.menuDetail  = clientVariables.CLIENT_LOGIN_RESPONSE.menuDetail;
                        
                        UINavigationController* navController  = [[UINavigationController alloc] initWithRootViewController:menuVC];
                        [[UIApplication sharedApplication] keyWindow].rootViewController = navController;
                        
                        DVAppDelegate* appDelegate = (DVAppDelegate*)[UIApplication sharedApplication].delegate;
                        appDelegate.navController = navController;
                    } else {
                        DashBoardMenuViewController *dashBoardMenuViewController = [[DashBoardMenuViewController alloc] initWithNibName:@"DashBoardMenuViewController" bundle:nil];
                        dashBoardMenuViewController.screenId = XmwcsConst_EssMenuScreen;
                        dashBoardMenuViewController.isFirstScreen                = YES;
                        dashBoardMenuViewController.menuDetail  = clientVariables.CLIENT_LOGIN_RESPONSE.menuDetail;
                        
                        UINavigationController* navController  = [[UINavigationController alloc] initWithRootViewController:dashBoardMenuViewController];
                        [[UIApplication sharedApplication] keyWindow].rootViewController = navController;
                        
                        DVAppDelegate* appDelegate = (DVAppDelegate*)[UIApplication sharedApplication].delegate;
                        appDelegate.navController = navController;
                        
                    }
                }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //code to be executed in the background
                        [self registerDeviceToken];
                    });
                }
            }
        } else if([callName isEqualToString: XmwcsConst_CALL_NAME_FOR_FORGOT_PASSWORD]) {
            DocPostResponse* docPostResponse = (DocPostResponse*) respondedObject;
            
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"mKonnect Response" message:docPostResponse.submittedMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
            [myAlertView show];
        }
 
        else if ([callName isEqualToString:XmwcsConst_CALL_NAME_FOR_NOTIFY_DEVICE_REGISTER])
        {
            DocPostResponse* docPostResponse = (DocPostResponse*) respondedObject;
           // no need to tell user on the device reqistation.
            /*
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"mKonnect Response" message:docPostResponse.submittedMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
            [myAlertView show];
             */
        }
    
    
    

}

- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];


    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"mKonnect Authentication!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
    
}

- (void) httpInterruptHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];

    
    
}


// protocol implementation of HamBurgerMenuHandler

-(void) menuClicked : (int) idx
{
    NSLog(@"Hamburger menu clicked with idx %d", idx);
    [rightSlideMenu removeFromSuperview];
    showMenu = true;
    
    // write your all menus handling here
    
    // [menuList addObject:@"About"];
    switch (idx) {
        case 0:  ; // about
            {
                self.navigationItem.rightBarButtonItem.enabled = false;
                aboutBox = (XMWAbout*)[XMWAbout loadingViewInView:self.view handler:self];
            }
            break;
        case 1:  ;// faq
            {
                faqWebView = [[XMWFaqWebViewController alloc] initWithNibName:@"XMWFaqWebViewController" bundle:nil];
                [[self navigationController] pushViewController:faqWebView  animated:YES];
            }
            break;
        case 2:  ;// forgot password
            [self forgotPasswordRequest];
            break;
        case 3:  exit(0); // exit
            break;
    }
}

// XMWAboutCloseDelegate protocol implementation

-(void) aboutClosed
{
    self.navigationItem.rightBarButtonItem.enabled = true;
    
}


-(IBAction)tapOnForgotPassword:(id)sender
{
    [self forgotPasswordRequest];
}

- (void) forgotPasswordRequest
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@"Email",@"Phone Number",nil];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Reset With"
                                                        message:nil delegate:self
                                              cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    
    alertView.alertViewStyle = UIAlertViewStyleDefault;
    
    for(NSString *buttonTitle in array)
    {
        [alertView addButtonWithTitle:buttonTitle];
    }
 
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString* trimmedString = [userName.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    m_username = trimmedString;
    
    NSString *click = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([click isEqualToString:@"Email"])
    {
        if([trimmedString length] > 0) {
                NSMutableDictionary* forgotData = [[NSMutableDictionary alloc] init];
        
                [forgotData setObject:trimmedString forKey:XmwcsConst_FORGOT_PWD_USER_ID ];
                [forgotData setObject:AppConst_MOBILET_ID_DEFAULT forKey:XmwcsConst_FORGOT_PWD_MODULE_ID ];
        
                NSUUID* vendorId = [UIDevice currentDevice].identifierForVendor;
        
                loadingView = [LoadingView loadingViewInView:self.view];
                networkHelper = [[NetworkHelper alloc] init];
                [networkHelper makeXmwNetworkCall:forgotData :self : vendorId.UUIDString :XmwcsConst_CALL_NAME_FOR_FORGOT_PASSWORD];
        
            } else {
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"mKonnect Authentication!" message: @"Please enter username." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
                [myAlertView show];
            }

    }
    
    else if([click isEqualToString: @"Phone Number"])
    {
//        //Network Call
//
//
//        NSDictionary *data = [[NSDictionary alloc]initWithObjectsAndKeys:m_username,@"CUSTOMER",nil];
//        NSMutableDictionary * otpCall = [[NSMutableDictionary  alloc]init];
//        [otpCall setObject:data forKey:@"data"];
//        [otpCall setObject:@"generateOtp" forKey:@"opcode"];
//        networkHelper = [[NetworkHelper alloc]init];
//        NSString * url=@"http://192.168.1.24:8080/xmwcsdealermkonnect/store";
//        networkHelper.serviceURLString = url;
//        [networkHelper genericJSONPayloadRequestWith:otpCall :self :@"otpCall"];
//        loadingView = [LoadingView loadingViewInView:self.view];
    
      phoneNumberView.hidden = NO;
    
    }
 
    }

// -------------------------------------------------------------------------------
//  displayMailComposerSheet
//  Displays an email composition interface inside the application.
//  Populates all the Mail fields.
// -------------------------------------------------------------------------------
- (void)displayMailComposerSheet
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"mKonnect Registration"];
    
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:@"mail.admin@havells.com"];
    //NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    // NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
    
    [picker setToRecipients:toRecipients];
   // [picker setCcRecipients:ccRecipients];
    // [picker setBccRecipients:bccRecipients];
    
    // Attach an image to the email
  //  NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"jpg"];
   // NSData *myData = [NSData dataWithContentsOfFile:path];
   // [picker addAttachmentData:myData mimeType:@"image/jpeg" fileName:@"rainy"];
    
    // Fill out the email body text
    NSUUID* vendorId = [UIDevice currentDevice].identifierForVendor;
    // vendorId.UUIDString
    NSString *emailBody =    [NSString stringWithFormat: @"For my iPhone device UUID %@", vendorId.UUIDString ]; //@"It is raining in sunny California!";
    [picker setMessageBody:emailBody isHTML:NO];
    
    [self presentViewController:picker animated:YES completion:NULL];
}



#pragma mark - Delegate Methods

// -------------------------------------------------------------------------------
//  mailComposeController:didFinishWithResult:
//  Dismisses the email composition interface when users tap Cancel or Send.
//  Proceeds to update the message field with the result of the operation.
// -------------------------------------------------------------------------------
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //self.feedbackMsg.hidden = NO;
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //self.feedbackMsg.text = @"Result: Mail sending canceled";
            break;
        case MFMailComposeResultSaved:
            //self.feedbackMsg.text = @"Result: Mail saved";
            break;
        case MFMailComposeResultSent:
           // self.feedbackMsg.text = @"Result: Mail sent";
            break;
        case MFMailComposeResultFailed:
            // self.feedbackMsg.text = @"Result: Mail sending failed";
            break;
        default:
           // self.feedbackMsg.text = @"Result: Mail not sent";
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}



- (NSUInteger)supportedInterfaceOrientations
{
    if(isIphone) {
        return UIInterfaceOrientationMaskPortrait;
    } else {
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft;
    }
}



- (void)awakeFromNib
{
     if(isIphone) {
         NSLog(@"iPhone mode, no need to have rotation");
     } else {
         
         NSLog(@"PageViewController awakeFromNib");
         isShowingLandscapeView = NO;
         [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
         [[NSNotificationCenter defaultCenter] addObserver:self
                                                  selector:@selector(orientationChanged:)
                                                      name:UIDeviceOrientationDidChangeNotification
                                                    object:nil];
     }
}

- (void)orientationChanged:(NSNotification *)notification
{
    NSLog(@"PageViewController orientationChanged");
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation) &&
        !isShowingLandscapeView)
    {
        // [self performSegueWithIdentifier:@"DisplayAlternateView" sender:self];
        isShowingLandscapeView = YES;
        
        UIView* view = [self.view viewWithTag:50];
        
        float posX = ([[UIScreen mainScreen] bounds].size.height - view.frame.size.width)/2;  // landscape, height is width
        float posY = ([[UIScreen mainScreen] bounds].size.width - view.frame.size.height)/2;
        view.frame = CGRectMake(posX, posY, view.frame.size.width, view.frame.size.height);
        
        if(!showMenu) {
                rightSlideMenu.frame = CGRectMake( [UIScreen mainScreen].bounds.size.height - 160.0f, 0.0f, 160.0f, rightSlideMenu.frame.size.height);
        }
        
        
    }
    else if (UIDeviceOrientationIsPortrait(deviceOrientation) &&
             isShowingLandscapeView)
    {
        // [self dismissViewControllerAnimated:YES completion:nil];
        isShowingLandscapeView = NO;
        UIView* view = [self.view viewWithTag:50];
        float posX = ([[UIScreen mainScreen] bounds].size.width - view.frame.size.width)/2;
        float posY = ([[UIScreen mainScreen] bounds].size.height - view.frame.size.height)/2;
        view.frame = CGRectMake(posX, posY, view.frame.size.width, view.frame.size.height);
        
        if(!showMenu) {
            rightSlideMenu.frame = CGRectMake( [UIScreen mainScreen].bounds.size.width - 160.0f, 0.0f, 160.0f, rightSlideMenu.frame.size.height);
        }
    }
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
        movedbyHeight =  textFieldRect.origin.y - (viewRect.size.height  - keyboardSize.height) ;
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


- (void)textFieldDidEndEditing:(UITextField *)textField
{
   
 
    
}

-(void)registerDeviceToken
{
    NSString *bundleIdentifier =   [[NSBundle mainBundle] bundleIdentifier];
    NSString* deviceTokenString =[[NSUserDefaults standardUserDefaults] objectForKey:@"PUSH_TOKEN"];
    
    if(deviceTokenString!=nil) {
        NotificationDeviceRegister* deviceRegister = [[NotificationDeviceRegister alloc] init];
        deviceRegister.appId = bundleIdentifier;
        deviceRegister.devicePort = @"123";
        deviceRegister.deviceRegisterId = deviceTokenString;
        deviceRegister.imei = @"";
        deviceRegister.moduleId = @"";
        deviceRegister.sessionDetail = @"";
        
        ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
        deviceRegister.userId = clientVariables.CLIENT_USER_LOGIN.userName;
        deviceRegister.os =  XmwcsConst_DEVICE_TYPE_IPHONE;
        
        networkHelper = [[NetworkHelper alloc] init];
        [networkHelper registerDevice:deviceRegister :self :XmwcsConst_CALL_NAME_FOR_NOTIFY_DEVICE_REGISTER];
    }
}


#pragma mark - custom report VCs

-(void) registerCustomReportVC
{
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    
    // for edit order
    [clientVariables registerReportVCClass:@"EditOrderVC" forId:@"DOT_REPORT_33_1"];
    
    // for Gold Card update
    [clientVariables registerReportVCClass:@"GoldCardUpdateVC" forId:@"DOT_REPORT_8"];
    
    // for Gold Card update
    [clientVariables registerReportVCClass:@"OrderListVC" forId:@"DOT_REPORT_33"];
    
    
    // for Proof Of Delivery Update
    [clientVariables registerReportVCClass:@"ProofOfDeliveryVC" forId:@"DOT_REPORT_12"];
    

 
    
    
}

#pragma mark - custom form VCs

-(void) registerCustomFormVC
{
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    
    // for Proof Of Delivery Custom form
    [clientVariables registerFormVCClass:@"PODFormVC" forId:@"DOT_FORM_12"];
    // for Customer Claims
    [clientVariables registerFormVCClass:@"CustomerClaimVC" forId:@"DOT_FORM_41"];
    
    // for My Claim
    [clientVariables registerFormVCClass:@"MyClaimVC" forId:@"DOT_FORM_42_CLAIMS"];
  
    
    // Pradeep: Commenting below as it is not going in the release
    // This feature was added to to support special price store
    // and is not tested and released
   // [clientVariables registerFormVCClass:@"DivisionVC" forId:@"DOT_FORM_3"];
    
    
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
    } else if([currentServerStr isEqualToString:@"QA"]) {
        XmwcsConst_SERVICE_URL = XmwcsConst_SERVICE_URL_DEMO;
        XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT = XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT_DEMO;
        XmwcsConst_PRODUCT_TREE_SERVICE_URL = XmwcsConst_PRODUCT_TREE_SERVICE_URL_DEMO;
        XmwcsConst_SERVICE_URL_APP_CONTROL = XmwcsConst_SERVICE_URL_APP_CONTROL_DEMO;
        XmwcsConst_SERVICE_URL_DEAL_STORE = XmwcsConst_SERVICE_URL_DEAL_STORE_DEMO;
    } else {
        // also set production server URLs here.
        XmwcsConst_SERVICE_URL = XmwcsConst_SERVICE_URL_PROD;
        XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT = XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT_PROD;
        XmwcsConst_PRODUCT_TREE_SERVICE_URL = XmwcsConst_PRODUCT_TREE_SERVICE_URL_PROD;
        XmwcsConst_SERVICE_URL_APP_CONTROL = XmwcsConst_SERVICE_URL_APP_CONTROL_PROD;
        XmwcsConst_SERVICE_URL_DEAL_STORE = XmwcsConst_SERVICE_URL_DEAL_STORE_PROD;
    }
}

//my code
- (void)viewDidAppear:(BOOL)animated{
    otpTextField.text = @"";
}
- (IBAction)otpSubmitButton:(id)sender {
    if ([otpTextField.text isEqualToString:@""]) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"mKonnect Authentication!" message:@"OTP field does not blank." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        [myAlertView show];
    }
    else{
        //network Call pending
        
    OTPVC *otpSubmitVC= [[OTPVC alloc]init];
     phoneNumberView.hidden = YES;
    [[self navigationController]pushViewController:otpSubmitVC animated:YES];
    }
}
- (IBAction)otpResendButton:(id)sender {
    
            //Network Call
            NSDictionary *data = [[NSDictionary alloc]initWithObjectsAndKeys:m_username,@"CUSTOMER",nil];
            NSMutableDictionary * otpCall = [[NSMutableDictionary  alloc]init];
            [otpCall setObject:data forKey:@"data"];
            [otpCall setObject:@"generateOtp" forKey:@"opcode"];
            networkHelper = [[NetworkHelper alloc]init];
            NSString * url=@"http://192.168.1.24:8080/xmwcsdealermkonnect/store";
            networkHelper.serviceURLString = url;
            [networkHelper genericJSONPayloadRequestWith:otpCall :self :@"otpResend"];
        loadingView = [LoadingView loadingViewInView:self.view];
}

@end
