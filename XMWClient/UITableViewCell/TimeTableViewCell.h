//
//  TimeTableViewCell.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 15/10/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXTextField.h"
#import "MXButton.h"
#import "MXLabel.h"


@interface TimeTableViewCell : UITableViewCell <UITextFieldDelegate>
{
    NSString *textValue;
	
	MXTextField *timeField;
	MXButton *timeButton;
	
	MXLabel *titleLabel;
	MXLabel *mandatoryLabel;
    
}
@property (nonatomic, retain) NSString *textValue;

@property (nonatomic, retain) MXTextField *timeField;
@property (nonatomic, retain) MXButton *timeButton;

@property (nonatomic, retain) MXLabel *titleLabel;
@property (nonatomic, retain) MXLabel *mandatoryLabel;

@end
