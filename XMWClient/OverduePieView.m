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
    
    return view;
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
        
        
        // we should receive report response data here
        chartResponseData = reportResponse;
        [dataArray addObjectsFromArray:chartResponseData.tableData];
        NSLog(@"Payment Outstanding Data: %@",dataArray);
        
        [self.collectionView reloadData];
        
        
        
    }   fail:^(DotFormPost* formPosted, NSString* message) {
        // we should receive error response here
        
        
    }];
    
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
