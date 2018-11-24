//
//  ExpandableRowTabularDataSection.m
//  QCMSProject
//
//  Created by Pradeep Singh on 3/6/17.
//  Copyright © 2017 dotvik. All rights reserved.
//

#import "ExpandableRowTabularDataSection.h"
#import "DotReport.h"
#import "DotReportElement.h"
#import "XmwcsConstant.h"



@interface ExpandableRowTabularDataSection ()
{
    
    NSMutableArray* _rowOpenCloseState;
}

@end

@implementation ExpandableRowTabularDataSection

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
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];  //this is default height
    } else {
        CGFloat defaultHeight = [super tableView:tableView heightForRowAtIndexPath:indexPath];
        defaultHeight = defaultHeight + [self heightOfExpandedView:indexPath.row];
        
        return defaultHeight;
    }

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

    // we need to add button for expanding the row as well
    UIView* customView = [cell.contentView viewWithTag:3001];
    if(customView!=nil) {
        [self addCustomOpenCloseAccessory:customView];
    }
    
    // adding expanded view but in hidden state
    UIView* exView = [cell.contentView viewWithTag:5000];
    if(exView==nil) {
        exView = [self createExpandedView:CGRectMake(0, [super tableView:tableView heightForRowAtIndexPath:indexPath], [UIScreen mainScreen].bounds.size.width, 0)];
        exView.tag = 5000;
        exView.hidden = YES;
        [cell.contentView addSubview:exView];
    }
    
    
    UIView* hLineView = [cell.contentView viewWithTag:7001];
    if(hLineView==nil) {
        hLineView = [[UIView alloc] initWithFrame:CGRectMake(0, [self tableView:tableView heightForRowAtIndexPath:indexPath] - 1, tableView.frame.size.width, 1.0f)];
        hLineView.tag = 7001;
        hLineView.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:hLineView];
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    
    
    // we need to add button for expanding the row as well
    UIView* customView = [cell.contentView viewWithTag:3001];
    if(customView!=nil) {
        [self willDisplayAccessoryView:customView forRowAtIndexPath:indexPath.row];
    }
   
    
    UIView* exView = [cell.contentView viewWithTag:5000];
    
    BOOL closeState = [[_rowOpenCloseState objectAtIndex:indexPath.row] boolValue];
    if(closeState==YES) {
        exView.hidden = YES;
    } else {
        exView.hidden = NO;
        [self willDisplayExpandedView:exView forRowAtIndexPath:indexPath.row];
    }
    
    UIView* hLineView = [cell.contentView viewWithTag:7001];
    hLineView.frame = CGRectMake(0, [self tableView:tableView heightForRowAtIndexPath:indexPath] - 1, tableView.frame.size.width, 1.0f);
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*
     // Pradeep: Do below in the accessory button action only
     
    BOOL closeState = [[_rowOpenCloseState objectAtIndex:indexPath.row] boolValue];
    if(closeState==YES) {
        [_rowOpenCloseState setObject:[NSNumber numberWithBool:NO] atIndexedSubscript:indexPath.row];
    } else {
        [_rowOpenCloseState setObject:[NSNumber numberWithBool:YES] atIndexedSubscript:indexPath.row];
    }
    
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:reportSection] withRowAnimation:UITableViewRowAnimationFade];
     */
    
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


-(void) addCustomOpenCloseAccessory:(UIView*) cellRowView
{
    NSMutableArray *reportElementIds = (NSMutableArray *)[cellComponent objectAtIndex:2];
    for(int idx=0; idx<[reportElementIds count]; idx++) {
        DotReportElement* reportElement = [self.dotReport.reportElements objectForKey:[reportElementIds objectAtIndex:idx]];
         int firstColTag = 1000 + idx;
        
        if([reportElement.componentType isEqualToString:XmwcsConst_DRE_COLUMN_TYPE_EXPAND]) {
            UIView* colView = [cellRowView viewWithTag:firstColTag];
            
            UIButton* openCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
            openCloseButton.frame = CGRectMake(0, 0, colView.frame.size.width, colView.frame.size.height);
            [openCloseButton setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
            
            
            [openCloseButton addTarget:self action:@selector(openCloseAccessoryAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [colView addSubview:openCloseButton];
        }
    }
}


-(UIView*) createExpandedView:(CGRect) frame
{
    UIView* exView = [[UIView alloc] initWithFrame:frame];
    
    CGFloat y_Offset = 0.0f;
    CGFloat rowHeight = 30.0f;
    
    if([cellComponent count]>5) {
        NSArray* hiddenElementIds = [cellComponent objectAtIndex:5]; // 5th position has hidden elements
        if([hiddenElementIds count]>0) {
            for(int i=0; i<[hiddenElementIds count];i++) {
                NSString* elementId = [hiddenElementIds objectAtIndex:i];
                DotReportElement* reportElement = [self.dotReport.reportElements objectForKey:elementId];
                
                UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, y_Offset, frame.size.width, rowHeight)];
                lineView.tag = 5000 + i;
                
                
                UILabel* leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, (frame.size.width/2)-10, rowHeight)];
                leftLabel.textAlignment = NSTextAlignmentLeft;
                leftLabel.tag = 101;
                leftLabel.font = [UIFont systemFontOfSize:12.0f];
                leftLabel.text = reportElement.displayText;
                
                [lineView addSubview:leftLabel];

                UILabel* rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2 + 5, 0, (frame.size.width/2)-10, rowHeight)];
                rightLabel.textAlignment = NSTextAlignmentRight;
                rightLabel.tag = 102;
                rightLabel.font = [UIFont systemFontOfSize:12.0f];

                [lineView addSubview:rightLabel];
                
                [exView addSubview:lineView];
                
                y_Offset = y_Offset + rowHeight;
            }
            
            exView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, y_Offset);
            
        }
    }
    
    return exView;
}


-(void) willDisplayAccessoryView:(UIView*) cellRowView forRowAtIndexPath:(NSInteger) rowIndex
{
    BOOL closeState = [[_rowOpenCloseState objectAtIndex:rowIndex] boolValue];
    
    NSMutableArray *reportElementIds = (NSMutableArray *)[cellComponent objectAtIndex:2];
    for(int idx=0; idx<[reportElementIds count]; idx++) {
        DotReportElement* reportElement = [self.dotReport.reportElements objectForKey:[reportElementIds objectAtIndex:idx]];
        int firstColTag = 1000 + idx;
        
        if([reportElement.componentType isEqualToString:XmwcsConst_DRE_COLUMN_TYPE_EXPAND]) {
            UIView* colView = [cellRowView viewWithTag:firstColTag];
            
            for(UIView* buttonView in [colView subviews]) {
                if([buttonView isKindOfClass:[UIButton class]]) {
                    UIButton* openCloseButton =  (UIButton*) buttonView;
                    // we need to set the rowIndex as well on the button
                    // other wise we will not able to identify which row it is clicked
                    openCloseButton.tag = rowIndex;
                    
                    if(closeState==YES) {
                        [openCloseButton setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
                    } else {
                        [openCloseButton setImage:[UIImage imageNamed:@"arrow_up"] forState:UIControlStateNormal];
                    }
                }
            }
            
        }
    }
    
}

-(void)  willDisplayExpandedView:(UIView*)exView forRowAtIndexPath:(NSInteger) rowIndex
{

    NSArray* rowData = [recordTableData objectAtIndex:rowIndex];
    
    if([cellComponent count]>5) {
        NSMutableArray *reportElementIds = (NSMutableArray *)[cellComponent objectAtIndex:2];
        NSArray* hiddenElementIds = [cellComponent objectAtIndex:5]; // 5th position has hidden elements
        
        /*
        for(int colIdx=0; colIdx<[reportElementIds count]; colIdx++ ) {
            NSString* reportElementId = [reportElementIds objectAtIndex:colIdx];
            DotReportElement* reportElement = [self.dotReport.reportElements objectForKey:reportElementId];

        }
         */
        
        if([hiddenElementIds count]>0) {
            for(int i=0; i<[hiddenElementIds count];i++) {
                NSString* elementId = [hiddenElementIds objectAtIndex:i];
                DotReportElement* reportElement = [self.dotReport.reportElements objectForKey:elementId];
                
                
                
                UIView* lineView = [exView viewWithTag:(5000+i)];
            
                // UILabel* leftLabel = [lineView viewWithTag:101];
                
                UILabel* rightLabel = [lineView viewWithTag:102];
                
                NSInteger dataIndex = [reportElementIds indexOfObject:reportElement.elementId];

                rightLabel.text = [rowData objectAtIndex:dataIndex];
                
            }
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
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:reportSection] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
