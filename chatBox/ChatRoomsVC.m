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
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawHeaderItem];
     [self initializeView];
    // Do any additional setup after loading the view from its nib.
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
    [LayoutClass textviewLayout:self.popupTextView forFontWeight:UIFontWeightRegular];
     [LayoutClass labelLayout:self.popupSubjectLbl forFontWeight:UIFontWeightMedium];
    [LayoutClass buttonLayout:self.popupAcceptButtonOulate forFontWeight:UIFontWeightBold];
    [LayoutClass setLayoutForIPhone6:self.acceptButtonPopUpView];
    [LayoutClass setLayoutForIPhone6:self.lineView1];
    [LayoutClass setLayoutForIPhone6:self.lineView2];
    [LayoutClass labelLayout:self.nameLbl forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.subjectLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass setLayoutForIPhone6:self.chatRoomTableView];
    [LayoutClass setLayoutForIPhone6:self.bottomView];

    self.popupTextView.delegate = self;
    chatRoomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    chatRoomTableView.bounces = NO;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [chatRoomTableView addGestureRecognizer:gestureRecognizer];
    [self setHeaderDetailsData];
}
-(void)setHeaderDetailsData
{
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    userId =[[clientVariables.CLIENT_USER_LOGIN userName] stringByAppendingString:@"@employee"];
    self.nameLbl.text = nameLbltext;
    self.subjectLbl.text = subject;
    
    
    [self createView];
    [self chatHistory];
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
        ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
        ChatHistory_Object *obj = (ChatHistory_Object *)[chatHistoryArray objectAtIndex:chatHistoryArray.count-1];
        
        self.popupSubjectLbl.text  =subject;
        NSString *ownUserId = [clientVariables.CLIENT_USER_LOGIN userName];
        NSArray *array = [obj.from componentsSeparatedByString:@"@"];
        if ([[array objectAtIndex:0] isEqualToString:ownUserId]) {
           self.popupTextView.text  = obj.message;
        }
       
    }
    else{
    loadingView = [LoadingView loadingViewInView:self.view];
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSMutableDictionary *chatMessageRqst = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *reqstData = [[NSMutableDictionary alloc]init];
    [chatMessageRqst setValue:@"1" forKey:@"requestId"];
    [reqstData setValue:[[clientVariables.CLIENT_USER_LOGIN userName] stringByAppendingString:@"@employee"] forKey:@"userId"];
    [reqstData setValue:[[clientVariables.CLIENT_USER_LOGIN deviceInfoMap] valueForKey:@"IMEI"] forKey:@"deviceId"];
    [reqstData setValue:XmwcsConst_DEVICE_TYPE_IPHONE forKey:@"osType"];
    [reqstData setValue:version forKey:@"appVersion"];
    [reqstData setValue:@"1" forKey:@"apiVersion"];
    [reqstData setValue:chatThreadId forKey:@"chatThreadId"];
    [chatMessageRqst setObject:reqstData forKey:@"requestData"];
    
    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=XmwcsConst_OPCODE_URL;
    networkHelper.serviceURLString = @"http://polycab.dotvik.com:8080/PushMessage/api/messages";
    [networkHelper genericJSONPayloadRequestWith:chatMessageRqst :self :@"chatMessageRqst"];
}
}

-(void)createView
{
    if ([chatStatus isEqualToString:@"Accept"] || [chatStatus isEqualToString:@"Close"]) {
       
        chatRoomTableView.frame = CGRectMake(chatRoomTableView.frame.origin.x, chatRoomTableView.frame.origin.y, chatRoomTableView.frame.size.width, chatRoomTableView.frame.size.height + bottomView.frame.size.height);
         [acceptButtonOutlet removeFromSuperview];
         [bottomView removeFromSuperview];
    }
    else
    {
        UIView *borderLine =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, bottomView.frame.size.width, 5)];
        borderLine.backgroundColor = [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1.0];
        [bottomView addSubview:borderLine];
        
        textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 6, bottomView.frame.size.width-50, 50)];
        textView.returnKeyType = UIReturnKeyDefault;
        textView.autocapitalizationType = UITextAutocapitalizationTypeWords;
        textView.autocorrectionType = UITextAutocorrectionTypeNo;
        textView.font = [UIFont systemFontOfSize:16.0];
        textView.textColor =[UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
        textView.text = @"Type your message here.";
        defaultTextViewText =@"Type your message here.";
        textView.delegate = self;
        [bottomView addSubview:textView];
        
        UIButton *sendButton = [[UIButton alloc]initWithFrame:CGRectMake(bottomView.frame.size.width-50,12, 40, 40)];
        [sendButton setBackgroundImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
        sendButton.contentMode = UIViewContentModeScaleAspectFit;
        [sendButton addTarget:self action:@selector(sendButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:sendButton];
        [self.view addSubview:bottomView];
    }
    


}
- (IBAction)popupAcceptButtonHandler:(id)sender {
    
    NSLog(@"accept Button Clicked");
    
     NSString* messageTextString = [popupTextView.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (messageTextString.length<0 || [messageTextString isEqualToString:@""] || [messageTextString isKindOfClass:[NSNull class]] )
    {
        UIAlertView *emptyMessage = [[UIAlertView alloc]initWithTitle:@"" message:@"empty message" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [emptyMessage show];
    }
    else{
    
    loadingView = [LoadingView loadingViewInView:self.view];
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    
    NSMutableDictionary *acceptMessageData = [[NSMutableDictionary alloc]init];
    
    [acceptMessageData setValue:@"1" forKey:@"requestId"];
    NSMutableDictionary *requestData = [[NSMutableDictionary alloc]init];
    [requestData setObject:chatThreadId forKey:@"chatThreadId"];
    [requestData setObject:@"Accept" forKey:@"status"];
    [requestData setObject:popupTextView.text forKey:@"closingMessage"];
    
    [acceptMessageData setObject:requestData forKey:@"requestData"];
    
    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=XmwcsConst_OPCODE_URL;
    networkHelper.serviceURLString = @"http://polycab.dotvik.com:8080/PushMessage/api/updateChatThreadStatus";
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
    [requestData setObject:[[clientVariables.CLIENT_USER_LOGIN userName] stringByAppendingString:@"@employee"] forKey:@"from"];
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
    NSString * url=XmwcsConst_OPCODE_URL;
    networkHelper.serviceURLString = @"http://polycab.dotvik.com:8080/PushMessage/api/pushMessage";
    [networkHelper genericJSONPayloadRequestWith:sendMessageData :self :@"sendMessageData"];
    
    }
    
}


- (void) backHandler : (id) sender
{
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
            
            ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
            NSMutableArray *obj = [chatHistoryArray objectAtIndex:chatHistoryArray.count-1];
            
            self.popupSubjectLbl.text  =subject;
            NSString *ownUserId = [clientVariables.CLIENT_USER_LOGIN userName];
            NSArray *array = [[obj valueForKey:@"from"] componentsSeparatedByString:@"@"];
            if ([[array objectAtIndex:0] isEqualToString:ownUserId]) {
                self.popupTextView.text  = [obj valueForKey:@"message"] ;
            }
            
        
            
            [ChatHistory_DB createInstance : @"ChatHistory_DB_STORAGE" : true :[chatThreadId integerValue]];
            ChatHistory_DB *chatHistory_DBStorage = [ChatHistory_DB getInstance];
            [chatHistory_DBStorage dropRows:@"ChatHistory_DB_STORAGE"];
           
             //[chatHistory_DBStorage dropTable:@"ChatHistory_DB_STORAGE"];
            for(int i =0; i<[chatHistoryArray count];i++)
            {
                ChatHistory_Object* chatHistory_Object = [[ChatHistory_Object alloc] init];
                chatHistory_Object.chatThreadId =  [[[chatHistoryArray objectAtIndex:i] valueForKey:@"chatThreadId"] integerValue] ;
                chatHistory_Object.from =   [ NSString stringWithFormat:@"%@", [[chatHistoryArray objectAtIndex:i] valueForKey:@"from"]];
                chatHistory_Object.to =  [ NSString stringWithFormat:@"%@",[[chatHistoryArray objectAtIndex:i] valueForKey:@"to"]];
                chatHistory_Object.message =[ NSString stringWithFormat:@"%@",[[chatHistoryArray objectAtIndex:i] valueForKey:@"message"]];
                chatHistory_Object.messageDate =[ NSString stringWithFormat:@"%@",[[chatHistoryArray objectAtIndex:i] valueForKey:@"messageDate"]];
                chatHistory_Object.messageType =[ NSString stringWithFormat:@"%@",[[chatHistoryArray objectAtIndex:i] valueForKey:@"messageType"]];
                
                chatHistory_Object.messageId =  [[[chatHistoryArray objectAtIndex:i] valueForKey:@"id"] integerValue] ;
                [chatHistory_DBStorage insertDoc:chatHistory_Object];
                
            }
            NSMutableArray *chatHistoryStorageData = [chatHistory_DBStorage getRecentDocumentsData : @"True"];
            chatHistoryArray = [[NSMutableArray alloc]init];
            [chatHistoryArray addObjectsFromArray:chatHistoryStorageData];
            [chatRoomTableView reloadData];
            [self performSelector:@selector(scrollToBottom) withObject:nil afterDelay:4.0];
            

       
            
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:[NSString stringWithFormat:@"CHAT_HISTORY_FIRST_TIME_FETCH_%@",[[chatHistoryArray objectAtIndex:0] valueForKey:@"chatThreadId"]]];
          
            
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
            
            [ChatHistory_DB createInstance : @"ChatHistory_DB_STORAGE" : true :[[dict valueForKey:@"chatThreadId"] integerValue]];
            ChatHistory_DB *chatHistory_DBStorage = [ChatHistory_DB getInstance];
            
            ChatHistory_Object* chatHistory_Object = [[ChatHistory_Object alloc] init];
            chatHistory_Object.chatThreadId =  [[dict valueForKey:@"chatThreadId"] integerValue] ;
            chatHistory_Object.from =   [ NSString stringWithFormat:@"%@", [dict valueForKey:@"from"]];
            chatHistory_Object.to =  [ NSString stringWithFormat:@"%@",[dict valueForKey:@"to"]];
            chatHistory_Object.message =[ NSString stringWithFormat:@"%@",textView.text];
            chatHistory_Object.messageDate =[ NSString stringWithFormat:@"%@",timeStampValue];
            chatHistory_Object.messageType =@"TEXT";
            chatHistory_Object.messageId =[[dict valueForKey:@"serverMessageId"] integerValue] ;
            [chatHistory_DBStorage insertDoc:chatHistory_Object];
            
            NSMutableArray *chatHistoryStorageData = [chatHistory_DBStorage getRecentDocumentsData : @"False"];
            chatHistoryArray = [[NSMutableArray alloc]init];
            [chatHistoryArray addObjectsFromArray:chatHistoryStorageData];
            [chatRoomTableView reloadData];
            self.popupTextView.text =textView.text;
            [textView resignFirstResponder];
            textView.text = defaultTextViewText;
            
            [ChatThreadList_DB createInstance : @"ChatThread_DB_STORAGE" : true];
            ChatThreadList_DB *chatThreadListStorage = [ChatThreadList_DB getInstance];
            ChatThreadList_Object* chatThreadList_Object = [[ChatThreadList_Object alloc] init];
            chatThreadList_Object.chatThreadId =  chatHistory_Object.chatThreadId;
            chatThreadList_Object.lastMessageOn = [ NSString stringWithFormat:@"%@",timeStampValue];
            [chatThreadListStorage updateDocLastMessageTime:chatThreadList_Object];
            
            UIViewController *root;
            root = [[[[UIApplication sharedApplication]windows]objectAtIndex:0]rootViewController];
            SWRevealViewController *reveal = (SWRevealViewController*)root;
            UINavigationController *check =(UINavigationController*)reveal.frontViewController;
            NSArray* viewsList = check.viewControllers;
            UIViewController *checkView = (UIViewController *) [viewsList objectAtIndex:viewsList.count - 2];
            NSMutableArray *chatThreadListStorageData = [chatThreadListStorage getRecentDocumentsData : @"False"];
            ChatBoxVC *vc =  (ChatBoxVC*) checkView;
            vc.chatThreadDict = chatThreadListStorageData;
              [self performSelector:@selector(scrollToBottom) withObject:nil afterDelay:0.0];
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
            UIViewController *root;
            root = [[[[UIApplication sharedApplication]windows]objectAtIndex:0]rootViewController];

            SWRevealViewController *reveal = (SWRevealViewController*)root;
            [(UINavigationController*)reveal.frontViewController pushViewController:chatVC animated:YES];
               [self performSelector:@selector(scrollToBottom) withObject:nil afterDelay:0.0];
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
#pragma -mark time


#pragma -mark textview Delagate
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return headerView.frame.size.height *deviceHeightRation;
//}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    v.backgroundColor = [UIColor redColor];
//    return  v;
//}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    if (textView.tag==10) {
        acceptTextView = textView;
    }
    if ([textView.text isEqualToString:defaultTextViewText]) {
        textView.text = @"";
    }
    
    textView.textColor = [UIColor blackColor];
    [textView resignFirstResponder];
    
    
    //    CGSize maximumLabelSize = CGSizeMake(textView.frame.size.width, 130);
    //
    //    CGSize expectedLabelSize = [textView.text sizeWithFont:textView.font constrainedToSize:maximumLabelSize];
    //
    //    //adjust the label the the new height.
    //    CGRect newFrame = textView.frame;
    //    newFrame.size.height = expectedLabelSize.height;
    //    textView.frame = newFrame;
    
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
}
#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification
{
    if (acceptTextView!=nil) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect f = self.view.frame;
            f.origin.y = -80;
            self.view.frame = f;
        }];
    }
    else{
        CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        [UIView animateWithDuration:0.3 animations:^{
            CGRect f = self.view.frame;
            f.origin.y = -keyboardSize.height;
            self.view.frame = f;
        }];
    }
}

-(void)keyboardWillHide:(NSNotification *)notification
{
   
        [UIView animateWithDuration:0.3 animations:^{
            CGRect f = self.view.frame;
            f.origin.y = 0.0f;
            self.view.frame = f;
        }];
    
}

#pragma mark-Tableview Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [chatHistoryArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier = @"messagingCell";
    PTSMessagingCell * cell = (PTSMessagingCell*) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    if (cell == nil) {
        cell = [[PTSMessagingCell alloc] initMessagingCellWithReuseIdentifier:cellIdentifier];
    }
    
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
        if(message!=nil)
        {
            messageSize = [PTSMessagingCell messageSize:message];
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
    
    if([senderId isEqualToString:userId]) {
        ccell.sent = NO;
        
        ccell.timeLabel.text = time;
        ccell.messageLabel.text = obj.message;
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
        ccell.messageLabel.text = obj.message;
    }

}
- (void) hideKeyboard {
    [textView resignFirstResponder];
 
}
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
}
- (void)scrollToBottom
{
      [chatRoomTableView scrollToRowAtIndexPath:pathToLastRow atScrollPosition:UITableViewScrollPositionTop animated:NO];
}
@end
