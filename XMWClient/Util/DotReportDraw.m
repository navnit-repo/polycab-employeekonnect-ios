//
//  DotReportDraw.m
//  QCMSProject
//
//  Created by Ashish Tiwari on 24/07/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

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

@interface DotReportDraw ()
{
    int tableRowHeight;
    int tableHeaderHeight;
    int reportHeaderRowHeight;
}
@end


@implementation DotReportDraw

@synthesize dotReportElements,dotReport,reportPostResponse, reportVC;
@synthesize forwardedDataPost,forwardedDataDisplay;
@synthesize dotFormPost;

-(void)initReport : (DotReport*) in_DotReport : (ReportPostResponse*) in_ReportPostResponse
 {
     self.dotReport = in_DotReport;
     self.reportPostResponse = in_ReportPostResponse;
     self.dotReportElements = in_DotReport.reportElements;
     tableRowHeight = [DotReportListCellRenderer tableRowHeight];
     tableHeaderHeight = [DotReportListCellRenderer tableHeaderHeight];
     reportHeaderRowHeight = [DotReportListCellRenderer reportHeaderRowHeight];
}


-(void) makeLegends : (UIView *) container
{
   
        ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
        NSMutableDictionary *colorMap = (NSMutableDictionary *)[clientVariables.CLIENT_APP_MASTER_DATA objectForKey:dotReport.legendColorOn];
        NSMutableDictionary *nameMap = (NSMutableDictionary *)[clientVariables.CLIENT_APP_MASTER_DATA objectForKey:dotReport.legendNameOn];
        NSArray* nameKeys = [nameMap allKeys];
    
    CGRect screenRect = reportVC.view.bounds;
    CGFloat screenWidth = screenRect.size.width;

    
    int y_Rel = 0;
    
    CGSize  rightSize = [@"Other" boundingRectWithSize:CGSizeMake(screenWidth/2 - 10, 480) options: NSStringDrawingUsesLineFragmentOrigin attributes: @{ NSFontAttributeName: [UIFont systemFontOfSize:14] } context: nil].size;
    
    int leftLabelHeight = rightSize.height;
    
    int cellHeight = leftLabelHeight - 2;
    
        for (int cntIndex = 0; cntIndex<[nameKeys count]; cntIndex = cntIndex + 2)
        {
           // UIView *elementContainer = [[UIView alloc] init ];
            UIView *elementContainer = [[UIView alloc] initWithFrame:CGRectMake(0, y_Rel, screenWidth, leftLabelHeight) ];
            NSString* key = (NSString*) [nameKeys objectAtIndex: cntIndex];
            NSString *colorCode = [colorMap objectForKey:key];
            NSString *legendName = [nameMap objectForKey:key];
            UILabel* mItemLabel = [[UILabel alloc]initWithFrame:CGRectMake(2, 0, (screenWidth-cellHeight*2)/2 - 10, leftLabelHeight)];
            mItemLabel.text = legendName;
            [mItemLabel setFont:[UIFont systemFontOfSize:12]];
            
            [elementContainer addSubview:mItemLabel];
            
            UIView* legendCont = [[UIView alloc]initWithFrame:CGRectMake((screenWidth-cellHeight*2)/2 - 10, 1, cellHeight, cellHeight)];
            legendCont.backgroundColor = [XmwUtils colorWithHexString:colorCode];
            
            [elementContainer addSubview:legendCont];
            
            if( (cntIndex + 1) < [nameKeys count]) {
                
                NSString* key = (NSString*) [nameKeys objectAtIndex: (cntIndex+1)];
                NSString *colorCode = [colorMap objectForKey:key];
                NSString *legendName = [nameMap objectForKey:key];
                UILabel* mItemLabel = [[UILabel alloc]initWithFrame:CGRectMake((screenWidth/2) + 2, 0, (screenWidth-cellHeight*2)/2 - 10, leftLabelHeight)];
                mItemLabel.text = legendName;
                [mItemLabel setFont:[UIFont systemFontOfSize:12]];
                
                [elementContainer addSubview:mItemLabel];
                
                UIView* legendCont = [[UIView alloc]initWithFrame:CGRectMake(screenWidth-cellHeight - 10, 1, cellHeight, cellHeight)];
                legendCont.backgroundColor = [XmwUtils colorWithHexString:colorCode];
                
                [elementContainer addSubview:legendCont];

            }
            
            [container addSubview:elementContainer];
            y_Rel = y_Rel + leftLabelHeight;
        }
    
    // y_inc = y_inc + y_Rel - container.frame.size.height;
    
    [container setFrame:CGRectMake(0, screenRect.size.height - y_Rel, screenWidth, y_Rel) ];
    
   
}





-(void) makeReportScreen : (ReportVC*) in_ReportVC : (DotReport*) in_DotReport : (ReportPostResponse*) in_ReportPostResponse : (NSMutableDictionary *) forwardedDataDisplay : (NSMutableDictionary *)forwardedDataPost
{
    self.reportVC = in_ReportVC;
    
    
    // for iOS 7.0
    y_inc = 0;
    
    
   [self initReport : in_DotReport : in_ReportPostResponse];
    CGRect screenRect = reportVC.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    
    //this.baseForm = baseForm;
    UIView *headerContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    //
    // this one is for Havells Dealer Konnect, as they want legend should be bottom aligned
    //
    UIView *legendContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    UIView *tableContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 30)];
    UIView *subHeaderContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    UIView *footerContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    NSMutableArray *placeVector = [XmwUtils breakStringTokenAsVector : dotReport.reportPlaces : @"$"];
    BOOL legendAdded = NO;
    
    for (int cntComponentPlace = 0; cntComponentPlace < [placeVector count]; cntComponentPlace++)
    {
        NSString *componentPlace = (NSString*) [placeVector objectAtIndex:cntComponentPlace];
      
        NSMutableArray *sortedElementId =[DotReportDraw sortRptComponents : dotReport.reportElements : componentPlace];
       if([componentPlace isEqualToString : XmwcsConst_REPORT_PLACE_HEADER])
        {
            [self drawHeader : sortedElementId : headerContainer : forwardedDataDisplay :forwardedDataPost];
            [reportVC.view addSubview : headerContainer];
        }
        else if([componentPlace isEqualToString : XmwcsConst_REPORT_PLACE_TABLE])
        {
           if([dotReport.reportType isEqualToString:XmwcsConst_REPORT_TYPE_LEGEND])
            {
               // [self  makeLegends : headerContainer];
               //  legendContainer.backgroundColor = [UIColor redColor];
                [reportVC.view addSubview:legendContainer];
                [self  makeLegends : legendContainer];
                legendAdded = YES;
            }
            [self drawTable : sortedElementId : tableContainer : legendAdded : legendContainer.frame.size.height];
            // [tableContainer setBackgroundColor:[UIColor redColor]];
            [reportVC.view addSubview : tableContainer];
        }
        else if([componentPlace isEqualToString : XmwcsConst_REPORT_PLACE_FOOTER ])
        {
            [self drawFooter:sortedElementId :footerContainer];
            [reportVC.view addSubview : footerContainer];
        }
        else if([componentPlace isEqualToString :XmwcsConst_REPORT_PLACE_SUBHEADER ])
        {
            [self drawSubHeader : subHeaderContainer];
            [reportVC.view addSubview : subHeaderContainer];
            
            
        }
    }
    
    // we need to reduce height of table container if legend container is also there
    if(legendAdded) {
        tableContainer.frame = CGRectMake(tableContainer.frame.origin.x, tableContainer.frame.origin.y, tableContainer.frame.size.width, tableContainer.frame.size.height - legendContainer.frame.size.height);
    }
}

-(void) drawHeader : (NSMutableArray *) sortedElementIds :(UIView *) headerContainer : (NSMutableDictionary*) forwardedDataDisplay : (NSMutableDictionary *) forwardedDataPost
{
    
    NSMutableDictionary * headerData = reportPostResponse.headerData;
    CGRect screenRect = reportVC.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    
    // int lable_headertext_height;
    int y_Rel = 0;
    for(int cntHeaderComp = 0;cntHeaderComp < [sortedElementIds count];cntHeaderComp++)
    {
        NSString *keyOfComp =  (NSString *) [sortedElementIds objectAtIndex :cntHeaderComp];
        DotReportElement *dotReportElement = (DotReportElement *) [dotReportElements objectForKey:keyOfComp];
        
    
        CGSize  leftSize = [dotReportElement.displayText boundingRectWithSize:CGSizeMake(screenWidth/2 - 10, 480) options: NSStringDrawingUsesLineFragmentOrigin attributes: @{ NSFontAttributeName: [UIFont systemFontOfSize:14] } context: nil].size;
        
        int leftLabelHeight = leftSize.height + 1;
        
        NSString *headerValue = @"";
        if((dotReportElement.valueDependOn !=nil) && [forwardedDataDisplay objectForKey:dotReportElement.valueDependOn]!=nil) {
            headerValue = (NSString*) [forwardedDataDisplay objectForKey:dotReportElement.valueDependOn];
        } else {
            headerValue =  (NSString*) [headerData objectForKey:dotReportElement.elementId];
        }
        
        if(headerValue == nil) {
            headerValue = @"";
        }
        
        //
        // special handling, as in this case data won't be coming from server
        //
        if([dotReportElement.componentType isEqualToString:XmwcsConst_DRE_COLUMN_TYPE_CURRENT_DATE_TIME]) {
            NSDate* currentDate = [NSDate date];
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
            NSString *dateString = [dateFormatter stringFromDate:currentDate];
            headerValue = dateString;
        }
        
        
        if([headerValue isEqualToString:@""] && ![dotReportElement.defaultVal isEqualToString:@""]) {
            headerValue = dotReportElement.defaultVal;
        }
        
        CGSize  rightSize = [headerValue boundingRectWithSize:CGSizeMake(screenWidth/2 - 10, 480) options: NSStringDrawingUsesLineFragmentOrigin attributes: @{ NSFontAttributeName: [UIFont systemFontOfSize:14] } context: nil].size;
        int rightLabelHeight = rightSize.height + 1;
        
        if(leftLabelHeight< rightLabelHeight) {
            lable_text_height = rightLabelHeight;
        } else {
            lable_text_height = leftLabelHeight;
        }
        
        UIView *elementContainer = [[UIView alloc] initWithFrame:CGRectMake(0, y_Rel, screenWidth, lable_text_height) ];
        
         UILabel *lblHeaderTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, screenWidth/2 - 10, leftLabelHeight)];
         lblHeaderTitle.text = dotReportElement.displayText;
        lblHeaderTitle.numberOfLines = 0;
        lblHeaderTitle.textAlignment = NSTextAlignmentLeft;
        [lblHeaderTitle setFont:[UIFont systemFontOfSize:14]];
       
         [elementContainer addSubview:lblHeaderTitle];
    
         UILabel *lblHeaderValue = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2, 0, screenWidth/2 - 10, lable_text_height)];
        [lblHeaderValue setFont:[UIFont systemFontOfSize:14]];
        lblHeaderValue.text  = headerValue;
        lblHeaderValue.numberOfLines = 0;
        lblHeaderValue.textAlignment = NSTextAlignmentRight;
        
        
        [elementContainer addSubview:lblHeaderValue];
         y_Rel = y_Rel + lable_text_height;
       
        //If this field value is use in Next Screen
        if([dotReportElement isUseForwardBool]) {
            [forwardedDataDisplay setObject:headerValue forKey:dotReportElement.elementId];
            [forwardedDataPost setObject:headerValue forKey:dotReportElement.elementId];
        }
       [headerContainer addSubview:elementContainer];
    }
    
    [headerContainer setFrame:CGRectMake(0, y_inc, screenWidth, y_Rel) ];
    y_inc = y_inc + y_Rel;
}


-(void) drawTable : (NSMutableArray *) sortedElementIds : (UIView *) tableContainer :(BOOL) isLegend :(int) legendAdjustment
{
    NSMutableArray *records = reportPostResponse.tableData;
    CGRect screenRect = reportVC.view.bounds;

    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    if(records == nil)
    {
        UILabel *lblNoRecord = [[MXLabel alloc]init];
        lblNoRecord.text = @"record not found";
               
        [tableContainer addSubview:lblNoRecord];
        
        return ;
    }
    NSMutableArray *returnMap = [self drawTableHeader : sortedElementIds : tableContainer];
    
    
    dotReportListRenderer = [[DotReportListCellRenderer alloc] init];
    dotReportListRenderer.recordTableData = reportPostResponse.tableData;
    dotReportListRenderer.cellComponent = returnMap;//elementType
    dotReportListRenderer.dotReortdrawProp = self;
    dotReportListRenderer.dotReport = dotReport;
    
    screenHeight = reportVC.view.bounds.size.height - y_inc;
    if(isLegend) {
        screenHeight = screenHeight - legendAdjustment;
    }

    /*
    if([records count]>10) {
        screenHeight = 30*10;
    } else {
        screenHeight = 30*[records count];
    }*/
    
    if(tableRowHeight*[records count] < screenHeight) {
        screenHeight = tableRowHeight*[records count];
    }
    
    
    tableList = [[UITableView alloc]initWithFrame:CGRectMake(0, tableHeaderHeight, screenWidth, screenHeight) style:UITableViewStylePlain];
          
    //[tableList setBackgroundColor:[UIColor greenColor]];
   // [tableList setDelegate:reportVC];
    [tableList setDelegate:dotReportListRenderer];
    [tableList setDataSource:dotReportListRenderer];
    [tableContainer addSubview:tableList];//added
    //[reportVC.view addSubview:tableList];
    
    [tableContainer setFrame:CGRectMake(0, y_inc - tableHeaderHeight, screenWidth, screenHeight + tableHeaderHeight)];
    
    y_inc = y_inc + screenHeight;
    
   }


-(NSMutableArray *) drawTableHeader : (NSMutableArray *) sortedElementIds : (UIView *) tableContainer
{
    int screenWidth = reportVC.view.bounds.size.width;
   UIView *tableHeaderContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, tableHeaderHeight) ];
    NSMutableDictionary *columnLengthMap = [[NSMutableDictionary alloc]init];
    
    NSMutableArray *elementId = [[NSMutableArray alloc]init];
    NSMutableArray *headerElementId = [[NSMutableArray alloc]init];
    
    NSMutableArray *elementType = [[NSMutableArray alloc]init];
    NSMutableArray *elementDisplay = [[NSMutableArray alloc]init];
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
                 || ([dotReportElement.componentType isEqualToString:XmwcsConst_DRE_COLUMN_TYPE_COLOR_CLICK])
                 || ([dotReportElement.componentType isEqualToString:XmwcsConst_DRE_COLUMN_TYPE_URL])    ))
               
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
    //start calculate tableheader column width
    // need to calculate column width normalization when total percentage is not 100% then we need to extrapolate to 100%
    // 76  ---- 18
    // 1 - 18/76
    // 100 - 18*100/totalPer
    int totalPerc = 0;
   // QStringList lengthKeys = columnLengthMap->keys();
    NSArray* lengthKeys = [columnLengthMap allKeys];
    //for (int cntTableColumn = 0; cntTableColumn < lengthKeys.count(); cntTableColumn++)
    for(int cntTableColumn = 0; cntTableColumn < [lengthKeys count]; cntTableColumn++)
    {
		NSString* tempLen = [columnLengthMap objectForKey:[lengthKeys objectAtIndex:cntTableColumn]];//columnLengthMap->value(lengthKeys.at(cntTableColumn));
		totalPerc = totalPerc + [tempLen intValue];// tempLen.toInt();
    }
    //end
    
    float xCord, width,hight;
    
    NSInteger elementDisplayNo = [elementDisplay count];
    xCord =0.0;
    
    width =screenWidth/elementDisplayNo; //98;
    hight = tableHeaderHeight;
    
    [tableHeaderContainer setBackgroundColor:[UIColor blackColor]];
    for (int cntTableColumn = 0; cntTableColumn < [elementDisplay count]; cntTableColumn++)
    {
        //start calculate tableheader column width
        NSString* tempLen = [columnLengthMap objectForKey:[headerElementId objectAtIndex:cntTableColumn]];//columnLengthMap->value(headerElementId->at(cntTableColumn));
       // qDebug() << "Column Width = " << tempLen;
        NSLog(@"column Width = tempLen");
        int normalized = 100/[headerElementId count];//(headerElementId->count());
        if(totalPerc!=0) {
        	normalized = [tempLen intValue]*100/totalPerc;//tempLen.toInt()*100/totalPerc;
            NSLog(@"normalized value = @%d",normalized);
        }
        
        float columnWidth = screenWidth * normalized / 100;
        NSLog(@"column width = @%f",columnWidth);
        
        //end
        
        UIView *header = [[UIView alloc]initWithFrame:CGRectMake(xCord, 0, columnWidth , hight)];
        UILabel *labelHeader = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, columnWidth, hight)];
        labelHeader.text = [elementDisplay objectAtIndex:cntTableColumn];
        labelHeader.numberOfLines = 0;
        labelHeader.backgroundColor = [UIColor lightGrayColor];
        [header addSubview:labelHeader];
        [labelHeader setFont:[UIFont systemFontOfSize:14]];
        //[header setBackgroundColor:[UIColor yellowColor]];
        [tableHeaderContainer addSubview:header];
        xCord = xCord + columnWidth;
        
            
    }
      
   //[tableHeaderContainer setBackgroundColor:[UIColor redColor]];
    [tableContainer addSubview:tableHeaderContainer];
    NSMutableArray *returnMap = [[NSMutableArray alloc]init];
    [returnMap addObject:elementType];
    [returnMap addObject:columnLengthMap];
    [returnMap addObject:elementId];
    [returnMap addObject:headerElementId];
    
    y_inc = y_inc + tableHeaderHeight;
    return returnMap;
   
}
 
+(NSMutableArray *) sortRptComponents : (NSMutableDictionary *) dotReportElements : (NSString *) placeType
{
    
    NSArray* keyElement = [dotReportElements allKeys];
    
    NSMutableArray *componentIdVec = [[NSMutableArray alloc]init];
    NSMutableArray *componentPositionVec = [[NSMutableArray alloc]init];
   
    for (int cntIndex = 0; cntIndex<[keyElement count]; cntIndex++)
    {
       
         NSString* key = (NSString*) [keyElement objectAtIndex: cntIndex];
        DotReportElement *dotReportElement = (DotReportElement *)[dotReportElements objectForKey:key];
        
       if(([dotReportElement isComponentDisplayBool]) && [dotReportElement.place isEqualToString:placeType])
        {
            [componentIdVec addObject:key];
            [componentPositionVec addObject:dotReportElement.elementPosition];
        }
    }
    
    [XmwUtils sortListOnPosition: componentIdVec : componentPositionVec];
    
    
    return componentIdVec;
    
}
        
       
        
-(void) drawFooter : (NSMutableArray *) sortedElementIds : (UIView *) footerContainer
{
    
    for (int cntHeaderComp = 0; cntHeaderComp < [sortedElementIds count]; cntHeaderComp++)
    {
        NSString *keyOfComp = (NSString *) [sortedElementIds objectAtIndex :cntHeaderComp];
        DotReportElement *dotReportElement = (DotReportElement*) [dotReportElements objectForKey:keyOfComp];
        NSMutableDictionary *footerGetData = reportPostResponse.footerData;
        if([dotReportElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_BUTTON])
        {           
            [self drawButtonFooter:dotReportElement :footerContainer :[footerGetData objectForKey:dotReportElement.elementId]];
        }
        else
        {
            [self drawFooterTextField : dotReportElement : footerContainer : footerGetData];
        }
    }
    
    
}

-(void)drawSubHeader : (UIView *) subHeaderContainer
{
    CGRect screenRect = reportVC.view.bounds;
    CGFloat screenWidth = screenRect.size.width;

    int y_Rel = 0;
    
    NSMutableArray *subHeaderData = reportPostResponse.subHeaderData;
    if (subHeaderData != nil)
    {
        
        CGSize  leftSize = [@"Other" boundingRectWithSize:CGSizeMake(screenWidth/2 - 10, 480) options: NSStringDrawingUsesLineFragmentOrigin attributes: @{ NSFontAttributeName: [UIFont systemFontOfSize:14] } context: nil].size;
        
        int leftLabelHeight = leftSize.height;
       
        for (int cntSubHeader = 0; cntSubHeader<[subHeaderData count]; cntSubHeader++)
        {
            int x = 0;
            
            NSMutableArray* record =  (NSMutableArray*)[subHeaderData objectAtIndex:cntSubHeader];//subHeaderData.at(cntSubHeader).toList();
            UIView *elementContainer = [[UIView alloc] initWithFrame:CGRectMake(0, y_Rel, screenWidth, leftLabelHeight) ];
          
            for(int cntReord = 0; cntReord < [record count]; cntReord++)
            {
                UILabel *child = [[UILabel alloc] initWithFrame:CGRectMake(x+2, 0, screenWidth/2, leftLabelHeight)];
                child.text = [record objectAtIndex:cntReord];
                [child setFont:[UIFont systemFontOfSize:12]];
                child.numberOfLines = 0;
                
               [elementContainer addSubview:child];
                x = x + screenWidth/2;
            }
            y_Rel = y_Rel + lable_text_height-10;
            [subHeaderContainer addSubview:elementContainer];
        }
        
        [subHeaderContainer setFrame:CGRectMake(0, y_inc, screenWidth, y_Rel) ];
        
        y_inc = y_inc + y_Rel ;
      
    }
     
    
       
}
-(void) drawButtonFooter : (DotReportElement *) dotReportElement : (UIView *) footerCont : (NSMutableDictionary *) footerGetData
{
    
    //int y_inc = 270;
    if ((footerGetData != nil) && ([footerGetData count] > 0))
      {
        NSArray*  enumKey = [footerGetData allKeys];
        
       for (int cntIndex = 0; cntIndex<[enumKey count]; cntIndex++)
       {
            NSString* keyOfMap = (NSString*) [enumKey objectAtIndex: cntIndex];
            NSString *valueOfMap = (NSString*)[footerGetData objectForKey:keyOfMap];
           NSString* buttonId = dotReportElement.elementId;
           buttonId = [buttonId stringByAppendingString:@":"];
           buttonId = [buttonId stringByAppendingString:keyOfMap];
           
           
           UIImage *blueImage          = [UIImage imageNamed:@"blueButton.png"];
           UIImage *blueButtonImage    = [blueImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
           MXButton *dotButton       = [MXButton buttonWithType:UIButtonTypeRoundedRect];
           [dotButton setFrame:CGRectMake(72,y_inc,180,36)]; //72.0f, 220.0f, 180.0f, 36.0f)];
           [dotButton setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
           [dotButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] forState: UIControlStateNormal];
           [dotButton setTitle:valueOfMap forState:UIControlStateNormal];
           [dotButton addTarget: self.reportVC action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
           dotButton.attachedData = keyOfMap;
           dotButton.elementId = buttonId;
           y_inc = y_inc+45;
           [footerCont addSubview:dotButton];
        }
    } else {
       // DotButton dotButton = new DotButton(dotReportElement.getDisplayText(), dotReportElement.getElementId(), dotReportElement.getDataType());
        NSString *btnDisplayText = dotReportElement.displayText;
        UIImage *blueImage          = [UIImage imageNamed:@"blueButton.png"];
        UIImage *blueButtonImage    = [blueImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
        MXButton *dotButton       = [MXButton buttonWithType:UIButtonTypeRoundedRect];
        [dotButton setFrame:CGRectMake( 72.0f, y_inc, 180.0f, 36.0f)];
        [dotButton setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
        [dotButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] forState: UIControlStateNormal];
        [dotButton setTitle:btnDisplayText forState:UIControlStateNormal];
        [dotButton addTarget: self.reportVC action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        dotButton.elementId = dotReportElement.elementId;
        dotButton.attachedData = dotReportElement.elementId;

         [footerCont addSubview:dotButton];
        
    }
      
}
-(void) drawFooterTextField : (DotReportElement *) dotReportElement : (UIView *) footerCont : (NSMutableDictionary *) footerGetData
{
    CGRect screenRect = reportVC.view.bounds;
    CGFloat screenWidth = screenRect.size.width;

    MXLabel *dotLabel = [[MXLabel alloc]initWithFrame:CGRectMake(10, y_inc/*200*/, screenWidth/2 - 10 , 30)];
    dotLabel.text = dotReportElement.displayText;
    dotLabel.numberOfLines = 0;
    [dotLabel setFont:[UIFont systemFontOfSize:14]];
    [footerCont addSubview:dotLabel];
    
    if([dotReportElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_TEXTFIELD])
    {
        MXTextField *dotTextField = [[MXTextField alloc]initWithFrame:CGRectMake(screenWidth/2, y_inc/*200*/, screenWidth/2 - 10 , 60)];
        
        dotTextField.backgroundColor=[UIColor whiteColor];
        dotTextField.layer.borderColor = [UIColor redColor].CGColor;
        dotTextField.delegate		= self.reportVC;
        dotTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        dotTextField.userInteractionEnabled = YES;
        dotTextField.tag = TAG_KEY_REMARK_TEXTFIELD;
        [dotTextField setFont:[UIFont systemFontOfSize:14]];
        [footerCont addSubview:dotTextField];

        y_inc = y_inc + 60;

    }
    else if([dotReportElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_TEXTAREA])
    {
        MXTextField *dotTextField = [[MXTextField alloc]initWithFrame:CGRectMake(screenWidth/2, y_inc /*200*/, screenWidth/2 - 10 , 60)];
        dotTextField.backgroundColor=[UIColor whiteColor];
        dotTextField.layer.borderColor = [UIColor redColor].CGColor;
        dotTextField.delegate		= self.reportVC;
        dotTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        dotTextField.userInteractionEnabled = YES;
        dotTextField.tag = TAG_KEY_REMARK_TEXTFIELD;
        [dotTextField setFont:[UIFont systemFontOfSize:14]];
        
        [footerCont addSubview:dotTextField];
        y_inc = y_inc + 60;

              
    }
    else if([dotReportElement.componentType isEqualToString: XmwcsConst_DE_COMPONENT_LABEL])
      
    {
        MXLabel *dotlable1 = [[MXLabel alloc]initWithFrame:CGRectMake(screenWidth/2, y_inc/*200*/, screenWidth/2 - 10 , 30)];
        // dotlable1.backgroundColor = [UIColor whiteColor];
        dotlable1.text = [footerGetData objectForKey:dotReportElement.elementId];
        dotlable1.numberOfLines = 0;
        dotlable1.textAlignment = NSTextAlignmentRight;
        [footerCont addSubview:dotlable1];
        [dotlable1 setFont:[UIFont systemFontOfSize:14]];
        y_inc = y_inc + 30;

    }
    
    //[footerCont addSubview:elementContainer];
    
}
-(void) handleDrillDown : (NSInteger) position :(NSMutableDictionary *) in_forwardedDataDisplay :(NSMutableDictionary *) in_forwardedDataPost
{
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

    
    self.dotFormPost = dotFormPost;
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
        [[self.reportVC navigationController] pushViewController:offlineReportVC  animated:YES];
    }
    
}

- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    
    if ([callName isEqualToString : XmwcsConst_CALL_NAME_FOR_REPORT])
    {
        ReportPostResponse *reportPostResponse = (ReportPostResponse*) respondedObject;
        ReportVC *reportVC = [[ReportVC alloc] initWithNibName:REPORTVC bundle:nil];
        reportVC.screenId = AppConst_SCREEN_ID_REPORT;
        reportVC.reportPostResponse = reportPostResponse;
        reportVC.forwardedDataDisplay = forwardedDataDisplay;
        reportVC.forwardedDataPost =  forwardedDataPost;
       [[self.reportVC navigationController] pushViewController:reportVC  animated:YES];
        
    }
    if([callName isEqualToString : XmwcsConst_CALL_NAME_FOR_SUBMIT])
    {
        DocPostResponse* docResponse = (DocPostResponse*) respondedObject;
		NSString* serverMessage = docResponse.submittedMessage;//docResponse->getSubmittedMessage();
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Server Response" message: serverMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        [myAlertView show];
        
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Ok"])
    {
        NetworkHelper *networkHelper = [[NetworkHelper alloc] init];
        [networkHelper makeXmwNetworkCall:dotFormPost :self : nil :  XmwcsConst_CALL_NAME_FOR_SUBMIT];
    }
    else if([title isEqualToString:@"Cancel"])
    {
           
    }
    
    
}




@end
