//
//  ReportTabularDataSection.m
//  QCMSProject
//
//  Created by Pradeep Singh on 7/27/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//
#import "DVCheckbox.h"
#import "ReportTabularDataSection.h"
#import "XmwcsConstant.h"
#import "DotReportDraw.h"
#import "XmwUtils.h"
#import "ClientVariable.h"
#import "DVAppDelegate.h"
#import "DotFormPost.h"
#import "AppConstants.h"
#import "LoadingView.h"
#import "XmwHttpFileDownloader.h"

#import "SimpleEditForm.h"

#define FONT_SIZE_HEADER 12.0f
#define FONT_SIZE_ROW 12.0f


@interface ReportTabularDataSection ()
{
    
    
}

@end

@implementation ReportTabularDataSection
{
    NSMutableArray *orignalReportTableData;
}

+(NSInteger) tableRowHeight
{
    return 50;
}

+(NSInteger) tableHeaderHeight
{
    return 40;
}

+(NSInteger) reportHeaderRowHeight
{
    return 30;
}


-(instancetype)init {
    self = [super init];
    if (self) {
        self.componentPlace = XmwcsConst_REPORT_PLACE_TABLE;
    }
    return self;
}



-(void) updateData:(DotReport *)inDotReport :(ReportPostResponse *)inReportPostResponse
{
    [super updateData:inDotReport :inReportPostResponse];
    
    
    reportElements = self.dotReport.reportElements;
    sortedElementIds =[DotReportDraw sortRptComponents : reportElements : self.componentPlace];
    cellComponent = [self createCellComponent];
    recordTableData = self.reportPostResponse.tableData;
    orignalReportTableData = [[NSMutableArray alloc]init];
    orignalReportTableData = self.reportPostResponse.tableData;
    self.reportVC.searchBar.userInteractionEnabled = YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    NSMutableArray *check = [cellComponent objectAtIndex:4];//for Polycab project in policy menu according to change UI
    if ([[check objectAtIndex:0] isEqualToString:@"Policy"]) {
        return 0.0f;
    }
    else
    return [ReportTabularDataSection tableHeaderHeight];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
       return [self drawTableHeader];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    reportSection = indexPath.section;
    CGFloat height=0.0f;
//    return [ReportTabularDataSection tableRowHeight];  //this is default height
    height = [self newCellHeight:[recordTableData objectAtIndex:indexPath.row]];
//    NSLog(@"Cell %ld height %f",(long)indexPath.row,height);
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TableDataSectionCell"];
//    if(cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TableDataSectionCell"];
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView* customView = [cell.contentView viewWithTag:3001];
//    if(customView==nil) {
        customView = [self initializeDataRowCell :indexPath];
        customView.tag = 3001;
        [cell.contentView addSubview:customView];
    cell.clipsToBounds = YES;
//    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView* customView = [cell.contentView viewWithTag:3001];
    if(customView!=nil) {
        [self  configureDataRowCell:customView :indexPath];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(recordTableData.count>0) {
        self.reportVC.reportTableView.backgroundView = nil;
        return [recordTableData count];
    }
    else
    {
        CGRect screen = [UIScreen mainScreen].bounds;
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screen.size.width, screen.size.height)];
        noDataLabel.tag = 700;
        noDataLabel.text             = @"No data available.";
        noDataLabel.textColor        = [UIColor blackColor];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        self.reportVC.reportTableView.backgroundView  = noDataLabel;
        self.reportVC.reportTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return [recordTableData count];
    }
    
    
//    return [recordTableData count];
}


-(UIView *) drawTableHeader
{
    int screenWidth = self.tableView.frame.size.width;
    UIView *tableHeaderContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, [ReportTabularDataSection tableHeaderHeight]) ];
    NSMutableArray *elementType = [cellComponent objectAtIndex:0];
    NSMutableDictionary *columnLengthMap = [cellComponent objectAtIndex:1];
    NSMutableArray *elementId = [cellComponent objectAtIndex:2];
    NSMutableArray *headerElementId = [cellComponent objectAtIndex:3];
    NSMutableArray *elementDisplay = [cellComponent objectAtIndex:4];
  
    //start calculate tableheader column width
    // need to calculate column width normalization when total percentage is not 100% then we need to extrapolate to 100%
    // 76  ---- 18
    // 1 - 18/76
    // 100 - 18*100/totalPer
    int totalPerc = 0;
    // QStringList lengthKeys = columnLengthMap->keys();
    NSArray* lengthKeys = [columnLengthMap allKeys];
    //for (int cntTableColumn = 0; cntTableColumn < lengthKeys.count(); cntTableColumn++)
    for(int cntTableColumn = 0; cntTableColumn < [lengthKeys count]; cntTableColumn++)
    {
        NSString* tempLen = [columnLengthMap objectForKey:[lengthKeys objectAtIndex:cntTableColumn]];//columnLengthMap->value(lengthKeys.at(cntTableColumn));
        totalPerc = totalPerc + [tempLen intValue];// tempLen.toInt();
    }
    //end
    
    float xCord, width,hight;
    
    NSInteger elementDisplayNo = [elementDisplay count];
    xCord = 0.0;
    
    width = screenWidth/elementDisplayNo; //98;
    hight = [ ReportTabularDataSection tableHeaderHeight];
    
    [tableHeaderContainer setBackgroundColor:[UIColor clearColor]];
    for (int cntTableColumn = 0; cntTableColumn < [elementDisplay count]; cntTableColumn++)
    {
        //start calculate tableheader column width
        NSString* tempLen = [columnLengthMap objectForKey:[headerElementId objectAtIndex:cntTableColumn]];//columnLengthMap->value(headerElementId->at(cntTableColumn));
        // qDebug() << "Column Width = " << tempLen;
        // NSLog(@"column Width = tempLen");
        int normalized = 100/[headerElementId count];//(headerElementId->count());
        if(totalPerc!=0) {
            normalized = [tempLen intValue]*100/totalPerc;//tempLen.toInt()*100/totalPerc;
           // NSLog(@"normalized value = @%d",normalized);
        }
        
        float columnWidth = screenWidth * normalized / 100;
       // NSLog(@"column width = @%f",columnWidth);
        
        //end
        
      
        
        
        UIView *header = [[UIView alloc]initWithFrame:CGRectMake(xCord+1, 0, columnWidth , hight)];
        header.backgroundColor = [UIColor whiteColor];
        UILabel *labelHeader = [[UILabel alloc]initWithFrame:CGRectMake(1, 0, header.frame.size.width-1, hight)];
        labelHeader.backgroundColor = [UIColor darkGrayColor];
        labelHeader.text = [elementDisplay objectAtIndex:cntTableColumn];
        labelHeader.textColor = [UIColor whiteColor];
        labelHeader.numberOfLines = 0;
        labelHeader.textAlignment = NSTextAlignmentCenter;
        [header addSubview:labelHeader];
        [labelHeader setFont:[UIFont systemFontOfSize:FONT_SIZE_HEADER weight:UIFontWeightMedium]];
        [tableHeaderContainer addSubview:header];
        xCord = xCord + columnWidth;
    }
    
    return tableHeaderContainer;
}


-(NSMutableArray *) createCellComponent
{
    NSMutableArray *elementType = [[NSMutableArray alloc]init];
    NSMutableDictionary *columnLengthMap = [[NSMutableDictionary alloc]init];
    NSMutableArray *elementId = [[NSMutableArray alloc]init];
    NSMutableArray *headerElementId = [[NSMutableArray alloc]init];
    NSMutableArray *hiddenElementIds = [[NSMutableArray alloc]init];
    
    ////my sorting code
    NSMutableArray *dataType = [[NSMutableArray alloc]init];
    
    NSMutableArray *elementDisplay = [[NSMutableArray alloc]init];
    
    for(int cntTableColumn = 0; cntTableColumn < [sortedElementIds count];cntTableColumn++)
    {
        NSString *keyOfComp = (NSString*) [sortedElementIds objectAtIndex:cntTableColumn];
        DotReportElement *dotReportElement = (DotReportElement *) [reportElements objectForKey:keyOfComp];
        
        if([dotReportElement.componentType isEqualToString:XmwcsConst_DRE_COLUMN_TYPE_SPEC_CHAR_IND])
        {
            [elementDisplay addObject:@""];
            if(dotReportElement.length != nil )
            {
                [columnLengthMap setObject:dotReportElement.length forKey:dotReportElement.elementId];
                
            }
            [headerElementId addObject:dotReportElement.elementId];
            
        }
        else if(!(([dotReportElement.componentType isEqualToString:XmwcsConst_DRE_COLUMN_TYPE_HIDDEN])
                  || ([dotReportElement.componentType isEqualToString:XmwcsConst_DRE_COLUMN_TYPE_COLOR])
                  || ([dotReportElement.componentType isEqualToString:XmwcsConst_DRE_COLUMN_TYPE_COLOR_CLICK])))
            
        {
            if(dotReportElement.displayText!=nil) {
                [elementDisplay addObject:dotReportElement.displayText];
            } else {
                [elementDisplay addObject:@""];
            }
            
            if(dotReportElement.length != nil)
            {
                [columnLengthMap setObject:dotReportElement.length forKey:dotReportElement.elementId];
            }
            [headerElementId addObject:dotReportElement.elementId];
        } else if([dotReportElement.componentType isEqualToString:XmwcsConst_DRE_COLUMN_TYPE_HIDDEN]) {
            [hiddenElementIds addObject:dotReportElement.elementId];
        }
        
        [elementType addObject:dotReportElement.componentType];
        [elementId addObject:dotReportElement.elementId];
   
    }
    
    
    NSMutableArray *returnMap = [[NSMutableArray alloc]init];
    [returnMap addObject:elementType];
    [returnMap addObject:columnLengthMap];
    [returnMap addObject:elementId];
    [returnMap addObject:headerElementId];
    [returnMap addObject:elementDisplay];
    [returnMap addObject:hiddenElementIds];
    [returnMap addObject:dataType];
    
    return returnMap;
}


-(UIView*) initializeDataRowCell:(NSIndexPath*)indexPath
{
    CGFloat screenWidth = self.tableView.frame.size.width;
    
    UIView* rowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, [ReportTabularDataSection tableRowHeight])];
    
    //new added start for color & hide some column in table
    NSMutableArray *elementType = (NSMutableArray *)[cellComponent objectAtIndex:0];
    NSMutableDictionary *columnLengthMap = (NSMutableDictionary *)[cellComponent objectAtIndex:1];
    NSMutableArray *elementId = (NSMutableArray *)[cellComponent objectAtIndex:2];
    NSMutableArray *headerElementId = (NSMutableArray *)[cellComponent objectAtIndex:3];
    
    NSString *rowColor = @"";
    // newly added close
    // NSMutableArray* row = [recordTableData objectAtIndex:indexPath.row];
    // NSInteger width = screenWidth/[cellComponent count];
    
    int x = 0;
    
    UIView* firstCol;
    UILabel *mItemLabel;
   
       NSInteger   width  =screenWidth/[cellComponent count];
       NSInteger height = [DotReportListCellRenderer tableRowHeight];
    
   
    
    //start calculate tableheader column width
    // need to calculate column width normalization when total percentage is not 100% then we need to extrapolate to 100%
    // 76  ---- 18
    // 1 - 18/76
    // 100 - 18*100/totalPer
    int totalPerc = 0;
    // QStringList lengthKeys = columnLengthMap->keys();
    NSArray* lengthKeys = [columnLengthMap allKeys];
    //for (int cntTableColumn = 0; cntTableColumn < lengthKeys.count(); cntTableColumn++)
    for(int cntTableColumn = 0; cntTableColumn < [lengthKeys count]; cntTableColumn++)
    {
        NSString* tempLen = [columnLengthMap objectForKey:[lengthKeys objectAtIndex:cntTableColumn]];
        //columnLengthMap->value(lengthKeys.at(cntTableColumn));
        totalPerc = totalPerc + [tempLen intValue];// tempLen.toInt();
    }
    //end
    bool heightComputeFlag = false;
    
    for(int i=0; i<[elementId count]; i++)
    {
        //start calculate tableheader column width
        NSString* tempLen = [columnLengthMap objectForKey:[elementId objectAtIndex:i]];//columnLengthMap->value(headerElementId->at(cntTableColumn));
        // qDebug() << "Column Width = " << tempLen;
        // NSLog(@"column Width = tempLen");
        int normalized = 100/[headerElementId count];//(headerElementId->count());
        if(totalPerc!=0) {
            normalized = [tempLen intValue]*100/totalPerc;//tempLen.toInt()*100/totalPerc;
            // NSLog(@"normalized value = @%d",normalized);
        }
        
        float columnWidth;
        
        NSMutableArray *check = [cellComponent objectAtIndex:4];//for Polycab project in policy menu according to change UI
        if ([[check objectAtIndex:0] isEqualToString:@"Policy"]) {
            columnWidth = screenWidth;        }
        else
        {
            columnWidth = screenWidth * normalized / 100;
        }
        
        // NSLog(@"column width = @%f",columnWidth);
        //end
        
        int firstColTag = 1000 + i;
        
        // A list item label, docked to the center, the text is set in updateItem.
        if([[elementType objectAtIndex:i] isEqualToString:XmwcsConst_DE_COMPONENT_LABEL])
        {
            //on going work
            
            if (!heightComputeFlag) {
                height = [self newCellHeight:[recordTableData objectAtIndex:indexPath.row]];
                heightComputeFlag = true;
                [self tableView:self heightForRowAtIndexPath:indexPath];
            }
            
            
            firstCol = [[UIView alloc] initWithFrame:CGRectMake(x, 0, columnWidth, height)];
            firstCol.tag = firstColTag;
            firstCol.backgroundColor = [UIColor clearColor];
            mItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(2,1.5, columnWidth - 2, height-1)];
            mItemLabel.tag = 11;
            mItemLabel.backgroundColor = [UIColor colorWithRed:236.0/255 green:236.0/255 blue:236.0/255 alpha:1.0];
            mItemLabel.textAlignment = NSTextAlignmentCenter;
            mItemLabel.lineBreakMode = UILineBreakModeWordWrap;
            mItemLabel.minimumFontSize = 8.0;
            mItemLabel.adjustsFontSizeToFitWidth = YES;
            
            // it will be done in the  configureDataRowCell
            //  mItemLabel.text = [row objectAtIndex:i];
            [mItemLabel setFont:[UIFont systemFontOfSize:FONT_SIZE_ROW]];
            mItemLabel.numberOfLines = 0;
            
            if(rowColor.length>0)
            {
                //mItemLabel.backgroundColor = [XmwUtils colorWithHexString:rowColor];
            }
            x = x + columnWidth;
            
            DotReportElement* dotReportElement = [reportElements objectForKey:[elementId objectAtIndex:i]];
            if([dotReportElement.dataType isEqualToString:XmwcsConst_DE_TEXTFIELD_DATA_TYPE_NUMERIC] ||
               [dotReportElement.dataType isEqualToString:XmwcsConst_DE_TEXTFIELD_DATA_TYPE_AMOUNT] ||
               [dotReportElement.dataType isEqualToString:XmwcsConst_DE_TEXTFIELD_DATA_TYPE_FLOAT])
            {
                //   mItemLabel.textAlignment = NSTextAlignmentRight;
                
                mItemLabel.textAlignment = NSTextAlignmentCenter;///for polycab
            }
            
            [firstCol addSubview:mItemLabel];
            [rowView  addSubview: firstCol];
            
        } else if( [[elementType objectAtIndex:i] isEqualToString:XmwcsConst_DRE_COLUMN_TYPE_COLOR]) {
            // not needed here in the initialization
            /*
             NSString *colorVal = [row objectAtIndex:i];
             ClientVariable* clientVariable = [ClientVariable getInstance : [DVAppDelegate currentModuleContext]];
             NSMutableDictionary *colorMap = [clientVariable.CLIENT_APP_MASTER_DATA objectForKey:dotReport.legendColorOn];
             rowColor = [colorMap objectForKey:colorVal];
             */
        } else if([[elementType objectAtIndex:i] isEqualToString:XmwcsConst_DRE_COLUMN_TYPE_CLICK]) {
            // not needed here in the initialization of the cell
            /*
             NSString *clickVal = [row objectAtIndex:i];
             ClientVariable* clientVariable = [ClientVariable getInstance : [DVAppDelegate currentModuleContext]];
             NSMutableDictionary *clickMap = [clientVariable.CLIENT_APP_MASTER_DATA objectForKey:dotReport.clickEventOn];
             if([(NSString *)[clickMap objectForKey:clickVal] isEqualToString:@"0"]){
             m_isClickableRow = false;
             }
             */
        } else if([[elementType objectAtIndex:i] isEqualToString:XmwcsConst_DRE_COLUMN_TYPE_COLOR_CLICK]){
            // not needed here in the initialization of the cell
            /*
             ClientVariable* clientVariable = [ClientVariable getInstance : [DVAppDelegate currentModuleContext]];
             NSString *clickVal = [row objectAtIndex:i];
             NSMutableDictionary *clickMap = [clientVariable.CLIENT_APP_MASTER_DATA objectForKey:dotReport.clickEventOn];
             if([(NSString *)[clickMap objectForKey:clickVal] isEqualToString:@"0"]){
             m_isClickableRow = false;
             }
             NSString *colorVal = [row objectAtIndex:i];
             NSMutableDictionary *colorMap = [clientVariable.CLIENT_APP_MASTER_DATA objectForKey:dotReport.legendColorOn];
             rowColor = [colorMap objectForKey:colorVal];
             */
        } else if([[elementType objectAtIndex:i] isEqualToString:XmwcsConst_DRE_COLUMN_TYPE_SPEC_CHAR_IND]){
            
            firstCol = [[UIView alloc] initWithFrame:CGRectMake(x, 0, columnWidth, height)];
            firstCol.tag = firstColTag;
            mItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, columnWidth-4, height)];
            mItemLabel.tag = 11;
            mItemLabel.textAlignment = NSTextAlignmentCenter;
            [mItemLabel setFont:[UIFont systemFontOfSize:FONT_SIZE_ROW]];
            // not needed to set text here.
            //  mItemLabel.text = [row objectAtIndex:i];
            mItemLabel.numberOfLines = 0;
            if(rowColor.length>0) {
                mItemLabel.backgroundColor = [XmwUtils colorWithHexString:rowColor];
            }
            x = x + columnWidth;
            
            [firstCol addSubview:mItemLabel];
            [rowView  addSubview: firstCol];
        } else if([[elementType objectAtIndex:i] isEqualToString:XmwcsConst_DRE_COLUMN_TYPE_EXPAND]) {
            // not needed here
            /*
             m_expandedValue = [row objectAtIndex:i];
             */
            firstCol = [[UIView alloc] initWithFrame:CGRectMake(x, 0, columnWidth, height)];
            firstCol.tag = firstColTag;
            x = x + columnWidth;
            [rowView  addSubview: firstCol];
        }
    }
//    NSLog(@"Row %ld height %f",(long)indexPath.row,rowView.frame.size.height);
    rowView.frame = CGRectMake(rowView.frame.origin.x, rowView.frame.origin.y, rowView.frame.size.width, height);
//    NSLog(@"Updated Row Frame %ld height %f",(long)indexPath.row,rowView.frame.size.height);
    return rowView;
}


-(void) configureDataRowCell:(UIView*) dataCell :(NSIndexPath *)indexPath
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    //new added start for color & hide some column in table
    NSMutableArray *elementType = (NSMutableArray *)[cellComponent objectAtIndex:0];
    NSMutableDictionary *columnLengthMap = (NSMutableDictionary *)[cellComponent objectAtIndex:1];
    NSMutableArray *elementId = (NSMutableArray *)[cellComponent objectAtIndex:2];
    NSMutableArray *headerElementId = (NSMutableArray *)[cellComponent objectAtIndex:3];
    
    NSString *rowColor = @"";
    // newly added close
    
    
    NSMutableArray* row = [recordTableData objectAtIndex:indexPath.row];
 
    // NSInteger width = screenWidth/[cellComponent count];
    
    int x =0;
    
    UIView* firstCol;
    UILabel *mItemLabel;
    NSInteger width =screenWidth/[cellComponent count];
    NSInteger height = [DotReportListCellRenderer tableRowHeight];
    
    //start calculate tableheader column width
    // need to calculate column width normalization when total percentage is not 100% then we need to extrapolate to 100%
    // 76  ---- 18
    // 1 - 18/76
    // 100 - 18*100/totalPer
    int totalPerc = 0;
    // QStringList lengthKeys = columnLengthMap->keys();
    NSArray* lengthKeys = [columnLengthMap allKeys];
    //for (int cntTableColumn = 0; cntTableColumn < lengthKeys.count(); cntTableColumn++)
    for(int cntTableColumn = 0; cntTableColumn < [lengthKeys count]; cntTableColumn++)
    {
        NSString* tempLen = [columnLengthMap objectForKey:[lengthKeys objectAtIndex:cntTableColumn]];
        //columnLengthMap->value(lengthKeys.at(cntTableColumn));
        totalPerc = totalPerc + [tempLen intValue];// tempLen.toInt();
    }
    //end
    
    bool allFlagCheck = false;
    UIColor *searchTextColor;
    for(int i=0; i<[elementId count]; i++)
    {
        //start calculate tableheader column width
        NSString* tempLen = [columnLengthMap objectForKey:[elementId objectAtIndex:i]];//columnLengthMap->value(headerElementId->at(cntTableColumn));
        // qDebug() << "Column Width = " << tempLen;
       // NSLog(@"column Width = tempLen");
        int normalized = 100/[headerElementId count];//(headerElementId->count());
        if(totalPerc!=0) {
            normalized = [tempLen intValue]*100/totalPerc;//tempLen.toInt()*100/totalPerc;
            //NSLog(@"normalized value = @%d",normalized);
        }
        
        float columnWidth = screenWidth * normalized / 100;
        // NSLog(@"column width = @%f",columnWidth);
        //end
        
        int firstColTag = 1000 + i;
        // A list item label, docked to the center, the text is set in updateItem.
        if([[elementType objectAtIndex:i] isEqualToString:XmwcsConst_DE_COMPONENT_LABEL])
        {
            firstCol = [dataCell viewWithTag:firstColTag];
            mItemLabel = (UILabel*)[firstCol viewWithTag:11];
            
            if ([[row objectAtIndex:i] isKindOfClass:[NSNull class]]) {
                mItemLabel.text = @"";
            }
            else{
            mItemLabel.text = [row objectAtIndex:i];
            }
            
            
            id object = [row objectAtIndex:i];
            NSString *allCheckStr = @"";
            if(![object isEqual:[NSNull null]])
            {
                allCheckStr = [row objectAtIndex:i];
                if (allCheckStr == nil || [allCheckStr isKindOfClass:[NSNull class]] || allCheckStr.length<=0 || allCheckStr == NULL || [allCheckStr isEqualToString:@""]) {
                    allCheckStr = @"";
                }
                
            }
            else
            {
                allCheckStr = @"";
            }
            for (int k=0; k<row.count; k++) {
                NSString *str = [row objectAtIndex:k];
                
                if ([str isKindOfClass:[NSString class]] && [str isEqualToString:@"Rejected"] && ![[elementType objectAtIndex:k] isEqualToString:@"HIDDEN"] ) {
                                 [mItemLabel setTextColor:[UIColor redColor]];
                            }
                            else
                            {
                //                [mItemLabel setTextColor:[UIColor redColor]];
                            }
            }
            
            if ([allCheckStr isEqualToString:@"All"] || allFlagCheck) {
                [mItemLabel setBackgroundColor:[UIColor colorWithRed:204.0/255 green:41.0/255 blue:43.0/255 alpha:1.0f]];
                [mItemLabel setTextColor:[UIColor whiteColor]];
               [mItemLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
                allFlagCheck = true;
                
                 searchTextColor = [UIColor yellowColor];
              
            }
            else
            {
                  [mItemLabel setFont:[UIFont systemFontOfSize:FONT_SIZE_ROW]];
                  searchTextColor = [UIColor colorWithRed:204.0/255 green:41.0/255 blue:43.0/255 alpha:1.0];
            }
            mItemLabel.numberOfLines = 0;
            mItemLabel.lineBreakMode = UILineBreakModeWordWrap;
            mItemLabel.minimumFontSize = 8.0;
            mItemLabel.adjustsFontSizeToFitWidth = YES;
            if(rowColor.length>0)
            {
                mItemLabel.backgroundColor = [XmwUtils colorWithHexString:rowColor];
                firstCol.backgroundColor = [XmwUtils colorWithHexString:rowColor];
            }
            x = x + columnWidth;
            
        } else if( [[elementType objectAtIndex:i] isEqualToString:XmwcsConst_DRE_COLUMN_TYPE_COLOR]){
            NSString *colorVal = [row objectAtIndex:i];
            ClientVariable* clientVariable = [ClientVariable getInstance : [DVAppDelegate currentModuleContext]];
            NSMutableDictionary *colorMap = [clientVariable.CLIENT_APP_MASTER_DATA objectForKey:self.dotReport.legendColorOn];
            rowColor = [colorMap objectForKey:colorVal];
        } else if([[elementType objectAtIndex:i] isEqualToString:XmwcsConst_DRE_COLUMN_TYPE_CLICK]) {
            NSString *clickVal = [row objectAtIndex:i];
            ClientVariable* clientVariable = [ClientVariable getInstance : [DVAppDelegate currentModuleContext]];
            NSMutableDictionary *clickMap = [clientVariable.CLIENT_APP_MASTER_DATA objectForKey:self.dotReport.clickEventOn];
            if([(NSString *)[clickMap objectForKey:clickVal] isEqualToString:@"0"]){
                // m_isClickableRow = false;
            }
        } else if([[elementType objectAtIndex:i] isEqualToString:XmwcsConst_DRE_COLUMN_TYPE_COLOR_CLICK]){
            ClientVariable* clientVariable = [ClientVariable getInstance : [DVAppDelegate currentModuleContext]];
            NSString *clickVal = [row objectAtIndex:i];
            NSMutableDictionary *clickMap = [clientVariable.CLIENT_APP_MASTER_DATA objectForKey:self.dotReport.clickEventOn];
            if([(NSString *)[clickMap objectForKey:clickVal] isEqualToString:@"0"]){
                // m_isClickableRow = false;
            }
            NSString *colorVal = [row objectAtIndex:i];
            NSMutableDictionary *colorMap = [clientVariable.CLIENT_APP_MASTER_DATA objectForKey:self.dotReport.legendColorOn];
            rowColor = [colorMap objectForKey:colorVal];
        } else if([[elementType objectAtIndex:i] isEqualToString:XmwcsConst_DRE_COLUMN_TYPE_SPEC_CHAR_IND]){
            firstCol = [dataCell viewWithTag:firstColTag];
            mItemLabel = (UILabel*)[firstCol viewWithTag:11];
            [mItemLabel setFont:[UIFont systemFontOfSize:FONT_SIZE_ROW]];
            mItemLabel.text = [row objectAtIndex:i];
            mItemLabel.numberOfLines = 0;
            if(rowColor.length>0) {
                mItemLabel.backgroundColor = [XmwUtils colorWithHexString:rowColor];
            }
            x = x + columnWidth;
        } else if([[elementType objectAtIndex:i] isEqualToString:XmwcsConst_DRE_COLUMN_TYPE_EXPAND]) {
           // m_expandedValue = [row objectAtIndex:i];
            
            firstCol = [dataCell viewWithTag:firstColTag];
            // we need to set open close here hooks here
            
        }
       
    
        NSMutableAttributedString *mutableString = nil;
        NSString *sampleText = @"";
        if (mItemLabel.text !=nil) {
            sampleText = mItemLabel.text;
        }
        
        mutableString = [[NSMutableAttributedString alloc] initWithString:sampleText];
        NSString *pattern = @"";
        if (self.reportVC.searchBar.text != nil) {
            pattern = self.reportVC.searchBar.text;
        }
//        NSString *pattern = self.reportVC.searchBar.text;
        NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:1 error:nil];
        
        NSRange range = NSMakeRange(0,[sampleText length]);
        [expression enumerateMatchesInString:sampleText options:1 range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            NSRange californiaRange = [result rangeAtIndex:0] ;
            [mutableString addAttribute:NSForegroundColorAttributeName value:searchTextColor range:californiaRange];
        }];
        
        
        
        mItemLabel.attributedText = mutableString;
        
        
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"Report Screen Controller : handleRowSelected");
    NSString* expandProperty;
    BOOL isDrillDown = [self clickableAndExpandable :indexPath.row :&expandProperty];
    NSLog(@"expandProperty");
    
    NSMutableArray *records = recordTableData;
    NSArray* rowData = [records objectAtIndex:indexPath.row];
    
//    if([[rowData objectAtIndex:0]isEqualToString:@"All"])//for polycab RECPT check
//    {
//        isDrillDown = NO;
//    }
    if([expandProperty isEqualToString:@""]!=0)
    {
        // handle expandable
        //SystemToast *toast = new SystemToast(this);
        
        //toast->setBody(expandProperty);
        //toast->setPosition(SystemUiPosition::MiddleCenter);
        //toast->show();
        
        return;
    }
    if(isDrillDown) {
        if(self.reportVC.drilldownDelegate !=nil && [self.reportVC.drilldownDelegate respondsToSelector:@selector(handleDrilldownForRow: withRowData:)]) {
            NSMutableArray *records = recordTableData;
            NSArray* rowData = [records objectAtIndex:indexPath.row];
            [self.reportVC.drilldownDelegate handleDrilldownForRow:indexPath.row  withRowData:rowData];
        } else {
            [self handleDrillDown: indexPath.row : self.reportVC.forwardedDataDisplay : self.reportVC.forwardedDataPost];
        }
    }
    
}

-(bool) clickableAndExpandable : (int) rowIdx : (NSString**) expandProperty
{
    NSLog(@"ReportScreenController:clickableAndExpandable");
    NSMutableArray *records = recordTableData;
    NSArray* rowData = [records objectAtIndex:rowIdx];
    bool isClickableRow = false;
    
    //if(cellComponent!=0 && [cellComponent count]==4) {
    
    NSMutableArray *elementType = (NSMutableArray *)[cellComponent objectAtIndex:0];
    NSMutableDictionary *columnLengthMap = (NSMutableDictionary *)[cellComponent objectAtIndex:1];
    NSMutableArray *elementId = (NSMutableArray *)[cellComponent objectAtIndex:2];
    NSMutableArray *headerElementId = (NSMutableArray *)[cellComponent objectAtIndex:3];
    
    NSString* rowColor = @"";
    isClickableRow = [self.dotReport isFindDrillDown];
    
    /* for(int i=0; i<[elementId count]; i++)
     {
     if([[elementType objectAtIndex:i] isEqualToString:XmwcsConst_DRE_COLUMN_TYPE_CLICK]) {
     NSString *clickVal = [rowData objectAtIndex:i];
     ClientVariable* clientVariable = [ClientVariable getInstance : [DVAppDelegate currentModuleContext]];
     NSMutableDictionary *clickMap = [clientVariable.CLIENT_APP_MASTER_DATA objectForKey:dotReport.clickEventOn];
     if([(NSString *)[clickMap objectForKey:clickVal] isEqualToString:@"0"]){
     isClickableRow = false;
     }
     
     
     } else if([[elementType objectAtIndex:i] isEqualToString:XmwcsConst_DRE_COLUMN_TYPE_EXPAND]) {
     expandProperty = [rowData objectAtIndex:i];
     }
     }*/
    
    
    //}
    return isClickableRow;
    
}


-(void) handleDrillDown : (NSInteger) position :(NSMutableDictionary *) in_forwardedDataDisplay :(NSMutableDictionary *) in_forwardedDataPost
{
    self.forwardedDataDisplay = in_forwardedDataDisplay;
    self.forwardedDataPost = in_forwardedDataPost;
    
    NSMutableArray *sortedElementIds = [DotReportDraw sortRptComponents:self.dotReport.reportElements :XmwcsConst_REPORT_PLACE_TABLE];
    
    
//    NSMutableArray *selectedRowElement = (NSMutableArray *)[self.reportPostResponse.tableData objectAtIndex:position];
    NSMutableArray *selectedRowElement = (NSMutableArray *) [recordTableData objectAtIndex:position]; // this code chanage because of search feature
    
    if (self.forwardedDataDisplay == nil)
		self.forwardedDataDisplay   = [[NSMutableDictionary alloc] init];
	
	if (self.forwardedDataPost == nil)
		self.forwardedDataPost      = [[NSMutableDictionary alloc] init];
    
    dotFormPost = [[DotFormPost alloc]init];
    [dotFormPost setAdapterId:self.dotReport.ddAdapterId];
    [dotFormPost setAdapterType:self.dotReport.ddAdapterType];
    //[dotFormPost setModuleId:XmwcsConst_APP_MODULE_WORKFLOW];
    [dotFormPost setModuleId:[DVAppDelegate currentModuleContext]];
    
    if(self.dotReport.ddServerCacheFlag!=nil && [self.dotReport.ddServerCacheFlag isEqualToString:@"FALSE"]) {
        dotFormPost.reportCacheRefresh = @"true";
    } else {
        dotFormPost.reportCacheRefresh = @"false";
    }
    
    NSLog(@"adaptertype : %@", self.dotReport.ddAdapterType);
    
    [dotFormPost setDocId: self.dotReport.ddAdapterType];
    
    NSArray* keysMap = [self.forwardedDataPost allKeys];
    
    for (int cntIndex = 0; cntIndex<[keysMap count]; cntIndex++)
    {
        NSString* keyOfMap = [keysMap objectAtIndex:cntIndex];
        [dotFormPost.postData setObject:[self.forwardedDataPost objectForKey:keyOfMap] forKey:keyOfMap];
    }
    
    for(int i =0; i<[sortedElementIds count];i++)
    {
        NSString *keyOfComp = (NSString *)[sortedElementIds objectAtIndex:i];
        DotReportElement *dotReportElement = (DotReportElement *)[self.dotReport.reportElements objectForKey:keyOfComp];
        if([dotReportElement isUseForward])
        {
            [self.forwardedDataDisplay setObject:[selectedRowElement objectAtIndex:i] forKey:dotReportElement.elementId];
            [self.forwardedDataPost setObject:[selectedRowElement objectAtIndex:i] forKey:dotReportElement.elementId];
            [dotFormPost.postData setObject:[selectedRowElement objectAtIndex:i] forKey:dotReportElement.elementId];
        }
        
        NSRange tempRange = [self.dotReport.ddNetworkFieldOfTable rangeOfString:keyOfComp];//java use of indexOf
        
        if(tempRange.length > 0)//java use of indexOf
        {
            [dotFormPost.postData setObject:[selectedRowElement objectAtIndex:i] forKey:dotReportElement.elementId];
        }
    }
    
    
    if([self.dotReport.reportType isEqualToString:XmwcsConst_REPORT_TYPE_SIMPLE_LINK]) {
        NSLog(@"key for URL download is %@", self.dotReport.urlField);
        NSString* urlString = [self.forwardedDataPost objectForKey:self.dotReport.urlField];
        NSLog(@"URL string is %@", urlString);
        
        //Tost Code Added by Ashish Tiwari
        
        [XmwUtils toastView:@"Your Downloading Start"];
        
        [self.reportVC.imageView startAnimating];
        
        //Tost Code Close by Ashish Tiwari
        
        // TODO Pradeep.
        XmwHttpFileDownloader* fileDownloader = [[XmwHttpFileDownloader alloc] initWithUrl:urlString];
        // we need to replace these username and password with the user
        
        [fileDownloader downloadStart:self.reportVC username:@"czz9999" password:@"crm123"];
        
        // String username = "czz9999", password = "crm123";
        return;
    }
    
    
    if([self.dotReport isDdNetworkCallBool])
    {
        //Middle screen
        //if([dotReport->getDdMiddleScrMsg().compare("")!=0])
        if(![self.dotReport.ddMiddleScrMsg isEqualToString:@""])
        {
            //Show the dialog Box and make Network Call
            
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Item Action:" message: [self.dotReport getDdMiddleScrMsg] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel" , nil];
            [myAlertView show];
            
            
        } else {
            
            loadingView = [LoadingView loadingViewInView:self.reportVC.view];
            if([self.dotReport.ddCallName isEqualToString:XmwcsConst_CALL_NAME_FOR_SUBMIT])
            {
                NetworkHelper *networkHelper = [[NetworkHelper alloc] init];
                [networkHelper makeXmwNetworkCall:dotFormPost :self : nil :  XmwcsConst_CALL_NAME_FOR_SUBMIT];
            } else{
                NetworkHelper *networkHelper = [[NetworkHelper alloc] init];
                [networkHelper makeXmwNetworkCall:dotFormPost :self : nil :  XmwcsConst_CALL_NAME_FOR_REPORT];
                
            }
        }
    } else {
        // we need to show local report here
        ReportPostResponse* reportPostResponseNoNetwork = [[ReportPostResponse alloc] init];
        reportPostResponseNoNetwork.viewReportId = dotFormPost.adapterId;
        
        ReportVC *offlineReportVC = [[ReportVC alloc] initWithNibName:REPORTVC bundle:nil];
        offlineReportVC.screenId = AppConst_SCREEN_ID_REPORT;
        offlineReportVC.reportPostResponse = reportPostResponseNoNetwork;
        offlineReportVC.forwardedDataDisplay = self.forwardedDataDisplay;
        offlineReportVC.forwardedDataPost = self.forwardedDataPost;
        [[self.reportVC navigationController] pushViewController:offlineReportVC  animated:YES];
    }
}


#pragma mark - HttpEventListener

- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    [loadingView removeView];
    if ([callName isEqualToString : XmwcsConst_CALL_NAME_FOR_REPORT])
    {
        if(self.dotReport.ddActionType !=nil && [self.dotReport.ddActionType isEqualToString:  XmwcsConst_DOC_TYPE_VIEW_EDIT] &&
           self.dotReport.ddActionFormId !=nil && [self.dotReport.ddActionFormId length]>0) {
            
            ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
            
            DotForm* dotForm = (DotForm *) [clientVariables.DOT_FORM_MAP objectForKey: self.dotReport.ddActionFormId];
            
            DotMenuObject* formMenuObject = [[DotMenuObject alloc] init];
            formMenuObject.FORM_ID = self.dotReport.ddActionFormId;
            
            SimpleEditForm* simpleEditForm = [[SimpleEditForm alloc] initWithData :formMenuObject
                                                                  :[[DotFormPost alloc] init]
                                                                  :NO
                                                                  :[[NSMutableDictionary alloc] init]
                                                                  :[[NSMutableDictionary alloc] init]];
            simpleEditForm.headerStr = dotForm.screenHeader;
            simpleEditForm.reportFormResponse = (ReportPostResponse*) respondedObject;
            
            [self.reportVC setNeedRefresh:YES];
            
            [[self.reportVC navigationController] pushViewController:simpleEditForm animated:YES];
        } else {
            DotFormPost* dotFormPost = (DotFormPost*) requestedObject;
            //  if(dotFormPost.adapterId)
            ReportPostResponse *reportPostResponse = (ReportPostResponse*) respondedObject;
            
            ClientVariable* clientVariable = [ClientVariable getInstance];
            ReportVC *reportVC = [clientVariable reportVCForId:dotFormPost.adapterId];
            reportVC.requestFormPost = dotFormPost;
            
            // ReportVC *reportVC = [[ReportVC alloc] initWithNibName:@"ReportVC" bundle:nil];
            reportVC.screenId = AppConst_SCREEN_ID_REPORT;
            reportVC.reportPostResponse = reportPostResponse;
            reportVC.forwardedDataDisplay = self.forwardedDataDisplay;
            reportVC.forwardedDataPost =  self.forwardedDataPost;
            [[self.reportVC navigationController] pushViewController:reportVC  animated:YES];
            return;
        }
    }
    if([callName isEqualToString : XmwcsConst_CALL_NAME_FOR_SUBMIT])
    {
        DocPostResponse* docResponse = (DocPostResponse*) respondedObject;
		NSString* serverMessage = docResponse.submittedMessage;//docResponse->getSubmittedMessage();
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Server Response" message: serverMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        [myAlertView show];
        return;
    }
}



- (void) httpFailureHandler : (NSString*) callName : (NSString*) message
{
     [loadingView removeView];
}

#pragma -mark calculate cell height
-(NSUInteger)newCellHeight :(NSArray *)array
{
    NSMutableArray *columnWidthArray = [[NSMutableArray alloc]init];
    CGFloat screenWidth = self.tableView.frame.size.width;
    float columnWidth = 0.0f;
    //new added start for color & hide some column in table
    NSMutableDictionary *columnLengthMap = (NSMutableDictionary *)[cellComponent objectAtIndex:1];
    NSMutableArray *elementId = (NSMutableArray *)[cellComponent objectAtIndex:2];
    NSMutableArray *headerElementId = (NSMutableArray *)[cellComponent objectAtIndex:3];
    
    int totalPerc = 0;
    // QStringList lengthKeys = columnLengthMap->keys();
    NSArray* lengthKeys = [columnLengthMap allKeys];
    //for (int cntTableColumn = 0; cntTableColumn < lengthKeys.count(); cntTableColumn++)
    for(int cntTableColumn = 0; cntTableColumn < [lengthKeys count]; cntTableColumn++)
    {
        NSString* tempLen = [columnLengthMap objectForKey:[lengthKeys objectAtIndex:cntTableColumn]];
        //columnLengthMap->value(lengthKeys.at(cntTableColumn));
        totalPerc = totalPerc + [tempLen intValue];// tempLen.toInt();
    }
    //end
    
    for(int i=0; i<[elementId count]; i++)
    {
        //start calculate tableheader column width
        NSString* tempLen = [columnLengthMap objectForKey:[elementId objectAtIndex:i]];//columnLengthMap->value(headerElementId->at(cntTableColumn));
        // qDebug() << "Column Width = " << tempLen;
        // NSLog(@"column Width = tempLen");
        int normalized = 100/[headerElementId count];//(headerElementId->count());
        if(totalPerc!=0) {
            normalized = [tempLen intValue]*100/totalPerc;//tempLen.toInt()*100/totalPerc;
            // NSLog(@"normalized value = @%d",normalized);
        }
        
        
        
        NSMutableArray *check = [cellComponent objectAtIndex:4];//for Polycab project in policy menu according to change UI
        if ([[check objectAtIndex:0] isEqualToString:@"Policy"]) {
            columnWidth = screenWidth;        }
        else
        {
            columnWidth = screenWidth * normalized / 100;
        }
        
        [columnWidthArray addObject:[NSString stringWithFormat:@"%f",columnWidth]];
        
    }
    
    NSMutableArray *elementType = (NSMutableArray *)[cellComponent objectAtIndex:0];
    NSMutableArray *allComponentHeightArray = [[NSMutableArray alloc] init];
    NSInteger height=0;
    
    for (int i=0; i<elementType.count; i++) {
        if ([[elementType objectAtIndex:i] isEqualToString:XmwcsConst_DE_COMPONENT_LABEL]) {
            float width = [[columnWidthArray objectAtIndex:i] floatValue];
            CGSize maximumLabelSize = CGSizeMake(width, FLT_MAX);
            
            NSString *str = @"";
            id object = [array objectAtIndex:i];
            
            if(![object isEqual:[NSNull null]])
            {
                str = [array objectAtIndex:i];
                if (str == nil || [str isKindOfClass:[NSNull class]] || str.length<=0 || str == NULL || [str isEqualToString:@""]) {
                    str = @"";
                }
                
            }
            else
            {
                str = @"";
            }
            
            CGSize expectedLabelSize = [str sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE_ROW] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
            
            [allComponentHeightArray addObject:[NSString stringWithFormat:@"%f", expectedLabelSize.height]];
        }
        
    }
    NSArray *sortedArray = [allComponentHeightArray  sortedArrayUsingComparator:
                            ^NSComparisonResult(id obj1, id obj2){
                                if ([obj1 floatValue] > [obj2 floatValue])
                                    return NSOrderedDescending;
                                else if ([obj1 floatValue] < [obj2 floatValue])
                                    return NSOrderedAscending;
                                return NSOrderedSame;
                                
                            }];
    
    height = [[sortedArray objectAtIndex: [sortedArray count]-1] floatValue];
    if (height<=[ReportTabularDataSection tableRowHeight]) {
        height =[ReportTabularDataSection tableRowHeight];
    }
    else
    {
        height = height+2;
    }
    return height;
    
    
}
#pragma mark - searchBar handler
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    if (searchText.length >0)
    {
        recordTableData = [[NSMutableArray alloc] init];
        for (int i=0; i<orignalReportTableData.count; i++) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObjectsFromArray:[orignalReportTableData objectAtIndex:i]];
            for (int j=0; j<array.count; j++) {
                NSString *name  = [array objectAtIndex:j];
                
                NSRange nameRange = [name rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (nameRange.location != NSNotFound) {
                    [recordTableData addObject: [orignalReportTableData objectAtIndex:i]];
                    break;
                }
            }
            
            
            
        }
         [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:reportSection] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    
    else
    {
        recordTableData = [[NSMutableArray alloc] init];
        [recordTableData addObjectsFromArray:orignalReportTableData];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:reportSection] withRowAnimation:UITableViewRowAnimationFade];
    }
}
@end
