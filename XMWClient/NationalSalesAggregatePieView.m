//
//  NationalSalesAggregatePieView.m
//  XMWClient
//
//  Created by dotvikios on 14/02/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "NationalSalesAggregatePieView.h"
#import "AppConstants.h"
#import "ClientVariable.h"
#import "XmwReportService.h"
#import "NationalSalesAggregatePieCellView.h"
#import "SimpleEditForm.h"
@implementation NationalSalesAggregatePieView
{
    NationalSalesAggregatePieCellView *nationalSalesAggregatePieCellView;
   
}
+(NationalSalesAggregatePieView*) createInstance

{
    NationalSalesAggregatePieView *view = (NationalSalesAggregatePieView *)[[[NSBundle mainBundle] loadNibNamed:@"NationalSalesAggregatePieView" owner:self options:nil] objectAtIndex:0];
    
    return view;
}

-(void)addLoadingView
{
    // add blank view
    blankView = [[UIView alloc]initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width-20, self.bounds.size.height)];
    blankView.backgroundColor = [UIColor clearColor];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 8, 150*deviceWidthRation, 15*deviceHeightRation)];
    lbl.text = @"Sales Aggregate";
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

- (void)networkCAll
{
    NSString *fromDate;
    NSLocale* currentDate = [NSLocale currentLocale];
    [[NSDate date] descriptionWithLocale:currentDate];
    
    NSDateFormatter *dateFormatterToDate=[[NSDateFormatter alloc] init];
    [dateFormatterToDate setDateFormat:@"dd/MM/yyyy"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@"%@",[dateFormatterToDate stringFromDate:[NSDate date]]);
    NSString *toDate = [dateFormatterToDate stringFromDate:[NSDate date]];
    
    // for month condition check
    NSDateFormatter *checkMonth = [[NSDateFormatter alloc] init];
    [checkMonth setDateFormat:@"02/04/yyyy"];
    NSLog(@"%@",[checkMonth stringFromDate:[NSDate date]]);
    NSString *date1=[checkMonth stringFromDate:[NSDate date]]; //01-04-current year
    NSString *date2=[dateFormatterToDate stringFromDate:[NSDate date]]; //current to date
    NSLog(@"Date1: %@ Date2: %@",date1,date2);
    NSDateFormatter *compareFormat = [[NSDateFormatter alloc] init];
    [compareFormat setDateFormat:@"dd/MM/yyyy"];
    NSDate *dtOne = [[NSDate alloc] init];
    NSDate *dtTwo = [[NSDate alloc] init];
    
    dtOne=[compareFormat dateFromString:date1];
    dtTwo=[compareFormat dateFromString:date2];
    
    
    
    NSComparisonResult result;
    result = [dtOne compare:dtTwo];
    
    if (result == NSOrderedAscending) {
        NSDateFormatter *dateFormatterFormDate=[[NSDateFormatter alloc] init];
        [dateFormatterFormDate setDateFormat:@"01/04/yyyy"];
        // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
        NSLog(@"%@",[dateFormatterFormDate stringFromDate:[NSDate date]]);
        fromDate =[dateFormatterFormDate stringFromDate:[NSDate date]];
        
    }
    else{
        NSDate *date = [NSDate date];
        NSDateComponents *setPreviousYear = [[NSDateComponents alloc] init];
        [setPreviousYear setYear:-1];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *newDate = [calendar dateByAddingComponents:setPreviousYear toDate:date options:0];
        NSLog(@"newDate -> %@",newDate);
        
        NSDateFormatter *dateFormatterFormDate=[[NSDateFormatter alloc] init];
        [dateFormatterFormDate setDateFormat:@"01/04/yyyy"];
        NSLog(@"%@",[dateFormatterFormDate stringFromDate:newDate]);
        fromDate =[dateFormatterFormDate stringFromDate:newDate];
    }
    
    NSLog(@"From Date : %@",fromDate);
    NSLog(@"To date : %@",toDate);
    
    
    // third request mtd
 
    NSMutableDictionary *sendData = [[NSMutableDictionary alloc]init];
    [sendData setObject:@"" forKey:@"CUSTOMER_ACCOUNT"];
    [sendData setObject:fromDate forKey:@"FROM_DATE"];
    [sendData setObject:toDate forKey:@"TO_DATE"];
    
    
    
    chartPostRqst = [[DotFormPost alloc]init];
    [chartPostRqst setAdapterId:AppConst_EMPLOYEE_SALES_AGGREGATE_PIE_CARD_DOC_ID];
    [chartPostRqst setAdapterType:@"CLASSLOADER"];
    [chartPostRqst setReportCacheRefresh:@"false"];
    [chartPostRqst setModuleId:AppConst_MOBILET_ID_DEFAULT];
    [chartPostRqst setPostData:sendData];
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
        //for testing
//        NSMutableArray *testArray = [[NSMutableArray alloc]init];
//        [testArray addObject:[dataArray objectAtIndex:0]];
//        [testArray addObject:[dataArray objectAtIndex:1]];
//        [testArray addObject:[dataArray objectAtIndex:2]];
//        [testArray addObject:[dataArray objectAtIndex:3]];
//        [testArray addObject:[dataArray objectAtIndex:4]];
//        dataArray = [[NSMutableArray alloc]init];
//        [dataArray addObjectsFromArray:testArray];
        if (indexPath.row==0) {
            
            nationalSalesAggregatePieCellView = [NationalSalesAggregatePieCellView createInstance];
            [nationalSalesAggregatePieCellView configure:dataArray];
            [cell addSubview:nationalSalesAggregatePieCellView];
            [blankView removeFromSuperview];
            cell.clipsToBounds = YES;
            
        }
    }
    
    
    
    pageIndicator.numberOfPages = 0;
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    if (dataArray.count>1) {
        DotFormPost *reqFormPost = (DotFormPost*)chartPostRqst;
        ReportPostResponse *reportPostResponse = (ReportPostResponse*) chartResponseData;
        ClientVariable* clientVariable = [ClientVariable getInstance];
        UIViewController* objVC = [clientVariable reportVCForId:reqFormPost.adapterId];
        
        NSMutableDictionary* forwardedDataDisplay;
        NSMutableDictionary* forwardedDataPost;
        forwardedDataPost = [[NSMutableDictionary alloc]init];
        forwardedDataDisplay = [[NSMutableDictionary alloc]init];
        [forwardedDataDisplay setObject:[reqFormPost.postData valueForKey:@"TO_DATE"]  forKey:@"TO_DATE"];
        [forwardedDataDisplay setObject:[reqFormPost.postData valueForKey:@"FROM_DATE"] forKey:@"FROM_DATE"];
        [forwardedDataPost setObject:[reqFormPost.postData valueForKey:@"TO_DATE"] forKey:@"TO_DATE"];
        [forwardedDataPost setObject:[reqFormPost.postData valueForKey:@"FROM_DATE"] forKey:@"FROM_DATE"];
        
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
    }
    
   
  
}

@end
