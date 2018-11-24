//
//  CustomeReportVC.m
//  XMWClient
//
//  Created by dotvikios on 03/10/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "CustomeReportVC.h"
#import "XmwUtils.h"
#import "XmwcsConstant.h"
#import "CustomeReportHeader.h"
#import "ReportLegendSection.h"
#import "ReportSectionsController.h"
#import "ReportFooterSection.h"
#import "ReportSubheaderSection.h"
@implementation CustomeReportVC

-(void) makeReportScreenV2
{
    
    
    
    self.reportTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 35, self.view.frame.size.width, self.view.frame.size.height-35)];
    self.reportTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    
    
    
    
    sectionArray = [[NSMutableArray alloc] init];
    sectionController = [[ReportSectionsController alloc] init];
    sectionController.tableView = self.reportTableView;
    self.reportTableView.dataSource = sectionController;
    self.reportTableView.delegate = sectionController;
    
    sectionController.sections = sectionArray;
    
    
    NSMutableArray *placeVector = [XmwUtils breakStringTokenAsVector : dotReport.reportPlaces : @"$"];
    for (int cntComponentPlace = 0; cntComponentPlace < [placeVector count]; cntComponentPlace++)
    {
        NSString *componentPlace = (NSString*) [placeVector objectAtIndex:cntComponentPlace];
        
        if([componentPlace isEqualToString : XmwcsConst_REPORT_PLACE_HEADER])
        {
            CustomeReportHeader* headerSection = [[CustomeReportHeader alloc] init];
            headerSection.forwardedDataDisplay = forwardedDataDisplay;
            headerSection.forwardedDataPost = forwardedDataPost;
            headerSection.reportVC = self;
            [sectionArray addObject:headerSection];
        }
        else if([componentPlace isEqualToString : XmwcsConst_REPORT_PLACE_TABLE])
        {
            if([dotReport.reportType isEqualToString:XmwcsConst_REPORT_TYPE_LEGEND])
            {
                ReportLegendSection* legendSection = [[ReportLegendSection alloc] init];
                [sectionArray addObject:legendSection];
                legendSection.reportVC = self;
            }
            
            ReportTabularDataSection* dataSection = [self addTabularDataSection];
            [sectionArray addObject:dataSection];
        }
        else if([componentPlace isEqualToString : XmwcsConst_REPORT_PLACE_FOOTER ])
        {
            ReportFooterSection* footerSection = [[ReportFooterSection alloc] init];
            footerSection.reportVC = self;
            [sectionArray addObject:footerSection];
        }
        else if([componentPlace isEqualToString :XmwcsConst_REPORT_PLACE_SUBHEADER ])
        {
            ReportSubheaderSection* subheaderSection = [[ReportSubheaderSection alloc] init];
            subheaderSection.reportVC = self;
            [sectionArray addObject:subheaderSection];
        }
    }
    [sectionController updateData:dotReport : reportPostResponse ];
    [self.view addSubview : self.reportTableView];
    
}
-(ReportTabularDataSection*) addTabularDataSection
{
    ReportTabularDataSection* dataSection = [[ReportTabularDataSection alloc] init];
    dataSection.forwardedDataDisplay = forwardedDataDisplay;
    dataSection.forwardedDataPost = forwardedDataPost;
    dataSection.reportVC = self;
    
    return  dataSection;
}

@end
