//
//  BarCodeScanField.h
//  QCMSProject
//
//  Created by Pradeep Singh on 2/14/17.
//  Copyright © 2017 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DotFormElement.h"
#import "MXTextField.h"
#import "MXButton.h"


@interface BarCodeScanField : UIView


@property (nonatomic, retain) UILabel* titleLabel;
@property (nonatomic, retain) UILabel* mandatoryLabel;
@property (nonatomic, retain) MXButton* scanButton;
@property (nonatomic, retain) MXTextField* editText;


-(void) configureViewCellFor:(DotFormElement*) formElement;

@end
