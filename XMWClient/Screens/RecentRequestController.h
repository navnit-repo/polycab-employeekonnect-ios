//
//  RecentRequestController.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 07/10/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuVC.h"
#import "XmwcsConstant.h"
#import "ReportPostResponse.h"
#import "DotReport.h"
#import "DotReportDraw.h"

@interface RecentRequestController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    int screenId;
	NSString* formId;

	MenuVC* parentForm;
	ReportPostResponse* reportResponse;
	NSMutableArray* maxDocIdList;
	NSMutableDictionary* forwardedDataDisplay;
    NSMutableDictionary* forwardedDataPost;
    DotReport* dotReport;
    
    int y_inc;
    int lable_text_height;
    
    UITableView *tableList;
    // for tableviewdelegate and cell renderer
    NSMutableArray *recordTableData;
    NSMutableArray *cellComponent;
    bool m_isClickableRow;
    NSString *m_expandedValue;
}

@property int screenId;
@property NSString* formId;
@property MenuVC* parentForm;
@property ReportPostResponse* reportResponse;
@property NSMutableArray* maxDocIdList;
@property NSMutableDictionary* forwardedDataDisplay;
@property NSMutableDictionary* forwardedDataPost;
@property DotReport* dotReport;

@property NSMutableArray *recordTableData;
@property NSMutableArray *cellComponent;


-(void)initwithData : (int)id : (NSString*)inFormId :(MenuVC*)parentScreen;
-(NSMutableArray*) getRecentReqTableData : itemMap : recentColumnsKey;
-(void) loadData;
-(void) screenDisplay;
- (void) makeReportScreen;


@end
