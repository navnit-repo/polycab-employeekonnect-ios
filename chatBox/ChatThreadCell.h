//
//  ChatThreadCell.h
//  XMWClient
//
//  Created by dotvikios on 12/04/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatThreadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *subjectLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLbl;
@property (weak, nonatomic) IBOutlet UILabel *chatPersonLbl;
@property (weak, nonatomic) IBOutlet UIView *pushView;


@end

NS_ASSUME_NONNULL_END
