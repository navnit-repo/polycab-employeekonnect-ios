//
//  detailsTableView.h
//  XMWClient
//
//  Created by dotvikios on 13/12/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailsTableView : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *dataArray;
    NSString *headerName;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *dataArray;
@property NSString *headerName;
@end
