//
//  WorkFlowLoginScreen.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 22/07/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpEventListener.h"
#import "LoadingView.h"

@interface WorkFlowLoginScreen : UIViewController <HttpEventListener>
{
    int screenId;
    IBOutlet UITextField *UserName;
    IBOutlet UITextField *Password;
    NSString *name;
    NSString *pass;
    LoadingView* loadingView;
}

@property int screenId;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *pass;

-(IBAction)WorkFlowLoginButton:(id)sender;
-(IBAction)WorkFlowCancleButton:(id)sender;

@end
