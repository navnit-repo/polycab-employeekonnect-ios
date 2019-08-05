//
//  OverduePieView.m
//  XMWClient
//
//  Created by dotvikios on 14/02/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "OverduePieView.h"
#import "OverduePieCellView.h"
#import "AppConstants.h"
@implementation OverduePieView
{
    OverduePieCellView *overduePieCellView;
}
+(OverduePieView*) createInstance

{
    OverduePieView *view = (OverduePieView *)[[[NSBundle mainBundle] loadNibNamed:@"OverduePieView" owner:self options:nil] objectAtIndex:0];
     [[NSNotificationCenter defaultCenter] addObserver:view selector:@selector(autoRefresh) name:XmwcsConst_OVERDUEPIE_CARD_AUTOREFRESH_IDENTIFIER object:nil];
    
    return view;
}
-(void)autoRefresh
{
    [self addLoadingView];
    [noDataView removeFromSuperview];
    dataArray = [[NSMutableArray alloc] init];
    pageIndicator.numberOfPages = [dataArray count];
    [collectionView reloadData];
    [self networkCAll];
    
    
}
-(void)addLoadingView
{
    [blankView removeFromSuperview];
    // add blank view
    blankView = [[UIView alloc]initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width-20, self.bounds.size.height)];
    blankView.backgroundColor = [UIColor clearColor];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 8, 150*deviceWidthRation, 15*deviceHeightRation)];
    lbl.text = @"Overdue";
    lbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    [blankView addSubview:lbl];
    
    
    UIActivityIndicatorView *  activityIndicatorView = [[UIActivityIndicatorView alloc]
                                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.tag = 50003;
    activityIndicatorView.center=blankView.center;
    [activityIndicatorView startAnimating];
    activityIndicatorView.color = [UIColor redColor];
    activityIndicatorView.hidesWhenStopped = NO;
    activityIndicatorView.hidden = NO;
    [blankView addSubview:activityIndicatorView];
    
    [self.mainView addSubview:blankView];
    
    
}

- (void)networkCAll
{
    chartPostRqst = [[DotFormPost alloc]init];
    [chartPostRqst setAdapterId:AppConst_EMPLOYEE_OVERDUE_PIE_CARD_DOC_ID];
    [chartPostRqst setAdapterType:@"CLASSLOADER"];
    [chartPostRqst setReportCacheRefresh:@"true"];
    [chartPostRqst setModuleId:AppConst_MOBILET_ID_DEFAULT];
    
    XmwReportService* reportService = [[XmwReportService alloc] initWithPostData:chartPostRqst withContext:@"chartPostRqst"];
    
    
    [reportService fetchReportUsingSuccess:^(DotFormPost* formPosted, ReportPostResponse* reportResponse) {
        
        dataArray = [[NSMutableArray alloc] init];
        // we should receive report response data here
        chartResponseData = reportResponse;
        [dataArray addObjectsFromArray:chartResponseData.tableData];
        NSLog(@"Payment Outstanding Data: %@",dataArray);
        
        if (dataArray.count>0) {
            [self.collectionView reloadData];
        }
       
        else
        {
            [self addNoDataAvailableView];
        }
        
        
    }   fail:^(DotFormPost* formPosted, NSString* message) {
        // we should receive error response here
        
        
    }];
    
}

-(void)addNoDataAvailableView
{
    [noDataView removeFromSuperview];
    noDataView = [[UIView alloc]initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width-20, self.bounds.size.height)];
    noDataView.backgroundColor = [UIColor clearColor];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(16, 12, 150*deviceWidthRation, 20*deviceHeightRation)];
    lbl.text = @"Overdue";
    lbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    [noDataView addSubview:lbl];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(0, noDataView.frame.size.height/2, noDataView.frame.size.width, 0)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor: [UIColor colorWithRed:(204.0/255) green:(43.0/255) blue:(43.0/255) alpha:(1)]];
    [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18.0]];
    [label setText: @"No Data Available"];
    
    [label setNumberOfLines: 0];
    [label sizeToFit];
    [label setCenter: CGPointMake(noDataView.center.x, label.center.y)];
    [noDataView addSubview:label];
    
    
    [blankView removeFromSuperview];
    
    [self.mainView addSubview:noDataView];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    if (dataArray.count !=0) {
        
        if (indexPath.row==0) {
            
            overduePieCellView = [OverduePieCellView createInstance];
            [overduePieCellView configure:dataArray];
            [cell addSubview:overduePieCellView];
            [blankView removeFromSuperview];
            cell.clipsToBounds = YES;
            
        }
    }
    
    
    
    pageIndicator.numberOfPages = 0;
    
    return cell;
}

@end
