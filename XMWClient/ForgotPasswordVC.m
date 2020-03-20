//
//  ForgotPasswordVC.m
//  XMWClient
//
//  Created by dotvikios on 18/02/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "ForgotPasswordVC.h"
#import "LayoutClass.h"
#import "DVAppDelegate.h"
#import "AppConstants.h"
#import "NetworkHelper.h"
#import "NetworkHelper.h"
#import "LoadingView.h"
#import "XmwcsConstant.h"
@interface ForgotPasswordVC ()

@end

@implementation ForgotPasswordVC
{
    NetworkHelper *networkHelper;
    LoadingView *loadingView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self autoLayout];
     [self navigationBarItems];
    // Do any additional setup after loading the view from its nib.
}
-(void)navigationBarItems
{

  
    self.navigationController.navigationBarHidden = NO;
    
    
    CGFloat topbarHeight = ([UIApplication sharedApplication].statusBarFrame.size.height +
                            (self.navigationController.navigationBar.frame.size.height ?: 0.0));
    
    self.mainView.frame = CGRectMake(self.mainView.frame.origin.x, topbarHeight, self.mainView.frame.size.width, self.mainView.frame.size.height);
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage
                                                                          imageNamed:@"back-button.png"] style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(backHandler:)];
    
    backButton.tintColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
    
    UIImageView *polycabLogo = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"polycab_logo"]];
    self.navigationItem.titleView.contentMode = UIViewContentModeCenter;
    self.navigationItem.titleView = polycabLogo;
    
    [self.navigationItem setLeftBarButtonItem:backButton];
}
- (void) backHandler : (id) sender
{
    
    
    [ [self navigationController]  popViewControllerAnimated:YES];
    
}
-(void)autoLayout
{
    [LayoutClass labelLayout:self.forgotPasswordLbl forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.orLbl forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.enterRegCodeLbl forFontWeight:UIFontWeightLight];
    [LayoutClass labelLayout:self.enterCustomeAccountLbl forFontWeight:UIFontWeightLight];
    [LayoutClass textfieldLayout:self.enterRegCodeTextField forFontWeight:UIFontWeightLight];
    [LayoutClass textfieldLayout:self.enterCustomerAccountTextField forFontWeight:UIFontWeightLight];
    [LayoutClass buttonLayout:self.submitButton forFontWeight:UIFontWeightBold];
    [LayoutClass setLayoutForIPhone6:self.mainView];
    
    self.enterCustomerAccountTextField.delegate = self;
    self.enterRegCodeTextField.delegate = self;
    
    
}
- (IBAction)submitButtonAction:(id)sender {
    
NSString* regID = [self.enterRegCodeTextField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* invoiceNo = [self.enterCustomerAccountTextField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (regID.length <=0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Invalid input field" message:@"Please enter employee id" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    else
    {
     //Network Call
        loadingView= [LoadingView loadingViewInView:self.view];
        NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
       
             [data setObject:regID forKey:@"employee_number"];
     
        
            //[data setObject:invoiceNo forKey:@"customer_number"];
       
   
        NSMutableDictionary * postData = [[NSMutableDictionary  alloc]init];
        [postData setObject:@"execute_forgetpassword" forKey:@"opcode"];
        [postData setObject:data forKey:@"data"];
        [postData setObject:@"xyz" forKey:@"authToken"];
        
        networkHelper = [[NetworkHelper alloc]init];
       NSString * url=XmwcsConst_OPCODE_URL;
      // NSString * url=@"http://10.5.51.113:8080/pcdealer/jsonservice";
        networkHelper.serviceURLString = url;
        [networkHelper genericJSONPayloadRequestWith:postData :self :@"execute_forgetpassword"];
    }
    
}
- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    [loadingView removeFromSuperview];
    if ([callName isEqualToString:@"execute_forgetpassword"]) {
        if ([[respondedObject valueForKey:@"status"]isEqualToString:@"SUCCESS"]) {
//            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
//            [dict setDictionary: [respondedObject valueForKey:@"responseData"]];
//
//            ForgotPasswordNextVC *vc = [[ForgotPasswordNextVC alloc]init];
//            vc.response = dict;
//            [self.navigationController pushViewController:vc animated:YES];
            
            
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Employee Authentication!" message:[respondedObject valueForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
            [myAlertView show];
            LogInVC *vc = [[LogInVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        else
        {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"" message:[respondedObject valueForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
            [myAlertView show];
        }
    }
    
}
- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Connect Authentication!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

@end
