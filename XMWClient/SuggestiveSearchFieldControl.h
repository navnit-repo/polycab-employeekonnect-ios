//
//  SuggestiveSearchFieldControl.h
//  XMWClient
//
//  Created by dotvikios on 30/07/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXTextField.h"
#import "MXButton.h"
#import "MXLabel.h"
#import "DotFormElement.h"
NS_ASSUME_NONNULL_BEGIN

@interface SuggestiveSearchFieldControl : UIView<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    MXLabel *mandatoryLabel;
    MXLabel *titleLabel;
    MXTextField *searchField;
    UITableView *mainTableView;
}
@property (nonatomic, retain) UITableView *mainTableView;
@property (nonatomic , strong) NSMutableArray *searchResponseArray;
@property (nonatomic, retain) MXLabel *mandatoryLabel;
@property (nonatomic, retain) MXLabel *titleLabel;
@property (nonatomic, retain) MXTextField *searchField;
@property (nonatomic, weak) DotFormElement* formElement;

- (instancetype)initWithFrame:(CGRect)frame :(int) yArguForDrawComp :(DotFormElement*) dotFormElement;
@end

NS_ASSUME_NONNULL_END
