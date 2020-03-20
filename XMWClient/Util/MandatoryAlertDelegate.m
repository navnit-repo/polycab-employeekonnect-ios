//
//  MandatoryAlertDelegate.m
//  QCMSProject
//
//  Created by Pradeep Singh on 7/12/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "MandatoryAlertDelegate.h"

@implementation MandatoryAlertDelegate

@synthesize nextFocusableControl;


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    
    
    return false;
}


- (void)willPresentAlertView:(UIAlertView *)alertView {
    
    
    
}

- (void)didPresentAlertView:(UIAlertView *)alertView {
    
    
    
}


- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    
    
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    
        
}

- (void)alertViewCancel:(UIAlertView *)alertView {
    if(nextFocusableControl != nil) {
        
        // [nextFocusableControl ]
    
    }
    [alertView removeFromSuperview];
}

@end
