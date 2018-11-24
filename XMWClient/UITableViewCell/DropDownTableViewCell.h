//
//  DropDownTableViewCell.h
//  EMSV3CommonMobilet
//
//  Created by Puneet on 28-Mar-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXTextField.h"
#import "MXButton.h"
#import "MXLabel.h"


@interface DropDownTableViewCell :  UIView <UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource> {
	
	NSString *keyValue;
	NSString *textValue;
	
	MXTextField *dropDownField;
	MXButton *dropDownButton;
	
	NSMutableDictionary *dataDictionary;	
	NSMutableArray *dataList;
	
	MXLabel *titleLabel;
	MXLabel *mandatoryLabel;
	
	UIPickerView *dropDownPicker;
	UIToolbar *pickerDoneButtonView;
}

@property (nonatomic, retain) NSString *keyValue;
@property (nonatomic, retain) NSString *textValue;

@property (nonatomic, retain) MXTextField *dropDownField;
@property (nonatomic, retain) MXButton *dropDownButton;

@property (nonatomic, retain) NSMutableDictionary *dataDictionary;

@property (nonatomic, retain) NSMutableArray *dataList;

@property (nonatomic, retain) MXLabel *titleLabel;
@property (nonatomic, retain) MXLabel *mandatoryLabel;


-(void) animatePicker:(int) direction;

@end
