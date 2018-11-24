//
//  MandatoryAlertDelegate.h
//  QCMSProject
//
//  Created by Pradeep Singh on 7/12/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MandatoryAlertDelegate : NSObject <UIAlertViewDelegate>
{
    UIControl* nextFocusableControl;
    
}

@property UIControl* nextFocusableControl;

@end
