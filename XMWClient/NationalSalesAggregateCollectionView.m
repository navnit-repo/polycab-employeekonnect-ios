//
//  NationalSalesAggregateCollectionView.m
//  XMWClient
//
//  Created by dotvikios on 14/02/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "NationalSalesAggregateCollectionView.h"
#import "NationalSalesAggregateCellView.h"
#import "NationalWisePolycabSalesComparisonChat.h"
@implementation NationalSalesAggregateCollectionView
{
    NationalSalesAggregateCellView *salesCell;
}
+(NationalSalesAggregateCollectionView*) createInstance

{
    NationalSalesAggregateCollectionView *view = (NationalSalesAggregateCollectionView *)[[[NSBundle mainBundle] loadNibNamed:@"NationalSalesAggregateCollectionView" owner:self options:nil] objectAtIndex:0];
    
    return view;
}


-(void)loadingView{
    // add loading View
    blankView = [[UIView alloc]initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width-20, self.bounds.size.height)];
    blankView.backgroundColor = [UIColor clearColor];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 8, 150*deviceWidthRation, 15*deviceHeightRation)];
    lbl.text = @"Sales Aggregate";
    lbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    [blankView addSubview:lbl];
    
    
    
    activityIndicatorView = [[UIActivityIndicatorView alloc]
                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activityIndicatorView.center=blankView.center;
    activityIndicatorView.tag = 50000;
    [activityIndicatorView startAnimating];
    activityIndicatorView.color = [UIColor redColor];
    activityIndicatorView.hidesWhenStopped = NO;
    activityIndicatorView.hidden = NO;
    [blankView addSubview:activityIndicatorView];
    [self.mainView addSubview:blankView];
    
    
}

-(void)ftdNetworkCall{
    
    // First request ftd
    
    
    NSLocale* currentDate = [NSLocale currentLocale];
    [[NSDate date] descriptionWithLocale:currentDate];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    
    NSString *fromDate =[dateFormatter stringFromDate:[NSDate date]];
    NSString *toDate = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"From Date : %@",fromDate);
    NSLog(@"To date : %@",toDate);
    
    
    ftdPost = [[DotFormPost alloc]init];
    [ftdPost setAdapterId:AppConst_EMPLOYEE_SALES_AGGREGATE_CARD_DOC_ID];
    [ftdPost setAdapterType:@"CLASSLOADER"];
    [ftdPost setModuleId:AppConst_MOBILET_ID_DEFAULT];
    
    NSMutableDictionary *sendData = [[NSMutableDictionary alloc]init];
    [sendData setObject:@"" forKey:@"CUSTOMER_ACCOUNT"];
    [sendData setObject:fromDate forKey:@"FROM_DATE"];
    [sendData setObject:toDate forKey:@"TO_DATE"];
    [ftdPost setPostData:sendData];
    
    
    XmwReportService* reportService = [[XmwReportService alloc] initWithPostData:ftdPost withContext:@"ftdCall"];
    
    [reportService fetchReportUsingSuccess:^(DotFormPost* formPosted, ReportPostResponse* reportResponse) {
        
        
        // we should receive report response data here
        
        ftdResponseData = reportResponse;
        for (int i=0; i<ftdResponseData.tableData.count; i++) {
            NSArray *array = [NSArray arrayWithArray:[ftdResponseData.tableData objectAtIndex:i]];
            [ftdDataArray addObject:array];
        }
        
        NSLog(@"FTD: %@",ftdDataArray);
        
        //when ftd call response sucess then hit mtd call
        [self mtdNetWorkCall];
        
        
    }   fail:^(DotFormPost* formPosted, NSString* message) {
        // we should receive error response here
        
    }];
}
-(void)mtdNetWorkCall{
    
    NSLocale* currentDate = [NSLocale currentLocale];
    [[NSDate date] descriptionWithLocale:currentDate];
    
    NSDateFormatter *dateFormatterFormDate=[[NSDateFormatter alloc] init];
    [dateFormatterFormDate setDateFormat:@"01/MM/yyyy"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@"%@",[dateFormatterFormDate stringFromDate:[NSDate date]]);
    
    
    NSDateFormatter *dateFormatterToDate=[[NSDateFormatter alloc] init];
    [dateFormatterToDate setDateFormat:@"dd/MM/yyyy"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@"%@",[dateFormatterToDate stringFromDate:[NSDate date]]);
    
    
    NSString *fromDate =[dateFormatterFormDate stringFromDate:[NSDate date]];
    NSString *toDate = [dateFormatterToDate stringFromDate:[NSDate date]];
    NSLog(@"From Date : %@",fromDate);
    NSLog(@"To date : %@",toDate);
    
    
    // sesond request mtd
    mtdPost = [[DotFormPost alloc]init];
    [mtdPost setAdapterId:AppConst_EMPLOYEE_SALES_AGGREGATE_CARD_DOC_ID];
    [mtdPost setAdapterType:@"CLASSLOADER"];
    [mtdPost setModuleId:AppConst_MOBILET_ID_DEFAULT];
    
    NSMutableDictionary *sendData = [[NSMutableDictionary alloc]init];
    [sendData setObject:@"" forKey:@"CUSTOMER_ACCOUNT"];
    [sendData setObject:fromDate forKey:@"FROM_DATE"];
    [sendData setObject:toDate forKey:@"TO_DATE"];
    [mtdPost setPostData:sendData];
    
    XmwReportService* reportService= [[XmwReportService alloc] initWithPostData:mtdPost withContext:@"mtdCall"];
    
    [reportService fetchReportUsingSuccess:^(DotFormPost* formPosted, ReportPostResponse* reportResponse) {
        
        
        
        // we should receive report response data here
        mtdResponseData = reportResponse;
        for (int i=0; i<mtdResponseData.tableData.count; i++) {
            NSArray *array = [NSArray arrayWithArray:[mtdResponseData.tableData objectAtIndex:i]];
            [mtdDataArray addObject:array];
        }
        
        NSLog(@"MTD: %@",mtdDataArray);
        
        //when mtd call response sucess then hit ytd call
        [self ytdNetworkCAll];
        
        
    }   fail:^(DotFormPost* formPosted, NSString* message) {
        // we should receive error response here
        
        
        
    }];
    
    
}
-(void)ytdNetworkCAll{
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
    ytdPost = [[DotFormPost alloc]init];
    [ytdPost setAdapterId:AppConst_EMPLOYEE_SALES_AGGREGATE_CARD_DOC_ID];
    [ytdPost setAdapterType:@"CLASSLOADER"];
    [ytdPost setModuleId:AppConst_MOBILET_ID_DEFAULT];
    
    NSMutableDictionary *sendData = [[NSMutableDictionary alloc]init];
    [sendData setObject:@"" forKey:@"CUSTOMER_ACCOUNT"];
    [sendData setObject:fromDate forKey:@"FROM_DATE"];
    [sendData setObject:toDate forKey:@"TO_DATE"];
    [ytdPost setPostData:sendData];
    
    XmwReportService* reportService = [[XmwReportService alloc] initWithPostData:ytdPost withContext:@"ytdCall"];
    
    [reportService fetchReportUsingSuccess:^(DotFormPost* formPosted, ReportPostResponse* reportResponse) {
        
        
        // we should receive report response data here
        ytdResponseData = reportResponse;
        
        for (int i=0; i<ytdResponseData.tableData.count; i++) {
            NSArray *array = [NSArray arrayWithArray:[ytdResponseData.tableData objectAtIndex:i]];
            [ytdDataArray addObject:array];
        }
        NSLog(@"YTD: %@",ytdDataArray);
        
        
        [self maintainArrayFTD_MTD_YTD];
        
    }   fail:^(DotFormPost* formPosted, NSString* message) {
        // we should receive error response here
        
        
        
    }];
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    
    
    //after add empty data if needed.
    NSLog(@"FTD array: %@",ftdDataArray);
    NSLog(@"MTD array: %@",mtdDataArray);
    NSLog(@"YTD array: %@",ytdDataArray);
    
    if (sortDone== true) {
        [blankView removeFromSuperview];
    }
    
    for (int i=0;i<numberOfCell; i++ ) {
        
        if (indexPath.row ==i) {
            
            salesCell = [NationalSalesAggregateCellView createInstance];
            [salesCell configure:[ftdDataArray objectAtIndex:i]  :[mtdDataArray objectAtIndex:i] :[ytdDataArray objectAtIndex:i]];
            [cell addSubview:salesCell];
            cell.clipsToBounds = YES;
        }
        
    }
    
    
    
    //set under lable text
    NSString *text = @"Above data is a representation Total Sales of";
    
    NSLocale* currentDate = [NSLocale currentLocale];
    [[NSDate date] descriptionWithLocale:currentDate];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    NSString *currentYear =[dateFormatter stringFromDate:[NSDate date]];
    
    NSLog(@"Current Year : %@",currentYear);
    
    
    underCellLbl.text =[[[NSString stringWithFormat:@"%@",text]stringByAppendingString:@" "]stringByAppendingString:currentYear];
    
    
    
    
    pageIndicator.numberOfPages = numberOfCell;
    pageIndicator.transform = CGAffineTransformMakeScale(0.7, 0.7);
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    NationalWisePolycabSalesComparisonChat* salesComparisionChart = [[NationalWisePolycabSalesComparisonChat alloc] initWithNibName:@"SalesComparisonChart" bundle:nil];
    
    UIViewController *root;
    root = [[[[UIApplication sharedApplication]windows]objectAtIndex:0]rootViewController];
    
    SWRevealViewController *reveal = (SWRevealViewController*)root;
    [(UINavigationController*)reveal.frontViewController pushViewController:salesComparisionChart animated:YES];
}

@end
