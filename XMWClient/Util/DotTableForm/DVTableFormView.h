//
//  DVTableFormView.h
//  ExPMCalender
//
//  Created by Pradeep Singh on 4/10/14.
//  Copyright (c) 2014 Dotvik Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DVTableFormView;
@class DotFormElement;

@protocol DVTableFormViewDelegate <NSObject>
-(void) notifyRowAdded_HeightIncreased:(int) heightInc;
-(void) notifyRowDeleted_HeightDecreased:(int) heightDec;
@end


@protocol DVTableFormColumnDelegate <NSObject>
-(void) columnHeadingRenderer:(DVTableFormView*) tfv column:(int) colIdx cell:(UIView*) view;
-(void) columnCellRenderer:(DVTableFormView*) tfv  row:(int) rowIdx column:(int) colIdx cell:(UIView*) view;
-(void) columnCellToBeRemoved:(DVTableFormView*) tfv  row:(int) rowIdx column:(int) colIdx cell:(UIView*) view;
-(CGFloat) columnOffsetForColumn:(int) colIdx;
@end


@protocol DVTableFormRowDelegate <NSObject>
-(void) addColumn:(NSString*) columnName formElement:(DotFormElement*)element delegate:(id<DVTableFormColumnDelegate>) columnDelegate;

-(id<DVTableFormColumnDelegate>) columnDelegateForColumn:(NSString*) columnName;

-(id<DVTableFormColumnDelegate>) columnDelegateForColumnIndex:(int) colIdx;

-(DotFormElement*) formElementForColumnIndex:(int) colIdx;
-(DotFormElement*) formElementForColumn:(NSString*) columnName;
-(void) updateRowNumber:(UIView*) rowContainer oldNumber:(int) oldRowId action:(int) minusOrPlus;
-(NSArray*) rowDataForSubmit:(UIView*) rowContainer forRow:(int) rowIdx;

@end



@interface DVTableFormView : UIView
{
    id<DVTableFormRowDelegate> rowDelegate;
}


@property id<DVTableFormRowDelegate> rowDelegate;

- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrameWithNoRightAction:(CGRect)frame;

-(void) subscribeTableUIEvent:(id<DVTableFormViewDelegate>) tableDelegate;
-(void) addColumn:(DotFormElement*) formElement;


-(void)insertRowAfterRow:(int)rowId withData:(NSArray*)searchRecord header:(NSArray*)headerData;
-(void) updateRowAfterRow:(int)rowId withData:(NSArray*)searchRecord header:(NSArray*)headerData;
-(UIView*) getRowCellWithRowId:(int) rowIdx colId:(int) colIdx;

-(UIView*) getRowWithRowId:(int) rowIdx;
-(UIButton*) getActionButtonWithRowId:(int) rowIdx;
-(long) rowIndexOfActionButton:(UIButton*) actionButton;
-(void) updateActionButtonTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents forRowId:(int)rowIdx;

-(int) getRowCount;


@end
