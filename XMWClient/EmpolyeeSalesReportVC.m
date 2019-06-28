//
//  EmpolyeeSalesReportVC.m
//  XMWClient
//
//  Created by dotvikios on 21/02/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "EmpolyeeSalesReportVC.h"
#import "DVAppDelegate.h"
#import "ClientVariable.h"
#import "XmwReportService.h"
#import "LayoutClass.h"
@implementation EmpolyeeSalesReportVC
{
    
    UILabel *label;
    NSMutableArray *sortDataArrayAddName;
}

- (void)viewDidLoad {
    sortDataArrayAddName = [[NSMutableArray alloc]init];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if(section==1) {
        UIView* lView = nil;
        UILabel* label = nil;
        
        NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
        
        
        lView = [view viewWithTag:0];
        //  lView.backgroundColor = [UIColor colorWithRed:128.0/255 green:128.0/255 blue:128.0/255 alpha:1.0];
        [LayoutClass setLayoutForIPhone6:lView];
        
        label = [lView viewWithTag:101];
        [LayoutClass labelLayout:label forFontWeight:UIFontWeightSemibold];
        label.text = [self zeroColumnHeading];
        
        
        
        
        
        lView = [view viewWithTag:1];
        [LayoutClass setLayoutForIPhone6:lView];
        label = [lView viewWithTag:101];
        [LayoutClass labelLayout:label forFontWeight:UIFontWeightSemibold];
        label.text = firstColumnText;
        label.attributedText = [[NSAttributedString alloc] initWithString:firstColumnText attributes:underlineAttribute];
        
        lView = [view viewWithTag:2];
        [LayoutClass setLayoutForIPhone6:lView];
        label = [lView viewWithTag:101];
        [LayoutClass labelLayout:label forFontWeight:UIFontWeightSemibold];
        label.text = secondColumnText;
        label.attributedText = [[NSAttributedString alloc] initWithString:secondColumnText attributes:underlineAttribute];
        
        lView = [view viewWithTag:3];
        [LayoutClass setLayoutForIPhone6:lView];
        label = [lView viewWithTag:101];
        [LayoutClass labelLayout:label forFontWeight:UIFontWeightSemibold];
        label.text = thirdColumnText;
        label.attributedText = [[NSAttributedString alloc] initWithString:thirdColumnText attributes:underlineAttribute];
        
        
        // for total labels
        
        UIView* totalRow = [view viewWithTag:20];
        [LayoutClass setLayoutForIPhone6:totalRow];
        
        MXButton *totalRowButton = [[MXButton alloc]initWithFrame:CGRectMake(0, 0, totalRow.frame.size.width, totalRow.frame.size.height)];
        totalRowButton.backgroundColor = [UIColor clearColor];
        [totalRowButton addTarget:self action:@selector(allButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
        [totalRow addSubview:totalRowButton];
        
        UILabel* tZero =  (UILabel*)[totalRow viewWithTag:200];
        [LayoutClass labelLayout:tZero forFontWeight:UIFontWeightSemibold];
        tZero.text = @"All";
        tZero.textAlignment = NSTextAlignmentCenter;
        
        UILabel* tFirst =  (UILabel*)[totalRow viewWithTag:201];
        [LayoutClass labelLayout:tFirst forFontWeight:UIFontWeightSemibold];
        NSString *tFirstText = [self totalHeaderValue:firstResponse];
        if ([ tFirstText isEqualToString:@"0"]) {
            tFirstText = @"0.0";
        }
        tFirst.text = tFirstText;
        tFirst.textAlignment = NSTextAlignmentCenter;
        
        UILabel* tSecond =  (UILabel*)[totalRow viewWithTag:202];
        [LayoutClass labelLayout:tSecond forFontWeight:UIFontWeightSemibold];
        NSString *tSecondText = [self totalHeaderValue:secondResponse];
        if ([ tSecondText isEqualToString:@"0"]) {
            tSecondText = @"0.0";
        }
        tSecond.text = tSecondText;
        tSecond.textAlignment = NSTextAlignmentCenter;
        
        UILabel* tThird =  (UILabel*)[totalRow viewWithTag:203];
        [LayoutClass labelLayout:tThird forFontWeight:UIFontWeightSemibold];
        NSString *tThirdText = [self totalHeaderValue:thirdResponse];
        if ([ tThirdText isEqualToString:@"0"]) {
            tThirdText = @"0.0";
        }
        tThird.text = tThirdText;
        tThird.textAlignment = NSTextAlignmentCenter;
        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0) {
        return 0;
    } else if(section==1) {
        if(dataSet.count>0) {
            self.mainTable.backgroundView = nil;
            return [dataSet.allKeys count];
        }
        else
        {
            UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.mainTable.bounds.size.width, self.mainTable.bounds.size.height)];
            noDataLabel.tag = 700;
            noDataLabel.text             = @"No records found";
            noDataLabel.textColor        = [UIColor blackColor];
            noDataLabel.textAlignment    = NSTextAlignmentCenter;
            self.mainTable.backgroundView  = noDataLabel;
            self.mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
            return [dataSet.allKeys count];
        }
    } else {
        return 0;
    }
}
-(IBAction)allButtonHandler:(id)sender
{
    NSLog(@"All button click");
    if ( [self clickable:0]==YES) {
        [self allHandleDrilldown:0];
    }
    else
    {
//        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.mainTable.bounds.size.width, self.mainTable.bounds.size.height)];
//        noDataLabel.text             = @"No records found";
//        noDataLabel.textColor        = [UIColor blackColor];
//        noDataLabel.textAlignment    = NSTextAlignmentCenter;
//        self.mainTable.backgroundView  = noDataLabel;
//        self.mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
}
-(DotFormPost*)allDDColumnDotFormPost:(DotFormPost*) dotFormPost rowIndex:(NSInteger) rowIndex columnRowData:(NSArray*) colRowData
{
    DotFormPost* ddFormPost = [[DotFormPost alloc]init];
    [ddFormPost setAdapterId:self.dotReport.ddAdapterId];
    [ddFormPost setAdapterType:self.dotReport.ddAdapterType];
    [ddFormPost setModuleId:[DVAppDelegate currentModuleContext]];
    [ddFormPost setDocId: self.dotReport.ddAdapterType];
    
    NSArray* keysMap = [self.forwardedDataPost allKeys];
    
    for (int cntIndex = 0; cntIndex<[keysMap count]; cntIndex++)
    {
        NSString* keyOfMap = [keysMap objectAtIndex:cntIndex];
        [ddFormPost.postData setObject:[self.forwardedDataPost objectForKey:keyOfMap] forKey:keyOfMap];
    }
    
    // for these reports dotFormPost must have FROM_DATE and TO_DATE
    [ddFormPost.postData setObject:[dotFormPost.postData objectForKey:@"FROM_DATE"] forKey:@"FROM_DATE"];
    [ddFormPost.postData setObject:[dotFormPost.postData objectForKey:@"TO_DATE"] forKey:@"TO_DATE"];
    
    
    
    // Now we need to set row specific forward data
    
    NSMutableArray *sortedElementIds = [DotReportDraw sortRptComponents:self.dotReport.reportElements :XmwcsConst_REPORT_PLACE_TABLE];
    
    for(int i =0; i<[sortedElementIds count];i++)
    {
        NSString *keyOfComp = (NSString *)[sortedElementIds objectAtIndex:i];
        DotReportElement *dotReportElement = (DotReportElement *)[self.dotReport.reportElements objectForKey:keyOfComp];
        if([dotReportElement isUseForward])
        {
            [self.forwardedDataDisplay setObject:[colRowData objectAtIndex:i] forKey:dotReportElement.elementId];
            [self.forwardedDataPost setObject:[colRowData objectAtIndex:i] forKey:dotReportElement.elementId];
            [ddFormPost.postData setObject:[colRowData objectAtIndex:i] forKey:dotReportElement.elementId];
        }
        
        NSRange tempRange = [self.dotReport.ddNetworkFieldOfTable rangeOfString:keyOfComp];//java use of indexOf
        
        if(tempRange.length > 0)//java use of indexOf
        {
            [ddFormPost.postData setObject:@"All" forKey:dotReportElement.elementId];
            [self.forwardedDataDisplay setObject:@"All" forKey:dotReportElement.elementId];
            [self.forwardedDataPost setObject:@"All" forKey:dotReportElement.elementId];
        }
        
    }
    
    return ddFormPost;
}
-(void) allHandleDrilldown:(NSInteger) rowIndex
{
    if (self.forwardedDataDisplay == nil)
        self.forwardedDataDisplay   = [[NSMutableDictionary alloc] init];
    
    if (self.forwardedDataPost == nil)
        self.forwardedDataPost      = [[NSMutableDictionary alloc] init];
    
    
    // need to create three dotform post objects for each columns
    // which will be passed to next report
    // NSString* dataSetKey = [[dataSet allKeys] objectAtIndex:rowIndex];
    NSString* dataSetKey = [sortedDataSetKeys objectAtIndex:rowIndex];
    XmwCompareTuple* dataTuple = [dataSet objectForKey:dataSetKey];
    
    
    EmpolyeeSalesReportVC* ddCustomCompareReport = [[EmpolyeeSalesReportVC alloc] initWithNibName:@"CustomCompareReportVC" bundle:nil];
    
    ddCustomCompareReport.dotForm = self.dotForm;
    
    NSArray* rawData = [self pickGoodRawData:dataTuple.firstRawData option:dataTuple.secondRawData option:dataTuple.thirdRawData];
    ddCustomCompareReport.firstFormPost = [self allDDColumnDotFormPost:self.firstFormPost rowIndex:rowIndex columnRowData:rawData];
    
    
    rawData = [self pickGoodRawData:dataTuple.secondRawData option:dataTuple.firstRawData option:dataTuple.thirdRawData];
    ddCustomCompareReport.secondFormPost = [self allDDColumnDotFormPost:self.secondFormPost rowIndex:rowIndex columnRowData:rawData];
    
    rawData = [self pickGoodRawData:dataTuple.thirdRawData option:dataTuple.firstRawData option:dataTuple.secondRawData];
    ddCustomCompareReport.thirdFormPost = [self allDDColumnDotFormPost:self.thirdFormPost rowIndex:rowIndex columnRowData:rawData];
    
    ddCustomCompareReport.forwardedDataDisplay = self.forwardedDataDisplay;
    ddCustomCompareReport.forwardedDataPost = self.forwardedDataPost;
    
    [self.navigationController pushViewController:ddCustomCompareReport animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f*deviceHeightRation;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0 ) {
        return 0.0f;
    } else if(section==1) {
        return 100.0f*deviceHeightRation;
    }
    return 0.0f;
}

-(void) drawTitle:(NSString *)headerStr
{
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    self.navigationController.navigationBar.translucent = NO;
    
    
    UIImageView *polycabLogo = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"polycab_logo"]];
    self.navigationItem.titleView.contentMode = UIViewContentModeCenter;
    self.navigationItem.titleView = polycabLogo;
    
    
    [self headerView:headerStr];
    
    
}
-(void)headerView:(NSString*)headername{
    NSLog(@"Header Name : %@",headername);
    
    label = [[UILabel alloc] initWithFrame: CGRectMake(0, 10, self.view.bounds.size.width, 40)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor: [UIColor blackColor]];
    [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [label setText: [headername uppercaseString]];
    //[label setText: headername];
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    [label setNumberOfLines: 0];
    [label setCenter: CGPointMake(self.view.center.x, label.center.y)];
    [self.view addSubview:label];
}
- (void)handleDrilldown:(NSInteger)rowIndex
{
    if (self.forwardedDataDisplay == nil)
        self.forwardedDataDisplay   = [[NSMutableDictionary alloc] init];
    
    if (self.forwardedDataPost == nil)
        self.forwardedDataPost      = [[NSMutableDictionary alloc] init];
    
    
    // need to create three dotform post objects for each columns
    // which will be passed to next report
    // NSString* dataSetKey = [[dataSet allKeys] objectAtIndex:rowIndex];
    NSString* dataSetKey = [sortedDataSetKeys objectAtIndex:rowIndex];
    XmwCompareTuple* dataTuple = [dataSet objectForKey:dataSetKey];
    
    
    EmpolyeeSalesReportVC* ddCustomCompareReport = [[EmpolyeeSalesReportVC alloc] initWithNibName:@"CustomCompareReportVC" bundle:nil];
    
    ddCustomCompareReport.dotForm = self.dotForm;
    
    NSArray* rawData = [self pickGoodRawData:dataTuple.firstRawData option:dataTuple.secondRawData option:dataTuple.thirdRawData];
    ddCustomCompareReport.firstFormPost = [self ddColumnDotFormPost:self.firstFormPost rowIndex:rowIndex columnRowData:rawData];
    
    
    rawData = [self pickGoodRawData:dataTuple.secondRawData option:dataTuple.firstRawData option:dataTuple.thirdRawData];
    ddCustomCompareReport.secondFormPost = [self ddColumnDotFormPost:self.secondFormPost rowIndex:rowIndex columnRowData:rawData];
    
    rawData = [self pickGoodRawData:dataTuple.thirdRawData option:dataTuple.firstRawData option:dataTuple.secondRawData];
    ddCustomCompareReport.thirdFormPost = [self ddColumnDotFormPost:self.thirdFormPost rowIndex:rowIndex columnRowData:rawData];
    
    ddCustomCompareReport.forwardedDataDisplay = self.forwardedDataDisplay;
    ddCustomCompareReport.forwardedDataPost = self.forwardedDataPost;
    
    [self.navigationController pushViewController:ddCustomCompareReport animated:YES];
}

-(void) addFirstSetData:(ReportPostResponse*) reportData into:(NSMutableDictionary*) inDataSet
{
    
    // we need to reset data for first value of all tuple in the inDataSet
    
    for(NSString* key in inDataSet.allKeys) {
        XmwCompareTuple* tupleObject = (XmwCompareTuple*)[inDataSet objectForKey:key];
        if(tupleObject!=nil) {
            tupleObject.firstValue = @"0.0";
            tupleObject.firstRawData = nil;
        }
    }
    
    NSArray* rowWiseTableData = reportData.tableData;
   
    for(NSArray* rowData in rowWiseTableData) {
        NSString* fieldName = [rowData objectAtIndex:0];
        XmwCompareTuple* tupleObject = (XmwCompareTuple*)[inDataSet objectForKey:fieldName];
        if(tupleObject==nil) {
            tupleObject = [[XmwCompareTuple alloc] init];
            tupleObject.firstValue = @"0.0";
            tupleObject.secondValue = @"0.0";
            tupleObject.thirdValue = @"0.0";
            tupleObject.firstRawData = nil;
            tupleObject.secondRawData = nil;
            tupleObject.thirdRawData = nil;
            [dataSet setObject:tupleObject forKey:fieldName];
    
        }
        tupleObject.firstValue = [rowData objectAtIndex:3];
        if([rowData count]>2) {
            tupleObject.uomValue = [rowData objectAtIndex:3];
        } else {
            tupleObject.uomValue = @"";
        }
        ReportPostResponse *resonse = (ReportPostResponse*) reportData;
        if ([resonse.viewReportId isEqualToString:@"DR_BU_SALES_CUSTOMER_WISE_V2"]) {
            if ([[rowData objectAtIndex:0] isEqualToString:@"All"]) {
                fieldName = [rowData objectAtIndex:0];
            }
            else
            {
              fieldName =[[[rowData objectAtIndex:0] stringByAppendingString:@"-"]stringByAppendingString:[rowData objectAtIndex:1]];
            }
            
    
        }
        else{
            
        }
        tupleObject.fieldName = fieldName;
        tupleObject.firstRawData = rowData;
    }
    
//    for (int i=0; i<rowWiseTableData.count; i++) {
//        NSString *object =[[rowWiseTableData objectAtIndex:i] objectAtIndex:0];
//
//        if (![sortDataArrayAddName containsObject:object]){
//            [sortDataArrayAddName addObject:object];
//        }
//
//    }
    
}

-(void) addSecondSetData:(ReportPostResponse*) reportData into:(NSMutableDictionary*) inDataSet
{
    
    // we need to reset data for second value of all tuple in the inDataSet
    for(NSString* key in inDataSet.allKeys) {
        XmwCompareTuple* tupleObject = (XmwCompareTuple*)[inDataSet objectForKey:key];
        if(tupleObject!=nil) {
            tupleObject.secondValue = @"0.0";
            tupleObject.secondRawData = nil;
        }
    }
    
    NSArray* rowWiseTableData = reportData.tableData;
  
    for(NSArray* rowData in rowWiseTableData) {
        NSString* fieldName = [rowData objectAtIndex:0];
        XmwCompareTuple* tupleObject = (XmwCompareTuple*)[inDataSet objectForKey:fieldName];
        if(tupleObject==nil) {
            tupleObject = [[XmwCompareTuple alloc] init];
            tupleObject.firstValue = @"0.0";
            tupleObject.secondValue = @"0.0";
            tupleObject.thirdValue = @"0.0";
            tupleObject.firstRawData = nil;
            tupleObject.secondRawData = nil;
            tupleObject.thirdRawData = nil;
            [dataSet setObject:tupleObject forKey:fieldName];
        }
        tupleObject.secondValue = [rowData objectAtIndex:3];
        if([rowData count]>2) {
            tupleObject.uomValue = [rowData objectAtIndex:3];
        } else {
            tupleObject.uomValue = @"";
        }
        ReportPostResponse *resonse = (ReportPostResponse*) reportData;
        if ([resonse.viewReportId isEqualToString:@"DR_BU_SALES_CUSTOMER_WISE_V2"]) {
            if ([[rowData objectAtIndex:0] isEqualToString:@"All"]) {
                fieldName = [rowData objectAtIndex:0];
            }
            else
            {
                fieldName =[[[rowData objectAtIndex:0] stringByAppendingString:@"-"]stringByAppendingString:[rowData objectAtIndex:1]];
            }
            
        }
        else{
            
        }
        tupleObject.fieldName = fieldName;
        tupleObject.secondRawData = rowData;
    }
    
//    for (int i=0; i<rowWiseTableData.count; i++) {
//        NSString *object =[[rowWiseTableData objectAtIndex:i] objectAtIndex:0];
//
//        if (![sortDataArrayAddName containsObject:object]){
//            [sortDataArrayAddName addObject:object];
//        }
//
//    }
    
}

-(void) addThirdSetData:(ReportPostResponse*) reportData into:(NSMutableDictionary*) inDataSet
{
    // we need to reset data for second value of all tuple in the inDataSet
    for(NSString* key in inDataSet.allKeys) {
        XmwCompareTuple* tupleObject = (XmwCompareTuple*)[inDataSet objectForKey:key];
        if(tupleObject!=nil) {
            tupleObject.thirdValue = @"0.0";
            tupleObject.thirdRawData = nil;
        }
    }
    
    NSArray* rowWiseTableData = reportData.tableData;
    
    for(NSArray* rowData in rowWiseTableData) {
        NSString* fieldName = [rowData objectAtIndex:0];
        XmwCompareTuple* tupleObject = (XmwCompareTuple*)[inDataSet objectForKey:fieldName];
        if(tupleObject==nil) {
            tupleObject = [[XmwCompareTuple alloc] init];
            tupleObject.firstValue = @"0.0";
            tupleObject.secondValue = @"0.0";
            tupleObject.thirdValue = @"0.0";
            tupleObject.firstRawData = nil;
            tupleObject.secondRawData = nil;
            tupleObject.thirdRawData = nil;
            [dataSet setObject:tupleObject forKey:fieldName];
        }
        tupleObject.thirdValue = [rowData objectAtIndex:3];
        if([rowData count]>2) {
            tupleObject.uomValue = [rowData objectAtIndex:3];
        } else {
            tupleObject.uomValue = @"";
        }
        ReportPostResponse *resonse = (ReportPostResponse*) reportData;
        if ([resonse.viewReportId isEqualToString:@"DR_BU_SALES_CUSTOMER_WISE_V2"]) {
            if ([[rowData objectAtIndex:0] isEqualToString:@"All"]) {
                fieldName = [rowData objectAtIndex:0];
            }
            else
            {
                fieldName =[[[rowData objectAtIndex:0] stringByAppendingString:@"-"]stringByAppendingString:[rowData objectAtIndex:1]];
            }
            
        }
        else{
            
        }
        tupleObject.fieldName = fieldName;
        tupleObject.thirdRawData = rowData;
    }
    
//    for (int i=0; i<rowWiseTableData.count; i++) {
//        NSString *object =[[rowWiseTableData objectAtIndex:i] objectAtIndex:0];
//
//        if (![sortDataArrayAddName containsObject:object]){
//            [sortDataArrayAddName addObject:object];
//        }
//
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* dataSetKey = [sortedDataSetKeys objectAtIndex:indexPath.row];
    XmwCompareTuple* dataTuple = [dataSet objectForKey:dataSetKey];
    

    
    NSArray* rawData = [self pickGoodRawData:dataTuple.firstRawData option:dataTuple.secondRawData option:dataTuple.thirdRawData];
    
    
    if([[rawData objectAtIndex:0]isEqualToString:@"All"])//for polycab All check
    {
        //isDrillDown = NO;
    }
    else
    {
            if(indexPath.section==1 && [self clickable:indexPath.row]==YES) {
                [self handleDrilldown:indexPath.row];
            }
    }

    
}
-(void) fetchFirstColumnData:(DotFormPost*) formPost
{
    
    if(loadingView==nil) {
        loadingView = [LoadingView loadingViewInView:self.view];
    }
    loaderCount++;
    
    
    firstColumnText = [NSString stringWithFormat:@"%@\r\n%@",
                       [self.firstFormPost.postData objectForKey:@"FROM_DATE"],
                       [self.firstFormPost.postData objectForKey:@"TO_DATE"]];
    
    
    XmwReportService* reportService = [[XmwReportService alloc] initWithPostData:formPost withContext:@"fetchFirstColumnData"];
    
    [reportService fetchReportUsingSuccess:^(DotFormPost* formPosted, ReportPostResponse* reportResponse) {
        
        if(loaderCount>0) {
            loaderCount--;
            if(loaderCount==0) {
                [loadingView removeView];
                loadingView = nil;
            }
        }
        // we should receive report response data here
        
        
        firstResponse = reportResponse;
        
        ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
        DotReport* dotReport;
        if(firstResponse!=nil) {
            dotReport = [clientVariables.DOT_REPORT_MAP objectForKey:firstResponse.viewReportId];
            
        } else {
            dotReport = [clientVariables.DOT_REPORT_MAP objectForKey:self.dotForm.submitAdapterId];
            
        }
        [label setText: [dotReport.screenHeader uppercaseString]];
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
        [label setNumberOfLines: 0];
        [label setCenter: CGPointMake(self.view.center.x, label.center.y)];
      //  label.text = dotReport.screenHeader;
        
        [self addFirstSetData:firstResponse into:dataSet];
        
        
        sortedDataSetKeys = [self sortKeys];
        [self.mainTable reloadData];
        
    }   fail:^(DotFormPost* formPosted, NSString* message) {
        if(loaderCount>0) {
            loaderCount--;
            if(loaderCount==0) {
                [loadingView removeView];
                loadingView = nil;
            }
        }
        
        
    }];
    
}

-(NSArray*) sortKeys
{
    NSString* sortOnFieldData = [self dotReport].sortedOnField;
    
    NSMutableArray *sortedElementIds = [DotReportDraw sortRptComponents:self.dotReport.reportElements :XmwcsConst_REPORT_PLACE_TABLE];
    
    if(sortOnFieldData !=nil && [sortOnFieldData length]>0) {
        NSDictionary* sortFieldMap = [XmwUtils getExtendedPropertyMap:sortOnFieldData];
        
        // FIRST_FIELD_NAME:[VKBUR]$FIRST_FIELD_TYPE:[CHAR]$FIRST_FIELD_ORDER:[DESC]
        NSString* sortingField = [sortFieldMap objectForKey:@"FIRST_FIELD_NAME"];
        NSString* sortingFieldType = [sortFieldMap objectForKey:@"FIRST_FIELD_TYPE"];
        NSString* sortingOrder = [sortFieldMap objectForKey:@"FIRST_FIELD_ORDER"];
        
        int sortFieldIndex = -1;
        for(int i=0; i<[sortedElementIds count]; i++) {
            if([[sortedElementIds objectAtIndex:i] isEqualToString:sortingField]) {
                sortFieldIndex = i;
            }
        }
        
        if(sortFieldIndex>-1) {
            NSArray* allKeys = [dataSet allKeys];
            NSArray* sortedList = [allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString* item1, NSString* item2) {
                
                XmwCompareTuple* objectA = [dataSet objectForKey:item1];
                XmwCompareTuple* objectB = [dataSet objectForKey:item2];
                
                NSArray* rowDataA = [self pickGoodRawData:objectA.firstRawData option:objectA.secondRawData option:objectA.thirdRawData];
                
                NSArray* rowDataB = [self pickGoodRawData:objectB.firstRawData option:objectB.secondRawData option:objectB.thirdRawData];
                
                NSString* keyA = [rowDataA objectAtIndex:sortFieldIndex];
                NSString* keyB = [rowDataB objectAtIndex:sortFieldIndex];
                
                if([sortingOrder isEqualToString:@"DESC"]) {
                    return [keyA compare:keyB options:NSNumericSearch];
                } else {
                    return [keyB compare:keyA options:NSNumericSearch];
                }
            }];
            
            return sortedList;
        }
        
    }
    else
    {
        // return sorted alphabetically array according to android 
        NSArray* allKeys = [dataSet allKeys];
        NSArray* sortedList = [allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        return sortedList;
    }
//    return [dataSet allKeys];
}
//-(NSArray*) sortKeys
//{
//    NSString* sortOnFieldData = [self dotReport].sortedOnField;
//
//    NSMutableArray *sortedElementIds = [DotReportDraw sortRptComponents:self.dotReport.reportElements :XmwcsConst_REPORT_PLACE_TABLE];
//
//    if(sortOnFieldData !=nil && [sortOnFieldData length]>0) {
//        NSDictionary* sortFieldMap = [XmwUtils getExtendedPropertyMap:sortOnFieldData];
//
//        // FIRST_FIELD_NAME:[VKBUR]$FIRST_FIELD_TYPE:[CHAR]$FIRST_FIELD_ORDER:[DESC]
//        NSString* sortingField = [sortFieldMap objectForKey:@"FIRST_FIELD_NAME"];
//        NSString* sortingFieldType = [sortFieldMap objectForKey:@"FIRST_FIELD_TYPE"];
//        NSString* sortingOrder = [sortFieldMap objectForKey:@"FIRST_FIELD_ORDER"];
//
//        int sortFieldIndex = -1;
//        for(int i=0; i<[sortedElementIds count]; i++) {
//            if([[sortedElementIds objectAtIndex:i] isEqualToString:sortingField]) {
//                sortFieldIndex = i;
//            }
//        }
//
//        if(sortFieldIndex>-1) {
//            NSArray* allKeys = [dataSet allKeys];
//            NSArray* sortedList = [allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString* item1, NSString* item2) {
//
//                XmwCompareTuple* objectA = [dataSet objectForKey:item1];
//                XmwCompareTuple* objectB = [dataSet objectForKey:item2];
//
//                NSArray* rowDataA = [self pickGoodRawData:objectA.firstRawData option:objectA.secondRawData option:objectA.thirdRawData];
//
//                NSArray* rowDataB = [self pickGoodRawData:objectB.firstRawData option:objectB.secondRawData option:objectB.thirdRawData];
//
//                NSString* keyA = [rowDataA objectAtIndex:sortFieldIndex];
//                NSString* keyB = [rowDataB objectAtIndex:sortFieldIndex];
//
//                if([sortingOrder isEqualToString:@"DESC"]) {
//                    return [keyA compare:keyB options:NSNumericSearch];
//                } else {
//                    return [keyB compare:keyA options:NSNumericSearch];
//                }
//            }];
//
//            return sortedList;
//        }
//
//    }
//
//    return sortDataArrayAddName;
//}

@end
