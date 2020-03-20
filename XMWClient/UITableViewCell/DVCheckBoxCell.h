//
//  DVCheckBoxCell.h
//  QCMSProject
//
//  Created by Pradeep Singh on 8/3/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVCheckbox.h"

@protocol DVCheckBoxCellDelegate <NSObject>

-(void) checkBoxSelectedForRowIndex:(NSInteger) rowIndex;
-(void) checkBoxUnSelectedForRowIndex:(NSInteger) rowIndex;

@end


@interface DVCheckBoxCell : UITableViewCell <DVCheckboxDelegate>

@property (weak, nonatomic) IBOutlet DVCheckbox* checkBox;
@property (weak, nonatomic) IBOutlet UILabel* itemText;
@property (weak, nonatomic) id<DVCheckBoxCellDelegate> checkBoxCellDelegate;

-(void) configureCell:(NSString*) itemText checked:(BOOL) status forIndex:(NSInteger) rowIndex;

@end
