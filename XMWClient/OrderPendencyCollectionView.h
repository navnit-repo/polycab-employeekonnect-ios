//
//  OrderPendencyCollectionView.h
//  XMWClient
//
//  Created by dotvikios on 09/08/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderPendencyCollectionView : UIView
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageIndicator;
+(OrderPendencyCollectionView*) createInstance;
@property (weak, nonatomic) IBOutlet UIView *mainView;
- (void)configure;
@end
