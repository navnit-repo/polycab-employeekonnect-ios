//
//  DVDateCell.m
//  ExPMCalender
//
//  Created by Pradeep Singh on 4/3/14.
//  Copyright (c) 2014 Dotvik Solutions. All rights reserved.
//

#import "DVDateCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation DVDateCell


+(int) REGISTER_FIRE
{
    return 1;
}
+(int) REGISTER_LOST_FOCUS
{
    return 2;
}
+(int) REGISTER_GOT_FOCUS
{
    return 4;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@synthesize label;
@synthesize cellIdx;
@synthesize dateAtCell;
@synthesize month;
@synthesize year;
@synthesize focusEventRegister;
@synthesize cellName;
@synthesize text;
@synthesize labelHeight;
@synthesize labelWidth;
@synthesize focusable;
@synthesize dateCellDelegate;
@synthesize cellRenderer;



- (id)initWithFrame:(CGRect)frame  Text:(NSString*) inText Day:(int) inDateAtCell Month:(int) inMonth Year:(int) inYear  CellIndex:(int) inCellIdx  Focus:(BOOL) inFocusable Renderer:(id<DVDateCellCustomRenderer>) myCellRenderer
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.text = inText;
        self.dateAtCell = inDateAtCell;
        self.month = inMonth;
        self.year = inYear;
        self.cellIdx = inCellIdx;
        self.focusable = inFocusable;
        self.cellRenderer = myCellRenderer;
        
        [self renderCell];
        
        UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandling:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tapGestureRecognizer];
        
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame Text:(NSString*) inText Day:(int) inDateAtCell Month:(int) inMonth Year:(int) inYear CellIndex:(int) inCellIdx Renderer:(id<DVDateCellCustomRenderer>) myCellRenderer
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.text = inText;
        self.dateAtCell = inDateAtCell;
        self.month = inMonth;
        self.year = inYear;
        self.cellIdx = inCellIdx;
        self.cellRenderer = myCellRenderer;
        
        [self renderCell];
        
        UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandling:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

-(IBAction)tapHandling:(UITapGestureRecognizer*)sender
{
    
    NSLog(@"DVDateCell: tabHandling, cellname = %@", self.cellName);
    NSLog(@"DVDateCell: tabHandling, cellIdx = %d", self.cellIdx);
    NSLog(@"DVDateCell: tabHandling, dateAtCell = %d", self.dateAtCell);
    NSLog(@"DVDateCell: tabHandling, text = %@", self.text);
    NSLog(@"DVDateCell: tabHandling, focusEventRegister = %d", self.focusEventRegister);

    if(self.dateCellDelegate!=nil && [self.dateCellDelegate respondsToSelector:@selector(cellTapped:)]) {
            [self.dateCellDelegate cellTapped:self];
    }

}

-(void) renderCell
{
    if(self.cellRenderer!=nil && [self.cellRenderer respondsToSelector:@selector(setLayoutForCell:)]) {
        [self.cellRenderer setLayoutForCell:self];
    } else {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        label.text = self.text;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
    
}

@end
