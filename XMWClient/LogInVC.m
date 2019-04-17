//
//  LogInVC.m
//  PolyCab
//
//  Created by dotvikios on 13/07/18.
//  Copyright © 2018 DotvikSol. All rights reserved.
//

#import "LogInVC.h"
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
#import "DashBoardVC.h"
#import "LeftViewVC.h"
#import "RightVC.h"
#import "FeedbackFormCustomerVC.h"
#import "CreateOrderVC1.h"
#import "CreateOrderVC2.h"
#import "LayoutClass.h"
#import <QuartzCore/QuartzCore.h>
#import "TermsVC.h"
#import "PaymentOutstandingReportView.h"
#import "EmployeeCreateOrderVC.h"
#import "NationalDashboardVC.h"
#import "ForgotPasswordVC.h"
#import "WideReportVC.h"
@interface LogInVC ()

@end
NSMutableDictionary *masterDataForEmployee;
@implementation LogInVC
{
    NetworkHelper *networkHelper;
    LoadingView *loadingView;
    NSString* m_username;
    NSString* customer_name;
    BOOL iconClick;
   
    bool isKeyboardOpen;
    CGSize keyboardSize;
    int movedbyHeight;
    UITextField* activeTextField;
}
@synthesize userName;
@synthesize password;
@synthesize menuDetailsDict;
@synthesize changeImage;
@synthesize authToken;
-(void)autoLayout{
    [LayoutClass setLayoutForIPhone6:self.constant1];
    [LayoutClass labelLayout:self.constant7 forFontWeight:UIFontWeightBold];
    [LayoutClass textfieldLayout:self.userName forFontWeight:UIFontWeightRegular];
    [LayoutClass textfieldLayout:self.password forFontWeight:UIFontWeightRegular];
    [LayoutClass setLayoutForIPhone6:self.constant3];
    [LayoutClass buttonLayout:self.constant2 forFontWeight:UIFontWeightRegular];
    [LayoutClass buttonLayout:self.constant4 forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.constant5 forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.costant8 forFontWeight:UIFontWeightLight];
    [LayoutClass labelLayout:self.constant9 forFontWeight:UIFontWeightLight];
    [LayoutClass buttonLayout:self.constant6 forFontWeight:UIFontWeightBold];
    [LayoutClass buttonLayout:self.forgotPasswordButton forFontWeight:UIFontWeightLight];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    masterDataForEmployee = [[NSMutableDictionary alloc]init];
    self.constant4.layer.masksToBounds = YES;
    self.constant4.layer.cornerRadius = 2.33f;
   
    self.userName.layer.masksToBounds = YES;
    self.userName.layer.cornerRadius = 2.33f;
    self.userName.layer.borderColor =(__bridge CGColorRef _Nullable)([UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0]);
    

    
    self.password.layer.masksToBounds = YES;
    self.password.layer.cornerRadius = 2.33f;

    self.password.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0]);
    
    
    [self autoLayout];
    
    NSLog(@"LogInVC call");

    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        
        statusBar.backgroundColor = [UIColor clearColor];//set whatever color you like
    }
    
    self.navigationController.navigationBarHidden = YES;
    
    iconClick = true;
    self.userName.delegate = self;
    self.password.delegate =self;
    self.userName.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor colorWithRed:(240/255.0) green:(240/255.0) blue:(240/255.0) alpha:1]);
    self.password.layer.borderColor =(__bridge CGColorRef _Nullable)([UIColor colorWithRed:(240/255.0) green:(240/255.0) blue:(240/255.0) alpha:1]);
    
    [self configureServerUrls];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setHidesBackButton:YES animated:YES];
    menuDetailsDict = [[NSMutableDictionary alloc]init];
   
    
    [DVAppDelegate pushModuleContext : AppConst_MOBILET_ID_DEFAULT];
    [ClientVariable createInstance : AppConst_MOBILET_ID_DEFAULT : true];
    [self registerForKeyboardNotifications];
    
    
    
    //for auto login if user already loggedIn
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"ISCHECKED"] isEqualToString:@"YES"]) {
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"USERNAME"]);
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"PASSWORD"]);
        
        self.userName.text =[[NSUserDefaults standardUserDefaults] valueForKey:@"USERNAME"];
        self.password.text =[[NSUserDefaults standardUserDefaults] valueForKey:@"PASSWORD"];
        [self signInButton:self];
    }
    


}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}
- (IBAction)showButtonTouch:(id)sender {
    password.secureTextEntry = false;
     NSLog(@"Start");
    [changeImage setImage:[UIImage imageNamed:@"blackeyeicon.png"]];
}
- (IBAction)showText:(id)sender {
    password.secureTextEntry=true;
    [changeImage setImage:[UIImage imageNamed:@"black-showpasswordicon.png"]];
     NSLog(@"End");
    
}


-(void)revealViewControllConfig{
    //for SWRevealViewController
    UIViewController *frontViewController;
    NSString *roleName =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"ROLE_NAME"]];
    
    
    
   
    
    if ([roleName isEqualToString:@"NATIONAL_ALL"] ) {
        NSLog(@"role name -: NATIONAL_ALL");
        
        AppConst_EMPLOYEE_SALES_AGGREGATE_CARD_DOC_ID = @"DR_NATIONAL_SALES_BU" ;
        AppConst_EMPLOYEE_SALES_AGGREGATE_PIE_CARD_DOC_ID = @"DR_NATIONAL_SALES_BU";
        AppConst_EMPLOYEE_PAYMENT_OUTSTANDING_PIE_CARD_DOC_ID = @"DR_NATIONAL_PAYMENT_OUTSTANDING_BU_WISE" ;
        AppConst_EMPLOYEE_OVERDUE_PIE_CARD_DOC_ID = @"DR_NATIONAL_OVERDUE_BU_WISE";
        
      frontViewController = [[NationalDashboardVC alloc] initWithNibName:@"DashBoardVC" bundle:nil];
    }
    
 
    
    
   else if ([roleName isEqualToString:@"BU_HEAD"]) {
        AppConst_EMPLOYEE_SALES_AGGREGATE_CARD_DOC_ID = @"DR_BU_SALES_REGION_WISE" ;
        AppConst_EMPLOYEE_SALES_AGGREGATE_PIE_CARD_DOC_ID = @"DR_BU_SALES_REGION_WISE";
        AppConst_EMPLOYEE_PAYMENT_OUTSTANDING_PIE_CARD_DOC_ID = @"DR_BU_PAYMENT_OUTSTANDING_REGION_WISE" ;
        AppConst_EMPLOYEE_OVERDUE_PIE_CARD_DOC_ID = @"DR_BU_OVERDUE_REGION_WISE";
        
        frontViewController = [[NationalDashboardVC alloc] initWithNibName:@"DashBoardVC" bundle:nil];
    }
    
   else if ([roleName isEqualToString:@"REGIONAL_HEAD"]) {
       AppConst_EMPLOYEE_SALES_AGGREGATE_CARD_DOC_ID = @"DR_BU_SALES_STATE_WISE" ;
       AppConst_EMPLOYEE_SALES_AGGREGATE_PIE_CARD_DOC_ID = @"DR_BU_SALES_STATE_WISE";
       AppConst_EMPLOYEE_PAYMENT_OUTSTANDING_PIE_CARD_DOC_ID = @"DR_BU_REGION_PAYMENT_OUTSTANDING_STATE_WISE" ;
       AppConst_EMPLOYEE_OVERDUE_PIE_CARD_DOC_ID = @"DR_BU_REGION_OVERDUE_STATE_WISE";
       
       frontViewController = [[NationalDashboardVC alloc] initWithNibName:@"DashBoardVC" bundle:nil];
   }
    
   else if ([roleName isEqualToString:@"STATE_HEAD"]) {
       AppConst_EMPLOYEE_SALES_AGGREGATE_CARD_DOC_ID = @"DR_BU_SALES_CUSTOMER_WISE" ;
       AppConst_EMPLOYEE_SALES_AGGREGATE_PIE_CARD_DOC_ID = @"DR_BU_SALES_CUSTOMER_WISE";
       AppConst_EMPLOYEE_PAYMENT_OUTSTANDING_PIE_CARD_DOC_ID = @"DR_BU_PAYMENT_OUTSTANDING_CUSTOMER_WISE" ;
       AppConst_EMPLOYEE_OVERDUE_PIE_CARD_DOC_ID = @"DR_BU_OVERDUE_CUSTOMER_WISE";
       
       frontViewController = [[NationalDashboardVC alloc] initWithNibName:@"DashBoardVC" bundle:nil];
   }
    
    else{
       frontViewController = [[DashBoardVC alloc] init];
    }
    
    LeftViewVC *rearViewController = [[LeftViewVC alloc] init];
    rearViewController.delegate = frontViewController;
    rearViewController.menuDetailsDict = menuDetailsDict;
    rearViewController.auth_Token = authToken;
   
   
    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
   
    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:frontNavigationController];
    revealController.delegate = frontViewController;
    
   // revealController.rightViewController = rightViewController;
    self.viewController = revealController;

    [UIApplication sharedApplication].keyWindow.rootViewController = self.viewController;
}

- (IBAction)forgotPasswordHandler:(id)sender {
    ForgotPasswordVC *fpvc = [[ForgotPasswordVC alloc]init];
    [self.navigationController pushViewController:fpvc animated:YES];
}



- (IBAction)signInButton:(id)sender {
    
    
    
    
    if([userName.text isEqualToString:@"Polycab#123"]) {
        SelectServerVC* selectServerVC =[[SelectServerVC alloc] initWithNibName:@"SelectServerVC" bundle:nil];
        [[self navigationController] pushViewController:selectServerVC  animated:YES];
        return;
    }
    
   else if ([userName.text isEqualToString:@""]||[password.text isEqualToString:@""]) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Authentication!" message:@"Blank Field" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        [myAlertView show];
    }
    
    
  
    
    
    
    else{
        ClientUserLogin* userLogin = [[ClientUserLogin alloc] init];
        NSString* trimmedString = [userName.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        m_username = trimmedString;
        userLogin.userName = trimmedString;
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
    
    }
}
- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    [loadingView removeView];
    if(respondedObject)
    {
    if([callName isEqualToString: XmwcsConst_CALL_NAME_FOR_LOGIN]) {
                    
                    ClientLoginResponse* clientLoginResponse = (ClientLoginResponse*)respondedObject;
                [LoginUtils setClientVariables :  clientLoginResponse : m_username];
        customer_name = [[clientLoginResponse.clientMasterDetail.masterDataRefresh valueForKey:@"USER_PROFILE"] valueForKey:@"customer_name"];
        NSMutableArray *roleList = [[NSMutableArray alloc]init];
        [roleList addObjectsFromArray:[clientLoginResponse.clientMasterDetail.masterDataRefresh valueForKey:@"LEVEL_WISE_ROLES"]];
        NSString *userRole= @"";
        for (int i=0; i<roleList.count; i++) {
            
            NSString *checkRole = [[roleList objectAtIndex:i] valueForKey:@"rolename"];
            if ([checkRole isEqualToString:@"NATIONAL_ALL"]) {
                userRole= @"NATIONAL_ALL";
                [[NSUserDefaults standardUserDefaults ]setObject:userRole forKey:@"ROLE_NAME"];
                break;
            }
           else if ([checkRole isEqualToString:@"BU_HEAD"]) {
               userRole= @"BU_HEAD";
               [[NSUserDefaults standardUserDefaults ]setObject:userRole forKey:@"ROLE_NAME"];
                break;
            }
           else if ([checkRole isEqualToString:@"REGIONAL_HEAD"]) {
               userRole= @"REGIONAL_HEAD";
               [[NSUserDefaults standardUserDefaults ]setObject:userRole forKey:@"ROLE_NAME"];
                break;
            }
           else if ([checkRole isEqualToString:@"STATE_HEAD"]) {
               userRole= @"STATE_HEAD";
               [[NSUserDefaults standardUserDefaults ]setObject:userRole forKey:@"ROLE_NAME"];
                break;
            }
        }
       
        
//        NSString *userRole = [[[clientLoginResponse.clientMasterDetail.masterDataRefresh valueForKey:@"LEVEL_WISE_ROLES"]objectAtIndex:0] valueForKey:@"rolename"];
        
        
     //   [[NSUserDefaults standardUserDefaults ]setObject:userRole forKey:@"ROLE_NAME"];
        
         [[NSUserDefaults standardUserDefaults ]setObject:customer_name forKey:@"CUSTOMER_NAME"];
        
        
                    [[NSUserDefaults standardUserDefaults] setObject:m_username forKey:@"USERNAME"];
                    authToken = clientLoginResponse.authToken;
                    NSLog(@"%@",authToken);
                 [[NSUserDefaults standardUserDefaults] setObject:clientLoginResponse.authToken forKey:@"AUTH_TOKEN"];
        
        [[NSUserDefaults standardUserDefaults] setObject:[clientLoginResponse.clientMasterDetail.masterData valueForKey:@"RMA_REASON"]  forKey:@"RMA_REASON"];
        
        [[NSUserDefaults standardUserDefaults] setObject:  [clientLoginResponse.clientMasterDetail.masterData valueForKey:@"UOMDESC"]  forKey:@"UOMDESC"];
        
      [[NSUserDefaults standardUserDefaults] setObject:    [clientLoginResponse.clientMasterDetail.masterData valueForKey:@"CORE"]  forKey:@"CORE"];
        
        [[NSUserDefaults standardUserDefaults] setObject:  [clientLoginResponse.clientMasterDetail.masterData valueForKey:@"COLOR"]  forKey:@"COLOR"];
        
        [[NSUserDefaults standardUserDefaults] setObject:  [clientLoginResponse.clientMasterDetail.masterData valueForKey:@"SQAUREMM"]  forKey:@"SQAUREMM"];
        
                    if([clientLoginResponse.userLoginStatus isEqualToString:@"0"])
                    {
                        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Authentication!" message:clientLoginResponse.userLoginMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
                        [myAlertView show];
        
                    }
                    else {
                        
                        if([clientLoginResponse.passwrdState isEqualToString:@"1"])
                        {
                            [LoginUtils setClientVariables:clientLoginResponse : m_username];
                            // we need to show password change screen
                            DotMenuObject *obj = [[DotMenuObject alloc]init];
                            obj.FORM_ID =@"DOT_FORM_1" ;
                            
                            NSMutableDictionary*  attachedData = [[NSMutableDictionary alloc]init];
                            [attachedData setObject:@"DOT_FORM_1" forKey:XmwcsConst_MENU_CONSTANT_FORM_ID];
                            NSMutableDictionary* forwardedDataDisplay = [[NSMutableDictionary alloc]init];
                            NSMutableDictionary* forwardedDataPost = [[NSMutableDictionary alloc]init];
                            DotFormPost* dotFormPost = [[DotFormPost alloc]init];
                            
                            FormVC* formController = [[FormVC alloc] initWithData : obj
                                                                                  : dotFormPost
                                                                                  : false
                                                                                  : forwardedDataDisplay
                                                                                  : forwardedDataPost];
                            
                            [[self navigationController] pushViewController:formController  animated:YES];
                            formController.headerStr    = @"Change Password";
                        }
                        
                        
                        
//                        else if([clientLoginResponse.userLoginStatus isEqualToString:@"1"]) //successfully login
                    else
                    {
                         [masterDataForEmployee setDictionary:clientLoginResponse.clientMasterDetail.masterDataRefresh];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:[[clientLoginResponse.clientMasterDetail.masterDataRefresh valueForKey:@"USER_PROFILE"]valueForKey:@"customer_name"]  forKey:@"customer_name"];
                        [[NSUserDefaults standardUserDefaults] setObject:m_username forKey:@"USERNAME"];
                        [[NSUserDefaults standardUserDefaults] setObject:self.password.text forKey:@"PASSWORD"];
                        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"ISCHECKED"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        // default context (MAIN)
                        ClientLoginResponse* clientLoginResponse =  (ClientLoginResponse*) respondedObject;
                        [LoginUtils setClientVariables :  clientLoginResponse : m_username];
                        
                        [self registerCustomReportVC];
                        [self registerCustomFormVC];
                        menuDetailsDict =clientLoginResponse.menuDetail;
                        
                        [self revealViewControllConfig];
                    }
                    }
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

#pragma mark - custom report VCs

-(void) registerCustomReportVC
{
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    // for My Details
    [clientVariables registerReportVCClass:@"MyDetailsVC" forId:@"DOT_REPORT_MYDETAIL"];
    
    [clientVariables registerReportVCClass:@"BalanceConfirmationVC" forId:@"DOT_REPORT_BALANCE_CONFIRMATION"];
    
     // for Dispatch Details
    [clientVariables registerReportVCClass:@"DispatchDetailsVC" forId:@"DOT_REPORT_DISPATCH_DETAILS_DW"];
    
    // for Payment Outstanding
    [clientVariables registerReportVCClass:@"PaymentOutstandingReportView" forId:@"DOT_REPORT_PAYMENT_OUTSTANDING"];
    
  // for WideReportVC
    [clientVariables registerReportVCClass:@"WideReportVC" forId:@"DOT_REPORT_EMPLOYEE_PORTAL_ORDERS"];
    
    // for WideReportVC drilldown
    [clientVariables registerReportVCClass:@"WideReportVC" forId:@"DOT_REPORT_EMPLOYEE_PORTAL_ORDERS_DD"];
    
}

#pragma mark - custom form VCs

-(void) registerCustomFormVC
{
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    // for My Manage Sub User
  [clientVariables registerFormVCClass:@"ManageSubUserVC" forId:@"DOT_FORM_Create_Sub_User"];
    
    // for FeedBack
  // [clientVariables registerFormVCClass:@"FeedBackVC" forId:@"DOT_FORM_FEEDBACK"];
   
    // for Feedback Form Customer
   [clientVariables registerFormVCClass:@"FeedbackFormCustomerVC" forId:@"DOT_FORM_FEEDBACK_FROM_CUSTOMER"];
    
    // for Create Order
    [clientVariables registerFormVCClass:@"EmployeeCreateOrderVC" forId:@"DOT_FORM_3"];
   
  // for BusinessVerticalVC
  [clientVariables registerFormVCClass:@"BusinessVerticalVC" forId:@"DOT_REPORT_5_BUSINESS_VERTICAL_SALES_REPORT"];
    
    // for SalesComparisonVC
    [clientVariables registerFormVCClass:@"SalesComparisonVC" forId:@"DOT_REPORT_5_SALES_COMPARISON"];
    
    // for RMAVC
     [clientVariables registerFormVCClass:@"RMAVC" forId:@"DOT_FORM_REQUEST_FOR_RETURN_MATERIAL"];
    
 ////for employee////////////////////////
    // for SalesComparisonVC
    [clientVariables registerFormVCClass:@"EmployeeSalesFormVC" forId:@"DOT_FORM_LEVEL_SALES_NATIONAL_WISE"];
    // for SalesComparisonVC
    [clientVariables registerFormVCClass:@"EmployeeSalesFormVC" forId:@"DOT_FORM_LEVEL_BU_NATIONAL_WISE"];
    // for SalesComparisonVC
    [clientVariables registerFormVCClass:@"EmployeeSalesFormVC" forId:@"DOT_FORM_BU_SALES_REGION_WISE"];
    // for SalesComparisonVC
    [clientVariables registerFormVCClass:@"EmployeeSalesFormVC" forId:@"DOT_FORM_BU_REGION_SALES_STATE_WISE"];
     [clientVariables registerFormVCClass:@"EmployeeSalesFormVC" forId:@"DOT_FORM_BU_SALES_CUSTOMER_WISE"];
    
/////////////////////////////
    
}

- (IBAction)signUpButton:(id)sender {

    SignUpVC *vc= [[SignUpVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

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
