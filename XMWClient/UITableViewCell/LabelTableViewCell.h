//
//  LabelTableViewCell.h
//  EMSV3CommonMobilet
//
//  Created by Puneet on 01-Apr-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXLabel.h"


@interface LabelTableViewCell : UIView<UILayoutSupport> {
	
	MXLabel *mandatoryLabel;
	MXLabel *titleLabel;	
	MXLabel *valueLabel;	
	
	NSString *cellKey;
}
@property (nonatomic,retain) MXLabel *mandatoryLabel;
@property (nonatomic,retain) MXLabel *titleLabel;
@property (nonatomic,retain) MXLabel *valueLabel;

@property (nonatomic,retain) NSString *cellKey;

@end
