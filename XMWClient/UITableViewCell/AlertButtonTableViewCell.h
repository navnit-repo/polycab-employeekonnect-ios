//
//  AlertButtonTableViewCell.h
//  EMSV3CommonMobilet
//
//  Created by Puneet Arora on 23/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MXButton.h"


@interface AlertButtonTableViewCell : UITableViewCell {
	
	UILabel *questionLabel;
	
	MXButton *leftButton;
	MXButton *rightButton;
}

@property (nonatomic, retain) UILabel *questionLabel;

@property (nonatomic, retain) MXButton *leftButton;
@property (nonatomic, retain) MXButton *rightButton;

@end
