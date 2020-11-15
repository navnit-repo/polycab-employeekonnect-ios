//
//  WideReportVC.m
//  XMW by Dotvik
//
//  Created by Ashish / Pradeep
//  Copyright (c) 2013 Dotvik Solutions. All rights reserved.
//

#import "WideReportVC.h"

#import <QuartzCore/QuartzCore.h>


#import "ClientVariable.h"
#import "DVAppDelegate.h"
#import "DotReportDraw.h"
#import "DotFormPost.h"
#import "MXButton.h"
#import "NetworkHelper.h"
#import "XmwcsConstant.h"
#import "TagKeyConstant.h"
#import "Styles.h"

#import "ReportSectionsController.h"
#import "ReportTabularDataSection.h"
#import "ReportHeaderSection.h"
#import "ReportSubheaderSection.h"
#import "ReportFooterSection.h"
#import "ReportLegendSection.h"


//#define kReportSectionHeader 0
//#define kReportSectionSubHeader 1
//#define kReportSectionLegend 2
//#define kReportSectionTable 3
//#define kReportSectionFooter 4

//#define kTotalSections 5


// for new section architecture





@interface WideReportVC () <UITableViewDataSource, UITableViewDelegate>
{
    ReportSectionsController* sectionController;
    NSMutableArray *sectionArray;
//    int sectionFlag[kTotalSections];
    
//    UIScrollView* hScrollView;
}
@end

@implementation WideReportVC


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    return self;
}

-(id) initWithDocIds:(NSMutableArray *)_docIdData
{
    if (self)
    {
        docIdData           = _docIdData;
    }
    return self;
}

#pragma mark - Initialize View

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for(int i=0; i<kTotalSections; i++) {
        sectionFlag[i] = 0;
    }
    
    /*
     if(isiPhone6Plus) {
     self.view.frame = CGRectMake(0, 64, 414, 672);
     } else if(isiPhone6) {
     self.view.frame = CGRectMake(0, 64, 375, 600);
     } else if(isiPhone5) {
     self.view.frame = CGRectMake(0, 64, 320, 504);
     } else {
     // 0, 64, 320, 416
     self.view.frame = CGRectMake(0, 64, 320, 416);
     }
     
     
     [self initializeView];
     
     [self drawHeaderItem];
     
     //
     // V1 was using DotReportDraw,
     // V2 was section controller based
     // This V3 is based on UICollectionView using BiDirectionalFlow layout
     //
     [self makeReportScreenV2];
     */
    
    
    
}


- (void) backHandler : (id) sender {
    [ [self navigationController]  popViewControllerAnimated:YES];
    
    // if( self.screenId==XmwcsConst_WorkflowMainScreen) {
    //    [DVAppDelegate popModuleContext];
    // }
}

-(void) initializeView
{
    [super initializeView];
    
    
    
     hScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, titleLblHeight + searchBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-(titleLblHeight + searchBar.frame.size.height))];
    
    hScrollView.scrollEnabled = YES;
    hScrollView.delegate = self;
    hScrollView.bounces = NO;
    
    // default hScrollView content size is same its size
    
    hScrollView.contentSize = CGSizeMake(self.view.frame.size.width, hScrollView.frame.size.height);
    
    
    [self.view addSubview:hScrollView];
    
}

-(void) drawTitle:(NSString *)headerStr
{
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    // self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    
    UIImageView *polycabLogo = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"polycab_logo"]];
    self.navigationItem.titleView.contentMode = UIViewContentModeCenter;
    self.navigationItem.titleView = polycabLogo;
    
}


-(void) makeReportScreenV2
{
    
    sectionArray = [[NSMutableArray alloc] init];
    sectionController = [[ReportSectionsController alloc] init];
    
//    self.reportTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 35, self.view.frame.size.width, self.view.frame.size.height-35)];

     self.reportTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, hScrollView.frame.size.height)];
    
    sectionController.tableView = self.reportTableView;
    self.reportTableView.dataSource = sectionController;
    self.reportTableView.delegate = sectionController;
    sectionController.sections = sectionArray;
    
    
    NSArray *placeVector = [XmwUtils breakStringTokenAsVector : dotReport.reportPlaces : @"$"];
    for (int cntComponentPlace = 0; cntComponentPlace < [placeVector count]; cntComponentPlace++)
    {
        NSString *componentPlace = (NSString*) [placeVector objectAtIndex:cntComponentPlace];
        
        if([componentPlace isEqualToString : XmwcsConst_REPORT_PLACE_HEADER])
        {
            sectionFlag[kReportSectionHeader] = 1;
            ReportHeaderSection* headerSection = [[ReportHeaderSection alloc] init];
            headerSection.forwardedDataDisplay = forwardedDataDisplay;
            headerSection.forwardedDataPost = forwardedDataPost;
            headerSection.reportVC = self;
            [sectionArray addObject:headerSection];
        } else if([componentPlace isEqualToString : XmwcsConst_REPORT_PLACE_TABLE])
        {
            if([dotReport.reportType isEqualToString:XmwcsConst_REPORT_TYPE_LEGEND])
            {
                ReportLegendSection* legendSection = [[ReportLegendSection alloc] init];
                [sectionArray addObject:legendSection];
                legendSection.reportVC = self;
                sectionFlag[kReportSectionLegend] = 1;
            }
            ReportTabularDataSection* dataSection = [self addTabularDataSection];
            searchBar.delegate = dataSection;
            [sectionArray addObject:dataSection];
            sectionFlag[kReportSectionTable] = 1;
        }  else if([componentPlace isEqualToString : XmwcsConst_REPORT_PLACE_FOOTER ])
        {
            ReportFooterSection* footerSection = [[ReportFooterSection alloc] init];
            footerSection.reportVC = self;
            [sectionArray addObject:footerSection];
            sectionFlag[kReportSectionFooter] = 1;
        }
        else if([componentPlace isEqualToString :XmwcsConst_REPORT_PLACE_SUBHEADER ])
        {
            ReportSubheaderSection* subheaderSection = [[ReportSubheaderSection alloc] init];
            subheaderSection.reportVC = self;
            [sectionArray addObject:subheaderSection];
            sectionFlag[kReportSectionSubHeader] = 1;
        }
    }
    
    [sectionController updateData:dotReport : reportPostResponse ];
    
   
    /* Old Code
    if(sectionFlag[kReportSectionTable] == 1) {
        NSArray* sortedElementIds =[DotReportDraw sortRptComponents : dotReport.reportElements : XmwcsConst_REPORT_PLACE_TABLE];

        if([sortedElementIds count]>0) {
            NSInteger defaultColumnWidth = self.view.frame.size.width/[sortedElementIds count];

            for(int i=0; i<[sortedElementIds count]; i++) {
                DotReportElement* dotReportElement = [dotReport.reportElements  objectForKey:[sortedElementIds objectAtIndex:i]];
                if(dotReportElement.length!=nil) {
                    scrollWidth = scrollWidth +  [dotReportElement.length integerValue];
                }
                scrollWidth = scrollWidth + defaultColumnWidth;
            }
        }
    }
     */
    
   // Tushar, update scrollview width
    NSInteger scrollWidth = 0;
    NSInteger totalDisplayElements = 0;
    NSMutableArray *lengthArray = nil;
    NSMutableArray* sortedElementIds = nil;
    
    if(sectionFlag[kReportSectionTable] == 1) {
         sortedElementIds =[DotReportDraw sortRptComponents : dotReport.reportElements : XmwcsConst_REPORT_PLACE_TABLE];
        NSMutableArray *removeElementIdsFromSortedElementIds = [[NSMutableArray alloc] init];

        for(int i=0; i<[sortedElementIds count]; i++) {
             DotReportElement* dotReportElement = [dotReport.reportElements  objectForKey:[sortedElementIds objectAtIndex:i]];
            if ([dotReportElement.componentType isEqualToString:@"HIDDEN"]) {
                [removeElementIdsFromSortedElementIds addObject:dotReportElement.elementId];
                // remove object for hidden
            }
            /*
            if ([dotReportElement.componentType isEqualToString:@"CUSTOM_COLUMN"] || [dotReportElement.componentType isEqualToString:@"HIDDEN"]) {
                [removeElementIdsFromSortedElementIds addObject:dotReportElement.elementId];
                //remove object
            }*/
        }
        
        if ([removeElementIdsFromSortedElementIds count] >0) {
            for (int i=0; i<removeElementIdsFromSortedElementIds.count; i++) {

                [sortedElementIds removeObject:[removeElementIdsFromSortedElementIds objectAtIndex:i]];
            }
        }

        if([sortedElementIds count]>0) {
            NSInteger defaultColumnWidth = self.view.frame.size.width/[sortedElementIds count];
            lengthArray = [[NSMutableArray alloc] init];
            for(int i=0; i<[sortedElementIds count]; i++) {
                DotReportElement* dotReportElement = [dotReport.reportElements  objectForKey:[sortedElementIds objectAtIndex:i]];
                if(dotReportElement.length!=nil) {
                   
                    
                    scrollWidth = scrollWidth +  [dotReportElement.length integerValue];
                    [lengthArray addObject:dotReportElement.length];
//                        if ([dotReportElement.length integerValue] <= 150) {
//                            scrollWidth = scrollWidth + 150;
//                            [lengthArray addObject:@"150"];
//                        }
//                        else
//                        {
//                          scrollWidth = scrollWidth +  [dotReportElement.length integerValue];
//                          [lengthArray addObject:dotReportElement.length];
//                        }
                    
                   
                }
                else
                {
                  scrollWidth = scrollWidth + defaultColumnWidth;
                }

            }
            totalDisplayElements = lengthArray.count;
        }
    }

    // this will make tableView also scroll horizontally with the columns are more
    if(scrollWidth>self.view.frame.size.width) {
        
        NSUInteger scrollViewContentSizeWidth = 0;
        for (int cntTableColumn = 0; cntTableColumn < [sortedElementIds count]; cntTableColumn++)
        {
            //start calculate tableheader column width
             DotReportElement* dotReportElement = [dotReport.reportElements  objectForKey:[sortedElementIds objectAtIndex:cntTableColumn]];
            NSString* tempLen = dotReportElement.length ;
            int normalized = 100/[sortedElementIds count];
            if(scrollWidth!=0) {
                normalized = [tempLen intValue]*100/scrollWidth;
            }
            float columnWidth = scrollWidth * normalized / 100;
            scrollViewContentSizeWidth = scrollViewContentSizeWidth + columnWidth;
            
        }
        hScrollView.contentSize = CGSizeMake(scrollViewContentSizeWidth, hScrollView.frame.size.height);
        self.reportTableView.frame = CGRectMake(0, 0, scrollWidth, hScrollView.frame.size.height);
    }
    
    [hScrollView addSubview : self.reportTableView];
}



#pragma mark - Action Methods

-(void) deSelect:(id)sender
{
    [(UITableView *)sender deselectRowAtIndexPath:[(UITableView *)sender indexPathForSelectedRow] animated:YES];
}

#pragma mark - Helper Methods


#pragma mark - Clean Ups

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    [loadingView removeView];
    
    NSLog(@"ReportScreenController::formResponseHandler");
    
    if([callName isEqualToString:XmwcsConst_CALL_NAME_FOR_SUBMIT])
    {
        DocPostResponse *docPostResponse = (DocPostResponse *)respondedObject;
        NSString *message = docPostResponse.submittedMessage;
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Info!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        [myAlertView show];
        
        
    }
}

-(void) httpFailureHandler:(NSString *)callName :(NSString *)message
{
    [loadingView removeView];
}




@end
