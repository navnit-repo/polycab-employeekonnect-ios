//
//  ReportSubheaderSection.m
//  QCMSProject
//
//  Created by Pradeep Singh on 7/27/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//

#import "ReportSubheaderSection.h"
#import "XmwcsConstant.h"
#import "DotReport.h"
#import "ReportPostResponse.h"


@interface ReportSubheaderSection ()
{
    NSMutableDictionary* reportElements;
}

@end

@implementation ReportSubheaderSection



-(id)init {
    self = [super init];
    if (self) {
        self.componentPlace = XmwcsConst_REPORT_PLACE_HEADER;
    }
    return self;
}

-(void) updateData:(DotReport *)inDotReport :(ReportPostResponse *)inReportPostResponse
{
    [super updateData:inDotReport :inReportPostResponse];
    
    reportElements = self.dotReport.reportElements;
}



-(UIView *)viewForCellAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat screenWidth = self.tableView.frame.size.width;

    NSString* temp = @"General";
    
    CGSize calcLeftSize = [temp boundingRectWithSize:CGSizeMake(screenWidth/2-10, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:12] } context:nil].size;

    UIView *elementContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, calcLeftSize.height) ];
    
    NSMutableArray *subHeaderData = self.reportPostResponse.subHeaderData;
    
    int x = 0;
            
    NSMutableArray* record =  (NSMutableArray*)[subHeaderData objectAtIndex:indexPath.row];
            
    for(int cntReord = 0; cntReord < [record count]; cntReord++)
    {
        UILabel *child = [[UILabel alloc] initWithFrame:CGRectMake(x+2, 0, screenWidth/[record count], calcLeftSize.height)];
        child.text = [record objectAtIndex:cntReord];
        [child setFont:[UIFont systemFontOfSize:12]];
        child.numberOfLines = 0;
        child.tag = 1000+cntReord;
                
        [elementContainer addSubview:child];
        x = x + screenWidth/[record count];
    }
    return elementContainer;
}

-(void) configureView:(UIView *)view forIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *subHeaderData = self.reportPostResponse.subHeaderData;
    NSMutableArray* record =  (NSMutableArray*)[subHeaderData objectAtIndex:indexPath.row];
    
    for(int cntReord = 0; cntReord < [record count]; cntReord++)
    {
        UILabel *child = (UILabel*)[view viewWithTag:(1000+cntReord) ];
        child.text = [record objectAtIndex:cntReord];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.reportPostResponse.subHeaderData !=nil) {
        
        return [self.reportPostResponse.subHeaderData count];
    }
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat screenWidth = self.tableView.frame.size.width;

    NSString* temp = @"General";
    
    CGSize calcLeftSize = [temp boundingRectWithSize:CGSizeMake(screenWidth/2-10, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:12] } context:nil].size;
    
    return calcLeftSize.height + 5.0f;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SubHeaderDataSectionCell"];
    if(cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SubHeaderDataSectionCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView* customView = [cell.contentView viewWithTag:2001];
    
    if(customView!=nil) {
        [customView removeFromSuperview];
    }
    
    customView = [self viewForCellAtIndexPath:indexPath];
    customView.tag = 2001;
    [cell.contentView addSubview:customView];
    
    return cell;
}


-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView* customView = [cell.contentView viewWithTag:2001];
    
    if(customView!=nil) {
        [self configureView:customView forIndexPath:indexPath];
    }
}

@end
