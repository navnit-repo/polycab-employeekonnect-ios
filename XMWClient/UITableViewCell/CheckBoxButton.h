//
//  CheckBoxButton.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 13/06/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXTextField.h"
#import "MXButton.h"
#import "MXLabel.h"

@interface CheckBoxButton : UIView
{

NSString *elementId;
NSString *textValue;

MXTextField *checkBoxField;
MXButton *checkBoxButton;
MXLabel *titleLabel;
MXLabel *mandatoryLabel;
BOOL isChecked;
    
}


@property (nonatomic, assign) BOOL isChecked;
@property (nonatomic, retain) NSString *elementId;
@property (nonatomic, retain) NSString *textValue;

@property (nonatomic, retain) MXTextField *checkBoxField;
@property (nonatomic, retain) MXButton *checkBoxButton;
@property (nonatomic, retain) MXLabel *titleLabel;
@property (nonatomic, retain) MXLabel *mandatoryLabel;


-(void) setChecked;
-(void) setUnchecked;


@end
