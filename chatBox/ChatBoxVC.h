//
//  ChatBoxVC.h
//  XMWClient
//
//  Created by dotvikios on 08/04/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatBoxVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *chatThreadDict;
}
@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *constantLbl1;
@property (weak, nonatomic) IBOutlet UITableView *threadListTableView;
@property NSMutableArray *chatThreadDict;
@end

NS_ASSUME_NONNULL_END
