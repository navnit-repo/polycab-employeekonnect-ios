//
//  GrowthIndicatorReportVC.m
//  XMWClient
//
//  Created by Pradeep Singh on 21/09/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "GrowthIndicatorReportVC.h"
#import "DotFormPost.h"
#import "DotFormPostUtil.h"
#import "Styles.h"
#import "GrowthIndicatorTableCell.h"
#import "LayoutClass.h"

#import "DVAppDelegate.h"
#import "ClientVariable.h"

@interface GrowthIndicatorReportVC () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation GrowthIndicatorReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if (isiPhoneXSMAX) {
        self.view.frame = CGRectMake(0, 64, 414, 832);
    }
    else if(isiPhoneXR) {
        self.view.frame = CGRectMake(0, 64, 414, 832);
    }
    
    else if(isiPhoneXS) {
        self.view.frame = CGRectMake(0, 64, 375, 748);
    }
    else if(isiPhone10) {
        self.view.frame = CGRectMake(0, 64, 375, 748);
    }
    
    else if(isiPhone6Plus) {
        self.view.frame = CGRectMake(0, 64, 414, 672);
    }
    else if(isiPhone6) {
        self.view.frame = CGRectMake(0, 64, 375, 600);
    } else if(isiPhone5) {
        self.view.frame = CGRectMake(0, 64, 320, 504);
    } else {
        // 0, 64, 320, 416
        self.view.frame = CGRectMake(0, 64, 320, 416);
    }
    
    
    [LayoutClass setLayoutForIPhone6:self.mainTable];
    self.mainTable.dataSource = self;
    self.mainTable.delegate = self;
    
    [self.mainTable registerNib:[UINib nibWithNibName:@"GrowthIndicatorTableCell" bundle:nil] forCellReuseIdentifier:@"GrowthIndicatorTableCell"];
    
    
     // [self drawHeaderItem];
    
}

/*
-(void) drawHeaderItem
{
    //    self.title = self.dotForm.screenHeader;
    //
    //    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
    //                                                                   style:UIBarButtonItemStyleBordered
    //                                                                  target:self
    //                                                                  action:@selector(backHandler:)];
    //    backButton.tintColor = [Styles barButtonTextColor];
    //    [self.navigationItem setLeftBarButtonItem:backButton];
    //
    //    [self drawTitle: self.dotForm.screenHeader];
    
    
    self.navigationController.navigationBar.translucent = NO;
    UIButton *leftMenuButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftMenuButton setFrame:CGRectMake( 0.0f, 0.0f, 40.0f, 40.0f)];
    [leftMenuButton setImage:[UIImage imageNamed:@"new_back_arrow"] forState:UIControlStateNormal];
    [leftMenuButton addTarget:self action:@selector(backHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftMenuButton];
    leftButtonItem.target           = self;
    leftButtonItem.tintColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"new_logo"]];
    [imageView setFrame:CGRectMake( 0.0f, 0.0f, 40.0f, 40.0f)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIBarButtonItem *imageViewButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    imageViewButtonItem.target           = self;
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:leftButtonItem, imageViewButtonItem, nil] animated:YES];
    
    
    // For Right side menu button
    
    UIButton *notificationButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [notificationButton setFrame:CGRectMake( 0.0f, 0.0f, 18.0f, 18.0f)];
    [notificationButton setBackgroundImage:[UIImage imageNamed:@"new_notification"] forState:UIControlStateNormal];
    [notificationButton addTarget:self action:@selector(notificationButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *notificationButtonItem = [[UIBarButtonItem alloc] initWithCustomView:notificationButton];
    notificationButtonItem.target           = self;
    notificationButtonItem.tintColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
    
    UIButton *searchButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setFrame:CGRectMake( 0.0f, 0.0f, 18.0f, 18.0f)];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"new_search"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    searchButtonItem.target           = self;
    searchButtonItem.tintColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
    
    UIButton *moreAppsButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreAppsButton setFrame:CGRectMake( 0.0f, 0.0f, 18.0f, 18.0f)];
    [moreAppsButton setBackgroundImage:[UIImage imageNamed:@"new_more-apps"] forState:UIControlStateNormal];
    [moreAppsButton addTarget:self action:@selector(moreAppsButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *moreAppsButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreAppsButton];
    moreAppsButtonItem.target           = self;
    moreAppsButtonItem.tintColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
    
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:moreAppsButtonItem, searchButtonItem,notificationButtonItem, nil] animated:YES];
    
    
    // [self drawTitle: self.dotForm.screenHeader];
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
       
    DotReport* dotReport = [clientVariables.DOT_REPORT_MAP objectForKey:self.firstFormPost.adapterId];

    [self drawTitle: dotReport.screenHeader];
    
}
 */



-(void)notificationButtonHandler: (id) sender
{
    //pending works
}
-(void)searchButtonHandle: (id) sender
{
    //pending works
}
-(void)moreAppsButtonHandle: (id) sender
{
    //pending works
}

- (void) backHandler : (id) sender {
    [ [self navigationController]  popViewControllerAnimated:YES];
    
    // if( self.screenId==XmwcsConst_WorkflowMainScreen) {
    //    [DVAppDelegate popModuleContext];
    // }
}

/*
-(void) drawTitle:(NSString *)headerStr
{
    //    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
    //                                    [UIColor whiteColor],NSForegroundColorAttributeName,
    //                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    //
    //    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    //    // self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    //    self.navigationController.navigationBar.translucent = NO;
    //
    //    UILabel*  titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
    //    titleLabel.text = headerStr;
    //    titleLabel.textColor = [Styles headerTextColor];
    //    titleLabel.textAlignment = NSTextAlignmentCenter;
    //    titleLabel.backgroundColor = [UIColor clearColor];
    //    [self.navigationItem setTitleView: titleLabel];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(16, 10, 288, 35)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor: [UIColor blackColor]];
    [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [label setText: headerStr ];
    [label setNumberOfLines: 0];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [LayoutClass labelLayout:label forFontWeight:UIFontWeightBold];
    
    CGSize maximumLabelSize = CGSizeMake(label.frame.size.width, FLT_MAX);
    CGSize expectedLabelSize = [label.text sizeWithFont:label.font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    
    if (label.frame.size.height<expectedLabelSize.height) {
        CGRect updatedFrame = label.frame;
        updatedFrame.size.height = expectedLabelSize.height;
        label.frame = updatedFrame;
    }
    
    //[label setCenter: CGPointMake(self.view.center.x, label.center.y)];
    [self.view addSubview:label];
    
    
    
    self.mainTable.frame = CGRectMake(0, label.frame.origin.y + label.frame.size.height +5, self.view.frame.size.width, self.view.frame.size.height-(label.frame.origin.y + label.frame.size.height +5));
    
}
 */




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


#pragma mark - UITableViewDelegate

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1) {
        // NSString* key = [dataSet.allKeys objectAtIndex:indexPath.row];
        
        NSString* key = [sortedDataSetKeys objectAtIndex:indexPath.row];
        XmwCompareTuple* tuple = [dataSet objectForKey:key];
        
        GrowthIndicatorTableCell* rowCell = (GrowthIndicatorTableCell*) cell;
        
        rowCell.fieldLabel.text = tuple.fieldName;
        rowCell.firstLabel.text = tuple.firstValue;
        rowCell.secondLabel.text = tuple.secondValue;
        rowCell.thirdLabel.text = tuple.thirdValue;
        
        double currYear = [tuple.firstValue doubleValue];
        double lastYear = [tuple.thirdValue doubleValue];
        
        if(lastYear>0.0) {
            double growthValue = currYear-lastYear;
            double percentGrowth = growthValue*100.0f/lastYear;
            
            NSNumberFormatter *comaFormatter = [[NSNumberFormatter alloc] init];
            [comaFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            [comaFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_IN"] ];
            [comaFormatter setMaximumFractionDigits:1];
            [comaFormatter setRoundingMode: NSNumberFormatterRoundHalfEven];
            
            
            if(growthValue<0.0) {
                rowCell.growthIcon.image = [UIImage imageNamed:@"growth_arrow_down"];
                
                NSString* formattedTest = [comaFormatter stringFromNumber:[NSNumber numberWithDouble:-1.0* percentGrowth]];
                rowCell.growthLabel.text = [formattedTest stringByAppendingString:@"%"];
            } else {
                rowCell.growthIcon.image = [UIImage imageNamed:@"growth_arrow_up"];
                NSString* formattedTest = [comaFormatter stringFromNumber:[NSNumber numberWithDouble: percentGrowth]];
                rowCell.growthLabel.text = [formattedTest stringByAppendingString:@"%"];
            }
        } else {
            rowCell.growthLabel.text = @"N/A";
            rowCell.growthIcon.image = nil;
        }
        
        
    }
    
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if(section==1) {
        UIView* lView = nil;
        UILabel* label = nil;
        
        NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
        
        
        lView = [view viewWithTag:0];
        label = [lView viewWithTag:101];
        label.text = [self zeroColumnHeading];
        
        lView = [view viewWithTag:1];
        label = [lView viewWithTag:101];
        label.text = [self shortDateRangeFormat:self.firstFormPost.postData] ; //  firstColumnText;
        label.attributedText = [[NSAttributedString alloc] initWithString:[self shortDateRangeFormat:self.firstFormPost.postData] attributes:underlineAttribute];
        
        lView = [view viewWithTag:2];
        label = [lView viewWithTag:101];
        label.text = [self shortDateRangeFormat:self.secondFormPost.postData];
        label.attributedText = [[NSAttributedString alloc] initWithString:[self shortDateRangeFormat:self.secondFormPost.postData] attributes:underlineAttribute];
        
        lView = [view viewWithTag:3];
        label = [lView viewWithTag:101];
        label.text = [self shortDateRangeFormat:self.thirdFormPost.postData];
        label.attributedText = [[NSAttributedString alloc] initWithString:[self shortDateRangeFormat:self.thirdFormPost.postData] attributes:underlineAttribute];
        
        
        // for total labels
        
        UIView* totalRow = [view viewWithTag:20];
        UILabel* tZero =  (UILabel*)[totalRow viewWithTag:200];
        tZero.text = @"Summary\r\n(In Lacs)";
        tZero.textAlignment = NSTextAlignmentLeft;
        
        UILabel* tFirst =  (UILabel*)[totalRow viewWithTag:201];
        tFirst.text = [self totalHeaderValue:firstResponse];
        tFirst.textAlignment = NSTextAlignmentRight;
        
        UILabel* tSecond =  (UILabel*)[totalRow viewWithTag:202];
        tSecond.text = [self totalHeaderValue:secondResponse];
        tSecond.textAlignment = NSTextAlignmentRight;
        
        UILabel* tThird =  (UILabel*)[totalRow viewWithTag:203];
        tThird.text = [self totalHeaderValue:thirdResponse];
        tThird.textAlignment = NSTextAlignmentRight;
        
        double currYear = [[self totalHeaderValue:firstResponse] doubleValue];
        double lastYear = [[self totalHeaderValue:thirdResponse] doubleValue];
        
        if(lastYear>0.0) {
            double growthValue = currYear-lastYear;
            double percentGrowth = growthValue*100.0f/lastYear;
            
            NSNumberFormatter *comaFormatter = [[NSNumberFormatter alloc] init];
            [comaFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            [comaFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_IN"] ];
            [comaFormatter setMaximumFractionDigits:1];
            [comaFormatter setRoundingMode: NSNumberFormatterRoundHalfEven];
            
            UILabel* percentLabel = (UILabel*)[totalRow viewWithTag:204];
            
            
            UIImageView* growthIcon = (UIImageView*)[totalRow viewWithTag:205];
            
            if(growthValue<0.0) {
                growthIcon.image = [UIImage imageNamed:@"growth_arrow_down"];
                NSString* formattedText = [comaFormatter stringFromNumber:[NSNumber numberWithDouble: -1.0*percentGrowth]];
                percentLabel.text = [formattedText stringByAppendingString:@"%"];
            } else {
                growthIcon.image = [UIImage imageNamed:@"growth_arrow_up"];
                NSString* formattedText = [comaFormatter stringFromNumber:[NSNumber numberWithDouble: percentGrowth]];
                percentLabel.text = [formattedText stringByAppendingString:@"%"];
            }
        } else {
            UIImageView* growthIcon = (UIImageView*)[totalRow viewWithTag:205];
            growthIcon.image = nil;
            
            UILabel* percentLabel = (UILabel*)[totalRow viewWithTag:204];
            percentLabel.text = @"N/A";
        }
        
        
        [LayoutClass setLayoutForIPhone6:[view viewWithTag:10]];
        [LayoutClass setLayoutForIPhone6:[view viewWithTag:20]];
        
        [LayoutClass setLayoutForIPhone6: [[view viewWithTag:20] viewWithTag:205]];
        
        [view viewWithTag:10].layer.cornerRadius = 5.0f;
        [view viewWithTag:20].layer.cornerRadius = 5.0f;
        
        [view viewWithTag:10].layer.masksToBounds = YES;
        [view viewWithTag:20].layer.masksToBounds = YES;
        
        for (int i=0; i<4; i++) {
            [LayoutClass setLayoutForIPhone6:[[view viewWithTag:10] viewWithTag:i]];
            [LayoutClass labelLayout:[[[view viewWithTag:10] viewWithTag:i] viewWithTag:101]];
        }
        [LayoutClass labelLayout:[[view viewWithTag:10] viewWithTag:4]];
        
        for (int i=200; i<205; i++) {
            [LayoutClass labelLayout:[[view viewWithTag:20] viewWithTag:i]];
        }
        
    }
    
}

-(NSString*) zeroColumnHeading
{
    NSMutableArray *sortedElementIds = [DotReportDraw sortRptComponents:self.dotReport.reportElements :XmwcsConst_REPORT_PLACE_TABLE];
    
    if([sortedElementIds count]>0) {
        NSString *keyOfComp = (NSString *)[sortedElementIds objectAtIndex:0];
        DotReportElement* element = [[self dotReport].reportElements objectForKey:keyOfComp];
        
        if(element!=nil) {
            return element.displayText;
        } else {
            return @"NA";
        }
    } else {
        return @"NA";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1 && [self clickable:indexPath.row]==YES) {
        [self handleDrilldown:indexPath.row];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f * deviceHeightRation;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0 ) {
        return 0.0f;
    } else if(section==1) {
        return 105.0f * deviceHeightRation;
    }
    return 0.0f;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if(section==1) {
        UINib* headerNib = [UINib nibWithNibName:@"GrowthIndicatorTableHeader" bundle:nil];
        
        UIView* view = [[headerNib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        
        view.bounds = CGRectMake(0, 0, self.view.frame.size.width, 60.0f);
        
        
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


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0) {
        return 0;
    } else if(section==1) {
        if(dataSet!=nil) {
            return [dataSet.allKeys count];
        }
    } else {
        return 0;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    if(indexPath.section==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
    } else if(indexPath.section==1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"GrowthIndicatorTableCell"];
    }
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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
    XmwCompareTuple* dataTuple = [dataSet objectForKey:dataSetKey];
    
    
    GrowthIndicatorReportVC* ddCustomCompareReport = [[GrowthIndicatorReportVC alloc] initWithNibName:@"GrowthIndicatorReportVC" bundle:nil];
    
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

-(NSString*) shortDateRangeFormat:(NSDictionary*) postData
{
    // dd/MM/yyyy
    NSString* fromDate = [postData objectForKey:@"FROM_DATE"];
    NSString* toDate = [postData objectForKey:@"TO_DATE"];
    
    NSArray* fromDateParts = [fromDate componentsSeparatedByString:@"/"];
    NSString* fromyy = [fromDateParts[2] substringFromIndex:2];
    
    NSArray* toDateParts = [toDate componentsSeparatedByString:@"/"];
    NSString* toyy = [toDateParts[2] substringFromIndex:2];
    
    
    return  [NSString stringWithFormat:@"%@/%@/%@\r\n%@/%@/%@", fromDateParts[0], fromDateParts[1], fromyy,
                       toDateParts[0], toDateParts[1], toyy];
}

@end
