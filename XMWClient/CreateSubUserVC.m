//
//  CreateSubUserVC.m
//  XMWClient
//
//  Created by dotvikios on 23/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "CreateSubUserVC.h"
#import "NetworkHelper.h"
#import "LoadingView.h"
#import "HttpEventListener.h"
#import "CreateSubUserRoleVC.h"
#import "XmwcsConstant.h"
#import "LayoutClass.h"

@interface CreateSubUserVC ()

@end

@implementation CreateSubUserVC
{
    NetworkHelper *networkHelper;
    LoadingView *loadingView;
    bool isKeyboardOpen;
    CGSize keyboardSize;
    int movedbyHeight;
    UITextField* activeTextField;
}
@synthesize subUserRegID;
@synthesize auth_Token;
@synthesize setSubUserName;
@synthesize setSubUserPassword;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.constantView8.layer.masksToBounds = YES;
    self.constantView8.layer.cornerRadius = 5.0f;
    
    [self autoLayout];
    [self setNavigationBar];
    NSLog(@"CreateSubUserVC Call");
    [self netWorkCall];
    self.setSubUserPassword.delegate = self;
    self.setSubUserName.delegate = self;
    [self registerForKeyboardNotifications];
}
-(void)setNavigationBar{
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage
                                                                          imageNamed:@"back-button.png"] style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(backHandler:)];
    
    backButton.tintColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
    
    
    [self.navigationItem setLeftBarButtonItem:backButton];
    
    UIImageView *polycabLogo = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"polycab_logo"]];
    self.navigationItem.titleView.contentMode = UIViewContentModeCenter;
    self.navigationItem.titleView = polycabLogo;
    
}
- (void) backHandler : (id) sender
{
    
    
    [ [self navigationController]  popViewControllerAnimated:YES];
    
}
-(void)autoLayout{
    [LayoutClass labelLayout:self.constantView1 forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.constantView3 forFontWeight:UIFontWeightBold];
    
    [LayoutClass labelLayout:self.constantView2 forFontWeight:UIFontWeightRegular];
      [LayoutClass labelLayout:self.constantView4 forFontWeight:UIFontWeightRegular];
    
      [LayoutClass labelLayout:self.constantView6 forFontWeight:UIFontWeightRegular];
    [LayoutClass textfieldLayout:self.constantView5 forFontWeight:UIFontWeightRegular];
    
     [LayoutClass textfieldLayout:self.constantView7 forFontWeight:UIFontWeightRegular];
    
    [LayoutClass buttonLayout:self.constantView8 forFontWeight:UIFontWeightBold];
}
-(void)netWorkCall{
   
    loadingView= [LoadingView loadingViewInView:self.view];
    NSString *userName;
    userName= [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    [data setObject:userName forKey:@"registry_id"];
    NSMutableDictionary *genrateSubUser = [[NSMutableDictionary alloc]init];
    [genrateSubUser setObject:data forKey:@"data"];
    [genrateSubUser setObject:auth_Token forKey:@"authToken"];
    [genrateSubUser setValue:@"generatesubuserreg" forKey:@"opcode"];
    
    
    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=XmwcsConst_OPCODE_URL;
    networkHelper.serviceURLString = url;
    [networkHelper genericJSONPayloadRequestWith:genrateSubUser :self :@"generatesubuserreg"];
}
- (void)httpResponseObjectHandler:(NSString *)callName :(id)respondedObject :(id)requestedObject{
    [loadingView removeView];
    if ( [callName isEqualToString:@"generatesubuserreg"]) {
        if([[respondedObject valueForKey:@"status"]isEqualToString:@"SUCCESS"])
        {
            self.subUserRegID.text =[respondedObject valueForKey:@"Data"];
            
        }
    }
    
    else if ( [callName isEqualToString:@"subuser"]) {
        if([[respondedObject valueForKey:@"status"]isEqualToString:@"SUCCESS"])
        {   NSString * subUserRefID =[NSString stringWithFormat:@"%@", [respondedObject valueForKey:@"Data "]];
            CreateSubUserRoleVC *vc = [[CreateSubUserRoleVC alloc]init];
             vc.authToken = auth_Token;
            vc.subUserReffenceID = subUserRefID;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return  YES;
}
- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Authentication!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
    
}
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if(isKeyboardOpen){
        //Cursor on textbox1
        self.view.frame  = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + movedbyHeight, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    isKeyboardOpen=true;
    
    
    NSDictionary* info = [aNotification userInfo];
    keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    
    CGRect textFieldRect = [self.view.window convertRect:activeTextField.bounds fromView:activeTextField];
    
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    NSLog(@"FormVC keyboardWasShown");
    NSLog(@"activeTextField.frame.origin.y = %f", activeTextField.frame.origin.y);
    NSLog(@"self.view.frame.size.height = %f", self.view.frame.size.height);
    
    if(textFieldRect.origin.y > (viewRect.size.height - keyboardSize.height)) {
        movedbyHeight =  textFieldRect.origin.y - (viewRect.size.height  - keyboardSize.height);
        movedbyHeight = movedbyHeight+35;
        //movedbyHeight =  textFieldRect.origin.y - keyboardSize.height ;
        
        self.view.frame  = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - movedbyHeight, self.view.frame.size.width, self.view.frame.size.height);
        
        
        
    }
    
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
    
    isKeyboardOpen=false;
    NSLog(@"FormVC keyboardWillBeHidden");
    
    
    self.view.frame  = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + movedbyHeight, self.view.frame.size.width, self.view.frame.size.height);
    
    
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
    return YES;
}


- (IBAction)submitButton:(id)sender {
    //netWork Call
    loadingView= [LoadingView loadingViewInView:self.view];
    NSString *userName;
    userName= [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
    NSString *subUserRegId = subUserRegID.text;
    NSString *subUserName = setSubUserName.text;
    NSString *subUserPassword = setSubUserPassword.text;
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    [data setObject:userName forKey:@"registry_id"];
    [data setObject:subUserRegId forKey:@"subuserid"];
    [data setObject:subUserName forKey:@"customername"];
    [data setObject:subUserPassword forKey:@"password"];
    
    NSMutableDictionary *genrateSubUser = [[NSMutableDictionary alloc]init];
    [genrateSubUser setObject:data forKey:@"data"];
    [genrateSubUser setObject:auth_Token forKey:@"authToken"];
    [genrateSubUser setValue:@"subuser" forKey:@"opcode"];
    
    
    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=XmwcsConst_OPCODE_URL;
    networkHelper.serviceURLString = url;
    [networkHelper genericJSONPayloadRequestWith:genrateSubUser :self :@"subuser"];
    
    
}
@end
