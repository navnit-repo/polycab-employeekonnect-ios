 //
//  DashBoardMenuViewController.m
//  UroMedica
//
//  Created by Ashish Tiwari on 30/12/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//

#import <objc/runtime.h>

#import "DashBoardMenuViewController.h"
#import "Styles.h"
#import "XmwcsConstant.h"
#import "XmwUtils.h"
#import "AppConstants.h"
#import "CreateOrderVC.h"
#import "DotMenuObject.h"
#import "OperationManagerUtil.h"
#import "DotFormPost.h"
#import "ClientVariable.h"
#import "DVAppDelegate.h"
#import "FormVC.h"
#import "RecentRequestController.h"
#import "XmwWebViewController.h"
#import "XmwFileExplorer.h"
#import "XmwNotificationViewController.h"

#import "ReportVC.h"
#import "ReportPostResponse.h"

#import "FirstDashView.h"
#import "FirstDashMTDView.h"
#import "SecondDashView.h"
#import "CreateOrderDashView.h"
#import "ThirdDashView.h"
#import "CreateOrderDashView.h"
#import "ForthDashView.h"
#import "FifthDashView.h"
#import "SixDashView.h"

#import "SalesComparisonChart.h"
#import "SalesIncentiveChart.h"

#import "SBJson.h"

#import "CreditLimitPieChart.h"
#import "SecondDashDataView.h"

#import "UpdateAppVersion.h"
#import "ImageUploadFormViewController.h"

#import "MyClaimVC.h"



#define KEY_salesSummaryYTD  @"salesSummaryYTD"
#define KEY_salesSummaryMTD  @"salesSummaryMTD"
#define KEY_salesIncentiveSummary  @"salesIncentiveSummary"
#define KEY_payableSummary  @"payableSummary"

#define KEY_mydetail @"mydetail"
#define KEY_salesIncentiveSummaryDivisionWiseMonthly @"salesIncentiveSummaryDivisionWiseMonthly"
#define KEY_salesSummaryDivisionWiseLastMTD @"salesSummaryDivisionWiseLastMTD"
#define KEY_salesSummaryDivisionWiseLastYTD @"salesSummaryDivisionWiseLastYTD"



#define TAG_LOGOUT_DIALOG 5001

NSString *const IS_PAUSE_KEY = @"IS_PAUSE";

@interface UIButton (FlipPause)
@property (nonatomic)  BOOL isPause;


@end


@implementation UIButton (FlipPause)

- (void)setIsPause:(BOOL)isPause {
    NSNumber *val = @(isPause);
    objc_setAssociatedObject(self, (__bridge const void*)(IS_PAUSE_KEY), val, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isPause {
    NSNumber *val = objc_getAssociatedObject(self, (__bridge const void*)IS_PAUSE_KEY);
    return [val boolValue];
}

@end


@interface NewVersionDownloader : NSObject <UIAlertViewDelegate>
@property NSString* updateVersionDownloadUrl;

@end

@implementation NewVersionDownloader

-(id) initWithDownloadURL:(NSString*) urlString
{
    self = [super init];
    self.updateVersionDownloadUrl = urlString;
    return self;
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 0 is cancel, // 1 is yes
    NSLog(@"User clicked button index = %ld", buttonIndex);
    if(buttonIndex==0) {
        // we need to download the URL
        dispatch_async(dispatch_get_main_queue(),  ^(void) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateVersionDownloadUrl]];
        });
    }
}


@end



@interface DashBoardMenuViewController ()
{
    NSArray *viewArray;
    UICollectionViewCell *rotedCollCell;
    int clicked;
    
    NSString *fifthCellLable;
    NSString *sixCellLable;
    NSString *compString;
    
    NSString *fifthCellImageName;
    NSString *sixCellImageName;
    
    DotMenuObject *fifthCellDotMenuObject;
    DotMenuObject *sixCellDotMenuObject;
    DotMenuObject *secondCellDotMenuObject;
    NSArray *viewSecondCellArray;
    UICollectionViewCell *rotedCollSecondCell;
    int secondCellClicked;
    
    
    NSTimer* firstTileTimer;
    NSTimer* secondTileTimer;
    NetworkHelper* networkHelper;
    
    
    NewVersionDownloader* versionDownloader;
}

@end

@implementation DashBoardMenuViewController


@synthesize menuDetail;
@synthesize screenId;
@synthesize isFirstScreen;
@synthesize forthCellreportPostResData;

@synthesize secondCellFLippedDataTextArray;

static bool showMenu = true;
static HamBurgerMenuView* rightSlideMenu = nil;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    
    clicked = 1;
    secondCellClicked = 0;
    
    [self configureHeaderBar];
    
    
    // for current financial year
    // for previous financial year it will be -1
    // for before that -2 go on
    NSNumber* yearReference = yearReference = [NSNumber numberWithInt:0];
    [[NSUserDefaults standardUserDefaults] setObject:yearReference forKey:RELATIVE_FINANCIAL_YEAR];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [self createDashBoardGrid];
    [self getMenuItems];//set data in humbergern menu list item
    
    
    sixCellLable = [[NSUserDefaults standardUserDefaults] objectForKey:@"SixCellDashKey"];
    fifthCellLable = [[NSUserDefaults standardUserDefaults] objectForKey:@"FifthCellDashKey"];
    
    NSLog(@"comp string = %@",compString);
    
    sixCellImageName = [[NSUserDefaults standardUserDefaults] objectForKey:@"SixCellImageDashKey"];
    fifthCellImageName =  [[NSUserDefaults standardUserDefaults] objectForKey:@"FifthCellImageDashKey"];
    
  
    
    NSString* fifthCellDataObjectJsonStr =  [[NSUserDefaults standardUserDefaults] objectForKey:@"fifthCellDotMenuObjectDataKey"];
    
    SBJsonParser* sbParser = [[SBJsonParser alloc] init];
    id parsedJsonFifthCellResponseObject = [sbParser objectWithString:fifthCellDataObjectJsonStr];
    
     NSMutableDictionary *fifthCellMenuObjectDicData =parsedJsonFifthCellResponseObject;
    fifthCellDotMenuObject = [[DotMenuObject alloc]init];
    if(fifthCellMenuObjectDicData !=nil)
    {
        fifthCellDotMenuObject.visible = (BOOL)[fifthCellMenuObjectDicData objectForKey:@"visible"];
        fifthCellDotMenuObject.isOpen = (BOOL)[fifthCellMenuObjectDicData objectForKey:@"isOpen"];
        fifthCellDotMenuObject.identifier = [fifthCellMenuObjectDicData objectForKey:@"identifier"];
        fifthCellDotMenuObject.MENU_NAME  = [fifthCellMenuObjectDicData objectForKey:@"MENU_NAME"];
        fifthCellDotMenuObject.FORM_TYPE  = [fifthCellMenuObjectDicData objectForKey:@"FORM_TYPE"];
        fifthCellDotMenuObject.FORM_ID  = [fifthCellMenuObjectDicData objectForKey:@"FORM_ID"];
        fifthCellDotMenuObject.MODULE   = [fifthCellMenuObjectDicData objectForKey:@"MODULE"];
        fifthCellDotMenuObject.ACCESORY_IMAGE = [fifthCellMenuObjectDicData objectForKey:@"ACCESORY_IMAGE"];
        fifthCellDotMenuObject.ACCESORY_IMAGE_NUM = [fifthCellMenuObjectDicData objectForKey:@"ACCESORY_IMAGE_NUM"];
        fifthCellDotMenuObject.ACCSRY_DASH_IMAGE_NAME = [fifthCellMenuObjectDicData objectForKey:@"ACCSRY_DASH_IMAGE_NAME"];
        
    }
    
    
    NSString* sixCellDataObjectJsonStr =  [[NSUserDefaults standardUserDefaults] objectForKey:@"sixCellDotMenuObjectDataKey"];
    id parsedJsonSixCellResponseObject = [sbParser objectWithString:sixCellDataObjectJsonStr];
    NSMutableDictionary *sixCellMenuObjectDicData =parsedJsonSixCellResponseObject;
    sixCellDotMenuObject = [[DotMenuObject alloc]init];
    if(sixCellMenuObjectDicData !=nil)
    {
        sixCellDotMenuObject.visible = (BOOL)[sixCellMenuObjectDicData objectForKey:@"visible"];
        sixCellDotMenuObject.isOpen = (BOOL)[sixCellMenuObjectDicData objectForKey:@"isOpen"];
        sixCellDotMenuObject.identifier = [sixCellMenuObjectDicData objectForKey:@"identifier"];
        sixCellDotMenuObject.MENU_NAME  = [sixCellMenuObjectDicData objectForKey:@"MENU_NAME"];
        sixCellDotMenuObject.FORM_TYPE  = [sixCellMenuObjectDicData objectForKey:@"FORM_TYPE"];
        sixCellDotMenuObject.FORM_ID  = [sixCellMenuObjectDicData objectForKey:@"FORM_ID"];
        sixCellDotMenuObject.MODULE   = [sixCellMenuObjectDicData objectForKey:@"MODULE"];
        sixCellDotMenuObject.ACCESORY_IMAGE = [sixCellMenuObjectDicData objectForKey:@"ACCESORY_IMAGE"];
        sixCellDotMenuObject.ACCESORY_IMAGE_NUM = [sixCellMenuObjectDicData objectForKey:@"ACCESORY_IMAGE_NUM"];
        sixCellDotMenuObject.ACCSRY_DASH_IMAGE_NAME = [sixCellMenuObjectDicData objectForKey:@"ACCSRY_DASH_IMAGE_NAME"];
    }

    // show user welcome message if key is there
    [self showUserWelcomeDialog];
    
    // add tap gesture on fyLabel
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    self.fyLabel.attributedText = [[NSAttributedString alloc] initWithString:[self lastFinancialYear:0]
                                                             attributes:underlineAttribute];
    
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fyTapHandling:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    self.fyLabel.userInteractionEnabled = YES;
    [self.fyLabel addGestureRecognizer:tapGestureRecognizer];
    
    
    // [self checkVersion];
    
    
}


-(void) showUserWelcomeDialog {
    
    
    ClientVariable* clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    
    ReportPostResponse* userDetails = (ReportPostResponse*)[clientVariables.CLIENT_LOGIN_RESPONSE.dashboardData objectForKey:KEY_mydetail];

    if(userDetails!=nil) {
        NSString* customerName = [userDetails.headerData objectForKey:@"E_CUSTOMER_NAME"];
        if(customerName!=nil) {
            self.marqueeText.text = [NSString stringWithFormat:@"Dear M/s. %@, Welcome to Havells mKonnect!", customerName];
          //  UIAlertView* welcomeDialog = [[UIAlertView alloc] initWithTitle:@"Havells mKonnect" message:[NSString stringWithFormat:@"Dear M/s. %@, \nWelcome to Havells mKonnect!", customerName] delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
            // [welcomeDialog show];
        } else {
            self.marqueeText.text = @"";
        }
        self.marqueeText.marqueeType = MLContinuous;
        
        self.marqueeText.leadingBuffer = 20;
        self.marqueeText.rate = 30.0;
    }
    
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
    
    // For right side menu button
    UIButton *rightMenuButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightMenuButton setFrame:CGRectMake( 0.0f, 0.0f, 30.0f, 30.0f)];
    [rightMenuButton setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [rightMenuButton addTarget:self action:@selector(humbergerMenuButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightMenuButton];
    rightButtonItem.target           = self;
    
    
    // for logout button
    UIButton *logoutButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutButton setFrame:CGRectMake( 0.0f, 0.0f, 30.0f, 30.0f)];
    [logoutButton setBackgroundImage:[UIImage imageNamed:@"logout"] forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logoutButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *logoutButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logoutButton];
    logoutButtonItem.target           = self;
    
        
    // for refresh button
    // for logout button
    UIButton *refreshButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setFrame:CGRectMake( 0.0f, 0.0f, 30.0f, 30.0f)];
    [refreshButton setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *refreshButtonItem = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    refreshButtonItem.target           = self;

    
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:rightButtonItem, refreshButtonItem, logoutButtonItem, nil] animated:YES];
    
    
    UIImageView *leftButtonView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"havells"]];
    [leftButtonView setFrame:CGRectMake( 0.0f, 0.0f, 44.0f, 44.0f)];
    leftButtonView.contentMode =  UIViewContentModeScaleAspectFit;
    
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];

    
    
}

-(void) getMenuItems
{
    menuItems           = [[NSMutableArray alloc] init];
    
    // keyIdName = [menuDetail allKeys];
    keyIdName           = [[NSMutableArray alloc] initWithArray:[XmwUtils sortHashtableKey : menuDetail : XmwcsConst_SORT_AS_INTEGER]];
    
    NSLog(@"menuDetail = %@",menuDetail);
    
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
        
        
        // for points accumulation
        NSMutableDictionary* pointsMenuDetail = [self pointsAccumulationCustomMenu];
        customMenuKey = [NSString stringWithFormat:@"%d", 1003];
        [menuDetail setObject:pointsMenuDetail forKey:customMenuKey];
        [keyIdName insertObject:customMenuKey atIndex:0];
        [menuItems insertObject:@"Points Accumulation" atIndex:0];
        
        //[self fetchPendingNotifications];
    }
    NSLog(@"menuDetailAfter = %@",menuDetail);
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

-(NSMutableDictionary*) pointsAccumulationCustomMenu
{
    NSMutableDictionary* menuItemDetail = [[NSMutableDictionary alloc] init];
    [menuItemDetail setObject:XmwcsConst_DF_FORM_TYPE_POINTS forKey:XmwcsConst_MENU_CONSTANT_FORM_TYPE];
    [menuItemDetail setObject:XmwcsConst_DF_FORM_TYPE_POINTS forKey:@"FORM_ID"];
    [menuItemDetail setObject:@"Points Accumulation" forKey:XmwcsConst_MENU_CONSTANT_MENU_NAME];
    [menuItemDetail setObject:AppConst_MOBILET_ID_DEFAULT forKey:@"MODULE"];
    
    return menuItemDetail;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [rightSlideMenu removeFromSuperview];
    showMenu = true;
    
    UITouch *touch = [touches anyObject];
    // here you can get your touch
    NSLog(@"Touched view  %@",[touch.view class] );
    
}


-(void)logoutButtonHandler:(id)sender
{
    UIAlertView* logoutDialog = [[UIAlertView alloc] initWithTitle:@"Havells mKonnect" message:@"Do you really want to exit?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    logoutDialog.tag = TAG_LOGOUT_DIALOG;
    [logoutDialog show];
}


-(void) refreshButtonHandler:(id) sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_FIRST_TILE" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_SECOND_TILE" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_FOURTH_TILE" object:nil];
}

-(void)humbergerMenuButtonHandler:(id)sender
{
    
    if(showMenu)
    {
        rightSlideMenu = [[HamBurgerMenuView alloc] initWithFrame:CGRectMake( self.view.bounds.size.width/4, -self.view.frame.size.height, ((self.view.bounds.size.width/4)*3), self.view.bounds.size.height) withMenu:menuItems handler:self :menuDetail : keyIdName];
        [self.view addSubview : rightSlideMenu];
        
        [UIView beginAnimations:@"rightSlideMenu" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        rightSlideMenu.frame = CGRectMake( self.view.bounds.size.width/4, 0.0f, ((self.view.bounds.size.width/4)*3), self.view.bounds.size.height);
        
        [UIView commitAnimations];
        
        showMenu = false;
    }
    else
    {
        [UIView beginAnimations:@"rightSlideMenu" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(humbergerMenuRemoved:)];
        rightSlideMenu.frame = CGRectMake( self.view.bounds.size.width/4, -self.view.frame.size.height, ((self.view.bounds.size.width/4)*3), self.view.bounds.size.height);
        [UIView commitAnimations];
        
        showMenu = true;
    }
    
}


-(IBAction)humbergerMenuRemoved:(id)sender
{
    NSLog(@"menuRemoved");
    [rightSlideMenu removeFromSuperview];
        
}

-(void) humbergerMenuClicked : (int) idx : (DotMenuObject *)selectedMenuData
{
    NSLog(@"Hamburger menu clicked with idx %d", idx);
//    [rightSlideMenu removeFromSuperview];
//    showMenu = true;
    
    [self handleMenuItemState:selectedMenuData];
    
    
    
//Logic for interchange Value
    compString = selectedMenuData.MENU_NAME;
    
    if(compString != nil)
    {
        if([compString isEqualToString:@"Notification"])
        {
            //then no change menu on DeshBoard
        }
        else if([compString isEqualToString:@"Logout"])
        {
            //then no change menu on Deshboard
        }
        else if([compString isEqualToString:@"Create Order"])
        {
            //then no change menu on Deshboard
        }
        else if([compString isEqualToString:@"Add New Claim"])
        {
            //then no change menu on Deshboard
        }
        else if([compString isEqualToString:@"My Claims"])
        {
            //then no change menu on Deshboard
        }
        else
        {
            
            if([compString isEqualToString:sixCellLable])
            {
                //then again no change menu icon on deshboard
            }
            else if([compString isEqualToString:fifthCellLable])
            {
                //then again no change menu icon on deshboard
            }
            else
            {
                if([fifthCellLable isEqualToString:@""])
                {
                    fifthCellLable = compString;
                    fifthCellImageName = selectedMenuData.ACCSRY_DASH_IMAGE_NAME;
                    
                    [[NSUserDefaults standardUserDefaults] setObject:fifthCellLable forKey:@"FifthCellDashKey"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    NSIndexPath *indexPathFifthCell = [NSIndexPath indexPathForItem:4 inSection:0];
                    [myCollectionView reloadItemsAtIndexPaths:@[indexPathFifthCell]];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:fifthCellImageName forKey:@"FifthCellImageDashKey"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    fifthCellDotMenuObject = selectedMenuData;
                    
                    
                    NSMutableDictionary *fifthCellMenuObjectDicData = [[NSMutableDictionary alloc]init];
                    [fifthCellMenuObjectDicData setValue:[NSNumber numberWithBool:fifthCellDotMenuObject.visible] forKey:@"visible"];
                    [fifthCellMenuObjectDicData setValue:[NSNumber numberWithBool:fifthCellDotMenuObject.isOpen] forKey:@"isOpen"];
                    [fifthCellMenuObjectDicData setValue:[NSNumber numberWithInt:[fifthCellDotMenuObject.identifier intValue]] forKey:@"identifier"];
                     [fifthCellMenuObjectDicData setValue:fifthCellDotMenuObject.MENU_NAME forKey:@"MENU_NAME"];
                     [fifthCellMenuObjectDicData setValue:fifthCellDotMenuObject.FORM_TYPE forKey:@"FORM_TYPE"];
                     [fifthCellMenuObjectDicData setValue:fifthCellDotMenuObject.FORM_ID forKey:@"FORM_ID"];
                     [fifthCellMenuObjectDicData setValue:fifthCellDotMenuObject.MODULE forKey:@"MODULE"];
                     [fifthCellMenuObjectDicData setValue:fifthCellDotMenuObject.ACCESORY_IMAGE forKey:@"ACCESORY_IMAGE"];
                     [fifthCellMenuObjectDicData setValue:[NSNumber numberWithInt:[fifthCellDotMenuObject.ACCESORY_IMAGE_NUM intValue]] forKey:@"ACCESORY_IMAGE_NUM"];
                     [fifthCellMenuObjectDicData setValue:fifthCellDotMenuObject.ACCSRY_DASH_IMAGE_NAME forKey:@"ACCSRY_DASH_IMAGE_NAME"];
                    
                    SBJsonWriter* jsonWriter = [[SBJsonWriter alloc] init];
                    NSString* fifthCellDataObjectJsonStr = [jsonWriter stringWithObject: fifthCellMenuObjectDicData ];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:fifthCellDataObjectJsonStr forKey:@"fifthCellDotMenuObjectDataKey"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    

                    
                    
                }
                else if([sixCellLable isEqualToString:@""])
                {
                    sixCellLable = compString;
                    sixCellImageName  = selectedMenuData.ACCSRY_DASH_IMAGE_NAME;
                    
                    [[NSUserDefaults standardUserDefaults] setObject:sixCellLable forKey:@"SixCellDashKey"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    NSIndexPath *indexPathSixCell = [NSIndexPath indexPathForItem:5 inSection:0];
                    [myCollectionView reloadItemsAtIndexPaths:@[indexPathSixCell]];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:sixCellImageName forKey:@"SixCellImageDashKey"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    sixCellDotMenuObject = selectedMenuData;
                    
                    NSMutableDictionary *sixCellMenuObjectDicData = [[NSMutableDictionary alloc]init];
                    [sixCellMenuObjectDicData setValue:[NSNumber numberWithBool:sixCellDotMenuObject.visible] forKey:@"visible"];
                    [sixCellMenuObjectDicData setValue:[NSNumber numberWithBool:sixCellDotMenuObject.isOpen] forKey:@"isOpen"];
                    [sixCellMenuObjectDicData setValue:[NSNumber numberWithInt:[sixCellDotMenuObject.identifier intValue]] forKey:@"identifier"];
                    [sixCellMenuObjectDicData setValue:sixCellDotMenuObject.MENU_NAME forKey:@"MENU_NAME"];
                    [sixCellMenuObjectDicData setValue:sixCellDotMenuObject.FORM_TYPE forKey:@"FORM_TYPE"];
                    [sixCellMenuObjectDicData setValue:sixCellDotMenuObject.FORM_ID forKey:@"FORM_ID"];
                    [sixCellMenuObjectDicData setValue:sixCellDotMenuObject.MODULE forKey:@"MODULE"];
                    [sixCellMenuObjectDicData setValue:sixCellDotMenuObject.ACCESORY_IMAGE forKey:@"ACCESORY_IMAGE"];
                    [sixCellMenuObjectDicData setValue:[NSNumber numberWithInt:[sixCellDotMenuObject.ACCESORY_IMAGE_NUM intValue]] forKey:@"ACCESORY_IMAGE_NUM"];
                    [sixCellMenuObjectDicData setValue:sixCellDotMenuObject.ACCSRY_DASH_IMAGE_NAME forKey:@"ACCSRY_DASH_IMAGE_NAME"];
                    
                    SBJsonWriter* jsonWriter = [[SBJsonWriter alloc] init];
                    NSString* sixCellDataObjectJsonStr = [jsonWriter stringWithObject: sixCellMenuObjectDicData ];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:sixCellDataObjectJsonStr forKey:@"sixCellDotMenuObjectDataKey"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                }
                else
                {
                    fifthCellLable = sixCellLable;
                    sixCellLable = compString;
                    
                    fifthCellImageName = sixCellImageName;
                    sixCellImageName  = selectedMenuData.ACCSRY_DASH_IMAGE_NAME;
                    
                    
                    [[NSUserDefaults standardUserDefaults] setObject:fifthCellLable forKey:@"FifthCellDashKey"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    NSIndexPath *indexPathFifthCell = [NSIndexPath indexPathForItem:4 inSection:0];
                    [myCollectionView reloadItemsAtIndexPaths:@[indexPathFifthCell]];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:sixCellLable forKey:@"SixCellDashKey"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    NSIndexPath *indexPathSixCell = [NSIndexPath indexPathForItem:5 inSection:0];
                    [myCollectionView reloadItemsAtIndexPaths:@[indexPathSixCell]];
                    
                    
                    [[NSUserDefaults standardUserDefaults] setObject:fifthCellImageName forKey:@"FifthCellImageDashKey"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:sixCellImageName forKey:@"SixCellImageDashKey"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    fifthCellDotMenuObject = sixCellDotMenuObject;
                    sixCellDotMenuObject  = selectedMenuData;
                    
                    
                    NSMutableDictionary *fifthCellMenuObjectDicData = [[NSMutableDictionary alloc]init];
                    [fifthCellMenuObjectDicData setValue:[NSNumber numberWithBool:fifthCellDotMenuObject.visible] forKey:@"visible"];
                    [fifthCellMenuObjectDicData setValue:[NSNumber numberWithBool:fifthCellDotMenuObject.isOpen] forKey:@"isOpen"];
                    [fifthCellMenuObjectDicData setValue:[NSNumber numberWithInt:[fifthCellDotMenuObject.identifier intValue]] forKey:@"identifier"];
                    [fifthCellMenuObjectDicData setValue:fifthCellDotMenuObject.MENU_NAME forKey:@"MENU_NAME"];
                    [fifthCellMenuObjectDicData setValue:fifthCellDotMenuObject.FORM_TYPE forKey:@"FORM_TYPE"];
                    [fifthCellMenuObjectDicData setValue:fifthCellDotMenuObject.FORM_ID forKey:@"FORM_ID"];
                    [fifthCellMenuObjectDicData setValue:fifthCellDotMenuObject.MODULE forKey:@"MODULE"];
                    [fifthCellMenuObjectDicData setValue:fifthCellDotMenuObject.ACCESORY_IMAGE forKey:@"ACCESORY_IMAGE"];
                    [fifthCellMenuObjectDicData setValue:[NSNumber numberWithInt:[fifthCellDotMenuObject.ACCESORY_IMAGE_NUM intValue]] forKey:@"ACCESORY_IMAGE_NUM"];
                    [fifthCellMenuObjectDicData setValue:fifthCellDotMenuObject.ACCSRY_DASH_IMAGE_NAME forKey:@"ACCSRY_DASH_IMAGE_NAME"];
                    
                    SBJsonWriter* jsonWriter = [[SBJsonWriter alloc] init];
                    NSString* fifthCellDataObjectJsonStr = [jsonWriter stringWithObject: fifthCellMenuObjectDicData ];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:fifthCellDataObjectJsonStr forKey:@"fifthCellDotMenuObjectDataKey"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    
                    NSMutableDictionary *sixCellMenuObjectDicData = [[NSMutableDictionary alloc]init];
                    [sixCellMenuObjectDicData setValue:[NSNumber numberWithBool:sixCellDotMenuObject.visible] forKey:@"visible"];
                    [sixCellMenuObjectDicData setValue:[NSNumber numberWithBool:sixCellDotMenuObject.isOpen] forKey:@"isOpen"];
                    [sixCellMenuObjectDicData setValue:[NSNumber numberWithInt:[sixCellDotMenuObject.identifier intValue]] forKey:@"identifier"];
                    [sixCellMenuObjectDicData setValue:sixCellDotMenuObject.MENU_NAME forKey:@"MENU_NAME"];
                    [sixCellMenuObjectDicData setValue:sixCellDotMenuObject.FORM_TYPE forKey:@"FORM_TYPE"];
                    [sixCellMenuObjectDicData setValue:sixCellDotMenuObject.FORM_ID forKey:@"FORM_ID"];
                    [sixCellMenuObjectDicData setValue:sixCellDotMenuObject.MODULE forKey:@"MODULE"];
                    [sixCellMenuObjectDicData setValue:sixCellDotMenuObject.ACCESORY_IMAGE forKey:@"ACCESORY_IMAGE"];
                    [sixCellMenuObjectDicData setValue:[NSNumber numberWithInt:[sixCellDotMenuObject.ACCESORY_IMAGE_NUM intValue]] forKey:@"ACCESORY_IMAGE_NUM"];
                    [sixCellMenuObjectDicData setValue:sixCellDotMenuObject.ACCSRY_DASH_IMAGE_NAME forKey:@"ACCSRY_DASH_IMAGE_NAME"];
                    
                    NSString* sixCellDataObjectJsonStr = [jsonWriter stringWithObject: sixCellMenuObjectDicData ];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:sixCellDataObjectJsonStr forKey:@"sixCellDotMenuObjectDataKey"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                }
                
               
            }
        }
        
    }
    
    
}

-(void) handleMenuItemState:(DotMenuObject *)selectedMenuData
{

    NSString *docType = selectedMenuData.FORM_TYPE;//(NSString*) [menuData objectForKey : XmwcsConst_MENU_CONSTANT_FORM_TYPE];
    NSString *isOperation = selectedMenuData.IS_OPERATION_AVAL;//[menuData objectForKey:XmwcsConst_MENU_CONSTANT_IS_OPERATION_AVAL];

    
  
    
    if (isOperation != NULL && [isOperation isEqualToString:XmwcsConst_BOOLEAN_VALUE_TRUE])
    {
        /*
        NSMutableDictionary* operationMenuMap = [OperationManagerUtil handleOnClickOperation : menuData];
        
        MenuVC *menuScreen          = [[MenuVC alloc] init];
        menuScreen.headerStr        = [menuData objectForKey: XmwcsConst_MENU_CONSTANT_MENU_NAME];
        menuScreen.menuDetail       =  operationMenuMap;
       	menuScreen.isFirstScreen    = NO;
        [[self navigationController] pushViewController:menuScreen  animated:YES];
      
      
        
        */
//        RecentRequestController* recentRequestController = [[RecentRequestController alloc] initWithNibName:@"RecentRequestController" bundle:nil];
//        [recentRequestController  initwithData : XmwcsConst_EssRecentRequestScreen : formId :self];
//
//        [[self navigationController] pushViewController:recentRequestController  animated:YES];
   }
    NSMutableDictionary* forwardDisplay = nil;
    NSMutableDictionary* forwardData = nil;
    
    
    
    if ([docType isEqualToString:XmwcsConst_DOC_TYPE_SUBMIT] || [docType isEqualToString:XmwcsConst_DOC_TYPE_VIEW])
        [self getFormType:selectedMenuData :nil :NO:forwardDisplay:forwardData];
    
    
    else if ([docType isEqualToString:XmwcsConst_DOC_TYPE_CONTENT_FORM])
    {
        
        
    } else if ([docType isEqualToString:XmwcsConst_DOC_TYPE_VIEWDIRECT]) {
        //for the direct call of the report on clicks of the menu
        NSString *formId = selectedMenuData.FORM_ID;//(NSString*)[menuData objectForKey: XmwcsConst_MENU_CONSTANT_FORM_ID] ;
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
        dotFormPost.reportCacheRefresh = @"true";
        [networkHelper makeXmwNetworkCall:dotFormPost :self : nil :  XmwcsConst_CALL_NAME_FOR_REPORT];
        
//        //my code
//        NSString *formId = selectedMenuData.FORM_ID;//(NSString*)[menuData objectForKey: XmwcsConst_MENU_CONSTANT_FORM_ID];
//        MyClaimVC * myClaimVc= [[MyClaimVC alloc]init];
//        [[self navigationController] pushViewController:myClaimVc  animated:YES];
//
        
    } else if ([docType isEqualToString:XmwcsConst_DOC_TYPE_VIEWDIRECT_EDIT]) {
        //for the direct call of the report on clicks of the menu
        NSString *formId = selectedMenuData.FORM_ID;//(NSString*)[menuData objectForKey: XmwcsConst_MENU_CONSTANT_FORM_ID] ;
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
        dotFormPost.reportCacheRefresh = @"true";
        [networkHelper makeXmwNetworkCall:dotFormPost :self : nil :  XmwcsConst_CALL_NAME_FOR_REPORT];
    }
    
    else if ([docType isEqualToString:XmwcsConst_DOC_TYPE_RECENT_REPORT])                  // Not Handle in SalesOnGo
    {
        
        NSString *formId = selectedMenuData.FORM_ID;//(NSString*)[menuData objectForKey: XmwcsConst_MENU_CONSTANT_FORM_ID];
        
        RecentRequestController* recentRequestController = [[RecentRequestController alloc] initWithNibName:@"RecentRequestController" bundle:nil];
        [recentRequestController  initwithData : XmwcsConst_EssRecentRequestScreen : formId :self];
        
        [[self navigationController] pushViewController:recentRequestController  animated:YES];
        
        
        
    } else if ([docType isEqualToString:XmwcsConst_DOC_TYPE_URL_LAUNCH])
    {
        NSString *formId = selectedMenuData.FORM_ID;//(NSString*)[menuData objectForKey: XmwcsConst_MENU_CONSTANT_FORM_ID];
        ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
        NSString *launchUrl = (NSString*)[clientVariables.CLIENT_MASTERDETAIL.masterData objectForKey: formId];
        //Open browser with launchUrl
        
        XmwWebViewController* webViewController = [[XmwWebViewController alloc] initWithNibName:@"XmwWebViewController" bundle:nil withAdURL:launchUrl];
        
        [[self navigationController] pushViewController:webViewController  animated:YES];
        
    } else if ([docType isEqualToString:XmwcsConst_DOC_TYPE_EMAIL_LAUNCH]) {
        
        NSString *formId = selectedMenuData.FORM_ID;//(NSString*)[menuData objectForKey: XmwcsConst_MENU_CONSTANT_FORM_ID];
        ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
        NSString *comaSeparatedEmailReceipients = (NSString*)[clientVariables.CLIENT_MASTERDETAIL.masterData objectForKey: formId];
        //Open browser with launchUrl
        
        [self displayMailComposerSheet: comaSeparatedEmailReceipients];
        
    } else if ([docType isEqualToString:XmwcsConst_DOC_TYPE_LOGOUT])
    {
        UIAlertView* logoutDialog = [[UIAlertView alloc] initWithTitle:@"Havells mKonnect" message:@"Do you really want to exit?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        logoutDialog.tag = TAG_LOGOUT_DIALOG;
        [logoutDialog show];
    } else if([docType isEqualToString:XmwcsConst_DF_FORM_TYPE_FILE_EXPLORER]) {
        XmwFileExplorer* fileExplorer = [[XmwFileExplorer alloc] initWithNibName:@"XmwFileExplorer" bundle:nil];
        [[self navigationController] pushViewController:fileExplorer  animated:YES];
        
    }
    else if([docType isEqualToString:XmwcsConst_DF_FORM_TYPE_NOTIFICATION]) {
        XmwNotificationViewController* notificationViewController = [[XmwNotificationViewController alloc] initWithNibName:@"XmwNotificationViewController" bundle:nil];
        [[self navigationController] pushViewController:notificationViewController  animated:YES];
        
    }
    else if([docType isEqualToString:XmwcsConst_DF_FORM_TYPE_POINTS]) {
        
#if TARGET_IPHONE_SIMULATOR
      //   XmwNotificationViewController* notificationViewController = [[XmwNotificationViewController alloc] initWithNibName:@"XmwNotificationViewController" bundle:nil];
       // [[self navigationController] pushViewController:notificationViewController  animated:YES];
        NSLog(@"This feature is not available on simulator");
        
//#elif TARGET_OS_IPHONE
//        
//        NSLog(@"This points feature is only available on real device");
//        ClientVariable *client = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
//      
//        OptionViewController *optionViewController = [[OptionViewController alloc] init];
//        optionViewController.dealerCode = client.CLIENT_USER_LOGIN.userName;
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: optionViewController];
//        [self presentViewController:nav animated:YES completion:nil];
//       //[[self navigationController] pushViewController:optionViewController  animated:YES];
#endif
        
    }
        
    
    
}

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


-(void) getFormType:(DotMenuObject *) addedData :(DotFormPost *) dotFormPost :(BOOL) isFormIsSubForm :(NSMutableDictionary *) forwardedDataDisplay :(NSMutableDictionary *) forwardedDataPost
{
    ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    NSString *formId = addedData.FORM_ID;//(NSString *)[addedData objectForKey:XmwcsConst_MENU_CONSTANT_FORM_ID];
    DotForm *dotForm = (DotForm *) [clientVariables.DOT_FORM_MAP objectForKey: formId];
    
    if (forwardedDataDisplay == nil)
        forwardedDataDisplay   = [[NSMutableDictionary alloc] init];
    
    if (forwardedDataPost == nil)
        forwardedDataPost      = [[NSMutableDictionary alloc] init];
    
    
    if( [[dotForm formSubType] isEqualToString:XmwcsConst_DF_FORM_TYPE_SIMPLE] ||
       [[dotForm formSubType] isEqualToString:XmwcsConst_DF_FORM_TYPE_CHANGE_PASSWORD] ||
       [[dotForm formSubType] isEqualToString:XmwcsConst_DF_FORM_TYPE_SIMPLEADDROW] ||
       [[dotForm formSubType] isEqualToString:XmwcsConst_DF_FORM_TYPE_ADD_ROW] ||
       [[dotForm formSubType] isEqualToString:XmwcsConst_DF_FORM_TYPE_SIMPLEADDROW_SAMEFORM]
       )
    {
        
        ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
        
        FormVC* formController  = [clientVariables  formVCForId:dotForm.formId];
        
        if(formController!=nil) {
            formController.formData = addedData;
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
        menuController.headerStr                    = dotForm.screenHeader; //@"Main Menu";
        menuController.isFirstScreen                = NO;
        menuController.menuDetail                   = menuDetails;
        
        [ [self navigationController]  pushViewController:menuController animated:YES];
        
        
    }
    
    
}

#pragma mark - HttpEventListener

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
        
        
    }else if([callName isEqualToString:XmwcsConst_CALL_NAME_FOR_UPDATE_APP_VERSION]) {
        UpdateAppVersion* versionResponse = (UpdateAppVersion*) respondedObject;
        // versionResponse.majorVersion
        // versionResponse.minorVersion
        NSString* currentShortVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        NSLog(@"current Short Version is %@", currentShortVersion);
        NSArray* versionParts = [currentShortVersion  componentsSeparatedByString:@"."];
        if([versionParts count]>1) {
            if([versionResponse.forceUpdate intValue]==0) {
                int currentMajorVersion = [[versionParts objectAtIndex:0] intValue];
                int currentMinorVersion = [[versionParts objectAtIndex:1] intValue];
                if(versionResponse.majorVersion.intValue > currentMajorVersion) {
                    // show version update alert
                    // If this is the case user must upgrade.
                    [self handleForceUpgrade:versionResponse.downloadUrl];
                } else if(versionResponse.majorVersion.intValue == currentMajorVersion ) {
                    if(versionResponse.minorVersion.intValue>currentMinorVersion) {
                        // it is minor version, just show user message
                        [self handleUpgrade:versionResponse.downloadUrl];
                    }
                }
            } else {
                // need to force update, launching app store
                [self handleForceUpgrade:versionResponse.downloadUrl];
            }
        }
    }
}

- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    
    [loadingView removeView];
    
    if([callName isEqualToString:XmwcsConst_CALL_NAME_FOR_UPDATE_APP_VERSION]) {
        
    } else if([callName isEqualToString: XmwcsConst_CALL_NAME_FOR_FETCH_NOTIFICATION_LIST]) {
        
    } else {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Error!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        [myAlertView show];
        
    }
}

- (void) httpInterruptHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];
    
}

- (void)displayMailComposerSheet: (NSString*) receipients
{
    
    ClientVariable* clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    NSString* customerName = @"";
    NSString* userId = [clientVariables.CLIENT_MASTERDETAIL.masterData objectForKey:@"USER_NAME"];
    if(userId==nil) {
        userId = [clientVariables.CLIENT_MASTERDETAIL.masterData objectForKey:@"USER_ID"];
    }
    
    ReportPostResponse* userDetails = (ReportPostResponse*)[clientVariables.CLIENT_LOGIN_RESPONSE.dashboardData objectForKey:KEY_mydetail];
    
    if(userDetails!=nil) {
        customerName = [userDetails.headerData objectForKey:@"E_CUSTOMER_NAME"];
    }
    
    
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
    NSString *emailBody = [NSString stringWithFormat:@"Enter your query.\r\n\r\nThanks, and regards,\r\nCustomer Code: %@Customer Name:%@", userId, customerName  ];
   //  NSString *emailBody = @"Enter your query.\r\n\r\nThanks, and regards,\r\n";
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





-(void)settingButtonHandler :(id)sender
{
    
}


//DashBorad Collection view DataSource and Delegates below


-(void)createDashBoardGrid
{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
  //  NSLog(@"%@",self.view.frame);
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];

    myCollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height-30) collectionViewLayout:layout];
    [myCollectionView setDataSource:self];
    [myCollectionView setDelegate:self];
    
    [myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier_0"];
    [myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier_1"];
    [myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier_2"];
    [myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier_3"];
    [myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier_4"];
    [myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier_5"];
    
    [myCollectionView setBackgroundColor:[UIColor clearColor]];
    
    //myCollectionView.autoresizingMask	= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    myCollectionView.showsVerticalScrollIndicator	 = YES;
    myCollectionView.showsHorizontalScrollIndicator = NO;
    
    myCollectionView.scrollEnabled = YES;
    layout.minimumInteritemSpacing = 0.0;
    layout.minimumLineSpacing = 5.0;//0.5;
    
    
    [self.view addSubview:myCollectionView];

    
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5); // top, left, bottom, right
}
-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = [NSString stringWithFormat:@"cellIdentifier_%d", indexPath.item];
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    cell.backgroundColor=[UIColor clearColor];
    
    NSLog(@"CellRow = %d",indexPath.row);
    NSLog(@"Cell Item = %d",indexPath.item);
    
    [self configureCell:cell :indexPath];
   
    return cell;
}


//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
//{
//   
//   [self configureCell:cell :indexPath];
//
//    
//}
-(void) configureCell:(UICollectionViewCell*)cell : (NSIndexPath *)indexPath
{
    ClientVariable* clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    
    ReportPostResponse* salesSummaryYTD = (ReportPostResponse*)[clientVariables.CLIENT_LOGIN_RESPONSE.dashboardData objectForKey:KEY_salesSummaryYTD];
    ReportPostResponse* salesSummaryMTD = (ReportPostResponse*)[clientVariables.CLIENT_LOGIN_RESPONSE.dashboardData objectForKey:KEY_salesSummaryMTD];
    ReportPostResponse* salesIncentiveSummary = (ReportPostResponse*)[clientVariables.CLIENT_LOGIN_RESPONSE.dashboardData objectForKey:KEY_salesIncentiveSummary];
    ReportPostResponse* payableSummary = (ReportPostResponse*)[clientVariables.CLIENT_LOGIN_RESPONSE.dashboardData objectForKey:KEY_payableSummary];
    
    // for chart data (sales)
    ReportPostResponse* salesLastYearMTD = (ReportPostResponse*)[clientVariables.CLIENT_LOGIN_RESPONSE.dashboardData objectForKey:KEY_salesSummaryDivisionWiseLastMTD];
    
    // for chart data (sales)
    ReportPostResponse* salesLastYearYTD = (ReportPostResponse*)[clientVariables.CLIENT_LOGIN_RESPONSE.dashboardData objectForKey:KEY_salesSummaryDivisionWiseLastYTD];

    // for chart data incentive
    ReportPostResponse* salesIncentiveMonthly = (ReportPostResponse*)[clientVariables.CLIENT_LOGIN_RESPONSE.dashboardData objectForKey:KEY_salesIncentiveSummaryDivisionWiseMonthly];
    
    
    if(indexPath.item == 0)
    {
        FirstDashMTDView* firstDashMTDView  = (FirstDashMTDView*)[cell.contentView viewWithTag:9001];
        if(firstDashMTDView==nil) {
            firstDashMTDView  = [FirstDashMTDView createInstance];
            firstDashMTDView.frame = cell.contentView.bounds;
            firstDashMTDView.layer.cornerRadius = 5.0;
            firstDashMTDView.layer.masksToBounds = YES;
            firstDashMTDView.pauseFlipButton.isPause = NO;
            firstDashMTDView.tag = 9001;
            
            // setting data received during login response (overnight generated data)
            if(salesSummaryMTD!=nil) {
                [firstDashMTDView setViewContent:salesSummaryMTD];
            } else {
                [firstDashMTDView updateData];
            }
            
            [cell.contentView addSubview:firstDashMTDView];
            [firstDashMTDView.pauseFlipButton addTarget:self action:@selector(pauseFlipActionHandler:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        FirstDashView* firstDashView = (FirstDashView*)[cell.contentView viewWithTag:9002];
        if(firstDashView==nil) {
            
            firstDashView =  [FirstDashView createInstance];
            firstDashView.frame = cell.contentView.bounds;
            firstDashView.pauseFlipButton.isPause = NO;
            
            firstDashView.layer.cornerRadius = 5.0;
            firstDashView.layer.masksToBounds = YES;
            firstDashView.tag = 9002;
            
            if(salesSummaryYTD!=nil) {
                [firstDashView setViewContent:salesSummaryYTD];
            } else {
                [firstDashView updateData];
            }
            
            [cell.contentView addSubview:firstDashView];
            [firstDashView.pauseFlipButton addTarget:self action:@selector(pauseFlipActionHandler:) forControlEvents:UIControlEventTouchUpInside];
            viewArray  = [[NSArray alloc] initWithObjects:firstDashView, firstDashMTDView, nil];
            [self fllipedFirstCellCooletionView];
        }
        rotedCollCell = cell;
    }
    /*
    else if (indexPath.item == 1)
    {
        SecondDashDataView* secondDashDataView = (SecondDashDataView*)[cell.contentView viewWithTag:9011];
        if(secondDashDataView==nil) {
            secondDashDataView = [SecondDashDataView createInstance];
            secondDashDataView.frame = cell.contentView.bounds;
            secondDashDataView.tag = 9011;
            secondDashDataView.layer.cornerRadius = 5.0;
            secondDashDataView.layer.masksToBounds = YES;
            
            secondDashDataView.pauseFlipButton.isPause = NO;

            secondDashDataView.dashBoardMenuViewCtrl = self;
            
            [cell.contentView addSubview:secondDashDataView];
            
            [secondDashDataView updateData];
            [secondDashDataView.pauseFlipButton addTarget:self action:@selector(pauseFlipActionHandler:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        SecondDashView* secondDashView = (SecondDashView*)[cell.contentView viewWithTag:9012];
        
        if(secondDashView==nil) {
            secondDashView = [SecondDashView createInstance];
            secondDashView.frame = cell.contentView.bounds;
            
            secondDashView.dashBoardMenuViewCtrl = self;
            secondDashView.layer.cornerRadius = 5.0;
            secondDashView.layer.masksToBounds = YES;
            secondDashView.pauseFlipButton.isPause = NO;
            secondDashView.tag = 9012;
            
            if(salesIncentiveSummary!=nil) {
                [secondDashView setViewContent:salesIncentiveSummary];
            } else {
                [secondDashView updateData];
            }
            
            [secondDashView.pauseFlipButton addTarget:self action:@selector(pauseFlipActionHandler:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:secondDashView];
            
            viewSecondCellArray  = [[NSArray alloc] initWithObjects:secondDashView, secondDashDataView, nil];
            
            rotedCollSecondCell = cell;
            [self fllipedSecondCellCooletionView];
        }
    }
     */
    else if (indexPath.item == 1){
        
        CreateOrderDashView* createOrderDashView = (CreateOrderDashView*)[cell.contentView viewWithTag:9020];
        if(createOrderDashView==nil) {
            createOrderDashView = [CreateOrderDashView createInstance];
            
            createOrderDashView.frame = cell.contentView.bounds;
            createOrderDashView.layer.cornerRadius = 5.0;
            createOrderDashView.layer.masksToBounds = YES;
            createOrderDashView.tag = 9020;
            
           // [thirdDashView updateData];
            
            [cell.contentView addSubview:createOrderDashView];
            
        }
    }
    else if (indexPath.item == 2)
    {
        ThirdDashView* thirdDashView = (ThirdDashView*)[cell.contentView viewWithTag:9020];
        if(thirdDashView==nil) {
            thirdDashView = [ThirdDashView createInstance];
            
            thirdDashView.frame = cell.contentView.bounds;
            thirdDashView.layer.cornerRadius = 5.0;
            thirdDashView.layer.masksToBounds = YES;
            thirdDashView.tag = 9020;
            
            [thirdDashView updateData];
            
            [cell.contentView addSubview:thirdDashView];
            
        }
        
    }
    else if (indexPath.item == 3)
    {
        ForthDashView* forthDashView = (ForthDashView*)[cell.contentView viewWithTag:9030];
        
        if(forthDashView==nil) {
            forthDashView = [ForthDashView createInstance];
            forthDashView.frame = cell.contentView.bounds;
            forthDashView.layer.cornerRadius = 5.0;
            forthDashView.layer.masksToBounds = YES;
            forthDashView.tag = 9030;
            
            forthDashView.dashViewContlr = self;
            
            if(payableSummary!=nil) {
                self.forthCellreportPostResData = payableSummary;
                [forthDashView setViewContent:payableSummary];
            } else {
                [forthDashView updateData];
            }
            
            [cell.contentView addSubview:forthDashView];
        }
    }
    else if (indexPath.item == 4)
    {
        FifthDashView* fifthDashView = (FifthDashView*)[cell.contentView viewWithTag:9040];
        
        if(fifthDashView==nil) {
            fifthDashView = [FifthDashView createInstance];
            fifthDashView.frame = cell.contentView.bounds;
            fifthDashView.layer.cornerRadius = 5.0;
            fifthDashView.layer.masksToBounds = YES;
            fifthDashView.tag = 9040;
            
            fifthDashView.dashCellNameLbl.text = fifthCellLable;
            if([fifthCellLable isEqualToString:@""])
            {
                fifthDashView.dashCellNameLbl.text = @"Recently Viewed";
                fifthDashView.dashCellImageIcon.image = [UIImage imageNamed:@"blankDashIcon"];
                fifthDashView.dashCellImageIcon.contentMode = UIViewContentModeCenter;
            }
            else
            {
                fifthDashView.dashCellImageIcon.image = [UIImage imageNamed:fifthCellImageName];
            }
            [cell.contentView addSubview:fifthDashView];
        }
    }
    else if (indexPath.item == 5)
    {
        SixDashView* sixDashView = (SixDashView*)[cell.contentView viewWithTag:9050];
        
        if(sixDashView==nil) {
            sixDashView = [SixDashView createInstance];
            sixDashView.frame = cell.contentView.bounds;
            sixDashView.layer.cornerRadius = 5.0;
            sixDashView.layer.masksToBounds = YES;
            sixDashView.tag = 9050;
            
            sixDashView.menuLblName.text = sixCellLable;
            if([sixCellLable isEqualToString:@""])
            {
                sixDashView.menuLblName.text = @"Recently Viewed";
                sixDashView.menuIconImage.image = [UIImage imageNamed:@"blankDashIcon"];
                sixDashView.menuIconImage.contentMode = UIViewContentModeCenter;
            }
            else
            {
                sixDashView.menuIconImage.image = [UIImage imageNamed:sixCellImageName];
            }
            
            [cell.contentView addSubview:sixDashView];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.view.frame.size.height>500) {
        return CGSizeMake((self.view.bounds.size.width/2)-8, (self.view.frame.size.height-30)/3-7);//(160-2, 139);
    } else {
        return CGSizeMake((self.view.bounds.size.width/2)-8, (504-30)/3-7);
    }
}


-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selectedRowindex = %d",indexPath.row);
    NSLog(@"selectedSection = %d", indexPath.section);
    NSLog(@"selected Item = %d", indexPath.item);
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell.superview bringSubviewToFront:collectionView];
    
    
    if(indexPath.item==0) {
        // We need to open Sales Comparision chart
        
        SalesComparisonChart* salesComparisionChart = [[SalesComparisonChart alloc] initWithNibName:@"SalesComparisonChart" bundle:nil];
        [self.navigationController pushViewController:salesComparisionChart animated:YES];
        
        return;
    } else if(indexPath.item==1) {
        // we need to open scheme incentive chart here
        // we need to open scheme incentive chart here
        
        DotMenuObject* selectedMenuData=[[DotMenuObject alloc] init];
        selectedMenuData.ACCESORY_IMAGE=@"Yes";
        selectedMenuData.ACCESORY_IMAGE_NUM=[NSNumber numberWithInt:3];
        selectedMenuData.ACCSRY_DASH_IMAGE_NAME=@"create_order_L.png";
        selectedMenuData.FORM_ID=@"DOT_FORM_3";
        selectedMenuData.FORM_TYPE=@"SUBMIT";
        selectedMenuData.MENU_NAME=@"Create Order";
        selectedMenuData.MODULE=@"XHAVELLSDEALER";
        selectedMenuData.identifier=[NSNumber numberWithInt:2];
        selectedMenuData.isOpen=[NSNumber numberWithBool:false];
        selectedMenuData.visible=[NSNumber numberWithBool:TRUE];
        
        [self humbergerMenuClicked:0 : selectedMenuData];
        
//       CreateOrderVC* createOrderVC = [[CreateOrderVC alloc] initWithNibName:@"CreateOrderVC" bundle:nil];
//        [self.navigationController pushViewController:createOrderVC animated:YES];
        
//        SalesIncentiveChart* salesIncentiveChart = [[SalesIncentiveChart alloc] initWithNibName:@"SalesIncentiveChart" bundle:nil];
//        [self.navigationController pushViewController:salesIncentiveChart animated:YES];
        
    } else if(indexPath.item ==2) {
        // we need to open Notification screen here
        
        XmwNotificationViewController* notificationViewController = [[XmwNotificationViewController alloc] initWithNibName:@"XmwNotificationViewController" bundle:nil];
        [[self navigationController] pushViewController:notificationViewController  animated:YES];
        
    } else if(indexPath.item ==3) {
        // we need to open Credit / Payable chart here
        
        
        // CreditLimitPieChart *creditLimitPieChart = [[CreditLimitPieChart alloc] initWithNibName:@"CreditLimitPieChart" bundle:nil];
        
        if(self.forthCellreportPostResData != nil)
        {
            CreditLimitPieChart* creditLimitPieChart = [[CreditLimitPieChart alloc] init];
            creditLimitPieChart.graphData = self.forthCellreportPostResData;
            [self.navigationController pushViewController:creditLimitPieChart animated:YES];
            return;
        }
    } else if(indexPath.item ==4) {
        // depends on the last menu type / id, we have to open the next action
        NSLog(@"Fifth DotMenu Object = %@", fifthCellDotMenuObject);
        if(fifthCellDotMenuObject != nil)
        {
            [self handleMenuItemState:fifthCellDotMenuObject];
        }
        
        
    } else if(indexPath.item ==5) {
        // depends on the last menu type / id, we have to open the next action
        
        if(sixCellDotMenuObject != nil)
        {
            [self handleMenuItemState:sixCellDotMenuObject];
        }
        
    }
    
    
}



-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

-(void)fllipedFirstCellCooletionView
{
   
    UIView *checkArary;
    if(clicked == 1)
    {
        checkArary =  (FirstDashMTDView*)[viewArray objectAtIndex:clicked];
    }
    else
    {
        checkArary =  (FirstDashView*)[viewArray objectAtIndex:clicked];
    }
    
    [UIView transitionWithView:rotedCollCell.contentView
                      duration:2.0f
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                         [rotedCollCell.contentView addSubview:checkArary];
                    }
                    completion:^(BOOL finished) {
                        
                        firstTileTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f
                                                         target:self selector:@selector(scheduleNextFlip:)
                                                       userInfo:nil repeats:NO];
                        
                    }];

    
}

-(void) scheduleNextFlip:(NSTimer*) timer
{
    if(clicked == 1)
    {
        clicked = 0;
    }
    else{
        clicked =1;
    }
    
    [self fllipedFirstCellCooletionView];
    
}

/*-(void)secondCellFlippedStartNotifications : (NSNotification*) notification
{
    [self fllipedSecondCellCooletionView];
}
 */

-(void)fllipedSecondCellCooletionView
{
    UIView *checkSecondArary;
    if(secondCellClicked== 1)
    {
        checkSecondArary =  (SecondDashDataView*)[viewSecondCellArray objectAtIndex:secondCellClicked];
    }
    else
    {
        checkSecondArary =  (SecondDashView*)[viewSecondCellArray objectAtIndex:secondCellClicked];
    }
    
    [UIView transitionWithView:rotedCollSecondCell.contentView
                      duration:2.0f
                       options:UIViewAnimationOptionTransitionFlipFromBottom
                    animations:^{
                        
                        [rotedCollSecondCell.contentView addSubview:checkSecondArary];
                        
                    }
                    completion:^(BOOL finished) {
                        
                        secondTileTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f
                                                         target:self selector:@selector(scheduleNextSecondCellFlip:)
                                                       userInfo:nil repeats:NO];
                        
                    }];
    
    
}

-(void) scheduleNextSecondCellFlip:(NSTimer*) timer
{
    if(secondCellClicked == 1)
    {
        secondCellClicked = 0;
    }
    else{
        secondCellClicked =1;
    }
    [self fllipedSecondCellCooletionView];
}




-(void)pauseFlipActionHandler:(id)sender
{
    UIButton* pauseFlipButton = (UIButton*) sender;
    
    NSLog(@"pauseFlipActionHandler tag id = %ld", pauseFlipButton.tag);
    
    
    if(pauseFlipButton.tag ==1001 || pauseFlipButton.tag == 1002) {
        // if tag is 1001 / 1002, then it is for tile 1
        if(pauseFlipButton.isPause) {
            [pauseFlipButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
            pauseFlipButton.isPause = NO;
            [self fllipedFirstCellCooletionView];
        } else {
            [pauseFlipButton setImage:[UIImage imageNamed:@"flip"] forState:UIControlStateNormal];
            pauseFlipButton.isPause = YES;
            
            [firstTileTimer invalidate];
        }
        
    } else if(pauseFlipButton.tag ==2001 || pauseFlipButton.tag == 2002) {
        // if tag is 2001 / 2002, then it is for tile 2
        
        if(pauseFlipButton.isPause) {
            [pauseFlipButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
            pauseFlipButton.isPause = NO;
            [self fllipedSecondCellCooletionView];
        } else {
            [pauseFlipButton setImage:[UIImage imageNamed:@"flip"] forState:UIControlStateNormal];
            pauseFlipButton.isPause = YES;
            [secondTileTimer invalidate];
        }
    }
    
    
    
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
}
// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)alertViewCancel:(UIAlertView *)alertView
{
//    if(alertView.tag == TAG_LOGOUT_DIALOG) {
//        [self userLogout];
//    }
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


#pragma  mark - TapGesture for FY
-(void)fyTapHandling:(id)sender
{
    NSLog(@"fyTapHandling");
    
    // we need to show picker for Financial Year
    
    NSNumber* yearReference = [[NSUserDefaults standardUserDefaults] objectForKey:RELATIVE_FINANCIAL_YEAR];
    if(yearReference==nil) {
        yearReference = [NSNumber numberWithInt:0];
        [[NSUserDefaults standardUserDefaults] setObject:yearReference forKey:RELATIVE_FINANCIAL_YEAR];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if(yearReference.intValue==0) {

        NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
        self.fyLabel.attributedText = [[NSAttributedString alloc] initWithString:[self lastFinancialYear:1]
                                                                      attributes:underlineAttribute];
        
        NSNumber* prevYearReference = [NSNumber numberWithInt:-1];
        [[NSUserDefaults standardUserDefaults] setObject:prevYearReference forKey:RELATIVE_FINANCIAL_YEAR];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else if(yearReference.intValue==-1) {
        
        NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
        self.fyLabel.attributedText = [[NSAttributedString alloc] initWithString:[self lastFinancialYear:2]
                                                                      attributes:underlineAttribute];
        
        NSNumber* prevYearReference = [NSNumber numberWithInt:-2];
        [[NSUserDefaults standardUserDefaults] setObject:prevYearReference forKey:RELATIVE_FINANCIAL_YEAR];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else if(yearReference.intValue==-2) {
        NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
        self.fyLabel.attributedText = [[NSAttributedString alloc] initWithString:[self lastFinancialYear:3]
                                                                      attributes:underlineAttribute];
        
        NSNumber* prevYearReference = [NSNumber numberWithInt:-3];
        [[NSUserDefaults standardUserDefaults] setObject:prevYearReference forKey:RELATIVE_FINANCIAL_YEAR];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else if(yearReference.intValue==-3) {
        
        NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
        self.fyLabel.attributedText = [[NSAttributedString alloc] initWithString:[self lastFinancialYear:0]
                                                                      attributes:underlineAttribute];
        
        NSNumber* prevYearReference = [NSNumber numberWithInt:0];
        
        [[NSUserDefaults standardUserDefaults] setObject:prevYearReference forKey:RELATIVE_FINANCIAL_YEAR];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self refreshButtonHandler:nil];
}

-(NSString*) lastFinancialYear:(int) prevFyIndex
{
    
    // FY: 2015-2016
    NSDate* today = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =[gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
    
    NSString* firstPart =  [NSString stringWithFormat:@"%.4ld",
                            ([weekdayComponents month] > 3) ?
                            [weekdayComponents year] - prevFyIndex :
                            [weekdayComponents year] - prevFyIndex - 1];

    NSString* secondPart = [NSString stringWithFormat:@"%.4ld",
                            ([weekdayComponents month] > 3) ?
                            ([weekdayComponents year] - prevFyIndex + 1) :
                            [weekdayComponents year] - prevFyIndex  ];
    
    // if month is jan (1), Feb (2), Mar(3)
    NSString* lastFY = [NSString stringWithFormat:@"FY: %@-%@", firstPart, secondPart];
    
    return lastFY;
    
}


-(void) checkVersion
{
    NSMutableDictionary* versionRequest = [[NSMutableDictionary alloc] init];
    [versionRequest setObject:[[NSBundle mainBundle] bundleIdentifier] forKey:XmwcsConst_APP_ID];
    NSString* currentShortVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [versionRequest setObject:currentShortVersion forKey:XmwcsConst_APP_VERSION];
    [versionRequest setObject:XmwcsConst_DEVICE_TYPE_IPHONE forKey:XmwcsConst_DEVICE_TYPE];
    
    networkHelper = [[NetworkHelper alloc] init];
    [networkHelper versionCheck: versionRequest :self :XmwcsConst_CALL_NAME_FOR_UPDATE_APP_VERSION];
}



-(void) handleUpgrade:(NSString*) downloadURL
{
    versionDownloader = [[NewVersionDownloader alloc] initWithDownloadURL:downloadURL];
    UIAlertView* downloadUpgradePrompt = [[UIAlertView alloc] initWithTitle:@"Polycab Version Check" message:@"Update is available. Do you want to download?" delegate:versionDownloader cancelButtonTitle:@"YES" otherButtonTitles:@"No", nil];
    [downloadUpgradePrompt show];
}

-(void) handleForceUpgrade:(NSString*) downloadURL
{
    versionDownloader = [[NewVersionDownloader alloc] initWithDownloadURL:downloadURL];
    UIAlertView* downloadUpgradePrompt = [[UIAlertView alloc] initWithTitle:@"Polycab Version Check" message:@"This version is outdated. Need to update." delegate:versionDownloader cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [downloadUpgradePrompt show];
}

@end
