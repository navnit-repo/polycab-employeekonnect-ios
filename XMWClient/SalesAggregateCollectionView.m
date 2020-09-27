//
//  SalesAggregateCollectionView.m
//  XMWClient
//
//  Created by dotvikios on 08/08/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "SalesAggregateCollectionView.h"
#import "DotFormPost.h"
#import "LoadingView.h"
#import "AppConstants.h"
#import "ClientVariable.h"
#import "XmwReportService.h"
#import "DVAppDelegate.h"
#import "SalesCell.h"
#import "LayoutClass.h"
#import "ProgressBarView.h"
#import "SalesComparisonChart.h"
#import "DashBoardVC.h"
#import "PolycabSalesComparisonChat.h"
#import "SWRevealViewController.h"
#define CELL_WIDTH 320
#define CELL_SPACING 10
@implementation SalesAggregateCollectionView
{
//    DotFormPost *ftdPost;
//    DotFormPost *mtdPost;
//    DotFormPost *ytdPost;
    LoadingView *loadingView;
 //   int numberOfCell;
    NSMutableArray *maxCellArray;
//    ReportPostResponse* ftdResponseData;
//    ReportPostResponse* mtdResponseData;
//    ReportPostResponse* ytdResponseData;
//    NSMutableArray *ftdDataArray;
//    NSMutableArray *mtdDataArray;
//    NSMutableArray *ytdDataArray;
    SalesCell *salesCell;
    
   // UIView *blankView;
   // BOOL sortDone;
    
   // UIActivityIndicatorView *activityIndicatorView;
//    UIView *  noDataView ;
    
}
@synthesize noDataView;
@synthesize LMTD_TO_Date;
@synthesize LMTD_From_Date;
@synthesize LFTD_TO_Date;
@synthesize LFTD_From_Date;
@synthesize collectionView;
@synthesize pageIndicator;
@synthesize underCellLbl;
+(SalesAggregateCollectionView*) createInstance

{
    SalesAggregateCollectionView *view = (SalesAggregateCollectionView *)[[[NSBundle mainBundle] loadNibNamed:@"SalesAggregateCollectionView" owner:self options:nil] objectAtIndex:0];
     [[NSNotificationCenter defaultCenter] addObserver:view selector:@selector(autoRefresh) name:XmwcsConst_SALESAGGREGATE_CARD_AUTOREFRESH_IDENTIFIER object:nil];
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
    [collectionView reloadData];
    [self netwrokCall];
    
}

-(void)autoLayout{
    [LayoutClass setLayoutForIPhone6:self.mainView];
    [LayoutClass setLayoutForIPhone6:self.collectionView];
    [LayoutClass labelLayout:self.underCellLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass setLayoutForIPhone6:self.pageIndicator];
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
-(void)configure{
    [self autoLayout];
    [self shadowView];
    sortDone = false;
    maxCellArray = [[NSMutableArray alloc]init];
    ftdDataArray = [[NSMutableArray alloc]init];
    mtdDataArray = [[NSMutableArray alloc]init];
    ytdDataArray = [[NSMutableArray alloc]init];
    lftdDataArray = [[NSMutableArray alloc]init];
    lmtdDataArray = [[NSMutableArray alloc]init];
    self.collectionView.delegate= self;
    self.collectionView.dataSource= self;
    
     [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.bounces = NO;
    [self loadingView];
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
    activityIndicatorView.tag = 50000;
    activityIndicatorView.center=blankView.center;
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
    [ftdPost setAdapterId:@"DOT_REPORT_CUSTOMER_WISE_SALE"];
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
    [mtdPost setAdapterId:@"DOT_REPORT_CUSTOMER_WISE_SALE"];
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
    [ytdPost setAdapterId:@"DOT_REPORT_CUSTOMER_WISE_SALE"];
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
        
        for (int i=0; i<ytdResponseData.tableData.count; i++) {
            NSArray *array = [NSArray arrayWithArray:[ytdResponseData.tableData objectAtIndex:i]];
            [ytdDataArray addObject:array];
        }
        NSLog(@"YTD: %@",ytdDataArray);
        
        [self LFTD_NetworkCall];
        
//        [self maintainArrayFTD_MTD_YTD];
      
    }   fail:^(DotFormPost* formPosted, NSString* message) {
        // we should receive error response here
        
        
        
    }];
    
    
}
-(void)LMTD_NetworkCall
{
    NSLog(@"From date :- %@",LMTD_From_Date);
    NSLog(@"To date :- %@",LMTD_TO_Date);
    lmtdPost = [[DotFormPost alloc]init];
    [lmtdPost setAdapterId:@"DOT_REPORT_CUSTOMER_WISE_SALE"];
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
        for (int i=0; i<lmtdResponseData.tableData.count; i++) {
            NSArray *array = [NSArray arrayWithArray:[lmtdResponseData.tableData objectAtIndex:i]];
            [lmtdDataArray addObject:array];
        }
        
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
    [lftdPost setAdapterId:@"DOT_REPORT_CUSTOMER_WISE_SALE"];
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
        for (int i=0; i<lftdResponseData.tableData.count; i++) {
            NSArray *array = [NSArray arrayWithArray:[lftdResponseData.tableData objectAtIndex:i]];
            [lftdDataArray addObject:array];
        }
        
        NSLog(@"LFTD: %@",lftdDataArray);
        
        [self LMTD_NetworkCall];
//          [self maintainArrayFTD_MTD_YTD];
        
    }   fail:^(DotFormPost* formPosted, NSString* message) {
        // we should receive error response here
        
    }];
}
-(NSArray*)removeZero:(NSArray*)array{
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    
    for (int i=0; i<array.count; i++) {
        if ([[[array objectAtIndex: 0]objectAtIndex: 0] isEqualToString:@"0"] || [[[array objectAtIndex: 0]objectAtIndex: 0] isEqualToString:@""] || [[array objectAtIndex: 0]objectAtIndex: 0] == nil || [[[array objectAtIndex: 0]objectAtIndex: 0] isKindOfClass:[NSNull class]] || [[[array objectAtIndex: 0]objectAtIndex: 0] length] == 0) {
           
        }
        else{
             [tempArray addObject:[array objectAtIndex:i]];
        }
    }
    
    return tempArray;
    
}
-(void)maintainArrayFTD_MTD_YTD{
   

    NSMutableArray*temp1 = [[NSMutableArray alloc]init];
    [temp1 addObjectsFromArray:[self removeZero:ftdDataArray]];
    
    NSMutableArray*temp2 = [[NSMutableArray alloc]init];
    [temp2 addObjectsFromArray:[self removeZero:mtdDataArray]];
    
    NSMutableArray*temp3 = [[NSMutableArray alloc]init];
    [temp3 addObjectsFromArray:[self removeZero:ytdDataArray]];
    
    NSMutableArray*temp4 = [[NSMutableArray alloc]init];
    [temp4 addObjectsFromArray:[self removeZero:lftdDataArray]];
    
    NSMutableArray*temp5 = [[NSMutableArray alloc]init];
    [temp5 addObjectsFromArray:[self removeZero:lmtdDataArray]];
    
    ftdDataArray = [[NSMutableArray alloc]init];
    [ftdDataArray addObjectsFromArray:temp1];
    mtdDataArray = [[NSMutableArray alloc]init];
    [mtdDataArray addObjectsFromArray:temp2];
    ytdDataArray = [[NSMutableArray alloc]init];
    [ytdDataArray addObjectsFromArray:temp3];
    
    lftdDataArray = [[NSMutableArray alloc]init];
    [lftdDataArray addObjectsFromArray:temp4];
    
    lmtdDataArray = [[NSMutableArray alloc]init];
    [lmtdDataArray addObjectsFromArray:temp5];
    
    NSLog(@"After FTD blank element object removed array: %@",ftdDataArray);
    NSLog(@"After MTD blank element object removed array: %@",mtdDataArray);
    NSLog(@"After YTD blank element object removed array: %@",ytdDataArray);
    NSLog(@"After LFTD blank element object removed array: %@",lftdDataArray);
    NSLog(@"After LMTD blank element object removed array: %@",lmtdDataArray);
    
    NSUInteger ftdCount= [ftdDataArray count];
    NSUInteger mtdCount= [mtdDataArray count];
    NSUInteger ytdCount= [ytdDataArray count];
    NSUInteger lftdCount = [lftdDataArray count];
    NSUInteger lmtdCount = [lmtdDataArray count];
    
   NSArray* arrayList = [NSArray arrayWithObjects:ftdDataArray, mtdDataArray, ytdDataArray, lftdDataArray, lmtdDataArray,  nil];
    
    arrayList = [arrayList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSArray* array1 = (NSArray*) obj1;
        NSArray* array2 = (NSArray*) obj2;
        if([array1 count] < [array2 count])  {
            return NSOrderedAscending;
        } else if([array1 count] == [array2 count]) {
            return NSOrderedSame;
        }
        return NSOrderedDescending;
    }];
    
    NSArray* largestArray = [arrayList objectAtIndex:4];
    numberOfCell = (int) [largestArray count];
    [maxCellArray addObjectsFromArray:largestArray];
    
     //count total number of cell draw
    /*
    if (ftdCount > mtdCount)
    {
        if (ftdCount > ytdCount)
        {
            NSLog(@"ftdCount is the greatest among three \n");
            NSLog(@"Count :%lu",(unsigned long)ftdCount);
            numberOfCell = (int)ftdCount;
            [maxCellArray addObjectsFromArray:ftdDataArray];
        }
        else
        {
            NSLog(@"ytdCount is the greatest among three \n");
            NSLog(@"Count :%lu",(unsigned long)ytdCount);
            numberOfCell = (int)ytdCount;
            [maxCellArray addObjectsFromArray:ytdDataArray];
        }
    }
    else if (mtdCount > ytdCount)
    {
        NSLog(@"mtdCount is the greatest among three \n");
        NSLog(@"Count :%lu",(unsigned long)mtdCount);
        numberOfCell = (int)mtdCount;
        [maxCellArray addObjectsFromArray:mtdDataArray];
    }
    else
    {
        NSLog(@"ytdCount is the greatest among three \n");
        NSLog(@"Count :%lu",(unsigned long)ytdCount);
        numberOfCell = (int)ytdCount;
        [maxCellArray addObjectsFromArray:ytdDataArray];
    }
    */
    
    
    //before add empty data
    NSLog(@"FTD array: %@",ftdDataArray);
    NSLog(@"MTD array: %@",mtdDataArray);
    NSLog(@"YTD array: %@",ytdDataArray);
    NSLog(@"Max Array: %@",maxCellArray);
    NSLog(@"Number of cell: %d",numberOfCell);
    
    //add empty array when other array length is less then number of cell
    
        if (ftdCount < numberOfCell) {
        
            NSArray *addEmptyArray = [[NSArray alloc]initWithArray:[self distinct:ftdDataArray :maxCellArray]];
            NSLog(@"%@",addEmptyArray);
            for (int i=0; i<addEmptyArray.count; i++) {
                NSMutableArray *emptyArray = [[NSMutableArray alloc]init];
                [emptyArray addObject:[addEmptyArray objectAtIndex:i]];
                [emptyArray addObject:@"0.0"];
                [emptyArray addObject:@"0.0"];
                [ftdDataArray insertObject:emptyArray atIndex:ftdCount];
            }
        
        }
    
    if (mtdCount < numberOfCell) {
        NSArray *addEmptyArray = [[NSArray alloc]initWithArray:[self distinct:mtdDataArray :maxCellArray]];
        NSLog(@"%@",addEmptyArray);
        for (int i=0; i<addEmptyArray.count; i++) {
                        NSMutableArray *emptyArray = [[NSMutableArray alloc]init];
                        [emptyArray addObject:[addEmptyArray objectAtIndex:i]];
                        [emptyArray addObject:@"0.0"];
                        [emptyArray addObject:@"0.0"];
                        [mtdDataArray insertObject:emptyArray atIndex:mtdCount];
                    }
    }
    
    if (ytdCount < numberOfCell) {
    
        NSArray *addEmptyArray = [[NSArray alloc]initWithArray:[self distinct:ytdDataArray :maxCellArray]];
        NSLog(@"%@",addEmptyArray);
        for (int i=0; i<addEmptyArray.count; i++) {
            NSMutableArray *emptyArray = [[NSMutableArray alloc]init];
            [emptyArray addObject:[addEmptyArray objectAtIndex:i]];
            [emptyArray addObject:@"0.0"];
            [emptyArray addObject:@"0.0"];
            [ytdDataArray insertObject:emptyArray atIndex:ytdCount];
        }
    
    }
    
    if (lftdCount < numberOfCell) {
        
        NSArray *addEmptyArray = [[NSArray alloc]initWithArray:[self distinct:lftdDataArray :maxCellArray]];
        NSLog(@"%@",addEmptyArray);
        for (int i=0; i<addEmptyArray.count; i++) {
            NSMutableArray *emptyArray = [[NSMutableArray alloc]init];
            [emptyArray addObject:[addEmptyArray objectAtIndex:i]];
            [emptyArray addObject:@"0.0"];
            [emptyArray addObject:@"0.0"];
            [lftdDataArray insertObject:emptyArray atIndex:lftdCount];
        }
        
    }
    
    if (lmtdCount < numberOfCell) {
        
        NSArray *addEmptyArray = [[NSArray alloc]initWithArray:[self distinct:lmtdDataArray :maxCellArray]];
        NSLog(@"%@",addEmptyArray);
        for (int i=0; i<addEmptyArray.count; i++) {
            NSMutableArray *emptyArray = [[NSMutableArray alloc]init];
            [emptyArray addObject:[addEmptyArray objectAtIndex:i]];
            [emptyArray addObject:@"0.0"];
            [emptyArray addObject:@"0.0"];
            [lmtdDataArray insertObject:emptyArray atIndex:lmtdCount];
        }
        
    }
    
 
    NSLog(@"FTD final array: %@",ftdDataArray);
    NSLog(@"MTD final array: %@",mtdDataArray);
    NSLog(@"YTD final array: %@",ytdDataArray);
    NSLog(@"LFTD final array: %@",lftdDataArray);
    NSLog(@"LMTD final array: %@",lmtdDataArray);
    // NSArray *sortedArray, with the unsorted 'array' pulled from some other instance
//    NSArray *sortedArray1= [[NSArray alloc]init];
    NSMutableArray *tempFtdArray = [[NSMutableArray alloc]init];
     NSMutableArray *tempMtdArray = [[NSMutableArray alloc]init];
  NSMutableArray *tempLftdArray = [[NSMutableArray alloc]init];
    NSMutableArray *tempLmtdArray = [[NSMutableArray alloc]init];
    for (int i=0; i<ytdDataArray.count; i++) {
        NSString *verticalName = [[ytdDataArray objectAtIndex:i]objectAtIndex:0];
        for (int j=0;j<ytdDataArray.count; j++) {
            NSString *findVerticalInFtdArray = [[ftdDataArray objectAtIndex:j]objectAtIndex:0];
            if ([verticalName isEqualToString:findVerticalInFtdArray]) {
              //  [tempFtdArray addObject:[ftdDataArray objectAtIndex:j]];
                [tempFtdArray insertObject:[ftdDataArray objectAtIndex:j] atIndex:i];
                break;
            }
        }
    }
    
    for (int i=0; i<ytdDataArray.count; i++) {
        NSString *verticalName = [[ytdDataArray objectAtIndex:i]objectAtIndex:0];
        for (int j=0;j<ytdDataArray.count; j++) {
            NSString *findVerticalInMtdArray = [[mtdDataArray objectAtIndex:j]objectAtIndex:0];
            if ([verticalName isEqualToString:findVerticalInMtdArray]) {
                //  [tempFtdArray addObject:[ftdDataArray objectAtIndex:j]];
                [tempMtdArray insertObject:[mtdDataArray objectAtIndex:j] atIndex:i];
                break;
            }
        }
    }
    
    
    for (int i=0; i<ytdDataArray.count; i++) {
        NSString *verticalName = [[ytdDataArray objectAtIndex:i]objectAtIndex:0];
        for (int j=0;j<ytdDataArray.count; j++) {
            NSString *findVerticalInLftdArray = [[lftdDataArray objectAtIndex:j]objectAtIndex:0];
            if ([verticalName isEqualToString:findVerticalInLftdArray]) {
                //  [tempFtdArray addObject:[ftdDataArray objectAtIndex:j]];
                [tempLftdArray insertObject:[lftdDataArray objectAtIndex:j] atIndex:i];
                break;
            }
        }
    }

    for (int i=0; i<ytdDataArray.count; i++) {
        NSString *verticalName = [[ytdDataArray objectAtIndex:i]objectAtIndex:0];
        for (int j=0;j<ytdDataArray.count; j++) {
            NSString *findVerticalInLmtdArray = [[lmtdDataArray objectAtIndex:j]objectAtIndex:0];
            if ([verticalName isEqualToString:findVerticalInLmtdArray]) {
                //  [tempFtdArray addObject:[ftdDataArray objectAtIndex:j]];
                [tempLmtdArray insertObject:[lmtdDataArray objectAtIndex:j] atIndex:i];
                break;
            }
        }
    }
    
    
    NSLog(@"Temp ftd Array :%@",tempFtdArray);
    NSLog(@"Temp Mtd Array :%@",tempMtdArray);
    NSLog(@"Temp Lftd Array :%@",tempLftdArray);
     NSLog(@"Temp Lmtd Array :%@",tempLmtdArray);
    //sorted array
    ftdDataArray = [[NSMutableArray alloc]init];
    [ftdDataArray addObjectsFromArray:tempFtdArray];
    mtdDataArray = [[NSMutableArray alloc]init];
    [mtdDataArray addObjectsFromArray:tempMtdArray];
    lftdDataArray = [[NSMutableArray alloc]init];
    [lftdDataArray addObjectsFromArray:tempLftdArray];
    lmtdDataArray = [[NSMutableArray alloc]init];
    [lmtdDataArray addObjectsFromArray:tempLmtdArray];
//    ytdDataArray = [[NSMutableArray alloc]init];
//    [ytdDataArray addObjectsFromArray:sortedArray3];
    
    sortDone = true;
    if (numberOfCell >15) {
        numberOfCell = 15;
   
    }
    if (ytdDataArray.count>0) {
         [self.collectionView reloadData];//reload cell data
    }
  else
  {
      [self addNoDataAvailableView];
  }
}

-(void)addNoDataAvailableView
{
    [noDataView removeFromSuperview];
    noDataView = [[UIView alloc]initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width-20, self.bounds.size.height)];
    noDataView.backgroundColor = [UIColor clearColor];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(16, 12, 150*deviceWidthRation, 20*deviceHeightRation)];
    lbl.text = @"Sales Aggregate";
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



-(NSArray*)distinct:(NSArray*)arrar1 :(NSArray*)array2{
    NSMutableArray *minProductName = [[NSMutableArray alloc]init];
    NSMutableArray *maxProductName = [[NSMutableArray alloc]init];
    
    NSMutableArray *temp1 = [[NSMutableArray alloc]init];
    NSMutableArray *temp2 = [[NSMutableArray alloc]init];
    [temp1 addObjectsFromArray:arrar1];
    [temp2 addObjectsFromArray:array2];
    for (int i=0; i<temp1.count; i++) {
        [minProductName addObject:[[temp1 objectAtIndex:i] objectAtIndex:0]];
    }
    for (int j=0; j<temp2.count; j++) {
        
        [maxProductName addObject:[[temp2 objectAtIndex:j] objectAtIndex:0]];
    }
    NSMutableSet* firstArraySet = [[NSMutableSet alloc] init];
    NSMutableSet* secondArraySet = [[NSMutableSet alloc] init];
    NSArray *fetchResultsArray;

    [firstArraySet addObjectsFromArray: maxProductName];
    
    [secondArraySet addObjectsFromArray: minProductName];
    
    [firstArraySet minusSet: secondArraySet];
    
    fetchResultsArray = [[NSMutableArray alloc] init];
    
    fetchResultsArray = [firstArraySet allObjects];
    NSLog(@"%@",fetchResultsArray);
    
    return fetchResultsArray;

}



-(void)netwrokCall{
 
  [self ftdNetworkCall];
}


#pragma mark : Collection View Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return numberOfCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.frame.size.width, 120*deviceHeightRation);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat width = scrollView.frame.size.width;
    NSInteger page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    NSInteger moveToPage = page;
    moveToPage = moveToPage % [ftdDataArray count];
    pageIndicator.currentPage = moveToPage;
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    

    
    //after add empty data if needed.
    NSLog(@"FTD array: %@",ftdDataArray);
    NSLog(@"MTD array: %@",mtdDataArray);
    NSLog(@"YTD array: %@",ytdDataArray);
    NSLog(@"LFTD array: %@",lftdDataArray);
    if (sortDone== true) {
        [blankView removeFromSuperview];
    }
    
        for (int i=0;i<numberOfCell; i++ ) {
            
            if (indexPath.row ==i) {

                salesCell = [SalesCell createInstance];
                [salesCell configure:[ftdDataArray objectAtIndex:i] :[mtdDataArray objectAtIndex:i] :[ytdDataArray objectAtIndex:i] :[lftdDataArray objectAtIndex:i] :[lmtdDataArray objectAtIndex:i]];
//                [salesCell configure:[ftdDataArray objectAtIndex:i]  :[mtdDataArray objectAtIndex:i] :[ytdDataArray objectAtIndex:i]];
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
    
    [underCellLbl removeFromSuperview];
    underCellLbl.text =[[[NSString stringWithFormat:@"%@",text]stringByAppendingString:@" "]stringByAppendingString:currentYear];
    
    
    
    
    pageIndicator.numberOfPages = numberOfCell;
    pageIndicator.transform = CGAffineTransformMakeScale(0.7, 0.7);
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PolycabSalesComparisonChat* salesComparisionChart = [[PolycabSalesComparisonChat alloc] initWithNibName:@"SalesComparisonChart" bundle:nil];
    
    UIViewController *root;
    root = [[[[UIApplication sharedApplication]windows]objectAtIndex:0]rootViewController];
    
    SWRevealViewController *reveal = (SWRevealViewController*)root;
      [(UINavigationController*)reveal.frontViewController pushViewController:salesComparisionChart animated:YES];
}


@end
