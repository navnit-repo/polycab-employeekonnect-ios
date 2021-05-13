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


@interface SalesCardDataTuple : NSObject

@property NSString* name;
@property NSString* code; // if present
@property NSString* ytdAmount;

@property NSString* mtdAmount;
@property NSString* lmtdAmount;

@property NSString* ftdAmount;
@property NSString* lftdAmount;

@end

@interface SalesAggregateCollectionView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
{
    DotFormPost *lmtdPost;
    DotFormPost *lftdPost;
    DotFormPost *ftdPost;
    DotFormPost *mtdPost;
    DotFormPost *ytdPost;
    
    ReportPostResponse* ftdResponseData;
    ReportPostResponse* lftdResponseData;
    ReportPostResponse* mtdResponseData;
    ReportPostResponse* ytdResponseData;
    ReportPostResponse* lmtdResponseData;
    
    NSMutableArray *ftdDataArray;
    NSMutableArray *lftdDataArray;
    NSMutableArray *mtdDataArray;
    NSMutableArray *ytdDataArray;
    NSMutableArray *lmtdDataArray;
    
    NSMutableArray *maxCellArray;
    
    NSMutableDictionary* salesSliderData;
    SalesCardDataTuple* summaryTuple;
    NSArray* sortedCardKeys;
    
    BOOL sortDone;
    int numberOfCell;
    UILabel *underCellLbl;
    UIPageControl *pageIndicator;
     UIView *blankView;
    UIActivityIndicatorView *activityIndicatorView;
    NSString *LFTD_From_Date;
    NSString *LFTD_TO_Date;
    NSString *LMTD_From_Date;
    NSString *LMTD_TO_Date;
    
    
     UIView *  noDataView ;
}
@property  UIView *  noDataView ;
@property NSString *LMTD_From_Date;
@property NSString *LMTD_TO_Date;
@property NSString *LFTD_From_Date;
@property NSString *LFTD_TO_Date;
@property DotFormPost *ftdPost;
@property DotFormPost *mtdPost;
@property DotFormPost *ytdPost;
@property DotFormPost *lftdPost;
@property DotFormPost *lmtdPost;
@property ReportPostResponse* ftdResponseData;
@property ReportPostResponse* mtdResponseData;
@property ReportPostResponse* ytdResponseData;
@property ReportPostResponse* lftdResponseData;
@property ReportPostResponse* lmtdResponseData;
@property NSMutableArray *ftdDataArray;
@property NSMutableArray *mtdDataArray;
@property NSMutableArray *ytdDataArray;
@property NSMutableArray *lftdDataArray;
@property NSMutableArray *lmtdDataArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageIndicator;
@property (strong, nonatomic) IBOutlet UILabel *underCellLbl;
+(SalesAggregateCollectionView*) createInstance;

@property (weak, nonatomic) IBOutlet UIView *mainView;
-(void)configure;
-(void)ftdNetworkCall;
-(void)mtdNetWorkCall;
-(void)ytdNetworkCAll;
-(void)LFTD_NetworkCall;
-(void)LMTD_NetworkCall;
-(void)maintainArrayFTD_MTD_YTD;
-(void)netwrokCall;
-(void)loadingView;
-(void)addNoDataAvailableView;

-(NSArray*)removeZero:(NSArray*)array;
-(NSArray*)distinct:(NSArray*)arrar1 :(NSArray*)array2;
-(void)addReportData:(ReportPostResponse*) reportData into:(NSMutableDictionary*) inDataSet forColumn:(NSString*) column;

@end
