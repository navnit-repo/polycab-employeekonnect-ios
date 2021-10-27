//
//  SPAReportVC.m
//  XMWClient
//
//  Created by Nit Navodit on 22/10/21.
//  Copyright © 2021 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPAReportVC.h"

#import "DotReportDraw.h"
#import "XmwcsConstant.h"
#import "XmwUtils.h"
#import "MXLabel.h"
#import "ReportVC.h"
#import "MXButton.h"
#import "DotReport.h"
#import "DotReportListCellRenderer.h"
#import "ClientVariable.h"
#import "DVAppDelegate.h"
#import "NetworkHelper.h"
#import "AppConstants.h"
#import "DVAppDelegate.h"
#import "MXTextField.h"
#import "TagKeyConstant.h"
#import "XmwHttpFileDownloader.h"

@interface SPAReportVC () <DrilldownControlDelegate>
{

}
@end
@implementation SPAReportVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.drilldownDelegate = self;
    NSLog(@"SPAReportVC viewDidLoad field tag = %d", 1);
}

#pragma mark - DrilldownControlDelegate
-(void) handleDrilldownForRow:(NSInteger) rowIndex withRowData:(NSArray*) rowData
{
    NSLog(@"SPAReportVC.handleDrilldownForRow for row index = %ld", rowIndex);
    
    ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    NSString *formId = @"DF_SPA_APPROVAL_HEADER";//(NSString *)[addedData objectForKey:XmwcsConst_MENU_CONSTANT_FORM_ID];
    DotForm *dotForm = (DotForm *) [clientVariables.DOT_FORM_MAP objectForKey: formId];
    
    if (forwardedDataDisplay == nil)
        forwardedDataDisplay   = [[NSMutableDictionary alloc] init];
    
    if (forwardedDataPost == nil)
        forwardedDataPost      = [[NSMutableDictionary alloc] init];
    
    
//    if( [[dotForm formSubType] isEqualToString:XmwcsConst_DF_FORM_TYPE_SIMPLE] ||
//       [[dotForm formSubType] isEqualToString:XmwcsConst_DF_FORM_TYPE_CHANGE_PASSWORD] ||
//       [[dotForm formSubType] isEqualToString:XmwcsConst_DF_FORM_TYPE_SIMPLEADDROW] ||
//       [[dotForm formSubType] isEqualToString:XmwcsConst_DF_FORM_TYPE_ADD_ROW] ||
//       [[dotForm formSubType] isEqualToString:XmwcsConst_DF_FORM_TYPE_SIMPLEADDROW_SAMEFORM]
//       )
//    {
        
//        ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
        
        FormVC* formController  = [clientVariables  formVCForId:dotForm.formId];
        
        if(formController!=nil) {
            DotMenuObject * addedData = [[DotMenuObject alloc]init];
            addedData.FORM_ID = formId;
            addedData.FORM_TYPE = @"SUBMIT";
            addedData.visible = true;
            addedData.MODULE = @"xmwpolycab";
            
            formController.formData = addedData;
            formController.dotFormPost = nil;
            formController.forwardedDataDisplay = forwardedDataDisplay;
            formController.forwardedDataPost = forwardedDataPost;
            formController.isFormIsSubForm = true;
            formController.addedRowData = [(NSArray*)rowData mutableCopy];
            
            formController.headerStr            = dotForm.screenHeader;
            formController.menuViewController = self;
//            formController.auth_Token = auth_Token;
            [[self navigationController] pushViewController:formController  animated:YES];
            
        }
        
        return;
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
    NSLog(@"setAdapterId : %@", self.dotReport.ddAdapterType);
    
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
-(void) handleDrillDown : (NSInteger) position :(NSMutableDictionary *) in_forwardedDataDisplay :(NSMutableDictionary *) in_forwardedDataPost
{
    NSLog(@"SPAReportVC handleDrillDown field tag = %d", 1);
    self.forwardedDataDisplay = in_forwardedDataDisplay;
    self.forwardedDataPost = in_forwardedDataPost;
    ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    NSMutableArray *sortedElementIds = [DotReportDraw sortRptComponents:dotReport.reportElements :XmwcsConst_REPORT_PLACE_TABLE];
    NSMutableArray *selectedRowElement = (NSMutableArray *)[reportPostResponse.tableData objectAtIndex:position];
    if (forwardedDataDisplay == nil)
        forwardedDataDisplay   = [[NSMutableDictionary alloc] init];
    
    if (forwardedDataPost == nil)
        forwardedDataPost      = [[NSMutableDictionary alloc] init];

    DotFormPost *dotFormPost = [[DotFormPost alloc]init];
    [dotFormPost setAdapterId:dotReport.ddAdapterId];
    [dotFormPost setAdapterType:dotReport.ddAdapterType];
    //[dotFormPost setModuleId:XmwcsConst_APP_MODULE_WORKFLOW];
    [dotFormPost setModuleId:[DVAppDelegate currentModuleContext]];
   
    NSLog(@"adaptertype : %@", dotReport.ddAdapterType);
   
    [dotFormPost setDocId: dotReport.ddAdapterType];
       
    NSArray* keysMap = [forwardedDataPost allKeys];

    for (int cntIndex = 0; cntIndex<[keysMap count]; cntIndex++)
    {
        NSString* keyOfMap = [keysMap objectAtIndex:cntIndex];
        [dotFormPost.postData setObject:[forwardedDataPost objectForKey:keyOfMap] forKey:keyOfMap];
    }
           
    for(int i =0; i<[sortedElementIds count];i++)
    {
        NSString *keyOfComp = (NSString *)[sortedElementIds objectAtIndex:i];
        DotReportElement *dotReportElement = (DotReportElement *)[dotReport.reportElements objectForKey:keyOfComp];
       if([dotReportElement isUseForward])
        {
            [forwardedDataDisplay setObject:[selectedRowElement objectAtIndex:i] forKey:dotReportElement.elementId];
            [forwardedDataPost setObject:[selectedRowElement objectAtIndex:i] forKey:dotReportElement.elementId];
            [dotFormPost.postData setObject:[selectedRowElement objectAtIndex:i] forKey:dotReportElement.elementId];
         }
                      
        NSRange tempRange = [dotReport.ddNetworkFieldOfTable rangeOfString:keyOfComp];//java use of indexOf
        
        if(tempRange.length > 0)//java use of indexOf
        {
           [dotFormPost.postData setObject:[selectedRowElement objectAtIndex:i] forKey:dotReportElement.elementId];
        }
    }
    
    if([dotReport.reportType isEqualToString:XmwcsConst_REPORT_TYPE_SIMPLE_LINK]) {
        NSLog(@"key for URL download is %@", dotReport.urlField);
        NSString* urlString = [forwardedDataPost objectForKey:dotReport.urlField];
        NSLog(@"URL string is %@", urlString);
        
        // TODO Pradeep.
        
        XmwHttpFileDownloader* fileDownloader = [[XmwHttpFileDownloader alloc] initWithUrl:urlString];
        // we need to replace these username and password with the user
        [fileDownloader downloadStart:nil username:@"czz9999" password:@"crm123"];
        
        // String username = "czz9999", password = "crm123";
        return;
    }

    
//    dotFormPost = dotFormPost;
    if([dotReport isDdNetworkCallBool])
    {
            //Middle screen
            //if([dotReport->getDdMiddleScrMsg().compare("")!=0])
            if(![dotReport.ddMiddleScrMsg isEqualToString:@""])
            {
                //Show the dialog Box and make Network Call
               
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Item Action:" message: [dotReport getDdMiddleScrMsg] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel" , nil];
                 [myAlertView show];
                
                
            } else {
                if([dotReport.ddCallName isEqualToString:XmwcsConst_CALL_NAME_FOR_SUBMIT])
                {
                    NetworkHelper *networkHelper = [[NetworkHelper alloc] init];
                    [networkHelper makeXmwNetworkCall:dotFormPost :self : nil :  XmwcsConst_CALL_NAME_FOR_SUBMIT];
                    
                    
                } else {
                    NetworkHelper *networkHelper = [[NetworkHelper alloc] init];
                    [networkHelper makeXmwNetworkCall:dotFormPost :self : nil :  XmwcsConst_CALL_NAME_FOR_REPORT];
                    
                }
                
            }
    } else {
        
        // we need to show local report here
        ReportPostResponse* reportPostResponseNoNetwork = [[ReportPostResponse alloc] init];
        reportPostResponseNoNetwork.viewReportId = dotFormPost.adapterId;
        
        ReportVC *offlineReportVC = [[ReportVC alloc] initWithNibName:REPORTVC bundle:nil];
        offlineReportVC.screenId = AppConst_SCREEN_ID_REPORT;
        offlineReportVC.reportPostResponse = reportPostResponseNoNetwork;
        offlineReportVC.forwardedDataDisplay = forwardedDataDisplay;
        offlineReportVC.forwardedDataPost = forwardedDataPost;
        [[self navigationController] pushViewController:offlineReportVC  animated:YES];
    }
    
}

@end
