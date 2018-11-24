//
//  CheckBoxGroup.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 19/06/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXTextField.h"
#import "MXButton.h"
#import "MXLabel.h"

@interface CheckBoxGroupItem : NSObject
{
    MXButton *checkBoxGroupButton;
    MXLabel *titleLabel;
    BOOL isChecked;
}

@property (nonatomic, retain) MXButton *checkBoxGroupButton;
@property (nonatomic, retain) MXLabel *titleLabel;
@property  BOOL isChecked;


-(void) setChecked;
-(void) setUnChecked;

@end



@interface CheckBoxGroup : UITableViewCell
{
    NSString* elementId;
    NSString* textValue;

    MXLabel *titleLabel;
    MXLabel *mandatoryLabel;
    
    NSMutableArray* checkBoxItems;
    
    id attachedData;
}

@property (nonatomic, retain) NSString *elementId;
@property (nonatomic, retain) NSString *textValue;
@property (nonatomic, retain) MXLabel *titleLabel;
@property (nonatomic, retain) MXLabel *mandatoryLabel;
@property (nonatomic, retain) NSMutableArray* checkBoxItems;

@property (strong, nonatomic) id attachedData;

@end
