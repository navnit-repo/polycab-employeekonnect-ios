//
//  NewChatBoxVC.h
//  XMWClient
//
//  Created by dotvikios on 07/05/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewChatBoxVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@end

NS_ASSUME_NONNULL_END
