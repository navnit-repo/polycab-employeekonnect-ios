//
//  CustomCompareReportVC.m
//  QCMSProject
//
//  Created by Pradeep Singh on 9/4/16.
//  Copyright © 2016 dotvik. All rights reserved.
//

#import "CustomCompareReportVC.h"

#import "DotFormPost.h"
#import "DVAppDelegate.h"
#import "XmwReportService.h"
#import "LoadingView.h"
#import "CompareReportTableCell.h"
#import  <CoreText/CoreText.h>
#import "DVPeriodCalendar.h"
#import "ClientVariable.h"
#import "Styles.h"
#import "XmwUtils.h"
#import "LayoutClass.h"


//@interface XmwCompareTuple : NSObject
//@property NSString* fieldName;
//@property NSString* firstValue;
//@property NSString* secondValue;
//@property NSString* thirdValue;
//@property NSString* uomValue;
//@property NSArray* firstRawData;
//@property NSArray* secondRawData;
//@property NSArray* thirdRawData;
//@end


@implementation XmwCompareTuple


@end

@interface CustomCompareReportVC () <UITableViewDataSource, UITableViewDelegate, DVPeriodCalendarDelegate>
{
//    NSString* firstColumnText;
//    NSString* secondColumnText;
//    NSString* thirdColumnText;
    NSDateFormatter* dateFormatter;
    
    
//    ReportPostResponse* firstResponse;
//    ReportPostResponse* secondResponse;
//    ReportPostResponse* thirdResponse;
    
   // NSMutableDictionary* dataSet;
    
//    NSArray* sortedDataSetKeys;
    
//    LoadingView* loadingView;
//    int loaderCount;
    
    
}

@end

@implementation CustomCompareReportVC
@synthesize orignalThirdResponseData,orignalSortedDataSetKeys,orignalDataSet;

@synthesize secondColumnText;
@synthesize thirdColumnText;
- (void)viewDidLoad {
    [LayoutClass setLayoutForIPhone6:self.mainTable];

//    self.mainTable.frame = CGRectMake(self.mainTable.frame.origin.x, self.mainTable.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height  - self.mainTable.frame.origin.y);
    
    [super viewDidLoad];
    
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
        self.view.frame = CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 64.0f);
    }
   
    
    loaderCount = 0;
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    dataSet = [[NSMutableDictionary alloc] init];
    
    
    // Do any additional setup after loading the view from its nib.
    
    
    self.mainTable.delegate = self;
    self.mainTable.dataSource = self;
    
    
    [self.mainTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DefaultCell" ];
    
    [self.mainTable registerNib:[UINib nibWithNibName:@"CompareReportTableCell" bundle:nil] forCellReuseIdentifier:@"CompareReportTableCell"];
    
    [self fetchFirstColumnData:self.firstFormPost];
    
    [self fetchSecondColumnData:self.secondFormPost];
    
    [self fetchThirdColumnData:self.thirdFormPost];
    
    
    [self drawHeaderItem];
    
}

-(void) drawHeaderItem
{
    self.title = self.dotForm.screenHeader;
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage
                                                                          imageNamed:@"back-button.png"] style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(backHandler:)];
    
    backButton.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backButton];
    
    [self drawTitle: self.dotForm.screenHeader];
    
}

-(void) drawTitle:(NSString *)headerStr
{
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    // self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    UILabel*  titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
    titleLabel.text = headerStr;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.navigationItem setTitleView: titleLabel];
    
}

-(IBAction)backHandler:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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




#pragma mark - UITableViewDelegate

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1) {
        // NSString* key = [dataSet.allKeys objectAtIndex:indexPath.row];
        
        NSString* key = [sortedDataSetKeys objectAtIndex:indexPath.row];
        XmwCompareTuple* tuple = [dataSet objectForKey:key];
        
        CompareReportTableCell* rowCell = (CompareReportTableCell*) cell;
        
        rowCell.fieldLabel.text = tuple.fieldName;
        rowCell.firstLabel.text = tuple.firstValue;
        rowCell.secondLabel.text = tuple.secondValue;
        rowCell.thirdLabel.text = tuple.thirdValue;
        
    }
    
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if(section==1) {
        UIView* lView = nil;
        UILabel* label = nil;
        
        NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
        
        
        lView = [view viewWithTag:0];
      //  lView.backgroundColor = [UIColor colorWithRed:128.0/255 green:128.0/255 blue:128.0/255 alpha:1.0];
        [LayoutClass setLayoutForIPhone6:lView];
        
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
        [LayoutClass setLayoutForIPhone6:totalRow];
        
        UILabel* tZero =  (UILabel*)[totalRow viewWithTag:200];
        [LayoutClass labelLayout:tZero forFontWeight:UIFontWeightSemibold];
        tZero.text = @"Summary";
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
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0 ) {
        return 0.0f;
    } else if(section==1) {
        return 100.0f*deviceHeightRation;
    }
    return 0.0f;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if(section==1) {
        UINib* headerNib = [UINib nibWithNibName:@"CompareReportTableHeader" bundle:nil];
        
        UIView* view = [[headerNib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        
        view.bounds = CGRectMake(0, 0, self.view.frame.size.width, 100.0f*deviceHeightRation);
        

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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if(indexPath.section==1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CompareReportTableCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.clipsToBounds = YES;
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}



#pragma mark - Create DotFormPost

-(DotFormPost*) dotFormPost:(DotFormPost*)formPost fromDate:(NSDate*) fromDate toDate:(NSDate*) toDate
{
    DotFormPost* newFormPost = [formPost cloneObject];
    
    [newFormPost.postData setObject:[dateFormatter stringFromDate:fromDate] forKey:@"FROM_DATE"];
    [newFormPost.postData setObject:[dateFormatter stringFromDate:toDate] forKey:@"TO_DATE"];
    
    [newFormPost.displayData setObject:[dateFormatter stringFromDate:fromDate] forKey:@"FROM_DATE"];
    [newFormPost.displayData setObject:[dateFormatter stringFromDate:toDate] forKey:@"TO_DATE"];
    
    return newFormPost;
}


#pragma mark - Fetch Report Data

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
        [self addFirstSetData:firstResponse into:dataSet];
        
        
        sortedDataSetKeys = [self sortKeys];
        [self.mainTable reloadData];
        
    }   fail:^(DotFormPost* formPosted, NSString* message) {
        if(loaderCount>0) {
            loaderCount--;
            if(loaderCount==0) {
                [loadingView removeView];
                loadingView = nil;
                
                
                if([message isEqualToString:@"SESSION_EXPIRED"]) {
                    [self handleExpiredSession];
                } else {
                    [XmwUtils toastView:message];
                }

            }
        }
        
        
    }];

}

-(void) fetchSecondColumnData:(DotFormPost*) formPost
{
    if(loadingView==nil) {
        loadingView = [LoadingView loadingViewInView:self.view];
    }
    loaderCount++;
    
    secondColumnText = [NSString stringWithFormat:@"%@\r\n%@",
                        [self.secondFormPost.postData objectForKey:@"FROM_DATE"],
                        [self.secondFormPost.postData objectForKey:@"TO_DATE"]];

    
    XmwReportService* reportService = [[XmwReportService alloc] initWithPostData:formPost withContext:@"fetchSecondColumnData"];
    
    [reportService fetchReportUsingSuccess:^(DotFormPost* formPosted, ReportPostResponse* reportResponse) {
        
        if(loaderCount>0) {
            loaderCount--;
            if(loaderCount==0) {
                [loadingView removeView];
                loadingView = nil;
            }
        }
        
        // we should receive report response data here
        secondResponse = reportResponse;
        [self addSecondSetData:secondResponse into:dataSet];
        
        sortedDataSetKeys = [self sortKeys];
        [self.mainTable reloadData];
        
    }   fail:^(DotFormPost* formPosted, NSString* message) {
        if(loaderCount>0) {
            loaderCount--;
            if(loaderCount==0) {
                [loadingView removeView];
                loadingView = nil;
                
                
                if([message isEqualToString:@"SESSION_EXPIRED"]) {
                    [self handleExpiredSession];
                } else {
                    [XmwUtils toastView:message];
                }

            }
        }
    }];
    
}

-(void) fetchThirdColumnData:(DotFormPost*) formPost
{
    if(loadingView==nil) {
        loadingView = [LoadingView loadingViewInView:self.view];
    }
    loaderCount++;
    
    thirdColumnText = [NSString stringWithFormat:@"%@\r\n%@",
                       [self.thirdFormPost.postData objectForKey:@"FROM_DATE"],
                       [self.thirdFormPost.postData objectForKey:@"TO_DATE"]];
    
    
    XmwReportService* reportService = [[XmwReportService alloc] initWithPostData:formPost withContext:@"fetchSecondColumnData"];
    
    [reportService fetchReportUsingSuccess:^(DotFormPost* formPosted, ReportPostResponse* reportResponse) {
        
        if(loaderCount>0) {
            loaderCount--;
            if(loaderCount==0) {
                [loadingView removeView];
                loadingView = nil;
            }
        }
        
        // we should receive report response data here
        thirdResponse = reportResponse;
        [self addThirdSetData:thirdResponse into:dataSet];
        
        sortedDataSetKeys = [self sortKeys];
        
        // this code for search feature
        orignalThirdResponseData = [[NSMutableArray alloc ] init];
        [orignalThirdResponseData addObjectsFromArray:[self sortSearchDataArray:thirdResponse.tableData]];
        orignalSortedDataSetKeys = [[NSArray alloc ] init];
        orignalSortedDataSetKeys = [self sortKeys];
        
        
        [self.mainTable reloadData];
        
    }   fail:^(DotFormPost* formPosted, NSString* message) {
        if(loaderCount>0) {
            loaderCount--;
            if(loaderCount==0) {
                [loadingView removeView];
                loadingView = nil;
                
                
                if([message isEqualToString:@"SESSION_EXPIRED"]) {
                    [self handleExpiredSession];
                } else {
                    [XmwUtils toastView:message];
                }

            }
        }
        
    }];
    
}


-(void) handleExpiredSession
{

         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Your Session expired, Please login again !" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                                        {
                                                           LogInVC *vc = [[LogInVC alloc] initWithNibName:@"LogInVC" bundle:nil];
                                                 vc.password.text = @"";
                                                                                              UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                                                                                              [UIApplication.sharedApplication.keyWindow setRootViewController:nav];
                                                              
                                                        }];
    
    [alertController addAction:defaultAction];
    
    
     UIViewController* root = [[[[UIApplication sharedApplication]windows]objectAtIndex:0] rootViewController];
            UIViewController *assignViewController = nil;
            
            if ([root isKindOfClass:[SWRevealViewController class]]) {
                        SWRevealViewController *reveal = (SWRevealViewController*)root;
                        UINavigationController *check =(UINavigationController*)reveal.frontViewController;
                        NSArray* viewsList = check.viewControllers;
                        UIViewController *checkView = (UIViewController *) [viewsList objectAtIndex:viewsList.count - 1];
                assignViewController = checkView;
            }
            else
            {
                assignViewController = root;
            }
            
            [assignViewController presentViewController:alertController animated:YES completion:nil];
    
}

-(NSArray*)sortSearchDataArray :(NSMutableArray*)array
{
   
    NSArray* sortedObjects = [array sortedArrayUsingComparator:^(id obj1, id obj2) {
        NSString* string1 = [obj1 objectAtIndex:0];
        NSString* string2 = [obj2 objectAtIndex:0];
        
        return [string1 compare:string2];
    }];
    
    return sortedObjects;
}

#pragma  mark -  populate and reload

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
        tupleObject.firstValue = [rowData objectAtIndex:1];
        if([rowData count]>2) {
            tupleObject.uomValue = [rowData objectAtIndex:2];
        } else {
            tupleObject.uomValue = @"";
        }
        tupleObject.fieldName = fieldName;
        tupleObject.firstRawData = rowData;
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
        tupleObject.secondValue = [rowData objectAtIndex:1];
        if([rowData count]>2) {
            tupleObject.uomValue = [rowData objectAtIndex:2];
        } else {
            tupleObject.uomValue = @"";
        }
        tupleObject.fieldName = fieldName;
        tupleObject.secondRawData = rowData;
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
        tupleObject.thirdValue = [rowData objectAtIndex:1];
        if([rowData count]>2) {
            tupleObject.uomValue = [rowData objectAtIndex:2];
        } else {
            tupleObject.uomValue = @"";
        }
        tupleObject.fieldName = fieldName;
        tupleObject.thirdRawData = rowData;
    }
}


-(void) changePeriodAction:(UITapGestureRecognizer*) gesture
{
    NSInteger columnIndex = gesture.view.tag;
    
    NSLog(@"Column is %ld", columnIndex);
    
    
    
    DVPeriodCalendar* periodCalendar = [[DVPeriodCalendar alloc] initWithNibName:@"DVPeriodCalendar" bundle:nil];
    periodCalendar.contextId = [NSString stringWithFormat:@"%ld", columnIndex];
    periodCalendar.calendarDelegate  = self;
    
    
    DVDateStruct* todayStruct = [DVDateStruct fromNSDate:[NSDate date]];
    [todayStruct setDay:1];
    [todayStruct setYear:(todayStruct.year-4)];
    
    // we can only go back to 4 years
    periodCalendar.fromLowerDate = [todayStruct convertToNSDate];
    periodCalendar.fromUpperDate = [NSDate date];
    
    todayStruct = [DVDateStruct fromNSDate:[NSDate date]];
    [todayStruct setDay:1];
    periodCalendar.fromDisplayDate  = [self dafaultFromDateForColumn:columnIndex];
    
    // we need to set propper to date field variables
    todayStruct = [DVDateStruct fromNSDate:[NSDate date]];
    [todayStruct setDay:1];
    [todayStruct setYear:(todayStruct.year-4)];
    periodCalendar.toLowerDate = [todayStruct convertToNSDate];
    periodCalendar.toUpperDate = [NSDate date];
    periodCalendar.toDisplayDate = [self dafaultToDateForColumn:columnIndex];;
    
    UIViewController* rootController = [[UIApplication sharedApplication].keyWindow rootViewController];
    
    [rootController presentViewController:periodCalendar animated:YES completion:nil];
    

}


-(NSDate*) dafaultFromDateForColumn:(NSInteger) columnIndex
{
    DotFormPost* formPost = nil;
    
    if(columnIndex==1) {
        formPost = self.firstFormPost;
    } else if(columnIndex==2) {
        formPost = self.secondFormPost;
    } else if(columnIndex==3) {
        formPost = self.thirdFormPost;
    }
    
    return [dateFormatter dateFromString:[formPost.postData objectForKey:@"FROM_DATE" ]];
}


-(NSDate*) dafaultToDateForColumn:(NSInteger) columnIndex
{
    DotFormPost* formPost = nil;
    
    if(columnIndex==1) {
        formPost = self.firstFormPost;
    } else if(columnIndex==2) {
        formPost = self.secondFormPost;
    } else if(columnIndex==3) {
        formPost = self.thirdFormPost;
    }
    
    return [dateFormatter dateFromString:[formPost.postData objectForKey:@"TO_DATE" ]];
}


#pragma mark - DVPeriodCalendarDelegate

-(void) fromDate:(DVDateStruct*) fromDateStruct toDate:(DVDateStruct*) toDateStruct  context:(NSString*) contextId
{
    if(fromDateStruct !=nil && toDateStruct !=nil) {
        
        // NSString *fromSelectedDate = [dateFormatter stringFromDate:[fromDateStruct convertToNSDate]];
        
        // NSString *toSelectedDate = [dateFormatter stringFromDate:[toDateStruct convertToNSDate]];
        
        if([contextId isEqualToString:@"1"]) {
            // update first Column data with user selected date range
            
            self.firstFormPost = [self dotFormPost:self.firstFormPost fromDate:[fromDateStruct convertToNSDate] toDate:[toDateStruct convertToNSDate]];
            
            [self fetchFirstColumnData:self.firstFormPost];
        } else if([contextId isEqualToString:@"2"]) {
            // update second columdn data with user selected date range
            self.secondFormPost = [self dotFormPost:self.secondFormPost fromDate:[fromDateStruct convertToNSDate] toDate:[toDateStruct convertToNSDate]];
            
            [self fetchSecondColumnData:self.secondFormPost];
        } else if([contextId isEqualToString:@"3"]) {
            // update third column data with user selected date range
            self.thirdFormPost = [self dotFormPost:self.thirdFormPost fromDate:[fromDateStruct convertToNSDate] toDate:[toDateStruct convertToNSDate]];
            
            [self fetchThirdColumnData:self.thirdFormPost];
            
        }
        
    }

    
}

-(void) userCancelled:(NSString*) contextId
{
    
    
    
}


#pragma  mark - DrillDown

-(bool) clickable:(NSInteger) rowIdx
{
    bool isClickableRow = NO;
    
    isClickableRow = [[self dotReport] isFindDrillDown];
    
    return isClickableRow;
}

-(DotReport*) dotReport
{
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    
    if(firstResponse!=nil) {
        DotReport* dotReport = [clientVariables.DOT_REPORT_MAP objectForKey:firstResponse.viewReportId];
        return dotReport;
    } else {
        DotReport* dotReport = [clientVariables.DOT_REPORT_MAP objectForKey:self.dotForm.submitAdapterId];
        return dotReport;
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
    XmwCompareTuple* dataTuple = [dataSet objectForKey:dataSetKey];
    
    
    CustomCompareReportVC* ddCustomCompareReport = [[CustomCompareReportVC alloc] initWithNibName:@"CustomCompareReportVC" bundle:nil];
    
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

-(NSArray*) pickGoodRawData:(NSArray*) best option:(NSArray*)other1 option:(NSArray*) other2
{
    if(best==nil) {
        if(other1==nil) {
            return other2;
        } else {
            return other1;
        }
    } else {
        return best;
    }
}

-(DotFormPost*)ddColumnDotFormPost:(DotFormPost*) dotFormPost rowIndex:(NSInteger) rowIndex columnRowData:(NSArray*) colRowData
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
            [ddFormPost.postData setObject:[colRowData objectAtIndex:i] forKey:dotReportElement.elementId];
        }
    }
    
    return ddFormPost;
}

-(NSString*) totalHeaderValue:(ReportPostResponse*) reportResponse
{
    NSString* amtAsString = [reportResponse.headerData objectForKey:@"TOTAL_AMT"];
    if(amtAsString==nil) return @"0.0";
    
    if([amtAsString isKindOfClass:[NSNull class]]) return @"0.0";
    
    return [reportResponse.headerData objectForKey:@"TOTAL_AMT"];
}


-(double) unformattedTotalHeaderValue:(ReportPostResponse*) reportResponse
{
    
    NSString* amtAsString = [reportResponse.headerData objectForKey:@"TOTAL_AMT"];
    if(amtAsString==nil) return 0.0f;
    
    if([amtAsString isKindOfClass:[NSNull class]]) return 0.0f;
    
    // we need to remove formatted characters i.e comma etc.
    
    // NSCharacterSet* numbers = [NSCharacterSet characterSetWithCharactersInString:@".0123456789"];
    
    NSArray* parts = [amtAsString  componentsSeparatedByString:@","];
    return [[parts componentsJoinedByString:@""] doubleValue];
    
    //  return [reportResponse.headerData objectForKey:@"TOTAL_AMT"];
}


#pragma mark - sorting on client side

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
     
    return [dataSet allKeys];
}

@end
