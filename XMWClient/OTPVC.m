//
//  OTPVC.m
//  XMWClient
//
//  Created by dotvikios on 12/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "OTPVC.h"

@interface OTPVC ()

@end

@implementation OTPVC
@synthesize headerView;
@synthesize nwPassword;
@synthesize confirmNewPassword;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setHidesBackButton:YES animated:YES];
    self.navigationItem.titleView = headerView;
    self.nwPassword.delegate = self;
    self.confirmNewPassword.delegate= self;
}
- (IBAction)headerBackButton:(id)sender {

[self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)submitButton:(id)sender {
    if ([nwPassword.text isEqualToString:confirmNewPassword.text]) {
       //network Call
    }
    if (nwPassword.text.length<8||confirmNewPassword.text.length<8) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Authentication!" message:@"The Password should be of minimum 8 characters." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        [myAlertView show];
    }
    else if(nwPassword.text != confirmNewPassword.text){
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Authentication!" message:@"Passowrd does not match." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        [myAlertView show];
    }
    else if([nwPassword.text isEqualToString:confirmNewPassword.text]){
        
        //NetWork CAll panding
        NSLog(@"Password Match");
    
    }
  
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{

   [textField resignFirstResponder];
    return YES;
}
@end
