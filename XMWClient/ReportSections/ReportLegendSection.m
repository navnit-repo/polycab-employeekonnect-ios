//
//  ReportLegendSection.m
//  QCMSProject
//
//  Created by Pradeep Singh on 7/27/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//

#import "ReportLegendSection.h"
#import "ClientVariable.h"
#import "DVAppDelegate.h"


@implementation ReportLegendSection


-(void) updateData:(DotReport *)inDotReport :(ReportPostResponse *)inReportPostResponse
{
    [super updateData:inDotReport :inReportPostResponse];
}


-(UIView *)viewForCellAtIndexPath:(NSIndexPath *)indexPath
{
    
    ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];

    int screenWidth = self.tableView.frame.size.width-10;
    
    NSString* temp = @"General";
    
    CGSize calcLeftSize = [temp boundingRectWithSize:CGSizeMake(screenWidth/2-10, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:14] } context:nil].size;
    
    int cellHeight = calcLeftSize.height + 10;
    
    UIView *elementContainer = [[UIView alloc] initWithFrame:CGRectMake(5, 0, screenWidth, cellHeight) ];
    elementContainer.backgroundColor = [[UIColor alloc] initWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1.0];
    
    int legendEdge = cellHeight - 4;

    // we are displaying 2 columns in a row for legends
    // for first column
   
    UILabel* mItemLabel = [[UILabel alloc]initWithFrame:CGRectMake(5 + legendEdge + 5 , 5, screenWidth/2 - legendEdge - 10, calcLeftSize.height)];
    [mItemLabel setFont:[UIFont systemFontOfSize:14]];
    mItemLabel.tag = 1001;
    [elementContainer addSubview:mItemLabel];
    
    UIView* legendCont = [[UIView alloc]initWithFrame:CGRectMake(5, 2, legendEdge, legendEdge)];
    legendCont.tag = 1002;
    [elementContainer addSubview:legendCont];
    
    // for second column
    
    mItemLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2 + 5 + legendEdge + 5, 5, screenWidth/2 - legendEdge - 10, calcLeftSize.height)];
    [mItemLabel setFont:[UIFont systemFontOfSize:14]];
    mItemLabel.tag = 1003;
    [elementContainer addSubview:mItemLabel];
    
    legendCont = [[UIView alloc]initWithFrame:CGRectMake(screenWidth/2 + 5, 2, legendEdge, legendEdge)];
    legendCont.tag = 1004;
    [elementContainer addSubview:legendCont];

    
    return elementContainer;
}


-(void) configureView:(UIView *)view forIndexPath:(NSIndexPath *)indexPath
{
    ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    NSMutableDictionary *colorMap = (NSMutableDictionary *)[clientVariables.CLIENT_APP_MASTER_DATA objectForKey:self.dotReport.legendColorOn];
    NSMutableDictionary *nameMap = (NSMutableDictionary *)[clientVariables.CLIENT_APP_MASTER_DATA objectForKey:self.dotReport.legendNameOn];

    int firstColIdx = indexPath.row*2;
    int secondColIdx = firstColIdx + 1;

    
    NSArray* nameKeys = [nameMap allKeys];
    
    NSString* firstColKey = [nameKeys objectAtIndex:firstColIdx];
    NSString* firstColLegendName = [nameMap objectForKey:firstColKey];
    NSString* firstColColorCode = [colorMap objectForKey:firstColKey];
    
    UILabel* mItemLabel = (UILabel*)[view viewWithTag:1001];
    mItemLabel.text = firstColLegendName;
    UIView* mLegendCont = (UILabel*)[view viewWithTag:1002];
    mLegendCont.backgroundColor = [XmwUtils colorWithHexString:firstColColorCode];
    
    
    if(secondColIdx<[nameKeys count]) {
        NSString* secondColKey = [nameKeys objectAtIndex:secondColIdx];
        NSString* secondColLegendName = [nameMap objectForKey:secondColKey];
        NSString* secondColColorCode = [colorMap objectForKey:secondColKey];
        
        mItemLabel = (UILabel*)[view viewWithTag:1003];
        mItemLabel.text = secondColLegendName;
        
        mLegendCont = (UILabel*)[view viewWithTag:1004];
        mLegendCont.backgroundColor = [XmwUtils colorWithHexString:secondColColorCode];
    } else {
        mItemLabel = (UILabel*)[view viewWithTag:1003];
        mItemLabel.text = @"";
        
        mLegendCont = (UILabel*)[view viewWithTag:1004];
        mLegendCont.backgroundColor = [UIColor clearColor];
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
    
    ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    NSMutableDictionary *colorMap = (NSMutableDictionary *)[clientVariables.CLIENT_APP_MASTER_DATA objectForKey:self.dotReport.legendColorOn];
    NSMutableDictionary *nameMap = (NSMutableDictionary *)[clientVariables.CLIENT_APP_MASTER_DATA objectForKey:self.dotReport.legendNameOn];
    
    if(nameMap!=nil) {
        NSArray* nameKeys = [nameMap allKeys];
        
        int totalLines = 0;
        for(int i=0; i<[nameKeys count]; i=i+2) {
            totalLines = totalLines + 1;
        }
        
        if(totalLines*2 < [nameKeys count]) {
            totalLines = totalLines + 1;
        }
        return totalLines;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int screenWidth = self.tableView.frame.size.width-10;
    
    NSString* temp = @"General";
    
    CGSize calcLeftSize = [temp boundingRectWithSize:CGSizeMake(screenWidth/2-10, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:14] } context:nil].size;
    
    CGFloat cellHeight = calcLeftSize.height + 10;
    
    return cellHeight;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"LegendDataSectionCell"];
    if(cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"LegendDataSectionCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView* customView = [cell.contentView viewWithTag:5001];
    if(customView!=nil) {
        [customView removeFromSuperview];
    }
    
    customView = [self viewForCellAtIndexPath:indexPath];
    customView.tag = 5001;
    [cell.contentView addSubview:customView];
    
    [self configureView:customView forIndexPath:indexPath];
    
}


@end
