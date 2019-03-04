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
@interface CreateOrderStatusVC ()

@end

@implementation CreateOrderStatusVC
{
    CreateOrderStatusCell *statusCell;
    int cellHeight;
}
@synthesize businessVerticalName;
@synthesize headerNameLbl;
@synthesize trackerIdLbl,trackerIdValueLbl,orderNumLbl,orderNumValueLbl,customerPoLbl,customerPoValueLbl,poDateLbl,poDateValueLbl,orderStatusLbl,orderStatusValueLbl,statusMsgLbl,statusMsgValueLbl;
@synthesize totalView,totalLbl;
@synthesize mainScrollView;
@synthesize jsonResponse;
@synthesize billToLbl,billToValueLbl,shipToLbl,shipToValueLbl,lineAmountLbl,lineAmountValueLbl,lineTaxAmountLbl,lineTaxAmountValueLbl,totalLineAmountLbl,totalLineAmountValueLbl;
- (void)viewDidLoad {
    [super viewDidLoad];
    cellHeight = 345*deviceHeightRation;
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
    
   
}
-(void) drawNavigationBarItem
{
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage
                                                                          imageNamed:@"back-button"]  style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(backHandler:)];

  //  backButton.tintColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
    
      backButton.tintColor = [UIColor whiteColor];
    UIImageView *polycabLogo = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"polycab_logo"]];
    self.navigationItem.titleView.contentMode = UIViewContentModeCenter;
    self.navigationItem.titleView = polycabLogo;
    [self.navigationItem setLeftBarButtonItem:backButton];
    
}

- (void) backHandler : (id) sender
{
    [ [self navigationController]  popViewControllerAnimated:YES];
    
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
        statusCell = [CreateOrderStatusCell CreateInstance];
        [statusCell configure:[data objectAtIndex:i] :businessVerticalName];
        
        statusCell.frame = CGRectMake(10, i*cellHeight,statusCell.frame.size.width*deviceWidthRation , statusCell.frame.size.height*deviceHeightRation);
        statusCell.layer.cornerRadius = 5.0f;
        statusCell.layer.masksToBounds = YES;
        
        [mainScrollView addSubview:statusCell];
        totalScrollViewHeight = cellHeight*(int)data.count;
        
    }
    [mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width,totalScrollViewHeight)];
}

@end
