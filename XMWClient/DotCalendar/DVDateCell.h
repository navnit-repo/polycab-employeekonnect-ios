//
//  DVDateCell.h
//  ExPMCalender
//
//  Created by Pradeep Singh on 4/3/14.
//  Copyright (c) 2014 Dotvik Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DVDateCell;

@protocol DVDateCellDelegate <NSObject>
-(void) cellTapped:(DVDateCell*) cell;
@end

@protocol DVDateCellCustomRenderer <NSObject>
-(void) setLayoutForCell:(DVDateCell*) cell;
-(void) setLayoutForSelectedCell:(DVDateCell*) cell;
-(void) setLayoutForDefaultDateCell:(DVDateCell*) cell;

@end



@interface DVDateCell : UIView
{
    
    UILabel* label;
    
	int cellIdx;
	int dateAtCell;
    int month;
    int year;
	int focusEventRegister;
    
	NSString* cellName;
	NSString* text;
    
    int labelHeight;
    int labelWidth;
    BOOL focusable;
    id<DVDateCellDelegate> dateCellDelegate;
    id<DVDateCellCustomRenderer> cellRenderer;
    
}


+(int) REGISTER_FIRE;
+(int) REGISTER_LOST_FOCUS;
+(int) REGISTER_GOT_FOCUS;

@property UILabel* label;
@property int cellIdx;
@property int dateAtCell;
@property int month;
@property int year;
@property int focusEventRegister;
@property NSString* cellName;
@property NSString* text;
@property int labelHeight;
@property int labelWidth;
@property BOOL focusable;
@property id<DVDateCellDelegate> dateCellDelegate;
@property id<DVDateCellCustomRenderer> cellRenderer;



- (id)initWithFrame:(CGRect)frame  Text:(NSString*) inText Day:(int) inDateAtCell Month:(int) inMonth Year:(int) inYear CellIndex:(int) inCellIdx  Focus:(BOOL) inFocusable Renderer:(id<DVDateCellCustomRenderer>) myCellRenderer;
- (id)initWithFrame:(CGRect)frame Text:(NSString*) inText Day:(int) inDateAtCell Month:(int) inMonth Year:(int) inYear CellIndex:(int) inCellIdx Renderer:(id<DVDateCellCustomRenderer>) myCellRenderer;




@end
