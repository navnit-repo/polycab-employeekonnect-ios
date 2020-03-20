//
//  CreditLimitPieChart.m
//  XYPieChart
//
//  Created by Ashish Tiwari on 28/01/15.
//  Copyright (c) 2015 Xiaoyang Feng. All rights reserved.
//

#import "CreditLimitPieChart.h"
#import <QuartzCore/QuartzCore.h>
#import "XmwcsConstant.h"
#import "DVAppDelegate.h"
#import "ClientVariable.h"
#import "DotFormPost.h"
#import "AppConstants.h"

#import "Styles.h"


@interface CreditLimitPieChart ()
{
   
}

@end


@implementation CreditLimitPieChart

@synthesize selectedSliceLabel = _selectedSlice;
@synthesize pieChartRight = _pieChart;
@synthesize slices = _slices;
@synthesize sliceColors = _sliceColors;
@synthesize paybleAmt;
@synthesize remainCredit;

@synthesize graphData;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    //fetch data for credit limit piechart
    
  //  [self fetchCreditLimitPieChartData];
    
     [self makePieChartFromData : graphData];
      
    [self drawHeaderItem];
    
}

-(void) drawHeaderItem
{
    self.title = @"Payable Amount";
    [self drawTitle: @"Payable Amount"];
    
    self.navigationController.navigationBar.tintColor = [Styles barButtonTextColor];
    
}

- (void) backHandler : (id) sender {
    
    [ [self navigationController]  popViewControllerAnimated:YES];
    
    }

-(void) drawTitle:(NSString *)headerStr
    {
        NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor whiteColor],NSForegroundColorAttributeName,
                                        [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
        
        self.navigationController.navigationBar.titleTextAttributes = textAttributes;
        // self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.translucent = NO;
        
        UILabel*  titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
        titleLabel.text = @"Payable Amount";
        titleLabel.textColor = [Styles headerTextColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        [self.navigationItem setTitleView: titleLabel];
        
    }


-(void)fetchCreditLimitPieChartData
{
        
    DotFormPost *dotFormPost = [[DotFormPost alloc]init];
    [dotFormPost setAdapterType:@"SAP"];
    [dotFormPost setAdapterId:@"DOT_REPORT_21"];
    [dotFormPost setModuleId: [DVAppDelegate currentModuleContext]];
    [dotFormPost setDocId:@"DOT_REPORT_21"];
    
    loadingView = [LoadingView loadingViewInView:self.view];
    
    networkHelper = [[NetworkHelper alloc] init];
    [networkHelper makeXmwNetworkCall:dotFormPost :self : nil :  XmwcsConst_CALL_NAME_FOR_REPORT];
}


- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    [loadingView removeFromSuperview];
    
    if ([callName isEqualToString : XmwcsConst_CALL_NAME_FOR_REPORT])
    {
        ReportPostResponse *reportPostResponse = (ReportPostResponse*) respondedObject;
        [self makePieChartFromData : reportPostResponse];
    }
}


- (void) httpFailureHandler : (NSString*) callName : (NSString*) message
{
    [loadingView removeFromSuperview];
    
}

-(void)makePieChartFromData : (ReportPostResponse *)postResponseData
{
    NSMutableDictionary *headerDicData = postResponseData.headerData;
    NSString *receivable = [headerDicData objectForKey:@"E_RECEIVABLE"];
    NSString *creditLimitAmt = [headerDicData objectForKey:@"E_CRD_LIMIT_AMT"];
    
    NSString *libilities  = [headerDicData objectForKey:@"E_LIABILITY"];
    
    
    NSNumber *receivableNum = [NSNumber numberWithInt:[[receivable stringByReplacingOccurrencesOfString:@"," withString:@""] intValue]];
    NSNumber *libilitiesNum = [NSNumber numberWithInt:[[libilities stringByReplacingOccurrencesOfString:@"," withString:@""] intValue]];
    NSNumber *creditLimAmtNum = [NSNumber numberWithInt:[[creditLimitAmt stringByReplacingOccurrencesOfString:@"," withString:@""] intValue]];
    NSNumber *subOfRecLibAndAmtNum = [NSNumber numberWithInt:([[creditLimitAmt stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] - ([[receivable stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] + [[libilities stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] ))];
    
    NSNumber *sumOfRecAndLib = [NSNumber numberWithInt:([[receivable stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] + [[libilities stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] )];
    
    self.slices = [NSMutableArray arrayWithCapacity:10];
    
    [_slices addObject:sumOfRecAndLib];
    [_slices addObject:subOfRecLibAndAmtNum];
    
    [self.pieChartRight setDelegate:self];
    [self.pieChartRight setDataSource:self];
    [self.pieChartRight setPieCenter:CGPointMake(self.pieChartRight.frame.size.width/2, self.pieChartRight.frame.size.width/2)];
    [self.pieChartRight setShowPercentage:NO];
    [self.pieChartRight setLabelColor:[UIColor blackColor]];
    
    
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor colorWithRed:51/255.0 green:160/255.0 blue:255/255.0 alpha:1],
                       [UIColor colorWithRed:249/255.0 green:157/255.0 blue:5/255.0 alpha:1],
                       [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
                       [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],
                       [UIColor colorWithRed:148/255.0 green:141/255.0 blue:139/255.0 alpha:1],nil];
    
    [self.pieChartRight reloadData];

    
    self.paybleAmt.text = @"Payable Amount";
    self.remainCredit.text = @"Remaining Credit";
    self.paybleAmt.backgroundColor = [self colorWithHexString:@"33A0FF"];
    self.remainCredit.backgroundColor = [self colorWithHexString:@"F99D05"];
    
    
    NSNumberFormatter *comaFormatter = [[NSNumberFormatter alloc] init];
    [comaFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [comaFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_IN"] ];
    //[comaFormatter setMaximumFractionDigits:2];
   // [comaFormatter setRoundingMode: NSNumberFormatterRoundUp];
    
    
    self.paybleAmtValue.text = [comaFormatter stringFromNumber:sumOfRecAndLib];//[NSString stringWithFormat:@"%@",sumOfRecAndLib];
    self.remainCrtValue.text =  [comaFormatter stringFromNumber:subOfRecLibAndAmtNum];//[NSString stringWithFormat:@"%@",subOfRecLibAndAmtNum];
    
    
}



#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
   // if(pieChart == self.pieChartRight) return nil;
    return [self.sliceColors objectAtIndex:index];
}

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
    self.selectedSliceLabel.text = [NSString stringWithFormat:@"%@",[self.slices objectAtIndex:index]];
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


@end
