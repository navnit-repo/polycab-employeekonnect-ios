//
//  CreditLimitDetailsMessage.h
//  XMWClient
//
//  Created by Pradeep Singh on 30/05/21.
//  Copyright © 2021 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CreditLimitDetailsMessage : UIView <UITableViewDelegate, UITableViewDataSource>

+(CreditLimitDetailsMessage*) createInstance;

@property (weak, nonatomic) IBOutlet UIView* centerPopup;
@property (weak, nonatomic) IBOutlet UITableView* lineTable;
@property (weak, nonatomic) IBOutlet UIView* buttonsView;

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSArray* tableRows;

@property (weak, nonatomic) UIButton* bottomButton;

@end

NS_ASSUME_NONNULL_END
