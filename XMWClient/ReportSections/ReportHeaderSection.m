//
//  ReportHeaderSection.m
//  QCMSProject
//
//  Created by Pradeep Singh on 7/27/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//

#import "ReportHeaderSection.h"
#import "DotReportElement.h"
#import "XmwcsConstant.h"
#import "DotReportDraw.h"
#import "XmwUtils.h"


@interface ReportHeaderSection ()
{
    
    
}

@end


@implementation ReportHeaderSection

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
    sortedElementIds =[DotReportDraw sortRptComponents : reportElements : self.componentPlace];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *keyOfComp =  (NSString *) [sortedElementIds objectAtIndex :indexPath.row];
    DotReportElement *dotReportElement = (DotReportElement *) [reportElements objectForKey:keyOfComp];
    
    if((dotReportElement.componentStyle !=nil) &&  ![dotReportElement.componentStyle isEqualToString:@""]) {
        return [self heightWithStyle:indexPath];
    } else {
        return [self heightNoStyle:indexPath];
    }
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderDataSectionCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"HeaderDataSectionCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView* customView = [cell.contentView viewWithTag:1001];
    
    if(customView==nil) {
        customView = [self viewForCellAtIndexPath:indexPath];
        customView.tag = 1001;
        [cell.contentView addSubview:customView];

    }
    
    return cell;
}


-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView* customView = [cell.contentView viewWithTag:1001];
    
    if(customView!=nil) {
        [self configureView:customView forIndexPath:indexPath];
    }
}


-(UIView *)viewForCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *keyOfComp =  (NSString *) [sortedElementIds objectAtIndex :indexPath.row];
    DotReportElement *dotReportElement = (DotReportElement *) [reportElements objectForKey:keyOfComp];
    
    if((dotReportElement.componentStyle !=nil) &&  ![dotReportElement.componentStyle isEqualToString:@""]) {
        return [self viewWithStyle:indexPath];
    } else {
        return [self viewNoStyle:indexPath];
    }
}


-(CGFloat) heightNoStyle:(NSIndexPath *)indexPath
{
//    CGFloat screenWidth = self.tableView.frame.size.width;
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;

    NSString *keyOfComp =  (NSString *) [sortedElementIds objectAtIndex :indexPath.row];
    DotReportElement *dotReportElement = (DotReportElement *) [reportElements objectForKey:keyOfComp];
    
    CGSize calcLeftSize = [dotReportElement.displayText boundingRectWithSize:CGSizeMake(screenWidth/2-10, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:14] } context:nil].size;
    
    
    NSString *headerValue = [self computeHeaderLineValue:dotReportElement];
    CGSize calcRightSize = [headerValue boundingRectWithSize:CGSizeMake(screenWidth/2-10, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:14] } context:nil].size;
    
    
    CGFloat headerRowHeight = calcLeftSize.height;
    
    if(headerRowHeight<calcRightSize.height) {
        headerRowHeight = calcRightSize.height;
    }
    
    headerRowHeight = headerRowHeight + 10.0f;  // padding
    return headerRowHeight;
}

-(UIView *)viewNoStyle:(NSIndexPath *)indexPath
{
//    CGFloat screenWidth = self.tableView.frame.size.width;
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;

    NSString *keyOfComp =  (NSString *) [sortedElementIds objectAtIndex :indexPath.row];
    DotReportElement *dotReportElement = (DotReportElement *) [reportElements objectForKey:keyOfComp];
    
    CGSize calcLeftSize = [dotReportElement.displayText boundingRectWithSize:CGSizeMake(screenWidth/2-10, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:14] } context:nil].size;
    
    
    NSString *headerValue = [self computeHeaderLineValue:dotReportElement];
    CGSize calcRightSize = [headerValue boundingRectWithSize:CGSizeMake(screenWidth/2-10, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:14] } context:nil].size;
    
    
    int headerRowHeight = calcLeftSize.height;
    
    if(headerRowHeight<calcRightSize.height) {
        headerRowHeight = calcRightSize.height;
    }
    
    headerRowHeight = headerRowHeight + 10;
    
    UIView *elementContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, headerRowHeight) ];
    
    UILabel *lblHeaderTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, screenWidth/2 - 10, calcLeftSize.height)];
    lblHeaderTitle.text = dotReportElement.displayText;
    [lblHeaderTitle setFont:[UIFont systemFontOfSize:14]];
    lblHeaderTitle.tag = 11;
    
    [elementContainer addSubview:lblHeaderTitle];
    
    UILabel *lblHeaderValue = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2+5, 5, screenWidth/2 - 10, calcRightSize.height)];
    //[lblHeaderValue setFont:[UIFont systemFontOfSize:14]];
    [lblHeaderValue setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightBold]];

    lblHeaderValue.text  = headerValue;
    lblHeaderValue.numberOfLines = 0;
    lblHeaderValue.tag = 12;
    
    [elementContainer addSubview:lblHeaderValue];
    
    //If this field value is use in Next Screen
    if([dotReportElement isUseForwardBool]) {
        [self.forwardedDataDisplay setObject:headerValue forKey:dotReportElement.elementId];
        [self.forwardedDataPost setObject:headerValue forKey:dotReportElement.elementId];
    }
    
    return elementContainer;
}

-(CGFloat)heightWithStyle:(NSIndexPath *)indexPath
{
    CGFloat screenWidth = self.tableView.frame.size.width;
    NSString *keyOfComp =  (NSString *) [sortedElementIds objectAtIndex :indexPath.row];
    DotReportElement *dotReportElement = (DotReportElement *) [reportElements objectForKey:keyOfComp];
    
    NSMutableDictionary* styles = [XmwUtils getExtendedPropertyMap : dotReportElement.componentStyle];
    
    NSString* rightAlignment = [styles objectForKey:XmwcsConst_STYLE_PREOPERTY_ALIGNMENT];
    NSTextAlignment rightValueAlignment = NSTextAlignmentRight;
    
    if([rightAlignment isEqualToString:XmwcsConst_STYLE_ALIGNMENT_LEFT]) {
        rightValueAlignment = NSTextAlignmentLeft;
    } else if ([rightAlignment isEqualToString:XmwcsConst_STYLE_ALIGNMENT_RIGHT]) {
        rightValueAlignment = NSTextAlignmentRight;
    } else if ([rightAlignment isEqualToString:XmwcsConst_STYLE_ALIGNMENT_HECNTER]) {
        rightValueAlignment = NSTextAlignmentCenter;
    }
    
    
    NSString *headerValue = [self computeHeaderLineValue:dotReportElement];
    CGSize calcLeftSize;
    CGSize calcRightSize;
    
    
    CGFloat headerRowHeight = 0.0f;
    
    NSString* styleLine = [styles objectForKey:XmwcsConst_STYLE_PREOPERTY_LINE];
    
    if(styleLine != nil && [styleLine isEqualToString:XmwcsConst_STYLE_LABEL_NEWLINE]) {
        calcLeftSize = [dotReportElement.displayText boundingRectWithSize:CGSizeMake(screenWidth-10, 1024) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:14] } context:nil].size;
        
        calcRightSize = [headerValue boundingRectWithSize:CGSizeMake(screenWidth - 10, 1024) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:14] } context:nil].size;
        
        headerRowHeight = calcLeftSize.height + calcRightSize.height + 10;
        
    } else {
        calcLeftSize = [dotReportElement.displayText boundingRectWithSize:CGSizeMake(screenWidth/2-10, 1024) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:14] } context:nil].size;
        
        calcRightSize = [headerValue boundingRectWithSize:CGSizeMake(screenWidth/2-10, 1024) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:14] } context:nil].size;
        
        headerRowHeight = calcLeftSize.height;
        
        if(headerRowHeight<calcRightSize.height) {
            headerRowHeight = calcRightSize.height;
        }
        
        headerRowHeight = headerRowHeight + 10;
    }
    
    return headerRowHeight;
}


-(UIView *)viewWithStyle:(NSIndexPath *)indexPath
{
    CGFloat screenWidth = self.tableView.frame.size.width;
    NSString *keyOfComp =  (NSString *) [sortedElementIds objectAtIndex :indexPath.row];
    DotReportElement *dotReportElement = (DotReportElement *) [reportElements objectForKey:keyOfComp];
    
    NSMutableDictionary* styles = [XmwUtils getExtendedPropertyMap : dotReportElement.componentStyle];

    NSString* rightAlignment = [styles objectForKey:XmwcsConst_STYLE_PREOPERTY_ALIGNMENT];
    NSTextAlignment rightValueAlignment = NSTextAlignmentRight;

    if([rightAlignment isEqualToString:XmwcsConst_STYLE_ALIGNMENT_LEFT]) {
        rightValueAlignment = NSTextAlignmentLeft;
    } else if ([rightAlignment isEqualToString:XmwcsConst_STYLE_ALIGNMENT_RIGHT]) {
        rightValueAlignment = NSTextAlignmentRight;
    } else if ([rightAlignment isEqualToString:XmwcsConst_STYLE_ALIGNMENT_HECNTER]) {
        rightValueAlignment = NSTextAlignmentCenter;
    }
    
    
    NSString *headerValue = [self computeHeaderLineValue:dotReportElement];
    CGSize calcLeftSize;
    CGSize calcRightSize;
    UIView *elementContainer;
    UILabel *lblHeaderTitle;
    UILabel *lblHeaderValue;
    
    NSString* styleLine = [styles objectForKey:XmwcsConst_STYLE_PREOPERTY_LINE];
    
    if(styleLine != nil && [styleLine isEqualToString:XmwcsConst_STYLE_LABEL_NEWLINE]) {
        calcLeftSize = [dotReportElement.displayText boundingRectWithSize:CGSizeMake(screenWidth-10, 1024) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:14] } context:nil].size;
        
        calcRightSize = [headerValue boundingRectWithSize:CGSizeMake(screenWidth - 10, 1024) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:14] } context:nil].size;
        
        int headerRowHeight = calcLeftSize.height + calcRightSize.height + 10;
        
        elementContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, headerRowHeight) ];
        lblHeaderTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, screenWidth - 10, calcLeftSize.height)];
        lblHeaderValue = [[UILabel alloc] initWithFrame:CGRectMake(5, 5 + calcLeftSize.height, screenWidth - 10, calcRightSize.height)];
    } else {
        calcLeftSize = [dotReportElement.displayText boundingRectWithSize:CGSizeMake(screenWidth/2-10, 1024) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:14] } context:nil].size;
        
        calcRightSize = [headerValue boundingRectWithSize:CGSizeMake(screenWidth/2-10, 1024) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:14] } context:nil].size;
        
        int headerRowHeight = calcLeftSize.height;
        
        if(headerRowHeight<calcRightSize.height) {
            headerRowHeight = calcRightSize.height;
        }
        
        headerRowHeight = headerRowHeight + 10;
        
        elementContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, headerRowHeight) ];
        lblHeaderTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, screenWidth/2 - 10, calcLeftSize.height)];
        
        lblHeaderValue = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2+5, 5, screenWidth/2 - 10, calcRightSize.height)];
    }

    lblHeaderTitle.text = dotReportElement.displayText;
    [lblHeaderTitle setFont:[UIFont systemFontOfSize:14]];
    lblHeaderTitle.tag = 11;
    
    [elementContainer addSubview:lblHeaderTitle];
    
    
    [lblHeaderValue setFont:[UIFont systemFontOfSize:14]];
    lblHeaderValue.text  = headerValue;
    lblHeaderValue.numberOfLines = 0;
    lblHeaderValue.tag = 12;
    
    [elementContainer addSubview:lblHeaderValue];
    
    //If this field value is use in Next Screen
    if([dotReportElement isUseForwardBool]) {
        [self.forwardedDataDisplay setObject:headerValue forKey:dotReportElement.elementId];
        [self.forwardedDataPost setObject:headerValue forKey:dotReportElement.elementId];
    }
    
    return elementContainer;
}


-(void)configureView:(UIView* )view forIndexPath:(NSIndexPath *)indexPath {
    UILabel *lblHeaderTitle = (UILabel*)[view viewWithTag:11];
    UILabel *lblHeaderValue = (UILabel*)[view viewWithTag:12];
    
    NSString *keyOfComp =  (NSString *) [sortedElementIds objectAtIndex :indexPath.row];
    DotReportElement *dotReportElement = (DotReportElement *) [reportElements objectForKey:keyOfComp];
    
    NSString *headerValue = [self computeHeaderLineValue:dotReportElement];
    
    lblHeaderValue.text  = headerValue;
    lblHeaderTitle.text = dotReportElement.displayText;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(sortedElementIds!=nil) {
        return [sortedElementIds count];
    }
    return 0;
}


-(NSString*) computeHeaderLineValue:(DotReportElement*) dotReportElement
{
    NSString* headerValue = @"";
    NSMutableDictionary * headerData = self.reportPostResponse.headerData;
   
    
    if((dotReportElement.valueDependOn !=nil) && [self.forwardedDataDisplay objectForKey:dotReportElement.valueDependOn]!=nil) {
        headerValue = (NSString*) [self.forwardedDataDisplay objectForKey:dotReportElement.valueDependOn];
    } else {
        headerValue =  (NSString*) [headerData objectForKey:dotReportElement.elementId];
    }
    
    if(headerValue == nil) {
        headerValue = @"";
    }
    if([headerValue isEqualToString:@""] && ![dotReportElement.defaultVal isEqualToString:@""]) {
        headerValue = dotReportElement.defaultVal;
        headerValue = @"--";
    }
    
    return headerValue;
}

@end
