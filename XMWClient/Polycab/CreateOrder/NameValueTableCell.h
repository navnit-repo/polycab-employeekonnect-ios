//
//  NameValueTableCell.h
//  XMWClient
//
//  Created by Pradeep Singh on 30/05/21.
//  Copyright © 2021 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NameValueTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* leftLabel;
@property (weak, nonatomic) IBOutlet UILabel* rightLabel;

@end

NS_ASSUME_NONNULL_END
