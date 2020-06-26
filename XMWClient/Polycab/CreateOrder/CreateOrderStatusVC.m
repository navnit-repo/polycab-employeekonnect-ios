//
//  CreateOrderStatusVC.m
//  XMWClient
//
//  Created by dotvikios on 25/01/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "CreateOrderStatusVC.h"
#import "LayoutClass.h"
#import "CreateOrderStatusCell.h"
#import "DVAppDelegate.h"
#import "LoadingView.h"
#import "NetworkHelper.h"
#import "ClientVariable.h"
#import "AppConstants.h"
@interface CreateOrderStatusVC ()

@end

@implementation CreateOrderStatusVC
{
    CreateOrderStatusCell *statusCell;
    int cellHeight;
    LoadingView *loadingView;
    NetworkHelper *networkHelper;
}
@synthesize isSPAFlag;
@synthesize businessVerticalName;
@synthesize headerNameLbl;
@synthesize trackerIdLbl,trackerIdValueLbl,orderNumLbl,orderNumValueLbl,customerPoLbl,customerPoValueLbl,poDateLbl,poDateValueLbl,orderStatusLbl,orderStatusValueLbl,statusMsgLbl,statusMsgValueLbl;
@synthesize totalView,totalLbl;
@synthesize mainScrollView;
@synthesize jsonResponse;
@synthesize billToLbl,billToValueLbl,shipToLbl,shipToValueLbl,lineAmountLbl,lineAmountValueLbl,lineTaxAmountLbl,lineTaxAmountValueLbl,totalLineAmountLbl,totalLineAmountValueLbl;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (isSPAFlag) {
        cellHeight = 363 * deviceHeightRation;
    }
    else
    {
      cellHeight = 345*deviceHeightRation;
    }
    
    NSLog(@"Create Order Status VC call");

    [self drawNavigationBarItem];
    
    [self autoLayout];
    NSMutableDictionary *headerDataDict = [[NSMutableDictionary alloc]init];
    NSMutableArray *cardDataArray = [[NSMutableArray alloc]init];
    [cardDataArray addObjectsFromArray:[jsonResponse valueForKey:@"so_lines"]];
    
    long int dataArrayCount = cardDataArray.count;
    dataArrayCount = dataArrayCount-1;
    
    NSString *LINE_AMOUNT;
    NSString *LINE_TAX_AMOUNT;
    NSString *TOT_LINE_AMOUNT;
    
    LINE_AMOUNT = [NSString stringWithFormat:@"%@",  [[cardDataArray objectAtIndex:dataArrayCount] valueForKey:@"LINE_AMOUNT"] ];
    LINE_TAX_AMOUNT =  [NSString stringWithFormat:@"%@",  [[cardDataArray objectAtIndex:dataArrayCount] valueForKey:@"LINE_TAX_AMOUNT"] ];
    TOT_LINE_AMOUNT = [NSString stringWithFormat:@"%@",  [[cardDataArray objectAtIndex:dataArrayCount] valueForKey:@"TOT_LINE_AMOUNT"] ];
 
    
    [headerDataDict setDictionary:[jsonResponse valueForKey:@"so_header"]];
    [headerDataDict setObject:LINE_AMOUNT forKey:@"LINE_AMOUNT"];
    [headerDataDict setObject:LINE_TAX_AMOUNT forKey:@"LINE_TAX_AMOUNT"];
    [headerDataDict setObject:TOT_LINE_AMOUNT forKey:@"TOT_LINE_AMOUNT"];
    
    [ self setHeaderData:headerDataDict :[jsonResponse valueForKey:@"status"]];
   
    [self drawItemCell:cardDataArray];
    
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)autoLayout
{
    [LayoutClass setLayoutForIPhone6:self.mainScrollView];
    [LayoutClass setLayoutForIPhone6:self.totalView];
    [LayoutClass labelLayout:self.headerNameLbl forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.totalLbl forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.trackerIdLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.trackerIdValueLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.orderNumLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.orderNumValueLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.customerPoLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.customerPoValueLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.poDateLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.poDateValueLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.orderStatusLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.orderStatusValueLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.statusMsgLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.statusMsgValueLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.billToLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.billToValueLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.shipToLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.shipToValueLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.lineAmountLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.lineAmountValueLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.lineTaxAmountLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.lineTaxAmountValueLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.totalLineAmountLbl forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.totalLineAmountValueLbl forFontWeight:UIFontWeightRegular];
    
    [LayoutClass buttonLayout:self.cancelButtonOutlet forFontWeight:UIFontWeightRegular];
    [LayoutClass buttonLayout:self.confirmButtonOutLet forFontWeight:UIFontWeightRegular];
    
    self.cancelButtonOutlet.layer.cornerRadius = 5.0f;
    self.cancelButtonOutlet.layer.masksToBounds = YES;
    self.confirmButtonOutLet.layer.cornerRadius = 5.0f;
    self.confirmButtonOutLet.layer.masksToBounds = YES;
       
    
   
}
-(void) drawNavigationBarItem
{
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage
                                                                          imageNamed:@"back-button"]  style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(backHandler:)];

    backButton.tintColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
    
    
    UIImageView *polycabLogo = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"polycab_logo"]];
    self.navigationItem.titleView.contentMode = UIViewContentModeCenter;
    self.navigationItem.titleView = polycabLogo;
    
    // Pradeep: 2020-06-26, we do not want to show back button
    // [self.navigationItem setLeftBarButtonItem:backButton];
    
}

- (void) backHandler : (id) sender
{
//    [ [self navigationController]  popViewControllerAnimated:YES];
    NSMutableArray *viewControllersArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
       NSMutableArray *dummyViewControllers = [[NSMutableArray alloc ] init];
       [dummyViewControllers addObject: [viewControllersArray objectAtIndex:0]];
       
                                                     
        [self.navigationController setViewControllers:dummyViewControllers animated:YES];
    
}


-(void)setHeaderData:(NSMutableDictionary*)dict :(NSString *)status
{
    NSString *tId;
    NSString *ordNo;
    NSString *custPO;
    NSString *poDate;
    NSString *ordStatus;
    NSString *statusMsg;
    NSString *billTo;
    NSString *shipTo;
    NSString *lineAmount;
    NSString *lineTaxAmount;
    NSString *totalLineAmount;
    
    
    tId = [dict valueForKey:@"TRACKER_ID"];
    ordNo = [dict valueForKey:@"ORDER_NUMBER"];
    custPO = [dict valueForKey:@"CUSTOMER_PO"];
    poDate = [dict valueForKey:@"PO_DATE"];
    ordStatus = status;
    billTo = [dict valueForKey:@"BILL_TO_SITE"];
    shipTo = [dict valueForKey:@"SHIP_TO_SITE"];
    lineAmount = [dict valueForKey:@"LINE_AMOUNT"];
    lineTaxAmount = [dict valueForKey:@"LINE_TAX_AMOUNT"];
    totalLineAmount = [dict valueForKey:@"TOT_LINE_AMOUNT"];
    statusMsg = [dict valueForKey:@"ERROR_MESSAGE"];
    if (tId ==nil || [tId isKindOfClass:[NSNull class]]) {
        tId = @"";
    }
    if (ordNo ==nil || [ordNo isKindOfClass:[NSNull class]]) {
        ordNo = @"";
    }
    if (custPO ==nil || [custPO isKindOfClass:[NSNull class]]) {
        custPO = @"";
    }
    if (poDate ==nil || [poDate isKindOfClass:[NSNull class]]) {
        poDate = @"";
    }
    if (ordStatus ==nil || [ordStatus isKindOfClass:[NSNull class]]) {
        ordStatus = @"";
    }
    if (statusMsg ==nil || [statusMsg isKindOfClass:[NSNull class]]) {
        statusMsg = @"";
    }
    if (billTo ==nil || [billTo isKindOfClass:[NSNull class]]) {
        billTo = @"";
    }
    if (shipTo ==nil || [shipTo isKindOfClass:[NSNull class]]) {
        shipTo = @"";
    }
    if (lineAmount ==nil || [lineAmount isKindOfClass:[NSNull class]]) {
        lineAmount = @"";
    }
    if (lineTaxAmount ==nil || [lineTaxAmount isKindOfClass:[NSNull class]]) {
        lineTaxAmount = @"";
    }
    if (totalLineAmount ==nil || [totalLineAmount isKindOfClass:[NSNull class]]) {
        totalLineAmount = @"";
    }
    
    trackerIdValueLbl.text = tId;
    orderNumValueLbl.text = ordNo;
    customerPoValueLbl.text = custPO;
    poDateValueLbl.text = poDate;
    orderStatusValueLbl.text = ordStatus;
    statusMsgValueLbl.text = statusMsg;
    billToValueLbl.text = billTo;
    shipToValueLbl.text = shipTo;
    lineAmountValueLbl.text = lineAmount;
    lineTaxAmountValueLbl.text = lineTaxAmount;
    totalLineAmountValueLbl.text = totalLineAmount;
    totalView.layer.cornerRadius = 5.0f;
    totalView.layer.masksToBounds = YES;
    
}

-(void)drawItemCell:(NSMutableArray *)data
{
    int totalScrollViewHeight=0;
    long int total_data_count = data.count;
    total_data_count = total_data_count -1;
    
    [data removeObjectAtIndex:total_data_count];
    for (int i=0; i<data.count; i++) {
        statusCell = [CreateOrderStatusCell CreateInstance :isSPAFlag];
        [statusCell configure:[data objectAtIndex:i] :businessVerticalName];
        
        statusCell.frame = CGRectMake(10, i*cellHeight,statusCell.frame.size.width*deviceWidthRation , statusCell.frame.size.height*deviceHeightRation);
        statusCell.layer.cornerRadius = 5.0f;
        statusCell.layer.masksToBounds = YES;
        
        [mainScrollView addSubview:statusCell];
        totalScrollViewHeight = cellHeight*(int)data.count;
        
    }
    [mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width,totalScrollViewHeight)];
}
#pragma mark - Button Handler

- (IBAction)confirmButton:(id)sender {
       loadingView = [LoadingView loadingViewInView:self.view];
       ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
       NSMutableDictionary *headerDataDict = [[NSMutableDictionary alloc] init];
       [headerDataDict setDictionary:[jsonResponse valueForKey:@"so_header"]];
    
       NSMutableDictionary *sendDict = [[NSMutableDictionary alloc]init];
       NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
       [data setValue:@"Confirm" forKey:@"confirmation_flag"];
       [data setObject:[headerDataDict objectForKey:@"USERNAME"] forKey:@"user_id"];
       [data setObject:[headerDataDict objectForKey:@"TRACKER_ID"] forKey:@"tracker_id"];
       [data setObject:[headerDataDict objectForKey:@"ACCOUNT_NUMBER"] forKey:@"account_number"];
       [data setObject:[headerDataDict objectForKey:@"BILL_TO"] forKey:@"bill_to"];
       [data setObject:[headerDataDict objectForKey:@"SHIP_TO"] forKey:@"ship_to"];
    
       [sendDict setValue:@"reConfirmation" forKey:@"opcode"];
       [sendDict setValue:clientVariables.CLIENT_LOGIN_RESPONSE.authToken forKey:@"authToken"];
       [sendDict setObject: data forKey:@"data"];


       NetworkHelper *networkHelper = [[NetworkHelper alloc]init];

       NSString *url = XmwcsConst_OPCODE_URL;
       networkHelper.serviceURLString = url;
       [networkHelper genericJSONPayloadRequestWith:sendDict :self :@"reConfirmation"];
}
- (IBAction)cancelButton:(id)sender {
       loadingView = [LoadingView loadingViewInView:self.view];
       ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
       NSMutableDictionary *headerDataDict = [[NSMutableDictionary alloc] init];;
       [headerDataDict setDictionary:[jsonResponse valueForKey:@"so_header"]];
    
       NSMutableDictionary *sendDict = [[NSMutableDictionary alloc]init];
       NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
       [data setValue:@"Cancel" forKey:@"confirmation_flag"];
       [data setObject:[headerDataDict objectForKey:@"USERNAME"] forKey:@"user_id"];
       [data setObject:[headerDataDict objectForKey:@"TRACKER_ID"] forKey:@"tracker_id"];
       [data setObject:[headerDataDict objectForKey:@"ACCOUNT_NUMBER"] forKey:@"account_number"];
       [data setObject:[headerDataDict objectForKey:@"BILL_TO"] forKey:@"bill_to"];
       [data setObject:[headerDataDict objectForKey:@"SHIP_TO"] forKey:@"ship_to"];
    
       [sendDict setValue:@"reConfirmation" forKey:@"opcode"];
       [sendDict setValue:clientVariables.CLIENT_LOGIN_RESPONSE.authToken forKey:@"authToken"];
       [sendDict setObject: data forKey:@"data"];


       NetworkHelper *networkHelper = [[NetworkHelper alloc]init];

       NSString *url = XmwcsConst_OPCODE_URL;
       networkHelper.serviceURLString = url;
       [networkHelper genericJSONPayloadRequestWith:sendDict :self :@"reConfirmation"];
}

- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    [loadingView removeView];
    if ([callName isEqualToString:@"reConfirmation"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Polycab Connect" message:[respondedObject objectForKey:@"message"]  preferredStyle:UIAlertControllerStyleAlert];
           
           UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               
               NSString *flag = requestedObject[@"data"][@"confirmation_flag"];
               
               [self setDummyViewController :flag];
           }];
           [alert addAction:action];
           [self presentViewController:alert animated:YES completion:nil];
       
    }
    
}
- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Polycab Connect" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self setDummyViewControllerToDashboard];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}
-(void) setDummyViewControllerToDashboard
{
    NSMutableArray *viewControllersArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    NSMutableArray *dummyViewControllers = [[NSMutableArray alloc ] init];
    [dummyViewControllers addObject: [viewControllersArray objectAtIndex:0]];
    [self.navigationController setViewControllers:dummyViewControllers animated:YES];
}
-(void) setDummyViewController :(NSString*) flag
{
    if ([flag isEqualToString:@"Confirm"]) {
        [self setDummyViewControllerToDashboard];
    }
    else if ([flag isEqualToString:@"Cancel"])
    {
        NSMutableArray *viewControllersArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
           NSMutableArray *dummyViewControllers = [[NSMutableArray alloc ] init];
           [dummyViewControllers addObject: [viewControllersArray objectAtIndex:0]];
           [dummyViewControllers addObject: [viewControllersArray objectAtIndex:1]];
           [self.navigationController setViewControllers:dummyViewControllers animated:YES];
    }
    
}
@end
