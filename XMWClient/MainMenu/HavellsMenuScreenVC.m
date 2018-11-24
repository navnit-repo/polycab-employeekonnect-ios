//
//  MenuScreenVC.m
//  Dummy_pro_ashish
//
//  Created by Ashish Tiwari on 08/07/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "HavellsMenuScreenVC.h"
#import "MenuVC.h"
#import "ClientVariable.h"
#import "DVAppDelegate.h"
#import "LoginUtils.h"
#import "ClientLoginResponse.h"
#import "NetworkHelper.h"
#import "WorkFlowLoginScreen.h"
#import "AppConstants.h"
#import "LoadingView.h"



@interface HavellsMenuScreenVC ()

@end


@implementation HavellsMenuScreenVC
@synthesize  menuScreen, headerStr;
@synthesize screenId;

int havellsMenuScrItem =3;

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
    [super viewDidLoad];
    [self drawHeaderItem];
    int y = 120;
    
    UIImage *blueImage          = [UIImage imageNamed:@"blueButton.png"];
	UIImage *blueButtonImage    = [blueImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	UIButton *havellsEssButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *havellsSalesButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *havellsWorkFlowButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    for(int i =0;i<havellsMenuScrItem;i++)
    {
	
        if(i==0)
        {
            [havellsEssButton setFrame:CGRectMake( 72.0f, y, 180.0f, 36.0f)];
            [havellsEssButton setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
            [havellsEssButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] forState: UIControlStateNormal];
            [havellsEssButton setTitle:@"ESS" forState:UIControlStateNormal];
        }
        if(i==1)
        {
            [havellsSalesButton setFrame:CGRectMake( 72.0f, y, 180.0f, 36.0f)];
            [havellsSalesButton setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
            [havellsSalesButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] forState: UIControlStateNormal];

            [havellsSalesButton setTitle:@"Sales" forState:UIControlStateNormal];
        }
        if (i==2)
        {
            
            [havellsWorkFlowButton setFrame:CGRectMake( 72.0f, y, 180.0f, 36.0f)];
            [havellsWorkFlowButton setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
            [havellsWorkFlowButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] forState: UIControlStateNormal];

           [havellsWorkFlowButton setTitle:@"WorkFlow" forState:UIControlStateNormal]; 
        }
        y=y+60;
              
    }
    [havellsEssButton addTarget:self action:@selector(ESSButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [havellsSalesButton addTarget:self action:@selector(SalesButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [havellsWorkFlowButton addTarget:self action:@selector(WorkFlowButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:havellsEssButton];
    [self.view addSubview:havellsSalesButton];
    [self.view addSubview:havellsWorkFlowButton];  

    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(IBAction)Logout : (id) sender
{
    // TODO also make logout request on server
    exit(0);
 
   // [self.navigationController popViewControllerAnimated:YES];

}

-(IBAction)ESSButtonPressed:(id)sender
{          
    
    // default context (MAIN)
	ClientVariable* clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
	ClientLoginResponse* clientLoginResponse = [clientVariables CLIENT_LOGIN_RESPONSE];
    
	// creating ESS context
	if( [ClientVariable getInstance : XmwcsConst_APP_MODULE_ESS ]== nil) {
        [ClientVariable createInstance : XmwcsConst_APP_MODULE_ESS : NO];
	}
	[DVAppDelegate pushModuleContext :XmwcsConst_APP_MODULE_ESS];
    
	// setting clientLoginResponse for ESS context
	ClientVariable* essContextClientVariable = [ClientVariable getInstance : XmwcsConst_APP_MODULE_ESS];
	essContextClientVariable.CLIENT_USER_LOGIN =  clientVariables.CLIENT_USER_LOGIN ;
	essContextClientVariable.CLIENT_LOGIN_RESPONSE = clientLoginResponse;
	[LoginUtils setClientVariables :clientLoginResponse : clientVariables.CLIENT_USER_LOGIN.userName];
    
    
    
    MenuVC *menuController                      =[[MenuVC alloc] initWithNibName:@"MenuVC" bundle:nil];
    menuController.screenId = XmwcsConst_EssMenuScreen;
    menuController.headerStr                    = @"Main Menu";
    menuController.isFirstScreen                = YES;
    menuController.menuDetail                   = clientVariables.CLIENT_LOGIN_RESPONSE.menuDetail;
    
    [[self navigationController] pushViewController:menuController animated:YES];
    
}

-(void) drawHeaderItem
{
    self.title = headerStr;
    
        UIButton *logoutButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        [logoutButton setFrame:CGRectMake( 0.0f, 0.0f, 30.0f, 30.0f)];
        [logoutButton setBackgroundImage:[UIImage imageNamed:@"logout.png"] forState:UIControlStateNormal];
        [logoutButton sizeToFit];
        [logoutButton addTarget:self action:@selector(Logout:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:logoutButton];
        leftButton.target           = self;
        
        [self.navigationItem setLeftBarButtonItem:leftButton];
    
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    // self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    UILabel*  titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
    titleLabel.text = @"Havells mKonnect";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.navigationItem setTitleView: titleLabel];
        
    
}
-(IBAction)SalesButtonPressed:(id)sender
{
     ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
     ClientUserLogin* userLogin = clientVariables.CLIENT_USER_LOGIN;
    if([ClientVariable getInstance:XmwcsConst_APP_MODULE_SALES] == nil)
    {
        [ClientVariable createInstance:XmwcsConst_APP_MODULE_SALES :false];
    }
    
    [DVAppDelegate pushModuleContext : XmwcsConst_APP_MODULE_SALES ];
   
    ClientVariable *salesContexClientVariables = [ClientVariable getInstance:XmwcsConst_APP_MODULE_SALES];
    
    loadingView = [LoadingView loadingViewInView:self.view];

    userLogin.moduleId = XmwcsConst_APP_MODULE_SALES;
    [salesContexClientVariables setCLIENT_USER_LOGIN:userLogin];
    
    
    NetworkHelper* networkHelper = [[NetworkHelper alloc] init];
    [networkHelper makeXmwNetworkCall:userLogin :self : nil :XmwcsConst_CALL_NAME_FOR_LOGIN];
 }


-(IBAction)WorkFlowButtonPressed:(id)sender
{
    if( [ClientVariable getInstance : XmwcsConst_APP_MODULE_WORKFLOW]==0) {
		[ClientVariable createInstance : XmwcsConst_APP_MODULE_WORKFLOW : NO];
	}
	
    [DVAppDelegate pushModuleContext : XmwcsConst_APP_MODULE_WORKFLOW];
    
    
    WorkFlowLoginScreen *workFlowLoginScreenVC    = [[WorkFlowLoginScreen alloc] initWithNibName:@"WorkFlowLoginScreen" bundle:nil];
    workFlowLoginScreenVC.screenId = XmwcsConst_WorkflowLoginScreen;
       
    [[self navigationController] pushViewController:workFlowLoginScreenVC animated:YES];
    
}

//sales Hanndler
- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject {
    [loadingView removeFromSuperview];
    ClientVariable* clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    ClientLoginResponse* clientLoginResponse =  (ClientLoginResponse*) respondedObject;
    [LoginUtils setClientVariables :  clientLoginResponse : clientVariables.CLIENT_USER_LOGIN.userName];
        
    MenuVC *menuController                      =[[MenuVC alloc] initWithNibName:@"MenuVC" bundle:nil];
    menuController.screenId = XmwcsConst_SalesMenuScreen;
    menuController.headerStr                    = @"Main Menu";
    menuController.isFirstScreen                = YES;
    menuController.menuDetail                   = clientLoginResponse.menuDetail;
    
    
    [[self navigationController] pushViewController:menuController animated:YES];
    
}


- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    //[loadingView removeFromSuperview];
    
    
}

- (void) httpInterruptHandler : (NSString*) callName : (NSString*) message {
   // [loadingView removeFromSuperview];
    
    
    
}




@end
