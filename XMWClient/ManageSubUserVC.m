//
//  ManageSubUserVC.m
//  XMWClient
//
//  Created by dotvikios on 23/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "ManageSubUserVC.h"
#import "NetworkHelper.h"
#import "LoadingView.h"
#import "ManageSubUserScrennFlow2nd.h"
#import "XmwcsConstant.h"
#import "LayoutClass.h"
#import "DashBoardVC.h"

@interface ManageSubUserVC ()

@end

@implementation ManageSubUserVC
{
    NetworkHelper *networkHelper;
    LoadingView *loadingView;
}
@synthesize passwordFiled;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self autoLayout];
    NSLog(@"ManageSubUserVC Call");
    NSLog(@"%@",auth_Token);
    
    self.constantView4.layer.masksToBounds = YES;
    self.constantView4.layer.cornerRadius = 5.0f;
    
    
    [self loadForm];
    
    self.passwordFiled.delegate = self;
}

-(void)autoLayout{
    [LayoutClass labelLayout:self.constantView1 forFontWeight:UIFontWeightBold];
     [LayoutClass labelLayout:self.constantView2 forFontWeight:UIFontWeightRegular];
    [LayoutClass textfieldLayout:self.constantView3 forFontWeight:UIFontWeightRegular];
    [LayoutClass buttonLayout:self.constantView4 forFontWeight:UIFontWeightBold];
        [LayoutClass labelLayout:self.constantView5 forFontWeight:UIFontWeightLight];
}
-(void)loadForm{
    //load empty formVC
}
- (IBAction)submitButton:(id)sender {
    if ([passwordFiled.text isEqualToString:@""]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Authentication!" message:@"Blank Field" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        
        [myAlertView show];
    }
    else{
        //network Call
        loadingView= [LoadingView loadingViewInView:self.view];
        NSString *password= passwordFiled.text;
        NSString *userName;
        userName= [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
        NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
        [data setObject:userName forKey:@"registry_id"];
        [data setObject:password forKey:@"password"];
        NSMutableDictionary *subUserDict = [[NSMutableDictionary alloc]init];
        [subUserDict setObject:data forKey:@"data"];
        [subUserDict setObject:auth_Token forKey:@"authToken"];
        [subUserDict setValue:@"dealerverification" forKey:@"opcode"];
        
       
        networkHelper = [[NetworkHelper alloc]init];
        NSString * url= XmwcsConst_OPCODE_URL;
        networkHelper.serviceURLString = url;
        [networkHelper genericJSONPayloadRequestWith:subUserDict :self :@"dealerverification"];
    }
}

- (void)httpResponseObjectHandler:(NSString *)callName :(id)respondedObject :(id)requestedObject{
    [loadingView removeView];
    if ( [callName isEqualToString:@"dealerverification"]) {
        if([[respondedObject valueForKey:@"status"]isEqualToString:@"SUCCESS"])
        {
            ManageSubUserScrennFlow2nd *vc = [[ManageSubUserScrennFlow2nd alloc]init];
             vc.authToken = auth_Token;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
       else if([[respondedObject valueForKey:@"status"]isEqualToString:@"FAIL"])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Password Verification" message:[respondedObject valueForKey:@"message"] delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
    }
    }
}
- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Authentication!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}
@end
