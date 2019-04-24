//
//  MessageSubjectVC.m
//  XMWClient
//
//  Created by dotvikios on 09/04/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "MessageSubjectVC.h"
#import "NetworkHelper.h"
#import "LoadingView.h"
#import "XmwcsConstant.h"
#import "LayoutClass.h"
#import "DVAppDelegate.h"
#import "AppConstants.h"
#import "ClientVariable.h"
#import "ChatBoxVC.h"
#import "ChatThreadList_Object.h"
#import "ChatThreadList_DB.h"
#import "ContactList_DB.h"
#import "ContactList_Object.h"
#import "LayoutClass.h"
@interface MessageSubjectVC ()

@end

@implementation MessageSubjectVC
{
    UITextField *checkTextField;
    UITextField *subjectTextField;
    UITextView *textView;
    NSString *defaultTextViewText;
    NetworkHelper *networkHelper;
    LoadingView *loadingView;
}
@synthesize nameLblText;
@synthesize userIDUnique;
- (void)viewDidLoad {
    [super viewDidLoad];
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
        self.view.frame = CGRectMake(0, 64, 375, 603);
    } else if(isiPhone5) {
        self.view.frame = CGRectMake(0, 64, 320, 504);
    } else {
        // 0, 64, 320, 416
        self.view.frame = CGRectMake(0, 64, 320, 416);
    }
    
    [self drawHeaderItem];
    [self createView];
    // Do any additional setup after loading the view from its nib.
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
- (void) backHandler : (id) sender
{
    [ [self navigationController]  popViewControllerAnimated:YES];
    
}
-(void)createView
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 110)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(16, 10, self.view.frame.size.width-32, 20)];
    [nameLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0f]];
    [nameLbl setTextColor:[UIColor blackColor]];
    nameLbl.text = nameLblText;
    [headerView addSubview:nameLbl];
    
    [self.view addSubview:headerView];
    
    subjectTextField = [[UITextField alloc]initWithFrame:CGRectMake(16, 40, self.view.frame.size.width-32, 50)];
    subjectTextField.borderStyle = UITextBorderStyleRoundedRect;
    subjectTextField.returnKeyType = UIReturnKeyDefault;
    subjectTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    subjectTextField.adjustsFontSizeToFitWidth = TRUE;
    subjectTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    subjectTextField.minimumFontSize = 10;
    subjectTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    subjectTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    subjectTextField.font = [UIFont systemFontOfSize:16.0];
    subjectTextField.adjustsFontSizeToFitWidth = YES;
//    subjectTextField.textColor =[UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
    subjectTextField.textColor = [UIColor blackColor];
    subjectTextField.backgroundColor =[UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0];
    subjectTextField.placeholder = @"New message subject";
    subjectTextField.delegate = self;
    //set textfield border
    subjectTextField.layer.masksToBounds=YES;
    subjectTextField.layer.cornerRadius = 5.0f;
    subjectTextField.layer.borderColor= [[UIColor lightGrayColor]CGColor];
    subjectTextField.layer.borderWidth= 1.0f;
    
    [headerView addSubview:subjectTextField];
    
    UIView *headerborderLine =  [[UIView alloc]initWithFrame:CGRectMake(0,headerView.frame.size.height-5, self.view.frame.size.width, 5)];
    headerborderLine.backgroundColor = [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1.0];
    [headerView addSubview:headerborderLine];
    
    
   UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-80+self.view.frame.origin.y, self.view.frame.size.width, 80)];
    UIView *borderLine =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 5)];
    borderLine.backgroundColor = [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1.0];
    [bottomView addSubview:borderLine];
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 6, bottomView.frame.size.width-50, 70)];
    textView.returnKeyType = UIReturnKeyDefault;
    textView.autocapitalizationType = UITextAutocapitalizationTypeWords;
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    textView.font = [UIFont systemFontOfSize:16.0];
    textView.textColor =[UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
    textView.text = @"Type your message here.";
    defaultTextViewText =@"Type your message here.";
    textView.delegate = self;
    [bottomView addSubview:textView];
//    UIViewContentModeCenter
    UIButton *sendButton = [[UIButton alloc]initWithFrame:CGRectMake(bottomView.frame.size.width-50,20, 30, 30)];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
    sendButton.contentMode = UIViewContentModeScaleAspectFit;
    [sendButton addTarget:self action:@selector(sendButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:sendButton];
    [self.view addSubview:bottomView];
//    [self.view addSubview:subjectTextField];
}

-(void)sendButtonHandler:(id)sender
{
   
    
    NSLog(@"Send Button Clicked");

    loadingView = [LoadingView loadingViewInView:self.view];
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSMutableDictionary *sendSubjectData = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *messageData = [[NSMutableDictionary alloc]init];
    
    [sendSubjectData setValue:@"1" forKey:@"requestId"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    [data setValue:[[clientVariables.CLIENT_USER_LOGIN userName] stringByAppendingString:@"@employee"] forKey:@"from"];
    [data setValue:[clientVariables.CLIENT_USER_LOGIN userName] forKey:@"fromUserAccount"];
    [data setValue:userIDUnique forKey:@"to"];
    [data setValue:subjectTextField.text forKey:@"subject"];
    
    [messageData setValue:@"0" forKey:@"chatThread"];
    [messageData setValue:[[clientVariables.CLIENT_USER_LOGIN userName] stringByAppendingString:@"@employee"] forKey:@"from"];
    [messageData setValue:userIDUnique forKey:@"to"];
    [messageData setValue:textView.text forKey:@"message"];
    [messageData setValue:@"Text" forKey:@"messageType"];
    [messageData setValue:@"" forKey:@"hiddenMessage"];
    [messageData setValue:[[clientVariables.CLIENT_USER_LOGIN deviceInfoMap] valueForKey:@"IMEI"] forKey:@"deviceId"];
    [messageData setValue:XmwcsConst_DEVICE_TYPE_IPHONE forKey:@"osType"];
    [messageData setValue:version forKey:@"appVersion"];
    [messageData setValue:@"1" forKey:@"apiVersion"];
    
    [data setObject:messageData forKey:@"message"];
  
    [sendSubjectData setObject:data forKey:@"requestData"];
    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=XmwcsConst_OPCODE_URL;
    networkHelper.serviceURLString = @"http://polycab.dotvik.com:8080/PushMessage/api/createChatThread";
    [networkHelper genericJSONPayloadRequestWith:sendSubjectData :self :@"sendSubjectData"];
    
    [textView resignFirstResponder];
    textView.text = defaultTextViewText;
}


#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification
{
    if (checkTextField!=nil) {
        
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
    if (checkTextField!=nil) {
        
    }
  else{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = 0.0f;
        self.view.frame = f;
    }];
    }
}  

#pragma -mark textview and textField Delagate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    checkTextField = textField;
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{ checkTextField = nil;
 return  [textField resignFirstResponder];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
     checkTextField = nil;
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
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
    
    if(textView.text.length == 0) {
        textView.textColor = [UIColor lightGrayColor];
        textView.text = @"Type your message here.";
        [textView resignFirstResponder];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    checkTextField = nil;
    [subjectTextField endEditing:YES];
     [textView endEditing:YES];
}

#pragma -mark Network Call Response methods
- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    [loadingView removeView];
    if ([callName isEqualToString:@"sendSubjectData"]) {
        if ([[respondedObject objectForKey:@"status"] boolValue] == YES) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setDictionary: [respondedObject valueForKey:@"responseData"]];
            
            [ContactList_DB createInstance : @"ContactList_DB_STORAGE" : true];
            ContactList_DB *contactListStorage = [ContactList_DB getInstance];
            
            [ChatThreadList_DB createInstance : @"ChatThread_DB_STORAGE" : true];
             ChatThreadList_DB *chatThreadListStorage = [ChatThreadList_DB getInstance];
            
      NSMutableArray *contactListStorageData = [contactListStorage getContactDisplayName:@"False" :[dict valueForKey:@"to"]];
            
            ContactList_Object *obj = (ContactList_Object*) [contactListStorageData objectAtIndex:0];
                ChatThreadList_Object* chatThreadList_Object = [[ChatThreadList_Object alloc] init];
                chatThreadList_Object.chatThreadId = [[dict valueForKey:@"chatThreadId"] integerValue];
                chatThreadList_Object.from =         [dict valueForKey:@"to"];
                chatThreadList_Object.to =           [dict valueForKey:@"from"];
                chatThreadList_Object.subject = subjectTextField.text;
                chatThreadList_Object.displayName = obj.userName;
          
            NSString * timeStampValue = [[NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]stringByAppendingString:@"000"];
            NSLog(@"Time Stamp Value == %@", timeStampValue);

                chatThreadList_Object.lastMessageOn = timeStampValue;
                chatThreadList_Object.status = @"";
            
                [chatThreadListStorage insertDoc:chatThreadList_Object];
        ChatBoxVC *vc = [[ChatBoxVC  alloc]init];
        [[self navigationController] pushViewController:vc animated:YES];
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
@end
