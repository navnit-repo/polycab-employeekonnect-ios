//
//  ChatBoxVC.h
//  XMWClient
//
//  Created by dotvikios on 08/04/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatBoxVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    NSMutableArray *chatThreadDict;
    NSMutableDictionary *expendObjectOpenClosedStatusDict;
    NSMutableArray *orignalChatThreadListArray;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *constantLbl1;
@property (weak, nonatomic) IBOutlet UITableView *threadListTableView;
@property NSMutableArray *chatThreadDict;
@property NSMutableDictionary *expendObjectOpenClosedStatusDict;
@property NSMutableArray *orignalChatThreadListArray;
@end

NS_ASSUME_NONNULL_END
