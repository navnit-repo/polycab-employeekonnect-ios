//
//  DotReportListCellRenderer.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 05/08/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DotReportDraw.h"
#import "DotReport.h"

@class DotReportDraw;



@interface DotReportListCellRenderer : NSObject <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *recordTableData;
    NSMutableArray *cellComponent;
    DotReportDraw *dotReortdrawProp;
    DotReport *dotReport;
    bool m_isClickableRow;
    NSString *m_expandedValue;
}

 @property NSMutableArray *recordTableData;
 @property NSMutableArray *cellComponent;
 @property DotReportDraw *dotReortdrawProp;;
 @property DotReport *dotReport;

-(bool) clickableAndExpandable : (int) rowIdx : (NSString*) expandProperty;


+(NSInteger) tableRowHeight;
+(NSInteger) tableHeaderHeight;
+(NSInteger) reportHeaderRowHeight;



@end
