//
//  MultiSelectPopup.h
//  QCMSProject
//
//  Created by Pradeep Singh on 8/3/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVCheckBoxCell.h"
#import "DVCheckbox.h"

@class MultiSelectPopup;


@protocol MultiSelectDelegate <NSObject>
-(void) selected:(MultiSelectPopup*) multiSelectPopup items:(NSArray*) itemIndices;
@end


@interface MultiSelectPopup : UIView  <UITableViewDelegate, UITableViewDataSource, DVCheckBoxCellDelegate>

@property (weak, nonatomic) IBOutlet UIView* popupHolderView;
@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (weak, nonatomic) IBOutlet UIView* bottomContainer;
@property (weak, nonatomic) IBOutlet UIButton* okButton;
@property (weak, nonatomic) IBOutlet UIButton* cancelButton;

@property (weak, nonatomic) NSArray* allOptions;
@property (weak, nonatomic) NSString* title;

@property (weak, nonatomic) id<MultiSelectDelegate> multiSelectDelegate;


+(MultiSelectPopup*) createInstanceWithData:(NSArray*) lineData title:(NSString*) titleText;

-(void) setInitialSelectedList:(NSArray*) selectedList;

@end
