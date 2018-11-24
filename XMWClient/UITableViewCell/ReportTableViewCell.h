//
//  ReportTableViewCell.h
//  EMSV3CommonMobilet
//
//  Created by Puneet on 27-Apr-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ReportTableViewCell : UITableViewCell {
	
	NSMutableArray *titleArray;
	NSMutableArray *valueArray;
	
	BOOL isAccessory;
}

@property (nonatomic) BOOL isAccessory;

@property (nonatomic, retain) NSMutableArray *titleArray;
@property (nonatomic, retain) NSMutableArray *valueArray;

- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold;

@end
