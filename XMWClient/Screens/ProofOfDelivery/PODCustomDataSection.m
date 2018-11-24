//
//  PODCustomDataSection.m
//  QCMSProject
//
//  Created by Pradeep Singh on 3/29/17.
//  Copyright © 2017 dotvik. All rights reserved.
//

#import "PODCustomDataSection.h"
#import "PODTableViewCell.h"
#import "DotReport.h"
#import "DotReportElement.h"
#import "XmwcsConstant.h"


#define FONT_SIZE_ROW 12.0f


@interface PODCustomDataSection ()
{
    
    NSMutableArray* _rowOpenCloseState;
}


@end




@implementation PODCustomDataSection


-(instancetype)init {
    self = [super init];
    
    return self;
}


-(void)updateData: (DotReport*) inDotReport :(ReportPostResponse*) inReportPostResponse
{
    [super updateData:inDotReport :inReportPostResponse];
    _rowOpenCloseState = [[NSMutableArray alloc] initWithCapacity:[recordTableData count]];
    
    for(int i=0; i<[recordTableData count]; i++) {
        [_rowOpenCloseState addObject:[NSNumber numberWithBool:YES]];
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL closeState = [[_rowOpenCloseState objectAtIndex:indexPath.row] boolValue];
    if(closeState==YES) {
        return 240.0f;  //this is default height
    } else {
        CGFloat defaultHeight = 240.0f;
        defaultHeight = defaultHeight + [self heightOfExpandedView:indexPath.row];
        
        return defaultHeight;
    }
    
}

-(CGFloat) heightOfExpandedView:(NSInteger) rowIndex
{
    CGFloat y_Offset = 0.0f;
    CGFloat rowHeight = 30.0f;
    
    if([cellComponent count]>5) {
        NSArray* hiddenElementIds = [cellComponent objectAtIndex:5]; // 5th position has hidden elements
        if([hiddenElementIds count]>0) {
            y_Offset = rowHeight*[hiddenElementIds count];
        }
    }
    return y_Offset;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PODTableViewCell"];
    
    if (cell == nil) {
        cell = [[PODTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PODTableViewCell"];
        
        
    }
    
    PODTableViewCell* podCell = (PODTableViewCell*) cell;
    
    [self initializeDataRowCell:podCell];
    
    // make sure to remove any previous target
    [podCell.accessoryButton removeTarget:self action:@selector(openCloseAccessoryAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [podCell.accessoryButton addTarget:self action:@selector(openCloseAccessoryAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    PODTableViewCell* podCell = (PODTableViewCell*) cell;
    podCell.accessoryButton.tag = indexPath.row;
    
    BOOL closeState = [[_rowOpenCloseState objectAtIndex:indexPath.row] boolValue];
    if(closeState==YES) {
        podCell.expandedView.hidden = YES;
        [podCell.accessoryButton setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    } else {
        podCell.expandedView.hidden = NO;
        [podCell.accessoryButton setImage:[UIImage imageNamed:@"arrow_up"] forState:UIControlStateNormal];
        
        [self willDisplayExpandedView:podCell.expandedView forRowAtIndexPath:indexPath.row];
    }
    
    [self configureDataRowCell:podCell rowIndex:indexPath];
    
}


-(void)  willDisplayExpandedView:(UIView*)exView forRowAtIndexPath:(NSInteger) rowIndex
{
    for(UIView* v in exView.subviews) {
        [v removeFromSuperview];
    }
    
    CGFloat y_Offset = 0.0f;
    CGFloat rowHeight = 25.0f;

    NSArray* rowData = [recordTableData objectAtIndex:rowIndex];
    
    if([cellComponent count]>5) {
        NSMutableArray *reportElementIds = (NSMutableArray *)[cellComponent objectAtIndex:2];
        NSArray* hiddenElementIds = [cellComponent objectAtIndex:5]; // 5th position has hidden elements
        
        if([hiddenElementIds count]>0) {
            for(int i=0; i<[hiddenElementIds count];i++) {
                NSString* elementId = [hiddenElementIds objectAtIndex:i];
                DotReportElement* reportElement = [self.dotReport.reportElements objectForKey:elementId];
                UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, y_Offset, exView.frame.size.width, rowHeight)];
                lineView.tag = 5000 + i;
                
                UILabel* leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, (exView.frame.size.width/2)-10, rowHeight)];
                leftLabel.textAlignment = NSTextAlignmentLeft;
                leftLabel.tag = 101;
                leftLabel.font = [UIFont systemFontOfSize:FONT_SIZE_ROW];
                leftLabel.text = reportElement.displayText;
                
                [lineView addSubview:leftLabel];
                
                
                UILabel* rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(exView.frame.size.width/2 + 5, 0, (exView.frame.size.width/2)-10, rowHeight)];
                rightLabel.textAlignment = NSTextAlignmentRight;
                rightLabel.tag = 102;
                rightLabel.font = [UIFont systemFontOfSize:FONT_SIZE_ROW];
                
                
                NSInteger dataIndex = [reportElementIds indexOfObject:reportElement.elementId];
                
                rightLabel.text = [rowData objectAtIndex:dataIndex];
                
                [lineView addSubview:rightLabel];
                
                [exView addSubview:lineView];
                
                y_Offset = y_Offset + rowHeight;
            }
            
            UIView* h_line = [[UIView alloc] initWithFrame:CGRectMake(40.0f, y_Offset, exView.frame.size.width - 80.0f, 1.0f)];
            h_line.backgroundColor = [UIColor lightGrayColor];
            [exView addSubview: h_line];
        }
    }
}


-(IBAction)openCloseAccessoryAction:(id)sender
{
    UIButton* openCloseButton = (UIButton*) sender;
    
    NSInteger rowIndex = openCloseButton.tag;
    
    if(rowIndex>=0 && rowIndex < [recordTableData count]) {
        BOOL closeState = [[_rowOpenCloseState objectAtIndex:rowIndex] boolValue];
        if(closeState==YES) {
            [_rowOpenCloseState setObject:[NSNumber numberWithBool:NO] atIndexedSubscript:rowIndex];
        } else {
            [_rowOpenCloseState setObject:[NSNumber numberWithBool:YES] atIndexedSubscript:rowIndex];
        }
        
        NSIndexPath* rowPath = [NSIndexPath indexPathForRow:rowIndex inSection:reportSection];
        
        NSArray* reloadRows = [[NSArray alloc] initWithObjects:rowPath, nil];
        
        [self.tableView reloadRowsAtIndexPaths:reloadRows withRowAnimation:UITableViewRowAnimationFade];
    }
}



-(UIView*) initializeDataRowCell:(PODTableViewCell*) podCell
{
    CGFloat screenWidth = self.tableView.frame.size.width;
    
    UIView* rowView = podCell.topRowView;
    
    
    //new added start for color & hide some column in table
    NSMutableArray *elementType = (NSMutableArray *)[cellComponent objectAtIndex:0];
    NSMutableDictionary *columnLengthMap = (NSMutableDictionary *)[cellComponent objectAtIndex:1];
    NSMutableArray *elementId = (NSMutableArray *)[cellComponent objectAtIndex:2];
    NSMutableArray *headerElementId = (NSMutableArray *)[cellComponent objectAtIndex:3];
    
    
    int x = 0;
    
    UIView* firstCol;
    UILabel *mItemLabel;
    
    NSInteger height = podCell.topRowView.frame.size.height;
    
    int totalPerc = 0;
    NSArray* lengthKeys = [columnLengthMap allKeys];
    for(int cntTableColumn = 0; cntTableColumn < [lengthKeys count]; cntTableColumn++)
    {
        NSString* tempLen = [columnLengthMap objectForKey:[lengthKeys objectAtIndex:cntTableColumn]];
        totalPerc = totalPerc + [tempLen intValue];
    }
    
    
    for(int i=0; i<[elementId count]; i++)
    {
        //start calculate tableheader column width
        NSString* tempLen = [columnLengthMap objectForKey:[elementId objectAtIndex:i]];
        // NSLog(@"column Width = tempLen");
        int normalized = 100/[headerElementId count];
        if(totalPerc!=0) {
            normalized = [tempLen intValue]*100/totalPerc;
        }
        
        float columnWidth = screenWidth * normalized / 100;
        
        int firstColTag = 1000 + i;
        
        UIView* checkAlreadyExisting = [rowView viewWithTag:(1000+i)];
        if(checkAlreadyExisting!=nil) continue;
        
        // A list item label, docked to the center, the text is set in updateItem.
        if([[elementType objectAtIndex:i] isEqualToString:XmwcsConst_DE_COMPONENT_LABEL])
        {
            firstCol = [[UIView alloc] initWithFrame:CGRectMake(x, 0, columnWidth, height)];
            firstCol.tag = firstColTag;
            mItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, columnWidth - 4, height)];
            mItemLabel.tag = 11;
            
            [mItemLabel setFont:[UIFont systemFontOfSize:FONT_SIZE_ROW]];
            mItemLabel.numberOfLines = 0;
            x = x + columnWidth;
            
            DotReportElement* dotReportElement = [reportElements objectForKey:[elementId objectAtIndex:i]];
            if([dotReportElement.dataType isEqualToString:XmwcsConst_DE_TEXTFIELD_DATA_TYPE_NUMERIC] ||
               [dotReportElement.dataType isEqualToString:XmwcsConst_DE_TEXTFIELD_DATA_TYPE_AMOUNT] ||
               [dotReportElement.dataType isEqualToString:XmwcsConst_DE_TEXTFIELD_DATA_TYPE_FLOAT])
            {
                mItemLabel.textAlignment = NSTextAlignmentRight;
            }
            
            [firstCol addSubview:mItemLabel];
            [rowView  addSubview: firstCol];
            
        } if([[elementType objectAtIndex:i] isEqualToString:XmwcsConst_DRE_COLUMN_TYPE_EXPAND]) {
            x = x + columnWidth;
        }
    }
    return rowView;
}

-(void) configureDataRowCell:(PODTableViewCell*) podCell rowIndex:(NSIndexPath *)indexPath
{
    UIView* dataCell = podCell.topRowView;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    //new added start for color & hide some column in table
    NSMutableArray *elementType = (NSMutableArray *)[cellComponent objectAtIndex:0];
    NSMutableDictionary *columnLengthMap = (NSMutableDictionary *)[cellComponent objectAtIndex:1];
    NSMutableArray *elementId = (NSMutableArray *)[cellComponent objectAtIndex:2];
    NSMutableArray *headerElementId = (NSMutableArray *)[cellComponent objectAtIndex:3];
    
    
    NSMutableArray* row = [recordTableData objectAtIndex:indexPath.row];
    // NSInteger width = screenWidth/[cellComponent count];
    
    UIView* firstCol;
    UILabel *mItemLabel;
    
    int totalPerc = 0;
    
    NSArray* lengthKeys = [columnLengthMap allKeys];
    for(int cntTableColumn = 0; cntTableColumn < [lengthKeys count]; cntTableColumn++)
    {
        NSString* tempLen = [columnLengthMap objectForKey:[lengthKeys objectAtIndex:cntTableColumn]];
        totalPerc = totalPerc + [tempLen intValue];
    }
    
    for(int i=0; i<[elementId count]; i++)
    {
        //start calculate tableheader column width
        NSString* tempLen = [columnLengthMap objectForKey:[elementId objectAtIndex:i]];
        
        int normalized = 100/[headerElementId count];
        if(totalPerc!=0) {
            normalized = [tempLen intValue]*100/totalPerc;
        }
        
        
        int firstColTag = 1000 + i;
        // A list item label, docked to the center, the text is set in updateItem.
        if([[elementType objectAtIndex:i] isEqualToString:XmwcsConst_DE_COMPONENT_LABEL])
        {
            firstCol = [dataCell viewWithTag:firstColTag];
            mItemLabel = (UILabel*)[firstCol viewWithTag:11];
            
            mItemLabel.text = [row objectAtIndex:i];
            [mItemLabel setFont:[UIFont systemFontOfSize:FONT_SIZE_ROW]];
            mItemLabel.numberOfLines = 0;
            
        }
    }
}

@end
