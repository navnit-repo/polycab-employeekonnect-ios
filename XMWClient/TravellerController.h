//
//  TravellerController.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 01/10/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageViewController.h"
#import "LoadingView.h"

@interface TravellerController : UIViewController <NSURLConnectionDelegate, UITextFieldDelegate>
{
    LoadingView* loadingView;
    
}
@property(strong, nonatomic) IBOutlet UITextField *userName;
@property(strong, nonatomic) IBOutlet UITextField *password;


-(IBAction)travelerAuthenticationLoginButton:(id)sender;
-(void) makeAuthCall;

-(void)onTravelerReply;

@end
