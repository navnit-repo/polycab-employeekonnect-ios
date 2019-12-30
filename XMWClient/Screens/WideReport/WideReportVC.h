//
//  WideReportVC.h
//  EMSSales
//
//  Created by Pradeep Singh on 30/09/2016.
//  Copyright (c) 2014 Dotvik Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportPostResponse.h"
#import "DotReportDraw.h"
#import "DotReport.h"
#import "HttpEventListener.h"
#import "LoadingView.h"
#import "ReportTabularDataSection.h"
#import "ReportVC.h"
#define kTotalSections 6
#define kReportSectionHeader 0
#define kReportSectionSubHeader 1
#define kReportSectionLegend 2
#define kReportSectionTable 3
#define kReportSectionFooter 4

@interface WideReportVC : ReportVC
{
    int sectionFlag[kTotalSections];
     UIScrollView* hScrollView;
}


@end
