//
//  ReportVC.m
//  EMSSales
//
//  Created by Puneet Arora on 14/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ReportVC.h"

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


// for new section architecture

#import "ReportSectionsController.h"
#import "ReportTabularDataSection.h"
#import "ReportHeaderSection.h"
#import "ReportSubheaderSection.h"
#import "ReportFooterSection.h"
#import "ReportLegendSection.h"

#import "DownloadHistoryMenuView.h"

@interface ReportVC ()
{
    
    
    UIBarButtonItem*  downloadButton;
    
  
}
@end

@implementation ReportVC

@synthesize downloadHistoryMenuList;
@synthesize imageView;

static bool showMenu = true;
static DownloadHistoryMenuView* rightSlideMenu = nil;


@synthesize reportTableView;
@synthesize menuDetailMap,dataForNextScreen,nextScreenPost;
@synthesize screenId, dotReport, reportPostResponse,forwardedDataDisplay,forwardedDataPost;


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
    
    self.needRefresh = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshReport) name:@"ReportNeedRefresh" object:nil];
    
    
    if(isiPhone10) {
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
    
    [self initializeView];
    
    [self drawHeaderItem];
    
    [self makeReportScreenV2];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}


-(void) drawHeaderItem
{
    self.title = dotReport.screenHeader;
    
     self.navigationController.navigationBar.tintColor = [Styles barButtonTextColor];
    
    
    /*
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(backHandler:)];
    backButton.tintColor = [Styles barButtonTextColor];
    [self.navigationItem setLeftBarButtonItem:backButton];
     */
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage
                                                                          imageNamed:@"back-button"] style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(backHandler:)];
    
    //backButton.tintColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
    backButton.tintColor = [UIColor whiteColor];
    
    [self.navigationItem setLeftBarButtonItem:backButton];
    
    
      //animate custom view add
    
    NSArray *images = [NSArray arrayWithObjects:
                        [UIImage imageNamed:@"downloadImage.png"],
                        [UIImage imageNamed:@"downloadImage1.png"],
                        [UIImage imageNamed:@"downloadImage2.png"],
                        [UIImage imageNamed:@"downloadImage3.png"],
                       nil];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"downloadImage.png"]];
    
    self.imageView.animationImages = images;
    
    self.imageView.animationDuration = 0.8;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.bounds = imageView.bounds;
    
    [button addSubview:imageView];
    
    [button addTarget:self action:@selector(downloadButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView: button] ;
    
    
    //[self.navigationItem setRightBarButtonItem:rightBarButton];
    
    
    
    [self drawTitle: dotReport.screenHeader];
    
}




- (void) backHandler : (id) sender {
    [ [self navigationController]  popViewControllerAnimated:YES];
    
    // if( self.screenId==XmwcsConst_WorkflowMainScreen) {
	//	[DVAppDelegate popModuleContext];
    // }
}



-(void) initializeView
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    dotReport = [clientVariables.DOT_REPORT_MAP objectForKey:reportPostResponse.viewReportId];
    
     //reportTableView         = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStylePlain];
    
   // dotReportDraw = [[DotReportDraw alloc] init];
	// [dotReportDraw  makeReportScreen :self :  dotReport :  reportPostResponse :  forwardedDataDisplay : forwardedDataPost];
    
}

-(void) drawTitle:(NSString *)headerStr
{
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    // self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
//    UILabel*  titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
//    titleLabel.text = dotReport.screenHeader;
//    titleLabel.textColor = [UIColor blackColor];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.backgroundColor = [UIColor clearColor];
    
    
    UIImageView *polycabLogo = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"polycab_logo"]];
    self.navigationItem.titleView.contentMode = UIViewContentModeCenter;
    self.navigationItem.titleView = polycabLogo;
    
  //  [self.navigationItem setTitleView: titleLabel];
    
   
    [self headerView:dotReport.screenHeader];
    


}




-(void)headerView:(NSString*)headername{
    NSLog(@"Header Name : %@",headername);
    
    UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(0, 10, self.view.bounds.size.width, 35)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor: [UIColor blackColor]];
    [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [label setText: [headername uppercaseString]];
    
    [label setNumberOfLines: 0];
    [label sizeToFit];
    [label setCenter: CGPointMake(self.view.center.x, label.center.y)];
    [self.view addSubview:label];
}
-(void) makeReportScreenV2
{
    
    
    
    self.reportTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 35, self.view.frame.size.width, self.view.frame.size.height-35)];
    self.reportTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    sectionArray = [[NSMutableArray alloc] init];
    sectionController = [[ReportSectionsController alloc] init];
    sectionController.tableView = self.reportTableView;
    self.reportTableView.dataSource = sectionController;
    self.reportTableView.delegate = sectionController;
    
    sectionController.sections = sectionArray;
    
    
    NSMutableArray *placeVector = [XmwUtils breakStringTokenAsVector : dotReport.reportPlaces : @"$"];
    for (int cntComponentPlace = 0; cntComponentPlace < [placeVector count]; cntComponentPlace++)
    {
        NSString *componentPlace = (NSString*) [placeVector objectAtIndex:cntComponentPlace];
        
        if([componentPlace isEqualToString : XmwcsConst_REPORT_PLACE_HEADER])
        {
            ReportHeaderSection* headerSection = [[ReportHeaderSection alloc] init];
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


-(ReportTabularDataSection*) addTabularDataSection
{
    ReportTabularDataSection* dataSection = [[ReportTabularDataSection alloc] init];
    dataSection.forwardedDataDisplay = forwardedDataDisplay;
    dataSection.forwardedDataPost = forwardedDataPost;
    dataSection.reportVC = self;
    
    return  dataSection;
}

-(void) updateReport
{
    if(self.reportTableView==nil) return;
    
    [sectionController updateData:dotReport : reportPostResponse ];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[menuDetailMap objectForKey:@"FOR_OPERATION"]  isEqualToString:@"DELETE"])
        return UITableViewCellEditingStyleDelete;

    return UITableViewCellEditingStyleNone;
}


- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - Action Methods

-(void) deSelect:(id)sender
{
	[(UITableView *)sender deselectRowAtIndexPath:[(UITableView *)sender indexPathForSelectedRow] animated:YES];
}

#pragma mark - Helper Methods

-(id) getGradientColor:(UIView *)myView
{
    static NSMutableArray *colors           = nil;
    if (colors == nil)
    {
        colors                              = [[NSMutableArray alloc] initWithCapacity:3];
        UIColor *color                      = nil;
        color                               = [UIColor colorWithRed:0.82 green:0.84 blue:0.87 alpha:1.0];
        [colors addObject:(id)[color CGColor]];
        color                               = [UIColor colorWithRed:0.41 green:0.41 blue:0.59 alpha:1.0];
        [colors addObject:(id)[color CGColor]];
        color                               = [UIColor colorWithRed:0.41 green:0.41 blue:0.59 alpha:1.0];
        [colors addObject:(id)[color CGColor]];
    }
    CAGradientLayer *gradient               = [CAGradientLayer layer];
    gradient.frame                          = myView.frame;
    gradient.colors                         = [NSArray arrayWithArray:colors];
    
    return gradient;
}

-(void) initializeHeaderData
{
    
}

-(void) initializeTableData
{}

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
-(IBAction) buttonPressed:(id) sender
{
    ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    
    //Button* buttonClicked = qobject_cast<Button*>(sender());
    MXButton* buttonClicked = (MXButton*) sender;
	//DotButton* dotButton = reinterpret_cast<DotButton*> (buttonClicked);

	//qDebug() << "DotFormController::ReportScreenController()" << dotButton->getId()  << endl;
    
    DotFormPost* dotFormPost = [[DotFormPost alloc]init];
    [dotFormPost setAdapterId:dotReport.ddAdapterId];
    [dotFormPost setDocId:dotReport.reportId];
	[dotFormPost setDocDesc:dotReport.screenHeader];
	[dotFormPost setAdapterType:dotReport.ddAdapterType];
	[dotFormPost setModuleId:[DVAppDelegate currentModuleContext]];
	dotFormPost.maxDocId  = [NSNumber numberWithInt:clientVariables.MAX_DOC_ID_CREATED];
    
    NSInteger remarksFieldId = TAG_KEY_REMARK_TEXTFIELD;
    MXTextField* textField = (MXTextField*)[[self view] viewWithTag:TAG_KEY_REMARK_TEXTFIELD];
    if(textField!=nil) {
        NSLog(@"Got the remark textField for sending remark");
        [dotFormPost.postData setObject: textField.text forKey:@"REMARK_TEXTFIELD"];
        [dotFormPost.displayData setObject: textField.text forKey:@"REMARK_TEXTFIELD"];
        
    }
    
    NSString* attachedData = (NSString*)buttonClicked.attachedData;
    
    [dotFormPost.postData setObject:buttonClicked.elementId forKey:attachedData];
    [dotFormPost.displayData setObject:buttonClicked.elementId forKey:attachedData ];
    
    NSArray* keys = [forwardedDataPost allKeys];
    
	for(int i=0; i<[keys count]; i++)
    {
		 NSString* key  = [keys objectAtIndex:i];
		 [dotFormPost.postData setObject:[forwardedDataPost objectForKey:key] forKey:key];
	}
     loadingView = [LoadingView loadingViewInView:self.view];
    
    NetworkHelper *networkHelper = [[NetworkHelper alloc] init];
   [networkHelper makeXmwNetworkCall:dotFormPost :self : nil :  XmwcsConst_CALL_NAME_FOR_SUBMIT];
    
    
}

#pragma mark - HttpEventListener

- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    [loadingView removeView];
    
    NSLog(@"ReportScreenController::formResponseHandler");
   
     if([callName isEqualToString:XmwcsConst_CALL_NAME_FOR_SUBMIT]) {
            DocPostResponse *docPostResponse = (DocPostResponse *)respondedObject;
            NSString *message = docPostResponse.submittedMessage;
         
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Info!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
            [myAlertView show];
     } else if([callName isEqualToString:XmwcsConst_CALL_NAME_FOR_REPORT]) {
         ReportPostResponse *tempPostResponse = (ReportPostResponse*) respondedObject;
         
         if(tempPostResponse !=nil && [tempPostResponse isKindOfClass:[reportPostResponse class]]) {
             self.reportPostResponse = tempPostResponse;
             // we need to reload the table
             
             for(int i=0; i<[sectionArray count]; i++) {
                 ReportBaseSection* baseSection = (ReportBaseSection*)[sectionArray objectAtIndex:i];
                 if([baseSection isKindOfClass:[ReportTabularDataSection class]]) {
                     [baseSection updateData:self.dotReport :self.reportPostResponse ];
                     [self.reportTableView reloadSections:[[NSIndexSet alloc] initWithIndex:i] withRowAnimation:UITableViewRowAnimationNone];
                     return;
                 }
             }
         }
     }
}

- (void) httpFailureHandler : (NSString*) callName : (NSString*) message
{
    [loadingView removeView];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    
    [ [self navigationController]  popViewControllerAnimated:YES];
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
    
	return TRUE;
}



-(UIView*) makeBottomLegends
{
    
    UIView* container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    NSMutableDictionary *colorMap = (NSMutableDictionary *)[clientVariables.CLIENT_APP_MASTER_DATA objectForKey:dotReport.legendColorOn];
    NSMutableDictionary *nameMap = (NSMutableDictionary *)[clientVariables.CLIENT_APP_MASTER_DATA objectForKey:dotReport.legendNameOn];
    NSArray* nameKeys = [nameMap allKeys];
    
    CGFloat screenWidth = self.view.frame.size.width;
    
    
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
        [mItemLabel setFont:[UIFont systemFontOfSize:14]];
        
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
            [mItemLabel setFont:[UIFont systemFontOfSize:14]];
            
            [elementContainer addSubview:mItemLabel];
            
            UIView* legendCont = [[UIView alloc]initWithFrame:CGRectMake(screenWidth-cellHeight - 10, 1, cellHeight, cellHeight)];
            legendCont.backgroundColor = [XmwUtils colorWithHexString:colorCode];
            
            [elementContainer addSubview:legendCont];
            
        }
        
        [container addSubview:elementContainer];
        y_Rel = y_Rel + leftLabelHeight;
    }
    
    [container setFrame:CGRectMake(0, self.view.frame.size.height - y_Rel, screenWidth, y_Rel) ];
    
    return container;
}

//code added by ashish tiwari
-(void)setDataInDownloadHistoryMenuViewList
{
    NSMutableArray *directoryStack = [[NSMutableArray alloc] init];
    NSArray *dirPaths;
    NSMutableArray *directoryFiles;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *docsDir = dirPaths[0];
    
    [directoryStack addObject:docsDir];
    
    NSLog(@"XmwFileExplorer: Document Directory = %@ ", docsDir);
    if([directoryStack count] >0) {
        NSString* currentDir = [directoryStack objectAtIndex:([directoryStack count] -1)];
        directoryFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:currentDir error:nil];
        NSLog(@"%@", directoryFiles);
    }
    
    
    downloadHistoryMenuList = [[NSMutableArray alloc] init];
    for (int i =0; i<[directoryFiles count]; i++)
    {
     NSString *fileName  =    [directoryFiles objectAtIndex:i];
        NSRange range = [fileName rangeOfString:@".db"];
        NSRange rangeStorage = [fileName rangeOfString:@"MAIN_OBJECT_STORAGE"];
        if(range.length > 0)
        {
            //no need to add file in download history array
        }
        else if(rangeStorage.length>0)
        {
            //again no need to add file in doownload history
        }
        else
        {
            [downloadHistoryMenuList addObject:fileName];

        }
    }
    
    //[downloadHistoryMenuList addObject:@"xyz.pdf"];
    //[downloadHistoryMenuList addObject:@"postTwitter.doc"];
    //[downloadHistoryMenuList addObject:@"GalaxyPlanet.pdf"];
    //[downloadHistoryMenuList addObject: @"sunshine.xls"];
    
    
    
}
- (void) downloadButtonHandler : (id) sender
{
    // [self.imageView stopAnimating];
    [self setDataInDownloadHistoryMenuViewList];
    
    
    if(showMenu)
    {
        rightSlideMenu = [[DownloadHistoryMenuView alloc] initWithFrame:CGRectMake( self.view.bounds.size.width/2, -250, self.view.bounds.size.width/2, [downloadHistoryMenuList count]*40) withMenu:downloadHistoryMenuList handler:self];
        
        [self.view addSubview : rightSlideMenu];
        
        [UIView beginAnimations:@"rightSlideMenu" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        rightSlideMenu.frame = CGRectMake( self.view.bounds.size.width/2, 0.0f, self.view.bounds.size.width/2, [downloadHistoryMenuList count]*40);
        
        [UIView commitAnimations];
        
        showMenu = false;
        
    }
    else
    {
        [UIView beginAnimations:@"rightSlideMenu" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(menuRemoved:)];
        rightSlideMenu.frame = CGRectMake( self.view.bounds.size.width/2, -250, self.view.bounds.size.width/2, [downloadHistoryMenuList count]*40);
        [UIView commitAnimations];
        
        showMenu = true;
    }
   
    
}

-(IBAction)menuRemoved:(id)sender
{
    //NSLog(@"menuRemoved");
    [rightSlideMenu removeFromSuperview];
    
}

-(void) downloadHistoryClicked : (int) idx
{
    //NSLog(@"Shared menu clicked with idx %d", idx);
    [rightSlideMenu removeFromSuperview];
    showMenu = true;
    
}

-(void) downloadCompleted :(NSString*) savedFilename
{
    NSLog(@"control comes on download Complete Function");
    
    [self.imageView stopAnimating];
    
    [XmwUtils toastView:@"Download Complete"];
    
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:web];

    NSString *path = savedFilename;
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [web loadRequest:request];
    [web setScalesPageToFit:YES];
    
    
    
}
-(void) percentDownloadComplete : (float) percent
{
    NSLog(@"control comes on percent download Complete Function = %f", percent);
    
    
}

-(void) setNeedRefresh:(BOOL)inNeedRefresh
{
    needRefresh = inNeedRefresh;
}

-(void)  refreshReport
{
    if(needRefresh==YES && self.requestFormPost!=nil) {
        loadingView = [LoadingView loadingViewInView:self.view];
        NetworkHelper *networkHelper = [[NetworkHelper alloc] init];
        [networkHelper makeXmwNetworkCall:self.requestFormPost :self :nil :XmwcsConst_CALL_NAME_FOR_REPORT];
        
    }
}

@end
