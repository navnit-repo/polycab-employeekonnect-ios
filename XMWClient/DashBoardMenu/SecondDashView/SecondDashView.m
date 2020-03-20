//
//  SecondDashView.m
//  QCMSProject
//
//  Created by Ashish Tiwari on 14/01/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import "SecondDashView.h"
#import "LoadingView.h"
#import "NetworkHelper.h"
#import "DVAsynchImageView.h"
#import "ClientVariable.h"
#import "DVAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "XmwReportService.h"

@interface SecondDashView ()
{
    LoadingView* loadingView;
    NetworkHelper* networkHelper;
    UIActivityIndicatorView *activityIndicator;
}

@end


@implementation SecondDashView

@synthesize pieChartLeft = _pieChartCopy;
@synthesize slices = _slices;
@synthesize sliceColors = _sliceColors;
@synthesize lacLabel;
@synthesize valueLabel;
@synthesize slicesDataArray;

@synthesize dashBoardMenuViewCtrl;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
              
        
    }
    return self;
}

+(SecondDashView*) createInstance
{
    
    SecondDashView *view = (SecondDashView *)[[[NSBundle mainBundle] loadNibNamed:@"SecondDashView" owner:self options:nil] objectAtIndex:0];
    [[NSNotificationCenter defaultCenter] addObserver:view selector:@selector(refreshData) name:@"REFRESH_SECOND_TILE" object:nil];
    
    return view;
}

- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject {
    if(loadingView!=nil) {
        [loadingView removeView];
        loadingView =nil;
    }
    
    if(activityIndicator!=nil) {
        [activityIndicator stopAnimating];
        activityIndicator = nil;
    }
    
    
    if ([callName isEqualToString : XmwcsConst_CALL_NAME_FOR_REPORT])
    {
        ReportPostResponse *reportPostResponse = (ReportPostResponse*) respondedObject;
        [self setViewContent : reportPostResponse];
    }

}

- (void) httpFailureHandler : (NSString*) callName : (NSString*) message
{
    if(loadingView!=nil) {
        [loadingView removeView];
        loadingView =nil;
    }
    
    if(activityIndicator!=nil) {
        [activityIndicator stopAnimating];
        activityIndicator = nil;
    }
    
    
    UIImageView *incentPieChart = [[UIImageView alloc]initWithFrame:CGRectMake(13, 8, 132, 83)];
    incentPieChart.image = [UIImage imageNamed:@"incentive"];
    incentPieChart.contentMode = UIViewContentModeScaleAspectFit;
    
}


-(DotFormPost*) createDotFormPost
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
    
    ClientVariable* clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    
    DotForm  *dotForm = (DotForm*) [clientVariables.DOT_FORM_MAP objectForKey: @"DOT_FORM_6_3"] ;
    
    DotFormPost *dotFormPost = [[DotFormPost alloc]init];
    NSMutableDictionary *postData = [[NSMutableDictionary alloc]init];
    [postData setObject:[self lastDayForFinancialYear:yearReference.intValue] forKey:@"BUDAT_TO"];
    [postData setObject:[self setFromDateForYTD:yearReference.intValue] forKey:@"BUDAT_FRM"];
    
    
    [dotFormPost setAdapterType:@"CLASSLOADER"];
    [dotFormPost setAdapterId:dotForm.submitAdapterId];
    [dotFormPost setModuleId: [DVAppDelegate currentModuleContext]];
    [dotFormPost setDocId:dotForm.formId];
    [dotFormPost setPostData:postData];

    return dotFormPost;
}


-(void) updateData
{
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
     activityIndicator.center = self.center;
    [activityIndicator startAnimating];
    [self addSubview:activityIndicator];
    
    DotFormPost* dotFormPost = [self createDotFormPost];
    
    networkHelper = [[NetworkHelper alloc] init];
    [networkHelper makeXmwNetworkCall:dotFormPost :self : nil :  XmwcsConst_CALL_NAME_FOR_REPORT];
    
}

-(void) refreshData
{
 
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = self.center;
    activityIndicator.backgroundColor = [UIColor clearColor];
    [activityIndicator startAnimating];
    [self addSubview:activityIndicator];
    
    DotFormPost* dotFormPost = [self createDotFormPost];
    dotFormPost.reportCacheRefresh = @"true";
    
    XmwReportService* reportService = [[XmwReportService alloc] initWithPostData:dotFormPost withContext:@"fetchIncentiveSales"];
    [reportService fetchReportUsingSuccess:^(DotFormPost* formPosted, ReportPostResponse* reportResponse) {
        
        if(activityIndicator!=nil) {
            [activityIndicator stopAnimating];
            activityIndicator = nil;
        }
        
        [self setViewContent:reportResponse];
        
    }   fail:^(DotFormPost* formPosted, NSString* message) {
        if(activityIndicator!=nil) {
            [activityIndicator stopAnimating];
            activityIndicator = nil;
        }
    }];
    
}

-(void)setViewContent:(ReportPostResponse *)reportPostResponse
{
    [activityIndicator stopAnimating];
    
    self.salesIncentiveSummary = reportPostResponse;
    
    
    UIImageView *incentPieChart = [[UIImageView alloc]initWithFrame:CGRectMake(13, 8, 132, 83)];
    incentPieChart.image = [UIImage imageNamed:@"incentive"];
    incentPieChart.contentMode = UIViewContentModeScaleAspectFit;
   //  self.incentiveLabel.text = @"Incentives";
    //[self addSubview:incentPieChart];
    
    NSMutableDictionary *headerDicData = self.salesIncentiveSummary.headerData;
    NSString *target = [headerDicData objectForKey:@"TARGET"];
    NSString *achieved = [headerDicData objectForKey:@"ACHIEVED"];
    NSString *paid = [headerDicData objectForKey:@"PAID"];
    float targetFloat = (float)[target floatValue];
    float achievedFloat = (float)[achieved floatValue];
    float paidFloat  = (float)[paid floatValue];
    
     NSNumber *one = [NSNumber numberWithFloat:targetFloat];
    NSNumber *two = [NSNumber numberWithFloat:achievedFloat];
    NSNumber *three = [NSNumber numberWithFloat:paidFloat];
    
    self.slices = [NSMutableArray arrayWithCapacity:10];
    
    [_slices addObject:two];
    [_slices addObject:one];
    [_slices addObject:three];
    
    
    [self.pieChartLeft setDataSource:self];
    [self.pieChartLeft setDelegate:self];
    [self.pieChartLeft setStartPieAngle:M_PI_2];
    [self.pieChartLeft setAnimationSpeed:1.0];
    [self.pieChartLeft setLabelFont:[UIFont systemFontOfSize:14]];
   //  [self.pieChartLeft setLabelRadius:(self.percentageLabel.frame.size.width/2)+12];
    [self.pieChartLeft setShowPercentage:NO];
    [self.pieChartLeft setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    [self.pieChartLeft setPieCenter:CGPointMake(self.pieChartLeft.frame.size.width/2, self.pieChartLeft.frame.size.width/2)];
    [self.pieChartLeft setUserInteractionEnabled:NO];
    [self.pieChartLeft setLabelShadowColor:[UIColor blackColor]];
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor colorWithRed:222/255.0 green:233/255.0 blue:102/255.0 alpha:1],
                       [UIColor colorWithRed:219/255.0 green:49/255.0 blue:49/255.0 alpha:1],
                       [UIColor colorWithRed:103/255.0 green:170/255.0 blue:57/255.0 alpha:1],
                       [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],
                       [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:1],nil];
    
    
    [self.centerView.layer setCornerRadius:self.centerView.frame.size.width/2];
    self.centerView.backgroundColor = [UIColor whiteColor];
    
    
    
    float sum = (targetFloat + achievedFloat + paidFloat)/100000;
    
  
    
    NSNumberFormatter *comaFormatter = [[NSNumberFormatter alloc] init];
    [comaFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    // [comaFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_IN"] ];
    [comaFormatter setMaximumFractionDigits:2];
    [comaFormatter setRoundingMode: NSNumberFormatterRoundHalfUp];
    comaFormatter.decimalSeparator = @".";
    
    NSString *showSumDataOnDash = [comaFormatter stringFromNumber:[NSNumber numberWithFloat:sum]];
    

    self.valueLabel.text = showSumDataOnDash;
    self.lacLabel.text = @"(In Lacs)";
    [self.pieChartLeft reloadData];
   
    
    self.slicesDataArray = [[NSMutableArray alloc]init];
    [self.slicesDataArray addObject:[NSString stringWithFormat:@"%.2f",achievedFloat]];
    [self.slicesDataArray addObject:[NSString stringWithFormat:@"%.2f",targetFloat]];
    [self.slicesDataArray addObject:[NSString stringWithFormat:@"%.2f",paidFloat]];
    
    dashBoardMenuViewCtrl.secondCellFLippedDataTextArray = self.slicesDataArray;//self.slices;
   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SET_SECONDCELL_FLIPPED_DATA_TEXT" object:nil];
    
}


-(NSString *)setFromDateForYTD:(int) yearReference
{
    //make today Date
    NSDate *today = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =[gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
    
    
    // if month is jan (1), Feb (2), Mar(3)
    NSString* firstDayOfCurrentFinancialYear = [NSString stringWithFormat:@"01/04/%.4ld", ([weekdayComponents month] > 3) ? [weekdayComponents year] + yearReference : [weekdayComponents year] - 1 + yearReference];
    
    return firstDayOfCurrentFinancialYear;
    
}


- (NSDate *)logicalOneYearAfter:(NSDate *)todayDate
{
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setYear:-1];
    
    return [gregorian dateByAddingComponents:offsetComponents toDate:todayDate options:0];
    
}

-(NSString *)setToDateForYTD
{
    NSDate *today = [NSDate date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *toDate = [dateFormat stringFromDate:today];
    return toDate;
}


-(NSString*) lastDayForFinancialYear:(int) yearReference
{
    
    NSDate* today = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =[gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
    
    
    // if month is jan (1), Feb (2), Mar(3)
    NSString* firstDayOfCurrentFinancialYear = [NSString stringWithFormat:@"01/04/%.4ld", ([weekdayComponents month] > 3) ? [weekdayComponents year] : [weekdayComponents year] - 1];
    
    
    NSString* lastDayOfThisFinancialYear = [NSString stringWithFormat:@"31/03/%.4ld", ([weekdayComponents month] > 3) ? ([weekdayComponents year]+1 + yearReference) : [weekdayComponents year] + yearReference];
    
    return lastDayOfThisFinancialYear;
}



#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] floatValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
  //  if(pieChart == self.pieChartRight) return nil;
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}
//- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index
//{
//    return [self.slicesText objectAtIndex:index];
//}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will select slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will deselect slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did deselect slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did select slice at index %d",index);
   // self.selectedSliceLabel.text = [NSString stringWithFormat:@"$%@",[self.slices objectAtIndex:index]];
}


-(void) dealloc
{
    //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"REFRESH_FIRST_TILE" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"REFRESH_SECOND_TILE" object:nil];
}

@end
