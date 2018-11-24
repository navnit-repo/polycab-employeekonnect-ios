//
//  RecentRequestController.m
//  QCMSProject
//
//  Created by Ashish Tiwari on 07/10/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "RecentRequestController.h"
#import "DVAppDelegate.h"
#import "ClientVariable.h"
#import "ClientUserLogin.h"
#import "RecentRequestStorage.h"
#import "DocumentScreenController.h"


@interface RecentRequestController ()

@end

@implementation RecentRequestController

@synthesize screenId;
@synthesize formId;
@synthesize parentForm;
@synthesize reportResponse;
@synthesize maxDocIdList;
@synthesize forwardedDataDisplay;
@synthesize forwardedDataPost;
@synthesize dotReport;
@synthesize recordTableData;
@synthesize cellComponent;



-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
 {
     self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
     if (self) {
 // Custom initialization

     }
     return self;
 }


-(void)initwithData : (int)id : (NSString*)inFormId :(MenuVC*)parentScreen;
{
    self.screenId = id;
    self.formId = inFormId;
    self.parentForm = parentScreen;
    self.reportResponse = nil;
    self.forwardedDataDisplay = nil;
    self.forwardedDataPost = nil;
    
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self drawTitle];
    [self loadData];
    [self screenDisplay];
    
    // Do any additional setup after loading the view from its nib.
}

-(void) drawTitle
{
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    // self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    UILabel*  titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
    titleLabel.text = @"Recent Request";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.navigationItem setTitleView: titleLabel];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadData
{
     self.reportResponse = [[ReportPostResponse alloc] init];
	 [reportResponse setViewReportId:formId];
	ClientVariable* clientVariable = [ClientVariable getInstance :[DVAppDelegate currentModuleContext]];
    self.dotReport = (DotReport*)[clientVariable.DOT_REPORT_MAP objectForKey:formId];
    
    NSMutableArray* recentColumnsKey = [DotReportDraw sortRptComponents : dotReport.reportElements : XmwcsConst_REPORT_PLACE_TABLE];
    
    RecentRequestStorage* storage = [RecentRequestStorage getInstance];
    NSMutableDictionary* itemMap = [storage getRecentDocumentsAsMap : clientVariable.CLIENT_USER_LOGIN.userName : clientVariable.CLIENT_USER_LOGIN.moduleId];
    
	NSMutableArray* recList = [self getRecentReqTableData : itemMap  : recentColumnsKey ];
    
	reportResponse.tableData = [recList objectAtIndex:0];
	self.maxDocIdList = [recList objectAtIndex:1];
    
}

-(void) screenDisplay
{
    
    if(self.forwardedDataDisplay == nil) {
        self.forwardedDataDisplay = [[NSMutableDictionary alloc] init];
    }
    if(self.forwardedDataPost == nil) {
        self.forwardedDataPost = [[NSMutableDictionary alloc] init];
    }

    [self  makeReportScreen];
    
    
}

-(NSMutableArray*) getRecentReqTableData : (NSMutableDictionary*)map : (NSMutableArray*)displayList
{
    NSMutableArray* sendBack = [[NSMutableArray alloc] init];
    NSMutableArray* maxDocIdList = [[NSMutableArray alloc] init];
   	NSMutableArray* returnArrayList =[[NSMutableArray alloc] init];
    NSArray* keys = [map allKeys];
	for(int keyIdx=0; keyIdx<[keys count]; keyIdx++)
    {
        NSMutableDictionary* childMap = [map objectForKey:[keys objectAtIndex:keyIdx]];
        [maxDocIdList addObject:[childMap objectForKey:XmwcsConst_RECENT_REQ_MAX_DOC_ID]];
		NSMutableArray* childList = [[NSMutableArray alloc]init];
		for(int i=0; i<[displayList count]; i++)
        {
            [childList addObject:[childMap objectForKey:[displayList objectAtIndex:i]]];
		}
		[returnArrayList addObject:childList];
    }
    [sendBack addObject:returnArrayList];
	[sendBack addObject:maxDocIdList];
	return sendBack;
}


-(void) makeReportScreen
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    
    //this.baseForm = baseForm;
    UIView *headerContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    UIView *tableContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 50)];
    UIView *subHeaderContainer = [[UIView alloc] init];
    UIView *footerContainer = [[UIView alloc] init];
    NSArray *placeVector = [XmwUtils breakStringTokenAsVector : dotReport.reportPlaces : @"$"];
    for (int cntComponentPlace = 0; cntComponentPlace < [placeVector count]; cntComponentPlace++)
    {
        NSString *componentPlace = (NSString*) [placeVector objectAtIndex:cntComponentPlace];
        
        NSMutableArray *sortedElementId =[DotReportDraw sortRptComponents : dotReport.reportElements : componentPlace];
        if([componentPlace isEqualToString : XmwcsConst_REPORT_PLACE_HEADER])
        {
            [self drawHeader : sortedElementId : headerContainer];
            [self.view addSubview : headerContainer];
        }
        else if([componentPlace isEqualToString : XmwcsConst_REPORT_PLACE_TABLE])
        {
            [self drawTable : sortedElementId : tableContainer];
            // [tableContainer setBackgroundColor:[UIColor redColor]];
            [self.view addSubview : tableContainer];
        }
    }
    
}
-(void) drawHeader : (NSMutableArray *) sortedElementIds :(UIView *) headerContainer
{
    NSMutableDictionary * headerData = self.reportResponse.headerData;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    NSMutableDictionary* dotReportElements = [dotReport reportElements];
    
    // int lable_headertext_height;
    for(int cntHeaderComp = 0;cntHeaderComp < [sortedElementIds count];cntHeaderComp++)
    {
        UIView *elementContainer = [[UIView alloc]init];
        NSString *keyOfComp =  (NSString *) [sortedElementIds objectAtIndex :cntHeaderComp];
        DotReportElement *dotReportElement = (DotReportElement *) [dotReportElements objectForKey:keyOfComp];
        lable_text_height = [self heightForText:dotReportElement.displayText];
        UITextView *lblHeaderTitle = [[UITextView alloc] initWithFrame:CGRectMake(0, y_inc, screenWidth/2, lable_text_height)];
        lblHeaderTitle.text = dotReportElement.displayText;
        [elementContainer addSubview:lblHeaderTitle];
        NSString *headerValue = @"";
        if((dotReportElement.valueDependOn !=nil) && [forwardedDataDisplay objectForKey:dotReportElement.valueDependOn]!=nil)
        {
            headerValue = (NSString*) [forwardedDataDisplay objectForKey:dotReportElement.valueDependOn];
        }
        else
        {
            headerValue =  (NSString*) [headerData objectForKey:dotReportElement.elementId];
        }
        if(headerValue == nil){
            headerValue = @"";
        }
        if([headerValue isEqualToString:@""] && ![dotReportElement.defaultVal isEqualToString:@""])
        {
            headerValue = dotReportElement.defaultVal;
        }
       
        UITextView *lblHeaderValue = [[UITextView alloc] initWithFrame:CGRectMake(screenWidth/2, y_inc, screenWidth/2, lable_text_height)];
        
        lblHeaderValue.scrollEnabled = YES;
        lblHeaderValue.userInteractionEnabled = YES;
        lblHeaderValue.alwaysBounceVertical = YES;
        
         lblHeaderValue.text  = headerValue;
        
        y_inc = y_inc + lable_text_height-5;
        
        [elementContainer addSubview:lblHeaderValue];
        
        
        //If this field value is use in Next Screen
        if([dotReportElement isUseForwardBool])
        {
            [forwardedDataDisplay setObject:headerValue forKey:dotReportElement.elementId];
            [forwardedDataPost setObject:headerValue forKey:dotReportElement.elementId];
        }
        [headerContainer addSubview:elementContainer];
        
    }
}


-(void) drawTable : (NSMutableArray *) sortedElementIds : (UIView *) tableContainer
{
    NSMutableArray *records = self.reportResponse.tableData;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height - 30;
    
    if(records == nil)// ||  ([records count] == nil))//here vikas sir code if (records.isEmpty())
    {
        UILabel *lblNoRecord = [[MXLabel alloc]init];
        lblNoRecord.text = @"record not found";
        
        [tableContainer addSubview:lblNoRecord];
        
        return ;
    }
    NSMutableArray *returnMap = [self drawTableHeader : sortedElementIds : tableContainer];
    
    // use to be part of DotReportListCellRenderer
    self.cellComponent = returnMap;
    self.recordTableData = self.reportResponse.tableData;
    
    
    // we need to implement recentlistrenderer and attach it with tablelist (tableview)
    
    
   // dotReportListRenderer = [[DotReportListCellRenderer alloc] init];
   // dotReportListRenderer.recordTableData = reportPostResponse.tableData;
   // dotReportListRenderer.cellComponent = returnMap;//elementType
    // dotReportListRenderer.dotReortdrawProp = self;

    // screenHeight = [records count]*18;//10.5;//*30;
    tableList = [[UITableView alloc]initWithFrame:CGRectMake(0, (y_inc+30), screenWidth, screenHeight) style:UITableViewStylePlain];
    
    //[tableList setBackgroundColor:[UIColor greenColor]];
    // [tableList setDelegate:reportVC];
    [tableList setDelegate:self];
    [tableList setDataSource:self];
    [self.view addSubview:tableContainer];//added
    [self.view addSubview:tableList];
    
    
}


-(NSMutableArray *) drawTableHeader : (NSMutableArray *) sortedElementIds : (UIView *) tableContainer
{
    UIView *tableHeaderContainer = [[UIView alloc]init] ;//]WithFrame:CGRectMake(0, 0, 320, 50)];
    NSMutableDictionary *columnLengthMap = [[NSMutableDictionary alloc]init];
    
    NSMutableArray *elementId = [[NSMutableArray alloc]init];
    NSMutableArray *headerElementId = [[NSMutableArray alloc]init];
    
    NSMutableArray *elementType = [[NSMutableArray alloc]init];
    NSMutableArray *elementDisplay = [[NSMutableArray alloc]init];
    
    NSMutableDictionary* dotReportElements =  dotReport.reportElements;
    
    for(int cntTableColumn = 0; cntTableColumn < [sortedElementIds count];cntTableColumn++)
    {
        NSString *keyOfComp = (NSString*) [sortedElementIds objectAtIndex:cntTableColumn];
        DotReportElement *dotReportElement = (DotReportElement *) [dotReportElements objectForKey:keyOfComp];
        
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
                  || ([dotReportElement.componentType isEqualToString:XmwcsConst_DRE_COLUMN_TYPE_EXPAND])
                  || ([dotReportElement.componentType isEqualToString:XmwcsConst_DRE_COLUMN_TYPE_COLOR])
                  || ([dotReportElement.componentType isEqualToString:XmwcsConst_DRE_COLUMN_TYPE_COLOR_CLICK])))
            
        {
            [elementDisplay addObject:dotReportElement.displayText];
            if(dotReportElement.length != nil)
            {
                [columnLengthMap setObject:dotReportElement.length forKey:dotReportElement.elementId];
            }
            [headerElementId addObject:dotReportElement.elementId];
        }
        [elementType addObject:dotReportElement.componentType];
        [elementId addObject:dotReportElement.elementId];
        
        
    }
    y_inc = 0;
    int xCord,yCord,width,hight;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSInteger elementDisplayNo = [elementDisplay count];
    xCord =0;
    yCord = y_inc;//1;
    width =screenWidth/elementDisplayNo; //98;
    hight = 30;
    
    [tableHeaderContainer setBackgroundColor:[UIColor blackColor]];
    for (int cntTableColumn = 0; cntTableColumn < [elementDisplay count]; cntTableColumn++)
    {
        UIView *header = [[UIView alloc]initWithFrame:CGRectMake(xCord, yCord,width , hight)];
        UILabel *labelHeader = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, hight)];
        
        labelHeader.text = [elementDisplay objectAtIndex:cntTableColumn];
        labelHeader.backgroundColor = [UIColor redColor];
        labelHeader.textColor = [UIColor greenColor];
        [header addSubview:labelHeader];
        //[header setBackgroundColor:[UIColor yellowColor]];
        [tableHeaderContainer addSubview:header];
        xCord = xCord+width;
        
    }
    
    //[tableHeaderContainer setBackgroundColor:[UIColor redColor]];
    [tableContainer addSubview:tableHeaderContainer];
    NSMutableArray *returnMap = [[NSMutableArray alloc]init];
    [returnMap addObject:elementType];
    [returnMap addObject:columnLengthMap];
    [returnMap addObject:elementId];
    [returnMap addObject:headerElementId];
    return returnMap;
    
}

- (CGFloat)heightForText:(NSString *)bodyText
{
    UIFont *cellFont = [UIFont systemFontOfSize:17];
    CGSize constraintSize = CGSizeMake(300, MAXFLOAT);
    CGSize labelSize = [bodyText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    CGFloat height = labelSize.height + 10;
    return height;
}




// for row tabular data

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
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:simpleTableIdentifier];
    }
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
    NSInteger height = 30;
    
    for(int i=0; i<[elementId count]; i++)
    {
        if([elementId objectAtIndex:i] !=nil && [columnLengthMap objectForKey:[elementId objectAtIndex:i]] !=nil)
        {
            NSString *check = (NSString *)[elementId objectAtIndex:i];
            NSString *labelWidth =  (NSString *)[columnLengthMap objectForKey: check];
            NSInteger labelWidthIntValue = [labelWidth intValue];
            width = screenWidth*labelWidthIntValue/100;
        }
        // A list item label, docked to the center, the text is set in updateItem.
        if([[elementType objectAtIndex:i] isEqualToString:XmwcsConst_DE_COMPONENT_LABEL])
        {
            firstCol = [[UIView alloc] initWithFrame:CGRectMake(x, 0, width, height)];
            mItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
            mItemLabel.text = [NSString stringWithFormat:@"%d", [row objectAtIndex:i]];//[row objectAtIndex:i];
            
            NSString* test = mItemLabel.text;
            if(rowColor.length>0)
            {
                
                mItemLabel.backgroundColor = [self colorWithHexString:rowColor];
                
                
            }
            x = x + width;
            
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
            firstCol = [[UIView alloc] initWithFrame:CGRectMake(x, 0, width, height)];
            mItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
            mItemLabel.text = [row objectAtIndex:i];
            if(rowColor.length>0){
                
                mItemLabel.backgroundColor = [self colorWithHexString:rowColor];
                
            }
            x = x + width;
        } else if([[elementType objectAtIndex:i] isEqualToString:XmwcsConst_DRE_COLUMN_TYPE_EXPAND]) {
            m_expandedValue = [row objectAtIndex:i];
        }
        
        [firstCol addSubview:mItemLabel];
        [cell  addSubview: firstCol];
        
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
    return 30;
    
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSLog(@"row selected %d", indexPath.row);
    NSLog(@"RecentRequest Table Row Selected Control");
    
    NSMutableArray* records = reportResponse.tableData;
	int rowIdx = indexPath.row;
    NSMutableArray* rowData = [records objectAtIndex:rowIdx];
	[self handleRowSelected : rowIdx : rowData];
  
    
  
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}
-(void)handleRowSelected : (int) rowIdx : (NSMutableArray*) rowData
{
    NSLog(@"RecentRequestController handleRowSelected");
    NSString* expandProperty;
	
    DocumentScreenController* documentScreenController = [[DocumentScreenController alloc] initWithNibName:@"DocumentScreenController" bundle:nil];
    [documentScreenController  initwithData : XmwcsConst_EssRecentDocumentScreen : [[maxDocIdList objectAtIndex:rowIdx] intValue] :self];
    
    [[self navigationController] pushViewController:documentScreenController  animated:YES];

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




@end
