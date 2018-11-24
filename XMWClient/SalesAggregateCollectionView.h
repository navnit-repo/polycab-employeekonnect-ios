//
//  SalesAggregateCollectionView.h
//  XMWClient
//
//  Created by dotvikios on 08/08/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalesAggregateCollectionView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageIndicator;
@property (weak, nonatomic) IBOutlet UILabel *underCellLbl;
+(SalesAggregateCollectionView*) createInstance;
- (void)configure;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@end
