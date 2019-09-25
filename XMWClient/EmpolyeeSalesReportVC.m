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
#import "CompareReportTableCell.h"
@implementation EmpolyeeSalesReportVC
{
    
    UILabel *label;
    NSMutableArray *sortDataArrayAddName;
    UISearchBar *searchBar;
    CGFloat titleLblHeight;
    
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
//        [LayoutClass setLayoutForIPhone6:lView];
        
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
//        [LayoutClass setLayoutForIPhone6:totalRow];
        
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
    if ( [self clickable:0]==YES && [sortedDataSetKeys count] >0) {
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
    
    CGSize maximumLabelSize = CGSizeMake(label.frame.size.width, FLT_MAX);
    
    CGSize expectedLabelSize = [headername sizeWithFont:label.font constrainedToSize:maximumLabelSize lineBreakMode:label.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect newFrame = label.frame;
    newFrame.size.height = expectedLabelSize.height;
    label.frame = newFrame;
    
    titleLblHeight = label.frame.size.height+10;
    
    [self.view addSubview:label];
    [self configureSearchBar] ;
}

-(void)configureSearchBar
{
    [searchBar removeFromSuperview];
    
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(10, titleLblHeight, self.view.frame.size.width-20, 44*deviceHeightRation)];
        searchBar.delegate = self;
    [searchBar setPlaceholder:@"Search"];
    [searchBar setReturnKeyType:UIReturnKeyDone];
    searchBar.enablesReturnKeyAutomatically = NO;
    [self.view addSubview:searchBar];
    
     if (@available(iOS 13.0, *)) {
                     [searchBar setBackgroundColor:[UIColor clearColor]];
                     [searchBar setBackgroundImage:[UIImage new]];
                     [searchBar setTranslucent:YES];
                     searchBar.searchTextField.borderStyle = UITextBorderStyleRoundedRect;
                     searchBar.searchTextField.layer.masksToBounds=YES;
                     searchBar.searchTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
                     searchBar.searchTextField.layer.cornerRadius=5.0f;
                     searchBar.searchTextField.layer.borderWidth= 1.0f;
       }
       else
       {
           for (id subview in [[searchBar.subviews lastObject] subviews]) {
           if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
               [subview removeFromSuperview];
           }
           
           if ([subview isKindOfClass:[UITextField class]])
           {
               UITextField *textFieldObject = (UITextField *)subview;
               textFieldObject.borderStyle = UITextBorderStyleRoundedRect;
               textFieldObject.layer.masksToBounds=YES;
               textFieldObject.layer.borderColor=[[UIColor lightGrayColor]CGColor];
               textFieldObject.layer.cornerRadius=5.0f;
               textFieldObject.layer.borderWidth= 1.0f;
               break;
           }
               
           }
       }
    
self.mainTable.frame = CGRectMake(0, titleLblHeight + searchBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-(35+searchBar.frame.size.height));
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
    
    orignalDataSet = [[NSMutableDictionary alloc ] init];
    orignalDataSet = dataSet;
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
        titleLblHeight = label.frame.size.height+10;
        [self configureSearchBar];
        
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


-(NSMutableAttributedString*)getmutableString :(NSString*) text :(NSString*) textPattern
{
    NSMutableAttributedString *mutableString = nil;
    
    mutableString = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:textPattern options:1 error:nil];
    
    NSRange range = NSMakeRange(0,[text length]);
    [expression enumerateMatchesInString:text options:1 range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange californiaRange = [result rangeAtIndex:0] ;
        [mutableString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:204.0/255 green:41.0/255 blue:43.0/255 alpha:1.0] range:californiaRange];
    }];
    return mutableString;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    if(indexPath.section==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    else if(indexPath.section==1) {
        NSString *str = [NSString stringWithFormat:@"CompareReportTableCell_Section_%ld_row_%ld",(long)indexPath.section,indexPath.row];
        CompareReportTableCell *rowCell = (CompareReportTableCell*) [tableView dequeueReusableCellWithIdentifier:str];
        [tableView registerNib:[UINib nibWithNibName:@"CompareReportTableCell" bundle:nil] forCellReuseIdentifier:str];
        rowCell  = [tableView dequeueReusableCellWithIdentifier:str];
        rowCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        NSString* key = [sortedDataSetKeys objectAtIndex:indexPath.row];
        XmwCompareTuple* tuple = [dataSet objectForKey:key];
        rowCell.fieldLabel.text = tuple.fieldName;
        rowCell.firstLabel.text = tuple.firstValue;
        rowCell.secondLabel.text = tuple.secondValue;
        rowCell.thirdLabel.text = tuple.thirdValue;
        
        NSString *fieldLabelText = @"";
        NSString *firstLabelText = @"";
        NSString *secondLabelText = @"";
        NSString *thirdLabelText = @"";
        if (rowCell.fieldLabel.text !=nil) {
            fieldLabelText = rowCell.fieldLabel.text;
        }
        
        if (rowCell.firstLabel.text !=nil) {
            firstLabelText = rowCell.firstLabel.text;
        }
        
        if (rowCell.secondLabel.text !=nil) {
            secondLabelText = rowCell.secondLabel.text;
        }
        
        if (rowCell.thirdLabel.text !=nil) {
            thirdLabelText = rowCell.thirdLabel.text;
        }
        
        NSString *patternText = @"";
        if (searchBar.text != nil) {
            patternText = searchBar.text;
        }
        
        rowCell.fieldLabel.attributedText = [self getmutableString:fieldLabelText :patternText];
        rowCell.firstLabel.attributedText = [self getmutableString:firstLabelText :patternText];
        rowCell.secondLabel.attributedText = [self getmutableString:secondLabelText :patternText];
        rowCell.thirdLabel.attributedText = [self getmutableString:thirdLabelText :patternText];
        
        
        CGSize maximumLabelSize = CGSizeMake(rowCell.fieldLabel.frame.size.width, FLT_MAX);
        
        CGSize expectedLabelSize = [rowCell.fieldLabel.text sizeWithFont:rowCell.fieldLabel.font constrainedToSize:maximumLabelSize lineBreakMode:rowCell.fieldLabel.lineBreakMode];
        
        if (rowCell.fieldLabel.frame.size.height < expectedLabelSize.height) {
            //adjust the label the the new height.
            CGRect newLableFrame = rowCell.fieldLabel.frame;
            newLableFrame.size.height = expectedLabelSize.height;
            rowCell.fieldLabel.frame = CGRectMake(rowCell.fieldLabel.frame.origin.x, rowCell.fieldLabel.frame.origin.y, rowCell.fieldLabel.frame.size.width, expectedLabelSize.height);
            
            CGRect viewNewFrame = rowCell.view1.frame;
            viewNewFrame.size.height = expectedLabelSize.height;
            rowCell.view1.frame = CGRectMake(rowCell.view1.frame.origin.x, rowCell.view1.frame.origin.y, rowCell.view1.frame.size.width, expectedLabelSize.height);
            
            rowCell.view2.frame = CGRectMake(rowCell.view2.frame.origin.x, rowCell.view2.frame.origin.y, rowCell.view2.frame.size.width, expectedLabelSize.height);
            
            rowCell.view3.frame = CGRectMake(rowCell.view3.frame.origin.x, rowCell.view3.frame.origin.y, rowCell.view3.frame.size.width, expectedLabelSize.height);
            
            rowCell.view4.frame = CGRectMake(rowCell.view4.frame.origin.x, rowCell.view4.frame.origin.y, rowCell.view4.frame.size.width, expectedLabelSize.height);
            
            rowCell.firstLabel.frame  =  CGRectMake(rowCell.firstLabel.frame.origin.x, rowCell.firstLabel.frame.origin.y, rowCell.firstLabel.frame.size.width, expectedLabelSize.height);
            
            rowCell.secondLabel.frame =  CGRectMake(rowCell.secondLabel.frame.origin.x, rowCell.secondLabel.frame.origin.y, rowCell.secondLabel.frame.size.width, expectedLabelSize.height);
            
            
            rowCell.thirdLabel.frame  =  CGRectMake(rowCell.thirdLabel.frame.origin.x, rowCell.thirdLabel.frame.origin.y, rowCell.thirdLabel.frame.size.width, expectedLabelSize.height);
            
            [self tableView:self heightForRowAtIndexPath:indexPath];
        }
        
        rowCell.clipsToBounds = YES;
        return rowCell;
    }
    cell.clipsToBounds = YES;
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0f;
    
    if(indexPath.section==1) {
        // NSString* key = [dataSet.allKeys objectAtIndex:indexPath.row];
        
        NSString* key = [sortedDataSetKeys objectAtIndex:indexPath.row];
        XmwCompareTuple* tuple = [dataSet objectForKey:key];
        
        
        UILabel *temLbl = [[UILabel alloc]init];
        temLbl.frame = CGRectMake(0, 0, 77, 42);
        temLbl.numberOfLines = 0;
        temLbl.textAlignment = NSTextAlignmentCenter;
        temLbl.lineBreakMode = NSLineBreakByWordWrapping;
        [temLbl setFont:[UIFont systemFontOfSize:12.0f weight:UIFontWeightRegular]];
        temLbl.text = tuple.fieldName;
        [LayoutClass labelLayout:temLbl forFontWeight:UIFontWeightRegular];
        
        CGSize maximumLabelSize = CGSizeMake(temLbl.frame.size.width, FLT_MAX);
        
        CGSize expectedLabelSize = [temLbl.text sizeWithFont: temLbl.font constrainedToSize:maximumLabelSize lineBreakMode:temLbl.lineBreakMode];
        
        if (temLbl.frame.size.height < expectedLabelSize.height) {
            //adjust the label the the new height.
            height = expectedLabelSize.height+4;
            NSLog(@"Cell height :- %f",height);
            return height;
        }
        else
        {
            height = 44.0f*deviceHeightRation;
            NSLog(@"Cell height :- %f",height);
            return height;
        }
        
    }
    
    else
    {
        height = 44.0f*deviceHeightRation;
        NSLog(@"Cell height :- %f",height);
        return height;
    }
    //    return 44.0f*deviceHeightRation;
    
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark - searchBar handler
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length>0) {
        dataSet = [[NSMutableDictionary alloc ] init ];
        
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc ] init];
        dict = orignalDataSet;
        for(id key in dict)
        {
            XmwCompareTuple* tuple = [dict objectForKey:key];
            
            NSString *fieldName;
            NSString *firstValue;
            NSString *secondValue;
            NSString *thirdValue;
            
            fieldName = tuple.fieldName;
            firstValue = tuple.firstValue;
            secondValue = tuple.secondValue;
            thirdValue = tuple.thirdValue;
            
            NSRange fieldNameRange =   [fieldName rangeOfString:searchText options:NSCaseInsensitiveSearch];
            NSRange firstValueRange =  [firstValue rangeOfString:searchText options:NSCaseInsensitiveSearch];
            NSRange secondValueRange = [secondValue rangeOfString:searchText options:NSCaseInsensitiveSearch];
            NSRange thirdValueRange =  [thirdValue rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            
            if (fieldNameRange.location != NSNotFound)
            {
                
                [dataSet setObject:tuple forKey:tuple.fieldName];
                
            }
           else if (firstValueRange.location != NSNotFound)
            {
                [dataSet setObject:tuple forKey:tuple.fieldName];
                
            }
            
           else if (secondValueRange.location != NSNotFound)
           {
                [dataSet setObject:tuple forKey:tuple.fieldName];
               
           }
           else if (thirdValueRange.location != NSNotFound)
           {
               [dataSet setObject:tuple forKey:tuple.fieldName];
               
           }
            
        }
        
        if (dataSet.count >0) {
        sortedDataSetKeys = [self sortKeys];
        }
        [self.mainTable reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    else
    {
                dataSet = [[NSMutableDictionary alloc ] init];
                dataSet = orignalDataSet;
                sortedDataSetKeys = [self sortKeys];
                [self.mainTable reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    }

}
@end
