//
//  OrderFeedbackPopup.h
//  QCMSProject
//
//  Created by Pradeep Singh on 8/26/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DocPostResponse.h"

@protocol OrderFeedbackPopupDelegate <NSObject>
-(void) cancelOrder;
-(void) confirmOrder;
@end

@interface OrderFeedbackPopup : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

+(id) createInstance;


@property (weak, nonatomic) DocPostResponse* docPostRespnose;
@property (weak, nonatomic) id<OrderFeedbackPopupDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView* popupContainer;
@property (weak, nonatomic) IBOutlet UILabel* orderMessage;
@property (weak, nonatomic) IBOutlet UIButton* cancelButton;
@property (weak, nonatomic) IBOutlet UIButton* okButton;


@end
