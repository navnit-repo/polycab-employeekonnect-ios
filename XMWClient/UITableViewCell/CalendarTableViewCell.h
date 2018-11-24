//
//  CalendarTableViewCell.h
//  EMSV3CommonMobilet
//
//  Created by Puneet on 28-Mar-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXTextField.h"
#import "MXButton.h"
#import "MXLabel.h"


@interface CalendarTableViewCell : UIView <UITextFieldDelegate> {
	
	NSString *textValue;
	
	MXTextField *calendarField;
	MXButton *calendarButton;
	
	MXLabel *titleLabel;
	MXLabel *mandatoryLabel;
}

@property (nonatomic, retain) NSString *textValue;

@property (nonatomic, retain) MXTextField *calendarField;
@property (nonatomic, retain) MXButton *calendarButton;

@property (nonatomic, retain) MXLabel *titleLabel;
@property (nonatomic, retain) MXLabel *mandatoryLabel;

@end
