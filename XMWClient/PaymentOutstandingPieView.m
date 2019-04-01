//
//  PaymentOutstandingPieView.m
//  XMWClient
//
//  Created by dotvikios on 14/02/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "PaymentOutstandingPieView.h"
#import "PaymentOutstandingPieViewCellView.h"
@implementation PaymentOutstandingPieView
{
    PaymentOutstandingPieViewCellView *paymentOutstandingPieViewCellView;
}
+(PaymentOutstandingPieView*) createInstance

{
    PaymentOutstandingPieView *view = (PaymentOutstandingPieView *)[[[NSBundle mainBundle] loadNibNamed:@"PaymentOutstandingPieView" owner:self options:nil] objectAtIndex:0];
    
    return view;
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
    activityIndicatorView.tag = 50002;
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
    [chartPostRqst setAdapterId:AppConst_EMPLOYEE_PAYMENT_OUTSTANDING_PIE_CARD_DOC_ID];
    [chartPostRqst setAdapterType:@"CLASSLOADER"];
    [chartPostRqst setReportCacheRefresh:@"true"];
    [chartPostRqst setModuleId:AppConst_MOBILET_ID_DEFAULT];
    
    XmwReportService* reportService = [[XmwReportService alloc] initWithPostData:chartPostRqst withContext:@"chartPostRqst"];
    
    
    [reportService fetchReportUsingSuccess:^(DotFormPost* formPosted, ReportPostResponse* reportResponse) {
        
        
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
    UIView *  noDataView = [[UIView alloc]initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width-20, self.bounds.size.height)];
    noDataView.backgroundColor = [UIColor clearColor];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(16, 12, 150*deviceWidthRation, 20*deviceHeightRation)];
    lbl.text = @"Payment Outstanding";
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
        
        if (indexPath.row==0) {
            
            paymentOutstandingPieViewCellView = [PaymentOutstandingPieViewCellView createInstance];
            [paymentOutstandingPieViewCellView configure:dataArray];
            [cell addSubview:paymentOutstandingPieViewCellView];
            [blankView removeFromSuperview];
            cell.clipsToBounds = YES;
            
        }
    }
    
    
    
    pageIndicator.numberOfPages = 0;
    
    return cell;
}
@end
