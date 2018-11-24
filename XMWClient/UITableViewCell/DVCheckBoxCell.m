//
//  DVCheckBoxCell.m
//  QCMSProject
//
//  Created by Pradeep Singh on 8/3/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import "DVCheckBoxCell.h"

@interface DVCheckBoxCell ()
{
    NSInteger lineIndex;
    BOOL checkBoxChecked;
}

@end



@implementation DVCheckBoxCell


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    
    NSLog(@"Getting Awake from NIb");
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.checkBox.checkboxDelegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) configureCell:(NSString*) itemText checked:(BOOL) status forIndex:(NSInteger) rowIndex
{
    self.itemText.text = itemText;
    lineIndex = rowIndex;
    checkBoxChecked = status;
    
    [self.checkBox configureCheckBoxCheck:checkBoxChecked enable:YES];
   
}


#pragma  mark - CheckBoxDelegate
-(void) hasChecked:(DVCheckbox*) sender
{
    checkBoxChecked = YES;
    if(self.checkBoxCellDelegate !=nil && [self.checkBoxCellDelegate respondsToSelector:@selector(checkBoxSelectedForRowIndex:)]) {
        [self.checkBoxCellDelegate checkBoxSelectedForRowIndex:lineIndex];
    }
}

-(void) hasUnchecked:(DVCheckbox*) sender
{
    checkBoxChecked = NO;
    if(self.checkBoxCellDelegate !=nil && [self.checkBoxCellDelegate respondsToSelector:@selector(checkBoxUnSelectedForRowIndex:)]) {
        [self.checkBoxCellDelegate checkBoxUnSelectedForRowIndex:lineIndex];
    }
    
}


@end
