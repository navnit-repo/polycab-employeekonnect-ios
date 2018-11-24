//
//  SalesIncentiveChart.m
//  QCMSProject
//
//  Created by Pradeep Singh on 2/3/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import "SalesIncentiveChart.h"
#import "DotDualAxisHBarChart.h"
#import "Styles.h"
#import "DotFormPost.h"
#import "ClientVariable.h"
#import "DVAppDelegate.h"
#import "XmwReportService.h"
#import "LoadingView.h"
#import "ReportPostResponse.h"
#import "DualAxisHorizontalBarCell.h"
#import "SalesIncentiveLegend.h"
#import "SalesIncentiveItemPopup.h"
#import "DVCalendarConstants.h"


#define MTD_INCENTIVE 0
#define QTD_INCENTIVE 1
#define YTD_INCENTIVE 2

#define kTargetTag 3978

#define KEY_salesIncentiveSummaryDivisionWiseMonthly @"salesIncentiveSummaryDivisionWiseMonthly"


@interface SalesIncentiveDataTuple : NSObject
@property NSString* schemeName;
@property NSString* rebateAgreementNo;
@property NSNumber* saleAchieved;
@property NSNumber* targetToBeAchieved;
@property NSNumber* incentiveAccrued;
@property BOOL targetSet;
@property NSString* rateUnit;
@property NSNumber* possibleIncentive;
@property NSDictionary* productWiseData;
@end

@implementation SalesIncentiveDataTuple
@end

@interface SalesIncentiveDataSet : NSObject
@property NSMutableArray*  tupleRecords;
@property NSNumber* maxSaleAchieved;
@property NSNumber* maxIncentiveAccrued;
@end

@implementation SalesIncentiveDataSet

@end


@interface SalesIncentiveChart ()
{
    NSInteger currentlyDisplaying;
    
    SalesIncentiveDataSet* mtdIncentiveDataSet;
    ReportPostResponse* mtdIncentiveResponse;
    
    SalesIncentiveDataSet* qtdIncentiveDataSet;
    ReportPostResponse* qtdIncentiveResponse;
    
    SalesIncentiveDataSet* ytdIncentiveDataSet;
    ReportPostResponse* ytdIncentiveResponse;
    
    DotDualAxisHBarChart* hBarChart;
    LoadingView* loadingView;
    
}

@end

@implementation SalesIncentiveChart

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    if(isiPhone10) {
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
    
    
    currentlyDisplaying = MTD_INCENTIVE;
    
    hBarChart =  [DotDualAxisHBarChart createInstance];
    hBarChart.frame = CGRectMake(10, 40, self.view.bounds.size.width - 20 , self.view.bounds.size.height - 40);
    
    hBarChart.chartDataSource = self;
    hBarChart.chartDelegate = self;
    hBarChart.horizontalAxisView.backgroundColor = [UIColor colorWithRed:0xee/255.0f green:0xc2/255.0f blue:0xb5/255.0f alpha:1.0f];
    hBarChart.legendView.backgroundColor = [UIColor clearColor];
    
    [hBarChart updateLayout];
    
    [self.view addSubview: hBarChart];
    
    [hBarChart.barChartsTableView setBounces:NO];

    
    [self  setHeader];
    
    
    SalesIncentiveLegend* customLegend = [SalesIncentiveLegend createInstance];
    [hBarChart.legendView addSubview:customLegend];
    
    
    [self useMTD_IncentiveDataFromLoginResponse];
   
}


-(void) useMTD_IncentiveDataFromLoginResponse
{
    // ClientVariable* clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    // mtdIncentiveResponse = (ReportPostResponse*)[clientVariables.CLIENT_LOGIN_RESPONSE.dashboardData objectForKey:KEY_salesIncentiveSummaryDivisionWiseMonthly];
    
    
    if(mtdIncentiveResponse!=nil) {
        mtdIncentiveDataSet = [[SalesIncentiveDataSet alloc] init];
        [self convertResponse:mtdIncentiveResponse toChartData:mtdIncentiveDataSet];
        
        [hBarChart.barChartsTableView reloadData];
        
        [self updateLegendView];
    } else {
         [self fetchIncentiveDataForMTD];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void) setHeader
{
    //[self.navigationController setTitle:@"Sales Camparision"];
    // self.navigationController
    // self.navigationController setT
    
    self.navigationController.navigationBar.translucent = NO;
    
    UILabel*  titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 40)];
    titleLabel.text = @"Sales Incentive - Open";
    titleLabel.textColor = [Styles headerTextColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.navigationItem setTitleView: titleLabel];
    
   //  self.navigationItem.hidesBackButton = YES;
    
    
    /*
     UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
     style:UIBarButtonItemStyleBordered
     target:self
     action:@selector(backHandler:)];
     backButton.tintColor = [Styles barButtonTextColor];
     [self.navigationItem setLeftBarButtonItem:backButton];
     */
    
    
    self.navigationController.navigationBar.tintColor = [Styles barButtonTextColor];}



-(IBAction)backHandler:(id)sender
{
    [ [self navigationController]  popViewControllerAnimated:YES];
}


- (IBAction)segmentControlAction:(id)sender {
    UISegmentedControl* segCtrl = (UISegmentedControl*) sender;
    NSLog(@"Segment control selected value: %d", segCtrl.selectedSegmentIndex );


    if(segCtrl.selectedSegmentIndex==0) {
        currentlyDisplaying = MTD_INCENTIVE;
        
        if(mtdIncentiveResponse==nil) {
            [self fetchIncentiveDataForMTD];
        } else {
            [hBarChart.barChartsTableView reloadData];
        }
        
    } else if(segCtrl.selectedSegmentIndex==1) {
        currentlyDisplaying = QTD_INCENTIVE;

        if(qtdIncentiveResponse==nil) {
            [self fetchIncentiveDataForQTD];
        } else {
            [hBarChart.barChartsTableView reloadData];
        }

    } else {
        currentlyDisplaying = YTD_INCENTIVE;
        if(ytdIncentiveResponse==nil) {
            [self fetchIncentiveDataForYTD];

        } else {
            [hBarChart.barChartsTableView reloadData];
        }
    }
    
    [self updateLegendView];

}


-(void)fetchIncentiveDataForMTD
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
    
    
    int daysInThisMonth = [self getNoDays :([weekdayComponents month]-1) :  ([weekdayComponents year] + yearReference.intValue)];

    NSString* lastDayOfThisMonthAsString = [NSString stringWithFormat:@"%.2d/%.2ld/%.4ld", daysInThisMonth, [weekdayComponents month], [weekdayComponents year] + yearReference.intValue ];

    NSString* firstOfThisMonth = [NSString stringWithFormat:@"01/%.2ld/%.4ld", [weekdayComponents month], [weekdayComponents year] + yearReference.intValue ];
    
    NSLog(@"SalesIncentiveChart:fetchIncentiveDataForMTD : FromDate=%@  , ToDate=%@", firstOfThisMonth,  lastDayOfThisMonthAsString);
    
    
    DotFormPost* formPostObject = [self salesIncentiveFormPost:firstOfThisMonth toDate:lastDayOfThisMonthAsString];
    
    XmwReportService* reportService = [[XmwReportService alloc] initWithPostData:formPostObject withContext:@"fetchIncentiveDataForMTD"];
    
    loadingView = [LoadingView loadingViewInView:self.view];
    
    [reportService fetchReportUsingSuccess:^(DotFormPost* formPosted, ReportPostResponse* reportResponse) {
        [loadingView removeView];
        // we should receive report response data here
        mtdIncentiveResponse = reportResponse;
        mtdIncentiveDataSet = [[SalesIncentiveDataSet alloc] init];
        [self convertResponse:mtdIncentiveResponse toChartData:mtdIncentiveDataSet];
        
        [hBarChart.barChartsTableView reloadData];
        
        [self updateLegendView];
        
    }   fail:^(DotFormPost* formPosted, NSString* message) {
        // we should receive error response here
        [loadingView removeView];
        
        
    }];
}

-(void)fetchIncentiveDataForQTD
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
    
    
    // we need to fine the quarter dates
    NSDate* today = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =[gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
    
    
    NSString* firstDayOfCurrentQuarter = @"";
    NSString* lastDayCurrentQuarter = @"";
    // if month is jan (1), Feb (2), Mar(3)
    if(([weekdayComponents month] <= 3) && ([weekdayComponents month] >= 1)) {
        firstDayOfCurrentQuarter = [NSString stringWithFormat:@"01/01/%.4ld", [weekdayComponents year] + yearReference.intValue];
        lastDayCurrentQuarter = [NSString stringWithFormat:@"31/03/%.4ld", [weekdayComponents year] + yearReference.intValue];
    }
    
    // if month is apr (4), may (5), jun(6)
    if(([weekdayComponents month] <= 6) && ([weekdayComponents month] >= 4)) {
        firstDayOfCurrentQuarter = [NSString stringWithFormat:@"01/04/%.4ld", [weekdayComponents year] + yearReference.intValue];
        lastDayCurrentQuarter = [NSString stringWithFormat:@"30/06/%.4ld", [weekdayComponents year] + yearReference.intValue];
    }
    
    // if month is july (7), aug (8), sep(9)
    if(([weekdayComponents month] <= 9) && ([weekdayComponents month] >= 7)) {
        firstDayOfCurrentQuarter = [NSString stringWithFormat:@"01/07/%.4ld", [weekdayComponents year] + yearReference.intValue];
        lastDayCurrentQuarter = [NSString stringWithFormat:@"30/09/%.4ld", [weekdayComponents year] + yearReference.intValue];
    }
    
    // if month is oct (10), nov (11), dec(12)
    if(([weekdayComponents month] <= 12) && ([weekdayComponents month] >= 10)) {
        firstDayOfCurrentQuarter = [NSString stringWithFormat:@"01/10/%.4ld", [weekdayComponents year] + yearReference.intValue];
        lastDayCurrentQuarter = [NSString stringWithFormat:@"31/12/%.4ld", [weekdayComponents year] + yearReference.intValue];
    }

    
    
    NSLog(@"SalesIncentiveChart:fetchIncentiveDataForQTD : FromDate=%@  , ToDate=%@", firstDayOfCurrentQuarter,  lastDayCurrentQuarter);
    
    
    DotFormPost* formPostObject = [self salesIncentiveFormPost:firstDayOfCurrentQuarter toDate:lastDayCurrentQuarter];
    
    
    XmwReportService* reportService = [[XmwReportService alloc] initWithPostData:formPostObject withContext:@"fetchIncentiveDataForQTD"];
    
    loadingView = [LoadingView loadingViewInView:self.view];
    
    
    [reportService fetchReportUsingSuccess:^(DotFormPost* formPosted, ReportPostResponse* reportResponse) {
        [loadingView removeView];
        // we should receive report response data here
        
        qtdIncentiveResponse = reportResponse;
        qtdIncentiveDataSet = [[SalesIncentiveDataSet alloc] init];
        [self convertResponse:qtdIncentiveResponse toChartData:qtdIncentiveDataSet];
        
        [hBarChart.barChartsTableView reloadData];
        
        [self updateLegendView];
        
    }   fail:^(DotFormPost* formPosted, NSString* message) {
        // we should receive error response here
        [loadingView removeView];
        
        
    }];
}

-(void)fetchIncentiveDataForYTD
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
    
    
    NSString* lastDayOfThisFinancialYear = [NSString stringWithFormat:@"31/03/%.4ld", ([weekdayComponents month] > 3) ? ([weekdayComponents year]+1 + yearReference.intValue) : [weekdayComponents year] + yearReference.intValue];
    
    NSLog(@"SalesIncentiveChart:fetchIncentiveDataForYTD : FromDate=%@  , ToDate=%@", firstDayOfCurrentFinancialYear,  lastDayOfThisFinancialYear);
    
    
    DotFormPost* formPostObject = [self salesIncentiveFormPost:firstDayOfCurrentFinancialYear toDate:lastDayOfThisFinancialYear];
    
    
    XmwReportService* reportService = [[XmwReportService alloc] initWithPostData:formPostObject withContext:@"fetchIncentiveDataForYTD"];
    
    loadingView = [LoadingView loadingViewInView:self.view];
    
    
    [reportService fetchReportUsingSuccess:^(DotFormPost* formPosted, ReportPostResponse* reportResponse) {
        [loadingView removeView];
        // we should receive report response data here
        
        ytdIncentiveResponse = reportResponse;
        
        ytdIncentiveDataSet = [[SalesIncentiveDataSet alloc] init];
        [self convertResponse:ytdIncentiveResponse toChartData:ytdIncentiveDataSet];
        
        [hBarChart.barChartsTableView reloadData];
        
        [self updateLegendView];
        
    }   fail:^(DotFormPost* formPosted, NSString* message) {
        // we should receive error response here
        [loadingView removeView];
        
        
    }];

}


-(void) convertResponse:(ReportPostResponse*) reportData toChartData:(SalesIncentiveDataSet*) incentiveDataSet
{
    NSNumber* maxIncentiveValue = [NSNumber numberWithInt:0];
    NSNumber* maxSalesValue =  [NSNumber numberWithInt:0];
    
    NSArray* rowWiseTableData = reportData.tableData;
    
    incentiveDataSet.tupleRecords = [[NSMutableArray alloc] initWithCapacity:[rowWiseTableData count]];
    
    for(NSArray* rowData in rowWiseTableData) {
        
        // 0 pos is target
        // 1 pos is actual sales
        // 2 pos is incentive
        // 3 product name (scheme or rebate)
        
        SalesIncentiveDataTuple* incentiveTuple = [[SalesIncentiveDataTuple alloc] init];
        incentiveTuple.schemeName = [rowData objectAtIndex:4];
        incentiveTuple.saleAchieved = [[NSNumber alloc] initWithDouble: [[rowData objectAtIndex:1] doubleValue]];
        incentiveTuple.targetToBeAchieved = [[NSNumber alloc] initWithDouble: [[rowData objectAtIndex:0] doubleValue]];
        incentiveTuple.incentiveAccrued = [[NSNumber alloc] initWithDouble: [[rowData objectAtIndex:2] doubleValue]];
        incentiveTuple.rebateAgreementNo = [rowData objectAtIndex:3];
        incentiveTuple.targetSet = [[rowData objectAtIndex:5] isEqualToString:@"1"];
        incentiveTuple.rateUnit = [rowData objectAtIndex:6];
        incentiveTuple.possibleIncentive = [[NSNumber alloc] initWithDouble: [[rowData objectAtIndex:7] doubleValue]];
        
        NSString* productWiseData = [XmwUtils  unescapeJson:[rowData objectAtIndex:9]];
        
       ///  NSLog(@"Product Wise Data: %@", productWiseData);
        incentiveTuple.productWiseData = [NSJSONSerialization JSONObjectWithData:[productWiseData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        // NSLog(@"Parsed Data: %@", [parsedProductData description]);
        
        [incentiveDataSet.tupleRecords addObject:incentiveTuple];
     
        // we should also computer max and min values here to chart axis
        
        if([maxSalesValue compare:incentiveTuple.saleAchieved]==NSOrderedAscending) {
            maxSalesValue = incentiveTuple.saleAchieved;
        }
        
        if([maxIncentiveValue compare:incentiveTuple.incentiveAccrued]==NSOrderedAscending) {
            maxIncentiveValue = incentiveTuple.incentiveAccrued;
        }
        
    }
    
    incentiveDataSet.maxSaleAchieved = [NSNumber numberWithDouble:[self computeMaxValueForAxis:maxSalesValue.doubleValue]];

    incentiveDataSet.maxIncentiveAccrued = [NSNumber numberWithDouble:[self computeMaxValueForAxis:maxIncentiveValue.doubleValue]];
    
}


-(DotFormPost*) salesIncentiveFormPost:(NSString*) fromDate toDate:(NSString*) toDate
{
    
    ClientVariable* clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    
    DotForm  *dotForm = (DotForm*) [clientVariables.DOT_FORM_MAP objectForKey: @"DOT_FORM_6_4"] ;
    
    DotFormPost *dotFormPost = [[DotFormPost alloc]init];
    NSMutableDictionary *postData = [[NSMutableDictionary alloc]init];
    [postData setObject:toDate forKey:@"BUDAT_TO"];
    [postData setObject:fromDate forKey:@"BUDAT_FRM"];
    
    NSMutableDictionary *displayData = [[NSMutableDictionary alloc]init];
    [displayData setObject:toDate forKey:@"BUDAT_TO"];
    [displayData setObject:fromDate forKey:@"BUDAT_FRM"];
    
    
    [dotFormPost setAdapterType:dotForm.adapterType];
    [dotFormPost setAdapterId:dotForm.submitAdapterId];
    [dotFormPost setModuleId: [DVAppDelegate currentModuleContext]];
    [dotFormPost setDocId:dotForm.formId];
    [dotFormPost setPostData:postData];
    [dotFormPost setDisplayData:displayData];
    [dotFormPost setDocDesc:dotForm.screenDesc];
    
    return dotFormPost;
}



#pragma mark - DotDualHAxisDataSource

-(NSInteger) dotHBarChartNumberOfBars:(DotDualAxisHBarChart *)barChart
{
    if(currentlyDisplaying==MTD_INCENTIVE) {
        if(mtdIncentiveDataSet!=nil) {
            return [mtdIncentiveDataSet.tupleRecords count];
        } else {
            return 0;
        }
    } else if(currentlyDisplaying==QTD_INCENTIVE) {
        if(qtdIncentiveDataSet!=nil) {
            return [qtdIncentiveDataSet.tupleRecords count];
        } else {
            return 0;
        }
    } else if(currentlyDisplaying==YTD_INCENTIVE) {
        if(ytdIncentiveDataSet!=nil) {
            return [ytdIncentiveDataSet.tupleRecords count];
        } else {
            return 0;
        }
    }
    return 0;
}

-(NSInteger) dotHBarChartBarWidth:(DotDualAxisHBarChart *)barChart
{
    return 30;
}


#pragma mark - DotDualHAxisDelegate

-(UIView*) dotHBarChart:(DualAxisHorizontalBarCell *) cell horizontalBarView:(NSInteger) index
{
    
    return [[UIView alloc] init];
}

-(void) dotHBarChart:(DualAxisHorizontalBarCell *)cell userDefView:(UIView*) udfView configureHorizontalBarView:(NSInteger) index
{
    
    SalesIncentiveDataSet* currentDataSet;
    
    if(currentlyDisplaying==MTD_INCENTIVE) {
        currentDataSet = mtdIncentiveDataSet;
    } else if(currentlyDisplaying==QTD_INCENTIVE) {
        currentDataSet = qtdIncentiveDataSet;
    } else if(currentlyDisplaying==YTD_INCENTIVE) {
        currentDataSet = ytdIncentiveDataSet;
    }
    
    SalesIncentiveDataTuple* dataTuple = [currentDataSet.tupleRecords objectAtIndex:index];
    
    cell.rowLabel.text = dataTuple.schemeName;
    [cell configureLeftWithValue:dataTuple.saleAchieved.doubleValue maxValue:currentDataSet.maxSaleAchieved.doubleValue];
    [cell configureRightWithValue:dataTuple.incentiveAccrued.doubleValue maxValue:currentDataSet.maxIncentiveAccrued.doubleValue];
   // currentDataSet.maxIncentiveAccrued;
   //  currentDataSet.maxSaleAchieved;
    
    if(dataTuple.targetSet) {
        [self showTarget:dataTuple.targetToBeAchieved.doubleValue onHorizontalBar:cell withBarMax:currentDataSet.maxSaleAchieved.doubleValue];
    } else {
        UIView* targetBox = [cell.leftBarParent viewWithTag:kTargetTag];
        if(targetBox!=nil) {
            targetBox.hidden = YES;
        }
    }
    
    
    // display values on bar
    [cell displayLeftBarValue:[NSString stringWithFormat:@"%.2f", (dataTuple.saleAchieved.doubleValue/100000.0f)]];
    [cell displayRightBarValue:[NSString stringWithFormat:@"%.2f", (dataTuple.incentiveAccrued.doubleValue/100000.0f)]];
}


-(void) dotHBarChart:(DotDualAxisHBarChart *)barChart didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SalesIncentiveDataSet* currentDataSet;
    
    if(currentlyDisplaying==MTD_INCENTIVE) {
        currentDataSet = mtdIncentiveDataSet;
    } else if(currentlyDisplaying==QTD_INCENTIVE) {
        currentDataSet = qtdIncentiveDataSet;
    } else if(currentlyDisplaying==YTD_INCENTIVE) {
        currentDataSet = ytdIncentiveDataSet;
    }
    
    SalesIncentiveDataTuple* dataTuple = [currentDataSet.tupleRecords objectAtIndex:indexPath.row];
    
    NSMutableArray* lineItemArrayForPopup = [[NSMutableArray alloc] init];
    
    
    [lineItemArrayForPopup addObject:[NSArray arrayWithObjects:@"Scheme", dataTuple.schemeName, nil]];
    [lineItemArrayForPopup addObject:[NSArray arrayWithObjects:@"Rebate No", dataTuple.rebateAgreementNo, nil]];
    
    
    NSNumberFormatter *comaFormatter = [[NSNumberFormatter alloc] init];
    [comaFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [comaFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_IN"] ];

    if(dataTuple.targetSet) {
        [lineItemArrayForPopup addObject:[NSArray arrayWithObjects:@"Target", [comaFormatter stringFromNumber:[NSNumber numberWithDouble:round(dataTuple.targetToBeAchieved.doubleValue) ]], nil]];
    } else {
        [lineItemArrayForPopup addObject:[NSArray arrayWithObjects:@"Target", @"0", nil]];
    }
    
    
    [lineItemArrayForPopup addObject:[NSArray arrayWithObjects:@"Sales", [comaFormatter stringFromNumber:[NSNumber numberWithDouble:round(dataTuple.saleAchieved.doubleValue) ]], nil]];
    
    [lineItemArrayForPopup addObject:[NSArray arrayWithObjects:@"Incentive", [comaFormatter stringFromNumber:[NSNumber numberWithDouble:round(dataTuple.incentiveAccrued.doubleValue) ]], nil]];
    
    if(dataTuple.incentiveAccrued.doubleValue == 0.0) {
        [lineItemArrayForPopup addObject:[NSArray arrayWithObjects:@"Possible Incentive", [comaFormatter stringFromNumber:[NSNumber numberWithDouble:round(dataTuple.possibleIncentive.doubleValue) ]], nil]];
    }
    
    if( (dataTuple.rateUnit!=nil) && (dataTuple.rateUnit.length >0)) {
        [lineItemArrayForPopup addObject:[NSArray arrayWithObjects:@"Rate Unit", dataTuple.rateUnit, nil]];
    }
    
    
    // for displaying productWiseData
    // dataTuple.productWiseData
   
   
    [lineItemArrayForPopup addObject:[NSArray arrayWithObjects:@"Product", @"Incentive", @"Rate", @"Target\n(in lacs)",  @"Sales\n(in lacs)", nil]];

    
    for(NSString* key in [dataTuple.productWiseData allKeys]) {
        
        NSDictionary* productData = [dataTuple.productWiseData objectForKey:key];
        /*
        [productData objectForKey:@"productName"];
        [productData objectForKey:@"unit"];
        [productData objectForKey:@"actualSale"];
        [productData objectForKey:@"cumAmountPay"];  // agreementType   targetRateSalesList is array
        [productData objectForKey:@"agreementType"];
        [productData objectForKey:@"schemeStatus"];
        [productData objectForKey:@"targetRateSalesList"];
         */
        
        
        NSArray* slabWiseData = [productData objectForKey:@"targetRateSalesList"];
        if([slabWiseData count]>0) {
            NSDictionary* slabData0 = [slabWiseData objectAtIndex:0];
            NSDictionary* slabData = [slabWiseData objectAtIndex:([slabWiseData count]-1)];
            
            NSString* targetInLacs = [NSString stringWithFormat:@"%.02lf", [[slabData objectForKey:@"target"] doubleValue]/100000.00f ];
            NSString* salesInLacs = [NSString stringWithFormat:@"%.02lf", [[slabData0 objectForKey:@"sales"] doubleValue]/100000.00f ];
            
            [lineItemArrayForPopup addObject:[NSArray arrayWithObjects:[productData objectForKey:@"productName"], [productData objectForKey:@"cumAmountPay"],  [slabData objectForKey:@"rate"], targetInLacs, salesInLacs, nil]];
        }
        
    }
    
    
    SalesIncentiveItemPopup* contentPopup = [SalesIncentiveItemPopup createInstanceWithData:lineItemArrayForPopup];
    
    [[UIApplication sharedApplication].keyWindow addSubview:contentPopup];
    
}


-(void) updateLegendView
{
    /*
    SalesComparisonLegend* customLegend = (SalesComparisonLegend*)[hBarChart.legendView viewWithTag:1001];
    if(customLegend==nil) {
        customLegend = [SalesComparisonLegend createInstance];
        customLegend.tag = 1001;
        [hBarChart.legendView addSubview:customLegend];
    }
     */
    
    SalesIncentiveDataSet* currentDataSet;
    
    if(currentlyDisplaying==MTD_INCENTIVE) {
        currentDataSet = mtdIncentiveDataSet;
    } else if(currentlyDisplaying==QTD_INCENTIVE) {
        currentDataSet = qtdIncentiveDataSet;
    } else if(currentlyDisplaying==YTD_INCENTIVE) {
        currentDataSet = ytdIncentiveDataSet;
    }
    
    
    // for amount in lakh, and incentive in lakhs.
    if(currentDataSet!=nil) {
        [hBarChart updateLeftHorizontalAxis:0.0f :currentDataSet.maxSaleAchieved.doubleValue/100000.0f];    //100000.0f
        [hBarChart updateRightHorizontalAxis:0.0f :currentDataSet.maxIncentiveAccrued.doubleValue/100000.0f ];
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

-(void) showTarget:(double) targetValue onHorizontalBar:(DualAxisHorizontalBarCell*) barCell withBarMax:(double) maxValue
{
    CGRect frameForTarget;
    
    if(maxValue==0.0f) {
        frameForTarget = CGRectMake(barCell.leftBarParent.frame.size.width, 0, 5, 14);
    } else {
        frameForTarget = CGRectMake(barCell.leftBarParent.frame.size.width*targetValue/maxValue
                                    , 0, 5, 14);
    }
    
    UIView* targetBox = [barCell.leftBarParent viewWithTag:kTargetTag];
    if(targetBox==nil) {
        targetBox = [[UIView alloc] initWithFrame:frameForTarget];
        targetBox.tag = kTargetTag;
        targetBox.backgroundColor = [UIColor blackColor];
        [barCell.leftBarParent addSubview:targetBox];
    }
    
    targetBox.frame = frameForTarget;
    targetBox.hidden = NO;
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


@end
