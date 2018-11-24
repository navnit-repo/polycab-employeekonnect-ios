//
//  BusinessVerticalReportVC.m
//  XMWClient
//
//  Created by dotvikios on 19/09/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "BusinessVerticalReportVC.h"
#import "DVAppDelegate.h"
#import "LayoutClass.h"
@interface BusinessVerticalReportVC ()

@end

@implementation BusinessVerticalReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f*deviceWidthRation;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0 ) {
        return 0.0f;
    } else if(section==1) {
        return 30.0f;
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if(section==1) {
        UINib* headerNib = [UINib nibWithNibName:@"BusinessReportQuantityValueTableHeader" bundle:nil];
        
        UIView* view = [[headerNib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        [LayoutClass setLayoutForIPhone6:view];
        view.bounds = CGRectMake(0, 0, self.view.frame.size.width, 30.0f);
        
        
        UIView* lView = nil;
        UITapGestureRecognizer* tapGesture = nil;
        
        lView = [view viewWithTag:0];
        
        
        lView = [view viewWithTag:1];
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePeriodAction:)];
        [lView addGestureRecognizer:tapGesture];
        
        
        lView = [view viewWithTag:2];
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePeriodAction:)];
        [lView addGestureRecognizer:tapGesture];
        
        
        lView = [view viewWithTag:3];
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePeriodAction:)];
        [lView addGestureRecognizer:tapGesture];
        
        
        return view;
    } else {
        return nil;
    }
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if(section==1) {
 
        
        // for total labels
        UIView* totalRow = [view viewWithTag:20];
       // totalRow.backgroundColor = [UIColor colorWithRed:128.0/255 green:128.0/255 blue:128.0/255 alpha:1.0];
        
        UILabel* tZero =  (UILabel*)[totalRow viewWithTag:200];
        
        [LayoutClass labelLayout:tZero forFontWeight:UIFontWeightSemibold];
        
        tZero.text = @"LOB";
        tZero.textAlignment = NSTextAlignmentCenter;
      
        
        UILabel* tq =  (UILabel*)[totalRow viewWithTag:201];
        [LayoutClass labelLayout:tq forFontWeight:UIFontWeightSemibold];
        
        
        UILabel* tFirstQty =  (UILabel*)[totalRow viewWithTag:202];
        [LayoutClass labelLayout:tFirstQty forFontWeight:UIFontWeightSemibold];
        tFirstQty.text = @"FTD";
        tFirstQty.textAlignment = NSTextAlignmentCenter;
        
        
        UILabel* tSecondQty =  (UILabel*)[totalRow viewWithTag:203];
        [LayoutClass labelLayout:tSecondQty forFontWeight:UIFontWeightSemibold];
        tSecondQty.text = @"MTD";
        tSecondQty.textAlignment = NSTextAlignmentCenter;
        
       
        
        UILabel* tThirdQty =  (UILabel*)[totalRow viewWithTag:204];
        [LayoutClass labelLayout:tThirdQty forFontWeight:UIFontWeightSemibold];
        tThirdQty.text = @"YTD";
        tThirdQty.textAlignment = NSTextAlignmentCenter;
        
       
        
    }
    
}

-(void) handleDrilldown:(NSInteger) rowIndex
{
    if (self.forwardedDataDisplay == nil)
        self.forwardedDataDisplay   = [[NSMutableDictionary alloc] init];
    
    if (self.forwardedDataPost == nil)
        self.forwardedDataPost      = [[NSMutableDictionary alloc] init];
    
    
    // need to create three dotform post objects for each columns
    // which will be passed to next report
    // NSString* dataSetKey = [[dataSet allKeys] objectAtIndex:rowIndex];
    NSString* dataSetKey = [sortedDataSetKeys objectAtIndex:rowIndex];
    XmwCompareTupleQV* dataTuple = [dataSet objectForKey:dataSetKey];
    
    
    
       BusinessVerticalReportVC* ddCustomCompareReport = [[BusinessVerticalReportVC alloc] initWithNibName:@"ReportQuantityValue" bundle:nil];
 
    
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
    
    UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(0, 10, self.view.bounds.size.width, 40)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor: [UIColor blackColor]];
    [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [label setText: @"SALES REPORT"];
    
    [label setNumberOfLines: 0];
    [label sizeToFit];
    [label setCenter: CGPointMake(self.view.center.x, label.center.y)];
    [self.view addSubview:label];
}

@end
