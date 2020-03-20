//
//  FirstDashView.m
//  QCMSProject
//
//  Created by Ashish Tiwari on 14/01/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import "FirstDashView.h"
#import "LoadingView.h"
#import "NetworkHelper.h"
#import "DVAsynchImageView.h"
#import "DotFormPost.h"
#import "DVAppDelegate.h"
#import "ClientVariable.h"
#import "DotForm.h"
#import "DotFormPostUtil.h"
#import "XmwcsConstant.h"
#import "ReportPostResponse.h"
#import "XmwReportService.h"


@interface FirstDashView ()
{
     LoadingView* loadingView;
     NetworkHelper* networkHelper;
    UIActivityIndicatorView *activityIndicator;
}

@end



@implementation FirstDashView

@synthesize dataLable;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code        
       
    }
    return self;
}

+(FirstDashView*) createInstance
{
    FirstDashView *view = (FirstDashView *)[[[NSBundle mainBundle] loadNibNamed:@"FirstDashView" owner:self options:nil] objectAtIndex:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:view selector:@selector(refreshData) name:@"REFRESH_FIRST_TILE" object:nil];
    
    return view;
}

- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    if(loadingView!=nil) {
        [loadingView removeView];
        loadingView = nil;
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
        loadingView = nil;
    }
    
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
    
    DotForm  *dotForm = (DotForm*) [clientVariables.DOT_FORM_MAP objectForKey: @"DOT_FORM_26"] ;
    
    DotFormPost *dotFormPost = [[DotFormPost alloc]init];
    NSMutableDictionary *postData = [[NSMutableDictionary alloc]init];
    [postData setObject:[self setToDateForYTD:yearReference.intValue] forKey:@"TO_DATE"];
    [postData setObject:[self setFromDateForYTD:yearReference.intValue] forKey:@"FROM_DATE"];
    [postData setObject:@"" forKey:@"SPART"];
    
    NSMutableDictionary *displayData = [[NSMutableDictionary alloc]init];
    [displayData setObject:[self setToDateForYTD:yearReference.intValue] forKey:@"TO_DATE"];
    [displayData setObject:[self setFromDateForYTD:yearReference.intValue] forKey:@"FROM_DATE"];
    [displayData setObject:@"All" forKey:@"SPART"];
    
    
    
    [dotFormPost setAdapterType:dotForm.adapterType];
    [dotFormPost setAdapterId:dotForm.submitAdapterId];
    [dotFormPost setModuleId: [DVAppDelegate currentModuleContext]];
    [dotFormPost setDocId:dotForm.formId];
    [dotFormPost setPostData:postData];
    [dotFormPost setDisplayData:displayData];
    
    DotFormPostUtil *dotFormPostUtil = [[DotFormPostUtil alloc]init];
    
    [dotFormPostUtil incrementMaxDocId:dotFormPost];
    
    return dotFormPost;
}

-(void)updateData
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
    
    XmwReportService* reportService = [[XmwReportService alloc] initWithPostData:dotFormPost withContext:@"fetchYTDSales"];
    [reportService fetchReportUsingSuccess:^(DotFormPost* formPosted, ReportPostResponse* reportResponse) {
        
        [activityIndicator removeFromSuperview];
        [self setViewContent:reportResponse];
        
    }   fail:^(DotFormPost* formPosted, NSString* message) {
        [activityIndicator removeFromSuperview];
        
    }];
}



-(void)setViewContent:(ReportPostResponse *)responseYTDData
{
    [activityIndicator stopAnimating];
    
    self.salesSummaryDataYTD = responseYTDData;
    
    NSMutableDictionary *headerData = self.salesSummaryDataYTD.headerData;
    
    NSArray *stringArray = [[headerData objectForKey:@"TOTAL_AMT"]componentsSeparatedByString:@"("];
    if(stringArray != nil)
    {
        for(int i = 0; i<[stringArray count];i++)
        {
            if(i == 0)
            {
                self.dataLable.text = [stringArray objectAtIndex:i];
            }
            else if(i == 1)
            {
                self.lacLabel.text =[@"("stringByAppendingString:[stringArray objectAtIndex:i]];
            }
        }
        
    }
    
    
    NSLog(@"YTD DATA = %@",self.dataLable.text);
    
    self.bottomLineView.backgroundColor = [self colorWithHexString:@"Bfbfbf"];
    self.topLineView.backgroundColor = [self colorWithHexString:@"Bfbfbf"];
    self.ytdLabel.text = @"YTD";

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

-(NSString *)setToDateForYTD:(int) yearReference
{
    NSDate *today = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =[gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    if(yearReference>=0) {
        return [dateFormat stringFromDate:today];
    } else {
        // if month is jan (1), Feb (2), Mar(3)
        NSString* lastDayOfPreviousFinancialYear = [NSString stringWithFormat:@"31/03/%.4ld", ([weekdayComponents month] > 3) ? [weekdayComponents year] + yearReference + 1  : [weekdayComponents year] + yearReference];
        return lastDayOfPreviousFinancialYear;
    }
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


-(void) dealloc
{
    //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"REFRESH_FIRST_TILE" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"REFRESH_FIRST_TILE" object:nil];
}


@end
