//
//  DVTableFormView.m
//  ExPMCalender
//
//  Created by Pradeep Singh on 4/10/14.
//  Copyright (c) 2014 Dotvik Solutions. All rights reserved.
//

#import "DVTableFormView.h"
#import "DotFormElement.h"

int TABLE_FORM_BUTTON_WIDTH = 40;
int TABLE_FORM_ROW_HEIGHT = 40;
int ROW_CONTENT_TAG_OFFSET = 8000;
int HEADER_COLUMN_TAG_OFFSET = 7000;
int ROW_BUTTON_TAG_OFFSET = 9000;


#pragma  mark - DefaultColumnDelegate

@interface DefaultColumnDelegate : NSObject <DVTableFormColumnDelegate>
{
    NSString* name;
    NSString* type;
}
@property NSString* name;
@property NSString* type;

-(id) init:(NSString*) forColumnName :(NSString*) columnType;

@end

@implementation DefaultColumnDelegate

-(id) init:(NSString*) forColumnName :(NSString*) columnType
{
    self = [super init];
    if(self!=nil)
    {
        self.name = forColumnName;
        self.type = columnType;
    }
    return self;
}
@synthesize name;
@synthesize type;

-(NSString*) heading
{
    return name;
}

-(NSString*) columnType
{
    return type;
}


-(void) columnHeadingRenderer:(DVTableFormView*) tfv column:(int) colIdx cell:(UIView*) view
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, view.frame.size.width - 4, view.frame.size.height)];
    label.text = name;
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    [view addSubview:label];
}

-(void) columnCellRenderer:(DVTableFormView*) tfv row:(int) rowIdx column:(int) colIdx cell:(UIView*) view
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, view.frame.size.width - 4, view.frame.size.height)];
    label.text = [NSString stringWithFormat:@"Row No. %d", rowIdx];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    [view addSubview:label];
    
}

@end


@interface DefaultRowDelegate : NSObject <DVTableFormRowDelegate>
{
    NSMutableDictionary* formElementsDic;
    NSMutableArray* formElementsArray;
    NSMutableDictionary* formElementColumnDelegateDic;
}

@end

@implementation DefaultRowDelegate

-(id) init
{
    self = [super init];
    if(self!=nil)
    {
        formElementsDic = [[NSMutableDictionary alloc] init];
        formElementsArray = [[NSMutableArray alloc] init];
        formElementColumnDelegateDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void) addColumn:(NSString*) columnName formElement:(DotFormElement*)element delegate:(id<DVTableFormColumnDelegate>) columnDelegate
{
    if(columnDelegate==nil) {
        columnDelegate = [[DefaultColumnDelegate alloc] init: columnName :element.componentType ];
    }
    
    [formElementsDic setObject:element forKey:columnName];
    [formElementsArray addObject:element];
    [formElementColumnDelegateDic setObject:columnDelegate forKey:element.elementId];
}

-(id<DVTableFormColumnDelegate>) columnDelegateForColumn:(NSString*) columnName
{
    DotFormElement* element = [formElementsDic objectForKey:columnName];
    return [formElementColumnDelegateDic  objectForKey:element.elementId];
}


-(id<DVTableFormColumnDelegate>) columnDelegateForColumnIndex:(int) colIdx
{
    DotFormElement* element = [formElementsArray objectAtIndex:colIdx ];
    return [formElementColumnDelegateDic  objectForKey:element.elementId];
}

-(DotFormElement*) formElementForColumnIndex:(int) colIdx
{
    return [formElementsArray objectAtIndex:colIdx ];
}

-(DotFormElement*) formElementForColumn:(NSString*) columnName
{
        return [formElementsDic objectForKey:columnName];
}

-(void) updateRowNumber:(UIView*) rowContainer oldNumber:(int) oldRowId action:(int) minusOrPlus
{
    // Do any update
    
}

-(NSArray*) rowDataForSubmit:(UIView*) rowContainer forRow:(int) rowIdx
{
    return nil;
}

@end


@interface DVTableFormView ()
{
    UIScrollView* leftContentArea;
    UIView* rightContentArea;  // Primarily Buttons
//    UIView* header;  // it will contain one scroll view and one add button on the right side
//    UIView* body;    // it will contain one scroll view
    NSMutableArray* header; // n columns of the header
    NSMutableArray* rows;  // all rows (It is array of rows. And one row container n row data
    int LEFT_AREA_WIDTH;
    int rowCount;
    int colCount;
    
    BOOL rightActionBar;
    
    NSMutableArray* uiEventSubscribers;
}
@end



@implementation DVTableFormView

@synthesize rowDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        rowCount = 0;
        colCount = 0;
        rightActionBar = true;
        
        // Initialization code
        LEFT_AREA_WIDTH = frame.size.width - TABLE_FORM_BUTTON_WIDTH;
        leftContentArea = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, LEFT_AREA_WIDTH, TABLE_FORM_ROW_HEIGHT)];
        leftContentArea.backgroundColor = [UIColor colorWithRed:12.0f/255.0f green:60.0f/255.0f blue:107.0f/255.0f alpha:1.0f];
        
        
        rightContentArea = [[UIView alloc] initWithFrame:CGRectMake(LEFT_AREA_WIDTH, 0, TABLE_FORM_BUTTON_WIDTH, TABLE_FORM_ROW_HEIGHT)];
        rightContentArea.backgroundColor = [UIColor colorWithRed:12.0f/255.0f green:60.0f/255.0f blue:107.0f/255.0f alpha:1.0f];
        
        
        // For right side menu button
        UIButton *plusRowButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        [plusRowButton setFrame:CGRectMake( 2.0f, 2.0f, TABLE_FORM_BUTTON_WIDTH-4, TABLE_FORM_BUTTON_WIDTH-4)];
        [plusRowButton setImage:[UIImage imageNamed:@"plus_normal"] forState:UIControlStateNormal];
        
        plusRowButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        plusRowButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        // [plusRowButton setBackgroundImage:[UIImage imageNamed:@"plus_pressed"] forState:UIControlStateHighlighted];
        [plusRowButton addTarget:self action:@selector(plusRowHandler:) forControlEvents:UIControlEventTouchUpInside];
        [rightContentArea addSubview:plusRowButton];
        
        
        [self addSubview:leftContentArea];
        [self addSubview:rightContentArea];
        
        uiEventSubscribers = [[NSMutableArray alloc] init];
        
    }
    return self;
}


- (id)initWithFrameWithNoRightAction:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        rowCount = 0;
        colCount = 0;
        
        rightActionBar = false;
        
        // Initialization code
        LEFT_AREA_WIDTH = frame.size.width;
        leftContentArea = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, LEFT_AREA_WIDTH, TABLE_FORM_ROW_HEIGHT)];
        leftContentArea.backgroundColor = [UIColor colorWithRed:12.0f/255.0f green:60.0f/255.0f blue:107.0f/255.0f alpha:1.0f];
        
        [self addSubview:leftContentArea];
        
        uiEventSubscribers = [[NSMutableArray alloc] init];

    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void) addColumn:(DotFormElement*) formElement
{
    colCount = colCount + 1;
    
    
    // self.frame.size.width / colCount
    if(rowDelegate==nil)
    {
        DefaultRowDelegate* defDelegate = [[DefaultRowDelegate alloc] init];
        rowDelegate = defDelegate;
    }
    
    [rowDelegate addColumn:formElement.elementId formElement:formElement delegate:nil];
    
    id<DVTableFormColumnDelegate> colDeleg =  [rowDelegate columnDelegateForColumnIndex:(colCount-1)];
    
    CGFloat cellOffset = [colDeleg columnOffsetForColumn:(colCount-1)];
    CGFloat nextCellOffset = [colDeleg columnOffsetForColumn:(colCount)];
    
    // int tWidth = leftContentArea.frame.size.width/colCount;
    UIView* headerColumn = [[UIView alloc] initWithFrame:CGRectMake(cellOffset, 0, nextCellOffset - cellOffset, TABLE_FORM_ROW_HEIGHT)];
    headerColumn.tag = HEADER_COLUMN_TAG_OFFSET + colCount;
    
    [leftContentArea addSubview:headerColumn];
    
    [colDeleg columnHeadingRenderer:self column:(colCount-1) cell:headerColumn];
    
    leftContentArea.contentSize = CGSizeMake(nextCellOffset, leftContentArea.frame.size.height);
    
}


/*
 * This adds a + button on the table header
 */
-(void) addRowButton
{
    
}

/*
 * This adds one row at the bottom of the table without data
 */
-(void) addRow
{
    
    
    
}

/*
 * This adds one row at the bottom of the table with data
 */
-(void) addRowWithData:(NSArray*) rowData
{
    
    
}

-(void) deleteRow:(int) rowIdx
{
    
    
}


-(void) subscribeTableUIEvent:(id<DVTableFormViewDelegate>) tableDelegate
{
    if(tableDelegate!=nil) {
        [uiEventSubscribers addObject:tableDelegate];
    }
}

# pragma mark - button actions here

-(IBAction)plusRowHandler:(id)sender
{
    NSLog(@"Adding a row here");
    rowCount = rowCount + 1;
    
    id<DVTableFormColumnDelegate> colDeleg =  [rowDelegate columnDelegateForColumnIndex:(colCount-1)];
    
    
    CGFloat lastCellOffset = [colDeleg columnOffsetForColumn:(colCount)];


    UIView* rowContent = [[UIView alloc] initWithFrame:CGRectMake(0, rowCount*TABLE_FORM_ROW_HEIGHT, lastCellOffset, TABLE_FORM_ROW_HEIGHT)];
    rowContent.backgroundColor =[UIColor whiteColor];// [UIColor colorWithRed:175.0f/255/0.0f green:175.0f/255/0.0f blue:175.0f/255/0.0f alpha:1.0f];
    rowContent.tag = ROW_CONTENT_TAG_OFFSET + rowCount;
    [leftContentArea addSubview:rowContent];
    
    // need to add row form content
    for(int i=0; i<colCount; i++) {
        CGFloat cellOffset = [colDeleg columnOffsetForColumn:i];
        CGFloat nextCellOffset = [colDeleg columnOffsetForColumn:(i+1)];
        
        UIView* rowCell = [[UIView alloc] initWithFrame:CGRectMake(cellOffset, 0, nextCellOffset - cellOffset, TABLE_FORM_ROW_HEIGHT)];
        
        id<DVTableFormColumnDelegate> colDeleg = [rowDelegate columnDelegateForColumnIndex:i];
        
        [colDeleg columnCellRenderer:self row:rowCount column:i cell:rowCell];
        [rowContent addSubview:rowCell];
    }
    
    // For right side menu button
    UIButton *minusRowButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [minusRowButton setFrame:CGRectMake( 2.0f, rowCount*TABLE_FORM_ROW_HEIGHT + 2.0f, TABLE_FORM_BUTTON_WIDTH-4, TABLE_FORM_BUTTON_WIDTH-4)];
    [minusRowButton setImage:[UIImage imageNamed:@"minus_normal"] forState:UIControlStateNormal];
    minusRowButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    minusRowButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;

    // [minusRowButton setBackgroundImage:[UIImage imageNamed:@"minus_pressed"] forState:UIControlStateHighlighted];
    [minusRowButton addTarget:self action:@selector(minusRowHandler:) forControlEvents:UIControlEventTouchUpInside];
    minusRowButton.tag = ROW_BUTTON_TAG_OFFSET + rowCount;
    [rightContentArea addSubview:minusRowButton];
    
    // (0, 0, LEFT_AREA_WIDTH, TABLE_FORM_ROW_HEIGHT)
    leftContentArea.frame = CGRectMake(0, 0, LEFT_AREA_WIDTH, leftContentArea.frame.size.height + TABLE_FORM_ROW_HEIGHT);
    
    // (LEFT_AREA_WIDTH, 0, TABLE_FORM_BUTTON_WIDTH, TABLE_FORM_ROW_HEIGHT)];
    rightContentArea.frame = CGRectMake(LEFT_AREA_WIDTH, 0, TABLE_FORM_BUTTON_WIDTH, rightContentArea.frame.size.height + TABLE_FORM_ROW_HEIGHT);
    
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height + TABLE_FORM_ROW_HEIGHT);
    
    
    // notifying subscribers for update their own UI frames
    
    for(int i=0; i<[uiEventSubscribers count]; i++) {
        id<DVTableFormViewDelegate> tableDelegate =  (id<DVTableFormViewDelegate>) [uiEventSubscribers objectAtIndex:i];
        if([tableDelegate respondsToSelector:@selector(notifyRowAdded_HeightIncreased:)]) {
            [tableDelegate notifyRowAdded_HeightIncreased:TABLE_FORM_ROW_HEIGHT ];
        }
    }
}

-(IBAction)minusRowHandler:(id)sender
{
    NSLog(@"removing a row here");
    UIButton* minusButton = (UIButton*) sender;
    int rowIdx = minusButton.tag - ROW_BUTTON_TAG_OFFSET;
    
    [[leftContentArea viewWithTag:(ROW_CONTENT_TAG_OFFSET + rowIdx)] removeFromSuperview];
    [minusButton removeFromSuperview];
    
    for(int i=rowIdx+1; i<=rowCount; i++) {
        UIView* rowContentView = [leftContentArea viewWithTag:(ROW_CONTENT_TAG_OFFSET + i)];
        rowContentView.tag = rowContentView.tag - 1;
        rowContentView.frame = CGRectMake(rowContentView.frame.origin.x, rowContentView.frame.origin.y - TABLE_FORM_ROW_HEIGHT, rowContentView.frame.size.width, rowContentView.frame.size.height);
        
        // notify rowDelegate about update
        [rowDelegate updateRowNumber:rowContentView oldNumber:(rowContentView.tag + 1) action:-1];
        
        UIView* buttonView = [rightContentArea viewWithTag:(ROW_BUTTON_TAG_OFFSET + i)];
        buttonView.tag = buttonView.tag - 1;
        buttonView.frame = CGRectMake(buttonView.frame.origin.x, buttonView.frame.origin.y - TABLE_FORM_ROW_HEIGHT, buttonView.frame.size.width, buttonView.frame.size.height);
        
    }
    rowCount = rowCount - 1;
    
    
    // (0, 0, LEFT_AREA_WIDTH, TABLE_FORM_ROW_HEIGHT)
    leftContentArea.frame = CGRectMake(0, 0, LEFT_AREA_WIDTH, leftContentArea.frame.size.height - TABLE_FORM_ROW_HEIGHT);
    
    // (LEFT_AREA_WIDTH, 0, TABLE_FORM_BUTTON_WIDTH, TABLE_FORM_ROW_HEIGHT)];
    rightContentArea.frame = CGRectMake(LEFT_AREA_WIDTH, 0, TABLE_FORM_BUTTON_WIDTH, rightContentArea.frame.size.height - TABLE_FORM_ROW_HEIGHT);
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height - TABLE_FORM_ROW_HEIGHT);

    // notifying subscribers for update their own UI frames

    
    for(int i=0; i<[uiEventSubscribers count]; i++) {
        id<DVTableFormViewDelegate> tableDelegate =  (id<DVTableFormViewDelegate>) [uiEventSubscribers objectAtIndex:i];
        if([tableDelegate respondsToSelector:@selector(notifyRowDeleted_HeightDecreased:)]) {
            [tableDelegate notifyRowDeleted_HeightDecreased:TABLE_FORM_ROW_HEIGHT ];
        }
    }
}



-(void)insertRowAfterRow:(int)rowId withData:(NSArray*)searchRecord header:(NSArray*)headerData
{
    // we need to push all rows after this row
    [self pushDownRowsAfterRow: rowId];
    
    rowCount = rowCount + 1;
    NSLog(@"number of rows %d", rowCount);
    NSLog(@"Adding a row after rowId = %d", rowId);
    
    id<DVTableFormColumnDelegate> colDeleg =  [rowDelegate columnDelegateForColumnIndex:(colCount-1)];
    CGFloat lastCellOffset = [colDeleg columnOffsetForColumn:(colCount)];
    
    
    int newRowId = rowId + 1;

    UIView* rowContent = [[UIView alloc] initWithFrame:CGRectMake(0, newRowId*TABLE_FORM_ROW_HEIGHT,  lastCellOffset, TABLE_FORM_ROW_HEIGHT)];
    rowContent.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:175.0f/255/0.0f green:175.0f/255/0.0f blue:175.0f/255/0.0f alpha:1.0f];
    rowContent.tag = ROW_CONTENT_TAG_OFFSET + newRowId;
    [leftContentArea addSubview:rowContent];
    
    // need to add row form content
    for(int i=0; i<colCount; i++) {
        CGFloat cellOffset = [colDeleg columnOffsetForColumn:i];
        CGFloat nextCellOffset = [colDeleg columnOffsetForColumn:(i+1)];
        
        UIView* rowCell = [[UIView alloc] initWithFrame:CGRectMake(cellOffset, 0, nextCellOffset - cellOffset, TABLE_FORM_ROW_HEIGHT)];
        
        id<DVTableFormColumnDelegate> colDeleg = [rowDelegate columnDelegateForColumnIndex:i];
        
        [colDeleg columnCellRenderer:self row:newRowId column:i cell:rowCell];
        [rowContent addSubview:rowCell];
    }
    
    // For right side menu button
    if(rightActionBar) {
        UIButton *minusRowButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        [minusRowButton setFrame:CGRectMake( 2.0f, newRowId*TABLE_FORM_ROW_HEIGHT + 2.0f, TABLE_FORM_BUTTON_WIDTH-4, TABLE_FORM_BUTTON_WIDTH-4)];
        [minusRowButton setBackgroundImage:[UIImage imageNamed:@"minus_normal"] forState:UIControlStateNormal];
        [minusRowButton setBackgroundImage:[UIImage imageNamed:@"minus_pressed"] forState:UIControlStateHighlighted];
        [minusRowButton addTarget:self action:@selector(minusRowHandler:) forControlEvents:UIControlEventTouchUpInside];
        minusRowButton.tag = ROW_BUTTON_TAG_OFFSET + newRowId;
        [rightContentArea addSubview:minusRowButton];
    }

}


-(void) pushDownRowsAfterRow:(int) rowId
{
    for(int i=rowCount; i>rowId; i--) {
        NSLog(@"pushing a row down %d", i );
        UIView* rowContent = [leftContentArea viewWithTag:ROW_CONTENT_TAG_OFFSET + i ];
        rowContent.frame = CGRectMake(rowContent.frame.origin.x, rowContent.frame.origin.y + TABLE_FORM_ROW_HEIGHT, rowContent.frame.size.width, rowContent.frame.size.height);
        rowContent.tag = rowContent.tag + 1;
        
        // notify rowDelegate about update
        [rowDelegate updateRowNumber:rowContent oldNumber:(rowContent.tag - 1) action:1];
        
        if(rightActionBar) {
            UIButton *minusRowButton  = (UIButton*)[rightContentArea viewWithTag: ROW_BUTTON_TAG_OFFSET + i ];
            minusRowButton.frame = CGRectMake(minusRowButton.frame.origin.x, minusRowButton.frame.origin.y + TABLE_FORM_ROW_HEIGHT, minusRowButton.frame.size.width, minusRowButton.frame.size.height);
            minusRowButton.tag = minusRowButton.tag +1;
        }
        
    }
    
    leftContentArea.frame = CGRectMake(0, 0, LEFT_AREA_WIDTH, leftContentArea.frame.size.height + TABLE_FORM_ROW_HEIGHT);
    
    if(rightActionBar) {
        rightContentArea.frame = CGRectMake(LEFT_AREA_WIDTH, 0, TABLE_FORM_BUTTON_WIDTH, rightContentArea.frame.size.height + TABLE_FORM_ROW_HEIGHT);
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height + TABLE_FORM_ROW_HEIGHT);
    
    // notifying subscribers for update their own UI frames
    for(int i=0; i<[uiEventSubscribers count]; i++) {
        id<DVTableFormViewDelegate> tableDelegate =  (id<DVTableFormViewDelegate>) [uiEventSubscribers objectAtIndex:i];
        if([tableDelegate respondsToSelector:@selector(notifyRowAdded_HeightIncreased:)]) {
            [tableDelegate notifyRowAdded_HeightIncreased:TABLE_FORM_ROW_HEIGHT ];
        }
    }
    
}

-(void) updateRowAfterRow:(int)rowId withData:(NSArray*)searchRecord header:(NSArray*)headerData
{
    
    
    
}

-(UIView*) getRowCellWithRowId:(int) rowIdx colId:(int) colIdx
{
    UIView* rowContent = [leftContentArea viewWithTag:ROW_CONTENT_TAG_OFFSET + rowIdx ];
    return [[rowContent subviews] objectAtIndex:colIdx];
}


-(UIView*) getRowWithRowId:(int) rowIdx
{
    return [leftContentArea viewWithTag:ROW_CONTENT_TAG_OFFSET + rowIdx ];
}

-(int) getRowCount
{
    return rowCount;
}


#pragma  mark - minus button customization
-(UIButton*) getActionButtonWithRowId:(int) rowIdx
{
    return [rightContentArea viewWithTag:ROW_BUTTON_TAG_OFFSET + rowIdx];
}


-(long) rowIndexOfActionButton:(UIButton*) actionButton
{
    return actionButton.tag - ROW_BUTTON_TAG_OFFSET;
}

-(void) updateActionButtonTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents forRowId:(int)rowIdx
{
    // minus button is the default button in this form as right row action.
    UIButton* minusButton = [rightContentArea viewWithTag:ROW_BUTTON_TAG_OFFSET + rowIdx];
    
    // remove any previous target if exists
    [minusButton removeTarget:self action:@selector(minusRowHandler:) forControlEvents:controlEvents];
    
    [minusButton addTarget:target action:action forControlEvents:controlEvents];
    
}




@end

