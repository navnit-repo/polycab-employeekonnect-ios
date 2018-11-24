//
//  DotReportDraw.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 24/07/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DotReport.h"
#import "ReportPostResponse.h"
#import "DotReportElement.h"
#import "DotReportListCellRenderer.h"
#import "HttpEventListener.h"
#import "DotFormPost.h"


@class ReportVC, DotReportListCellRenderer;

@interface DotReportDraw : NSObject <HttpEventListener,UIViewControllerRestoration , UITextViewDelegate, UIScrollViewDelegate>
{
@private
    NSMutableDictionary *dotReportElements;
    DotReport *dotReport;
    ReportPostResponse *reportPostResponse;
    ReportVC *reportVC;
    UITableView *tableList;
    DotReportListCellRenderer *dotReportListRenderer;
    NSMutableDictionary *forwardedDataDisplay;
    NSMutableDictionary *forwardedDataPost;
    
    int y_inc;
    int lable_text_height;
    DotFormPost* dotFormPost;
    
}
@property NSMutableDictionary *forwardedDataDisplay;
@property NSMutableDictionary *forwardedDataPost;
@property NSMutableDictionary *dotReportElements;
@property DotReport *dotReport;
@property ReportPostResponse *reportPostResponse;
@property ReportVC *reportVC;
@property DotFormPost* dotFormPost;

-(void)initReport : (DotReport*) in_DotReport : (ReportPostResponse*) in_ReportPostResponse;
-(void)makeReportScreen : (ReportVC*) reportVC : (DotReport*) in_DotReport : (ReportPostResponse*) in_ReportPostResponse : (NSMutableDictionary *) forwardedDataDisplay : (NSMutableDictionary *) forwardedDataPost;
-(void) drawHeader : (NSMutableDictionary *) sortedElementIds :(UIView *) headerContainer : (NSMutableDictionary*) forwardedDataDisplay : (NSMutableDictionary *) forwardedDataPost;
-(void) drawTable : (NSMutableDictionary *) sortedElementIds : (UIView *) tableContainer;

-(NSMutableArray *) drawTableHeader : (NSMutableArray *) sortedElementIds : (UIView *) tableContainer;
-(void) drawFooter : (NSMutableArray *) sortedElementIds : (UIView *) footerContainer;
 -(void)drawSubHeader : (UIView *) subHeaderContainer;

-(void) drawButtonFooter : (DotReportElement *) dotReportElement : (UIView *) footerCont : (NSMutableDictionary *) footerGetData;
-(void) drawFooterTextField : (DotReportElement *) dotReportElement : (UIView *) footerCont : (NSMutableDictionary *) footerGetData;
+(NSMutableArray *) sortRptComponents : (NSMutableDictionary *) dotReportElements : (NSString *) placeType;

-(void) handleDrillDown : (NSInteger) position :(NSMutableDictionary *) forwardedDataDisplay :(NSMutableDictionary *) forwardedDataPost;

// - (CGFloat)heightForText:(NSString *)bodyText;

-(void) makeLegends : (UIView *) container;


@end
