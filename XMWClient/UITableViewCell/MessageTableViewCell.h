//
//  MessageTableViewCell.h
//  EMSV3CommonMobilet
//
//  Created by Puneet on 19-May-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MessageTableViewCell : UITableViewCell {
	
	UILabel *messageLabel;
}

@property (nonatomic, retain) UILabel *messageLabel;

@end
