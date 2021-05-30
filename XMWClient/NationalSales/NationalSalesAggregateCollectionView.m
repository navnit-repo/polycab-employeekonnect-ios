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
#import "AppConstants.h"
#import "XmwcsConstant.h"

@implementation NationalSalesAggregateCollectionView
{
    NationalSalesAggregateCellView *salesCell;
}

+(NationalSalesAggregateCollectionView*) createInstance

{
    NationalSalesAggregateCollectionView *view = (NationalSalesAggregateCollectionView *)[[[NSBundle mainBundle] loadNibNamed:@"NationalSalesAggregateCollectionView" owner:self options:nil] objectAtIndex:0];
    [[NSNotificationCenter defaultCenter] addObserver:view selector:@selector(autoRefresh) name:XmwcsConst_NATIONALSALESAGGREGATE_CARD_AUTOREFRESH_IDENTIFIER object:nil];
    return view;
}
-(void)autoRefresh
{
    [self loadingView];
    [noDataView removeFromSuperview];
    [underCellLbl removeFromSuperview];
    ftdDataArray = [[NSMutableArray alloc]init];
    mtdDataArray = [[NSMutableArray alloc]init];
    ytdDataArray = [[NSMutableArray alloc]init];
    lftdDataArray = [[NSMutableArray alloc]init];
    lmtdDataArray = [[NSMutableArray alloc]init];
    sortDone = false;
    numberOfCell = 0;
    pageIndicator.numberOfPages = numberOfCell;
    [self.collectionView reloadData];
    [self netwrokCall];
    
}

-(void)loadingView{
    // add loading View
    
    [blankView removeFromSuperview];
    
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
    [ftdPost setDocDesc:@"FTD"];
    NSMutableDictionary *sendData = [[NSMutableDictionary alloc]init];
    [sendData setObject:@"" forKey:@"CUSTOMER_ACCOUNT"];
    [sendData setObject:fromDate forKey:@"FROM_DATE"];
    [sendData setObject:toDate forKey:@"TO_DATE"];
    [ftdPost setPostData:sendData];
    
    
    NSDateFormatter *LFTD_dateFormatter = [[NSDateFormatter alloc] init];
    [LFTD_dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *dateFromString = [LFTD_dateFormatter dateFromString:fromDate];
    
    NSDateComponents *previousDaye = [[NSDateComponents alloc] init];
    [previousDaye setDay:-1];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:previousDaye toDate:dateFromString options:0];
    NSLog(@"newDate -> %@",newDate);
    
    LFTD_From_Date = [LFTD_dateFormatter stringFromDate:newDate];
    LFTD_TO_Date = LFTD_From_Date;
    
    XmwReportService* reportService = [[XmwReportService alloc] initWithPostData:ftdPost withContext:@"ftdCall"];
    
    [reportService fetchReportUsingSuccess:^(DotFormPost* formPosted, ReportPostResponse* reportResponse) {
        
        
        // we should receive report response data here
        ftdDataArray = [[NSMutableArray alloc ] init];
        ftdResponseData = reportResponse;
        [self addReportData:ftdResponseData into:salesSliderData forColumn:@"FTD"];
        
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
    
    
    NSDateFormatter *LMTD_dateFormatter = [[NSDateFormatter alloc] init];
    [LMTD_dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *dateFromString = [LMTD_dateFormatter dateFromString:fromDate];
    
    NSDateComponents *previousMonthForFrom = [[NSDateComponents alloc] init];
    [previousMonthForFrom setMonth:-1];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *newDateFrom = [calendar dateByAddingComponents:previousMonthForFrom toDate:dateFromString options:0];
    NSLog(@"newDate -> %@",newDateFrom);
    
    LMTD_From_Date = [LMTD_dateFormatter stringFromDate:newDateFrom];
    
    NSDate *dateToString = [LMTD_dateFormatter dateFromString:toDate];
    
    NSDateComponents *previousMonthForTo = [[NSDateComponents alloc] init];
    [previousMonthForTo setMonth:-1];
    NSCalendar *calendar2 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *newDateTo = [calendar2 dateByAddingComponents:previousMonthForTo toDate:dateToString options:0];
    NSLog(@"newDate -> %@",newDateTo);
    
    LMTD_TO_Date = [LMTD_dateFormatter stringFromDate:newDateTo];
    
    
    // sesond request mtd
    mtdPost = [[DotFormPost alloc]init];
    [mtdPost setAdapterId:AppConst_EMPLOYEE_SALES_AGGREGATE_CARD_DOC_ID];
    [mtdPost setAdapterType:@"CLASSLOADER"];
    [mtdPost setModuleId:AppConst_MOBILET_ID_DEFAULT];
    [mtdPost setDocDesc:@"MTD"];
    NSMutableDictionary *sendData = [[NSMutableDictionary alloc]init];
    [sendData setObject:@"" forKey:@"CUSTOMER_ACCOUNT"];
    [sendData setObject:fromDate forKey:@"FROM_DATE"];
    [sendData setObject:toDate forKey:@"TO_DATE"];
    [mtdPost setPostData:sendData];
    
    XmwReportService* reportService= [[XmwReportService alloc] initWithPostData:mtdPost withContext:@"mtdCall"];
    
    [reportService fetchReportUsingSuccess:^(DotFormPost* formPosted, ReportPostResponse* reportResponse) {
        
        
        mtdDataArray = [[NSMutableArray alloc ] init];
        // we should receive report response data here
        mtdResponseData = reportResponse;
        
        [self addReportData:mtdResponseData into:salesSliderData forColumn:@"MTD"];
        
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
    [checkMonth setDateFormat:@"01/04/yyyy"];
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
    
    else if (result == NSOrderedSame) {
        NSDateFormatter *dateFormatterToDate=[[NSDateFormatter alloc] init];
        [dateFormatterToDate setDateFormat:@"dd/MM/yyyy"];
        // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
        NSLog(@"%@",[dateFormatterToDate stringFromDate:[NSDate date]]);
        fromDate = [dateFormatterToDate stringFromDate:[NSDate date]];
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
    [ytdPost setDocDesc:@"YTD"];

    NSMutableDictionary *sendData = [[NSMutableDictionary alloc]init];
    [sendData setObject:@"" forKey:@"CUSTOMER_ACCOUNT"];
    [sendData setObject:fromDate forKey:@"FROM_DATE"];
    [sendData setObject:toDate forKey:@"TO_DATE"];
    [ytdPost setPostData:sendData];
    
    XmwReportService* reportService = [[XmwReportService alloc] initWithPostData:ytdPost withContext:@"ytdCall"];
    
    [reportService fetchReportUsingSuccess:^(DotFormPost* formPosted, ReportPostResponse* reportResponse) {
        
         ytdDataArray = [[NSMutableArray alloc ] init];
        // we should receive report response data here
        ytdResponseData = reportResponse;
        
        [self addReportData:ytdResponseData into:salesSliderData forColumn:@"YTD"];
        
        [self LFTD_NetworkCall];
        //[self maintainArrayFTD_MTD_YTD];
        
    }   fail:^(DotFormPost* formPosted, NSString* message) {
        // we should receive error response here
        
        
        
    }];
    
    
}
-(void)LMTD_NetworkCall
{
    NSLog(@"From date :- %@",LMTD_From_Date);
    NSLog(@"To date :- %@",LMTD_TO_Date);
    lmtdPost = [[DotFormPost alloc]init];
    [lmtdPost setAdapterId:AppConst_EMPLOYEE_SALES_AGGREGATE_CARD_DOC_ID];
    [lmtdPost setAdapterType:@"CLASSLOADER"];
    [lmtdPost setModuleId:AppConst_MOBILET_ID_DEFAULT];
    [lmtdPost setDocDesc:@"LMTD"];
    NSMutableDictionary *sendData = [[NSMutableDictionary alloc]init];
    [sendData setObject:@"" forKey:@"CUSTOMER_ACCOUNT"];
    [sendData setObject:LMTD_From_Date forKey:@"FROM_DATE"];
    [sendData setObject:LMTD_TO_Date forKey:@"TO_DATE"];
    [lmtdPost setPostData:sendData];
    
    XmwReportService* reportService = [[XmwReportService alloc] initWithPostData:lmtdPost withContext:@"lmtdCall"];
    
    [reportService fetchReportUsingSuccess:^(DotFormPost* formPosted, ReportPostResponse* reportResponse) {
        
        
        // we should receive report response data here
        lmtdDataArray = [[NSMutableArray alloc ] init];
        lmtdResponseData = reportResponse;
        [self addReportData:lmtdResponseData into:salesSliderData forColumn:@"LMTD"];
        
        NSLog(@"LMTD: %@",lmtdDataArray);
        
        
        [self maintainArrayFTD_MTD_YTD];
        
    }   fail:^(DotFormPost* formPosted, NSString* message) {
        // we should receive error response here
        
    }];
}
-(void)LFTD_NetworkCall
{
    NSLog(@"From date :- %@",LFTD_From_Date);
    NSLog(@"To date :- %@",LFTD_TO_Date);
    lftdPost = [[DotFormPost alloc]init];
    [lftdPost setAdapterId:AppConst_EMPLOYEE_SALES_AGGREGATE_CARD_DOC_ID];
    [lftdPost setAdapterType:@"CLASSLOADER"];
    [lftdPost setModuleId:AppConst_MOBILET_ID_DEFAULT];
    [lftdPost setDocDesc:@"LFTD"];
    NSMutableDictionary *sendData = [[NSMutableDictionary alloc]init];
    [sendData setObject:@"" forKey:@"CUSTOMER_ACCOUNT"];
    [sendData setObject:LFTD_From_Date forKey:@"FROM_DATE"];
    [sendData setObject:LFTD_TO_Date forKey:@"TO_DATE"];
    [lftdPost setPostData:sendData];
    
    XmwReportService* reportService = [[XmwReportService alloc] initWithPostData:lftdPost withContext:@"lftdCall"];
    
    [reportService fetchReportUsingSuccess:^(DotFormPost* formPosted, ReportPostResponse* reportResponse) {
        
        
        // we should receive report response data here
         lftdDataArray = [[NSMutableArray alloc ] init];
        lftdResponseData = reportResponse;
        
        [self addReportData:lftdResponseData into:salesSliderData forColumn:@"LFTD"];
        
        [self LMTD_NetworkCall];
        
    }   fail:^(DotFormPost* formPosted, NSString* message) {
        // we should receive error response here
        
    }];
}




#pragma mark : Collection View Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return numberOfCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.frame.size.width, 120*deviceHeightRation);
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    

    if (sortDone== true) {
        [blankView removeFromSuperview];
    }
    
    SalesCardDataTuple* tuple = [salesSliderData objectForKey:[sortedCardKeys objectAtIndex:indexPath.row]];
    
    NSString* displayName = @"";
    
    if([tuple.code length]>0) {
        displayName =  [NSString stringWithFormat:@"%@-%@", tuple.name,  tuple.code];
    } else {
        displayName = tuple.name;
    }
    
    salesCell = [NationalSalesAggregateCellView createInstance];
    
    [salesCell configureFor:displayName ftd:tuple.ftdAmount mtd:tuple.mtdAmount ytd:tuple.ytdAmount lftd:tuple.lftdAmount lmtd:tuple.lmtdAmount];
    
    NSInteger tagId = 1000 + indexPath.row;
    salesCell.tag = tagId;

    [[cell.contentView viewWithTag:tagId] removeFromSuperview];

    [cell.contentView addSubview:salesCell];
    cell.clipsToBounds = YES;
    

    //set under lable text
    NSString *text = @"Above data is a representation Total Sales of";
    
    NSLocale* currentDate = [NSLocale currentLocale];
    [[NSDate date] descriptionWithLocale:currentDate];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    NSString *currentYear =[dateFormatter stringFromDate:[NSDate date]];
    
    NSLog(@"Current Year : %@",currentYear);
    
    [underCellLbl removeFromSuperview];
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


-(void)addReportData:(ReportPostResponse*) reportData into:(NSMutableDictionary*) inDataSet forColumn:(NSString*) column
{
    // we need to reset data for first value of all tuple in the inDataSet
    for(NSString* key in inDataSet.allKeys) {
        SalesCardDataTuple* tupleObject = (SalesCardDataTuple*)[inDataSet objectForKey:key];
        if(tupleObject!=nil) {
            if([column isEqual:@"YTD"]) {
                tupleObject.ytdAmount = @"0.0";
            } else if([column isEqual:@"MTD"]) {
                tupleObject.mtdAmount = @"0.0";
            } if([column isEqual:@"LMTD"]) {
                tupleObject.lmtdAmount = @"0.0";
            } if([column isEqual:@"FTD"]) {
                tupleObject.ftdAmount = @"0.0";
            } if([column isEqual:@"LFTD"]) {
                tupleObject.lftdAmount = @"0.0";
            }
        }
    }
    
    NSArray* rowWiseTableData = reportData.tableData;
    
    for(NSArray* rowData in rowWiseTableData) {
        NSString* fieldName = [rowData objectAtIndex:0];
        SalesCardDataTuple* tupleObject = (SalesCardDataTuple*)[inDataSet objectForKey:fieldName];
        if(tupleObject==nil) {
            tupleObject = [[SalesCardDataTuple alloc] init];
            tupleObject.ytdAmount = @"0.0";
            tupleObject.mtdAmount = @"0.0";
            tupleObject.lmtdAmount = @"0.0";
            tupleObject.ftdAmount = @"0.0";
            tupleObject.lftdAmount = @"0.0";
            
            [inDataSet setObject:tupleObject forKey:fieldName];
        }
        tupleObject.name = [rowData objectAtIndex:0];
        tupleObject.code = [rowData objectAtIndex:1];
        
        if([column isEqual:@"YTD"]) {
            tupleObject.ytdAmount = [rowData objectAtIndex:2];
        } else if([column isEqual:@"MTD"]) {
            tupleObject.mtdAmount = [rowData objectAtIndex:2];
        } if([column isEqual:@"LMTD"]) {
            tupleObject.lmtdAmount = [rowData objectAtIndex:2];
        } if([column isEqual:@"FTD"]) {
            tupleObject.ftdAmount = [rowData objectAtIndex:2];
        } if([column isEqual:@"LFTD"]) {
            tupleObject.lftdAmount = [rowData objectAtIndex:2];
        }
    }
}

@end
