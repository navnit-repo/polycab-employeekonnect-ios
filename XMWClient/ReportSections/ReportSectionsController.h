//
//  ReportSectionsController.h
//  Dotvik XMW
//
//  Created Pradeep
//
//

#import <Foundation/Foundation.h>
#import "ReportBaseSection.h"
#import "DotReport.h"
#import "ReportPostResponse.h"


@interface ReportSectionsController : NSObject <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,assign) UITableView* tableView;
@property(nonatomic,retain) NSIndexPath* visibleRow;
@property(nonatomic,retain) NSArray* sections;

@property(nonatomic,retain) DotReport* dotReport;
@property(nonatomic, retain) ReportPostResponse* reportPostResponse;

-(void)updateData: (DotReport*) inDotReport :(ReportPostResponse*) inReportPostResponse;

@end


