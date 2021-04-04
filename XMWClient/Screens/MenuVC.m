

//
//  MenuVC.m
//  EMSSales
//
//  Created by Ashish Tiwari on 07/05/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//


#import "MenuVC.h"
#import "XmwcsConstant.h"
#import "XmwUtils.h"
#import "OperationManagerUtil.h"
#import "DotForm.h"
#import "DotFormElement.h"
#import "ClientVariable.h"
#import "FormVC.h"
#import "DVAppDelegate.h"
#import "DotFormPost.h"


#import "MenuTVCell.h"

// #import "FormVC.h"
 #import "AddRowFormVC.h"

#import "AppConstants.h"
#import "NetworkHelper.h"
#import "ReportPostResponse.h"
#import "ReportVC.h"
#import "AppConstants.h"
#import "RecentRequestController.h"
#import "Styles.h"
#import "XmwWebViewController.h"
#import "XmwFileExplorer.h"
#import "XmwNotificationViewController.h"
#import "DotNotificationSend.h"
#import "NotificationRequestStorage.h"

#define TAG_LOGOUT_DIALOG 5002

@interface MenuVC ()
{
    NetworkHelper* networkHelper;
    int notificationUnread;
}

@end



@implementation MenuVC

@synthesize menuTableView;
@synthesize internetActive;
@synthesize headerStr;
@synthesize isFirstScreen;
@synthesize isSecondScreen;
@synthesize menuDetail;
@synthesize screenId;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
        self.isFirstScreen = YES;
        notificationUnread = 0;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(isiPhone5) {
        self.view.frame = CGRectMake(0, 64, 320, 504);
    } else {
        // 0, 64, 320, 416
        self.view.frame = CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 64.0f);
    }
    
    [self drawHeaderItem];
    
    [self getMenuItems];
    
    [self configureHeaderBar];
}

-(void) viewWillAppear:(BOOL)animated
{
      
    if(self.isFirstScreen == YES) {
        [self fetchPendingNotifications];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) configureHeaderBar
{
    self.navigationController.navigationBar.translucent = NO;
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    // self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    
    UILabel*  titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, [UIScreen mainScreen].bounds.size.width - 100, 40)];
    titleLabel.text = @"Havells mKonnect";
    titleLabel.textColor = [UIColor redColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.backgroundColor = [UIColor clearColor];
    
    [self.navigationItem setTitleView: titleLabel];
    
    
    self.navigationItem.hidesBackButton = YES;
    
    
    UIImageView *leftButtonView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"havells"]];
    [leftButtonView setFrame:CGRectMake( 0.0f, 0.0f, 44.0f, 44.0f)];
    leftButtonView.contentMode =  UIViewContentModeScaleAspectFit;
    
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
    
    
    
}


#pragma mark - Table View Delegates

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *cellIdentifier     = @"MenuTableViewCell";    	
	MenuTVCell *menuCell                = (MenuTVCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (menuCell == nil) 
		menuCell                        = [[MenuTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    
    menuCell.textLabel.text             = [menuItems objectAtIndex:indexPath.row];
    menuCell.keyValue                   = [menuItems objectAtIndex:indexPath.row];
    menuCell.tag                        = indexPath.row + 1;
    menuCell.accessoryType              = UITableViewCellAccessoryDisclosureIndicator;
    
    
    if((self.isFirstScreen == YES) && (indexPath.row==0)) {
        if(notificationUnread>0) {
            // Notification
            menuCell.textLabel.text = [NSString stringWithFormat:@"%@ (%d)", [menuItems objectAtIndex:indexPath.row], notificationUnread ];
            menuCell.textLabel.font = [UIFont boldSystemFontOfSize:17];
        }
    }

    return menuCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTVCell *cell                    = (MenuTVCell *)[tableView cellForRowAtIndexPath:indexPath];
    UIView *newView                     = [cell.contentView.subviews objectAtIndex:0];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.5];
    [UIView transitionFromView:cell.contentView toView:newView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromTop completion:NULL];
    
    [UIView transitionFromView:newView toView:cell.contentView duration:0.5 options:UIViewAnimationOptionTransitionNone completion:NULL];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int selectedIndex                   = [menuItems indexOfObjectIdenticalTo:cell.keyValue];
    NSString* menuKey = (NSString*)[keyIdName   objectAtIndex:selectedIndex];
	NSMutableDictionary *selectedButtonDetail = (NSMutableDictionary *)[menuDetail objectForKey:menuKey];
    
    NSDictionary* childMenuDetails = (NSDictionary*)[selectedButtonDetail objectForKey:@"CHILD_MENU_DETAIL"];

    
    if(childMenuDetails != nil && [childMenuDetails count]>0) {
        NSLog(@"Total Child menus %d", [childMenuDetails count]);
        NSArray *keySortList = [XmwUtils sortHashtableKey:childMenuDetails :XmwcsConst_SORT_AS_INTEGER];
        
        MenuVC* menuVC = [[MenuVC alloc] initWithNibName:@"MenuVC" bundle:nil];
        menuVC.screenId = self.screenId;
        menuVC.headerStr                    = [selectedButtonDetail objectForKey:@"MENU_NAME"];
        menuVC.isFirstScreen                = NO;
        menuVC.menuDetail                   = childMenuDetails;
        
        [[self navigationController] pushViewController:menuVC animated:YES];
    } else {
        [self performSelector:@selector(handleMenuItemState:) withObject:selectedButtonDetail afterDelay:1.2];
    }
    
    [UIView commitAnimations];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
}

#pragma mark - Action Methods

-(void) handleMenuItemState:(NSMutableDictionary *)menuData
{
    
    NSString *docType = (NSString*) [menuData objectForKey : XmwcsConst_MENU_CONSTANT_FORM_TYPE];
    NSString *isOperation = [menuData objectForKey:XmwcsConst_MENU_CONSTANT_IS_OPERATION_AVAL];

    if (isOperation != NULL && [isOperation isEqualToString:XmwcsConst_BOOLEAN_VALUE_TRUE])
    {
        NSMutableDictionary* operationMenuMap = [OperationManagerUtil handleOnClickOperation : menuData];        
        
        MenuVC *menuScreen          = [[MenuVC alloc] init];
		menuScreen.headerStr        = [menuData objectForKey: XmwcsConst_MENU_CONSTANT_MENU_NAME];
		menuScreen.menuDetail       =  operationMenuMap;
       	menuScreen.isFirstScreen    = NO;
		[[self navigationController] pushViewController:menuScreen  animated:YES];
       
    
        return;
    }
    NSMutableDictionary* forwardDisplay = nil;
    NSMutableDictionary* forwardData = nil;

    
    
	if ([docType isEqualToString:XmwcsConst_DOC_TYPE_SUBMIT] || [docType isEqualToString:XmwcsConst_DOC_TYPE_VIEW])
		[self getFormType:menuData :nil :NO:forwardDisplay:forwardData];

    
    else if ([docType isEqualToString:XmwcsConst_DOC_TYPE_CONTENT_FORM])
    {
    
    
    }
    else if ([docType isEqualToString:XmwcsConst_DOC_TYPE_VIEWDIRECT])
    {
        //for the direct call of the report on clicks of the menu
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
        [dotFormPost setModuleId:AppConst_MOBILET_ID_DEFAULT];
        [dotFormPost setDocId:adapterId];
        
        loadingView = [LoadingView loadingViewInView:self.view];
        
        NetworkHelper *networkHelper = [[NetworkHelper alloc] init];
        [networkHelper makeXmwNetworkCall:dotFormPost :self : nil :  XmwcsConst_CALL_NAME_FOR_REPORT];
        
    } else if ([docType isEqualToString:XmwcsConst_DOC_TYPE_VIEWDIRECT_EDIT]) {
        //for the direct call of the report on clicks of the menu
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
        [dotFormPost setModuleId:AppConst_MOBILET_ID_DEFAULT];
        [dotFormPost setDocId:adapterId];
        
        loadingView = [LoadingView loadingViewInView:self.view];
        
        NetworkHelper *networkHelper = [[NetworkHelper alloc] init];
        [networkHelper makeXmwNetworkCall:dotFormPost :self : nil :  XmwcsConst_CALL_NAME_FOR_REPORT];
    } else if ([docType isEqualToString:XmwcsConst_DOC_TYPE_RECENT_REPORT]) {
        // Not Handle in SalesOnGo
        
        NSString *formId = (NSString*)[menuData objectForKey: XmwcsConst_MENU_CONSTANT_FORM_ID];
        
        RecentRequestController* recentRequestController = [[RecentRequestController alloc] initWithNibName:@"RecentRequestController" bundle:nil];
        [recentRequestController  initwithData : XmwcsConst_EssRecentRequestScreen : formId :self];
        
        [[self navigationController] pushViewController:recentRequestController  animated:YES];
       
                
      
	} else if ([docType isEqualToString:XmwcsConst_DOC_TYPE_URL_LAUNCH])
    {
        NSString *formId = (NSString*)[menuData objectForKey: XmwcsConst_MENU_CONSTANT_FORM_ID];
        ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
        NSString *launchUrl = (NSString*)[clientVariables.CLIENT_MASTERDETAIL.masterData objectForKey: formId];
        //Open browser with launchUrl
        
        XmwWebViewController* webViewController = [[XmwWebViewController alloc] initWithNibName:@"XmwWebViewController" bundle:nil withAdURL:launchUrl];
        
        [[self navigationController] pushViewController:webViewController  animated:YES];
        
    } else if ([docType isEqualToString:XmwcsConst_DOC_TYPE_EMAIL_LAUNCH]) {
    
        NSString *formId = (NSString*)[menuData objectForKey: XmwcsConst_MENU_CONSTANT_FORM_ID];
        ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
        NSString *comaSeparatedEmailReceipients = (NSString*)[clientVariables.CLIENT_MASTERDETAIL.masterData objectForKey: formId];
        //Open browser with launchUrl
        
        [self displayMailComposerSheet: comaSeparatedEmailReceipients];
    
    } else if ([docType isEqualToString:XmwcsConst_DOC_TYPE_LOGOUT])
    {
        UIAlertView* logoutDialog = [[UIAlertView alloc] initWithTitle:@"Havells mKonnect" message:@"Do you really want to exit?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        logoutDialog.tag = TAG_LOGOUT_DIALOG;
        [logoutDialog show];
        
//        PageViewController *pageViewController = [[PageViewController alloc] initWithNibName:@"PageViewController" bundle:nil];//added by ashish tiwari on aug 2014
//        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:pageViewController];//addded by ashish tiwari on aug 2014
//        [[UIApplication sharedApplication] keyWindow].rootViewController = nc;//added by ashish tiwari on aug 2014
//
//        DVAppDelegate* appDelegate =(DVAppDelegate*)[UIApplication sharedApplication].delegate;
//        appDelegate.navController = nc;

        //exit(0);//comment by ashish tiwari on aug 2014
        
    } else if([docType isEqualToString:XmwcsConst_DF_FORM_TYPE_FILE_EXPLORER]) {
        XmwFileExplorer* fileExplorer = [[XmwFileExplorer alloc] initWithNibName:@"XmwFileExplorer" bundle:nil];
        [[self navigationController] pushViewController:fileExplorer  animated:YES];
        
    }
    else if([docType isEqualToString:XmwcsConst_DF_FORM_TYPE_NOTIFICATION]) {
        XmwNotificationViewController* notificationViewController = [[XmwNotificationViewController alloc] initWithNibName:@"XmwNotificationViewController" bundle:nil];
        [[self navigationController] pushViewController:notificationViewController  animated:YES];
        
    }
        
     
}


- (void) showLoadingView
{
//	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//	loadingView                     = [LoadingView loadingViewInView:self.view];
}

-(void) dismissLoadingView
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	//[LoadingView removeView];
}

#pragma mark - Helper Methods

-(void) getFormType : (NSMutableDictionary *) addedData : (DotFormPost *) dotFormPost : (BOOL) isFormIsSubForm :(NSMutableDictionary *) forwardedDataDisplay : (NSMutableDictionary *) forwardedDataPost
{
    ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
	NSString *formId = (NSString *)[addedData objectForKey:XmwcsConst_MENU_CONSTANT_FORM_ID];
	DotForm *dotForm = (DotForm *) [clientVariables.DOT_FORM_MAP objectForKey: formId];
	
	if (forwardedDataDisplay == nil) 
		forwardedDataDisplay   = [[NSMutableDictionary alloc] init];
	
	if (forwardedDataPost == nil) 
		forwardedDataPost      = [[NSMutableDictionary alloc] init];
    
    
   if( [[dotForm formSubType] isEqualToString:XmwcsConst_DF_FORM_TYPE_SIMPLE] ||
        [[dotForm formSubType] isEqualToString:XmwcsConst_DF_FORM_TYPE_CHANGE_PASSWORD] ||
        [[dotForm formSubType] isEqualToString:XmwcsConst_DF_FORM_TYPE_SIMPLEADDROW] ||
        [[dotForm formSubType] isEqualToString:XmwcsConst_DF_FORM_TYPE_ADD_ROW]
      )
   {
       DotMenuObject* dotMenuObject = [[DotMenuObject alloc] initWithObject:addedData];
       
       
       ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
       
       FormVC* formController  = [clientVariables  formVCForId:dotForm.formId];
       
       if(formController!=nil) {
           formController.formData = dotMenuObject;
           formController.dotFormPost = dotFormPost;
           formController.forwardedDataDisplay = forwardedDataDisplay;
           formController.forwardedDataPost = forwardedDataPost;
           formController.isFormIsSubForm = isFormIsSubForm;
           
           formController.headerStr			= dotForm.screenHeader;
           formController.menuViewController = self;
           
           [[self navigationController] pushViewController:formController  animated:YES];
           
       }

   } else if([[dotForm formSubType] isEqualToString:XmwcsConst_DF_FORM_TYPE_BUTTON]) {
       
       NSMutableDictionary* menuDetails = [DotFormDraw makeMenuForButtonScreen : formId];
       
       
       MenuVC *menuController                      = [[MenuVC alloc] init];
      // navigationController.viewControllers        = [NSArray arrayWithObject:menuController];
      // navigationController.modalTransitionStyle   = UIModalTransitionStyleFlipHorizontal;
       menuController.headerStr                    = dotForm.screenHeader; //@"Main Menu";
      // menuController.isSecondScreen                = YES;
      menuController.isFirstScreen                = NO;
       menuController.menuDetail                   = menuDetails;
       
       [ [self navigationController]  pushViewController:menuController animated:YES];

       
   }
    
    
}

-(void) drawHeaderItem
{
    self.title              = headerStr;
    
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor], NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName, nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    // self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    UILabel*  titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
    titleLabel.text =headerStr;
    titleLabel.textColor = [Styles headerTextColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.navigationItem setTitleView: titleLabel];
    
    
    if(self.isFirstScreen==NO) {
        UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                      style:UIBarButtonItemStyleBordered
                                     target:self
                                     action:@selector(backHandler:)];
        backButton.tintColor = [Styles barButtonTextColor];
        [self.navigationItem setLeftBarButtonItem:backButton];
    }
}

- (void) backHandler : (id) sender {
     [ [self navigationController]  popViewControllerAnimated:YES];
    
    if( (self.screenId==XmwcsConst_EssMenuScreen) || (self.screenId==XmwcsConst_SalesMenuScreen) ) {
		[DVAppDelegate popModuleContext];
    }
}



-(void) getMenuItems
{
    menuItems           = [[NSMutableArray alloc] init];
    
    // keyIdName = [menuDetail allKeys];
    keyIdName           = [[NSMutableArray alloc] initWithArray:[XmwUtils sortHashtableKey : menuDetail : XmwcsConst_SORT_AS_INTEGER]];
    
	int sizeOfKeyVec    = [keyIdName count];

	NSString *menuTitle;
	
	for (int idx = 0; idx < sizeOfKeyVec; idx++)
	{
        NSMutableDictionary* menuItemDetail = [menuDetail objectForKey: [keyIdName objectAtIndex:idx]];
		menuTitle = [menuItemDetail objectForKey: XmwcsConst_MENU_CONSTANT_MENU_NAME ]; 
		[menuItems addObject:menuTitle];			
	}
    
    if(self.isFirstScreen == YES) {
        // for file explorer menu
        NSMutableDictionary* fileExplorerMenuDetail = [self fileExplorerCustomMenu];
        NSString* customMenuKey = [NSString stringWithFormat:@"%d", 1001];
        [menuDetail setObject:fileExplorerMenuDetail forKey:customMenuKey];
        [keyIdName insertObject:customMenuKey atIndex:([menuDetail count] - 2)];
        [menuItems insertObject:@"File Explorer" atIndex:([menuDetail count] - 2)];
    
        
        // for notification menu
        NSMutableDictionary* notificationMenuDetail = [self notificationCustomMenu];
        customMenuKey = [NSString stringWithFormat:@"%d", 1002];
        [menuDetail setObject:notificationMenuDetail forKey:customMenuKey];
        [keyIdName insertObject:customMenuKey atIndex:0];
        [menuItems insertObject:@"Notification" atIndex:0];
        
        [self fetchPendingNotifications];
    }
}


-(NSMutableDictionary*) fileExplorerCustomMenu
{
    NSMutableDictionary* menuItemDetail = [[NSMutableDictionary alloc] init];
    [menuItemDetail setObject:XmwcsConst_DF_FORM_TYPE_FILE_EXPLORER forKey:XmwcsConst_MENU_CONSTANT_FORM_TYPE];
    [menuItemDetail setObject:XmwcsConst_DF_FORM_TYPE_FILE_EXPLORER forKey:@"FORM_ID"];
    [menuItemDetail setObject:@"File Explorer" forKey:XmwcsConst_MENU_CONSTANT_MENU_NAME];
    [menuItemDetail setObject:AppConst_MOBILET_ID_DEFAULT forKey:@"MODULE"];
    
    return menuItemDetail;
}
-(NSMutableDictionary*) notificationCustomMenu
{
    NSMutableDictionary* menuItemDetail = [[NSMutableDictionary alloc] init];
    [menuItemDetail setObject:XmwcsConst_DF_FORM_TYPE_NOTIFICATION forKey:XmwcsConst_MENU_CONSTANT_FORM_TYPE];
    [menuItemDetail setObject:XmwcsConst_DF_FORM_TYPE_NOTIFICATION forKey:@"FORM_ID"];
    [menuItemDetail setObject:@"Notification" forKey:XmwcsConst_MENU_CONSTANT_MENU_NAME];
    [menuItemDetail setObject:AppConst_MOBILET_ID_DEFAULT forKey:@"MODULE"];
    
    return menuItemDetail;
}

    
- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
    {
        [loadingView removeView];
        
        if ([callName isEqualToString : XmwcsConst_CALL_NAME_FOR_REPORT])
        {
            DotFormPost* dotFormPost = (DotFormPost*) requestedObject;
            
            ClientVariable* clientVariable = [ClientVariable getInstance];
            
            ReportPostResponse *reportPostResponse = (ReportPostResponse*) respondedObject;
            
            ReportVC *reportVC = [clientVariable reportVCForId:dotFormPost.adapterId];
            
            reportVC.screenId = AppConst_SCREEN_ID_REPORT;
            reportVC.reportPostResponse = reportPostResponse;
            // reportVC.forwardedDataDisplay = forwardedDataDisplay;
            // reportVC.forwardedDataPost = forwardedDataPost;
            [[self navigationController] pushViewController:reportVC  animated:YES];

           
                      
        } else if([callName isEqualToString: XmwcsConst_CALL_NAME_FOR_FETCH_NOTIFICATION_LIST]) {
            [self recievedNotificationPullData : respondedObject];
        }
    }

- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    
    if(![callName isEqualToString: XmwcsConst_CALL_NAME_FOR_FETCH_NOTIFICATION_LIST]) {
        [loadingView removeView];
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Error!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        [myAlertView show];

    }
}

- (void) httpInterruptHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];
    
}

#pragma mark - Network Status Methods

- (void) reachabilityChanged: (NSNotification* )note
{
    
	// Reachability* curReach = [note object];
	// [self updateNetworkStatus: curReach];
}

- (void) updateNetworkStatus:(Reachability *) curReach
{

}

#pragma mark - Clean Ups

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(NSMutableArray*) getRecentReqTableData : (NSMutableDictionary*)map : (NSMutableArray*)displayList
{
    NSMutableArray* sendBack = [[NSMutableArray alloc]init];
    NSMutableArray* maxDocIdList = [[NSMutableArray alloc]init];
   	NSMutableArray* returnArrayList =[[NSMutableArray alloc]init];
    NSMutableArray* keys = [map allKeys];
	for(int keyIdx=0; keyIdx<[keys count]; keyIdx++)
    {		
        NSMutableDictionary* childMap = [map objectForKey:[keys objectAtIndex:keyIdx]];
        [maxDocIdList addObject:[childMap objectForKey:XmwcsConst_RECENT_REQ_MAX_DOC_ID]];
		NSMutableArray* childList = [[NSMutableArray alloc]init];
		for(int i=0; i<[displayList count]; i++)
        {
            [childList addObject:[childMap objectForKey:[displayList objectAtIndex:i]]];
		}
		[returnArrayList addObject:childList];
    }
    [sendBack addObject:returnArrayList];
	[sendBack addObject:maxDocIdList];
	return sendBack;
}


- (void)displayMailComposerSheet: (NSString*) receipients
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"Dealer Konnect: Contact Us"];
    
    // Set up recipients
    NSArray *toRecipients = [receipients componentsSeparatedByString:@","];
    // NSArray *toRecipients = [NSArray arrayWithObject:@"mail.admin@havells.com"];
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
    NSString *emailBody = @"Enter your query.";
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



#pragma mark - pending notification stuff is here
-(void) userLogout
{
    // [ThirdDashView removeObsr];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"PASSWORD"];
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"ISCHECKED"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // [self.navigationController popViewControllerAnimated:YES];
        //code to be executed in the background
        PageViewController *pageViewController = [[PageViewController alloc] initWithNibName:@"PageViewController" bundle:nil];//added by ashish tiwari on aug 2014
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:pageViewController];//addded by ashish tiwari on aug 2014
        
        DVAppDelegate* appDelegate =(DVAppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.navController = nc;
        
        
        [[UIApplication sharedApplication] keyWindow].rootViewController = nc;//added by ashish tiwari on aug 2014
        
    });
    
}

-(void) fetchPendingNotifications
{
    NSString *bundleIdentifier =   [[NSBundle mainBundle] bundleIdentifier];
    NSString* deviceTokenString =[[NSUserDefaults standardUserDefaults] objectForKey:@"PUSH_TOKEN"];
    
    if(deviceTokenString!=nil && (deviceTokenString.length > 0)) {
        NSMutableDictionary* requestData = [[NSMutableDictionary alloc] init];
        [requestData setObject:bundleIdentifier forKey:@"APP_ID"];
        [requestData setObject:deviceTokenString forKey:@"DEVICE_TOKEN"];
        
        ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
        
        [requestData setObject:clientVariables.CLIENT_USER_LOGIN.userName forKey:@"USER_ID"];
        [requestData setObject:XmwcsConst_DEVICE_TYPE_IPHONE forKey:@"OS"];
        
        networkHelper = [[NetworkHelper alloc] init];
        [networkHelper genericRequestWith:requestData :self :XmwcsConst_CALL_NAME_FOR_FETCH_NOTIFICATION_LIST];
    }
}

-(void)recievedNotificationPullData : (NSMutableArray *)notificationData
{
    notificationUnread = 0;

    [NotificationRequestStorage createInstance : @"NOTIFICATION_STORAGE" : true];
    NotificationRequestStorage *notificationStorage = [NotificationRequestStorage getInstance];
    NSMutableArray *notificationStorageData = [notificationStorage getRecentDocumentsData : @"False"];
    
    if([notificationStorageData count] >0)
    {
        for(int i=0; i<[notificationStorageData count];i++) {
            NotificationRequestItem* item = (NotificationRequestItem*)[notificationStorageData objectAtIndex:i];
            if([item.KEY_READ caseInsensitiveCompare:@"UnRead"]==NSOrderedSame) {
                notificationUnread = notificationUnread + 1;
            }
        }
    }

    
    
    //data inserted in Storage
    for(int i =0; i<[notificationData count];i++)
    {
        DotNotificationSend* notificationObject = (DotNotificationSend* )[notificationData objectAtIndex:i];
        NSString *notifyContentTitle = notificationObject.notifyContentTitle;
        NSString *notifyContentUrl = notificationObject.notifyContentUrl;
        NSString *notifyCreateDate = notificationObject.notifyCreateDate;
        NSString *notifyContentType = notificationObject.notifyContentType;
        NSString *notifyContentMsg = notificationObject.notifyContentMsg;
        
        NSNumber *notifyLogIdIntegerValue = notificationObject.notifyLogId;
        NSString *notifyLogId =  [NSString stringWithFormat:@"%d", [notifyLogIdIntegerValue intValue]];//convert int value to string
        
        NSMutableArray *notifyLogIdDataFromDataBase = [notificationStorage getRecentDocuments :notifyLogId];
        if([notifyLogIdDataFromDataBase count]>0)
        {
            //then skip Insert this Alert in to storage
            NotificationRequestItem* notificationRequestItem = ( NotificationRequestItem*)[notifyLogIdDataFromDataBase objectAtIndex:0];
            if([notificationRequestItem.KEY_READ caseInsensitiveCompare:@"Read"]==NSOrderedSame) {
                NSLog(@"Already read");
            } else if([notificationRequestItem.KEY_READ caseInsensitiveCompare:@"UnRead"]==NSOrderedSame) {
                NSLog(@"Unread item");
            }
        }
        else
        {
            //insert data in to storage
            NotificationRequestItem* notificationRequestItem = [[NotificationRequestItem alloc] init];
            notificationRequestItem.KEY_ID = 0;
            notificationRequestItem.KEY_READ = @"UnRead";
            notificationRequestItem.KEY_DELETE = @"False";
            notificationRequestItem.KEY_NOTIFY_CONTENT_TYPE = notifyContentType;
            notificationRequestItem.KEY_NOTIFY_CONTENT_TITLE =  notifyContentTitle;
            notificationRequestItem.KEY_NOTIFY_COTENT_MSG = notifyContentMsg;
            notificationRequestItem.KEY_NOTIFY_CONTENT_URL = notifyContentUrl;
            notificationRequestItem.KEY_NOTIFY_CONTENT_DATA = @"";
            notificationRequestItem.KEY_NOTIFY_CALLBACK_DATA = @"";
            notificationRequestItem.KEY_NOTIFY_FIELD1 = @"";
            notificationRequestItem.KEY_NOTIFY_FIELD2 =@"";
            notificationRequestItem.KEY_RESPOND_TO_BACK = @"";
            notificationRequestItem.KEY_REQUIRE_LOGIN = @"";
            notificationRequestItem.KEY_NOTIFY_CREATE_DATE = notifyCreateDate;
            notificationRequestItem.KEY_NOTIFY_LOGID = notifyLogId;
            notificationRequestItem.KEY_CALLNAME = @"";
            [notificationStorage insertDoc:notificationRequestItem];
            
            notificationUnread = notificationUnread + 1;
        }
    }
    
    [self updateNotificationMenuStyle];
    
    //storage close
}


-(void) updateNotificationMenuStyle
{
    if(self.isFirstScreen == YES) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        MenuTVCell* notificationCell = (MenuTVCell*)[menuTableView cellForRowAtIndexPath:indexPath];
        
        if(notificationUnread>0) {
            // Notification
            notificationCell.textLabel.text = [NSString stringWithFormat:@"%@ (%d)", [menuItems objectAtIndex:indexPath.row], notificationUnread ];
            notificationCell.textLabel.font = [UIFont boldSystemFontOfSize:17];
        } else {
            notificationCell.textLabel.text = [menuItems objectAtIndex:indexPath.row];
            notificationCell.textLabel.font = [UIFont systemFontOfSize:17];
        }
        
    }
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    //if(alertView.tag == TAG_LOGOUT_DIALOG) {
    //   [self userLogout];
    //}
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    NSLog(@"dismiss button");
    
    if(alertView.tag == TAG_LOGOUT_DIALOG) {
        if(buttonIndex==0) {
            [self userLogout];
        } else {
            // do nothing
        }
        
    }
    
}


@end
