//
//  SalesAggregateCollectionView.h
//  XMWClient
//
//  Created by dotvikios on 08/08/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DotFormPost.h"
#import "AppConstants.h"
#import "XmwReportService.h"
#import "ReportPostResponse.h"
#import "DVAppDelegate.h"

@interface SalesAggregateCollectionView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
{
    DotFormPost *ftdPost;
    DotFormPost *mtdPost;
    DotFormPost *ytdPost;
    ReportPostResponse* ftdResponseData;
    ReportPostResponse* mtdResponseData;
    ReportPostResponse* ytdResponseData;
    NSMutableArray *ftdDataArray;
    NSMutableArray *mtdDataArray;
    NSMutableArray *ytdDataArray;
    BOOL sortDone;
    int numberOfCell;
    UILabel *underCellLbl;
    UIPageControl *pageIndicator;
     UIView *blankView;
    UIActivityIndicatorView *activityIndicatorView;
}
@property DotFormPost *ftdPost;
@property DotFormPost *mtdPost;
@property DotFormPost *ytdPost;
@property ReportPostResponse* ftdResponseData;
@property ReportPostResponse* mtdResponseData;
@property ReportPostResponse* ytdResponseData;
@property NSMutableArray *ftdDataArray;
@property NSMutableArray *mtdDataArray;
@property NSMutableArray *ytdDataArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageIndicator;
@property (strong, nonatomic) IBOutlet UILabel *underCellLbl;
+(SalesAggregateCollectionView*) createInstance;

@property (weak, nonatomic) IBOutlet UIView *mainView;
-(void)configure;
-(void)ftdNetworkCall;
-(void)mtdNetWorkCall;
-(void)ytdNetworkCAll;
-(void)maintainArrayFTD_MTD_YTD;
-(void)netwrokCall;
-(void)loadingView;
@end
