//
//  EditOrderTableFormDelegate.m
//  QCMSProject
//
//  Created by Pradeep Singh on 6/7/16.
//  Copyright © 2016 dotvik. All rights reserved.
//

#import "EditOrderTableFormDelegate.h"


@interface EditOrderTableFormDelegate ()
{
    CGFloat columnOffsets[10];
}

@end



@implementation EditOrderTableFormDelegate


-(id)init
{
    self  = [super init];
    
    columnOffsets[0] = 0.0f;
    columnOffsets[1] = 110.0f;
    columnOffsets[2] = 170.0f;
    columnOffsets[3] = 300.0f;
    columnOffsets[4] = 340.0f;
    columnOffsets[5] = 380.0f;
    columnOffsets[6] = 450.0f;
    columnOffsets[7] = 520.0f;
    columnOffsets[8] = 590.0f;
    columnOffsets[9] = 660.0f;
    
    return self;
}


-(CGFloat) columnOffsetForColumn:(int) colIdx
{
    if(colIdx<10) {
        return columnOffsets[colIdx];
    } else {
        return columnOffsets[9] + (11-colIdx)*70.0f;
    }
}


#pragma  mark - MultiSelect search

-(void) multipleItemsSelected:(NSArray*) headerData   :(NSArray*) selectedRows
{
    
    [self  multipleItemsSelectedForEditOrder:(NSArray*) headerData   :(NSArray*) selectedRows];
    
    
}


-(void) multipleItemsSelectedForEditOrder:(NSArray*) headerData   :(NSArray*) selectedRows
{
    NSLog(@"XMWCreateOrderTFVDelegate.multipleItemsSelected : total items selected = %d", [selectedRows count]);
    NSLog(@"currentCTX = %@", self.currentCtx);
    NSArray* parts = [self.currentCtx componentsSeparatedByString:@":"];
    if([parts count]==2) {
        NSString* rowIdxStr = [parts objectAtIndex:0];
        NSString* colIdxStr = [parts objectAtIndex:1];
        
        int rowId = rowIdxStr.intValue;
        int colId = colIdxStr.intValue;
        
        if(selectedRows!=nil && ([selectedRows count]>0)) {
            for(int i=0; i<[selectedRows count]; i++) {
                NSArray* searchRecord = (NSArray*)[selectedRows objectAtIndex:i];
                if(i==0) {
                    // we need to update data on the row identified by rowId
                    [self.ctxTableFormView updateRowAfterRow:rowId withData:searchRecord header:headerData];
                    
                    UIView* searchCell = [self.ctxTableFormView getRowCellWithRowId:(rowId+i) colId:0];
                    MXLabel* labelField = (MXLabel*)[[searchCell subviews] objectAtIndex:0];
                    labelField.text = [searchRecord objectAtIndex:0];
                    
                    UIView* descCell = [self.ctxTableFormView getRowCellWithRowId:(rowId+i) colId:2];
                    MXLabel* descLabel = (MXLabel*)[[descCell subviews] objectAtIndex:0];
                    descLabel.text = [searchRecord objectAtIndex:1];
                    descLabel.font = [UIFont systemFontOfSize:11];
                    descLabel.numberOfLines = 0;
                    
                    UIView* unitCell = [self.ctxTableFormView getRowCellWithRowId:(rowId+i) colId:3];
                    MXLabel* unitLabel = (MXLabel*)[[unitCell subviews] objectAtIndex:0];
                    unitLabel.font = [UIFont systemFontOfSize:11];
                    unitLabel.text = [searchRecord objectAtIndex:2];
                    
                } else {
                    // we need to insert data on the new rows after rowId
                    [self.ctxTableFormView insertRowAfterRow:rowId withData:searchRecord header:headerData];
                    
                    rowId = rowId + 1;
                    
                    
                    UIView* searchCell = [self.ctxTableFormView getRowCellWithRowId:(rowId) colId:0];
                    MXLabel* labelField = (MXLabel*)[[searchCell subviews] objectAtIndex:0];
                    labelField.text = [searchRecord objectAtIndex:0];
                    
                    UIView* descCell = [self.ctxTableFormView getRowCellWithRowId:(rowId) colId:2];
                    MXLabel* descLabel = (MXLabel*)[[descCell subviews] objectAtIndex:0];
                    descLabel.text = [searchRecord objectAtIndex:1];
                    descLabel.font = [UIFont systemFontOfSize:11];
                    descLabel.numberOfLines = 0;
                    
                    UIView* unitCell = [self.ctxTableFormView getRowCellWithRowId:(rowId) colId:3];
                    MXLabel* unitLabel = (MXLabel*)[[unitCell subviews] objectAtIndex:0];
                    unitLabel.font = [UIFont systemFontOfSize:11];
                    unitLabel.text = [searchRecord objectAtIndex:2];
                    
                }
            }
        }
    }
}


@end
