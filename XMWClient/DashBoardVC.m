//
//  DashBoardVC.m
//  XMWClient
//
//  Created by dotvikios on 17/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//
#import "DashBoardVC.h"
#import "SWRevealViewController.h"
#import "LeftViewVC.h"
#import "HamBurgerMenuView.h"
#import "XmwcsConstant.h"
#import "DotFormPost.h"
#import "XmwcsConstant.h"
#import "XmwUtils.h"
#import "AppConstants.h"
#import "CreateOrderVC.h"
#import "DotMenuObject.h"
#import "OperationManagerUtil.h"
#import "DotFormPost.h"
#import "ClientVariable.h"
#import "ReportVC.h"
#import "ReportPostResponse.h"
#import "XmwWebViewController.h"
#import "RecentRequestController.h"
#import "NetworkHelper.h"
#import "DVAppDelegate.h"
#import "XmwFileExplorer.h"
#import "XmwNotificationViewController.h"
#import "SalesAggregateCollectionView.h"
#import "CreditDetailsCollectionView.h"
#import "OrderPendencyCollectionView.h"
#import "ProgressBarView.h"
#import "MarqueeLabel.h"
#import "OverDueCollectionView.h"
#import "NationalDashboardVC.h"
#import "ChatBoxVC.h"
#import "ChatRoomsVC.h"
#import "ChatHistory_Object.h"
#import "NewChatBoxVC.h"
#import "KeychainItemWrapper.h"
#import "ChatThreadList_Object.h"
#import "ChatThreadList_DB.h"
#import "LayoutClass.h"
#import "DataManager.h"
#import "XmwNotificationWebViewController.h"

#define TAG_LOGOUT_DIALOG 1000
@interface DashBoardVC () <HttpEventListener>
{
    
    
}

@end

@implementation DashBoardVC
{
    NetworkHelper* networkHelper;
    LoadingView *loadingView;
    NSMutableArray *imagesArray;
    SalesAggregateCollectionView *salesAggregateSliderView;
    CreditDetailsCollectionView * creditDetailsSliderView;
    OrderPendencyCollectionView *orderPendencyCollectionView;
    OverDueCollectionView *overdue;
    //UITableView *tableView;
    ProgressBarView *progressBarView;
    
    MarqueeLabel *lble;
//    UIRefreshControl*   refreshControl;
    BOOL refreshFlag;
    UIButton *chatButton;
    
}
@synthesize auth_Token;
@synthesize tabBar;
@synthesize tableView;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSLog(@"DashBoardVC Call");
    self.tabBar.delegate = self;
    
    if (isiPhoneXSMAX) {
        self.view.frame = CGRectMake(0, 64, 414, 832);
    }
    else if(isiPhoneXR) {
        self.view.frame = CGRectMake(0, 64, 414, 832);
    }
    
    else if(isiPhoneXS) {
        self.view.frame = CGRectMake(0, 64, 375, 748);
    }
    else if(isiPhone10) {
        self.view.frame = CGRectMake(0, 64, 375, 748);
    }
    
    else if(isiPhone6Plus) {
        self.view.frame = CGRectMake(0, 64, 414, 672);
    }
    else if(isiPhone6) {
        self.view.frame = CGRectMake(0, 64, 375, 600);
    } else if(isiPhone5) {
        self.view.frame = CGRectMake(0, 64, 320, 504);
    } else {
        // 0, 64, 320, 416
        self.view.frame = CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 64.0f);
    }

    
    [self initializeView];
    [self headerView];
    [self loadCellView];

    
    [self fetchPendingNotifications];
    
    [self getNonTSI_Accounts];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    // for chat icon alert
    dispatch_async(dispatch_get_main_queue(), ^{
      
        [ChatThreadList_DB createInstance : @"ChatThread_DB_STORAGE" : true];
        ChatThreadList_DB *chatThreadListStorage = [ChatThreadList_DB getInstance];
        NSMutableArray *chatThreadListStorageData = [chatThreadListStorage getRecentDocumentsData : @"False"];
        
        for (int i=0; i<chatThreadListStorageData.count; i++) {
            ChatThreadList_Object *obj = (ChatThreadList_Object*) [chatThreadListStorageData objectAtIndex:i];
            if (obj.unreadMessageCount >0) {
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake( 15.0f, -5.0f, 10.0f, 10.0f)];
                view.tag = 10000000;
                view.backgroundColor = [UIColor whiteColor];
                view.layer.cornerRadius = 5;
                CALayer *myLayer = view.layer;
                
                [chatButton.layer addSublayer:myLayer];
                break;
            }
            else
            {

                long int totalButtonLayer = chatButton.layer.sublayers.count;
                for (int i=0; i<totalButtonLayer; i++) {
                    if (chatButton.layer.sublayers.count >=2 ) {
                        [[chatButton.layer.sublayers objectAtIndex:1] removeFromSuperlayer];
                    }
                }

            }
        }
        
    });
    
    
    if (ChatBoxPushNotifiactionFlag == YES) {
        dispatch_async(dispatch_get_main_queue(), ^{
            ChatBoxVC *vc = [[ChatBoxVC alloc]init];
            UIViewController *root;
            root = [[[[UIApplication sharedApplication]windows]objectAtIndex:0]rootViewController];
            SWRevealViewController *reveal = (SWRevealViewController*)root;
            [(UINavigationController*)reveal.frontViewController pushViewController:vc animated:YES];
        });
    }
    else if (ChatRoomPushNotifiactionFlag== YES)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            ChatBoxVC *vc = [[ChatBoxVC alloc]init];
            UIViewController *root;
            root = [[[[UIApplication sharedApplication]windows]objectAtIndex:0]rootViewController];
            SWRevealViewController *reveal = (SWRevealViewController*)root;
            [(UINavigationController*)reveal.frontViewController pushViewController:vc animated:YES];
        });
    }
    
    NSString* deepLinkUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"deepLinkUrl"];
    
    if(deepLinkUrl!=nil && [deepLinkUrl length]>0) {
        // explicit open the URL in the WebView
        ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
        NSString* launchedUrl = [deepLinkUrl stringByAppendingFormat:@"&authToken=%@", clientVariables.CLIENT_LOGIN_RESPONSE.authToken ];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // XmwWebViewController* webViewController = [[XmwWebViewController alloc] initWithNibName:@"XmwWebViewController" bundle:nil withAdURL:deepLinkUrl];
            // [[self navigationController] pushViewController:webViewController  animated:YES];
            
            XmwNotificationWebViewController *notificationWebViewController = [[XmwNotificationWebViewController alloc]initWithNibName:@"XmwNotificationWebViewController" bundle:nil];
            notificationWebViewController.urlString = launchedUrl;
            [self.navigationController pushViewController:notificationWebViewController animated:YES];
             
        });
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"deepLinkUrl"];
    }
    
    
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
        
        if(clientVariables.CLIENT_USER_LOGIN != nil)
        {
            
            NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
            
            [requestData setObject:username forKey:@"USER_ID"];
            [requestData setObject:XmwcsConst_DEVICE_TYPE_IPHONE forKey:@"OS"];
            
            networkHelper = [[NetworkHelper alloc] init];
            [networkHelper genericRequestWith:requestData :self :XmwcsConst_CALL_NAME_FOR_FETCH_NOTIFICATION_LIST];
        }
    }
}

-(void)headerView{
    
//self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:204.0/255 green:41.0/255 blue:43.0/255 alpha:1.0];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:204.0/255 green:41.0/255 blue:43.0/255 alpha:1.0];
    
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.opaque = YES;
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:204.0/255 green:41.0/255 blue:43.0/255 alpha:1.0];
    
    
    SWRevealViewController *revealController = [self revealViewController];
    revealController.panGestureRecognizer.enabled = NO;
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    
    
    UIBarButtonItem* menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage
                                                                          imageNamed:@"polycab_menu"] style:UIBarButtonItemStylePlain target:revealController
                                                                  action:@selector(revealToggle:)];



    //menuButton.tintColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
      menuButton.tintColor = [UIColor whiteColor];
    
    
    // For right side menu button
     UIImage *notificationButtonIconImage = [[UIImage imageNamed:@"polycab_notification"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *notificationButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [notificationButton setFrame:CGRectMake( 0.0f, 0.0f, 25.0f, 25.0f)];
    [notificationButton setBackgroundImage:notificationButtonIconImage forState:UIControlStateNormal];
    [notificationButton addTarget:self action:@selector(notificationHandler:) forControlEvents:UIControlEventTouchUpInside];
     notificationButton.tintColor =[UIColor whiteColor];
    UIBarButtonItem *notificationButtonItem = [[UIBarButtonItem alloc] initWithCustomView:notificationButton];
    notificationButtonItem.target           = self;
    
     UIImage *chatButtonIconImage = [[UIImage imageNamed:@"Artboard"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    chatButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [chatButton setFrame:CGRectMake( 0.0f, 0.0f, 25.0f, 25.0f)];
    [chatButton setBackgroundImage:chatButtonIconImage forState:UIControlStateNormal];
    [chatButton addTarget:self action:@selector(chatHandler:) forControlEvents:UIControlEventTouchUpInside];
    chatButton.tintColor = [UIColor whiteColor];
    chatButton.tag = 20;

    UIBarButtonItem *chatButtonItem = [[UIBarButtonItem alloc] initWithCustomView:chatButton];
    chatButtonItem.target           = self;
    
    
//    UIButton *refreshButton  = [UIButton buttonWithType:UIButtonTypeCustom];
//    [refreshButton setTitle:@"Re" forState:UIControlStateNormal];
//    [refreshButton setFrame:CGRectMake( 0.0f, 0.0f, 25.0f, 25.0f)];
//    [refreshButton addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventTouchUpInside];
//    refreshButton.tintColor = [UIColor whiteColor];
//    refreshButton.tag = 20;
//
//    UIBarButtonItem *refreshButtonItem = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
//    chatButtonItem.target           = self;
    
    
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:notificationButtonItem, chatButtonItem, nil] animated:YES];
    
    
    UIImageView *polycabLogo = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"polycab_logo"]];
    self.navigationItem.titleView.contentMode = UIViewContentModeCenter;
    self.navigationItem.titleView = polycabLogo;
   [self.navigationItem setLeftBarButtonItem:menuButton];
    
    // this code for check user assigned chat feature or not
     ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    NSMutableArray *roleList = [[NSMutableArray alloc]init];
    [roleList addObjectsFromArray:[clientVariables.CLIENT_LOGIN_RESPONSE.clientMasterDetail.masterDataRefresh valueForKey:@"LEVEL_WISE_ROLES"]];
    NSMutableArray *rolesArray= [[NSMutableArray alloc]init];
    for (int i=0; i<roleList.count; i++) {
        [rolesArray addObject:[[roleList objectAtIndex:i] valueForKey:@"rolename"]];
    }
    if (![rolesArray containsObject:@"CHAIRMAN_CHAT"]) {
        [chatButton setBackgroundImage:nil forState:UIControlStateNormal];
        chatButton.userInteractionEnabled = NO;
    }
}
- (void) chatHandler : (id) sender
{
    NSLog(@"chatHandler button clicked");
    ChatBoxVC *chatVC = [[ChatBoxVC alloc]init];
   [ [self navigationController]  pushViewController:chatVC animated:YES];
    
    //chat icon on dashboard
    UIButton *button = (UIButton*) sender;
    long int totalButtonLayer = button.layer.sublayers.count;
    for (int i=0; i<totalButtonLayer; i++) {
        if (button.layer.sublayers.count >=2 ) {
            [[button.layer.sublayers objectAtIndex:1] removeFromSuperlayer];
        }
    }
  

}

- (void) notificationHandler : (id) sender
{
    NSLog(@"Notification button clicked");
    //pending
    
}


-(void) initializeView
{
    
    self.tabbarBottomConstraint.constant = bottomBarHeight+6;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    

    
    tableView.backgroundColor = [UIColor colorWithRed:249.0/255 green:249.0/255 blue:249.0/255 alpha:1.0];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
//    tableView.bounces = NO;
    tableView.clipsToBounds = YES;
    
    
//    pending work. this work test in next Version 2.1
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dashboardForegroundRefresh) name:XmwcsConst_DASHBOARD_FOREGROUND_AUTOREFRESH_IDENTIFIER object:nil];
    
  refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];

    if (@available(iOS 10.0, *)) {
        tableView.refreshControl = refreshControl;
    } else {
        [tableView addSubview:refreshControl];
    }
    
    // this code for dashboard refresh
    autoRefreashTimeLimit = 5;
    
    NSDate* now = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComp =[gregorian components:(NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:now];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"MMM, HH:mm:ss"];
    currentSyncTime = [outputFormatter stringFromDate:now];
    
    // Sales as on : Current date time (3rd May , 15:05:10)
    syncTime = [NSString stringWithFormat: @"Sales as on: %ld%@ %@",  dateComp.day, [XmwUtils daySuffix:dateComp.day], currentSyncTime];
    

    // for the first day of the month, server sends data till EOD of previous month
    if(dateComp.day == 1) {
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setDay:-1];
        NSDate* yesterday = [gregorian dateByAddingComponents:dateComponents toDate:now options:0];
        dateComp =[gregorian components:(NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:yesterday];
        
        outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"MMM, 23:59:59"];
        currentSyncTime = [outputFormatter stringFromDate:yesterday];
        syncTime = [NSString stringWithFormat: @"Sales as on: %ld%@ %@",  dateComp.day, [XmwUtils daySuffix:dateComp.day], currentSyncTime];
    }
}

-(void)loadCellView{
    
    salesAggregateSliderView = [SalesAggregateCollectionView createInstance];
    [salesAggregateSliderView configure];
    
    
    creditDetailsSliderView =[CreditDetailsCollectionView createInstance];
    [creditDetailsSliderView configure];
    
    
    overdue = [OverDueCollectionView createInstance];
    [overdue configure];
    
}
-(BOOL)timerCheck {
    BOOL flag = false;
    
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm:ss"];
    NSString *refreshCurrenttime = [outputFormatter stringFromDate:now];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    NSDate *date1= [[formatter dateFromString:currentSyncTime] dateByAddingTimeInterval:60.0*autoRefreashTimeLimit];
    NSDate *date2 = [formatter dateFromString:refreshCurrenttime];
    
    
    NSComparisonResult result = [date1 compare:date2];
    
    if(result == NSOrderedAscending)
    {
        currentSyncTime = refreshCurrenttime;
        syncLbl.text = [NSString stringWithFormat: @"Last Sync Time: %@",currentSyncTime];
        flag = true;
    }
    else
    {
        flag = false;
    }
    return flag;
}
-(void)dashboardForegroundRefresh
{
  
    if([self timerCheck])
    {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:XmwcsConst_SALESAGGREGATE_CARD_AUTOREFRESH_IDENTIFIER object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:XmwcsConst_CREDITDETAILS_CARD_AUTOREFRESH_IDENTIFIER object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:XmwcsConst_OVERDUE_CARD_AUTOREFRESH_IDENTIFIER object:nil];
        }
        
        
    
    
   
}
- (void)refreshTable {
    [refreshControl endRefreshing];
    
    if([self timerCheck])
    {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:XmwcsConst_SALESAGGREGATE_CARD_AUTOREFRESH_IDENTIFIER object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:XmwcsConst_CREDITDETAILS_CARD_AUTOREFRESH_IDENTIFIER object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:XmwcsConst_OVERDUE_CARD_AUTOREFRESH_IDENTIFIER object:nil];
    }
    
    
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    if (item.tag == 0) {
        NSLog(@"Click on Home");
        //        DotMenuObject * obj = [[DotMenuObject alloc]init];
        //        obj.FORM_ID = @"";
        
    }
    if (item.tag == 1) {
        NSLog(@"Click on Create Order");
        DotMenuObject * obj = [[DotMenuObject alloc]init];
        obj.FORM_ID = @"DOT_FORM_3";
        obj.FORM_TYPE = @"VIEW";
        [self clickedDashBoardDelegate:1 :obj :@"tab bar clicked"];
    }
    if (item.tag == 2) {
        NSLog(@"Click on My Details");
        DotMenuObject * obj = [[DotMenuObject alloc]init];
        obj.FORM_ID = @"DOT_REPORT_MYDETAIL$CLASSLOADER";
        obj.FORM_TYPE = @"VIEW_DIRECT";
        [self clickedDashBoardDelegate:2 :obj :@"tab bar clicked"];
    }
    if (item.tag == 3) {
        NSLog(@"Click on Feedback");
        DotMenuObject * obj = [[DotMenuObject alloc]init];
        obj.FORM_ID = @"DOT_FORM_FEEDBACK";
        obj.FORM_TYPE = @"SUBMIT";
        [self clickedDashBoardDelegate:3 :obj :@"tab bar clicked"];
    }
    
    if (item.tag == 4) {
        NSLog(@"Click on Request for Return");
        DotMenuObject * obj = [[DotMenuObject alloc]init];
        obj.FORM_ID = @"DOT_FORM_REQUEST_FOR_RETURN_MATERIAL";
        obj.FORM_TYPE = @"SUBMIT";
        [self clickedDashBoardDelegate:4 :obj :@"tab bar clicked"];
    }
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0) {
        return 1;
    }
    else if (section==1) {
        return 1;
    }
    
   else if (section ==2) {
        return 1;
    }
  else  if (section == 3) {
        return 1;
    }
  else  if (section == 4) {
        return 1;
    }
    
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 0;
    }
    else
    {
        return 16;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   

    
    CGFloat height = 0.0;
    if (indexPath.section ==0) {
        height = deviceHeightRation*20;
    }
    else if (indexPath.section ==1) {
        height = 20;
    }
    
   else if (indexPath.section==2) {
        
        UIView *currentView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 180)];
        CGRect viewFrame=currentView.frame;
        viewFrame.origin.x=deviceWidthRation*currentView.frame.origin.x;
        viewFrame.origin.y=deviceHeightRation*currentView.frame.origin.y;
        viewFrame.size.width=deviceWidthRation*currentView.frame.size.width;
        viewFrame.size.height=deviceHeightRation*currentView.frame.size.height;
        currentView.frame=viewFrame;
        height=currentView.frame.size.height;
    }
  else  if (indexPath.section==3) {
        UIView *currentView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 271)];
        CGRect viewFrame=currentView.frame;
        viewFrame.origin.x=deviceWidthRation*currentView.frame.origin.x;
        viewFrame.origin.y=deviceHeightRation*currentView.frame.origin.y;
        viewFrame.size.width=deviceWidthRation*currentView.frame.size.width;
        viewFrame.size.height=deviceHeightRation*currentView.frame.size.height;
        currentView.frame=viewFrame;
        
        height=currentView.frame.size.height;
    }
  else  if (indexPath.section==4) {
        
        UIView *currentView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 271)];
        CGRect viewFrame=currentView.frame;
        viewFrame.origin.x=deviceWidthRation*currentView.frame.origin.x;
        viewFrame.origin.y=deviceHeightRation*currentView.frame.origin.y;
        viewFrame.size.width=deviceWidthRation*currentView.frame.size.width;
        viewFrame.size.height=deviceHeightRation*currentView.frame.size.height;
        currentView.frame=viewFrame;
        
        height=currentView.frame.size.height;
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* cellIdentifier = [NSString stringWithFormat:@"cell_%ld", (long)indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
  

    if(indexPath.section==0) {
        
        cell.backgroundColor = [UIColor clearColor];
        
        NSString *text1 = @"Dear";
        NSString *text2;
        text2= [[NSUserDefaults standardUserDefaults] valueForKey:@"CUSTOMER_NAME"];
        
        if (text2 == NULL) {
            text2 = @"";
        }
        
        NSString *text3 = @"Welcome to Polycab!";
        UIFont *myFont = [ UIFont fontWithName: @"Helvetica-Regular" size: 15.0 ];
        
        lble = [cell viewWithTag:10];
        [lble removeFromSuperview];
       
        lble = [[MarqueeLabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
        lble.tag =10;
        lble.text = [[[[[NSString stringWithFormat:@"%@",text1]stringByAppendingString:@" "]stringByAppendingString:text2]stringByAppendingString:@", "]stringByAppendingString:text3];
        lble.font  = myFont;
        lble.textColor = [UIColor colorWithRed:204.0/255.0 green:43.0/255.0 blue:43.0/255.0 alpha:1];
        lble.marqueeType = MLContinuous;
        lble.leadingBuffer = 20;
        lble.rate = 30.0;
        lble.labelize = NO;
        lble.holdScrolling = NO;
        [cell.contentView addSubview:lble];
        cell.clipsToBounds = YES;

    }
    else if (indexPath.section == 1)
    {
        CGRect rect = [[UIScreen mainScreen] bounds];
        
        cell.backgroundColor = [UIColor clearColor];
        syncLbl = [[UILabel alloc] init];
        syncLbl.frame = CGRectMake(20, 0, rect.size.width - 40, 20);
        syncLbl.textAlignment = NSTextAlignmentRight;
        syncLbl.font = [ UIFont fontWithName: @"Helvetica-Light" size: 13.0 ];
        syncLbl.text = syncTime;
        syncLbl.textColor = [UIColor colorWithRed:204.0/255.0 green:43.0/255.0 blue:43.0/255.0 alpha:1];
        syncLbl.textAlignment = NSTextAlignmentRight;
        
        [cell.contentView addSubview:syncLbl];
    }
    
   else if(indexPath.section == 2) {
        
        cell.backgroundColor = [UIColor clearColor];
        cell.frame=CGRectMake(10, 0,salesAggregateSliderView.bounds.size.width-5 ,salesAggregateSliderView.bounds.size.height-5);
        cell.layer.cornerRadius = 5;
        cell.layer.masksToBounds = true;
        [cell.contentView addSubview:salesAggregateSliderView];
        cell.clipsToBounds = YES;
        
        
        
    }
   else if (indexPath.section == 3) {
        cell.backgroundColor = [UIColor clearColor];
        
        cell.frame=CGRectMake(10, 0,creditDetailsSliderView.bounds.size.width-5 ,creditDetailsSliderView.bounds.size.height-5);
        cell.layer.cornerRadius = 5;
        cell.layer.masksToBounds = true;
        [cell.contentView addSubview:creditDetailsSliderView];
        cell.clipsToBounds = YES;
        
    }
  else  if (indexPath.section == 4) {
        
        
        cell.backgroundColor = [UIColor clearColor];
        
       cell.frame=CGRectMake(10, 0,overdue.bounds.size.width-5 ,overdue.bounds.size.height-5);
        cell.layer.cornerRadius = 5;
        cell.layer.masksToBounds = true;
        [cell.contentView addSubview:overdue];
        cell.clipsToBounds = YES;
        
    }
    
}

    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [lble restartLabel];
    }
    else if (indexPath.section == 2) {
        
        UIActivityIndicatorView *act = [(UIActivityIndicatorView*)self.view viewWithTag:50000];
        [act startAnimating];
        
    }
   else if (indexPath.section == 3) {
        UIActivityIndicatorView *act = [(UIActivityIndicatorView*)self.view viewWithTag:50001];
        [act startAnimating];
    }
   else if (indexPath.section == 4 ) {
        UIActivityIndicatorView *act = [(UIActivityIndicatorView*)self.view viewWithTag:50002];
        [act startAnimating];
    }
    
}


-(void) handleMenuItemState:(DotMenuObject *)selectedMenuData
{
    
    NSString *docType = selectedMenuData.FORM_TYPE;//(NSString*) [menuData objectForKey : XmwcsConst_MENU_CONSTANT_FORM_TYPE];
    NSString *isOperation = selectedMenuData.IS_OPERATION_AVAL;//[menuData objectForKey:XmwcsConst_MENU_CONSTANT_IS_OPERATION_AVAL];
    
    if (isOperation != NULL && [isOperation isEqualToString:XmwcsConst_BOOLEAN_VALUE_TRUE])
    {
        
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
        
        //  [self displayMailComposerSheet: comaSeparatedEmailReceipients];
        
    }
    else if ([docType isEqualToString:XmwcsConst_DOC_TYPE_LOGOUT])
    {
        UIAlertView* logoutDialog = [[UIAlertView alloc] initWithTitle:@"PolyCab" message:@"Do you really want to exit?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        logoutDialog.tag = TAG_LOGOUT_DIALOG;
        [logoutDialog show];
    }
    else if([docType isEqualToString:XmwcsConst_DF_FORM_TYPE_FILE_EXPLORER]) {
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
        
#endif
        
    }
    
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
            
            formController.headerStr            = dotForm.screenHeader;
            formController.menuViewController = self;
            formController.auth_Token = auth_Token;
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
    
    else if ([formId isEqualToString:@"DOT_FORM_CHAIRMAN_CHAT"])
    {
       ChatBoxVC *chatVC = [[ChatBoxVC alloc]init];
    [ [self navigationController]  pushViewController:chatVC animated:YES];
    }
    
    
}

# pragma mark - HttpEventListener
- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    [loadingView removeView];
    
    if ([callName isEqualToString : @"FOR_FETCH_NOTIFICATION_LIST"]) {
        NSLog(@"FOR_FETCH_NOTIFICATION_LIST response");
    } else if ([callName isEqualToString : @"FOR_LOGOUT"])
    {
        DocPostResponse *reportPostResponse = (DocPostResponse*) respondedObject;
        if ([[reportPostResponse submitStatus] isEqualToString:@"S"]) {
            
            LogInVC *loginVC = [[LogInVC alloc] initWithNibName:@"LogInVC" bundle:nil];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:loginVC];
            DVAppDelegate* appDelegate =(DVAppDelegate*)[UIApplication sharedApplication].delegate;
            appDelegate.navController = nc;
            
            
            [[UIApplication sharedApplication] keyWindow].rootViewController = nc;//added by ashish tiwari on aug 2014
        }
        else
        {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Logout" message:[reportPostResponse submittedMessage] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
        }
        
    } else if ([callName isEqualToString : XmwcsConst_CALL_NAME_FOR_REPORT])
    {
        DotFormPost* dotFormPost = (DotFormPost*) requestedObject;
        
        ClientVariable* clientVariable = [ClientVariable getInstance];
        
        ReportPostResponse *reportPostResponse = (ReportPostResponse*) respondedObject;
        
        ReportVC *reportVC = [clientVariable reportVCForId:dotFormPost.adapterId];
        
        reportVC.screenId = AppConst_SCREEN_ID_REPORT;
        reportVC.reportPostResponse = reportPostResponse;
      [(UINavigationController*)self.revealViewController.frontViewController pushViewController:reportVC animated:YES];
    } else if([callName isEqualToString:@"role_based_registry_ids_accounts"]){
        [self handleNonTSI_Response:respondedObject];
        [loadingView removeView];
    }
}

- (void)clickedDashBoardDelegate:(int)indx :(DotMenuObject *)selectedMenuData :(NSString *)AUTH_TOKEN{
    NSLog(@"Hamburger menu clicked with idx %d", indx);
    auth_Token = AUTH_TOKEN;
    NSLog(@"%@",auth_Token);
    [self handleMenuItemState:selectedMenuData];
    
}
- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    
    [loadingView removeView];
    
    if([callName isEqualToString:XmwcsConst_CALL_NAME_FOR_UPDATE_APP_VERSION]) {
        
    }
    
    else if ([callName isEqualToString:@"FOR_LOGOUT"])
    {
        LogInVC *loginVC = [[LogInVC alloc] initWithNibName:@"LogInVC" bundle:nil];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:loginVC];
        DVAppDelegate* appDelegate =(DVAppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.navController = nc;
        
        
        [[UIApplication sharedApplication] keyWindow].rootViewController = nc;//added by ashish tiwari on aug 2014
    }
    else if([callName isEqualToString: XmwcsConst_CALL_NAME_FOR_FETCH_NOTIFICATION_LIST]) {
        
    } else {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Error!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        [myAlertView show];
        
    }
}
-(void) userLogout
{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:XmwcsConst_KEYCHAIN_IDENTIFIER accessGroup:nil ];
    NSString *userId = [keychainItem objectForKey:kSecAttrAccount];
    //for clear all default save data
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict2 = [defs dictionaryRepresentation];
    for (id key in dict2) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [[NSUserDefaults standardUserDefaults ] setObject:userId forKey:@"LAST_LOGIN_USER"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    loadingView = [LoadingView loadingViewInView:self.view];
    
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:bundleIdentifier forKey:@"APP_ID"];
    [dict setObject:@"1" forKey:@"FOR_NOTIFY_DEVICE_DEREGISTER"];
    DotFormPost *logOutPost = [[DotFormPost alloc]init];
    [logOutPost setAdapterType:@"JDBC"];
    [logOutPost setAdapterId:@"ADT_JDBC_LOGOUT"];
    [logOutPost setModuleId:AppConst_MOBILET_ID_DEFAULT];
    [logOutPost setDocId:@"DOT_FORM_LOGOUT"];
    [logOutPost setDocDesc:@"Logout"];
    [logOutPost setReportCacheRefresh:@"false"];
    [logOutPost setPostData:dict];
    
    networkHelper = [[NetworkHelper alloc] init];
    [networkHelper makeXmwNetworkCall:logOutPost :self :self  :@"FOR_LOGOUT"];
    
    [[DataManager getInstance] clear];
    
    
}
- (void)alertViewCancel:(UIAlertView *)alertView
{
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


-(void)getNonTSI_Accounts
{
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    NSMutableArray* roleList = [[NSMutableArray alloc]init];
    
    [roleList addObjectsFromArray:[clientVariables.CLIENT_LOGIN_RESPONSE.clientMasterDetail.masterDataRefresh valueForKey:@"LEVEL_WISE_ROLES"]];
    
    
    NSMutableArray* roles = [[NSMutableArray alloc] init];
    

    for (int i=0; i<roleList.count; i++) {
        NSString* roleName = [[roleList objectAtIndex:i] valueForKey:@"rolename"];
        [roles addObject:roleName];
    }
        
    NSMutableDictionary * postCall = [[NSMutableDictionary  alloc]init];
    [postCall setObject:@"role_based_registry_ids_accounts" forKey:@"opcode"];
    [postCall setObject:clientVariables.CLIENT_LOGIN_RESPONSE.authToken forKey:@"authToken"];
    
    
    NSMutableDictionary* postData = [[NSMutableDictionary alloc] init];
    // here it is logged in user (not registy id as used in other apis)
    [postData setObject:clientVariables.CLIENT_USER_LOGIN.userName forKey:@"username"];
    [postData setObject:roles forKey:@"roles"];
        
    [postCall setObject: postData forKey:@"userdetails"];
    
   
    loadingView = [LoadingView loadingViewInView:self.view];
    
    NetworkHelper * networkHelper = [[NetworkHelper alloc] init];
    NSString* url = XmwcsConst_OPCODE_URL;
    networkHelper.serviceURLString = url;
    [networkHelper genericJSONPayloadRequestWith:postCall :self :@"role_based_registry_ids_accounts"];

}

-(void) handleNonTSI_Response:(NSDictionary*) response
{
    if([[response allKeys] containsObject:@"customers"]) {
        NSArray* customers = [response objectForKey:@"customers"];
        
        NSMutableArray< NSMutableArray< NSString* >* >* registryIds = [[NSMutableArray alloc] init];
        
        NSMutableDictionary<NSString*, NSMutableArray< NSMutableArray< NSString*>* >* >*  nonTSIAccounts = [[NSMutableDictionary alloc] init];


        for(int i=0; i<[customers count]; i++) {
            NSDictionary* customer = [customers objectAtIndex:i];
            NSString* registryId = [customer  objectForKey:@"registry_id"];

            NSMutableArray<NSString*>* details = [[NSMutableArray alloc] init];
            
            [details addObject:[[customer objectForKey:@"registry_id"] copy]];
            [details addObject:[[customer objectForKey:@"customer_name"] copy]];
            
            // details.add(customer.getString("display_value"));

            // accounts
            [registryIds addObject:details];

            NSString* key = [@"BUSINESS_VERTICAL_" stringByAppendingString:registryId];

            NSArray* customerAccounts = [customer objectForKey:@"accounts"];

            NSMutableArray< NSMutableArray< NSString*>* >* accountsVertical =  [[NSMutableArray alloc] init];

            for(int j=0; j<[customerAccounts count]; j++) {
                NSDictionary* account = [customerAccounts objectAtIndex:j];
                NSString* customerNumber = [account objectForKey:@"customer_number"];
                NSString* buGroup = [account objectForKey:@"bu_group"];
                // account.getString("display_value_account");
                NSMutableArray<NSString*>* numberList = [[NSMutableArray alloc] init];
                [numberList addObject:[customerNumber copy]];
                [numberList addObject:[NSString stringWithFormat:@"%@-%@", customerNumber, buGroup]];
                
                [accountsVertical addObject:numberList];
            }
            [nonTSIAccounts setObject:accountsVertical forKeyedSubscript:key];
        }
        
        [DataManager getInstance].non_tsi_customers = registryIds;
        [DataManager getInstance].non_tsi_accounts = nonTSIAccounts;
        
    }
    
    if([[response allKeys] containsObject:@"customers_unfiltered"]) {
           NSArray* customers = [response objectForKey:@"customers_unfiltered"];
           
           NSMutableArray< NSMutableArray< NSString* >* >* unfilteredIds = [[NSMutableArray alloc] init];
           
           NSMutableDictionary<NSString*, NSMutableArray< NSMutableArray< NSString*>* >* >*  unfilteredAccounts = [[NSMutableDictionary alloc] init];


           for(int i=0; i<[customers count]; i++) {
               NSDictionary* customer = [customers objectAtIndex:i];
               NSString* registryId = [customer  objectForKey:@"registry_id"];

               NSMutableArray<NSString*>* details = [[NSMutableArray alloc] init];
               
               [details addObject:[[customer objectForKey:@"registry_id"] copy]];
               [details addObject:[[customer objectForKey:@"customer_name"] copy]];
               
               // details.add(customer.getString("display_value"));

               // accounts
               [unfilteredIds addObject:details];

               NSString* key = [@"BUSINESS_VERTICAL_" stringByAppendingString:registryId];

               NSArray* customerAccounts = [customer objectForKey:@"accounts"];

               NSMutableArray< NSMutableArray< NSString*>* >* accountsVertical =  [[NSMutableArray alloc] init];

               for(int j=0; j<[customerAccounts count]; j++) {
                   NSDictionary* account = [customerAccounts objectAtIndex:j];
                   NSString* customerNumber = [account objectForKey:@"customer_number"];
                   NSString* buGroup = [account objectForKey:@"bu_group"];
                   // account.getString("display_value_account");
                   NSMutableArray<NSString*>* numberList = [[NSMutableArray alloc] init];
                   [numberList addObject:[customerNumber copy]];
                   [numberList addObject:[NSString stringWithFormat:@"%@-%@", customerNumber, buGroup]];
                   
                   [accountsVertical addObject:numberList];
               }
               [unfilteredAccounts setObject:accountsVertical forKeyedSubscript:key];
           }
           
           [DataManager getInstance].unfiltered_customers = unfilteredIds;
           [DataManager getInstance].unfiltered_accounts = unfilteredAccounts;
       }

}

@end
