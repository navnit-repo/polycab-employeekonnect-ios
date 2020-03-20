//
//  CreditDetailsCollectionView.h
//  XMWClient
//
//  Created by dotvikios on 09/08/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DotFormPost.h"
#import "ReportPostResponse.h"

@interface CreditDetailsCollectionView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
{
     DotFormPost *chartPostRqst;
     NSMutableArray *dataArray;
    ReportPostResponse* chartResponseData;
    UICollectionView *collectionView;
}
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageIndicator;
@property  DotFormPost *chartPostRqst;
@property  NSMutableArray *dataArray;
@property ReportPostResponse* chartResponseData;
+(CreditDetailsCollectionView*) createInstance;
@property (weak, nonatomic) IBOutlet UIView *mainView;
- (void)configure;
-(void)networkCAll;
-(void)autoLayout;
-(void)shadowView;
-(void)addLoadingView;
@end
