//
//  SearchTableViewCell.h
//  EMSV3CommonMobilet
//
//  Created by Puneet on 11-May-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MXLabel.h"

#import "MXButton.h"



@interface SearchTableViewCell : UITableViewCell {

	MXLabel *mandatoryLabel;
	MXLabel *titleLabel;
	
	MXButton *radioGroupButton;
}

@property (nonatomic,retain) MXLabel *mandatoryLabel;
@property (nonatomic,retain) MXLabel *titleLabel;

@property (nonatomic, retain) MXButton *radioGroupButton;

@end
