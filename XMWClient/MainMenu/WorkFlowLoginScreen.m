//
//  WorkFlowLoginScreen.m
//  QCMSProject
//
//  Created by Ashish Tiwari on 22/07/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "WorkFlowLoginScreen.h"
#import "ClientUserLogin.h"
#import "ClientVariable.h"
#import "DVAppDelegate.h"
#import "NetworkHelper.h"
#import "XmwcsConstant.h"
#import "AppConstants.h"
#import "MenuVC.h"
#import "ClientLoginResponse.h"
#import "ReportPostResponse.h"
#import "ReportVC.h"

@interface WorkFlowLoginScreen ()

@end

@implementation WorkFlowLoginScreen

@synthesize screenId;
@synthesize name, pass;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.title              = @"Work Flow Screen";
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage *blueImage          = [UIImage imageNamed:@"blueButton.png"];
	UIImage *blueButtonImage    = [blueImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	UIButton *workFlowLoginButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[workFlowLoginButton setFrame:CGRectMake( 72.0f, 250.0f, 180.0f, 36.0f)];
	[workFlowLoginButton setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
	[workFlowLoginButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] forState: UIControlStateNormal];
	[workFlowLoginButton setTitle:@"Login" forState:UIControlStateNormal];
    [workFlowLoginButton addTarget:self action:@selector(WorkFlowLoginButton:) forControlEvents:UIControlEventTouchUpInside];
	
	
    [self.view addSubview:workFlowLoginButton];
    
   	[UserName setPlaceholder:@"UserName"];
    [Password setPlaceholder:@"Password"];
    UserName.delegate           = self;
    Password.delegate           = self;
    Password.secureTextEntry = YES;    

    [self drawHeaderItem];
}


-(void) drawHeaderItem
{
    //self.title              = headerStr;
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(backHandler:)];
    [self.navigationItem setLeftBarButtonItem:backButton];
    
    
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    // self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    UILabel*  titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
    titleLabel.text = @"SAP Login";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.navigationItem setTitleView: titleLabel];
    
}


- (void) backHandler : (id) sender {
    [ [self navigationController]  popViewControllerAnimated:YES];
    
    [DVAppDelegate popModuleContext];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)WorkFlowLoginButton:(id)sender
{
    

    NSLog(@"Login Button Pressed");
    NSLog(@ "name = %@", UserName.text);
    NSLog(@"pass = %@", Password.text);
    
    ClientUserLogin* userLogin = [[ClientUserLogin alloc] init];
    userLogin.userName = UserName.text;
    userLogin.password = Password.text;
    userLogin.deviceInfoMap = [[NSMutableDictionary alloc]init];
    [userLogin.deviceInfoMap setObject:XmwcsConst_IMEI forKey:@"IMEI"];
    [userLogin.deviceInfoMap setObject:XmwcsConst_DEVICE_MODEL forKey:@"DEVICE_MODULE"];
    [userLogin.deviceInfoMap setObject:XmwcsConst_DEVICE_DETAIL forKey:@"DEVICE_DETAIL"];
    
    userLogin.language = AppConst_LANGUAGE_DEFAULT;
	userLogin.moduleId = XmwcsConst_APP_MODULE_WORKFLOW;
    
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    clientVariables.CLIENT_USER_LOGIN = userLogin;
    loadingView = [LoadingView loadingViewInView:self.view];
    
     NetworkHelper* networkHelper = [[NetworkHelper alloc] init];
    [networkHelper makeXmwNetworkCall:userLogin :self : nil : XmwcsConst_CALL_NAME_FOR_LOGIN];

    
    
    
    
}

-(IBAction)WorkFlowCancleButton:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    //[self viewDidUnload];
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    return TRUE;
}
//workflow handler
- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject {
    [loadingView removeFromSuperview];
   
    if(callName == XmwcsConst_CALL_NAME_FOR_LOGIN )
    {
        ClientLoginResponse* clientLoginResponse =  (ClientLoginResponse*) respondedObject;
         ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
        [LoginUtils setClientVariables :  clientLoginResponse : clientVariables.CLIENT_USER_LOGIN.userName];
        
        if([clientVariables.CLIENT_LOGIN_RESPONSE.menuDetail count]== 1)
        {
            NSMutableDictionary *menuDetailMap = clientVariables.CLIENT_LOGIN_RESPONSE.menuDetail;
        
            NSArray *keySorList = [XmwUtils sortHashtableKey:menuDetailMap :XmwcsConst_SORT_AS_INTEGER];
        
        
            NSMutableDictionary *menuData = (NSMutableDictionary *)[ menuDetailMap objectForKey: [keySorList objectAtIndex:0]];
            NSString *formId = (NSString*)[menuData objectForKey: XmwcsConst_MENU_CONSTANT_FORM_ID] ;
    
            NSRange pos = [formId rangeOfString:@"$" ];
            NSString* adapterId = [formId substringToIndex:pos.location];
    
            // starting position (pos.location + 1)
            // end position (.length()
            NSRange valueRange;
            valueRange.location = pos.location + 1;
            valueRange.length = formId.length - valueRange.location;
    
            NSString *adapterType  = [formId substringWithRange:valueRange];
    
            DotFormPost *dotFormPost = [[DotFormPost alloc]init];
    
            [dotFormPost setAdapterType:adapterType];
            [dotFormPost setAdapterId:adapterId];
            [dotFormPost setModuleId:XmwcsConst_APP_MODULE_WORKFLOW];
            [dotFormPost setDocId:adapterId];
    
            NetworkHelper *networkHelper = [[NetworkHelper alloc] init];
            [networkHelper makeXmwNetworkCall:dotFormPost :self : nil :  XmwcsConst_CALL_NAME_FOR_REPORT];
        } else {
            MenuVC *menuController                      =[[MenuVC alloc] initWithNibName:@"MenuVC" bundle:nil];
            menuController.headerStr                    = @"Main Menu";
            menuController.isFirstScreen                = YES;
            menuController.menuDetail                   = clientLoginResponse.menuDetail;
            [[self navigationController]  pushViewController:menuController animated:YES];
        }
    } else {
        ReportPostResponse *reportPostResponse = (ReportPostResponse*)respondedObject;
        ReportVC *reportVC = [[ReportVC alloc] initWithNibName:REPORTVC bundle:nil];
        reportVC.screenId = XmwcsConst_WorkflowMainScreen;
        reportVC.reportPostResponse = reportPostResponse;
        
        [[self navigationController] pushViewController:reportVC  animated:YES];
    }
    
}



@end
