//
//  ProofOfDeliveryVC.m
//  QCMSProject
//
//  Created by Pradeep Singh on 3/6/17.
//  Copyright © 2017 dotvik. All rights reserved.
//

#import "ProofOfDeliveryVC.h"
#import "XmwcsConstant.h"
#import "ReportSectionsController.h"
#import "ExpandableRowTabularDataSection.h"
#import "XmwUtils.h"
#import "PODFormUpdateSection.h"
#import "Styles.h"

#import "ClientVariable.h"
#import "DVAppDelegate.h"


#define kReportSectionHeader 0
#define kReportSectionSubHeader 1
#define kReportSectionLegend 2
#define kReportSectionTable 3
#define kReportSectionFooter 4

#define kTotalSections 5


@interface ProofOfDeliveryVC () <DrilldownControlDelegate>
{
    
    ReportSectionsController* sectionController;
    NSMutableArray *sectionArray;
    UIBarButtonItem*  downloadButton;
    
    int sectionFlag[kTotalSections];
    
    UIScrollView* hScrollView;
    
    UITextField* activeTextField;
    
    CGRect origin_frameSize;
}

@end

@implementation ProofOfDeliveryVC


- (void)viewDidLoad
{
    
    for(int i=0; i<kTotalSections; i++) {
        sectionFlag[i] = 0;
    }
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [Styles formBackgroundColor];
    
    [self.navigationItem setRightBarButtonItem:nil];
    
    self.drilldownDelegate = self;
    
    
    [self registerForKeyboardNotifications];
    
}


- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) initializeView
{
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    dotReport = [clientVariables.DOT_REPORT_MAP objectForKey:reportPostResponse.viewReportId];
    
    
    hScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    hScrollView.scrollEnabled = YES;
    hScrollView.delegate = self;
    
    
    // default hScrollView content size is same its size
    
    hScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    
    
    [self.view addSubview:hScrollView];
    
}

-(void) makeReportScreenV2
{
    self.reportTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.reportTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.reportTableView.backgroundColor = [Styles formBackgroundColor];
    
    [self.reportTableView registerNib:[UINib nibWithNibName:@"PODTableViewCell" bundle:nil] forCellReuseIdentifier:@"PODTableViewCell"];
    
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
        
        if([componentPlace isEqualToString : XmwcsConst_REPORT_PLACE_TABLE])
        {
            ReportTabularDataSection* dataSection = [self addTabularDataSection];
            [sectionArray addObject:dataSection];
        }
    }

    
    if([reportPostResponse.tableData count]>0) {
        PODFormUpdateSection* formSection = [[PODFormUpdateSection alloc] init];
        formSection.dotFormId = @"DOT_FORM_12_1";
        formSection.reportVC = self;
    
        [sectionArray addObject:formSection];
        [sectionController updateData:dotReport : reportPostResponse ];
        
        NSInteger scrollWidth = 0;
        
        
        NSArray* sortedElementIds =[DotReportDraw sortRptComponents : dotReport.reportElements : XmwcsConst_REPORT_PLACE_TABLE];
        
        if([sortedElementIds count]>0) {
            NSInteger defaultColumnWidth = self.view.frame.size.width/[sortedElementIds count];
            
            for(int i=0; i<[sortedElementIds count]; i++) {
                DotReportElement* dotReportElement = [dotReport.reportElements  objectForKey:[sortedElementIds objectAtIndex:i]];
                if(dotReportElement.length!=nil) {
                    if([dotReportElement.componentType isEqualToString:@"HIDDEN"]) {
                        NSLog(@"Field is hidden = %@", dotReportElement.elementId);
                    } else {
                        scrollWidth = scrollWidth +  [dotReportElement.length integerValue];
                    }
                } else {
                    scrollWidth = scrollWidth + defaultColumnWidth;
                }
            }
        }
        
        // this will make tableView also scroll horizontally with the columns are more
        if(scrollWidth>self.view.frame.size.width) {
            hScrollView.contentSize = CGSizeMake(scrollWidth, self.view.frame.size.height);
            self.reportTableView.frame = CGRectMake(0, 0, scrollWidth, self.view.frame.size.height);
        }
        
        [hScrollView addSubview : self.reportTableView];
    
    } else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Proof of Delivery" message:@"No record found!" preferredStyle:UIAlertControllerStyleAlert];
        
        //rate action
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self dismissViewControllerAnimated:YES completion:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
        }]];
        
        //get current view controller and present alert
        [self presentViewController:alert animated:YES completion:NULL];
        
    }
    
    origin_frameSize = self.reportTableView.frame;
    
}


-(ReportTabularDataSection*) addTabularDataSection
{
    
    ExpandableRowTabularDataSection* dataSection = [[ExpandableRowTabularDataSection alloc] init];
    dataSection.forwardedDataDisplay = forwardedDataDisplay;
    dataSection.forwardedDataPost = forwardedDataPost;
    dataSection.reportVC = self;
    
    return  dataSection;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - DrilldownControlDelegate
-(void) handleDrilldownForRow:(NSInteger) rowIndex withRowData:(NSArray*) rowData
{
    NSLog(@"ProofOfDeliveryVC.handleDrilldownForRow for row index = %ld", rowIndex);
    
    
    NSMutableArray *sortedElementIds = [DotReportDraw sortRptComponents:self.dotReport.reportElements :XmwcsConst_REPORT_PLACE_TABLE];
    NSMutableArray *selectedRowElement = (NSMutableArray *)[self.reportPostResponse.tableData objectAtIndex:rowIndex];
    
    
    
}


#pragma mark - UITextFieldDelegate


- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"ProofOfDeliveryVC textFieldShouldBeginEditing");
    activeTextField = textField;
    
    
    return YES;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"ProofOfDeliveryVC textFieldDidBeginEditing field tag = %d", textField.tag);
    
    activeTextField = textField;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"ProofOfDeliveryVC textFieldShouldReturn field tag = %d", textField.tag);
    [textField resignFirstResponder];
    
    //[self setViewMovedUp:NO :0];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"ProofOfDeliveryVC textFieldDidEndEditing field tag = %d", textField.tag);
    
    
    
}



#pragma mark - KeyBoardEvents


// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    // Get the keyboard size
    CGRect keyboardBounds;
    [[aNotification.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
    
    // Detect orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect frame = origin_frameSize;//cardDetailTableList.frame;
    
    
    // Start animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    // Reduce size of the Table view
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        frame.size.height -= keyboardBounds.size.height;
    else
        frame.size.height -= keyboardBounds.size.width;
    
    // Apply new size of table view
    
    self.reportTableView.frame = frame;
    
    // Scroll the table view to see the TextField just above the keyboard
    if (activeTextField)
    {
        CGRect textFieldRect = [self.reportTableView convertRect:activeTextField.bounds fromView:activeTextField];
        [self.reportTableView scrollRectToVisible:textFieldRect animated:NO];
    }
    
    [UIView commitAnimations];
    
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
    // Get the keyboard size
    CGRect keyboardBounds;
    [[aNotification.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
    
    // Detect orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect frame = self.reportTableView.frame;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    // Increase size of the Table view
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        frame.size.height += keyboardBounds.size.height;
    else
        frame.size.height += keyboardBounds.size.width;
    
    // Apply new size of table view
    self.reportTableView.frame = frame;
    
    [UIView commitAnimations];
    
}

@end
