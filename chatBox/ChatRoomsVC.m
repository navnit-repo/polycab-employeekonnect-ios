//
//  ChatRoomsVC.m
//  XMWClient
//
//  Created by dotvikios on 12/04/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "ChatRoomsVC.h"
#import "LayoutClass.h"
#import "NetworkHelper.h"
#import "LoadingView.h"
#import "XmwcsConstant.h"
#import "DVAppDelegate.h"
#import "AppConstants.h"
#import "ClientVariable.h"
#import "ChatHistory_Object.h"
#import "ChatHistory_DB.h"
#import "ChatThreadList_Object.h"
#import "ChatThreadList_DB.h"
#import "ChatBoxVC.h"
#import "NewInstanceNsUserDefault.h"
#import "ExpendObjectClass.h"
#import "SBJsonWriter.h"
#import "ReadUnreadService.h"
#import "LogInVC.h"
@interface ChatRoomsVC ()

@end

@implementation ChatRoomsVC
{
    UITextView *textView;
    NSString *defaultTextViewText;
    NetworkHelper *networkHelper;
    LoadingView *loadingView;
//    NSMutableArray *chatHistoryArray;
    NSString *userId;
    NSString *isFromStr;
    UITextView *acceptTextView;
    NSIndexPath *pathToLastRow;
    CGRect viewFrame;
    CGFloat yorigin;
    CGFloat totalViewHeight;
    UISearchBar *searchBar;
    bool searchBarKeyboardShowFlag;
    NSMutableArray *originalChatHistoryArray;
    NSMutableArray *searchTextArray;
}
@synthesize headerView;
@synthesize popupTextView;
@synthesize nameLbltext;
@synthesize acceptButtonOutlet;
@synthesize chatStatus;
@synthesize withChatPersonName;
@synthesize chatThreadId;
@synthesize chatRoomTableView;
@synthesize subject;
@synthesize bottomView;
@synthesize chatHistoryArray;
@synthesize remarkView;
- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationController.navigationBar.translucent = NO;
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    NSLog(@"Navigation Bar height : %f",navBarHeight);
    CGFloat statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size.height;
    NSLog(@"statusBarSize Bar height : %f",statusBarSize);
     yorigin = navBarHeight +statusBarSize;
     totalViewHeight = [[UIApplication sharedApplication].keyWindow bounds].size.height;
    if (isiPhoneXSMAX) {
        self.view.frame = CGRectMake(0, yorigin, 414, totalViewHeight-yorigin);
        viewFrame = CGRectMake(0, yorigin, 414, totalViewHeight);
    }
    else if(isiPhoneXR) {
        self.view.frame = CGRectMake(0, yorigin, 414, totalViewHeight-yorigin);
        viewFrame =CGRectMake(0, yorigin, 414, totalViewHeight);
    }
    
    else if(isiPhoneXS) {
        self.view.frame = CGRectMake(0, yorigin, 375, totalViewHeight-yorigin);
        viewFrame =CGRectMake(0, yorigin, 375, totalViewHeight);
    }
    else if(isiPhone10) {
        self.view.frame = CGRectMake(0, yorigin, 375, totalViewHeight-yorigin);
        viewFrame =CGRectMake(0, yorigin, 375, totalViewHeight);
    }
    
    else if(isiPhone6Plus) {
        self.view.frame = CGRectMake(0, yorigin, 414, totalViewHeight-yorigin);
        viewFrame =CGRectMake(0, yorigin, 414, totalViewHeight);
    }
    else if(isiPhone6) {
        self.view.frame = CGRectMake(0, yorigin, 375, totalViewHeight-yorigin);
        viewFrame =CGRectMake(0, yorigin, 375, totalViewHeight);
    } else if(isiPhone5) {
        self.view.frame = CGRectMake(0, yorigin, 320, totalViewHeight-yorigin);
        viewFrame =CGRectMake(0, yorigin, 320, totalViewHeight);
    } else {
        // 0, 64, 320, 416
        self.view.frame = CGRectMake(0, yorigin, 320, totalViewHeight-yorigin);
        viewFrame =CGRectMake(0, yorigin, 320, totalViewHeight);
    }
    [self drawHeaderItem];
     [self initializeView];
    // Do any additional setup after loading the view from its nib.
}
-(void)autoLayoutIphoneMax
{
    self.headerView.frame =CGRectMake(self.headerView.frame.origin.x, 0, self.headerView.frame.size.width, self.headerView.frame.size.height);
    bottomView.frame = CGRectMake(bottomView.frame.origin.x, self.view.frame.size.height-bottomView.frame.size.height, bottomView.frame.size.width, bottomView.frame.size.height);
    self.chatRoomTableView.frame = CGRectMake(self.chatRoomTableView.frame.origin.x, self.chatRoomTableView.frame.origin.y, self.chatRoomTableView.frame.size.width, self.view.frame.size.height-(self.headerView.frame.size.height+self.bottomView.frame.size.height));
    _acceptButtonPopUpView.frame = self.view.frame;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self scrollToBottom];
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
   
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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
-(void)initializeView
{
    [LayoutClass buttonLayout:self.acceptButtonOutlet forFontWeight:UIFontWeightBold];
    NSString *acceptButton = [[NSUserDefaults standardUserDefaults] valueForKey:@"Accept_Chat_Button"];
    
    if ([acceptButton isEqualToString:@"NO"]) {
        self.acceptButtonOutlet.userInteractionEnabled = NO;
        self.acceptButtonOutlet.hidden  =YES;
    }
    [LayoutClass setLayoutForIPhone6:self.headerView];
    [LayoutClass textviewLayout:self.popupTextView forFontWeight:UIFontWeightRegular];
     [LayoutClass textviewLayout:self.remarkView forFontWeight:UIFontWeightRegular];
     [LayoutClass labelLayout:self.popupSubjectLbl forFontWeight:UIFontWeightMedium];
    [LayoutClass buttonLayout:self.popupAcceptButtonOulate forFontWeight:UIFontWeightBold];
    [LayoutClass setLayoutForIPhone6:self.acceptButtonPopUpView];
     [LayoutClass setLayoutForIPhone6:self.mainPopView];
    [LayoutClass setLayoutForIPhone6:self.borderLineVIew];
    [LayoutClass setLayoutForIPhone6:self.lineView1];
    [LayoutClass setLayoutForIPhone6:self.lineView2];
    [LayoutClass labelLayout:self.nameLbl forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.subjectLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass setLayoutForIPhone6:self.chatRoomTableView];
    [LayoutClass setLayoutForIPhone6:self.bottomView];
    
    remarkView.layer.borderColor =[UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1.0].CGColor;
    remarkView.layer.borderWidth = 1.0;
    remarkView.layer.cornerRadius = 5.0;
    popupTextView.layer.borderColor = [UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1.0].CGColor;
    popupTextView.layer.borderWidth = 1.0;
    popupTextView.layer.cornerRadius = 5.0;

    
    self.popupTextView.delegate = self;
    self.remarkView.delegate = self;
    self.remarkView.text = @"Remarks";
    chatRoomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    chatRoomTableView.bounces = NO;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [chatRoomTableView addGestureRecognizer:gestureRecognizer];
    [self setHeaderDetailsData];
    
    /// add search controller
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(12, 8, (self.acceptButtonOutlet.frame.size.width+self.acceptButtonOutlet.frame.origin.x)-12, 44*deviceHeightRation)];
    searchBar.delegate = self;
    [searchBar setPlaceholder:@"Search"];
    [searchBar setReturnKeyType:UIReturnKeyDone];
    searchBar.enablesReturnKeyAutomatically = NO;
    searchBar.tag= 13;
    [self.headerView addSubview:searchBar];
    
     if (@available(iOS 13.0, *)) {
                     [searchBar setBackgroundColor:[UIColor clearColor]];
                     [searchBar setBackgroundImage:[UIImage new]];
                     [searchBar setTranslucent:YES];
                     searchBar.searchTextField.borderStyle = UITextBorderStyleRoundedRect;
                     searchBar.searchTextField.layer.masksToBounds=YES;
                     searchBar.searchTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
                     searchBar.searchTextField.layer.cornerRadius=5.0f;
                     searchBar.searchTextField.layer.borderWidth= 1.0f;
       }
       else
       {
           for (id subview in [[searchBar.subviews lastObject] subviews]) {
           if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
               [subview removeFromSuperview];
           }
           
           if ([subview isKindOfClass:[UITextField class]])
           {
               UITextField *textFieldObject = (UITextField *)subview;
               textFieldObject.borderStyle = UITextBorderStyleRoundedRect;
               textFieldObject.layer.masksToBounds=YES;
               textFieldObject.layer.borderColor=[[UIColor lightGrayColor]CGColor];
               textFieldObject.layer.cornerRadius=5.0f;
               textFieldObject.layer.borderWidth= 1.0f;
               break;
           }
               
           }
       }
}
-(void)setHeaderDetailsData
{
    NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
    userId =[chatPersonUserID stringByAppendingString:@"@employee"];
    self.nameLbl.text = nameLbltext;
    self.subjectLbl.text = subject;
    
    [self autoLayoutIphoneMax];
    [self createView];
    [self chatHistory];
    [self unreadMessageNetworkCall];
}
-(void)unreadMessageNetworkCall
{
     NSMutableArray *sendMessageIdsArray = [[NSMutableArray alloc]init];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [ChatHistory_DB createInstance : @"ChatHistory_DB_STORAGE" : true :[chatThreadId integerValue]];
        ChatHistory_DB *chatHistory_DBStorage = [ChatHistory_DB getInstance];
        NSMutableArray *unreadMessageIdArray = [chatHistory_DBStorage getRecentUnreadMessage:@"False"];
        if (unreadMessageIdArray.count>0) {
            
            for (int i=0; i<unreadMessageIdArray.count; i++) {
                ChatHistory_Object *obj = (ChatHistory_Object*) [unreadMessageIdArray objectAtIndex:i];
                [sendMessageIdsArray addObject:[NSString stringWithFormat:@"%d",obj.messageId]];
                //for update status of unread messages
                ChatHistory_Object* chatHistory_Object = [[ChatHistory_Object alloc] init];
                chatHistory_Object.chatThreadId = obj.chatThreadId;
                chatHistory_Object.messageId    = obj.messageId;
                [chatHistory_DBStorage updateUnreadMessageStatus:chatHistory_Object];
            }
        }
    });

        dispatch_async(dispatch_get_main_queue(), ^{
            [ChatThreadList_DB createInstance : @"ChatThread_DB_STORAGE" : true];
            ChatThreadList_DB *chatThreadListStorage = [ChatThreadList_DB getInstance];
            ChatThreadList_Object* chatThreadList_Object = [[ChatThreadList_Object alloc] init];
            chatThreadList_Object.chatThreadId =[chatThreadId integerValue] ;
            [chatThreadListStorage updateUnreadThread:chatThreadList_Object :0];
        });
        
       
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
                           NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
                           NSMutableDictionary *chatMessageRqst = [[NSMutableDictionary alloc]init];
                           NSMutableDictionary *reqstData = [[NSMutableDictionary alloc]init];
                           [chatMessageRqst setValue:@"1" forKey:@"requestId"];
                           
                           
                           
                           [reqstData setValue:[chatPersonUserID stringByAppendingString:@"@employee"] forKey:@"userId"];
                           [reqstData setValue:[[clientVariables.CLIENT_USER_LOGIN deviceInfoMap] valueForKey:@"IMEI"] forKey:@"deviceId"];
                           [reqstData setValue:XmwcsConst_DEVICE_TYPE_IPHONE forKey:@"osType"];
                           [reqstData setValue:version forKey:@"appVersion"];
                           [reqstData setValue:@"1" forKey:@"apiVersion"];
                           [reqstData setValue:chatThreadId forKey:@"chatThreadId"];
                           [reqstData setObject:sendMessageIdsArray forKey:@"messageIds"];
                           [chatMessageRqst setObject:reqstData forKey:@"requestData"];
                           
                           ReadUnreadService *service = [[ReadUnreadService alloc] initWithPostData:chatMessageRqst withContext:@"messagesUnreadCall"];
                           
                       });
        
        
       
//        networkHelper = [[NetworkHelper alloc]init];
//        NSString * url=XmwcsConst_OPCODE_URL;
//        networkHelper.serviceURLString = @"http://polycab.dotvik.com:8080/PushMessage/api/messagesRead";
//        [networkHelper genericJSONPayloadRequestWith:chatMessageRqst :self :@"messagesUnreadCall"];
//    }
    
   
}
-(void)chatHistory
{
    [ChatHistory_DB createInstance : @"ChatHistory_DB_STORAGE" : true :[chatThreadId integerValue]];
    ChatHistory_DB *chatHistory_DBStorage = [ChatHistory_DB getInstance];
    NSMutableArray *chatHistoryStorageData = [chatHistory_DBStorage getRecentDocumentsData : @"False"];
    chatHistoryArray = [[NSMutableArray alloc]init];
    [chatHistoryArray addObjectsFromArray:chatHistoryStorageData];
    
    NSString *first_time_networkcall_check = [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"CHAT_HISTORY_FIRST_TIME_FETCH_%@",chatThreadId]];
    if (chatHistoryArray.count!=0 && [first_time_networkcall_check isEqualToString:@"YES"] ) {
        // show loacl save data
         originalChatHistoryArray = [[NSMutableArray alloc]init];
        [originalChatHistoryArray addObjectsFromArray:chatHistoryArray];
        
        
        self.popupSubjectLbl.text  =subject;
        
        NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
        
        NSString *ownUserId = chatPersonUserID;

        
        for (  NSInteger i = chatHistoryArray.count - 1; i>=0; i--) {
            ChatHistory_Object *obj = (ChatHistory_Object *)[chatHistoryArray objectAtIndex:i];
             NSArray *array = [obj.from componentsSeparatedByString:@"@"];
            if ([[array objectAtIndex:0] isEqualToString:ownUserId]) {
                
                //  Base64 string to original string
                NSData *base64Data = [[NSData alloc] initWithBase64EncodedString:obj.message options:NSDataBase64DecodingIgnoreUnknownCharacters];
                NSString *originalString =[[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
                
                NSLog(@"Result: %@",originalString);
                
                self.popupTextView.text  = originalString;
                break;
            }
            
        }
       
       
       
    }
    else{
        
     NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
        
    loadingView = [LoadingView loadingViewInView:self.view];
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSMutableDictionary *chatMessageRqst = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *reqstData = [[NSMutableDictionary alloc]init];
    [chatMessageRqst setValue:@"1" forKey:@"requestId"];
    [reqstData setValue:[chatPersonUserID stringByAppendingString:@"@employee"] forKey:@"userId"];
    [reqstData setValue:[[clientVariables.CLIENT_USER_LOGIN deviceInfoMap] valueForKey:@"IMEI"] forKey:@"deviceId"];
    [reqstData setValue:XmwcsConst_DEVICE_TYPE_IPHONE forKey:@"osType"];
    [reqstData setValue:version forKey:@"appVersion"];
    [reqstData setValue:@"1" forKey:@"apiVersion"];
    [reqstData setValue:chatThreadId forKey:@"chatThreadId"];
    [chatMessageRqst setObject:reqstData forKey:@"requestData"];
    
    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=[XmwcsConst_CHAT_URL stringByAppendingString:@"PushMessage/api/messages"];
    networkHelper.serviceURLString = url;
//    networkHelper.serviceURLString = @"http://polycab.dotvik.com:8080/PushMessage/api/messages";
    [networkHelper genericJSONPayloadRequestWith:chatMessageRqst :self :@"chatMessageRqst"];
}
}

-(void)createView
{

        UIView *borderLine =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, bottomView.frame.size.width, 5)];
        borderLine.backgroundColor = [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1.0];
        [bottomView addSubview:borderLine];
        
        textView = [[UITextView alloc]initWithFrame:CGRectMake(15, 6, bottomView.frame.size.width-50, 50)];
        textView.returnKeyType = UIReturnKeyDefault;
        textView.keyboardType = UIKeyboardTypeDefault;
        textView.autocapitalizationType = UITextAutocapitalizationTypeWords;
        textView.autocorrectionType = UITextAutocorrectionTypeNo;
        textView.font = [UIFont systemFontOfSize:14.0];
        textView.textColor =[UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
        textView.text = @"Type your message here.";
        defaultTextViewText =@"Type your message here.";
        textView.delegate = self;
        [bottomView addSubview:textView];
        
        UIButton *sendButton = [[UIButton alloc]initWithFrame:CGRectMake(bottomView.frame.size.width-35,12, 30, 35)];
        [sendButton setBackgroundImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
        sendButton.contentMode = UIViewContentModeScaleAspectFit;
        [sendButton addTarget:self action:@selector(sendButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:sendButton];
        [self.view addSubview:bottomView];
    
    if ([chatStatus isEqualToString:@"Accept"] || [chatStatus isEqualToString:@"Close"]) {
//          [acceptButtonOutlet removeFromSuperview];
        acceptButtonOutlet.hidden = YES;
        acceptButtonOutlet.userInteractionEnabled = NO;
    }
//    }
    


}
- (IBAction)popupAcceptButtonHandler:(id)sender {
    
    NSLog(@"accept Button Clicked");
    
     NSString* messageTextString = [popupTextView.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* remarkTextString = [remarkView.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (messageTextString.length<0 || [messageTextString isEqualToString:@""] || [messageTextString isKindOfClass:[NSNull class]] || [messageTextString isEqualToString:defaultTextViewText] || [messageTextString isEqualToString:@"Remarks"])
    {
        UIAlertView *emptyMessage = [[UIAlertView alloc]initWithTitle:@"" message:@"empty message" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [emptyMessage show];
    }
   
    else{
    
        if ( [remarkTextString isEqualToString:defaultTextViewText] || [remarkTextString isEqualToString:@"Remarks"])
        {
            remarkView.text =@"";
        }
        
    loadingView = [LoadingView loadingViewInView:self.view];
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    
    NSMutableDictionary *acceptMessageData = [[NSMutableDictionary alloc]init];
    
    [acceptMessageData setValue:@"1" forKey:@"requestId"];
    NSMutableDictionary *requestData = [[NSMutableDictionary alloc]init];
    [requestData setObject:chatThreadId forKey:@"chatThreadId"];
    [requestData setObject:@"Accept" forKey:@"status"];
    [requestData setObject:popupTextView.text forKey:@"closingMessage"];
     [requestData setObject:remarkView.text forKey:@"closingRemark"];
    [acceptMessageData setObject:requestData forKey:@"requestData"];
    
    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=[XmwcsConst_CHAT_URL stringByAppendingString:@"PushMessage/api/updateChatThreadStatus"];
        networkHelper.serviceURLString = url;
//    networkHelper.serviceURLString = @"http://polycab.dotvik.com:8080/PushMessage/api/updateChatThreadStatus";
    [networkHelper genericJSONPayloadRequestWith:acceptMessageData :self :@"acceptMessageData"];
    }
}
- (IBAction)acceptButtonHandler:(id)sender {
    bottomView.hidden = YES;
    self.acceptButtonPopUpView.hidden  = NO;
    
}

-(void)sendButtonHandler:(id)sender
{
    
     NSString* messageTextString = [textView.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (messageTextString.length<0 || [messageTextString isEqualToString:@""] || [messageTextString isKindOfClass:[NSNull class]] || [messageTextString isEqualToString:defaultTextViewText])
    {
        UIAlertView *emptyMessage = [[UIAlertView alloc]initWithTitle:@"" message:@"empty message" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [emptyMessage show];
    }
    else{
    
    NSLog(@"Send Button Clicked");
    
    loadingView = [LoadingView loadingViewInView:self.view];
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
 
    NSMutableDictionary *sendMessageData = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *messageData = [[NSMutableDictionary alloc]init];
    
    [sendMessageData setValue:@"" forKey:@"requestId"];
    NSMutableDictionary *requestData = [[NSMutableDictionary alloc]init];
    [requestData setObject:chatThreadId forKey:@"chatThread"];
        
         NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
        
    [requestData setObject:[chatPersonUserID stringByAppendingString:@"@employee"] forKey:@"from"];
    [requestData setObject:withChatPersonName forKey:@"to"];
    [requestData setObject:textView.text forKey:@"message"];
    [requestData setObject:@"Text" forKey:@"messageType"];
    [requestData setObject:@"" forKey:@"hiddenMessage"];
    [requestData setObject:[[clientVariables.CLIENT_USER_LOGIN deviceInfoMap] valueForKey:@"IMEI"] forKey:@"deviceId"];
    [requestData setObject:XmwcsConst_DEVICE_TYPE_IPHONE forKey:@"osType"];
    [requestData setObject:version forKey:@"appVersion"];
    [requestData setObject:@"1" forKey:@"apiVersion"];
    
    [sendMessageData setObject:requestData forKey:@"requestData"];

    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=[XmwcsConst_CHAT_URL stringByAppendingString:@"PushMessage/api/pushMessage"];
        networkHelper.serviceURLString = url;
//    networkHelper.serviceURLString = @"http://polycab.dotvik.com:8080/PushMessage/api/pushMessage";
    [networkHelper genericJSONPayloadRequestWith:sendMessageData :self :@"sendMessageData"];
    
    }
    
}
-(NSMutableArray*)groupData :(NSArray*)dataArray
{
    NSMutableArray*distinctName = [[NSMutableArray alloc]init];
    for (int i=0; i<dataArray.count; i++) {
        ChatThreadList_Object *obj = (ChatThreadList_Object*) [dataArray objectAtIndex:i];
        
        if (![distinctName  containsObject:obj.displayName]) {
            [distinctName addObject:obj.displayName];
        }
    }
    
    NSMutableArray *groupObject = [[NSMutableArray alloc]init];
    for (int i=0; i<distinctName.count; i++) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        ExpendObjectClass * expendObj = [[ExpendObjectClass alloc]init];
        for (int j=0; j<dataArray.count; j++) {
            ChatThreadList_Object *obj = (ChatThreadList_Object*) [dataArray objectAtIndex:j];
            if ([obj.displayName isEqualToString:[distinctName objectAtIndex:i]] ) {
                [array addObject:obj];
            }
            
        }
        expendObj.MENU_NAME =[distinctName objectAtIndex:i];
        expendObj.childCategories = array;
        [groupObject addObject:expendObj];
    }
    return groupObject;
}

- (void) backHandler : (id) sender
{
    UIViewController *root;
    root = [[[[UIApplication sharedApplication]windows]objectAtIndex:0]rootViewController];
    SWRevealViewController *reveal = (SWRevealViewController*)root;
    UINavigationController *check =(UINavigationController*)reveal.frontViewController;
    NSArray* viewsList = check.viewControllers;
    UIViewController *checkView = (UIViewController *) [viewsList objectAtIndex:viewsList.count - 2];
    if ([checkView isKindOfClass:[ChatBoxVC class]]) {
        ChatBoxVC *vc  = (ChatBoxVC *) checkView;
        [ChatThreadList_DB createInstance : @"ChatThread_DB_STORAGE" : true];
        ChatThreadList_DB *chatThreadListStorage = [ChatThreadList_DB getInstance];
        NSMutableArray *chatThreadListStorageData = [chatThreadListStorage getRecentDocumentsData : @"False"];
        vc.chatThreadDict = [[NSMutableArray alloc]init];
        [vc.chatThreadDict addObjectsFromArray:[self groupData:chatThreadListStorageData]];
        [vc.threadListTableView reloadData];
    }
    
    ChatRoomPushNotifiactionFlag = NO;
    ChatBoxPushNotifiactionFlag = NO;
    
    [ [self navigationController]  popViewControllerAnimated:YES];
    
}
#pragma -mark Network Call Response methods
- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    [loadingView removeView];
    if ([callName isEqualToString:@"chatMessageRqst"]) {
        
        if ([[respondedObject objectForKey:@"status"] boolValue] == YES) {
          
            chatHistoryArray = [[NSMutableArray alloc]init];
            [chatHistoryArray addObjectsFromArray:[[respondedObject valueForKey:@"responseData"] valueForKey:@"list"]];
            //[chatRoomTableView reloadData];
            
            
            self.popupSubjectLbl.text  =subject;
            
            NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];

            NSString *ownUserId = chatPersonUserID;
            for (  NSInteger i = chatHistoryArray.count - 1; i>=0; i--) {
                NSMutableArray *obj = [chatHistoryArray objectAtIndex:i];
                NSArray *array = [[obj valueForKey:@"from"] componentsSeparatedByString:@"@"];
                if ([[array objectAtIndex:0] isEqualToString:ownUserId]) {
                    self.popupTextView.text  = [obj valueForKey:@"message"] ;
                    break;
                }
                
            }
            [ChatHistory_DB createInstance : @"ChatHistory_DB_STORAGE" : true :[chatThreadId integerValue]];
            ChatHistory_DB *chatHistory_DBStorage = [ChatHistory_DB getInstance];
            [chatHistory_DBStorage dropRows:@"ChatHistory_DB_STORAGE"];
           
             //[chatHistory_DBStorage dropTable:@"ChatHistory_DB_STORAGE"];
            for(int i =0; i<[chatHistoryArray count];i++)
            {
                NSString *messageString = [[chatHistoryArray objectAtIndex:i] valueForKey:@"message"];
                NSData *messageData = [messageString dataUsingEncoding:NSUTF8StringEncoding];
                NSString *base64MessageString = [messageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                
                ChatHistory_Object* chatHistory_Object = [[ChatHistory_Object alloc] init];
                chatHistory_Object.chatThreadId =  [[[chatHistoryArray objectAtIndex:i] valueForKey:@"chatThreadId"] integerValue] ;
                chatHistory_Object.from =   [ NSString stringWithFormat:@"%@", [[chatHistoryArray objectAtIndex:i] valueForKey:@"from"]];
                chatHistory_Object.to =  [ NSString stringWithFormat:@"%@",[[chatHistoryArray objectAtIndex:i] valueForKey:@"to"]];
                chatHistory_Object.message =base64MessageString;
                chatHistory_Object.messageDate =[ NSString stringWithFormat:@"%@",[[chatHistoryArray objectAtIndex:i] valueForKey:@"messageDate"]];
                chatHistory_Object.messageType =[ NSString stringWithFormat:@"%@",[[chatHistoryArray objectAtIndex:i] valueForKey:@"messageType"]];
                
                
                
                chatHistory_Object.messageId =  [[[chatHistoryArray objectAtIndex:i] valueForKey:@"id"] integerValue] ;
                BOOL messageReadStatus = [[[chatHistoryArray objectAtIndex:i] valueForKey:@"messageRead"] boolValue];
                chatHistory_Object.messageRead =[ NSString stringWithFormat:@"%@",messageReadStatus ? @"YES" : @"NO"];
                
                [chatHistory_DBStorage insertDoc:chatHistory_Object];
                
            }
            NSMutableArray *chatHistoryStorageData = [chatHistory_DBStorage getRecentDocumentsData : @"True"];
            chatHistoryArray = [[NSMutableArray alloc]init];
            [chatHistoryArray addObjectsFromArray:chatHistoryStorageData];
            originalChatHistoryArray = [[NSMutableArray alloc]init];
            [originalChatHistoryArray addObjectsFromArray:chatHistoryArray];
            [chatRoomTableView reloadData];
            [chatRoomTableView layoutIfNeeded];
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow: ([chatRoomTableView numberOfRowsInSection:([chatRoomTableView numberOfSections]-1)]-1) inSection: ([chatRoomTableView numberOfSections]-1)];
            [chatRoomTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            

       
            
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:[NSString stringWithFormat:@"CHAT_HISTORY_FIRST_TIME_FETCH_%@",[[chatHistoryArray objectAtIndex:0] valueForKey:@"chatThreadId"]]];
        
          [[NSUserDefaults standardUserDefaults] synchronize];
            [self unreadMessageNetworkCall];
        }
        else
        {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"" message:[[respondedObject valueForKey:@"errorData"] valueForKey:@"displayMessage"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
            [myAlertView show];
        }
    }
   // sendMessageData
    else if ([callName isEqualToString:@"sendMessageData"])
    {
        if ([[respondedObject objectForKey:@"status"] boolValue] == YES) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setDictionary:[respondedObject objectForKey:@"responseData"]];

            NSString * timeStampValue = [[NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]stringByAppendingString:@"000"];
            NSLog(@"Time Stamp Value == %@", timeStampValue);
            NSString *messageString = textView.text;
            NSData *messageData = [messageString dataUsingEncoding:NSUTF8StringEncoding];
            NSString *base64MessageString = [messageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            
            [ChatHistory_DB createInstance : @"ChatHistory_DB_STORAGE" : true :[[dict valueForKey:@"chatThreadId"] integerValue]];
            ChatHistory_DB *chatHistory_DBStorage = [ChatHistory_DB getInstance];
            
            ChatHistory_Object* chatHistory_Object = [[ChatHistory_Object alloc] init];
            chatHistory_Object.chatThreadId =  [[dict valueForKey:@"chatThreadId"] integerValue] ;
            chatHistory_Object.from =   [ NSString stringWithFormat:@"%@", [dict valueForKey:@"from"]];
            chatHistory_Object.to =  [ NSString stringWithFormat:@"%@",[dict valueForKey:@"to"]];
            chatHistory_Object.message =base64MessageString;
            chatHistory_Object.messageDate =[ NSString stringWithFormat:@"%@",timeStampValue];
            chatHistory_Object.messageType =@"TEXT";
            chatHistory_Object.messageId =[[dict valueForKey:@"serverMessageId"] integerValue] ;
            chatHistory_Object.messageRead =@"YES";
            [chatHistory_DBStorage insertDoc:chatHistory_Object];
            
            NSMutableArray *chatHistoryStorageData = [chatHistory_DBStorage getRecentDocumentsData : @"False"];
            chatHistoryArray = [[NSMutableArray alloc]init];
            [chatHistoryArray addObjectsFromArray:chatHistoryStorageData];
            originalChatHistoryArray = [[NSMutableArray alloc]init];
            [originalChatHistoryArray addObjectsFromArray:chatHistoryArray];
            [chatRoomTableView reloadData];
            [chatRoomTableView layoutIfNeeded];
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow: ([chatRoomTableView numberOfRowsInSection:([chatRoomTableView numberOfSections]-1)]-1) inSection: ([chatRoomTableView numberOfSections]-1)];
            [chatRoomTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            
            
            self.popupTextView.text =textView.text;
            [textView resignFirstResponder];
            textView.text = defaultTextViewText;
            
            [ChatThreadList_DB createInstance : @"ChatThread_DB_STORAGE" : true];
            ChatThreadList_DB *chatThreadListStorage = [ChatThreadList_DB getInstance];
            ChatThreadList_Object* chatThreadList_Object = [[ChatThreadList_Object alloc] init];
            chatThreadList_Object.chatThreadId =  chatHistory_Object.chatThreadId;
            chatThreadList_Object.lastMessageOn = [ NSString stringWithFormat:@"%@",timeStampValue];
            [chatThreadListStorage updateDocLastMessageTime:chatThreadList_Object];
            
            
            //Accept Talk Code
            
            if ([chatStatus isEqualToString:@"Accept"] || [chatStatus isEqualToString:@"Close"]) {
                acceptButtonOutlet.hidden = NO;
                acceptButtonOutlet.userInteractionEnabled = YES;
                ChatThreadList_Object* chatThreadList_ObjectForAccept = [[ChatThreadList_Object alloc] init];
                chatThreadList_ObjectForAccept.chatThreadId =[chatThreadId integerValue] ;
                chatThreadList_ObjectForAccept.status =@"Accept-Talk";
                [chatThreadListStorage updateDoc:chatThreadList_ObjectForAccept];
            }
            
          
            
            
            UIViewController *root;
            root = [[[[UIApplication sharedApplication]windows]objectAtIndex:0]rootViewController];
            SWRevealViewController *reveal = (SWRevealViewController*)root;
            UINavigationController *check =(UINavigationController*)reveal.frontViewController;
            NSArray* viewsList = check.viewControllers;
            UIViewController *checkView = (UIViewController *) [viewsList objectAtIndex:viewsList.count - 2];
            NSMutableArray *chatThreadListStorageData = [chatThreadListStorage getRecentDocumentsData : @"False"];
            ChatBoxVC *vc =  (ChatBoxVC*) checkView;
            vc.chatThreadDict = chatThreadListStorageData;
            [self scrollToBottom];
//              [self performSelector:@selector(scrollToBottom) withObject:nil afterDelay:0.0];
            
        }
       
        else
        {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"" message:[[respondedObject valueForKey:@"errorData"] valueForKey:@"displayMessage"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
            [myAlertView show];
        }
    }
    

    
     else if ([callName isEqualToString:@"acceptMessageData"])
     {
        if ([[respondedObject objectForKey:@"status"] boolValue] == true) {

            self.acceptButtonPopUpView.hidden  = YES;
            [ChatThreadList_DB createInstance : @"ChatThread_DB_STORAGE" : true];
            ChatThreadList_DB *chatThreadListStorage = [ChatThreadList_DB getInstance];


            ChatThreadList_Object* chatThreadList_Object = [[ChatThreadList_Object alloc] init];
            chatThreadList_Object.chatThreadId =[chatThreadId integerValue] ;
            chatThreadList_Object.status =@"Accept";
            [chatThreadListStorage updateDoc:chatThreadList_Object];
            ChatBoxVC *chatVC = [[ChatBoxVC alloc]init];
            
            NSMutableArray *viewControllersArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            NSMutableArray *dummyArray = [[NSMutableArray alloc]init];
            [dummyArray addObjectsFromArray:viewControllersArray];
            [dummyArray removeObjectAtIndex:dummyArray.count -1];// this remove for topup chatroomvc
            [dummyArray removeObjectAtIndex:dummyArray.count -1];// this remove for topup previous chatboxvc
            [dummyArray addObject:chatVC];
            [[self navigationController] setViewControllers:dummyArray animated:YES];

            [self scrollToBottom];
//               [self performSelector:@selector(scrollToBottom) withObject:nil afterDelay:0.0];
        }
        else
        {
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"" message:[[respondedObject valueForKey:@"errorData"] valueForKey:@"displayMessage"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];

         }
    }
    
    if ([callName isEqualToString:@"messagesUnreadCall"]) {
        
        if ([[respondedObject objectForKey:@"status"] boolValue] == YES) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setDictionary:[respondedObject objectForKey:@"responseData"]];
            NSMutableArray *updated = [dict valueForKey:@"updated"];
            NSMutableArray *failedToUpdate = [dict valueForKey:@"failedToUpdate"];
            for ( int i=0; i<updated.count; i++) {
                [ChatHistory_DB createInstance : @"ChatHistory_DB_STORAGE" : true :[[dict valueForKey:@"chatThreadId"] integerValue]];
                ChatHistory_DB *chatHistory_DBStorage = [ChatHistory_DB getInstance];
                
                ChatHistory_Object* chatHistory_Object = [[ChatHistory_Object alloc] init];
                chatHistory_Object.chatThreadId = [[dict valueForKey:@"chatThreadId"] integerValue] ;
                chatHistory_Object.messageId    =  [[updated objectAtIndex:i] integerValue];
                [chatHistory_DBStorage updateUnreadMessageStatus:chatHistory_Object];
            }
            if (failedToUpdate.count>0) {

            }
            else
            {
            
                [ChatThreadList_DB createInstance : @"ChatThread_DB_STORAGE" : true];
                ChatThreadList_DB *chatThreadListStorage = [ChatThreadList_DB getInstance];
                ChatThreadList_Object* chatThreadList_Object = [[ChatThreadList_Object alloc] init];
                chatThreadList_Object.chatThreadId =[[dict valueForKey:@"chatThreadId"] integerValue] ;
                [chatThreadListStorage updateUnreadThread:chatThreadList_Object :0];
//                [chatThreadListStorage updateUnreadThread:chatThreadList_Object];
                
                UIViewController *root;
                root = [[[[UIApplication sharedApplication]windows]objectAtIndex:0]rootViewController];
                SWRevealViewController *reveal = (SWRevealViewController*)root;
                UINavigationController *check =(UINavigationController*)reveal.frontViewController;
                NSArray* viewsList = check.viewControllers;
                if (viewsList.count==3) {
                    UIViewController *checkView = (UIViewController *) [viewsList objectAtIndex:viewsList.count - 2];
                    NSMutableArray *chatThreadListStorageData = [chatThreadListStorage getRecentDocumentsData : @"False"];
                    if ([checkView isKindOfClass:[ChatBoxVC class]]) {
                        ChatBoxVC *vc =  (ChatBoxVC*) checkView;
                        vc.chatThreadDict = chatThreadListStorageData;
                    }
                }
                
               
                
            }
        }

    }
    
}
- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
    
}
#pragma -mark time


#pragma -mark textview Delagate

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    if (textView.tag==10||textView.tag==11) {
        acceptTextView = textView;
    }
    if ([textView.text isEqualToString:defaultTextViewText]) {
        textView.text = @"";
    }
    if ([textView.text isEqualToString:@"Remarks"]) {
        textView.text = @"";
    }
    textView.textColor = [UIColor blackColor];
    [textView resignFirstResponder];
    
    return YES;
}
-(void) textViewDidChange:(UITextView *)textView {
    
    if(textView.text.length == 0) {
        textView.textColor = [UIColor lightGrayColor];
        textView.text = @"Type your message here.";
        [textView resignFirstResponder];
    }
}

-(void) textViewShouldEndEditing:(UITextView *)textView {
    
    if (textView.tag==10) {
        acceptTextView = nil;
    }
    if(textView.text.length == 0) {
        textView.textColor = [UIColor lightGrayColor];
        textView.text = @"Type your message here.";
        [textView resignFirstResponder];
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.acceptButtonPopUpView.hidden = YES;
    bottomView.hidden = NO;
    [popupTextView resignFirstResponder];
    [remarkView resignFirstResponder];
    [searchBar resignFirstResponder];
}
#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification
{
    if (acceptTextView!=nil) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect f = self.view.frame;
            f.origin.y = -120;
            self.view.frame = f;
        }];
    }
  
    else if (searchBarKeyboardShowFlag == YES)
    {
        // do nothing 
    }
    else{
        CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        [UIView animateWithDuration:0.3 animations:^{
            CGRect f = self.view.frame;
            f.origin.y = -keyboardSize.height+yorigin;
            self.view.frame = f;
        }];
    }
}

-(void)keyboardWillHide:(NSNotification *)notification
{
   
        [UIView animateWithDuration:0.3 animations:^{
            CGRect f = self.view.frame;
            f.origin.y = yorigin;
            self.view.frame = f;
        }];
    
}

#pragma mark-Tableview Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    return view;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [chatHistoryArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier = @"messagingCell";
    PTSMessagingCell * cell = (PTSMessagingCell*) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
//    if (cell == nil) {
        cell = [[PTSMessagingCell alloc] initMessagingCellWithReuseIdentifier:cellIdentifier];
//    }
    
    [self configureCell:cell atIndexPath:indexPath];
    NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
    
    // Then grab the number of rows in the last section
    NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex] - 1;
    
    // Now just construct the index path
    pathToLastRow = [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
  
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    CGSize messageSize;
    if(chatHistoryArray.count>0)
    { ChatHistory_Object *obj = (ChatHistory_Object *)[chatHistoryArray objectAtIndex:indexPath.row];
       
        NSString *message= obj.message;
        
        //  Base64 string to original string
        NSData *base64Data = [[NSData alloc] initWithBase64EncodedString:message options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSString *originalMessage =[[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
        
        NSLog(@"Result: %@",originalMessage);
        if(originalMessage!=nil)
        {
            messageSize = [PTSMessagingCell messageSize:originalMessage];
            return messageSize.height + 2*[PTSMessagingCell textMarginVertical] + 40.0f;
        }
    }

    return messageSize.height + 2*[PTSMessagingCell textMarginVertical] + 40.0f;

}
#pragma  PTSMessaging Configure Method
-(void)configureCell:(id)cell atIndexPath:(NSIndexPath *)indexPath {
    
    PTSMessagingCell* ccell = (PTSMessagingCell*)cell;
    ccell.backgroundColor = [UIColor clearColor];
    
    ChatHistory_Object *obj = (ChatHistory_Object *)[chatHistoryArray objectAtIndex:indexPath.row];
    
    
    
    NSString *senderId=obj.from;
    //NSString *isFromStr=[dict objectForKey:@"to"];
    double timeStamp = [obj.messageDate doubleValue];
    NSTimeInterval timeInterval=timeStamp/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"dd LLL,yy HH:mm"];
    NSString *dateString=[dateformatter stringFromDate:date];
    NSString *time=dateString;
    NSString *objString = obj.message;
    
  //  Base64 string to original string
                    NSData *base64Data = [[NSData alloc] initWithBase64EncodedString:objString options:NSDataBase64DecodingIgnoreUnknownCharacters];
                    NSString *originalString =[[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
                    NSLog(@"Result: %@",originalString);
    
    if([senderId isEqualToString:userId]) {
        ccell.sent = NO;
        
        ccell.timeLabel.text = time;
        ccell.messageLabel.text = originalString;
    }
    else {
        ccell.sent = YES;
//        if([isFromStr isEqualToString:userId])
//        {
//        }
//        else
//        {
//        }
       
        ccell.timeLabel.text = time;
        ccell.messageLabel.text = originalString;
    }

}
- (void) hideKeyboard {
    [textView resignFirstResponder];
    [searchBar resignFirstResponder];
    searchBarKeyboardShowFlag =NO;
}
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
}
- (void)scrollToBottom
{
      [chatRoomTableView scrollToRowAtIndexPath:pathToLastRow atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark - searchBar handler
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    searchBarKeyboardShowFlag = NO;
    [searchBar resignFirstResponder];
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBarKeyboardShowFlag =YES;
    return  YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
     NSLog(@"%@",searchText);
    searchTextArray = [[NSMutableArray alloc]init];
    if (searchText.length>0) {
        
        for (int i=0; i<originalChatHistoryArray.count; i++) {
              ChatHistory_Object *obj = (ChatHistory_Object *)[originalChatHistoryArray objectAtIndex:i];
                NSString *objString = obj.message;
                NSData *base64Data = [[NSData alloc] initWithBase64EncodedString:objString options:NSDataBase64DecodingIgnoreUnknownCharacters];
                NSString *message =[[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
                NSLog(@"Result: %@",message);
            
            NSRange nameRange = [message rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (nameRange.location != NSNotFound) {
                [searchTextArray addObject: obj];
            }
            
        }
        chatHistoryArray =[[NSMutableArray alloc]init];
        [chatHistoryArray addObjectsFromArray:searchTextArray];
        [chatRoomTableView reloadData];
    }
    else
    {   chatHistoryArray  = [[NSMutableArray alloc]init];
        [chatHistoryArray addObjectsFromArray:originalChatHistoryArray];
        [chatRoomTableView reloadData];
    }
    
}
@end
