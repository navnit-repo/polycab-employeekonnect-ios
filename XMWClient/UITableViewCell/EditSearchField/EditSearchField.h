//
//  EditSearchField.h
//  QCMSProject
//
//  Created by Pradeep Singh on 11/30/16.
//  Copyright © 2016 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DotFormElement.h"
#import "MXTextField.h"
#import "MXButton.h"


@interface EditSearchField : UIView


@property (nonatomic, retain) UILabel* titleLabel;
@property (nonatomic, retain) UILabel* mandatoryLabel;
@property (nonatomic, retain) MXButton* searchButton;
@property (nonatomic, retain) MXTextField* editText;


-(void) configureViewCellFor:(DotFormElement*) formElement;


@end
