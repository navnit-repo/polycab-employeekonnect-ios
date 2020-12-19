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
#import "ChatThreadList_Object.h"
#import "ChatThreadList_DB.h"
#import "ContactList_DB.h"
#import "ContactList_Object.h"
#import <Security/Security.h>
#import "KeychainWrapper.h"
#import "KeychainItemWrapper.h"
#import "UpdateAppVersion.h"
#import "ScreenMapper.h"


@interface LogInVC ()
{
    NSString* versionDownloaderUrl;
}

@end
NSMutableDictionary *masterDataForEmployee;
NSString *chatPersonUserID;
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
    KeychainWrapper *keychainWrapper;
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
    [self configureServerUrls];
    [self checkVersion];
    
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

    
//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//
//    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
//
//        statusBar.backgroundColor = [UIColor clearColor];//set whatever color you like
//    }
//
    
    UIView *statusBar;

      if (@available(iOS 13.0, *)) {
          statusBar = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame] ;
          statusBar.backgroundColor = [UIColor clearColor];
      } else {
          // Fallback on earlier versions
          if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {

              statusBar.backgroundColor = [UIColor clearColor];//set whatever color you like
          }

      }
    
    self.navigationController.navigationBarHidden = YES;
    
    iconClick = true;
    self.userName.delegate = self;
    self.password.delegate =self;
    self.userName.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor colorWithRed:(240/255.0) green:(240/255.0) blue:(240/255.0) alpha:1]);
    self.password.layer.borderColor =(__bridge CGColorRef _Nullable)([UIColor colorWithRed:(240/255.0) green:(240/255.0) blue:(240/255.0) alpha:1]);
    
//    [self configureServerUrls];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setHidesBackButton:YES animated:YES];
    menuDetailsDict = [[NSMutableDictionary alloc]init];
   
    
    [DVAppDelegate pushModuleContext : AppConst_MOBILET_ID_DEFAULT];
    [ClientVariable createInstance : AppConst_MOBILET_ID_DEFAULT : true];
    [self registerForKeyboardNotifications];
    
    
    
    //for auto login if user already loggedIn
//    NSString* isChecked = [[NSUserDefaults standardUserDefaults] objectForKey:@"ISCHECKED"];
//      if (isChecked !=nil &&[isChecked isEqualToString:@"YES"]) {
//          KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:XmwcsConst_KEYCHAIN_IDENTIFIER accessGroup:nil];
//
//          NSString* username = [keychainItem objectForKey:kSecAttrAccount];
//          NSString* password = [[NSString alloc] initWithData:[keychainItem objectForKey:kSecValueData] encoding:NSUTF8StringEncoding];
//          NSLog(@"UserId :- %@",username);
//          NSLog(@"Password :- %@",password);
//
//        self.userName.text =username;
//        self.password.text =password;
//        [self signInButton:self];
//    }
//


}
-(void)autoLogin
{
    // if server under maintenence
    NSString* maintenenceFlag = [[NSUserDefaults standardUserDefaults] objectForKey:@"SERVER_UNDER_MAINTENANCE"];
    
    //for auto login if user already loggedIn
    NSString* isChecked = [[NSUserDefaults standardUserDefaults] objectForKey:@"ISCHECKED"];
    
      if (isChecked !=nil &&[isChecked isEqualToString:@"YES"]) {
          KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:XmwcsConst_KEYCHAIN_IDENTIFIER accessGroup:nil];

          NSString* username = [keychainItem objectForKey:kSecAttrAccount];
          NSString* password = [[NSString alloc] initWithData:[keychainItem objectForKey:kSecValueData] encoding:NSUTF8StringEncoding];
          NSLog(@"UserId :- %@",username);
          NSLog(@"Password :- %@",password);

        self.userName.text =username;
        self.password.text =password;
          
          if(maintenenceFlag!=nil && [maintenenceFlag isEqualToString:@"YES"]) {
              NSLog(@"Server flag under maintenance is YES");
          } else {
              [self signInButton:self];
          }
            
        }
    
}
-(void) checkVersion
{
    NSMutableDictionary* versionRequest = [[NSMutableDictionary alloc] init];
    [versionRequest setObject:[[NSBundle mainBundle] bundleIdentifier] forKey:XmwcsConst_APP_ID];
    [versionRequest setObject:XmwcsConst_DEVICE_TYPE_IPHONE forKey:XmwcsConst_DEVICE_TYPE];
    
    NetworkHelper* networkHelper = [[NetworkHelper alloc] init];
    [networkHelper versionCheck: versionRequest :self :XmwcsConst_CALL_NAME_FOR_UPDATE_APP_VERSION];
}
-(void) handleUpgrade:(NSString*) downloadURL
{
    versionDownloaderUrl  = [downloadURL copy];
    UIAlertView* downloadUpgradePrompt = [[UIAlertView alloc] initWithTitle:@"Polycab Sales Connect Version Check" message:@"Update is available. Do you want to download?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [downloadUpgradePrompt show];
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
    loadingView = [LoadingView loadingViewInView:self.view];
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
    
 else if ([roleName isEqualToString:@"MULTIPLE_REGIONAL_HEAD"])
 {
     NSLog(@"role name -: MULTIPLE_REGIONAL_HEAD");
     
     AppConst_EMPLOYEE_SALES_AGGREGATE_CARD_DOC_ID = @"DR_NATIONAL_SALES_BU" ;
     AppConst_EMPLOYEE_SALES_AGGREGATE_PIE_CARD_DOC_ID = @"DR_NATIONAL_SALES_BU";
     AppConst_EMPLOYEE_PAYMENT_OUTSTANDING_PIE_CARD_DOC_ID = @"DR_NATIONAL_PAYMENT_OUTSTANDING_BU_WISE" ;
     AppConst_EMPLOYEE_OVERDUE_PIE_CARD_DOC_ID = @"DR_NATIONAL_OVERDUE_BU_WISE";
     
     frontViewController = [[NationalDashboardVC alloc] initWithNibName:@"DashBoardVC" bundle:nil];
 }
    
 else if ([roleName isEqualToString:@"MULTIPLE_STATE_HEAD"])
 {
     NSLog(@"role name -: MULTIPLE_STATE_HEAD");
     
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
    
    
    NSString* trimmedString = [userName.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    m_username = trimmedString;
    
    if( [trimmedString length] > 0) {
        ClientUserLogin* userLogin = [[ClientUserLogin alloc] init];
        
        
        if([trimmedString compare:XmwcsConst_DEMO_USER options:NSCaseInsensitiveSearch]==NSOrderedSame) {
            userLogin.userName = XmwcsConst_DEMO_USER;
            
            // also set developer / qa server URLs here
            XmwcsConst_SERVICE_URL = XmwcsConst_SERVICE_URL_DEMO;
            XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT = XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT_DEMO;
            XmwcsConst_PRODUCT_TREE_SERVICE_URL = XmwcsConst_PRODUCT_TREE_SERVICE_URL_DEMO;
            XmwcsConst_SERVICE_URL_APP_CONTROL = XmwcsConst_SERVICE_URL_APP_CONTROL_DEMO;
            XmwcsConst_OPCODE_URL = XmwcsConst_SERVICE_URL_OPCODE_SERVICE_DEMO;
            XmwcsConst_FILE_UPLOAD_URL =XmwcsConst_SERVICE_URL_FILE_UPLOAD_SERVICE_DEMO;
            
            
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
        
        
    }
    
    
    else if ([userName.text isEqualToString:@""]||[password.text isEqualToString:@""]) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Authentication!" message:@"Blank Field" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        [myAlertView show];
    }
}
-(void)clearSQLiteChatFeatureDB
{
    [[NSUserDefaults standardUserDefaults] setObject:m_username forKey:@"LAST_LOGIN_USER"];
    
    NSMutableArray *dbNameArray = [[NSMutableArray alloc]init];
    [dbNameArray addObject:@"ContactList_DB.sqlite.db"];
    [dbNameArray addObject:@"ChatHistory_DB.sqlite.db"];
    [dbNameArray addObject:@"ChatThreadList_DB.sqlite.db"];
    
    for (int i=0; i<3; i++) {
        NSString *appGroupId = XmwcsConst_APPGROUP_IDENTIFIER;
        NSURL *appGroupDirectoryPath = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:appGroupId];
        NSString *appGroupDirectoryPathString = appGroupDirectoryPath.absoluteString;
        
        NSString *documentsDirectory = appGroupDirectoryPathString;
        NSString *filePath =  [documentsDirectory stringByAppendingPathComponent:[dbNameArray objectAtIndex:i]];
        
        NSError *err;
        
        NSFileManager *fm = [NSFileManager defaultManager];
        
        err = nil;
        NSString *str = [filePath substringWithRange:NSMakeRange(6, filePath.length-6)];
        NSURL *url = [NSURL fileURLWithPath:str];
        
        [fm removeItemAtPath:[url path] error:&err];
        
        if(err)
            
        {
            
            NSLog(@"File Manager: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
            
        }
        
        else
            
        {
            
            NSLog(@"File :- %@ deleted",[dbNameArray objectAtIndex:i]);
            
        }
        
    }

}
-(void)syncContactListDB :(id)respondedObject
{
    NSMutableArray * contactsList = [[NSMutableArray alloc]init];
    
    if ([[respondedObject objectForKey:@"status"] boolValue] == YES) {
        if ([[[respondedObject valueForKey:@"responseData"] valueForKey:@"contacts"] isKindOfClass:[NSNull class]]) {
            // do nothing
        }
        else
        {
            [contactsList addObjectsFromArray:[[respondedObject valueForKey:@"responseData"] valueForKey:@"contacts"]];
        }
        
        
        [ContactList_DB createInstance : @"ContactList_DB_STORAGE" : true];
        ContactList_DB *contactListStorage = [ContactList_DB getInstance];
        [contactListStorage dropTable:@"ContactList_DB_STORAGE"];
        
        for(int i =0; i<[contactsList count];i++) //for unhidden contact  insert into db
        {
            ContactList_Object* contactList_Object = [[ContactList_Object alloc] init];
            contactList_Object.emailId = [[contactsList objectAtIndex:i] valueForKey:@"emailId"];
            contactList_Object.name =    [[contactsList objectAtIndex:i] valueForKey:@"name"];
            contactList_Object.userId =  [[contactsList objectAtIndex:i] valueForKey:@"userId"];
            contactList_Object.isHidden = 0;
            [contactListStorage insertDoc:contactList_Object];
        }
        
        contactsList = [[NSMutableArray alloc]init];
        if ([[[respondedObject valueForKey:@"responseData"] valueForKey:@"hiddenContacts"] isKindOfClass:[NSNull class]]) {
            // do nothing
        }
        else{
            [contactsList addObjectsFromArray:[[respondedObject valueForKey:@"responseData"] valueForKey:@"hiddenContacts"]];
        }
        
        for(int i =0; i<[contactsList count];i++) //for hidden contact  insert into db
        {
            ContactList_Object* contactList_Object = [[ContactList_Object alloc] init];
            contactList_Object.emailId = [[contactsList objectAtIndex:i] valueForKey:@"emailId"];
            contactList_Object.name =    [[contactsList objectAtIndex:i] valueForKey:@"name"];
            contactList_Object.userId =  [[contactsList objectAtIndex:i] valueForKey:@"userId"];
            contactList_Object.isHidden = 1;
            [contactListStorage insertDoc:contactList_Object];
        }
        
        NSMutableArray *contactListStorageData = [contactListStorage getRecentDocumentsData : @"False"];
        contactsList = [[NSMutableArray alloc]init];
        [contactsList addObjectsFromArray:contactListStorageData];
    }
}
-(void)syncChatThreadListDB:(id)respondedObject
{
    NSMutableArray *  chatThreadDict = [[NSMutableArray alloc]init];
    if ([[respondedObject objectForKey:@"status"] boolValue] == YES) {
        
        [ContactList_DB createInstance : @"ContactList_DB_STORAGE" : true];
        ContactList_DB *contactListStorage = [ContactList_DB getInstance];
        
        
        
        chatThreadDict = [[NSMutableArray alloc]init];
        [chatThreadDict addObjectsFromArray:[[respondedObject valueForKey:@"responseData"] valueForKey:@"list"]];
        // [threadListTableView reloadData];
        [ChatThreadList_DB createInstance : @"ChatThread_DB_STORAGE" : true];
        ChatThreadList_DB *chatThreadListStorage = [ChatThreadList_DB getInstance];
        [chatThreadListStorage dropTable:@"ChatThread_DB_STORAGE"];
        ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
        for(int i =0; i<[chatThreadDict count];i++)
        {
            NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];

            
            NSString *ownUserId = [chatPersonUserID stringByAppendingString:@"@employee"];
            NSString *parseId= @"";// for get username from contact db
            if ([[[chatThreadDict objectAtIndex:i] valueForKey:@"fromUserId"] isEqualToString:ownUserId]) {
                parseId =[[chatThreadDict objectAtIndex:i] valueForKey:@"toUserId"];
            }
            else{
                parseId =[[chatThreadDict objectAtIndex:i] valueForKey:@"fromUserId"];
            }
            ContactList_Object *obj;
            NSArray *contactListStorageData = [contactListStorage getContactDisplayName:@"False" :parseId];
            if (contactListStorageData.count==0) {
                obj = [[ContactList_Object alloc]init];
            } else {
                obj = (ContactList_Object*) [contactListStorageData objectAtIndex:0];
            }
             
            NSString *subjectString = [[chatThreadDict objectAtIndex:i] valueForKey:@"subject"];
            NSData *subjectData = [subjectString dataUsingEncoding:NSUTF8StringEncoding];
            NSString *base64SubjectString = [subjectData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            
            ChatThreadList_Object* chatThreadList_Object = [[ChatThreadList_Object alloc] init];
            chatThreadList_Object.chatThreadId =[[[chatThreadDict objectAtIndex:i] valueForKey:@"id"] integerValue] ;
            chatThreadList_Object.from =   [ NSString stringWithFormat:@"%@", [[chatThreadDict objectAtIndex:i] valueForKey:@"fromUserId"]];
            chatThreadList_Object.to =  [ NSString stringWithFormat:@"%@",[[chatThreadDict objectAtIndex:i] valueForKey:@"toUserId"]];
            chatThreadList_Object.subject =base64SubjectString;
            chatThreadList_Object.lastMessageOn =[ NSString stringWithFormat:@"%@",[[chatThreadDict objectAtIndex:i] valueForKey:@"lastMessageOn"]];
            chatThreadList_Object.status =[ NSString stringWithFormat:@"%@",[[chatThreadDict objectAtIndex:i] valueForKey:@"status"]];
            BOOL flag = [[[chatThreadDict objectAtIndex:i] valueForKey:@"deleted"] boolValue];
            
            chatThreadList_Object.deletedFlag =[ NSString stringWithFormat:@"%@",flag ? @"YES" : @"NO"];
            
            if(obj.userName!=nil) {
                chatThreadList_Object.displayName = obj.userName;
            } else {
                chatThreadList_Object.displayName = [ NSString stringWithFormat:@"%@", [[chatThreadDict objectAtIndex:i] valueForKey:@"fromUserId"]];
            }
            
            chatThreadList_Object.unreadMessageCount =[[[chatThreadDict objectAtIndex:i] valueForKey:@"unreadMessageCount"] intValue] ;
            chatThreadList_Object.spaNo =[ NSString stringWithFormat:@"%@",[[chatThreadDict objectAtIndex:i] valueForKey:@"spaNo"]];
            [chatThreadListStorage insertDoc:chatThreadList_Object];
            
        }
        NSMutableArray *chatThreadListStorageData = [chatThreadListStorage getRecentDocumentsData : @"False"];
        chatThreadDict = [[NSMutableArray alloc]init];
        [chatThreadDict addObjectsFromArray:chatThreadListStorageData];
        
        //             [self revealViewControllConfig];
    }

}

-(void)configureUserRole :(ClientLoginResponse*)clientLoginResponse
{
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
        else if ([checkRole isEqualToString:@"MULTIPLE_REGIONAL_HEAD"])
        {
            userRole= @"MULTIPLE_REGIONAL_HEAD";
            [[NSUserDefaults standardUserDefaults ]setObject:userRole forKey:@"ROLE_NAME"];
            break;
        }
        else if ([checkRole isEqualToString:@"MULTIPLE_STATE_HEAD"])
        {
            userRole= @"MULTIPLE_STATE_HEAD";
            [[NSUserDefaults standardUserDefaults ]setObject:userRole forKey:@"ROLE_NAME"];
            break;
        }
        else if([checkRole isEqualToString:@"Accept On Chat"])
        {
            [[NSUserDefaults standardUserDefaults ]setObject:@"YES" forKey:@"Accept_Chat_Button"];
            // break;
        }
    }
}

-(void)set_RMA_Reason_UOMDESC_CORE_COLOR_SQAUREMM_into_NSuserDefaultStorage :(ClientLoginResponse*)clientLoginResponse
{
    [[NSUserDefaults standardUserDefaults] setObject:[clientLoginResponse.clientMasterDetail.masterData valueForKey:@"RMA_REASON"]  forKey:@"RMA_REASON"];
    
    [[NSUserDefaults standardUserDefaults] setObject:  [clientLoginResponse.clientMasterDetail.masterData valueForKey:@"UOMDESC"]  forKey:@"UOMDESC"];
    
    [[NSUserDefaults standardUserDefaults] setObject:    [clientLoginResponse.clientMasterDetail.masterData valueForKey:@"CORE"]  forKey:@"CORE"];
    
    [[NSUserDefaults standardUserDefaults] setObject:  [clientLoginResponse.clientMasterDetail.masterData valueForKey:@"COLOR"]  forKey:@"COLOR"];
    
    [[NSUserDefaults standardUserDefaults] setObject:  [clientLoginResponse.clientMasterDetail.masterData valueForKey:@"SQAUREMM"]  forKey:@"SQAUREMM"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)setUserCredentials_into_NSuserDefaultStorage :(ClientLoginResponse*)clientLoginResponse username:(NSString*) username
{
    authToken = clientLoginResponse.authToken;
    NSLog(@"%@",authToken);
    [[NSUserDefaults standardUserDefaults] setObject:clientLoginResponse.authToken forKey:@"AUTH_TOKEN"];
    
    customer_name = [[clientLoginResponse.clientMasterDetail.masterDataRefresh valueForKey:@"USER_PROFILE"] valueForKey:@"customer_name"];
    [[NSUserDefaults standardUserDefaults ]setObject:customer_name forKey:@"CUSTOMER_NAME"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    menuDetailsDict =clientLoginResponse.menuDetail;
    
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:XmwcsConst_KEYCHAIN_IDENTIFIER accessGroup:nil];
    [keychainItem setObject:username forKey:kSecAttrAccount];
    [keychainItem setObject:self.password.text forKey:kSecValueData];
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"CURRENT_USER_LOGEDIN_ID"];
    [masterDataForEmployee setDictionary:clientLoginResponse.clientMasterDetail.masterDataRefresh];
    chatPersonUserID = username;
    
    
    //this code for remove firstly save username and password in userdefault than save in it.
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"USERNAME"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PASSWORD"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"USERNAME"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:self.password.text forKey:@"PASSWORD"];
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"ISCHECKED"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - HttpEventListener
- (void) httpResponseObjectHandler:(NSString*) callName :(id) respondedObject :(id) requestedObject
{
  
    if(respondedObject)
    {
        if([callName isEqualToString: XmwcsConst_CALL_NAME_FOR_LOGIN]) {
            [loadingView removeView];
            ClientUserLogin* serverUpdatedLogin = (ClientUserLogin*)requestedObject;
            ClientLoginResponse* clientLoginResponse = (ClientLoginResponse*)respondedObject;
            [LoginUtils setClientVariables:  clientLoginResponse :serverUpdatedLogin.userName];
            if([clientLoginResponse.userLoginStatus isEqualToString:@"0"])
            {
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Authentication!" message:clientLoginResponse.userLoginMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
                [myAlertView show];

            } else {
                        
                if([clientLoginResponse.passwrdState isEqualToString:@"1"])
                {
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
                } else {
                        // default context (MAIN)
                        // user now sucessfully logged in
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [ScreenMapper registerCustomReportVC];
                            [ScreenMapper registerCustomFormVC];
                            [self configureUserRole:clientLoginResponse];
                            [self set_RMA_Reason_UOMDESC_CORE_COLOR_SQAUREMM_into_NSuserDefaultStorage:clientLoginResponse];
                            [self setUserCredentials_into_NSuserDefaultStorage:clientLoginResponse username:serverUpdatedLogin.userName];
                        });

                        //this code for clear all chat DB file's
                        NSString *lastUserLogedIn = [[NSUserDefaults standardUserDefaults] valueForKey:@"LAST_LOGIN_USER"];
                        if ([lastUserLogedIn isEqualToString:m_username] || lastUserLogedIn ==nil) {
                            // no need to clear chat local db data
                        }
                        else
                        {
                                dispatch_async(dispatch_get_main_queue(),
                                               ^{
                                                   [self clearSQLiteChatFeatureDB];
                                               });
                        }
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //code to be executed in the background
                            [self registerDeviceToken];
                        });
                    }
            }
        } else if ([callName isEqualToString:XmwcsConst_CALL_NAME_FOR_NOTIFY_DEVICE_REGISTER]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //code to be executed in the background
                [self contactListNetworkCall];
                [self chatThreadListNetworkCall];
                [self revealViewControllConfig];
            });
        }
        
    else if ([callName isEqualToString:@"requestUserList"])
    {
        [loadingView removeView];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self syncContactListDB :respondedObject];
        });
        
    }
    else if ([callName isEqualToString:@"chatThreadRequestData"])
    {   [loadingView removeView];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self syncChatThreadListDB:respondedObject];
            
        });
    } else if ([callName isEqualToString:XmwcsConst_CALL_NAME_FOR_UPDATE_APP_VERSION])
        {
            UpdateAppVersion* versionResponse = (UpdateAppVersion*) respondedObject;
            // versionResponse.majorVersion
            // versionResponse.minorVersion
            NSString* currentShortVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
            NSLog(@"current Short Version is %@", currentShortVersion);
            NSArray* versionParts = [currentShortVersion  componentsSeparatedByString:@"."];
            if([versionParts count]>1) {
                int currentMajorVersion = [[versionParts objectAtIndex:0] intValue];
                int currentMinorVersion = [[versionParts objectAtIndex:1] intValue];
                if(versionResponse.majorVersion.intValue > currentMajorVersion) {
                    // show version update alert
                    // If this is the case user must upgrade.
                    [self handleUpgrade:versionResponse.downloadUrl];
                }
                else if(versionResponse.majorVersion.intValue == currentMajorVersion ) {
                    if(versionResponse.minorVersion.intValue>currentMinorVersion) {
                        // it is minor version, just show user message
                        [self handleUpgrade:versionResponse.downloadUrl];
                    } else {
                        [self autoLogin];
                    }
                } else {
                    [self autoLogin];
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


#pragma  mark - fetch local db data from server
-(void)contactListNetworkCall
{
      NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
    
    loadingView = [LoadingView loadingViewInView:self.view];
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSMutableDictionary *requstData = [[NSMutableDictionary alloc]init];
    
    [requstData setValue:@"45" forKey:@"requestId"];
    [requstData setValue:clientVariables.CLIENT_LOGIN_RESPONSE.authToken forKey:@"authToken"];
    [requstData setValue:[chatPersonUserID stringByAppendingString:@"@employee"] forKey:@"username"];
    
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    [data setValue:[chatPersonUserID stringByAppendingString:@"@employee"] forKey:@"userId"];
    [data setValue:@"1" forKey:@"apiVersion"];
    [data setValue:[[clientVariables.CLIENT_USER_LOGIN deviceInfoMap] valueForKey:@"IMEI"]  forKey:@"deviceId"];
    [data setValue:XmwcsConst_DEVICE_TYPE_IPHONE forKey:@"osType"];
    [data setValue:version forKey:@"appVersion"];
    
    [requstData setObject:data forKey:@"requestData"];
    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=[XmwcsConst_CHAT_URL stringByAppendingString:@"PushMessage/api/getContacts"];
    networkHelper.serviceURLString = url;
//    networkHelper.serviceURLString = @"http://polycab.dotvik.com:8080/PushMessage/api/getContacts";
    [networkHelper genericJSONPayloadRequestWith:requstData :self :@"requestUserList"];
}


-(void)chatThreadListNetworkCall
{
    NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
    
    loadingView = [LoadingView loadingViewInView:self.view];
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSMutableDictionary *chatThreadRequestData = [[NSMutableDictionary alloc]init];
    
    [chatThreadRequestData setValue:@"1" forKey:@"requestId"];
    [chatThreadRequestData setValue:clientVariables.CLIENT_LOGIN_RESPONSE.authToken forKey:@"authToken"];
    [chatThreadRequestData setValue:[chatPersonUserID stringByAppendingString:@"@employee"] forKey:@"username"];
    
    NSMutableDictionary *reqstData = [[NSMutableDictionary alloc] init];
    
    [reqstData setValue:[chatPersonUserID stringByAppendingString:@"@employee"] forKey:@"userId"];
    [reqstData setValue:[[clientVariables.CLIENT_USER_LOGIN deviceInfoMap] valueForKey:@"IMEI"] forKey:@"deviceId"];
    [reqstData setValue:XmwcsConst_DEVICE_TYPE_IPHONE forKey:@"osType"];
    [reqstData setValue:version forKey:@"appVersion"];
    [reqstData setValue:@"1" forKey:@"apiVersion"];
    [chatThreadRequestData setObject:reqstData forKey:@"requestData"];
    
    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=[XmwcsConst_CHAT_URL stringByAppendingString:@"PushMessage/api/chatThreads"];;
    networkHelper.serviceURLString = url;
//    networkHelper.serviceURLString = @"http://polycab.dotvik.com:8080/PushMessage/api/chatThreads";
    [networkHelper genericJSONPayloadRequestWith:chatThreadRequestData :self :@"chatThreadRequestData"];
}


-(void)registerDeviceToken
{
   KeychainWrapper* keychainWrapper = [[KeychainWrapper alloc]init];
    NSString *deviceId = [keychainWrapper myObjectForKey:(__bridge id)(kSecAttrAccount)];
    
    NSString *bundleIdentifier =   [[NSBundle mainBundle] bundleIdentifier];
    NSString* deviceTokenString =deviceId;
    NSString *currentDeviceVersion = [[UIDevice currentDevice] systemVersion];
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    if(deviceTokenString!=nil) {
        NotificationDeviceRegister* deviceRegister = [[NotificationDeviceRegister alloc] init];
        deviceRegister.appId = bundleIdentifier;
        deviceRegister.devicePort = @"123";
        deviceRegister.deviceRegisterId = deviceTokenString;
        deviceRegister.imei = [[clientVariables.CLIENT_USER_LOGIN deviceInfoMap] valueForKey:@"IMEI"] ;
        deviceRegister.moduleId = @"";
        deviceRegister.sessionDetail = @"";
        
        ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
        deviceRegister.userId = clientVariables.CLIENT_USER_LOGIN.userName;
        deviceRegister.os =  XmwcsConst_DEVICE_TYPE_IPHONE;
        
        networkHelper = [[NetworkHelper alloc] init];
        [networkHelper registerDevice:deviceRegister :self :XmwcsConst_CALL_NAME_FOR_NOTIFY_DEVICE_REGISTER];
    }
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
        XmwcsConst_CHAT_URL =XmwcsConst_SERVICE_URL_CHAT_SERVICE_DEV;
        XmwcsConst_DEALER_OPCODE_URL = XmwcsConst_DEALER_OPCODE_URL_DEV;
        
    } else if([currentServerStr isEqualToString:@"QA"]) {
        XmwcsConst_SERVICE_URL = XmwcsConst_SERVICE_URL_DEMO;
        XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT = XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT_DEMO;
        XmwcsConst_PRODUCT_TREE_SERVICE_URL = XmwcsConst_PRODUCT_TREE_SERVICE_URL_DEMO;
        XmwcsConst_SERVICE_URL_APP_CONTROL = XmwcsConst_SERVICE_URL_APP_CONTROL_DEMO;
        XmwcsConst_SERVICE_URL_DEAL_STORE = XmwcsConst_SERVICE_URL_DEAL_STORE_DEMO;
        XmwcsConst_OPCODE_URL = XmwcsConst_SERVICE_URL_OPCODE_SERVICE_DEMO;
        XmwcsConst_FILE_UPLOAD_URL =XmwcsConst_SERVICE_URL_FILE_UPLOAD_SERVICE_DEMO;
        XmwcsConst_CHAT_URL =XmwcsConst_SERVICE_URL_CHAT_SERVICE_DEMO;
        XmwcsConst_DEALER_OPCODE_URL = XmwcsConst_DEALER_OPCODE_URL_DEMO;
        
    } else {
        // also set production server URLs here.
        XmwcsConst_SERVICE_URL = XmwcsConst_SERVICE_URL_PROD;
        XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT = XmwcsConst_SERVICE_URL_NOTIFY_CONTEXT_PROD;
        XmwcsConst_PRODUCT_TREE_SERVICE_URL = XmwcsConst_PRODUCT_TREE_SERVICE_URL_PROD;
        XmwcsConst_SERVICE_URL_APP_CONTROL = XmwcsConst_SERVICE_URL_APP_CONTROL_PROD;
        XmwcsConst_SERVICE_URL_DEAL_STORE = XmwcsConst_SERVICE_URL_DEAL_STORE_PROD;
        XmwcsConst_OPCODE_URL = XmwcsConst_SERVICE_URL_OPCODE_SERVICE_PROD;
        XmwcsConst_FILE_UPLOAD_URL = XmwcsConst_SERVICE_URL_FILE_UPLOAD_SERVICE_PROD;
        XmwcsConst_CHAT_URL =XmwcsConst_SERVICE_URL_CHAT_SERVICE_PROD;
        
        XmwcsConst_DEALER_OPCODE_URL = XmwcsConst_DEALER_OPCODE_URL_PROD;
    }
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

#pragma mark - UIAlertDelegate

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (versionDownloaderUrl != nil) {
        // 0 is cancel, // 1 is yes
        NSLog(@"User clicked button index = %ld", buttonIndex);
        if(buttonIndex==1) {
            // we need to download the URL
            dispatch_async(dispatch_get_main_queue(),  ^(void) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:versionDownloaderUrl]];
            });
        } else if(buttonIndex==0) {
            // we need to do our normal flow
            [self autoLogin];
        }
    }
 
}
@end
