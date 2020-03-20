//
//  TimePickerViewController.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 15/10/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormVC.h"

@interface TimePickerViewController : UIViewController
{
    FormVC* parentController;
    IBOutlet UIDatePicker *datePicker;
    
}
@property FormVC* parentController;
-(void) drawNavigationButtonItem;
- (void) doneHandler : (id) sender;

@property IBOutlet UIDatePicker *datePicker;
@end
