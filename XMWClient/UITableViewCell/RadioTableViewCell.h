//
//  RadioTableViewCell.h
//  EMSV3CommonMobilet
//
//  Created by Puneet on 09-May-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MXLabel.h"

#import "MXButton.h"
#import "RadioGroup.h"
#import "RadioButton.h"

@interface RadioTableViewCell : UIView {

	MXLabel *titleLabel;
	
    RadioGroup *radioGroup;

    
    
}

@property(nonatomic , retain)RadioGroup *radioGroup;

@property (nonatomic,retain) MXLabel *titleLabel;

@end
