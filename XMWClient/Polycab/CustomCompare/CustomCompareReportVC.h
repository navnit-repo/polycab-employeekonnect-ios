//
//  CustomCompareReportVC.h
//  QCMSProject
//
//  Created by Pradeep Singh on 9/4/16.
//  Copyright © 2016 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DotForm.h"
#import "DotFormPost.h"
#import "DotFormElement.h"
#import "ReportPostResponse.h"
#import "LoadingView.h"
#import "DotReport.h"
@interface XmwCompareTuple : NSObject
@property NSString* fieldName;
@property NSString* firstValue;
@property NSString* secondValue;
@property NSString* thirdValue;
@property NSString* uomValue;
@property NSArray* firstRawData;
@property NSArray* secondRawData;
@property NSArray* thirdRawData;
@end


@interface CustomCompareReportVC : UIViewController
{
     NSArray* sortedDataSetKeys;
    NSMutableDictionary* dataSet;
    LoadingView* loadingView;
    int loaderCount;
    NSString* firstColumnText;
    ReportPostResponse* firstResponse;
    NSString* secondColumnText;
    NSString* thirdColumnText;
    ReportPostResponse* secondResponse;
    ReportPostResponse* thirdResponse;
    
    NSMutableArray *orignalThirdResponseData;
    NSMutableDictionary* orignalDataSet;
    NSArray* orignalSortedDataSetKeys;
}

@property (strong, nonatomic) NSArray* orignalSortedDataSetKeys;
@property (strong, nonatomic) NSMutableArray *orignalThirdResponseData;
@property (strong, nonatomic) NSMutableDictionary* orignalDataSet;


@property  NSString* thirdColumnText;
@property   ReportPostResponse* secondResponse;
@property   ReportPostResponse* thirdResponse;
@property NSString* secondColumnText;
@property ReportPostResponse* firstResponse;
@property NSString* firstColumnText;
@property (weak, nonatomic) DotForm* dotForm;

@property (strong, nonatomic) DotFormPost* firstFormPost;
@property (strong, nonatomic) DotFormPost* secondFormPost;
@property (strong, nonatomic) DotFormPost* thirdFormPost;

@property (nonatomic, retain) NSMutableDictionary* forwardedDataDisplay;
@property (nonatomic, retain) NSMutableDictionary* forwardedDataPost;


@property (weak, nonatomic) IBOutlet UITableView* mainTable;
@property  NSArray* sortedDataSetKeys;
@property NSMutableDictionary* dataSet;
-(void) handleDrilldown:(NSInteger) rowIndex;
-(NSArray*) pickGoodRawData:(NSArray*) best option:(NSArray*)other1 option:(NSArray*) other2;
-(DotFormPost*)ddColumnDotFormPost:(DotFormPost*) dotFormPost rowIndex:(NSInteger) rowIndex columnRowData:(NSArray*) colRowData;
-(void) addFirstSetData:(ReportPostResponse*) reportData into:(NSMutableDictionary*) inDataSet;
-(void) addSecondSetData:(ReportPostResponse*) reportData into:(NSMutableDictionary*) inDataSet;
-(void) addThirdSetData:(ReportPostResponse*) reportData into:(NSMutableDictionary*) inDataSet;
-(bool) clickable:(NSInteger) rowIdx;
-(void) fetchFirstColumnData:(DotFormPost*) formPost;
-(NSArray*) sortKeys;
-(DotReport*) dotReport;
-(NSString*) totalHeaderValue:(ReportPostResponse*) reportResponse;
-(double) unformattedTotalHeaderValue:(ReportPostResponse*) reportResponse;
-(NSString*) zeroColumnHeading;

-(void) handleExpiredSession;

@end
