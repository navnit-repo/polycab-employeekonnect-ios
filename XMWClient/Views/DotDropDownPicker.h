//
//  DotDropDownPicker.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 06/07/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormVC.h"

@interface DotDropDownPicker : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>
{
@private
        id attachedData ;
        NSString* elementId;
        NSMutableArray *dropDownList;
        NSMutableArray *dropDownListKey;
        NSString *selectedPickerValue;
        NSString *selectedPickerKey;
    
   
}

@property id attachedData;
@property NSString* elementId;
@property NSMutableArray *dropDownList;
@property NSMutableArray *dropDownListKey;
@property NSString *selectedPickerValue;
@property NSString *selectedPickerKey;

@end
