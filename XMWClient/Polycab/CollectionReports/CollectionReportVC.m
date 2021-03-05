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
#import "CurrencyConversationClass.h"
#import "DotReportDraw.h"
#import "Styles.h"

@interface CollectionReportVC () <UITableViewDelegate, UITableViewDataSource>
{
    CurrencyConversationClass* currencyFormat;
    NSString* rupee;
    NSArray* headerElementIds;
}
@end

@implementation CollectionReportVC

- (void)viewDidLoad {
    currencyFormat = [[CurrencyConversationClass alloc] init];
    rupee = @"\u20B9";
    

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)makeReportScreenV2
{
    // [super makeReportScreenV2];
    
    headerElementIds = [DotReportDraw sortRptComponents: dotReport.reportElements :@"HEADER"];
    
    self.reportTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, titleLblHeight + searchBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-(35+searchBar.frame.size.height))];
    self.reportTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.reportTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HeaderCell" ];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0) {
        return [headerElementIds count];
    } else if(section==1) {
        return  [self.reportPostResponse.tableData count];
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath");
    
    // NSArray* rowData = [self.reportPostResponse.tableData objectAtIndex:indexPath.row];
    
    if( (indexPath.section==1) &&  (indexPath.row > 0) ) {
        if([self.dotReport isFindDrillDown]) {
            [self handleDrillDown:indexPath.row :self.forwardedDataDisplay :self.forwardedDataPost];
        }
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section ==0 ) {
        return 35.0f;
    } else if(indexPath.section == 1) {
        return 120.0f*deviceWidthRation + 12.0f;
    } else {
        return 0.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;

    // resusing it
    if(indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
        // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView* customView = [cell.contentView viewWithTag:1001];
        
        if(customView==nil) {
            customView = [self viewWithStyle:indexPath];
            customView.tag = 1001;
            [cell.contentView addSubview:customView];
        }
        
    } else if(indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        SalesCell* dashCell =  [cell.contentView viewWithTag:9999];
        if(dashCell==nil) {
            dashCell= [SalesCell createInstance];
            [LayoutClass setLayoutForIPhone6:dashCell];
            
            [dashCell autoLayout];
            dashCell.tag = 9999;
            
            // Need to rearraged constantLbl1 , displayName  of sales
            dashCell.constantLbl1.hidden = YES;
            dashCell.displayName.frame = CGRectMake(10.0f, dashCell.displayName.frame.origin.y, dashCell.frame.size.width-20.0f, dashCell.displayName.frame.size.height);

            CGFloat xOffset = (self.view.frame.size.width - dashCell.frame.size.width)/2;
            CGRect oldFrame = dashCell.frame;
            dashCell.frame = CGRectMake(xOffset, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);
            dashCell.layer.borderColor = [UIColor lightGrayColor].CGColor;
            dashCell.layer.borderWidth = 1.0f;
            
            cell.contentView.frame = CGRectMake(0, 0, tableView.frame.size.width, 120.0f*deviceWidthRation + 12.0f);
            [cell.contentView addSubview:dashCell];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        // cell.textLabel.text =  @"Testing";
        
        UIView* customView = [cell.contentView viewWithTag:1001];
        
        if(customView!=nil) {
            [self configureView:customView forIndexPath:indexPath];
        }
        
       
        
    } else if(indexPath.section == 1) {
        SalesCell* dashCell =  [cell.contentView viewWithTag:9999];
        if(dashCell!=nil) {
            NSArray* rowData = [self.reportPostResponse.tableData objectAtIndex:indexPath.row];
            
            if([rowData count]==8) {
                dashCell.constantLbl1.text = @"";
                dashCell.displayName.text = [rowData objectAtIndex:0];
                
                dashCell.lftdDisplacyLbl.text = [self currencyDisplay:[rowData objectAtIndex:1]];
                dashCell.ftdDataSetLbl.text = [self currencyDisplay:[rowData objectAtIndex:3]];
                
                dashCell.lmtdDisplayLbl.text = [self currencyDisplay:[rowData objectAtIndex:4]];
                dashCell.mtdDataSetLbl.text = [self currencyDisplay:[rowData objectAtIndex:6]];
                
                dashCell.ytdDataSetLbl.text = [self currencyDisplay:[rowData objectAtIndex:7]];
                
            } else if([rowData count]==9) {
                // for customers
                NSString* displayLabel = [NSString stringWithFormat:@"%@ - %@", [rowData objectAtIndex:0], [rowData objectAtIndex:1]];
                
                dashCell.constantLbl1.text = @"";
                dashCell.displayName.text = displayLabel ;
                
                dashCell.lftdDisplacyLbl.text = [self currencyDisplay:[rowData objectAtIndex:2]];
                dashCell.ftdDataSetLbl.text = [self currencyDisplay:[rowData objectAtIndex:4]];
                
                dashCell.lmtdDisplayLbl.text = [self currencyDisplay:[rowData objectAtIndex:5]];
                dashCell.mtdDataSetLbl.text = [self currencyDisplay:[rowData objectAtIndex:7]];
                
                dashCell.ytdDataSetLbl.text = [self currencyDisplay:[rowData objectAtIndex:8]];
            }
        }
        
    }
    
}

-(NSString*) currencyDisplay:(NSString*) amountValue
{
    NSString* cleanedString = [[amountValue stringByReplacingOccurrencesOfString:@"," withString:@""]
    stringByTrimmingCharactersInSet: [NSCharacterSet symbolCharacterSet]];
    
    return [NSString stringWithFormat:@"%@%@", rupee, [currencyFormat formateCurrency:cleanedString]];
}


#pragma mark - Drilldown

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
    
    
#pragma mark - ReportHeader
-(UIView *)viewWithStyle:(NSIndexPath *)indexPath
{
    CGFloat screenWidth = self.reportTableView.frame.size.width;
    NSString *keyOfComp =  (NSString *) [headerElementIds objectAtIndex :indexPath.row];
    DotReportElement *dotReportElement = (DotReportElement *) [self.dotReport.reportElements objectForKey:keyOfComp];
    
    NSMutableDictionary* styles = [XmwUtils getExtendedPropertyMap : dotReportElement.componentStyle];

    NSString* rightAlignment = [styles objectForKey:XmwcsConst_STYLE_PREOPERTY_ALIGNMENT];
    NSTextAlignment rightValueAlignment = NSTextAlignmentRight;

    if([rightAlignment isEqualToString:XmwcsConst_STYLE_ALIGNMENT_LEFT]) {
        rightValueAlignment = NSTextAlignmentLeft;
    } else if ([rightAlignment isEqualToString:XmwcsConst_STYLE_ALIGNMENT_RIGHT]) {
        rightValueAlignment = NSTextAlignmentRight;
    } else if ([rightAlignment isEqualToString:XmwcsConst_STYLE_ALIGNMENT_HECNTER]) {
        rightValueAlignment = NSTextAlignmentCenter;
    }
    
    
    NSString *headerValue = [self.reportPostResponse.headerData objectForKey:keyOfComp];
    
    if(headerValue == nil) headerValue = @"";
    
    CGSize calcLeftSize;
    CGSize calcRightSize;
    UIView *elementContainer;
    UILabel *lblHeaderTitle;
    UILabel *lblHeaderValue;
    
    NSString* styleLine = [styles objectForKey:XmwcsConst_STYLE_PREOPERTY_LINE];
    
    if(styleLine != nil && [styleLine isEqualToString:XmwcsConst_STYLE_LABEL_NEWLINE]) {
        calcLeftSize = [dotReportElement.displayText boundingRectWithSize:CGSizeMake(screenWidth-10, 1024) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:14] } context:nil].size;
        
        calcRightSize = [headerValue boundingRectWithSize:CGSizeMake(screenWidth - 10, 1024) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:14] } context:nil].size;
        
        int headerRowHeight = calcLeftSize.height + calcRightSize.height + 10;
        
        elementContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, headerRowHeight) ];
        lblHeaderTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, screenWidth - 10, calcLeftSize.height)];
        lblHeaderValue = [[UILabel alloc] initWithFrame:CGRectMake(10, 5 + calcLeftSize.height, screenWidth - 10, calcRightSize.height)];
    } else {
        calcLeftSize = [dotReportElement.displayText boundingRectWithSize:CGSizeMake(screenWidth/2-10, 1024) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:14] } context:nil].size;
        
        calcRightSize = [headerValue boundingRectWithSize:CGSizeMake(screenWidth/2-10, 1024) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:14] } context:nil].size;
        
        int headerRowHeight = calcLeftSize.height;
        
        if(headerRowHeight<calcRightSize.height) {
            headerRowHeight = calcRightSize.height;
        }
        
        headerRowHeight = headerRowHeight + 10;
        
        elementContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, headerRowHeight) ];
        lblHeaderTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, screenWidth/2 - 20, calcLeftSize.height)];
        
        lblHeaderValue = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2, 5, screenWidth/2 - 20, calcRightSize.height)];
    }

    lblHeaderTitle.text = dotReportElement.displayText;
    [lblHeaderTitle setFont:[UIFont boldSystemFontOfSize:14]];
    lblHeaderTitle.tag = 11;
    
    [elementContainer addSubview:lblHeaderTitle];
    

    [lblHeaderValue setFont:[UIFont boldSystemFontOfSize:14]];
    lblHeaderValue.text  = headerValue;
    lblHeaderValue.textAlignment = rightValueAlignment;
    lblHeaderValue.numberOfLines = 0;
    lblHeaderValue.tag = 12;
    lblHeaderValue.textColor = [Styles themeLabelValueColor];
    
    
    [elementContainer addSubview:lblHeaderValue];
    
    //If this field value is use in Next Screen
    if([dotReportElement isUseForwardBool]) {
        [self.forwardedDataDisplay setObject:headerValue forKey:dotReportElement.elementId];
        [self.forwardedDataPost setObject:headerValue forKey:dotReportElement.elementId];
    }
    
    return elementContainer;
}


-(void)configureView:(UIView* )view forIndexPath:(NSIndexPath *)indexPath {
    UILabel *lblHeaderTitle = (UILabel*)[view viewWithTag:11];
    UILabel *lblHeaderValue = (UILabel*)[view viewWithTag:12];
    
    NSString *keyOfComp =  (NSString *) [headerElementIds objectAtIndex :indexPath.row];
    DotReportElement *dotReportElement = (DotReportElement *) [self.dotReport.reportElements objectForKey:keyOfComp];
    
    NSString *headerValue = [self.reportPostResponse.headerData objectForKey:keyOfComp];
    
    lblHeaderValue.text  = headerValue;
    lblHeaderTitle.text = dotReportElement.displayText;
}

@end
