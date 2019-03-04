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


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if(section==1) {
        UINib* headerNib = [UINib nibWithNibName:@"EmpolyeeSalesReportHeaderView" bundle:nil];
        
        UIView* view = [[headerNib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        
        view.bounds = CGRectMake(0, 0, self.view.frame.size.width, 60.0f);
        
        
        UIView* lView = nil;
        UITapGestureRecognizer* tapGesture = nil;
        
        lView = [view viewWithTag:0];
        
        
        lView = [view viewWithTag:1];
        //     tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePeriodAction:)];
        //  [lView addGestureRecognizer:tapGesture];
        
        
        lView = [view viewWithTag:2];
        //    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePeriodAction:)];
        //    [lView addGestureRecognizer:tapGesture];
        
        
        lView = [view viewWithTag:3];
        //    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePeriodAction:)];
        //    [lView addGestureRecognizer:tapGesture];
        
        
        return view;
    } else {
        return nil;
    }
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
        return 60.0f*deviceHeightRation;
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
        tupleObject.firstValue = [rowData objectAtIndex:2];
        if([rowData count]>2) {
            tupleObject.uomValue = [rowData objectAtIndex:2];
        } else {
            tupleObject.uomValue = @"";
        }
        tupleObject.fieldName = fieldName;
        tupleObject.firstRawData = rowData;
    }
    
    for (int i=0; i<rowWiseTableData.count; i++) {
        NSString *object =[[rowWiseTableData objectAtIndex:i] objectAtIndex:0];
        
        if (![sortDataArrayAddName containsObject:object]){
            [sortDataArrayAddName addObject:object];
        }
       
    }
    
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
        tupleObject.secondValue = [rowData objectAtIndex:2];
        if([rowData count]>2) {
            tupleObject.uomValue = [rowData objectAtIndex:2];
        } else {
            tupleObject.uomValue = @"";
        }
        tupleObject.fieldName = fieldName;
        tupleObject.secondRawData = rowData;
    }
    
    for (int i=0; i<rowWiseTableData.count; i++) {
        NSString *object =[[rowWiseTableData objectAtIndex:i] objectAtIndex:0];
        
        if (![sortDataArrayAddName containsObject:object]){
            [sortDataArrayAddName addObject:object];
        }
        
    }
    
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
        tupleObject.thirdValue = [rowData objectAtIndex:2];
        if([rowData count]>2) {
            tupleObject.uomValue = [rowData objectAtIndex:2];
        } else {
            tupleObject.uomValue = @"";
        }
        tupleObject.fieldName = fieldName;
        tupleObject.thirdRawData = rowData;
    }
    
    for (int i=0; i<rowWiseTableData.count; i++) {
        NSString *object =[[rowWiseTableData objectAtIndex:i] objectAtIndex:0];
        
        if (![sortDataArrayAddName containsObject:object]){
            [sortDataArrayAddName addObject:object];
        }
        
    }
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
    
    return sortDataArrayAddName;
}

@end
