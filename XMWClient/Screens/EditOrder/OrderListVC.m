//
//  OrderListVC.m
//  QCMSProject
//
//  Created by Pradeep Singh on 6/16/16.
//  Copyright © 2016 dotvik. All rights reserved.
//

#import "OrderListVC.h"
#import "DVAppDelegate.h"
#import "DotReportDraw.h"
#import "XmwcsConstant.h"
#import "ClientVariable.h"
#import "AppConstants.h"


//
// This is done to override cache refresh behaviour for a report
// We need to get fresh content from the SAP / ERP as Order has been updated.
//

@interface OrderListVC ()  <DrilldownControlDelegate>
{
    LoadingView* loadingView;
}

@end

@implementation OrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.drilldownDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - DrilldownControlDelegate
-(void) handleDrilldownForRow:(NSInteger) rowIndex withRowData:(NSArray*) rowData
{
    NSLog(@"OrderListVC.handleDrilldownForRow for row index = %ld", rowIndex);
    
    
    NSMutableArray *sortedElementIds = [DotReportDraw sortRptComponents:self.dotReport.reportElements :XmwcsConst_REPORT_PLACE_TABLE];
    NSMutableArray *selectedRowElement = (NSMutableArray *)[self.reportPostResponse.tableData objectAtIndex:rowIndex];

    
    if (self.forwardedDataDisplay == nil)
        self.forwardedDataDisplay   = [[NSMutableDictionary alloc] init];
    
    if (self.forwardedDataPost == nil)
        self.forwardedDataPost      = [[NSMutableDictionary alloc] init];
    
    
    DotFormPost* dotFormPost = [[DotFormPost alloc]init];
    [dotFormPost setAdapterId:self.dotReport.ddAdapterId];
    [dotFormPost setAdapterType:self.dotReport.ddAdapterType];
    dotFormPost.reportCacheRefresh = @"true";
    
    [dotFormPost setModuleId:[DVAppDelegate currentModuleContext]];
    
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
    
    
    NetworkHelper *networkHelper = [[NetworkHelper alloc] init];
    [networkHelper makeXmwNetworkCall:dotFormPost :self : nil :  XmwcsConst_CALL_NAME_FOR_REPORT];
    
    
}



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
