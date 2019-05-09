//
//  ChatThreadCell.h
//  XMWClient
//
//  Created by dotvikios on 12/04/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXButton.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChatThreadCell : UITableViewCell<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *subjectLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLbl;
@property (weak, nonatomic) IBOutlet UILabel *chatPersonLbl;
@property (weak, nonatomic) IBOutlet UIView *pushView;
@property (weak, nonatomic) IBOutlet UIImageView *acceptImageView;
@property (weak, nonatomic) IBOutlet MXButton *closeButtonOutlate;


@end

NS_ASSUME_NONNULL_END
