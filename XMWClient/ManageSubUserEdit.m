//
//  ManageSubUserEdit.m
//  XMWClient
//
//  Created by dotvikios on 24/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "ManageSubUserEdit.h"
#import "NetworkHelper.h"
#import "LoadingView.h"
#import "HttpEventListener.h"
#import "ManageSubUserScrennFlow2nd.h"
#import "CreateSubUserRoleVC.h"
#import "XmwcsConstant.h"
#import "LayoutClass.h"

@interface ManageSubUserEdit ()
@end

@implementation ManageSubUserEdit
{
    NetworkHelper *networkHelper;
    LoadingView *loadingView;
}
@synthesize userid;
@synthesize regID;
@synthesize authToken;
@synthesize userNameFiled;
@synthesize passwordField;
@synthesize regcodeLable;
@synthesize subuserrefid;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.constantView7.layer.masksToBounds = YES;
    self.constantView7.layer.cornerRadius = 5.0f;
    [self autoLayout];
    [self setNavigationBar];
    NSLog(@"ManageSubUserEdit Call");
    self.userNameFiled.delegate = self;
    self.passwordField.delegate = self;
    self.regcodeLable.text = regID;
    self.userNameFiled.text = userid;
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
    
    [self.navigationController popViewControllerAnimated:YES];
   
    
}
- (void)autoLayout{
    [LayoutClass labelLayout:self.constantView1 forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.constantView2 forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.constantView3 forFontWeight:UIFontWeightRegular];
      [LayoutClass labelLayout:self.constantView5 forFontWeight:UIFontWeightRegular];
    
    [LayoutClass textfieldLayout:self.constantView4 forFontWeight:UIFontWeightRegular];
     [LayoutClass textfieldLayout:self.constantView6 forFontWeight:UIFontWeightRegular];
    [LayoutClass buttonLayout:self.constantView7 forFontWeight:UIFontWeightBold];
    
     [LayoutClass buttonLayout:self.constantView8 forFontWeight:UIFontWeightRegular];
     [LayoutClass buttonLayout:self.constantView9 forFontWeight:UIFontWeightRegular];
    
    
}
- (IBAction)updateButton:(id)sender {
    //network Call
    loadingView= [LoadingView loadingViewInView:self.view];
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    NSString *subuser_name =userNameFiled.text;
    NSString *password = passwordField.text;
    [data setObject:subuser_name forKey:@"subuser_name"];
    [data setObject:subuserrefid forKey:@"subuserrefid"];
    [data setObject:password forKey:@"password"];
    NSMutableDictionary *updateSubUser = [[NSMutableDictionary alloc]init];
    [updateSubUser setObject:data forKey:@"data"];
    [updateSubUser setObject:authToken forKey:@"authToken"];
    [updateSubUser setValue:@"updatesubuser" forKey:@"opcode"];
    
    
    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=XmwcsConst_OPCODE_URL;
    networkHelper.serviceURLString = url;
    [networkHelper genericJSONPayloadRequestWith:updateSubUser :self :@"updatesubuser"];
    
}
- (IBAction)editButton:(id)sender {
    CreateSubUserRoleVC *vc = [[CreateSubUserRoleVC alloc]init];
    vc.authToken = authToken;
    vc.networkCallFlag = true;
    vc.subUserReffenceID = subuserrefid;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)removeButton:(id)sender {
    UIAlertView* removeDialog = [[UIAlertView alloc] initWithTitle:@"PolyCab" message:@"Do you really want to remove sub user?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [removeDialog show];
   
}
- (void)httpResponseObjectHandler:(NSString *)callName :(id)respondedObject :(id)requestedObject{
    [loadingView removeView];
    if ( [callName isEqualToString:@"updatesubuser"]) {
        if([[respondedObject valueForKey:@"status"]isEqualToString:@"SUCCESS"])
        {
            ManageSubUserScrennFlow2nd *vc = [[ManageSubUserScrennFlow2nd alloc]init];
            vc.authToken = authToken;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }

    else if ( [callName isEqualToString:@"removesubuser"]) {
        if([[respondedObject valueForKey:@"status"]isEqualToString:@"SUCCESS"])
        {
            ManageSubUserScrennFlow2nd *vc = [[ManageSubUserScrennFlow2nd alloc]init];
            vc.authToken = authToken;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }
}
- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Authentication!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
        if(buttonIndex==0) {
            [self removeSubUserCall];
        } else {
            // do nothing
        }
}
-(void)removeSubUserCall{
    //network Call
    loadingView= [LoadingView loadingViewInView:self.view];
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    [data setObject:subuserrefid forKey:@"subuserrefid"];
    NSMutableDictionary *updateSubUser = [[NSMutableDictionary alloc]init];
    [updateSubUser setObject:data forKey:@"data"];
    [updateSubUser setObject:authToken forKey:@"authToken"];
    [updateSubUser setValue:@"removesubuser" forKey:@"opcode"];
    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=XmwcsConst_OPCODE_URL;
    networkHelper.serviceURLString = url;
    [networkHelper genericJSONPayloadRequestWith:updateSubUser :self :@"removesubuser"];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return  YES;
}
@end
