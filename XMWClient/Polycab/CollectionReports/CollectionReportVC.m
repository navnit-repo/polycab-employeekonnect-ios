//
//  CollectionReportVC.m
//  XMWClient
//
//  Created by Pradeep Singh on 15/02/21.
//  Copyright © 2021 dotvik. All rights reserved.
//

#import "CollectionReportVC.h"
#import "SalesCell.h"
#import "DVAppDelegate.h"
#import "XmwcsConstant.h"
#import "DotFormPost.h"
#import "DotForm.h"
#import "ClientVariable.h"
#import "AppConstants.h"
#import "LayoutClass.h"

@interface CollectionReportVC () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation CollectionReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)makeReportScreenV2
{
    // [super makeReportScreenV2];
    
    self.reportTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, titleLblHeight + searchBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-(35+searchBar.frame.size.height))];
    self.reportTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.reportTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DefaultCell" ];
    
    
    self.reportTableView.dataSource = self;
    self.reportTableView.delegate = self;
  
   [self.view addSubview : self.reportTableView];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma  mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.reportPostResponse.tableData count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath");
    
    // NSArray* rowData = [self.reportPostResponse.tableData objectAtIndex:indexPath.row];
    
    if(indexPath.row > 0) {
        if([self.dotReport isFindDrillDown]) {
            [self handleDrillDown:indexPath.row :self.forwardedDataDisplay :self.forwardedDataPost];
        }
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f*deviceWidthRation + 12.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // resusing it
    SalesCell* dashCell =  [cell.contentView viewWithTag:9999];
    if(dashCell==nil) {
        dashCell= [SalesCell createInstance];
        [LayoutClass setLayoutForIPhone6:dashCell];
        
        [dashCell autoLayout];
        dashCell.tag = 9999;
        

        CGFloat xOffset = (self.view.frame.size.width - dashCell.frame.size.width)/2;
        CGRect oldFrame = dashCell.frame;
        dashCell.frame = CGRectMake(xOffset, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);
        dashCell.layer.borderColor = [UIColor lightGrayColor].CGColor;
        dashCell.layer.borderWidth = 1.0f;
        
        cell.contentView.frame = CGRectMake(0, 0, tableView.frame.size.width, 120.0f*deviceWidthRation + 12.0f);
        [cell.contentView addSubview:dashCell];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    SalesCell* dashCell =  [cell.contentView viewWithTag:9999];
    if(dashCell!=nil) {
        NSArray* rowData = [self.reportPostResponse.tableData objectAtIndex:indexPath.row];
        
        if([rowData count]==8) {
            dashCell.constantLbl1.text = [rowData objectAtIndex:0];
            dashCell.displayName.text = @"";
            
            dashCell.lftdDisplacyLbl.text = [rowData objectAtIndex:1];
            dashCell.ftdDataSetLbl.text = [rowData objectAtIndex:3];
            
            dashCell.lmtdDisplayLbl.text = [rowData objectAtIndex:4];
            dashCell.mtdDataSetLbl.text = [rowData objectAtIndex:6];
            
            dashCell.ytdDataSetLbl.text = [rowData objectAtIndex:7];
            
        } else if([rowData count]==9) {
            // for customers
            NSString* displayLabel = [NSString stringWithFormat:@"%@ - %@", [rowData objectAtIndex:0], [rowData objectAtIndex:1]];
            dashCell.constantLbl1.text = displayLabel;
            dashCell.displayName.text = @"";
            
            dashCell.lftdDisplacyLbl.text = [rowData objectAtIndex:2];
            dashCell.ftdDataSetLbl.text = [rowData objectAtIndex:4];
            
            dashCell.lmtdDisplayLbl.text = [rowData objectAtIndex:5];
            dashCell.mtdDataSetLbl.text = [rowData objectAtIndex:7];
            
            dashCell.ytdDataSetLbl.text = [rowData objectAtIndex:8];
            
            
        }
        
        
    }
}



-(void) handleDrillDown: (NSInteger) position :(NSMutableDictionary *) in_forwardedDataDisplay :(NSMutableDictionary *) in_forwardedDataPost
{
    self.forwardedDataDisplay = in_forwardedDataDisplay;
    self.forwardedDataPost = in_forwardedDataPost;
    
    NSMutableArray *sortedElementIds = [DotReportDraw sortRptComponents:self.dotReport.reportElements :XmwcsConst_REPORT_PLACE_TABLE];
    
    
   NSMutableArray *selectedRowElement = (NSMutableArray *)[self.reportPostResponse.tableData objectAtIndex:position];
   // NSMutableArray *selectedRowElement = (NSMutableArray *) [recordTableData objectAtIndex:position]; // this code chanage because of search feature
    
    if (self.forwardedDataDisplay == nil)
        self.forwardedDataDisplay   = [[NSMutableDictionary alloc] init];
    
    if (self.forwardedDataPost == nil)
        self.forwardedDataPost      = [[NSMutableDictionary alloc] init];
    
    DotFormPost* dotFormPost = [[DotFormPost alloc]init];
    [dotFormPost setAdapterId:self.dotReport.ddAdapterId];
    [dotFormPost setAdapterType:self.dotReport.ddAdapterType];
    //[dotFormPost setModuleId:XmwcsConst_APP_MODULE_WORKFLOW];
    [dotFormPost setModuleId:[DVAppDelegate currentModuleContext]];
    
    if(self.dotReport.ddServerCacheFlag!=nil && [self.dotReport.ddServerCacheFlag isEqualToString:@"FALSE"]) {
        dotFormPost.reportCacheRefresh = @"true";
    } else {
        dotFormPost.reportCacheRefresh = @"false";
    }
    
    NSLog(@"adaptertype : %@", self.dotReport.ddAdapterType);
    
    [dotFormPost setDocId: self.dotReport.ddAdapterType];
    
    NSArray* keysMap = [self.forwardedDataPost allKeys];
    
    for (int cntIndex = 0; cntIndex<[keysMap count]; cntIndex++)
    {
        NSString* keyOfMap = [keysMap objectAtIndex:cntIndex];
        [dotFormPost.postData setObject:[self.forwardedDataPost objectForKey:keyOfMap] forKey:keyOfMap];
    }
    
    for(int i =0; i<[sortedElementIds count];i++)
    {
        NSString *keyOfComp = (NSString *)[sortedElementIds objectAtIndex:i];
        DotReportElement *dotReportElement = (DotReportElement *)[self.dotReport.reportElements objectForKey:keyOfComp];
        if([dotReportElement isUseForward])
        {
            [self.forwardedDataDisplay setObject:[selectedRowElement objectAtIndex:i] forKey:dotReportElement.elementId];
            [self.forwardedDataPost setObject:[selectedRowElement objectAtIndex:i] forKey:dotReportElement.elementId];
            [dotFormPost.postData setObject:[selectedRowElement objectAtIndex:i] forKey:dotReportElement.elementId];
        }
        
        NSRange tempRange = [self.dotReport.ddNetworkFieldOfTable rangeOfString:keyOfComp];//java use of indexOf
        
        if(tempRange.length > 0)//java use of indexOf
        {
            [dotFormPost.postData setObject:[selectedRowElement objectAtIndex:i] forKey:dotReportElement.elementId];
        }
    }
    
    
    if([self.dotReport isDdNetworkCallBool])
    {
        //Middle screen
        //if([dotReport->getDdMiddleScrMsg().compare("")!=0])
        if(![self.dotReport.ddMiddleScrMsg isEqualToString:@""])
        {
            //Show the dialog Box and make Network Call
            
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Item Action:" message: [self.dotReport getDdMiddleScrMsg] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel" , nil];
            [myAlertView show];
            
            
        } else {
            
            loadingView = [LoadingView loadingViewInView:self.view];
            if([self.dotReport.ddCallName isEqualToString:XmwcsConst_CALL_NAME_FOR_SUBMIT])
            {
                NetworkHelper *networkHelper = [[NetworkHelper alloc] init];
                [networkHelper makeXmwNetworkCall:dotFormPost :self : nil :  XmwcsConst_CALL_NAME_FOR_SUBMIT];
            } else{
                NetworkHelper *networkHelper = [[NetworkHelper alloc] init];
                [networkHelper makeXmwNetworkCall:dotFormPost :self : nil :  XmwcsConst_CALL_NAME_FOR_REPORT];
                
            }
        }
    }
}


#pragma mark - HttpEventListener

- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    [loadingView removeView];
    if ([callName isEqualToString : XmwcsConst_CALL_NAME_FOR_REPORT])
    {
        
            DotFormPost* dotFormPost = (DotFormPost*) requestedObject;
            //  if(dotFormPost.adapterId)
            ReportPostResponse *reportPostResponse = (ReportPostResponse*) respondedObject;
            
            ClientVariable* clientVariable = [ClientVariable getInstance];
            ReportVC *reportVC = [clientVariable reportVCForId:dotFormPost.adapterId];
            reportVC.requestFormPost = dotFormPost;
            
            // ReportVC *reportVC = [[ReportVC alloc] initWithNibName:@"ReportVC" bundle:nil];
            reportVC.screenId = AppConst_SCREEN_ID_REPORT;
            reportVC.reportPostResponse = reportPostResponse;
            reportVC.forwardedDataDisplay = self.forwardedDataDisplay;
            reportVC.forwardedDataPost =  self.forwardedDataPost;
            [[self navigationController] pushViewController:reportVC  animated:YES];
            return;
        
    }
    if([callName isEqualToString : XmwcsConst_CALL_NAME_FOR_SUBMIT])
    {
        DocPostResponse* docResponse = (DocPostResponse*) respondedObject;
        NSString* serverMessage = docResponse.submittedMessage;//docResponse->getSubmittedMessage();
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Server Response" message: serverMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        [myAlertView show];
        return;
    }
}



- (void) httpFailureHandler : (NSString*) callName : (NSString*) message
{
     [loadingView removeView];
}
@end
