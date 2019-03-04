//
//  CreditDetailsCollectionView.m
//  XMWClient
//
//  Created by dotvikios on 09/08/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "CreditDetailsCollectionView.h"
#import "DotFormPost.h"
#import "LoadingView.h"
#import "AppConstants.h"
#import "ClientVariable.h"
#import "XmwReportService.h"
#import "CreateDetailsCell.h"
#import "LayoutClass.h"
#import "DVAppDelegate.h"
#import "ProgressBarView.h"
#import "detailsTableView.h"
@implementation CreditDetailsCollectionView
{
   // DotFormPost *chartPostRqst;
    LoadingView *loadingView;
    NSMutableArray *numberOfCell;
  //  ReportPostResponse* chartResponseData;
  //  NSMutableArray *dataArray;
    CreateDetailsCell *createDetailsCell;
    ProgressBarView *progressBarView;
    UIView *blankView;
}
@synthesize collectionView;
@synthesize pageIndicator;

-(void)autoLayout{
    [LayoutClass setLayoutForIPhone6:self.mainView];
    [LayoutClass setLayoutForIPhone6:self.collectionView];
    [LayoutClass setLayoutForIPhone6:self.pageIndicator];
}


- (void)configure{
    [self autoLayout];
    [self shadowView];
    dataArray = [[NSMutableArray alloc]init];
    self.collectionView.delegate= self;
    self.collectionView.dataSource= self;
   [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
   collectionView.backgroundColor = [UIColor clearColor];
   collectionView.bounces = NO;
    
    [self addLoadingView];
    
    //.... add 3 second delay
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(networkCAll) object:nil];
    [self performSelector:@selector(networkCAll) withObject:nil afterDelay:4.0];
     //.... add 3 second delay
    
//    [self networkCAll]; comment this code for add 3 sec delay
}

-(void)addLoadingView
{
    // add blank view
    blankView = [[UIView alloc]initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width-20, self.bounds.size.height)];
    blankView.backgroundColor = [UIColor clearColor];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 8, 150*deviceWidthRation, 15*deviceHeightRation)];
    lbl.text = @"Payment Outstanding";
    lbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    [blankView addSubview:lbl];
    
    
    UIActivityIndicatorView *  activityIndicatorView = [[UIActivityIndicatorView alloc]
                                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.tag = 50001;
    activityIndicatorView.center=blankView.center;
    [activityIndicatorView startAnimating];
    activityIndicatorView.color = [UIColor redColor];
    activityIndicatorView.hidesWhenStopped = NO;
    activityIndicatorView.hidden = NO;
    [blankView addSubview:activityIndicatorView];
    
    [self.mainView addSubview:blankView];
    

    
}
-(void)shadowView{
    // *** Set masks bounds to NO to display shadow visible ***
    self.mainView.layer.masksToBounds = NO;
    // *** Set light gray color as shown in sample ***
    self.mainView.layer.shadowColor = [UIColor grayColor].CGColor;
    //    // *** *** Use following to add Shadow top, left ***
    //    self.mainView.layer.shadowOffset = CGSizeMake(-5.0f, -5.0f);
    
    // *** Use following to add Shadow bottom, right ***
    //self.avatarImageView.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    
    // *** Use following to add Shadow top, left, bottom, right ***
    self.mainView.layer.shadowOffset = CGSizeZero;
    self.mainView.layer.shadowRadius = 5.0f;
    
    // *** Set shadowOpacity to full (1) ***
    self.mainView.layer.shadowOpacity = 5.0f;

    
}

-(void)networkCAll{
    chartPostRqst = [[DotFormPost alloc]init];    
    [chartPostRqst setAdapterId:@"EMP_PORTAL_PAYMENT_OUTSTANDING"];
    [chartPostRqst setAdapterType:@"CLASSLOADER"];
    [chartPostRqst setDocId:@"EMP_PORTAL_PAYMENT_OUTSTANDING"];
    [chartPostRqst setReportCacheRefresh:@"true"];
    [chartPostRqst setModuleId:AppConst_MOBILET_ID_DEFAULT];
    
    XmwReportService* reportService = [[XmwReportService alloc] initWithPostData:chartPostRqst withContext:@"chartPostRqst"];
   
 
    [reportService fetchReportUsingSuccess:^(DotFormPost* formPosted, ReportPostResponse* reportResponse) {
        
      
        // we should receive report response data here
        chartResponseData = reportResponse;
        [dataArray addObjectsFromArray:chartResponseData.tableData];
        NSLog(@"Payment Outstanding Data: %@",dataArray);
    
            [self.collectionView reloadData];
        
       
      
    }   fail:^(DotFormPost* formPosted, NSString* message) {
        // we should receive error response here
        
        
    }];
    
    
    
}

+(CreditDetailsCollectionView*) createInstance

{
    CreditDetailsCollectionView *view = (CreditDetailsCollectionView *)[[[NSBundle mainBundle] loadNibNamed:@"CreditDetailsCollectionView" owner:self options:nil] objectAtIndex:0];
    
    return view;
}
#pragma mark : Collection View Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.collectionView.frame.size.width, 210*deviceHeightRation);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat width = scrollView.frame.size.width;
    NSInteger page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    NSInteger moveToPage = page;
    moveToPage = moveToPage % [dataArray count];;
    pageIndicator.currentPage = moveToPage;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];

//        for (int i=0;i<dataArray.count; i++ ) {
//
//            [blankView removeFromSuperview];
//
//            if (indexPath.row ==i) {
//                createDetailsCell = [CreateDetailsCell createInstance];
//                [createDetailsCell configure:[dataArray objectAtIndex:i]];
//                [cell addSubview:createDetailsCell];
//                cell.clipsToBounds = YES;
//            }
//
//        }
//    pageIndicator.numberOfPages = [dataArray count];
    
    if (dataArray.count !=0) {
        [blankView removeFromSuperview];
        if (indexPath.row==0) {
            
            createDetailsCell = [CreateDetailsCell createInstance];
            [createDetailsCell configure:dataArray];
            [cell addSubview:createDetailsCell];
            cell.clipsToBounds = YES;
            
        }
    }
    
    
    
    pageIndicator.numberOfPages = 0;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DotFormPost *reqFormPost = (DotFormPost*)chartPostRqst;
    ReportPostResponse *reportPostResponse = (ReportPostResponse*) chartResponseData;
    ClientVariable* clientVariable = [ClientVariable getInstance];
    UIViewController* objVC = [clientVariable reportVCForId:reqFormPost.adapterId];
    
    NSMutableDictionary* forwardedDataDisplay;
    NSMutableDictionary* forwardedDataPost;
    forwardedDataPost = [[NSMutableDictionary alloc]init];
    forwardedDataDisplay = [[NSMutableDictionary alloc]init];
    ReportVC *reportVC = (ReportVC*) objVC;
    
    reportVC.requestFormPost = reqFormPost;
    reportVC.screenId = AppConst_SCREEN_ID_REPORT;
    reportVC.reportPostResponse = reportPostResponse;
    reportVC.forwardedDataDisplay = forwardedDataDisplay;
    reportVC.forwardedDataPost = forwardedDataPost;
    
    UIViewController *root;
    root = [[[[UIApplication sharedApplication]windows]objectAtIndex:0]rootViewController];
    
    SWRevealViewController *reveal = (SWRevealViewController*)root;
    [(UINavigationController*)reveal.frontViewController pushViewController:objVC animated:YES];
    
//    detailsTableView *vc = [[detailsTableView alloc]init];
//    vc.dataArray = dataArray;
//    vc.headerName = @"Payment Outstanding";
//
//    UIViewController *root;
//    root = [[[[UIApplication sharedApplication]windows]objectAtIndex:0]rootViewController];
//
//    SWRevealViewController *reveal = (SWRevealViewController*)root;
//    [(UINavigationController*)reveal.frontViewController pushViewController:vc animated:YES];
}

@end
