//
//  DotReportListCellRenderer.m
//  QCMSProject
//
//  Created by Ashish Tiwari on 05/08/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "DotReportListCellRenderer.h"
#import "DotReportElement.h"
#import "XmwcsConstant.h"
#import "DotReportDraw.h"
#import "ReportVC.h"
#import "AppConstants.h"
#import "DVAppDelegate.h"
#import "ClientVariable.h"

@implementation DotReportListCellRenderer
@synthesize recordTableData ,cellComponent ,dotReortdrawProp;
@synthesize dotReport;


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


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}



- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
  
    return [recordTableData count];
}
#pragma mark - Table View Delegates



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = [NSString stringWithFormat:@"SimpleTableItem:%d", indexPath.row];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:simpleTableIdentifier];
   
    
    //new added start for color & hide some column in table
    NSMutableArray *elementType = (NSMutableArray *)[cellComponent objectAtIndex:0];
    NSMutableDictionary *columnLengthMap = (NSMutableDictionary *)[cellComponent objectAtIndex:1];
    NSMutableArray *elementId = (NSMutableArray *)[cellComponent objectAtIndex:2];
    NSMutableArray *headerElementId = (NSMutableArray *)[cellComponent objectAtIndex:3];
    
    NSString *rowColor = @"";
     //newly added close
    NSMutableArray* row = [recordTableData objectAtIndex:indexPath.row];
    //NSInteger width = screenWidth/[cellComponent count];
    
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
		NSString* tempLen = [columnLengthMap objectForKey:[lengthKeys objectAtIndex:cntTableColumn]];//columnLengthMap->value(lengthKeys.at(cntTableColumn));
		totalPerc = totalPerc + [tempLen intValue];// tempLen.toInt();
    }
    //end

    
        for(int i=0; i<[elementId count]; i++)
        {
            
            //start calculate tableheader column width
            NSString* tempLen = [columnLengthMap objectForKey:[elementId objectAtIndex:i]];//columnLengthMap->value(headerElementId->at(cntTableColumn));
            // qDebug() << "Column Width = " << tempLen;
            NSLog(@"column Width = tempLen");
            int normalized = 100/[headerElementId count];//(headerElementId->count());
            if(totalPerc!=0) {
                normalized = [tempLen intValue]*100/totalPerc;//tempLen.toInt()*100/totalPerc;
                NSLog(@"normalized value = @%d",normalized);
            }
            
            float columnWidth = screenWidth * normalized / 100;
            NSLog(@"column width = @%f",columnWidth);
            //end


            // A list item label, docked to the center, the text is set in updateItem.
        if([[elementType objectAtIndex:i] isEqualToString:XmwcsConst_DE_COMPONENT_LABEL])
            {
                 firstCol = [[UIView alloc] initWithFrame:CGRectMake(x, 0, columnWidth, height)];
                mItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, columnWidth, height)];
                
                
                mItemLabel.text = [row objectAtIndex:i];
                [mItemLabel setFont:[UIFont systemFontOfSize:12]];
                 mItemLabel.numberOfLines = 0;
                
                
               if(rowColor.length>0)
               {
                   mItemLabel.backgroundColor = [self colorWithHexString:rowColor];
               }
                x = x + columnWidth;
                
			} else if( [[elementType objectAtIndex:i] isEqualToString:XmwcsConst_DRE_COLUMN_TYPE_COLOR]){
                NSString *colorVal = [row objectAtIndex:i];
				ClientVariable* clientVariable = [ClientVariable getInstance : [DVAppDelegate currentModuleContext]];
				NSMutableDictionary *colorMap = [clientVariable.CLIENT_APP_MASTER_DATA objectForKey:dotReport.legendColorOn];
				rowColor = [colorMap objectForKey:colorVal];
            } else if([[elementType objectAtIndex:i] isEqualToString:XmwcsConst_DRE_COLUMN_TYPE_CLICK]) {
				NSString *clickVal = [row objectAtIndex:i];
				ClientVariable* clientVariable = [ClientVariable getInstance : [DVAppDelegate currentModuleContext]];
                NSMutableDictionary *clickMap = [clientVariable.CLIENT_APP_MASTER_DATA objectForKey:dotReport.clickEventOn];
				if([(NSString *)[clickMap objectForKey:clickVal] isEqualToString:@"0"]){
					m_isClickableRow = false;
				}
			} else if([[elementType objectAtIndex:i] isEqualToString:XmwcsConst_DRE_COLUMN_TYPE_COLOR_CLICK]){
				ClientVariable* clientVariable = [ClientVariable getInstance : [DVAppDelegate currentModuleContext]];
                NSString *clickVal = [row objectAtIndex:i];
                NSMutableDictionary *clickMap = [clientVariable.CLIENT_APP_MASTER_DATA objectForKey:dotReport.clickEventOn];
				if([(NSString *)[clickMap objectForKey:clickVal] isEqualToString:@"0"]){
					m_isClickableRow = false;
				}
                NSString *colorVal = [row objectAtIndex:i];
                NSMutableDictionary *colorMap = [clientVariable.CLIENT_APP_MASTER_DATA objectForKey:dotReport.legendColorOn];
				rowColor = [colorMap objectForKey:colorVal];
            } else if([[elementType objectAtIndex:i] isEqualToString:XmwcsConst_DRE_COLUMN_TYPE_SPEC_CHAR_IND]){
                firstCol = [[UIView alloc] initWithFrame:CGRectMake(x, 0, columnWidth, height)];
				mItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, columnWidth, height)];
                [mItemLabel setFont:[UIFont systemFontOfSize:12]];
                 mItemLabel.text = [row objectAtIndex:i];
                mItemLabel.numberOfLines = 0;
				if(rowColor.length>0){
                    
                    mItemLabel.backgroundColor = [self colorWithHexString:rowColor];
					
				}
                x = x + columnWidth;
			} else if([[elementType objectAtIndex:i] isEqualToString:XmwcsConst_DRE_COLUMN_TYPE_EXPAND]) {
				m_expandedValue = [row objectAtIndex:i];
			}
           
            [firstCol addSubview:mItemLabel];
            [cell  addSubview: firstCol];
             

        }
    }
    
    
    tableView.separatorColor =  [UIColor colorWithRed:0.41 green:0.41 blue:0.59 alpha:1.0];
    return cell;

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
       return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
      return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return [DotReportListCellRenderer tableRowHeight];
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSLog(@"Report Screen Controller : handleRowSelected");
	NSString* expandProperty;
	BOOL isDrillDown = [self clickableAndExpandable : indexPath.row : expandProperty];
    NSLog(@"expandProperty");
	
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
		//drilldownWithNetworkCall(rowIdx, rowData);
        [dotReortdrawProp handleDrillDown: indexPath.row : dotReortdrawProp.reportVC.forwardedDataDisplay : dotReortdrawProp.reportVC.forwardedDataPost];
        
	}
    
       
    //[dotReortdrawProp handleDrillDown: indexPath.row : dotReortdrawProp.reportVC.forwardedDataDisplay : dotReortdrawProp.reportVC.forwardedDataPost];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    return UITableViewCellEditingStyleNone;
}


-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

-(bool) clickableAndExpandable : (int) rowIdx : (NSString*) expandProperty
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
    isClickableRow = [dotReport isFindDrillDown];
    
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

@end
