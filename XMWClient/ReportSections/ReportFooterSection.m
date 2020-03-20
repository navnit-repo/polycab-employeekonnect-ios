//
//  ReportFooterSection.m
//  QCMSProject
//
//  Created by Pradeep Singh on 7/27/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//

#import "ReportFooterSection.h"
#import "XmwcsConstant.h"
#import "DotReportDraw.h"
#import "MXButton.h"
#import "MXLabel.h"
#import "MXTextField.h"
#import "TagKeyConstant.h"





@interface ReportFooterSection ()
{
    NSArray* sortedElementIds;
    NSMutableDictionary* reportElements;
    NSMutableArray *cellComponent;
    NSMutableArray *recordTableData;
}

@end


@implementation ReportFooterSection


-(id)init {
    self = [super init];
    if (self) {
        self.componentPlace = XmwcsConst_REPORT_PLACE_FOOTER;
    }
    return self;
}


-(void) updateData:(DotReport *)inDotReport :(ReportPostResponse *)inReportPostResponse
{
    [super updateData:inDotReport :inReportPostResponse];
    
    reportElements = self.dotReport.reportElements;
    
    sortedElementIds = [DotReportDraw sortRptComponents : self.dotReport.reportElements : self.componentPlace];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *keyOfComp = (NSString *) [sortedElementIds objectAtIndex :indexPath.row];
    DotReportElement *dotReportElement = (DotReportElement*) [reportElements objectForKey:keyOfComp];
    NSMutableDictionary *footerGetData = self.reportPostResponse.footerData;
    
    if([dotReportElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_BUTTON])
    {
        if ((footerGetData != nil) && ([footerGetData count] > 0))
        {
            return [footerGetData count]*45.0f;
        } else {
            return 45.0f;
        }
    } else {
        return 60.0f;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FooterDataSectionCell"];
    if(cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"FooterDataSectionCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView* customView = [cell.contentView viewWithTag:4001];
    if(customView!=nil) {
        [customView removeFromSuperview];
    }
    
    customView = [self viewForCellAtIndexPath:indexPath];
    customView.tag = 4001;
    [cell.contentView addSubview:customView];
}


-(UIView *)viewForCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *keyOfComp = (NSString *) [sortedElementIds objectAtIndex :indexPath.row];
    DotReportElement *dotReportElement = (DotReportElement*) [reportElements objectForKey:keyOfComp];
    NSMutableDictionary *footerGetData = self.reportPostResponse.footerData;
    
    if([dotReportElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_BUTTON])
    {
        return [self drawButtonFooter:dotReportElement :[footerGetData objectForKey:dotReportElement.elementId]];
    }
    else
    {
        return [self drawFooterTextField : dotReportElement : footerGetData];
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [sortedElementIds count];
}


-(UIView*) drawButtonFooter : (DotReportElement *) dotReportElement : (NSMutableDictionary *) footerGetData
{
    int screenWidth = self.tableView.frame.size.width;

    UIView* footerCont = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 45)];
    footerCont.backgroundColor = [[UIColor alloc] initWithRed:255.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
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
            [dotButton setFrame:CGRectMake(72, 5, 180, 36)]; //72.0f, 220.0f, 180.0f, 36.0f)];
            [dotButton setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
            [dotButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] forState: UIControlStateNormal];
            [dotButton setTitle:valueOfMap forState:UIControlStateNormal];
            [dotButton addTarget: self.reportVC action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            dotButton.attachedData = keyOfMap;
            dotButton.elementId = buttonId;
            [footerCont addSubview:dotButton];
        }
    } else {
        // DotButton dotButton = new DotButton(dotReportElement.getDisplayText(), dotReportElement.getElementId(), dotReportElement.getDataType());
        NSString *btnDisplayText = dotReportElement.displayText;
        UIImage *blueImage          = [UIImage imageNamed:@"blueButton.png"];
        UIImage *blueButtonImage    = [blueImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
        MXButton *dotButton       = [MXButton buttonWithType:UIButtonTypeRoundedRect];
        [dotButton setFrame:CGRectMake( 72.0f, 5, 180.0f, 36.0f)];
        [dotButton setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
        [dotButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] forState: UIControlStateNormal];
        [dotButton setTitle:btnDisplayText forState:UIControlStateNormal];
        [dotButton addTarget: self.reportVC action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        dotButton.elementId = dotReportElement.elementId;
        dotButton.attachedData = dotReportElement.elementId;
        
        [footerCont addSubview:dotButton];
        
    }
    
    return footerCont;
    
}

-(UIView*) drawFooterTextField : (DotReportElement *) dotReportElement  : (NSMutableDictionary *) footerGetData
{
    int screenWidth = self.tableView.frame.size.width;
    UIView* footerCont = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 60)];
    footerCont.backgroundColor = [[UIColor alloc] initWithRed:255.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
    
    MXLabel *dotLabel = [[MXLabel alloc]initWithFrame:CGRectMake(5, 5, screenWidth/4-5 , 30)];
    dotLabel.text = dotReportElement.displayText;
    [dotLabel setFont:[UIFont systemFontOfSize:12]];
    [footerCont addSubview:dotLabel];
    
    if([dotReportElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_TEXTFIELD])
    {
        MXTextField *dotTextField = [[MXTextField alloc]initWithFrame:CGRectMake(screenWidth/4, 5, 225 , 50)];
        
        dotTextField.backgroundColor=[UIColor whiteColor];
        dotTextField.layer.borderColor = [UIColor redColor].CGColor;
        dotTextField.delegate		= self.reportVC;
        dotTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        dotTextField.userInteractionEnabled = YES;
        dotTextField.tag = TAG_KEY_REMARK_TEXTFIELD;
        [dotTextField setFont:[UIFont systemFontOfSize:12]];
        [footerCont addSubview:dotTextField];
    }
    else if([dotReportElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_TEXTAREA])
    {
        MXTextField *dotTextField = [[MXTextField alloc]initWithFrame:CGRectMake(screenWidth/4, 5 , 225 , 50)];
        dotTextField.backgroundColor=[UIColor whiteColor];
        dotTextField.layer.borderColor = [UIColor redColor].CGColor;
        dotTextField.delegate		= self.reportVC;
        dotTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        dotTextField.userInteractionEnabled = YES;
        dotTextField.tag = TAG_KEY_REMARK_TEXTFIELD;
        [dotTextField setFont:[UIFont systemFontOfSize:12]];
        
        [footerCont addSubview:dotTextField];
    }
    else if([dotReportElement.componentType isEqualToString: XmwcsConst_DE_COMPONENT_LABEL])
        
    {
        MXLabel *dotlable1 = [[MXLabel alloc]initWithFrame:CGRectMake(screenWidth/4, 5, 225 , 30)];
        dotlable1.backgroundColor = [UIColor whiteColor];
        [footerCont addSubview:dotlable1];
        [dotlable1 setFont:[UIFont systemFontOfSize:12]];
    }
    
    return footerCont;
    
}
@end
