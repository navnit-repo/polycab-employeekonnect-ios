//
//  PaymentOutstandingPieView.h
//  XMWClient
//
//  Created by dotvikios on 14/02/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverDueCollectionView.h"
NS_ASSUME_NONNULL_BEGIN

@interface PaymentOutstandingPieView : OverDueCollectionView
+(PaymentOutstandingPieView*) createInstance;
@end

NS_ASSUME_NONNULL_END
