//
//  MyDetailsVC.m
//  XMWClient
//
//  Created by dotvikios on 19/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "MyDetailsVC.h"
#import "XmwUtils.h"
#import "ReportHeaderSection.h"
#import "ReportSubheaderSection.h"
#import "XmwcsConstant.h"
#import "ReportLegendSection.h"
#import "ReportFooterSection.h"
#import "DVAppDelegate.h"
#import "MyDetailsReportHeaderSection.h"
@interface MyDetailsVC ()

@end

@implementation MyDetailsVC
{
    UIImageView *profileImageView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"My DitalsVC Call");
}


-(void) makeReportScreenV2
{
    
    
    
    self.reportTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 135, self.view.frame.size.width, self.view.frame.size.height-35)];
    self.reportTableView.bounces = NO;
   self.reportTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    sectionArray = [[NSMutableArray alloc] init];
    sectionController = [[ReportSectionsController alloc] init];
    sectionController.tableView = self.reportTableView;
    self.reportTableView.dataSource = sectionController;
    self.reportTableView.delegate = sectionController;
    self.reportTableView.backgroundColor = [UIColor whiteColor];
    sectionController.sections = sectionArray;
    
    
    NSMutableArray *placeVector = [XmwUtils breakStringTokenAsVector : dotReport.reportPlaces : @"$"];
    for (int cntComponentPlace = 0; cntComponentPlace < [placeVector count]; cntComponentPlace++)
    {
        NSString *componentPlace = (NSString*) [placeVector objectAtIndex:cntComponentPlace];
        
        if([componentPlace isEqualToString : XmwcsConst_REPORT_PLACE_HEADER])
        {
            MyDetailsReportHeaderSection* headerSection = [[MyDetailsReportHeaderSection alloc] init];
            headerSection.forwardedDataDisplay = forwardedDataDisplay;
            headerSection.forwardedDataPost = forwardedDataPost;
            headerSection.reportVC = self;
            [sectionArray addObject:headerSection];
        }
        else if([componentPlace isEqualToString : XmwcsConst_REPORT_PLACE_TABLE])
        {
            if([dotReport.reportType isEqualToString:XmwcsConst_REPORT_TYPE_LEGEND])
            {
                ReportLegendSection* legendSection = [[ReportLegendSection alloc] init];
                [sectionArray addObject:legendSection];
                legendSection.reportVC = self;
            }
            
            ReportTabularDataSection* dataSection = [self addTabularDataSection];
            [sectionArray addObject:dataSection];
        }
        else if([componentPlace isEqualToString : XmwcsConst_REPORT_PLACE_FOOTER ])
        {
            ReportFooterSection* footerSection = [[ReportFooterSection alloc] init];
            footerSection.reportVC = self;
            [sectionArray addObject:footerSection];
        }
        else if([componentPlace isEqualToString :XmwcsConst_REPORT_PLACE_SUBHEADER ])
        {
            ReportSubheaderSection* subheaderSection = [[ReportSubheaderSection alloc] init];
            subheaderSection.reportVC = self;
            [sectionArray addObject:subheaderSection];
        }
    }
    [sectionController updateData:dotReport : reportPostResponse ];
    [self.view addSubview : self.reportTableView];
    
}
-(void)headerView:(NSString*)headername{
    NSLog(@"Header Name : %@",headername);
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200*deviceHeightRation)];
    view.backgroundColor = [UIColor colorWithRed:236.0/255 green:236.0/255 blue:236.0/255 alpha:1.0];
    
    UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(0, 10, self.view.bounds.size.width, 35)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor: [UIColor blackColor]];
    [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [label setText: headername];
    
    [label setNumberOfLines: 0];
    [label sizeToFit];
    [label setCenter: CGPointMake(self.view.center.x, label.center.y)];
    [view addSubview:label];
    
     profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 35, 80*deviceWidthRation, 80*deviceHeightRation)];
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"profileImageData"]!=NULL) {
        [profileImageView setImage:[UIImage imageWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"profileImageData"]]];
    }
    else{
        [profileImageView setImage:[UIImage imageNamed:@"user_icon.png"]];
    }
    profileImageView.layer.borderWidth=1.0;
    profileImageView.layer.masksToBounds = false;
    profileImageView.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor whiteColor]);
    profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2;
    profileImageView.clipsToBounds = true;
    
    
    UILabel *customerName = [[UILabel alloc]initWithFrame:CGRectMake(105*deviceWidthRation, 50, 250*deviceWidthRation, 25*deviceHeightRation)];
    customerName.text =[[NSUserDefaults standardUserDefaults] valueForKey:@"CUSTOMER_NAME"];
    customerName.textColor = [UIColor blackColor];
    customerName.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    customerName.numberOfLines = 1;
    customerName.textAlignment = UITextAlignmentLeft;
    
    
    UILabel *regID = [[UILabel alloc]initWithFrame:CGRectMake(105*deviceWidthRation, 75, 150*deviceWidthRation, 20*deviceHeightRation)];
    regID.textColor =  [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
    regID.font = [UIFont fontWithName:@"Helvetica" size:12];
    regID.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"USERNAME"];

    [view addSubview:profileImageView];
    [view addSubview:customerName];
    [view addSubview:regID];
  
    [self.view addSubview:view];
}
@end
