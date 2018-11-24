//
//  FormTableViewCell.h
//  EMSV3CommonMobilet
//
//  Created by Puneet on 17-Mar-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXTextField.h"
#import "MXLabel.h"


@interface FormTableViewCell : UIView <UITextFieldDelegate> {
	
	MXLabel *mandatoryLabel;
	MXLabel *titleLabel;	
	//UILabel *valueLabel;	
	
	MXTextField *cellTextField;
	
}

@property (nonatomic,retain) MXLabel *mandatoryLabel;
@property (nonatomic,retain) MXLabel *titleLabel;
//@property (nonatomic,retain) UILabel *valueLabel;

@property (nonatomic,retain) MXTextField *cellTextField;


@end
