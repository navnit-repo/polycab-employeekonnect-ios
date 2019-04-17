//
//  ChatBoxUserListVC.h
//  XMWClient
//
//  Created by dotvikios on 08/04/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatBoxUserListVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *contactsList;
}
@property NSMutableArray *contactsList;
@end

NS_ASSUME_NONNULL_END
