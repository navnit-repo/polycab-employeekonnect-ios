//
//  ReportTabularDataSection.h
//  QCMSProject
//
//  Created by Pradeep Singh on 7/27/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//

#import "ReportBaseSection.h"
#import "LoadingView.h"
#import "DotFormPost.h"


@interface ReportTabularDataSection : ReportBaseSection
{
    NSArray* sortedElementIds;
    NSDictionary* reportElements;
    NSArray *cellComponent;
    NSMutableArray *recordTableData;
    DotFormPost *dotFormPost;
    
    LoadingView* loadingView;
    
}

@property(nonatomic,retain) NSMutableDictionary* forwardedDataDisplay;
@property(nonatomic,retain) NSMutableDictionary* forwardedDataPost;


+(NSInteger) tableRowHeight;

+(NSInteger) reportHeaderRowHeight;




-(NSInteger) tableHeaderHeight;
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

-(NSArray*) tableRowDataRecord:(NSInteger) rowIndex;
-(NSDictionary*) reportElements;


-(UIView *) drawTableHeader;

-(NSArray *) createCellComponent;
-(UIView*) initializeDataRowCell;
-(void) configureDataRowCell:(UIView*) dataCell :(NSIndexPath *)indexPath;

-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
