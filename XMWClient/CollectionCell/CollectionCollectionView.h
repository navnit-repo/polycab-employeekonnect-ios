//
//  CollectionCollectionView.h
//  XMWClient
//
//  Created by Pradeep Singh on 07/06/21.
//  Copyright © 2021 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionCollectionView : UIView <UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *maxCellArray;
    
    NSInteger numberOfCell;
    UIView* blankView;
    UIView* noDataView;
    UIActivityIndicatorView* activityIndicatorView;
     
}

@property (weak, nonatomic) IBOutlet UIView* mainView;
@property (weak, nonatomic) IBOutlet UICollectionView* collectionView;
@property (strong, nonatomic) IBOutlet UILabel* underCellLbl;
@property (strong, nonatomic) IBOutlet UIPageControl* pageIndicator;

+(CollectionCollectionView*) createInstance;
-(void)configure;



@end

NS_ASSUME_NONNULL_END
