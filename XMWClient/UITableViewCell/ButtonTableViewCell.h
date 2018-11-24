//
//  ButtonTableViewCell.h
//  EMSV3CommonMobilet
//
//  Created by Puneet on 28-Mar-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXButton.h"


@interface ButtonTableViewCell : UIView {
	
	MXButton *button;
}

@property (nonatomic, retain) MXButton *button;


@end
