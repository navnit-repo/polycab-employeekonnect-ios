//
//  DVTwoWeekView.h
//  ExPMCalender
//
//  Created by Pradeep Singh on 4/14/14.
//  Copyright (c) 2014 Dotvik Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVDateCell.h"
#import "DVDateStruct.h"

@interface DVDateCell (DVTWV)
@property DVDateStruct* dateStruct;
@end

@protocol DVTwoWeekViewDelegate <NSObject>
-(void) dateSelected:(DVDateCell*) cell;
@end


@interface DVTwoWeekView : UIView <DVDateCellDelegate>
{
    
    id<DVTwoWeekViewDelegate> twoWeekViewDelegate;
    id<DVDateCellCustomRenderer> cellRenderer;
}

@property id<DVTwoWeekViewDelegate> twoWeekViewDelegate;
@property id<DVDateCellCustomRenderer> cellRenderer;


- (id)initWithFrame:(CGRect)frame date:(DVDateStruct*) inDate Renderer:(id<DVDateCellCustomRenderer>) myCellRenderer;


@end
