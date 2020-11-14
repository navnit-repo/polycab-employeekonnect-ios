//
//  SalesComparisonChart.m
//  QCMSProject
//
//  Created by Pradeep Singh on 1/18/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import "SalesComparisonChart.h"
#import "DotHBarChart.h"
#import "NetworkHelper.h"
#import "XmwReportService.h"
#import "DVCalendarConstants.h"
#import "ClientVariable.h"
#import "DotFormPost.h"
#import "DVAppDelegate.h"
#import "DotHorizontalBarCell.h"
#import "XmwReportService.h"
#import "LoadingView.h"

#import "SalesComparisonLegend.h"
#import "SalesIncentiveItemPopup.h"

#import "Styles.h"


#define KEY_salesSummaryMTD  @"salesSummaryMTD"
#define KEY_salesSummaryDivisionWiseLastMTD @"salesSummaryDivisionWiseLastMTD"

#define KEY_salesSummaryYTD  @"salesSummaryYTD"
#define KEY_salesSummaryDivisionWiseLastYTD @"salesSummaryDivisionWiseLastYTD"



@interface SalesCompareTuple : NSObject
@property NSString* firstValue;
@property NSString* uomFirstValue;

@property NSString* secondValue;
@property NSString* uomSecondValue;
@property NSString* division;
@end


@implementation SalesCompareTuple


@end



@interface SalesComparisonChart ()
{
    NSInteger currentlyDisplaying;
    
    NetworkHelper* networkHelper;
    
    ReportPostResponse* mtdCurrentYearSalesData;
    ReportPostResponse* currentMonthOnLastYearSalesData;
    NSMutableDictionary* mtdDivisionWiseSalesDataSet;
    NSArray* sortedMtdDataSet;
    NSNumber* mtdMaxBarValue;
    
    
    ReportPostResponse* ytdCurrentFinancialYearSalesData;
    ReportPostResponse* lastFinancialYearSalesData;
    NSMutableDictionary* ytdDivisionWiseSalesDataSet;
    NSArray* sortedYtdDataSet;
    NSNumber* ytdMaxBarValue;
    
    
    DotHBarChart* hBarChart;
    
    
    LoadingView* loadingView;
}

@end



@implementation SalesComparisonChart

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    mtdMaxBarValue = nil;
    ytdMaxBarValue = nil;
    
    
    if (isiPhoneXSMAX) {
        self.view.frame = CGRectMake(0, 64, 414, 832);
    }
    else if(isiPhoneXR) {
        self.view.frame = CGRectMake(0, 64, 414, 832);
    }
    
    else if(isiPhoneXS) {
        self.view.frame = CGRectMake(0, 64, 375, 748);
    }
    else if(isiPhone10) {
        self.view.frame = CGRectMake(0, 64, 375, 748);
    }
    
    else if(isiPhone6Plus) {
        self.view.frame = CGRectMake(0, 64, 414, 672);
    }
    else if(isiPhone6) {
        self.view.frame = CGRectMake(0, 64, 375, 600);
    } else if(isiPhone5) {
        self.view.frame = CGRectMake(0, 64, 320, 504);
    } else {
        // 0, 64, 320, 416
        self.view.frame = CGRectMake(0, 64, 320, 416);
    }
    
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    
    currentlyDisplaying = self.chartType; //MTD_ means, showing monthly YTD_ means
    
    
    

    hBarChart =  [DotHBarChart createInstance];
    hBarChart.frame = CGRectMake(10, 40, self.view.bounds.size.width - 20 , self.view.bounds.size.height - 60);
    hBarChart.needLeftAxis = NO;
    hBarChart.chartDataSource = self;
    hBarChart.chartDelegate = self;
    //hBarChart.horizontalAxisView.backgroundColor = [UIColor colorWithRed:0xee/255.0f green:0xc2/255.0f blue:0xb5/255.0f alpha:1.0f];
    hBarChart.horizontalAxisView.backgroundColor = [UIColor colorWithRed:247.0/255 green:244.0/255 blue:199.0/255 alpha:1.0];
    hBarChart.legendView.backgroundColor = [UIColor clearColor];
    
    [hBarChart updateLayout];
    
    [self.view addSubview: hBarChart];
    
    [hBarChart.barChartsTableView setBounces:NO];
    
    
    // using data received from login response user dashboard data
    [self useMTD_DataFromLoginResponse];

    
    /*
    if(self.chartType == MTD_SALES) {
        // for MTD
        [self fetchMTDSalesForCurrentFinancialYear];
    } else if(self.chartType == YTD_SALES) {
        // for MTD
        [self fetchYTDSalesForCurrentFinancialYear];
    }
     */
    
    [self setHeader];
    
}


-(void) useMTD_DataFromLoginResponse
{
    ClientVariable* clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    
   //  mtdCurrentYearSalesData = (ReportPostResponse*)[clientVariables.CLIENT_LOGIN_RESPONSE.dashboardData objectForKey:KEY_salesSummaryMTD];
    
    // for chart data (sales)
    // currentMonthOnLastYearSalesData = (ReportPostResponse*)[clientVariables.CLIENT_LOGIN_RESPONSE.dashboardData objectForKey:KEY_salesSummaryDivisionWiseLastMTD];
    
    if(mtdCurrentYearSalesData!=nil) {
        mtdDivisionWiseSalesDataSet = [[NSMutableDictionary alloc] init];
        [self addFirstSetData:mtdCurrentYearSalesData  into:mtdDivisionWiseSalesDataSet];
        
        if(currentMonthOnLastYearSalesData!=nil) {
            [self addSecondSetData:currentMonthOnLastYearSalesData  into:mtdDivisionWiseSalesDataSet];
            // sorted data
            sortedMtdDataSet = [self salesWiseDescendingKeys:mtdDivisionWiseSalesDataSet];
            mtdMaxBarValue = [self findMaxBarValue];
            [hBarChart.barChartsTableView reloadData];
            [self updateLegendView];
        } else {
            [self fetchMTDSalesForLastFinancialYear];
        }
    } else {
        [self fetchMTDSalesForCurrentFinancialYear];
    }
    
    
    /*
    
    ytdCurrentFinancialYearSalesData = (ReportPostResponse*)[clientVariables.CLIENT_LOGIN_RESPONSE.dashboardData objectForKey:KEY_salesSummaryYTD];
    
    // for chart data (sales)
    lastFinancialYearSalesData = (ReportPostResponse*)[clientVariables.CLIENT_LOGIN_RESPONSE.dashboardData objectForKey:KEY_salesSummaryDivisionWiseLastYTD];
     */
    
}



-(void) useYTD_DataFromLoginResponse
{
    ClientVariable* clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    
     
     ytdCurrentFinancialYearSalesData = (ReportPostResponse*)[clientVariables.CLIENT_LOGIN_RESPONSE.dashboardData objectForKey:KEY_salesSummaryYTD];
     
     // for chart data (sales)
     lastFinancialYearSalesData = (ReportPostResponse*)[clientVariables.CLIENT_LOGIN_RESPONSE.dashboardData objectForKey:KEY_salesSummaryDivisionWiseLastYTD];

    
    if(ytdCurrentFinancialYearSalesData!=nil) {
        ytdDivisionWiseSalesDataSet = [[NSMutableDictionary alloc] init];
        [self addFirstSetData:ytdCurrentFinancialYearSalesData  into:ytdDivisionWiseSalesDataSet];
        
        if(lastFinancialYearSalesData!=nil) {
            [self addSecondSetData:lastFinancialYearSalesData  into:ytdDivisionWiseSalesDataSet];
            
            // sorted data
            sortedYtdDataSet = [self salesWiseDescendingKeys:ytdDivisionWiseSalesDataSet];
            
            ytdMaxBarValue = [self findMaxBarValue];
            
            [hBarChart.barChartsTableView reloadData];
            [self updateLegendView];
        } else {
            [self fetchYTDSalesForLastFinancialYear];
        }
        
    } else {
        [self fetchYTDSalesForCurrentFinancialYear];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) setHeader
{
    //[self.navigationController setTitle:@"Sales Camparision"];
    // self.navigationController
    // self.navigationController setT
    
    self.navigationController.navigationBar.translucent = NO;
    
    UILabel*  titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 40)];
    titleLabel.text = @"Sales Camparison";
    titleLabel.textColor = [Styles headerTextColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.navigationItem setTitleView: titleLabel];
    
    // self.navigationItem.hidesBackButton = YES;
    
    
    
    /*
   UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(backHandler:)];
    backButton.tintColor = [Styles barButtonTextColor];
    [self.navigationItem setLeftBarButtonItem:backButton];
     */
    
    
    self.navigationController.navigationBar.tintColor = [Styles barButtonTextColor];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void) fetchMTDSalesForCurrentFinancialYear
{
    // for current financial year
    // for previous financial year it will be -1
    // for before that -2 go on
    NSNumber* yearReference = [[NSUserDefaults standardUserDefaults] objectForKey:RELATIVE_FINANCIAL_YEAR];
    if(yearReference==nil) {
        yearReference = [NSNumber numberWithInt:0];
        [[NSUserDefaults standardUserDefaults] setObject:yearReference forKey:RELATIVE_FINANCIAL_YEAR];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    NSDate* today = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =[gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
    
    NSString* todayAsString = [NSString stringWithFormat:@"%.2ld/%.2ld/%.4ld", [weekdayComponents day], [weekdayComponents month], [weekdayComponents year] + yearReference.intValue ];
    
    NSString* firstOfThisMonth = [NSString stringWithFormat:@"01/%.2ld/%.4ld", [weekdayComponents month], [weekdayComponents year] + yearReference.intValue ];
    
    NSLog(@"SalesComparisionChart:fetchMTDSalesForCurrentFinancialYear : FromDate=%@  , ToDate=%@", firstOfThisMonth,  todayAsString);

    
    DotFormPost* formPostObject = [self salesReportFormPost:firstOfThisMonth toDate:todayAsString];
    
    XmwReportService* reportService = [[XmwReportService alloc] initWithPostData:formPostObject withContext:@"fetchMTDSalesForCurrentFinancialYear"];
    
    
    loadingView = [LoadingView loadingViewInView:self.view];
    
    [reportService fetchReportUsingSuccess:^(DotFormPost* formPosted, ReportPostResponse* reportResponse) {
            // we should receive report response data here
        mtdCurrentYearSalesData = reportResponse;
        mtdDivisionWiseSalesDataSet = [[NSMutableDictionary alloc] init];
        [self addFirstSetData:mtdCurrentYearSalesData  into:mtdDivisionWiseSalesDataSet];
        
        // [hBarChart.barChartsTableView reloadData];
        
        [self fetchMTDSalesForLastFinancialYear];
        
    }
     
        fail:^(DotFormPost* formPosted, NSString* message) {
            // we should receive error response here
        [loadingView removeView];
        
        
    }];
}


-(void) fetchMTDSalesForLastFinancialYear
{
    // for current financial year
    // for previous financial year it will be -1
    // for before that -2 go on
    NSNumber* yearReference = [[NSUserDefaults standardUserDefaults] objectForKey:RELATIVE_FINANCIAL_YEAR];
    if(yearReference==nil) {
        yearReference = [NSNumber numberWithInt:0];
        [[NSUserDefaults standardUserDefaults] setObject:yearReference forKey:RELATIVE_FINANCIAL_YEAR];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    NSDate* today = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =[gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
    
    // int daysInThisMonthLastYear = [self getNoDays :([weekdayComponents month]-1) :  ([weekdayComponents year] - 1)];

    NSString* thisDayOfMonthAsString = [NSString stringWithFormat:@"%.2ld/%.2ld/%.4ld", [weekdayComponents day], [weekdayComponents month], [weekdayComponents year] - 1 + yearReference.intValue];
    
    NSString* firstOfThisMonthLastYear = [NSString stringWithFormat:@"01/%.2ld/%.4ld", [weekdayComponents month], ([weekdayComponents year] - 1 + yearReference.intValue) ];
    
    NSLog(@"SalesComparisionChart:fetchMTDSalesForLastFinancialYear : FromDate=%@  , ToDate=%@", firstOfThisMonthLastYear,  thisDayOfMonthAsString);
    
    
     DotFormPost* formPostObject = [self salesReportFormPost:firstOfThisMonthLastYear toDate:thisDayOfMonthAsString];
    
    XmwReportService* reportService = [[XmwReportService alloc] initWithPostData:formPostObject withContext:@"fetchMTDSalesForLastFinancialYear"];
    

    [reportService fetchReportUsingSuccess:^(DotFormPost* formPosted, ReportPostResponse* reportResponse) {
        
        [loadingView removeView];
        
        // we should receive report response data here
        
        currentMonthOnLastYearSalesData = reportResponse;
        [self addSecondSetData:currentMonthOnLastYearSalesData  into:mtdDivisionWiseSalesDataSet];
        
        // sorted data
        sortedMtdDataSet = [self salesWiseDescendingKeys:mtdDivisionWiseSalesDataSet];
        
        mtdMaxBarValue = [self findMaxBarValue];
        
        [hBarChart.barChartsTableView reloadData];
        [self updateLegendView];
        
        
    }
       fail:^(DotFormPost* formPosted, NSString* message) {
        // we should receive error response here
        [loadingView removeView];
        
        
    }];
   
}

-(void) fetchYTDSalesForCurrentFinancialYear
{
    
    
    // for current financial year
    // for previous financial year it will be -1
    // for before that -2 go on
    NSNumber* yearReference = [[NSUserDefaults standardUserDefaults] objectForKey:RELATIVE_FINANCIAL_YEAR];
    if(yearReference==nil) {
        yearReference = [NSNumber numberWithInt:0];
        [[NSUserDefaults standardUserDefaults] setObject:yearReference forKey:RELATIVE_FINANCIAL_YEAR];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSDate* today = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =[gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
    
    
    // if month is jan (1), Feb (2), Mar(3)
    NSString* firstDayOfCurrentFinancialYear = [NSString stringWithFormat:@"01/04/%.4ld", ([weekdayComponents month] > 3) ? [weekdayComponents year] + yearReference.intValue : [weekdayComponents year] - 1 + yearReference.intValue];
    
    
    NSString* todayAsString = [NSString stringWithFormat:@"%.2ld/%.2ld/%.4ld", [weekdayComponents day], [weekdayComponents month], [weekdayComponents year] + yearReference.intValue ];
   
    //
    // of year reference is not current financial year, then we should use 31 March
    //
    if(yearReference.intValue<0) {
        todayAsString = [NSString stringWithFormat:@"31/03/%.4ld", ([weekdayComponents month] > 3) ? [weekdayComponents year] + yearReference.intValue + 1: [weekdayComponents year] + yearReference.intValue];
    }
    
    NSLog(@"SalesComparisionChart:fetchYTDSalesForCurrentFinancialYear : FromDate=%@  , ToDate=%@", firstDayOfCurrentFinancialYear,  todayAsString);
    
    
    DotFormPost* formPostObject = [self salesReportFormPost:firstDayOfCurrentFinancialYear toDate:todayAsString];
    
    
    XmwReportService* reportService = [[XmwReportService alloc] initWithPostData:formPostObject withContext:@"fetchYTDSalesForCurrentFinancialYear"];
    
    loadingView = [LoadingView loadingViewInView:self.view];
    
    
    [reportService fetchReportUsingSuccess:^(DotFormPost* formPosted, ReportPostResponse* reportResponse) {
        // we should receive report response data here
        ytdCurrentFinancialYearSalesData = reportResponse;
        
        ytdDivisionWiseSalesDataSet = [[NSMutableDictionary alloc] init];
        [self addFirstSetData:ytdCurrentFinancialYearSalesData  into:ytdDivisionWiseSalesDataSet];
        
        [self fetchYTDSalesForLastFinancialYear];
        
    }   fail:^(DotFormPost* formPosted, NSString* message) {
        // we should receive error response here
        [loadingView removeView];
        
        
    }];
    
}


-(void) fetchYTDSalesForLastFinancialYear
{
    // for current financial year
    // for previous financial year it will be -1
    // for before that -2 go on
    NSNumber* yearReference = [[NSUserDefaults standardUserDefaults] objectForKey:RELATIVE_FINANCIAL_YEAR];
    if(yearReference==nil) {
        yearReference = [NSNumber numberWithInt:0];
        [[NSUserDefaults standardUserDefaults] setObject:yearReference forKey:RELATIVE_FINANCIAL_YEAR];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    
    NSDate* today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =[gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
    
    // if month is jan (1), Feb (2), Mar(3)
    NSString* firstDayOfLastFinancialYear = [NSString stringWithFormat:@"01/04/%.4ld", ([weekdayComponents month] > 3) ? [weekdayComponents year] -1 + yearReference.intValue: [weekdayComponents year] - 2 + yearReference.intValue];
    
    
    NSString* thisDayOfLastFinancialYear = [NSString stringWithFormat:@"%.2ld/%.2ld/%.4ld", [weekdayComponents day], [weekdayComponents month],([weekdayComponents month] > 3) ? [weekdayComponents year] - 1 +  yearReference.intValue: [weekdayComponents year] - 1 + yearReference.intValue];
    
    if(yearReference.intValue < 0) {
        thisDayOfLastFinancialYear = [NSString stringWithFormat:@"31/03/%.4ld", ([weekdayComponents month] > 3) ? [weekdayComponents year]  + yearReference.intValue: [weekdayComponents year] - 1 + yearReference.intValue];
    }
    
    
     NSLog(@"SalesComparisionChart:fetchYTDSalesForLastFinancialYear : FromDate=%@  , ToDate=%@", firstDayOfLastFinancialYear,  thisDayOfLastFinancialYear);
    
    
    DotFormPost* formPostObject = [self salesReportFormPost:firstDayOfLastFinancialYear toDate:thisDayOfLastFinancialYear];
    
    
    XmwReportService* reportService = [[XmwReportService alloc] initWithPostData:formPostObject withContext:@"fetchYTDSalesForLastFinancialYear"];
    
    [reportService fetchReportUsingSuccess:^(DotFormPost* formPosted, ReportPostResponse* reportResponse) {
        
        [loadingView removeView];
        
        // we should receive report response data here
        lastFinancialYearSalesData = reportResponse;
        
        [self addSecondSetData:lastFinancialYearSalesData  into:ytdDivisionWiseSalesDataSet];
        
        // sorted data
        sortedYtdDataSet = [self salesWiseDescendingKeys:ytdDivisionWiseSalesDataSet];

        ytdMaxBarValue = [self findMaxBarValue];
        
        [hBarChart.barChartsTableView reloadData];
        [self updateLegendView];
        
    }   fail:^(DotFormPost* formPosted, NSString* message) {
        // we should receive error response here
        [loadingView removeView];
        
        
    }];
    
    

}


-(int) getNoDays :(int) inMonth :(int) inYear
{
    NSNumber* limit = [[DVCalendarConstants daysInMonth] objectAtIndex:inMonth];
    if ((inMonth == 1) && (inYear % 4 == 0)) {
        return  29;
    } else {
        return limit.intValue;
    }
}


-(DotFormPost*) salesReportFormPost:(NSString*) fromDate toDate:(NSString*) toDate
{
    
    ClientVariable* clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    
    DotForm  *dotForm = (DotForm*) [clientVariables.DOT_FORM_MAP objectForKey: @"DOT_FORM_26"] ;
    
    DotFormPost *dotFormPost = [[DotFormPost alloc]init];
    NSMutableDictionary *postData = [[NSMutableDictionary alloc]init];
    [postData setObject:toDate forKey:@"TO_DATE"];
    [postData setObject:fromDate forKey:@"FROM_DATE"];
    
   [postData setObject:@"" forKey:@"SPART"];
    
    
    NSMutableDictionary *displayData = [[NSMutableDictionary alloc]init];
    [displayData setObject:toDate forKey:@"TO_DATE"];
    [displayData setObject:fromDate forKey:@"FROM_DATE"];
   [displayData setObject:@"All" forKey:@"SPART"];
    
    
    [dotFormPost setAdapterType:dotForm.adapterType];
    [dotFormPost setAdapterId:dotForm.submitAdapterId];
    [dotFormPost setModuleId: [DVAppDelegate currentModuleContext]];
    [dotFormPost setDocId:dotForm.formId];
    [dotFormPost setPostData:postData];
    [dotFormPost setDisplayData:displayData];
    
    return dotFormPost;
}
-(NSString*)formateCurrency:(NSString *)actualAmount{
    
    float shortenedAmount = [actualAmount floatValue];
    NSString *suffix = @"";
    
    suffix = @"Cr";
    shortenedAmount /= 10000000.0f;
    
    /*
     //
     // Pradeep 2020-11-12 bad implementation, there should be only one unit
     // Unit suppose to computed from the max value, we will do that later
     //
    float currency = [actualAmount floatValue];
    if(currency >= 10000000.0f) {
        suffix = @"Cr";
        shortenedAmount /= 10000000.0f;
    }
    else if(currency >= 100000.0f) {
        suffix = @"L";
        shortenedAmount /= 100000.0f;
    }
    else if(currency >= 1000.0f) {
        suffix = @"K";
        shortenedAmount /= 1000.0f;
    }
     */
    
    NSString *requiredString = [NSString stringWithFormat:@"%0.2f%@", shortenedAmount, suffix];
    return requiredString;
    
}
-(void) addFirstSetData:(ReportPostResponse*) reportData into:(NSMutableDictionary*) dataSet
{
    NSArray* rowWiseTableData = reportData.tableData;
    
    for(NSArray* rowData in rowWiseTableData) {
        NSString* divisionName = [rowData objectAtIndex:0];
        SalesCompareTuple* tupleObject = (SalesCompareTuple*)[dataSet objectForKey:divisionName];
        if(tupleObject==nil) {
            tupleObject = [[SalesCompareTuple alloc] init];
            tupleObject.secondValue = @"0.0";
            if([divisionName compare:@"All" options:NSCaseInsensitiveSearch] != NSOrderedSame) {
                [dataSet setObject:tupleObject forKey:divisionName];
            }
        }
        
        // [self formateCurrency:[ftdData objectAtIndex:2]];
        // tupleObject.firstValue = [rowData objectAtIndex:2];
        //[[NSString stringWithFormat:@"%@",rupee]stringByAppendingString:ftd];
        tupleObject.firstValue = [self formateCurrency:[rowData objectAtIndex:2]];
        tupleObject.uomFirstValue = [self formateCurrency:[rowData objectAtIndex:2]];
        tupleObject.division = divisionName;
        
        
    }
}

-(void) addSecondSetData:(ReportPostResponse*) reportData into:(NSMutableDictionary*) dataSet
{
    NSArray* rowWiseTableData = reportData.tableData;
    
    for(NSArray* rowData in rowWiseTableData) {
        NSString* divisionName = [rowData objectAtIndex:0];
        SalesCompareTuple* tupleObject = (SalesCompareTuple*)[dataSet objectForKey:divisionName];
        if(tupleObject==nil) {
            tupleObject = [[SalesCompareTuple alloc] init];
            tupleObject.firstValue = @"0.0";
            
            // Pradeep: 2020-11-13, do not add if it is 'All' in it
            // does not make sense to show bar for 'All'
            // as data then cannot be compared
            if([divisionName compare:@"All" options:NSCaseInsensitiveSearch] != NSOrderedSame) {
                [dataSet setObject:tupleObject forKey:divisionName];
            }
        }
        tupleObject.secondValue = [self formateCurrency:[rowData objectAtIndex:2]];
        tupleObject.uomSecondValue = [self formateCurrency:[rowData objectAtIndex:2]];
        tupleObject.division = divisionName;
    }
    
}

-(NSArray*) salesWiseDescendingKeys: (NSMutableDictionary*) dataSet
{
    NSArray* unSortedArray = dataSet.allValues;

    NSArray* sortedElementIdArray = [unSortedArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        SalesCompareTuple* objcA = (SalesCompareTuple*) a;
        SalesCompareTuple* objcB = (SalesCompareTuple*) b;
        
        if(objcA.firstValue==nil)
            objcA.firstValue = @"0";
        
        if(objcB.firstValue==nil)
            objcB.firstValue = @"0";
        
        return [objcA.firstValue doubleValue] < [objcB.firstValue doubleValue];
    }];
    return sortedElementIdArray;
}

#pragma mark - DotHBarChartDataSource

-(NSInteger) dotHBarChartNumberOfBars:(DotHBarChart *)barChart
{
    if(currentlyDisplaying == MTD_SALES) {
        return [[mtdDivisionWiseSalesDataSet allKeys] count];
    } else if(currentlyDisplaying == YTD_SALES) {
        return [[ytdDivisionWiseSalesDataSet allKeys] count];
    }
    
    return 0;
}

// since it is comparision chart for current year data viz a viz last financial year data,
// we have two rows
-(NSInteger) dotHBarChart:(DotHBarChart *)barChart noOfSubBarFor:(NSInteger) index
{
    return 3.0;
}

-(NSInteger) dotHBarChartSubBarWidth:(DotHBarChart *)barChart
{
    return 15.0;
}

-(NSNumber*) dotHBarChart:(DotHBarChart *)barChart barValueFor:(NSInteger) index
{
    if(currentlyDisplaying == MTD_SALES) {
        NSArray* divisionArray = [mtdDivisionWiseSalesDataSet allKeys];
        NSString* divisionName = [divisionArray objectAtIndex:index];
        SalesCompareTuple* tuple = (SalesCompareTuple*)[mtdDivisionWiseSalesDataSet objectForKey:divisionName];
        
        return [NSNumber numberWithDouble:[tuple.firstValue doubleValue]];
        
    } else if(currentlyDisplaying == YTD_SALES) {
        NSArray* divisionArray = [ytdDivisionWiseSalesDataSet allKeys];
        NSString* divisionName = [divisionArray objectAtIndex:index];
        SalesCompareTuple* tuple = (SalesCompareTuple*)[ytdDivisionWiseSalesDataSet objectForKey:divisionName];
        
        return [NSNumber numberWithDouble:[tuple.firstValue doubleValue]];
    }

    return nil;
}

-(NSNumber*) dotHBarChart:(DotHBarChart *)barChart maxBarValueFor:(NSInteger) index
{
    NSNumber* maxValue = (NSNumber*) [self findMaxBarValue];

    return maxValue;
}

-(NSString*) dotHBarChart:(DotHBarChart *)barChart axisValueFor:(NSInteger) index
{
    if(currentlyDisplaying == MTD_SALES) {
        
       //  NSArray* divisionArray = [mtdDivisionWiseSalesDataSet allKeys];
        // NSString* divisionName = [divisionArray objectAtIndex:index];
        // SalesCompareTuple* tuple = (SalesCompareTuple*)[mtdDivisionWiseSalesDataSet objectForKey:divisionName];
        
        SalesCompareTuple* chartDataObject = (SalesCompareTuple*)[sortedMtdDataSet objectAtIndex:index];
        return chartDataObject.division;
        
    } else if(currentlyDisplaying == YTD_SALES) {
        // NSArray* divisionArray = [ytdDivisionWiseSalesDataSet allKeys];
        // NSString* divisionName = [divisionArray objectAtIndex:index];
        // SalesCompareTuple* tuple = (SalesCompareTuple*)[ytdDivisionWiseSalesDataSet objectForKey:divisionName];
        
        SalesCompareTuple* chartDataObject = (SalesCompareTuple*)[sortedYtdDataSet objectAtIndex:index];
        return chartDataObject.division;
    }

    return @"";
}

-(NSString*) dotHBarChart:(DotHBarChart *)barChart unitOfMeasureValueFor:(NSInteger)index
{
    
    return @"Lakhs";
}


#pragma  mark - DotHBarChartDelegate

-(UIView*) dotHBarChart:(DotHorizontalBarCell *)barCell partViewForVerticalAxis:(NSInteger) index
{
    UIView* myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    myView.backgroundColor = [UIColor clearColor];
    
    
    return myView;
}

-(void) dotHBarChart:(DotHorizontalBarCell *)barCell userDefAxisView:(UIView*) udfView configurePartAxisView:(NSInteger) index
{

    
    return;
}

-(UIView*) dotHBarChart:(DotHorizontalBarCell *)barCell horizontalBarView:(NSInteger) index
{
    UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 200, 20)];
    textLabel.backgroundColor = [UIColor clearColor];
    
    textLabel.font = [UIFont systemFontOfSize:11];
    textLabel.text = [self dotHBarChart:hBarChart axisValueFor:index];
    
    DotHBar* hBar = [barCell addSubBar:hBarChart forValue:0 maxValue:100];
    hBar.backgroundColor = [UIColor clearColor];
    
    hBar = [barCell addSubBar:hBarChart forValue:0 maxValue:100];
  //  [UIColor colorWithRed:(49.0/255) green:(221.0/255) blue:(179.0/255) alpha:(1)];
   // [UIColor colorWithRed:(79.0/255) green:(121.0/255) blue:(219.0/255) alpha:(1)];
  //  hBar.backgroundColor = [UIColor colorWithRed:0x67/255.0f green:0xaa/255.0f blue:0x39/255.0f alpha:1.0f];   // 67aa39 db3131
    
    hBar.backgroundColor =[UIColor colorWithRed:(49.0/255) green:(221.0/255) blue:(179.0/255) alpha:(1)];
    
    hBar = [barCell addSubBar:hBarChart forValue:0 maxValue:100];
 //   hBar.backgroundColor = [UIColor colorWithRed:0xdb/255.0f green:0x31/255.0f blue:0x31/255.0f alpha:1.0f];;
    hBar.backgroundColor = [UIColor colorWithRed:(79.0/255) green:(121.0/255) blue:(219.0/255) alpha:(1)];
    return textLabel;
}

-(void) dotHBarChart:(DotHorizontalBarCell *)barCell userDefView:(UIView*) udfView configureHorizontalBarView:(NSInteger) index
{
    UILabel* textLabel = (UILabel*)udfView;
    NSString* divisionWithCode = [self dotHBarChart:hBarChart axisValueFor:index];
    NSArray* parts = [divisionWithCode componentsSeparatedByString:@"-"];
    textLabel.text = [parts objectAtIndex:0];
    [textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    
    if(currentlyDisplaying == MTD_SALES) {
        SalesCompareTuple* tuple = (SalesCompareTuple*)[sortedMtdDataSet objectAtIndex:index];
       
        NSNumber* firstValue = [NSNumber numberWithDouble:[tuple.firstValue doubleValue]];
        [barCell updateSubBar:hBarChart forValue:firstValue.doubleValue maxValue:mtdMaxBarValue.doubleValue subBarIndex:1];
        
        NSNumber* secondValue = [NSNumber numberWithDouble:[tuple.secondValue doubleValue]];
        [barCell updateSubBar:hBarChart forValue:secondValue.doubleValue maxValue:mtdMaxBarValue.doubleValue subBarIndex:2];
        
    } else if(currentlyDisplaying == YTD_SALES) {
        SalesCompareTuple* tuple = (SalesCompareTuple*)[sortedYtdDataSet objectAtIndex:index];
        
        NSNumber* firstValue = [NSNumber numberWithDouble:[tuple.firstValue doubleValue]];
        [barCell updateSubBar:hBarChart forValue:firstValue.doubleValue maxValue:ytdMaxBarValue.doubleValue subBarIndex:1];
        
        NSNumber* secondValue = [NSNumber numberWithDouble:[tuple.secondValue doubleValue]];
        [barCell updateSubBar:hBarChart forValue:secondValue.doubleValue maxValue:ytdMaxBarValue.doubleValue subBarIndex:2];
    }
    
}


-(void)dotHBarChart:(DotHBarChart *)barChart didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SalesCompareTuple* tuple = nil;
    NSMutableArray* lineItemArrayForPopup = [[NSMutableArray alloc] init];
    
    if(currentlyDisplaying == MTD_SALES) {
        tuple = (SalesCompareTuple*)[sortedMtdDataSet objectAtIndex:indexPath.row];
        
        NSArray* parts = [tuple.division componentsSeparatedByString:@"-"];
        [lineItemArrayForPopup addObject:[NSArray arrayWithObjects:@"LOB Name:", [parts objectAtIndex:0], nil]];
       // [lineItemArrayForPopup addObject:[NSArray arrayWithObjects:@"Amount in lacs", nil]];
        [lineItemArrayForPopup addObject:[NSArray arrayWithObjects:@"Current Year Sale:", tuple.firstValue, nil]];
        [lineItemArrayForPopup addObject:[NSArray arrayWithObjects:@"Last Year Sale:", tuple.secondValue, nil]];
        
    } else if(currentlyDisplaying == YTD_SALES) {
        tuple = (SalesCompareTuple*)[sortedYtdDataSet objectAtIndex:indexPath.row];
        NSArray* parts = [tuple.division componentsSeparatedByString:@"-"];
        
        [lineItemArrayForPopup addObject:[NSArray arrayWithObjects:@"LOB Name:", [parts objectAtIndex:0], nil]];
     //   [lineItemArrayForPopup addObject:[NSArray arrayWithObjects:@"Amount in lacs", nil]];
        [lineItemArrayForPopup addObject:[NSArray arrayWithObjects:@"Current Year Sale:", tuple.firstValue, nil]];
        [lineItemArrayForPopup addObject:[NSArray arrayWithObjects:@"Last Year Sale:", tuple.secondValue, nil]];
    }
    
    // SalesIncentiveItemPopup* contentPopup = [SalesIncentiveItemPopup createInstance];
    // contentPopup.lineItemData = lineItemArrayForPopup;
    
    SalesIncentiveItemPopup* contentPopup = [SalesIncentiveItemPopup createInstanceWithData:lineItemArrayForPopup];
    
    [[UIApplication sharedApplication].keyWindow addSubview:contentPopup];

}

-(NSNumber*) findMaxBarValue
{
    NSDictionary* dataSet = nil;
    
    if(currentlyDisplaying == MTD_SALES) {
        dataSet = mtdDivisionWiseSalesDataSet;
    } else if(currentlyDisplaying == YTD_SALES) {
        dataSet = ytdDivisionWiseSalesDataSet;
    }

    
    NSNumber* maxValue = [NSNumber numberWithInt:0];
    
    if(dataSet!=nil) {
        NSArray* divisionArray = [dataSet allKeys];
        for(NSString* division in divisionArray) {
            SalesCompareTuple* tuple = (SalesCompareTuple*)[dataSet objectForKey:division];
           
            NSNumber* tempNumber = [NSNumber numberWithDouble:[tuple.firstValue doubleValue]];
            if([maxValue compare:tempNumber]==NSOrderedAscending) {
                maxValue = tempNumber;
            }
            
            tempNumber = [NSNumber numberWithDouble:[tuple.secondValue doubleValue]];
            if([maxValue compare:tempNumber]==NSOrderedAscending) {
                maxValue = tempNumber;
            }
        }
    }
    
    NSLog(@"Max Value is %@", [maxValue description]);
    
    NSNumber* retMaxValue = [NSNumber numberWithDouble:[self computeMaxValueForAxis:maxValue.doubleValue]];
    
    return retMaxValue;
}


-(IBAction)backHandler:(id)sender
{
    [ [self navigationController]  popViewControllerAnimated:YES];
}


- (IBAction)segmentControlAction:(id)sender {
    UISegmentedControl* segCtrl = (UISegmentedControl*) sender;
    // NSLog(@"Segment control selected value: %d", segCtrl.selectedSegmentIndex );
    
    if(segCtrl.selectedSegmentIndex==0) {
        currentlyDisplaying = MTD_SALES;
        self.chartType = MTD_SALES;
        if(sortedMtdDataSet==nil) {
            [self fetchMTDSalesForCurrentFinancialYear];
        } else {
            [hBarChart.barChartsTableView reloadData];
        }
    } else {
        currentlyDisplaying = YTD_SALES;
        self.chartType = YTD_SALES;
        
        [self useYTD_DataFromLoginResponse];
        /*
        if(sortedYtdDataSet==nil) {
            [self fetchYTDSalesForCurrentFinancialYear];
        } else {
            [hBarChart.barChartsTableView reloadData];
        }*/
    }
    [self updateLegendView];
 }


-(void) createLegendView
{
    UIView* customSubView = [hBarChart.legendView viewWithTag:1001];
    if(customSubView==nil) {
        SalesComparisonLegend* customLegend = [SalesComparisonLegend createInstance];
        [customLegend autoLayout];
        
        customLegend.tag = 1001;
        [hBarChart.legendView addSubview:customLegend];
    }
}

-(void) updateLegendView
{
    SalesComparisonLegend* customLegend = (SalesComparisonLegend*)[hBarChart.legendView viewWithTag:1001];
    if(customLegend==nil) {
        customLegend = [SalesComparisonLegend createInstance];
        [customLegend autoLayout];
        customLegend.tag = 1001;
        [hBarChart.legendView addSubview:customLegend];
    }
    
    if(self.chartType== MTD_SALES) {
        customLegend.firstLegendLabel.text =  [self currentFinancialYear];
        customLegend.secondLegendLabel.text =  [self lastFinancialYear];
        
        if(mtdCurrentYearSalesData!=nil) {
            customLegend.mtdCurrentTotal.text = [NSString stringWithFormat:@"Total: %@", [mtdCurrentYearSalesData.headerData objectForKey:@"TOTAL_AMT"]];
        } else {
            customLegend.mtdCurrentTotal.text = @"";
        }
        
        if(currentMonthOnLastYearSalesData!=nil) {
            customLegend.mtdLastTotal.text = [NSString stringWithFormat:@"Total: %@", [currentMonthOnLastYearSalesData.headerData objectForKey:@"TOTAL_AMT"]];
        } else {
            customLegend.mtdLastTotal.text = @"";
        }
        
        [hBarChart updateHorizontalAxis:0.0 :mtdMaxBarValue.doubleValue];
        
    } else {
        customLegend.firstLegendLabel.text =  [self currentFinancialYear];
        customLegend.secondLegendLabel.text = [self lastFinancialYear];
        
        
        if(ytdCurrentFinancialYearSalesData!=nil) {
            customLegend.mtdCurrentTotal.text = [NSString stringWithFormat:@"Total: %@", [ytdCurrentFinancialYearSalesData.headerData objectForKey:@"TOTAL_AMT"]];
        } else {
            customLegend.mtdCurrentTotal.text = @"";
        }
        
        
        if(lastFinancialYearSalesData !=nil) {
            customLegend.mtdLastTotal.text = [NSString stringWithFormat:@"Total: %@", [lastFinancialYearSalesData.headerData objectForKey:@"TOTAL_AMT"]];
        } else {
            customLegend.mtdLastTotal.text = @"";
        }
        
        [hBarChart updateHorizontalAxis:0.0 :ytdMaxBarValue.doubleValue];
        
    }
}

-(double) computeMaxValueForAxis:(double) dataMaxValue
{
    // 1, 2, 4, 5, 8, 10
    
    NSInteger baseTenLog = floor(log10(dataMaxValue));
    double baseValue = pow(10, baseTenLog);
    
    if(baseValue>dataMaxValue) {
        NSLog(@"computeMaxValueForAxis (%f) = %f", dataMaxValue, (baseValue*1) );
        return baseValue*1;
    }
    
    if(baseValue*2>dataMaxValue) {
        NSLog(@"computeMaxValueForAxis (%f) = %f", dataMaxValue, (baseValue*2) );
        return baseValue*2;
    }
    
    if(baseValue*4>dataMaxValue) {
        NSLog(@"computeMaxValueForAxis (%f) = %f", dataMaxValue, (baseValue*4) );
        return baseValue*4;
    }
    
    if(baseValue*5>dataMaxValue) {
        NSLog(@"computeMaxValueForAxis (%f) = %f", dataMaxValue, (baseValue*5) );
        return baseValue*5;
    }
    
    
    if(baseValue*8>dataMaxValue) {
        NSLog(@"computeMaxValueForAxis (%f) = %f", dataMaxValue, (baseValue*8) );
        return baseValue*8;
    }
    
    if(baseValue*10>dataMaxValue) {
        NSLog(@"computeMaxValueForAxis (%f) = %f", dataMaxValue, (baseValue*10) );
        return baseValue*10;
    }
    
    return  dataMaxValue;
    
}


-(NSString*) currentFinancialYear
{
    
    // for current financial year
    // for previous financial year it will be -1
    // for before that -2 go on
    NSNumber* yearReference = [[NSUserDefaults standardUserDefaults] objectForKey:RELATIVE_FINANCIAL_YEAR];
    if(yearReference==nil) {
        yearReference = [NSNumber numberWithInt:0];
        [[NSUserDefaults standardUserDefaults] setObject:yearReference forKey:RELATIVE_FINANCIAL_YEAR];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    NSDate* today = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =[gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
    
    // if month is jan (1), Feb (2), Mar(3)
    NSString* currentFY = [NSString stringWithFormat:@"(%.4ld - %.4ld)", ([weekdayComponents month] > 3) ? [weekdayComponents year] + yearReference.intValue : [weekdayComponents year] - 1 + yearReference.intValue,  ([weekdayComponents month] > 3) ? ([weekdayComponents year] + 1 + yearReference.intValue) : [weekdayComponents year] + yearReference.intValue ];
    
    return currentFY;
}

-(NSString*) lastFinancialYear
{
    // for current financial year
    // for previous financial year it will be -1
    // for before that -2 go on
    NSNumber* yearReference = [[NSUserDefaults standardUserDefaults] objectForKey:RELATIVE_FINANCIAL_YEAR];
    if(yearReference==nil) {
        yearReference = [NSNumber numberWithInt:0];
        [[NSUserDefaults standardUserDefaults] setObject:yearReference forKey:RELATIVE_FINANCIAL_YEAR];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSDate* today = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =[gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
    
    // if month is jan (1), Feb (2), Mar(3)
    NSString* lastFY = [NSString stringWithFormat:@"(%.4ld - %.4ld)", ([weekdayComponents month] > 3) ? [weekdayComponents year] -1 + yearReference.intValue : [weekdayComponents year] - 2 + yearReference.intValue,  ([weekdayComponents month] > 3) ? ([weekdayComponents year] + yearReference.intValue) : [weekdayComponents year] - 1 + yearReference.intValue ];
    
    return lastFY;

}

@end
