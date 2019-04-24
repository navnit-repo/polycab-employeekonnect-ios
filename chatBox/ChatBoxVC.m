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
@interface ChatBoxVC ()

@end

@implementation ChatBoxVC
{
    NetworkHelper *networkHelper;
    LoadingView *loadingView;
}
@synthesize chatThreadDict;
@synthesize threadListTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawHeaderItem];
    [self contactListNetworkCall];
    [self initializeView];
    // Do any additional setup after loading the view from its nib.
}
-(void)initializeView
{
    [LayoutClass setLayoutForIPhone6:self.lineView1];
    [LayoutClass setLayoutForIPhone6:self.lineView2];
    [LayoutClass labelLayout:self.nameLbl forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.constantLbl1 forFontWeight:UIFontWeightRegular];
    [LayoutClass setLayoutForIPhone6:self.threadListTableView];
   
    threadListTableView.delegate = self;
    threadListTableView.bounces = NO;
  
//    [self setHeaderDetailsData];
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
    
    loadingView = [LoadingView loadingViewInView:self.view];
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSMutableDictionary *requstData = [[NSMutableDictionary alloc]init];
    
    [requstData setValue:@"45" forKey:@"requestId"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    [data setValue:[[clientVariables.CLIENT_USER_LOGIN userName] stringByAppendingString:@"@employee"] forKey:@"userId"];
    [data setValue:@"1" forKey:@"apiVersion"];
    [data setValue:[[clientVariables.CLIENT_USER_LOGIN deviceInfoMap] valueForKey:@"IMEI"]  forKey:@"deviceId"];
    [data setValue:XmwcsConst_DEVICE_TYPE_IPHONE forKey:@"osType"];
    [data setValue:version forKey:@"appVersion"];
    
    [requstData setObject:data forKey:@"requestData"];
    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=XmwcsConst_OPCODE_URL;
    networkHelper.serviceURLString = @"http://polycab.dotvik.com:8080/PushMessage/api/getContacts";
    [networkHelper genericJSONPayloadRequestWith:requstData :self :@"requestUserList"];
    }
}
-(void)setHeaderDetailsData
{
   // self.nameLbl.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"CUSTOMER_NAME"];
    [self chatThreadListNetworkCall];
}
-(void)chatThreadListNetworkCall
{
    [ChatThreadList_DB createInstance : @"ChatThread_DB_STORAGE" : true];
    ChatThreadList_DB *chatThreadListStorage = [ChatThreadList_DB getInstance];
    NSMutableArray *chatThreadListStorageData = [chatThreadListStorage getRecentDocumentsData : @"False"];
    chatThreadDict = [[NSMutableArray alloc]init];
    [chatThreadDict addObjectsFromArray:chatThreadListStorageData];
    if (chatThreadDict.count!=0) {
        // show loacl save data
    }
    else{
    loadingView = [LoadingView loadingViewInView:self.view];
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSMutableDictionary *chatThreadRequestData = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *reqstData = [[NSMutableDictionary alloc]init];
    [chatThreadRequestData setValue:@"1" forKey:@"requestId"];
    [reqstData setValue:[[clientVariables.CLIENT_USER_LOGIN userName] stringByAppendingString:@"@employee"] forKey:@"userId"];
    [reqstData setValue:[[clientVariables.CLIENT_USER_LOGIN deviceInfoMap] valueForKey:@"IMEI"] forKey:@"deviceId"];
    [reqstData setValue:XmwcsConst_DEVICE_TYPE_IPHONE forKey:@"osType"];
    [reqstData setValue:version forKey:@"appVersion"];
    [reqstData setValue:@"1" forKey:@"apiVersion"];
    [chatThreadRequestData setObject:reqstData forKey:@"requestData"];

    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=XmwcsConst_OPCODE_URL;
    networkHelper.serviceURLString = @"http://polycab.dotvik.com:8080/PushMessage/api/chatThreads";
    [networkHelper genericJSONPayloadRequestWith:chatThreadRequestData :self :@"chatThreadRequestData"];
    }
}
-(void) drawHeaderItem
{
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage
                                                                          imageNamed:@"back-button"]  style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(backHandler:)];
    
    
    
    backButton.tintColor = [UIColor whiteColor];
    
    
    
    UIBarButtonItem *addButon = [[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addButtonHandler:)];
    addButon.tintColor = [UIColor whiteColor];
    
    
    UIImageView *polycabLogo = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"polycab_logo"]];
    self.navigationItem.titleView.contentMode = UIViewContentModeCenter;
    self.navigationItem.titleView = polycabLogo;
    
    [self.navigationItem setLeftBarButtonItem:backButton];
    [self.navigationItem setRightBarButtonItem:addButon];
    
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
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"" message:[[respondedObject valueForKey:@"responseData"] valueForKey:@"displayMessage"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
            [myAlertView show];
        }
        
    }
    
    if ([callName isEqualToString:@"chatThreadRequestData"]) {
  
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
                NSString *ownUserId = [[clientVariables.CLIENT_USER_LOGIN userName] stringByAppendingString:@"@employee"];
                NSString *parseId= @"";// for get username from contact db
                if ([[[chatThreadDict objectAtIndex:i] valueForKey:@"fromUserId"] isEqualToString:ownUserId]) {
                    parseId =[[chatThreadDict objectAtIndex:i] valueForKey:@"toUserId"];
                }
                else{
                     parseId =[[chatThreadDict objectAtIndex:i] valueForKey:@"fromUserId"];
                }
                
                 NSArray *contactListStorageData = [contactListStorage getContactDisplayName:@"False" :parseId];
                
                ContactList_Object *obj = (ContactList_Object*) [contactListStorageData objectAtIndex:0];
                
                ChatThreadList_Object* chatThreadList_Object = [[ChatThreadList_Object alloc] init];
                chatThreadList_Object.chatThreadId =[[[chatThreadDict objectAtIndex:i] valueForKey:@"id"] integerValue] ;
                chatThreadList_Object.from =   [ NSString stringWithFormat:@"%@", [[chatThreadDict objectAtIndex:i] valueForKey:@"fromUserId"]];
                chatThreadList_Object.to =  [ NSString stringWithFormat:@"%@",[[chatThreadDict objectAtIndex:i] valueForKey:@"toUserId"]];
                chatThreadList_Object.subject =[ NSString stringWithFormat:@"%@",[[chatThreadDict objectAtIndex:i] valueForKey:@"subject"]];
                chatThreadList_Object.lastMessageOn =[ NSString stringWithFormat:@"%@",[[chatThreadDict objectAtIndex:i] valueForKey:@"lastMessageOn"]];
                chatThreadList_Object.status =[ NSString stringWithFormat:@"%@",[[chatThreadDict objectAtIndex:i] valueForKey:@"status"]];
                chatThreadList_Object.displayName = obj.userName;
                [chatThreadListStorage insertDoc:chatThreadList_Object];

            }
            NSMutableArray *chatThreadListStorageData = [chatThreadListStorage getRecentDocumentsData : @"False"];
            chatThreadDict = [[NSMutableArray alloc]init];
            [chatThreadDict addObjectsFromArray:chatThreadListStorageData];
            [threadListTableView reloadData];
        }
        else
        {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"" message:[[respondedObject valueForKey:@"responseData"] valueForKey:@"displayMessage"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
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
    ChatThreadList_Object *obj = (ChatThreadList_Object *)[chatThreadDict objectAtIndex:indexPath.row];
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    NSString *ownUserId = [clientVariables.CLIENT_USER_LOGIN userName];
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
    }
    else
    {
         [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"Accept_Chat_Button"];
    }
    
   // ChatThreadList_Object *obj = (ChatThreadList_Object *)[chatThreadDict objectAtIndex:indexPath.row];
    ChatRoomsVC *vc = [[ChatRoomsVC alloc]init];
    vc.subject =obj.subject;
    vc.withChatPersonName = parseId;
    vc.chatThreadId =[NSString stringWithFormat:@"%d",obj.chatThreadId];
    vc.chatStatus = obj.status;
    vc.nameLbltext = obj.displayName;
    [[self navigationController ] pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [chatThreadDict count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10; // you can have your own choice, of course
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
    NSString *str = [NSString stringWithFormat:@"cell_%ld",indexPath.row];
    ChatThreadCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
//    if (cell==nil) {
        [tableView registerNib:[UINib nibWithNibName:@"ChatThreadCell" bundle:nil] forCellReuseIdentifier:str];
        cell  = [tableView dequeueReusableCellWithIdentifier:str];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ChatThreadList_Object *obj = (ChatThreadList_Object *)[chatThreadDict objectAtIndex:indexPath.row];
        cell.subjectLbl.text = obj.subject;
        cell.chatPersonLbl.text = obj.displayName;
        double timeStamp = [obj.lastMessageOn doubleValue];
       
        NSTimeInterval timeInterval=timeStamp/1000;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
        [dateformatter setDateFormat:@"dd-LLL, HH:mm"];
        NSString *dateString=[dateformatter stringFromDate:date];
        cell.timeStampLbl.text =dateString;
        cell.tag = obj.chatThreadId;
        
        if ([obj.status isEqualToString:@"Accept"] || [obj.status isEqualToString:@"Close"]) {
            cell.backgroundColor = [UIColor colorWithRed:230.0f/255 green:230.0f/255 blue:230.0f/255 alpha:1.0];
        }

        
    //}
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
