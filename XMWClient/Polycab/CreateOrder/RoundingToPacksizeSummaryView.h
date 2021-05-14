//
//  RoundingToPacksizeSummaryView.h
//  XMWClient
//
//  Created by Pradeep Singh on 14/05/21.
//  Copyright © 2021 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RoundingToPacksizeSummaryView : UIView

@property(weak, nonatomic) IBOutlet UILabel* headerLabel;
@property(weak, nonatomic) IBOutlet UITableView* linesTable;
@property(weak, nonatomic) IBOutlet UIButton* cancelButton;
@property(weak, nonatomic) IBOutlet UIButton* continueButton;


@end

NS_ASSUME_NONNULL_END
