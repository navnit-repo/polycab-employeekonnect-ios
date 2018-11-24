//
//  ForthDashView.m
//  QCMSProject
//
//  Created by Ashish Tiwari on 14/01/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import "ForthDashView.h"
#import "LoadingView.h"
#import "NetworkHelper.h"
#import "DVAsynchImageView.h"
#import "DotFormPost.h"
#import "DVAppDelegate.h"
#import "ClientVariable.h"
#import "DotForm.h"
#import "XmwcsConstant.h"
#import "AppConstants.h"
#import "ReportPostResponse.h"
#import "XmwReportService.h"


@interface ForthDashView ()
{
    LoadingView* loadingView;
    NetworkHelper* networkHelper;
    UIActivityIndicatorView *activityIndicator;
}

@end


@implementation ForthDashView
@synthesize dataLable;
@synthesize dashViewContlr;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        
             
        
    }
    return self;
}


+(ForthDashView*) createInstance
{
    
    ForthDashView *view = (ForthDashView *)[[[NSBundle mainBundle] loadNibNamed:@"ForthDashView" owner:self options:nil] objectAtIndex:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:view selector:@selector(refreshData) name:@"REFRESH_FOURTH_TILE" object:nil];
    
    return view;
}

- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    if(loadingView!=nil) {
        [loadingView removeView];
        loadingView = nil;
    }
    
    if(activityIndicator!=nil) {
        [activityIndicator removeFromSuperview];
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
        loadingView = nil;
    }
    
    if(activityIndicator!=nil) {
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        activityIndicator = nil;
    }
    
}


-(DotFormPost*) createDotFormPost
{

    DotFormPost *dotFormPost = [[DotFormPost alloc]init];
    [dotFormPost setAdapterType:@"SAP"];
    [dotFormPost setAdapterId:@"DOT_REPORT_21"];
    [dotFormPost setModuleId:AppConst_MOBILET_ID_DEFAULT];
    [dotFormPost setDocId:@"DOT_REPORT_21"];
    
    
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
    
    XmwReportService* reportService = [[XmwReportService alloc] initWithPostData:dotFormPost withContext:@"fetchPayableData"];
    [reportService fetchReportUsingSuccess:^(DotFormPost* formPosted, ReportPostResponse* reportResponse) {
        
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        [self setViewContent:reportResponse];
        activityIndicator = nil;
        
    }   fail:^(DotFormPost* formPosted, NSString* message) {
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        activityIndicator = nil;
        
    }];

}

-(void)setViewContent:(ReportPostResponse *)responsePayTotaleAmt
{
    self.payableSummary =  responsePayTotaleAmt;
    
    dashViewContlr.forthCellreportPostResData = self.payableSummary;
    
    NSMutableDictionary *headerData = self.payableSummary.headerData;
    
    NSMutableString *receivableString = [[NSMutableString alloc]init];
    NSArray *receivableArray = [[headerData objectForKey:@"E_RECEIVABLE"] componentsSeparatedByString:@","];
    for(int i =0; i<[receivableArray count];i++)
    {
        receivableString = [receivableString stringByAppendingString:[receivableArray objectAtIndex:i]];
    }
    float receivable = [receivableString floatValue];
    
    NSMutableString *liabilityString = [[NSMutableString alloc]init];
    NSArray *liabilityArray = [[headerData objectForKey:@"E_LIABILITY"] componentsSeparatedByString:@","];
    for(int idx =0; idx<[liabilityArray count];idx++)
    {
        liabilityString = [liabilityString stringByAppendingString:[liabilityArray objectAtIndex:idx]];
    }
    float liability  = [liabilityString floatValue];
    
    float sum = receivable + liability;
    
    //float floatSum = [[NSNumber numberWithInt: sum] floatValue];
    
    float div = (sum/100000);
    
    NSNumberFormatter *comaFormatter = [[NSNumberFormatter alloc] init];
     [comaFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    // [comaFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_IN"] ];
    [comaFormatter setMaximumFractionDigits:2];
    [comaFormatter setMinimumFractionDigits:2];
    [comaFormatter setRoundingMode: NSNumberFormatterRoundUp];
    comaFormatter.decimalSeparator = @".";
   
    NSString *showSumDataOnDash = [comaFormatter stringFromNumber:[NSNumber numberWithFloat:div]];
    
    self.dataLable.text = showSumDataOnDash;
    NSLog(@"Credit Exposer = %@",self.dataLable.text);
    
    self.bottomLineView.backgroundColor = [self colorWithHexString:@"Bfbfbf"];
    self.topLineView.backgroundColor = [self colorWithHexString:@"Bfbfbf"];
    self.lacLabel.text = @"(In Lacs)";
    
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"REFRESH_FOURTH_TILE" object:nil];
}


@end
