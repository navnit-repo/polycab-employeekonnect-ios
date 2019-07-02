//
//  ChatBoxVC.m
//  XMWClient
//
//  Created by dotvikios on 08/04/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "ChatBoxVC.h"
#import "ChatBoxUserListVC.h"
#import "LayoutClass.h"
#import "ChatThreadCell.h"
#import "ClientVariable.h"
#import "NetworkHelper.h"
#import "LoadingView.h"
#import "XmwcsConstant.h"
#import "DVAppDelegate.h"
#import "AppConstants.h"
#import "ChatRoomsVC.h"
#import "ChatThreadList_Object.h"
#import "ChatThreadList_DB.h"
#import "ContactList_DB.h"
#import "ContactList_Object.h"
#import "ChatHistory_Object.h"
#import "ExpendObjectClass.h"
#import "LogInVC.h"
static NSString *const kCellCatIdentifier = @"kCellCatIdentifier";
static NSString *const kCellSubCatIdentifier = @"kCellSubCatIdentifier";
@interface ChatBoxVC ()

@end

@implementation ChatBoxVC
{
    NetworkHelper *networkHelper;
    LoadingView *loadingView;
    NSMutableDictionary *expendStatus;
    UIView *dotView;
    UIButton *addContactButton;
    NSMutableArray *searchTextArray;
    NSMutableArray *orignalChatThreadListArray;
    bool isfilterFlag;
    long long int uniqueCell;
    UISearchBar *searchBar;
//    NSMutableDictionary *expendObjectOpenClosedStatusDict;
    
}
@synthesize expendObjectOpenClosedStatusDict;
@synthesize chatThreadDict;
@synthesize threadListTableView;

- (void)viewDidLoad {
    uniqueCell =0;
    orignalChatThreadListArray = [[NSMutableArray alloc]init];
    expendObjectOpenClosedStatusDict = [[NSMutableDictionary alloc]init];
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    NSLog(@"Navigation Bar height : %f",navBarHeight);
    CGFloat statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size.height;
    NSLog(@"statusBarSize Bar height : %f",statusBarSize);
    CGFloat yorigin = navBarHeight +statusBarSize;
    CGFloat totalViewHeight = [[UIApplication sharedApplication].keyWindow bounds].size.height;
    if (isiPhoneXSMAX) {
        self.view.frame = CGRectMake(0, yorigin, 414, totalViewHeight-yorigin);
    }
    else if(isiPhoneXR) {
        self.view.frame = CGRectMake(0, yorigin, 414, totalViewHeight-yorigin);
    }
    
    else if(isiPhoneXS) {
        self.view.frame = CGRectMake(0, yorigin, 375, totalViewHeight-yorigin);
    }
    else if(isiPhone10) {
        self.view.frame = CGRectMake(0, yorigin, 375, totalViewHeight-yorigin);
    }
    
    else if(isiPhone6Plus) {
        self.view.frame = CGRectMake(0, yorigin, 414, totalViewHeight-yorigin);
    }
    else if(isiPhone6) {
        self.view.frame = CGRectMake(0, yorigin, 375, totalViewHeight-yorigin);
    } else if(isiPhone5) {
        self.view.frame = CGRectMake(0, yorigin, 320, totalViewHeight-yorigin);
    } else {
        // 0, 64, 320, 416
        self.view.frame = CGRectMake(0, yorigin, 320, totalViewHeight-yorigin);
    }
    expendStatus = [[NSMutableDictionary alloc]init];
    orignalChatThreadListArray = [[NSMutableArray alloc]init];
    [self drawHeaderItem];
    [self contactListNetworkCall];
    [self initializeView];
   

    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidAppear:(BOOL)animated
{
   
    [threadListTableView reloadData];
}
- (void)viewWillAppear:(BOOL)animated
{
    searchBar.text = @"";
    
    CGFloat width = [[UIApplication sharedApplication].keyWindow bounds].size.width;
    CGFloat height = [[UIApplication sharedApplication].keyWindow bounds].size.height;
    
    addContactButton = [[UIButton alloc]initWithFrame:CGRectMake( width-70*deviceWidthRation, height-70*deviceHeightRation, 40*deviceWidthRation, 40*deviceHeightRation)];
    [addContactButton setImage:[UIImage imageNamed:@"chat_add"] forState:UIControlStateNormal];
    [addContactButton addTarget:self action:@selector(addButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [[[UIApplication sharedApplication] keyWindow] addSubview:addContactButton];

    if (ChatBoxPushNotifiactionFlag == YES) {
        if (chatThreadDict.count>0) {
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                                   [self pushHandling];
                           });
        
//           [self performSelector:@selector(pushHandling) withObject:nil afterDelay:0.5];
        }
       
       
    }
    else if (ChatRoomPushNotifiactionFlag == YES)
    {
       
        if (chatThreadDict.count>0) {
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               [self pushHandling];
                           });
//            [self performSelector:@selector(pushHandling) withObject:nil afterDelay:0.5];
        }

    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    [addContactButton removeFromSuperview];
}
-(void)pushHandling
{
    ChatThreadList_Object *obj;
    if (ChatBoxPushNotifiactionFlag == YES) {
        ChatBoxPushNotifiactionFlag = NO;
        ExpendObjectClass *expendObj = (ExpendObjectClass *)[chatThreadDict objectAtIndex:0];
      obj = (ChatThreadList_Object *)[expendObj.childCategories objectAtIndex:0];
    }
    else if (ChatRoomPushNotifiactionFlag== YES)
    {
        ChatRoomPushNotifiactionFlag= NO;
        
        ChatHistory_Object* chatHistory_Object = (ChatHistory_Object*) puchNotifiactionChatHistory_Object;
        
        UITableViewCell *cell = [(UITableViewCell *) self.view viewWithTag:chatHistory_Object.chatThreadId];
        NSIndexPath *index = [self.threadListTableView indexPathForCell:cell];
        NSLog(@"%i", index.row);
        ExpendObjectClass *expendObj = (ExpendObjectClass *)[chatThreadDict objectAtIndex:0];
        obj = (ChatThreadList_Object *)[expendObj.childCategories objectAtIndex:0];
    }
    NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
    NSString *ownUserId = chatPersonUserID;
    NSString *parseId= @"";// for get username from contact db
    NSArray *array = [obj.from componentsSeparatedByString:@"@"];
    if ([[array objectAtIndex:0] isEqualToString:ownUserId]) {
        parseId =obj.to;
    }
    else{
        parseId =obj.from;
    }
    NSArray *array2 = [parseId componentsSeparatedByString:@"@"];//// for accept button check.
    if ([[array2 objectAtIndex:1] isEqualToString:@"employee"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"Accept_Chat_Button"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"Accept_Chat_Button"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSArray *navigationControllesArray = [[self navigationController] viewControllers];
    ChatRoomsVC *vc = [[ChatRoomsVC alloc]init];
    NSString*objString = obj.subject;
    //  Base64 string to original string
    NSData *base64Data = [[NSData alloc] initWithBase64EncodedString:objString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *originalString =[[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
    
    NSLog(@"Result: %@",originalString);
    vc.subject =originalString;
    vc.withChatPersonName = parseId;
    vc.chatThreadId =[NSString stringWithFormat:@"%d",obj.chatThreadId];
    vc.chatStatus = obj.status;
    vc.nameLbltext = obj.displayName;

    [[self navigationController ] pushViewController:vc animated:YES];
    
}
-(void)initializeView
{
    
    
//    [LayoutClass setLayoutForIPhone6:self.searchBar];
    [LayoutClass setLayoutForIPhone6:self.headerView];
    [LayoutClass setLayoutForIPhone6:self.lineView1];
    [LayoutClass setLayoutForIPhone6:self.lineView2];
    [LayoutClass labelLayout:self.nameLbl forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.constantLbl1 forFontWeight:UIFontWeightRegular];
    [LayoutClass setLayoutForIPhone6:self.threadListTableView];
    self.threadListTableView.frame = CGRectMake(self.threadListTableView.frame.origin.x, self.threadListTableView.frame.origin.y, self.threadListTableView.frame.size.width,self.view.frame.size.height-(self.headerView.frame.size.height));
    
    threadListTableView.delegate = self;
    threadListTableView.bounces = NO;
  
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(10, 8, _headerView.frame.size.width-20, 44*deviceHeightRation)];
    searchBar.delegate = self;
    searchBar.barTintColor = [UIColor whiteColor];
    searchBar.layer.borderWidth = 0.5;
    searchBar.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [searchBar setPlaceholder:@"Search"];
    [searchBar setReturnKeyType:UIReturnKeyDone];
    searchBar.enablesReturnKeyAutomatically = NO;
    [_headerView addSubview:searchBar];
}

-(void)contactListNetworkCall
{
    [ContactList_DB createInstance : @"ContactList_DB_STORAGE" : true];
    ContactList_DB *contactListStorage = [ContactList_DB getInstance];
    NSMutableArray *contactListStorageData = [contactListStorage getRecentDocumentsData : @"False"];
   NSMutableArray* contactsList = [[NSMutableArray alloc]init];
    [contactsList addObjectsFromArray:contactListStorageData];
    if (contactsList.count!=0) {
        // show loacl save data
        [self chatThreadListNetworkCall];
    }
    else{
    
        NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
        
    loadingView = [LoadingView loadingViewInView:self.view];
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSMutableDictionary *requstData = [[NSMutableDictionary alloc]init];
    
    [requstData setValue:@"45" forKey:@"requestId"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    [data setValue:[chatPersonUserID stringByAppendingString:@"@employee"] forKey:@"userId"];
    [data setValue:@"1" forKey:@"apiVersion"];
    [data setValue:[[clientVariables.CLIENT_USER_LOGIN deviceInfoMap] valueForKey:@"IMEI"]  forKey:@"deviceId"];
    [data setValue:XmwcsConst_DEVICE_TYPE_IPHONE forKey:@"osType"];
    [data setValue:version forKey:@"appVersion"];
    
    [requstData setObject:data forKey:@"requestData"];
    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=[XmwcsConst_CHAT_URL stringByAppendingString:@"PushMessage/api/getContacts"];
//    networkHelper.serviceURLString = @"http://polycab.dotvik.com:8080/PushMessage/api/getContacts";
        networkHelper.serviceURLString = url;
    [networkHelper genericJSONPayloadRequestWith:requstData :self :@"requestUserList"];
    }
}
-(void)setHeaderDetailsData
{
    [self chatThreadListNetworkCall];
}
-(void)chatThreadListNetworkCall
{
    [ChatThreadList_DB createInstance : @"ChatThread_DB_STORAGE" : true];
    ChatThreadList_DB *chatThreadListStorage = [ChatThreadList_DB getInstance];
    NSMutableArray *chatThreadListStorageData = [chatThreadListStorage getRecentDocumentsData : @"False"];
    chatThreadDict = [[NSMutableArray alloc]init];
    [chatThreadDict addObjectsFromArray:chatThreadListStorageData];
    NSMutableArray*distinctName = [[NSMutableArray alloc]init];
    for (int i=0; i<chatThreadDict.count; i++) {
        ChatThreadList_Object *obj = (ChatThreadList_Object*) [chatThreadDict objectAtIndex:i];
        
        if (![distinctName  containsObject:obj.displayName]) {
            [distinctName addObject:obj.displayName];
        }
    }
    
    NSMutableArray *groupObject = [[NSMutableArray alloc]init];
    for (int i=0; i<distinctName.count; i++) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        ExpendObjectClass * expendObj = [[ExpendObjectClass alloc]init];
        for (int j=0; j<chatThreadDict.count; j++) {
            ChatThreadList_Object *obj = (ChatThreadList_Object*) [chatThreadDict objectAtIndex:j];
            if ([obj.displayName isEqualToString:[distinctName objectAtIndex:i]] ) {
                [array addObject:obj];
            }
           
        }
        expendObj.MENU_NAME =[distinctName objectAtIndex:i];
        expendObj.childCategories = array;
        [groupObject addObject:expendObj];
    }
    if (chatThreadDict.count!=0) {
        // show loacl save data
        chatThreadDict = [[NSMutableArray alloc]init];
        [chatThreadDict addObjectsFromArray:groupObject];
        [orignalChatThreadListArray addObjectsFromArray:chatThreadDict];
    }
    else{
        
        NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];

        
    loadingView = [LoadingView loadingViewInView:self.view];
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSMutableDictionary *chatThreadRequestData = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *reqstData = [[NSMutableDictionary alloc]init];
    [chatThreadRequestData setValue:@"1" forKey:@"requestId"];
    [reqstData setValue:[chatPersonUserID stringByAppendingString:@"@employee"] forKey:@"userId"];
    [reqstData setValue:[[clientVariables.CLIENT_USER_LOGIN deviceInfoMap] valueForKey:@"IMEI"] forKey:@"deviceId"];
    [reqstData setValue:XmwcsConst_DEVICE_TYPE_IPHONE forKey:@"osType"];
    [reqstData setValue:version forKey:@"appVersion"];
    [reqstData setValue:@"1" forKey:@"apiVersion"];
    [chatThreadRequestData setObject:reqstData forKey:@"requestData"];

    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=[XmwcsConst_CHAT_URL stringByAppendingString:@"PushMessage/api/chatThreads"];
    networkHelper.serviceURLString = url;
//    networkHelper.serviceURLString = @"http://polycab.dotvik.com:8080/PushMessage/api/chatThreads";
    [networkHelper genericJSONPayloadRequestWith:chatThreadRequestData :self :@"chatThreadRequestData"];
    }
}
-(void) drawHeaderItem
{
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage
                                                                          imageNamed:@"back-button"]  style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(backHandler:)];
    
    
    
    backButton.tintColor = [UIColor whiteColor];
    
    UIImageView *polycabLogo = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"polycab_logo"]];
    self.navigationItem.titleView.contentMode = UIViewContentModeCenter;
    self.navigationItem.titleView = polycabLogo;
    
    [self.navigationItem setLeftBarButtonItem:backButton];

    
}
- (void) backHandler : (id) sender
{
    [ [self navigationController]  popViewControllerAnimated:YES];
    
}
- (void) addButtonHandler : (id) sender
{
    ChatBoxUserListVC *userListVC = [[ChatBoxUserListVC alloc]init];
    [[self navigationController] pushViewController:userListVC animated:YES];
    
}

#pragma -mark Network Call Response methods
- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    [loadingView removeView];
    
    if ([callName isEqualToString:@"requestUserList"]) {
        if ([[respondedObject objectForKey:@"status"] boolValue] == YES) {
            NSMutableArray * contactsList = [[NSMutableArray alloc]init];
            [contactsList addObjectsFromArray:[[respondedObject valueForKey:@"responseData"] valueForKey:@"contacts"]];
            
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
            [contactsList addObjectsFromArray:[[respondedObject valueForKey:@"responseData"] valueForKey:@"hiddenContacts"]];
            
            for(int i =0; i<[contactsList count];i++) //for hidden contact  insert into db
            {
                ContactList_Object* contactList_Object = [[ContactList_Object alloc] init];
                contactList_Object.emailId = [[contactsList objectAtIndex:i] valueForKey:@"emailId"];
                contactList_Object.name =    [[contactsList objectAtIndex:i] valueForKey:@"name"];
                contactList_Object.userId =  [[contactsList objectAtIndex:i] valueForKey:@"userId"];
                contactList_Object.isHidden = 1;
                [contactListStorage insertDoc:contactList_Object];
            }
            
          [self setHeaderDetailsData];
            
        }
        else
        {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"" message:[[respondedObject valueForKey:@"errorData"] valueForKey:@"displayMessage"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
            [myAlertView show];
        }
        
    }
    
    if ([callName isEqualToString:@"chatThreadRequestData"]) {
  
        if ([[respondedObject objectForKey:@"status"] boolValue] == YES) {
            NSMutableArray *records = [[respondedObject valueForKey:@"responseData"] valueForKey:@"list"];
            NSMutableArray *displayThreadCount  = [[NSMutableArray alloc]init];
            for (int i=0; i<records.count; i++) {
                BOOL flag = [[[records objectAtIndex:i] valueForKey:@"deleted"] boolValue];
                ChatThreadList_Object* chatThreadList_Object = [[ChatThreadList_Object alloc] init];
                chatThreadList_Object.deletedFlag = [ NSString stringWithFormat:@"%@",flag ? @"YES" : @"NO"];
                if ([chatThreadList_Object.deletedFlag isEqualToString:@"NO"]) {
                    [displayThreadCount addObject:[records objectAtIndex:i]];
                }
            }
            if (displayThreadCount.count<=0) {
                
                
            }
            else
            {
            [ContactList_DB createInstance : @"ContactList_DB_STORAGE" : true];
            ContactList_DB *contactListStorage = [ContactList_DB getInstance];
            
            
            
            chatThreadDict = [[NSMutableArray alloc]init];
            [chatThreadDict addObjectsFromArray:[[respondedObject valueForKey:@"responseData"] valueForKey:@"list"]];
            // [threadListTableView reloadData];
            [ChatThreadList_DB createInstance : @"ChatThread_DB_STORAGE" : true];
            ChatThreadList_DB *chatThreadListStorage = [ChatThreadList_DB getInstance];
            [chatThreadListStorage dropTable:@"ChatThread_DB_STORAGE"];
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
                }
                else{
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
                chatThreadList_Object.displayName = obj.userName;
                chatThreadList_Object.unreadMessageCount =[[[chatThreadDict objectAtIndex:i] valueForKey:@"unreadMessageCount"] intValue] ;
                chatThreadList_Object.spaNo =[ NSString stringWithFormat:@"%@",[[chatThreadDict objectAtIndex:i] valueForKey:@"spaNo"]];
                [chatThreadListStorage insertDoc:chatThreadList_Object];
                
            }
            NSMutableArray *chatThreadListStorageData = [chatThreadListStorage getRecentDocumentsData : @"False"];
            chatThreadDict = [[NSMutableArray alloc]init];
            [chatThreadDict addObjectsFromArray:chatThreadListStorageData];
            [self chatThreadListNetworkCall];
            [threadListTableView reloadData];
                
                
                 if (ChatBoxPushNotifiactionFlag == YES) {
                     [self pushHandling];
                 }
                else if (ChatRoomPushNotifiactionFlag == YES) {
                    [self pushHandling];
                }
                
        }
        }
        else
        {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"" message:[[respondedObject valueForKey:@"errorData"] valueForKey:@"displayMessage"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
            [myAlertView show];
        }
    }
}
- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
    
}

#pragma - mark TableView  methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
     [searchBar resignFirstResponder];
    if ([[chatThreadDict objectAtIndex: indexPath.row] isKindOfClass:[ExpendObjectClass class]]) {
        ExpendObjectClass *currObject = chatThreadDict[indexPath.row];
        if (currObject.childCategories>0) {
            dotView.backgroundColor  = [UIColor clearColor];
            BOOL isAlreadyInserted=[self checkIfChildrenInserted:currObject];
            if(isAlreadyInserted) {
                [expendObjectOpenClosedStatusDict setObject:@"close" forKey:currObject.MENU_NAME];
                [self miniMizeThisRows:currObject.childCategories];
            }
            else{
                [expendObjectOpenClosedStatusDict setObject:@"open" forKey:currObject.MENU_NAME];
                NSUInteger count=indexPath.row+1;
                NSMutableArray *arCells=[NSMutableArray array];
                NSMutableArray *childData =currObject.childCategories;
                for (int i=0; i<[childData count]; i++) {
                    ChatThreadList_Object *dInner = (ChatThreadList_Object*) [childData objectAtIndex:i];
                    [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                    [chatThreadDict insertObject:dInner atIndex:count++];
                }
                [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationLeft];
                
            }
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone]; // reload for arrow status
        }
    }
    
    else{
        expendObjectOpenClosedStatusDict = [[NSMutableDictionary alloc]init];
    ChatThreadList_Object *obj = (ChatThreadList_Object *)[chatThreadDict objectAtIndex:indexPath.row];
    NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
    NSString *ownUserId = chatPersonUserID;
    NSString *parseId= @"";// for get username from contact db
    NSArray *array = [obj.from componentsSeparatedByString:@"@"];
    if ([[array objectAtIndex:0] isEqualToString:ownUserId]) {
        parseId =obj.to;
    }
    else{
        parseId =obj.from;
    }
     NSArray *array2 = [parseId componentsSeparatedByString:@"@"];//// for accept button check.
    if ([[array2 objectAtIndex:1] isEqualToString:@"employee"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"Accept_Chat_Button"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
         [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"Accept_Chat_Button"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
        NSString*objString = obj.subject;
        //  Base64 string to original string
        NSData *base64Data = [[NSData alloc] initWithBase64EncodedString:objString options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSString *originalString =[[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
        
        NSLog(@"Result: %@",originalString);
        
    ChatRoomsVC *vc = [[ChatRoomsVC alloc]init];
    vc.subject =originalString;
    vc.withChatPersonName = parseId;
    vc.chatThreadId =[NSString stringWithFormat:@"%d",obj.chatThreadId];
    vc.chatStatus = obj.status;
    vc.nameLbltext = obj.displayName;
    [[self navigationController ] pushViewController:vc animated:YES];
    
    ChatThreadCell *cellView =[( ChatThreadCell * ) self.view viewWithTag:obj.chatThreadId];
    cellView.pushView.backgroundColor = [UIColor clearColor];
    }
}
- (BOOL)checkIfChildrenInserted: (ExpendObjectClass *)parentObject {
    BOOL childrenInserted=NO;
    
    for(ChatThreadList_Object *dInner in parentObject.childCategories ){
        NSUInteger index=[chatThreadDict indexOfObject:dInner];
        childrenInserted=(index>0 && index!=NSIntegerMax);
        if(childrenInserted) break;
    }
    return childrenInserted;
}
-(void)miniMizeThisRows:(NSArray*)ar{
    
    for(ExpendObjectClass *dInner in ar ) {
        NSUInteger indexToRemove=[chatThreadDict indexOfObject:dInner];
        if([chatThreadDict indexOfObject:dInner]!=NSNotFound) {
            [chatThreadDict removeObject:dInner];
            [threadListTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                          [NSIndexPath indexPathForRow:indexToRemove inSection:0]
                                          ]
                        withRowAnimation:UITableViewRowAnimationRight];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numOfSections = 0;
    if (chatThreadDict.count >0)
    {
        numOfSections = 1;
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        threadListTableView.backgroundView  = view;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, threadListTableView.bounds.size.width, threadListTableView.bounds.size.height)];
        noDataLabel.text             = @"No chat threads available.";
        noDataLabel.textColor        = [UIColor blackColor];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        threadListTableView.backgroundView  = noDataLabel;
        threadListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return numOfSections;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [chatThreadDict count];
 
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height =0.0f;
    
    if ([[chatThreadDict objectAtIndex:indexPath.row] isKindOfClass:[ExpendObjectClass class]] ) {
        height =40.0f;
    }
 else if([[chatThreadDict objectAtIndex:indexPath.row] isKindOfClass:[ChatThreadList_Object class]])
    {
        height =70.0f;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    NSString *str = [NSString stringWithFormat:@"cell_%lld",uniqueCell];
    uniqueCell ++;
    if ([[chatThreadDict objectAtIndex:indexPath.row] isKindOfClass:[ExpendObjectClass class]]  ) {
        UITableViewCell *cell ;
     
//        cell = [tableView dequeueReusableCellWithIdentifier:str];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
        ExpendObjectClass* obj =( ExpendObjectClass *) [chatThreadDict objectAtIndex:indexPath.row];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 0, cell.frame.size.width, cell.frame.size.height)];
        dotView = [[UIView alloc]initWithFrame:CGRectMake(0, 15, 10*deviceWidthRation, 10*deviceHeightRation)];
        dotView.tag = uniqueCell;
        for (int i=0; i<obj.childCategories.count; i++) {
            ChatThreadList_Object *threadObj = (ChatThreadList_Object*) [obj.childCategories objectAtIndex:i];
            if (threadObj.unreadMessageCount >0) {
                    dotView.backgroundColor = [UIColor colorWithRed:204.0f/255 green:41.0f/255 blue:43.0f/255 alpha:1.0];
                    break;
                }
                else
                {
                    dotView.backgroundColor = [UIColor clearColor];
                }
        }
        
        
        dotView.layer.cornerRadius = 5;
        UILabel *textLbl = [[UILabel alloc]initWithFrame:CGRectMake(15*deviceWidthRation, 0,cell.frame.size.width, cell.frame.size.height)];
        textLbl.text  = obj.MENU_NAME;
        textLbl.font = [UIFont systemFontOfSize:14.0f weight:UIFontWeightBold];
        [view addSubview:dotView];
        [view addSubview:textLbl];
        [cell.contentView addSubview:view];
        UIImageView *arrowView = [[UIImageView alloc]init];
        [arrowView setFrame:CGRectMake(0, 0, 15, 5)];
        if ([expendObjectOpenClosedStatusDict valueForKey:obj.MENU_NAME]==nil || [[expendObjectOpenClosedStatusDict valueForKey:obj.MENU_NAME] isEqualToString:@"close"]) {
            
            [arrowView setImage:[UIImage imageNamed:@"polycab_arrow_closed"]];
            cell.accessoryView = arrowView;
            
        }
        else if ([[expendObjectOpenClosedStatusDict valueForKey:obj.MENU_NAME ] isEqualToString:@"open"])
        {
            [arrowView setImage:[UIImage imageNamed:@"polycab_arrow_open"]];
            cell.accessoryView = arrowView;
        }
       
        
            return cell;



    }
    else if([[chatThreadDict objectAtIndex:indexPath.row] isKindOfClass:[ChatThreadList_Object class]] )
    {
         ChatThreadCell * cell =(ChatThreadCell*) [tableView dequeueReusableCellWithIdentifier:str];
            [tableView registerNib:[UINib nibWithNibName:@"ChatThreadCell" bundle:nil] forCellReuseIdentifier:str];
            cell  = [tableView dequeueReusableCellWithIdentifier:str];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            ChatThreadList_Object *obj = (ChatThreadList_Object *)[chatThreadDict objectAtIndex:indexPath.row];
        NSString*objString = obj.subject;
        //  Base64 string to original string
        NSData *base64Data = [[NSData alloc] initWithBase64EncodedString:objString options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSString *originalString =[[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
        
        NSLog(@"Result: %@",originalString);
        
            cell.subjectLbl.text = originalString;
            cell.chatPersonLbl.text = obj.displayName;
            double timeStamp = [obj.lastMessageOn doubleValue];
            
            NSTimeInterval timeInterval=timeStamp/1000;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
            NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
            [dateformatter setDateFormat:@"dd LLL,yy HH:mm"];
            NSString *dateString=[dateformatter stringFromDate:date];
            cell.timeStampLbl.text =dateString;
            cell.tag = obj.chatThreadId;
            cell.closeButtonOutlate.elementId = [NSString stringWithFormat:@"%d",obj.chatThreadId];
            
            if ([obj.status isEqualToString:@"Accept"] || [obj.status isEqualToString:@"Close"] || [obj.status isEqualToString:@"Accept-Talk"] ) {
               
                [cell.acceptImageView setImage:[UIImage imageNamed:@"Tick_Mark"]];
                cell.chatIdLbl.text = [NSString stringWithFormat:@"SPA No : %@",obj.spaNo];
            }

            if (obj.unreadMessageCount >0) {
                cell.pushView.backgroundColor = [UIColor colorWithRed:204.0f/255 green:41.0f/255 blue:43.0f/255 alpha:1.0];
            }
            else
            {
                cell.pushView.backgroundColor = [UIColor clearColor];
            }
            return cell;

    }
    return nil;

}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([[chatThreadDict objectAtIndex:indexPath.row] isKindOfClass:[ExpendObjectClass class]]  ) {
//        ExpendObjectClass* obj =( ExpendObjectClass *) [chatThreadDict objectAtIndex:indexPath.row];
//        NSString  *str = cell.reuseIdentifier;
//        NSArray *array = [str componentsSeparatedByString:@"_"];
//
//        dotView = (UIView*) [self.view viewWithTag:[[array objectAtIndex:1] intValue] ];
//
//        for (int i=0; i<obj.childCategories.count; i++) {
//            ChatThreadList_Object *threadObj = (ChatThreadList_Object*) [obj.childCategories objectAtIndex:i];
//            if (threadObj.unreadMessageCount >0) {
//                dotView.backgroundColor = [UIColor colorWithRed:204.0f/255 green:41.0f/255 blue:43.0f/255 alpha:1.0];
//                break;
//            }
//            else
//            {
//                dotView.backgroundColor = [UIColor clearColor];
//            }
//        }
//}
}
#pragma mark - searchBar handler
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    expendObjectOpenClosedStatusDict = [[NSMutableDictionary alloc]init];
    NSLog(@"%@",searchText);
    searchTextArray = [[NSMutableArray alloc]init];
    if (searchText.length>0) {
        
        for (int i=0; i<orignalChatThreadListArray.count; i++) {
            ExpendObjectClass *obj = (ExpendObjectClass*) [orignalChatThreadListArray objectAtIndex:i];
            NSString *name  = obj.MENU_NAME;
            
            NSRange nameRange = [name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (nameRange.location != NSNotFound) {
                [searchTextArray addObject:obj];
            
            }
            else
            {
                NSMutableArray *childArray = [[NSMutableArray alloc]init];
                for (int j=0; j<obj.childCategories.count; j++) {
                    
                    ChatThreadList_Object *childObject = (ChatThreadList_Object *)[obj.childCategories objectAtIndex:j];
                    NSString*objString = childObject.subject;
                    //  Base64 string to original string
                    NSData *base64Data = [[NSData alloc] initWithBase64EncodedString:objString options:NSDataBase64DecodingIgnoreUnknownCharacters];
                    NSString *childSubject =[[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
                    NSLog(@"Result: %@",childSubject);
                    NSRange nameRange = [childSubject rangeOfString:searchText options:NSCaseInsensitiveSearch];
                   
                    
                    if (nameRange.location != NSNotFound) {
                      
                        [childArray addObject:childObject];
                        
                    }
                  
                   
                }
                if (childArray.count >0) {
                    ExpendObjectClass * newobject = [[ExpendObjectClass alloc] init];
                    newobject.MENU_NAME = obj.MENU_NAME;
                    newobject.childCategories = childArray;
                    [searchTextArray addObject:newobject];
                }
            }
            
        }
        chatThreadDict =[[NSMutableArray alloc]init];
        [chatThreadDict addObjectsFromArray:searchTextArray];
         [threadListTableView reloadData];
    }
    else
    {   chatThreadDict  = [[NSMutableArray alloc]init];
        [chatThreadDict addObjectsFromArray:orignalChatThreadListArray];
        [threadListTableView reloadData];
    }
   
}
@end
