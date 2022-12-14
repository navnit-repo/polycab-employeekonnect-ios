//
//  CreateOrderVC2.m
//  XMWClient
//
//  Created by dotvikios on 10/08/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "CreateOrderVC2.h"
#import "SearchViewController.h"
#import "CreateOrderDisplayCell.h"
#import "Styles.h"
#import "NetworkHelper.h"
#import "LoadingView.h"
#import "XmwcsConstant.h"
#import "HttpEventListener.h"
#import "LayoutClass.h"
#import "DVAppDelegate.h"
#import "ClientVariable.h"
#import "CreateOrderStatusVC.h"
#import "CreditLimitDetailsMessage.h"

/// create order cell tag start 2000
/// add from catalog button tag 100
/// search product button tag 101
@interface CreateOrderVC2 ()<SearchViewMultiSelectDelegate>
@end
@implementation CreateOrderVC2{
    
    NSMutableArray *numberOfCell;
    UITableView *mainTableView;
    long int totalCell;
    CreateOrderDisplayCell *displayCell;
    NSMutableArray *alreadyAddDisplayCellData;
    LoadingView *loadingView;
    NetworkHelper *networkHelper;
    NSMutableArray* removeTag;
    CGSize keyboardSize;
    UITextField* activeTextField;
    BOOL returnPress;
    NSString *trackerID;
    int totalSeconds;
    NSTimer *fiveMinTimer;
    NSMutableDictionary *cellIndexQntyValueDict;
    BOOL packSizeFlagCheck;
    UIButton *searchButton;
    int lineItemCount;
    bool oneTimeSuccessFlagCheck;
}

@synthesize itemName,orderRefNo,dateofDelivery;
@synthesize mainView;
@synthesize createOrderDynamicCellHeight;

-(void)autoLayout{
    [LayoutClass labelLayout:self.itemName forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.constant1 forFontWeight:UIFontWeightThin];
    [LayoutClass labelLayout:self.orderRefNo forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.constant2 forFontWeight:UIFontWeightThin];
    [LayoutClass labelLayout:self.dateofDelivery forFontWeight:UIFontWeightBold];
    [LayoutClass buttonLayout:self.constant3 forFontWeight:UIFontWeightRegular];
    [LayoutClass buttonLayout:self.constant4 forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.constant5 forFontWeight:UIFontWeightRegular];
    [LayoutClass setLayoutForIPhone6:self.mainView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self autoLayout];
    NSLog(@"CreateOrderVC2 call");
    totalSeconds= 180;
    [[self.view.subviews objectAtIndex:1] removeFromSuperview];
    
    alreadyAddDisplayCellData = [[NSMutableArray alloc]init];
    cellIndexQntyValueDict = [[NSMutableDictionary alloc]init];
    [self setDataOwnCustomeView];
    [self addCustomeTableView];
    
    
    // if message is of below format, we need to show structured message
/*
    NSString* message = @"Total Credit Limit (Rs.1), Utilized - Ledger Balance+Open Orders (Rs.4775036.764), Balance Available Limit = Rs.-4775035.764 and order Value is Rs. 79000";
    NSArray* autoDoCheckNumbers = [XmwUtils findNumbersInMessage:message];
    for(int i=0; i<[autoDoCheckNumbers count]; i++) {
        NSLog(@"Number = %@", [autoDoCheckNumbers objectAtIndex:i]);
    }
    
    [self showCreditLimitMessage:autoDoCheckNumbers];
 */
     
}

-(void)addCustomeTableView{
    mainTableView = [[UITableView alloc]init];
    mainTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    mainTableView.backgroundColor = [UIColor whiteColor];
    mainTableView.clipsToBounds = YES;
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.bounces = NO;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:mainTableView];
    
    
    //check already add lob data
    if ([[NSUserDefaults standardUserDefaults] valueForKey:self.itemName.text]!=nil) {
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:self.itemName.text]);
        [alreadyAddDisplayCellData addObjectsFromArray:[[NSUserDefaults standardUserDefaults] valueForKey:self.itemName.text]];
    }
    
}
-(void)setDataOwnCustomeView{
    NSLog(@"Forward Data Display :-%@",forwardedDataDisplay);
    NSLog(@"Post Data :-%@",forwardedDataPost);
    
    self.itemName.text = [NSString stringWithFormat:@"%@", [forwardedDataDisplay valueForKey:@"BUSINESS_VERTICAL"]];
    self.orderRefNo.text = [NSString stringWithFormat:@"%@", [forwardedDataDisplay valueForKey:@"PURCH_NO"]];
    self.dateofDelivery.text =  [NSString stringWithFormat:@"%@", [forwardedDataDisplay valueForKey:@"DELIVERY_DATE"]];
    
    
    
}
-(IBAction)addFormCatalogueButton:(id)sender {
    long int tag = [sender tag];
    NSLog(@"%ld",tag);
    NSLog(@"Button Clicked");
    
    
    NSMutableDictionary* buttonTag =[[NSMutableDictionary alloc]init];
    // buttonTag = @{@"ButtonTag": @(tag)};
    [buttonTag setObject:[NSString stringWithFormat:@"%ld",tag] forKey:@"ButtonTag"];
    [buttonTag setObject:[forwardedDataDisplay valueForKey:@"BUSINESS_VERTICAL"] forKey:@"BUSINESS_VERTICAL"];
    [buttonTag setObject:[forwardedDataPost valueForKey:@"BILL_TO"] forKey:@"BILL_TO"];
    [buttonTag setObject:[forwardedDataPost valueForKey:@"SHIP_TO"] forKey:@"SHIP_TO"];
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"setButtonHandler" object:self userInfo:buttonTag];
    
    
}
- (IBAction)searchProductsButton:(id)sender {
    long int tag = [sender tag];
    NSLog(@"%ld",tag);
    NSLog(@"Button Clicked");
    
    NSMutableDictionary* buttonTag =[[NSMutableDictionary alloc]init];
    [buttonTag setObject:[NSString stringWithFormat:@"%ld",tag] forKey:@"ButtonTag"];
    [buttonTag setObject:self.itemName.text forKey:@"itemName"];
    [buttonTag setObject:[forwardedDataDisplay valueForKey:@"BUSINESS_VERTICAL"] forKey:@"BUSINESS_VERTICAL"];
    [buttonTag setObject:[forwardedDataPost valueForKey:@"BILL_TO"] forKey:@"BILL_TO"];
    [buttonTag setObject:[forwardedDataPost valueForKey:@"SHIP_TO"] forKey:@"SHIP_TO"];
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"setButtonHandler" object:self userInfo:buttonTag];
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section==0) {
        // Search View section
        return 1;
        
    }
    else if(section==1) {
        // Display Cell section
        if (alreadyAddDisplayCellData.count!=0) {
            mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//            for (int j=0;  j<alreadyAddDisplayCellData.count; j++) {
//                [cellIndexQntyValueDict setValue:@"" forKey:[NSString stringWithFormat:@"%d",j]];
//            }
            
        }
        else
        {
            mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        
        return [alreadyAddDisplayCellData count];
        
    }
    else if (section==2)
    {
        mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //add place order Button
        return 1;
    }
    return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section==0) {
        UIView *currentView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 132)];
        CGRect viewFrame=currentView.frame;
        viewFrame.origin.x=deviceWidthRation*currentView.frame.origin.x;
        viewFrame.origin.y=deviceHeightRation*currentView.frame.origin.y;
        viewFrame.size.width=deviceWidthRation*currentView.frame.size.width;
        viewFrame.size.height=deviceHeightRation*currentView.frame.size.height;
        currentView.frame=viewFrame;
        return currentView.frame.size.height;
    }
    
    else if(indexPath.section==1) {
        return createOrderDynamicCellHeight*deviceHeightRation;
    }
    else if (indexPath.section==2)
    {
        return 44.0f;
    }
    return 0.0f;
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 5.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}
-(UIButton*) placeOrderButton
{
    UIImage *blueImage          = [UIImage imageNamed:@"blueButton.png"];
    UIImage *blueButtonImage    = [blueImage stretchableImageWithLeftCapWidth:8 topCapHeight:0];
    
    searchButton   = [[UIButton alloc]init];
    
    searchButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [searchButton setFrame:CGRectMake(self.view.bounds.size.width/2,5, 160, 36)];
    
    [searchButton setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
    
    [searchButton setTitleColor:[Styles buttonTextColor] forState: UIControlStateNormal];
    
    [searchButton setTitle:@"Place an Order" forState:UIControlStateNormal];
    
    [searchButton addTarget:self action:@selector(placeOrderButtonHandler) forControlEvents:UIControlEventTouchUpInside];
    
    return searchButton;
}
- (void) placeOrderButtonHandler
{
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    BOOL zeroQuantityFlag = true;
    
    NSString *authToken= [[NSUserDefaults standardUserDefaults] valueForKey:@"AUTH_TOKEN"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    removeTag = [[NSMutableArray alloc]init];
    
    lineItemCount = 0;
    oneTimeSuccessFlagCheck = true;
    
    NSMutableArray* roundingDetails = [[NSMutableArray alloc] init];
    
    for (int i=0; i<alreadyAddDisplayCellData.count; i++) {
        
        int tag = i + 2000;
        NSLog(@"Place order button click Create Order Display Tag %d",tag);
        CreateOrderDisplayCell *displayCell = [(CreateOrderDisplayCell*) self.view viewWithTag:tag];
        NSString *checkTextFiledEmpty =  [[NSString alloc]init];
        MXTextField *textField = (MXTextField*) displayCell.valueTxtFld;
        
        checkTextFiledEmpty = textField.text;
        
        
        if (checkTextFiledEmpty.length !=0 || [checkTextFiledEmpty isEqualToString:@""]) {
            NSLog(@"Qnty:%@",checkTextFiledEmpty);
            // Tushar, Zero Quantity value check
            NSInteger value = [checkTextFiledEmpty integerValue];
            if (value <= 0) {
                long int tag = displayCell.tag-2000;
                NSLog(@"Cell Tag: %ld",tag);
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[[alreadyAddDisplayCellData objectAtIndex:tag] objectAtIndex:0] message:@"Please enter quantity greater than zero." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [loadingView removeView];
                [alert show];
                zeroQuantityFlag = false;
                break;
            }
            else
            {
                //
                if([displayCell isPackingSizeRoundingEnabled:textField.elementId ]) {
                    // we need to check the pack size rounding
                    
                   BOOL roundingApplied =  [self roundingForPacksize:textField.attachedData inputQuantity:&checkTextFiledEmpty];
                
                    if(roundingApplied) {
                        // Packsize rounding applied
                        NSMutableArray* roundingLine = [[NSMutableArray alloc] init];
                        [roundingLine addObject:[NSString stringWithFormat:@"%d", i]];  // line n
                        [roundingLine addObject:[[alreadyAddDisplayCellData objectAtIndex:i] objectAtIndex:0]];  // item code
                        [roundingLine addObject:[[alreadyAddDisplayCellData objectAtIndex:i] objectAtIndex:1]];  // item desc
                        [roundingLine addObject:[checkTextFiledEmpty copy]];  // rounding quantity
                        [roundingDetails addObject:roundingLine];
                        
                        // update the textfield value
                        textField.text = checkTextFiledEmpty;
                    }
                }
                zeroQuantityFlag = true;
                long int tag = displayCell.tag-2000;
                NSLog(@"Cell Tag: %ld",tag);
                NSUInteger lenght =[[alreadyAddDisplayCellData objectAtIndex:tag] count];
                
                [removeTag addObject:[NSString stringWithFormat:@"%ld",tag] ];
                
                NSMutableDictionary *line_items = [[NSMutableDictionary alloc]init];
                [line_items setObject:[[alreadyAddDisplayCellData objectAtIndex:tag] objectAtIndex:2] forKey:@"INVENTORY_ITEM_ID"];
                [line_items setObject:[[alreadyAddDisplayCellData objectAtIndex:tag] objectAtIndex:0] forKey:@"ITEM_CODE"];
                [line_items setObject:[[alreadyAddDisplayCellData objectAtIndex:tag] objectAtIndex:1] forKey:@"ITEM_DESC"];
                [line_items setObject:[[alreadyAddDisplayCellData objectAtIndex:tag] objectAtIndex:3] forKey:@"UOM"];
                [line_items setObject:[[alreadyAddDisplayCellData objectAtIndex:tag] objectAtIndex:8] forKey:@"UOMDESC"];
                
                [line_items setObject:checkTextFiledEmpty forKey:@"QTY"];
                [array addObject:line_items];
                
                lineItemCount = lineItemCount + 1;
            }
        }
    }
    
    if (zeroQuantityFlag) {
        [data setObject:array forKey:@"pc_so_line_items"];
        if ([array count] != 0) {
            
            NSMutableDictionary *header = [[NSMutableDictionary alloc]init];
            [header setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedRegisterIDCode"] forKey:@"USERNAME"];
            [header setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedRegisterIDCustomerName"] forKey:@"CUSTOMER_NAME"];
            [header setObject:[NSString stringWithFormat:@"%@", [forwardedDataPost valueForKey:@"BUSINESS_VERTICAL"]] forKey:@"ACCOUNT_NUMBER"];
            [header setObject:[NSString stringWithFormat:@"%@", [forwardedDataPost valueForKey:@"BILL_TO"]] forKey:@"BILL_TO"];
            [header setObject:[NSString stringWithFormat:@"%@", [forwardedDataPost valueForKey:@"SHIP_TO"]] forKey:@"SHIP_TO"];
            [header setObject:@"" forKey:@"REMARK"];
            [header setObject:[NSString stringWithFormat:@"%@", [forwardedDataDisplay valueForKey:@"DELIVERY_DATE"]] forKey:@"DELIVERY_DATE"];
            [header setObject:[NSString stringWithFormat:@"%@", [forwardedDataDisplay valueForKey:@"PURCH_NO"]] forKey:@"PURCHASE_NUMBER"];
            
            
            [data setObject:header forKey:@"pc_so_header"];
            
            NSMutableDictionary *sendDict = [[NSMutableDictionary alloc]init];
            [sendDict setObject:data forKey:@"data"];
            [sendDict setObject:clientVariables.CLIENT_LOGIN_RESPONSE.authToken forKey:@"authToken"];
            [sendDict setValue:@"createSalesOrder" forKey:@"opcode"];
            
            
            if([roundingDetails count]>0) {
                // display user about rounding to pack size lines
                [self showAlertForRoundingMessage:sendDict roundingDetails:roundingDetails];
            } else {
                [self call_CreateSalesOrderAPI: sendDict];
            }
        } else {
            if (zeroQuantityFlag) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Please enter atleast one item quantity to place the order." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [loadingView removeView];
                [alert show];
            }
            else
            {
                // do nothing, show zero validation alert
            }
        }
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    //pending
    
    
}

-(void)trackNetworkCall
{
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    NSMutableDictionary *sendDict = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    [data setObject:trackerID forKey:@"TRACKER_ID"];
    [data setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedRegisterIDCode"] forKey:@"USERNAME"];
    [data setObject:[self.forwardedDataPost valueForKey:@"BUSINESS_VERTICAL"] forKey:@"ACCOUNT_NUMBER"];
    
    [sendDict setValue:@"statusSalesOrder" forKey:@"opcode"];
    [sendDict setValue:clientVariables.CLIENT_LOGIN_RESPONSE.authToken forKey:@"authToken"];
    [sendDict setObject: data forKey:@"data"];
    
    
    networkHelper = [[NetworkHelper alloc]init];
    
    NSString *url = XmwcsConst_OPCODE_URL;
    networkHelper.serviceURLString = url;
    [networkHelper genericJSONPayloadRequestWith:sendDict :self :@"statusSalesOrder"];
    
}


- (void)timer {
    loadingView= [LoadingView loadingViewInView:self.view];
    totalSeconds = totalSeconds - 1;
    if ( totalSeconds != 0 && totalSeconds >0 ) {
        [fiveMinTimer invalidate];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(trackNetworkCall) object:nil];
        [self performSelector:@selector(trackNetworkCall) withObject:nil afterDelay:5.0];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Polycab" message:@"Sorry, due to some technical issue your order is not processed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - HttpEventListener

- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    [loadingView removeView];
    
    if ([callName isEqualToString:@"statusSalesOrder"]) {
        
        NSString *status_flag = [[respondedObject valueForKey:@"so_header"] valueForKey:@"STATUS_FLAG"];
        
        if ([status_flag isEqualToString:@"S"]) {
            // One exta time check if line item count  not line item count + 1
            NSDictionary *so_lines = respondedObject[@"so_lines"];
            if (so_lines.count != (lineItemCount + 1)) {
                if (oneTimeSuccessFlagCheck) {
                    oneTimeSuccessFlagCheck = false;
                    loadingView= [LoadingView loadingViewInView:self.view];
                    [self performSelector:@selector(trackNetworkCall) withObject:nil afterDelay:10.0];
                                    
                  } else {
                       [self configureSummaryVC:respondedObject];
                 }
            } else {
                [self configureSummaryVC:respondedObject];
            }
        } else if ([status_flag isEqualToString:@"E"] || [status_flag isEqualToString:@"H"]) {
            // if message is of below format, we need to show structured message
            // var sample = "Your account is either not having enough credit limit or has overdue invoices so order is not getting accepted.Total Credit Limit (Rs.370000), Utilized - Ledger Balance+Open Orders (Rs.433885.04), Balance Available Limit = Rs.-63885.04 and order Value is Rs. 530000";
            
            NSArray* autoDoCheckNumbers = [XmwUtils findNumbersInMessage:[respondedObject valueForKey:@"message"]];

            if(autoDoCheckNumbers!=nil && autoDoCheckNumbers.count==4) {
                
                // display custom message popup for AutoDO Failure
                [self showCreditLimitMessage:autoDoCheckNumbers];
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Polycab" message:[respondedObject valueForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        } else
        {
            [self timer];
        }
    }   // end of if statusSalesOrder
    
    if ([callName isEqualToString:@"createSalesOrder"]) {
        if ([[respondedObject valueForKey:@"status"] isEqualToString:@"SUCCESS"]) {
            //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Polycab" message:[respondedObject valueForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //            [alert show];
            
            
            
            // remove cell
            //            NSMutableArray *updatedArrayList = [[NSMutableArray alloc]init];
            //            for (int i=0; i<[alreadyAddDisplayCellData count]; i++) {
            //                BOOL contains;
            //                NSString *str = [NSString stringWithFormat:@"%i", i];
            //                contains = [removeTag containsObject:str];
            //                if (contains==false) {
            //                    [updatedArrayList addObject:[alreadyAddDisplayCellData objectAtIndex:i]];
            //                }
            //                else {
            //                 //do nothing
            //                }
            //            }
            //            alreadyAddDisplayCellData = [[NSMutableArray alloc]init];
            //            [alreadyAddDisplayCellData addObjectsFromArray:updatedArrayList];
            //            //locally save cell
            //            [[NSUserDefaults standardUserDefaults] setObject:alreadyAddDisplayCellData forKey:self.itemName.text];
            
            
            
            trackerID = [respondedObject valueForKey:@"TRACKER_ID"];
            if (trackerID==nil ||[trackerID isKindOfClass: [NSNull class]]) {
                trackerID = @"";
            }
            else
            {
                [self trackNetworkCall];
            }
            
            //   [mainTableView reloadData];
            
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Polycab" message:[respondedObject valueForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
}

- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
    
}

-(void)configureSummaryVC :(id)respondedObject {
    
    //send data to next screen
    NSString *name;
    NSString *verticalName= [forwardedDataDisplay valueForKey:@"BUSINESS_VERTICAL"];
    NSCharacterSet *numbersSet = [NSCharacterSet characterSetWithCharactersInString:@"-0123456789"];
    name = [verticalName stringByTrimmingCharactersInSet:numbersSet];
    NSLog(@"%@",name);
    
    
    CreateOrderStatusVC *vc = [[CreateOrderStatusVC alloc]init];
    vc.jsonResponse = respondedObject;
    vc.businessVerticalName = name;
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
    //remove cell
    NSMutableArray *updatedArrayList = [[NSMutableArray alloc]init];
    for (int i=0; i<[alreadyAddDisplayCellData count]; i++) {
        BOOL contains;
        NSString *str = [NSString stringWithFormat:@"%i", i];
        contains = [removeTag containsObject:str];
        if (contains==false) {
            [updatedArrayList addObject:[alreadyAddDisplayCellData objectAtIndex:i]];
        }
        else {
            //do nothing
        }
    }
    alreadyAddDisplayCellData = [[NSMutableArray alloc]init];
    [alreadyAddDisplayCellData addObjectsFromArray:updatedArrayList];
    //locally save cell
    [[NSUserDefaults standardUserDefaults] setObject:alreadyAddDisplayCellData forKey:self.itemName.text];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [mainTableView reloadData];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if(indexPath.section==0) {
        [cell.contentView addSubview:mainView];
        cell.clipsToBounds = YES;
        
        
    }
    
    
    else if(indexPath.section==1) {
        cell = [self displayTableViewCell:tableView cellForRowAtIndexPath:indexPath];
        cell.clipsToBounds = YES;
        
    }
    
    else if(indexPath.section==2) {
        if ([alreadyAddDisplayCellData count]!=0){
            cell = [tableView dequeueReusableCellWithIdentifier:@"placeOrderButton"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(cell==nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"placeOrderButton"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.contentView addSubview:[self placeOrderButton]];
            }
        }
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}


- (UITableViewCell *)displayTableViewCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = [NSString stringWithFormat:@"displayCell:%ld", (long)indexPath.row ];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    CreateOrderDisplayCell* displayCell = [CreateOrderDisplayCell CreateInstance];
    displayCell.delegate = self;
    long int cancelButtonTag = indexPath.row;
    long int arrayObjectTag = indexPath.row;
    NSString *name;
    NSString *verticalName= [forwardedDataDisplay valueForKey:@"BUSINESS_VERTICAL"];
    NSCharacterSet *numbersSet = [NSCharacterSet characterSetWithCharactersInString:@"-0123456789"];
    name = [verticalName stringByTrimmingCharactersInSet:numbersSet];
    NSLog(@"%@",name);
    NSArray * array = [alreadyAddDisplayCellData objectAtIndex:indexPath.row];
       NSString *quantity = [cellIndexQntyValueDict valueForKey: [NSString stringWithFormat:@"%@",[array objectAtIndex:0]]];
    [ displayCell configure:[alreadyAddDisplayCellData objectAtIndex:arrayObjectTag] :cancelButtonTag :name :quantity];
    //   [displayCell configure:[alreadyAddDisplayCellData objectAtIndex:arrayObjectTag] :cancelButtonTag :name];
    //[displayCell configure:[alreadyAddDisplayCellData objectAtIndex:arrayObjectTag] :cancelButtonTag];
    long int cellTag = indexPath.row +2000;
    displayCell.tag = cellTag;
    
    [cell.contentView addSubview:displayCell];
    displayCell.clipsToBounds = YES;
    
    createOrderDynamicCellHeight =displayCell.titleLbl.frame.size.height+displayCell.descriptionLbl.frame.size.height+displayCell.mainDescLbl.frame.size.height+displayCell.priceLabel.frame.size.height+20;
    
    return cell;
}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    if (indexPath.section==1) {
////        displayCell = [(CreateOrderDisplayCell *) self.view viewWithTag:indexPath.row +2000];
////        displayCell.valueTxtFld.text = @"2000";
////    }
//
//}


- (NSArray *)dictionaryByReplacingNullsWithStrings :(NSMutableArray *)array {
    NSMutableArray *replaceArry = [[NSMutableArray alloc]init];
    
    for (int i=0; i<array.count; i++) {
        NSLog(@"%@",[array objectAtIndex:i]);
        
        NSString *value =( NSString*)[array objectAtIndex:i];
        if ([value isKindOfClass:[NSNull class]]) {
            [replaceArry addObject:@""];
          //  [array replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@""]];
            
        }
        else{
            [replaceArry addObject:[array objectAtIndex:i]];
            // no need to change data
        }
        
    }
    
    NSLog(@"After Remove Null :%@",array);
    NSLog(@"replace array  :%@",replaceArry);
    return replaceArry;
    
}

- (void)multipleItemsSelected:(NSArray *)headerData :(NSArray *)selectedRows{
    if ( selectedRows!= nil) {
        numberOfCell = [[NSMutableArray alloc]init];
        for (int i=0; i<selectedRows.count;i++) {
            [numberOfCell addObject:[self dictionaryByReplacingNullsWithStrings:[selectedRows objectAtIndex:i]]];
        }
        NSMutableIndexSet *indexes = [NSMutableIndexSet new];
        NSMutableArray *itemCodeArray = [[NSMutableArray alloc]init];
        for (int i=0; i<numberOfCell.count; i++) {
            NSString *str1= [[numberOfCell objectAtIndex:i] objectAtIndex:2];
            for (int j=0; j<alreadyAddDisplayCellData.count; j++) {
                NSString *str2 =[[alreadyAddDisplayCellData objectAtIndex:j]objectAtIndex:2];
                if ([str1 isEqualToString:str2]) {
                    [itemCodeArray addObject:str1];
                    [indexes addIndex:i];
                    break;
                }
            }
            
        }
        
        
        if (itemCodeArray.count!=0) {
            NSString *massege = @"These items are already added.";
            NSString *itemCodes =@"";
            for (int i=0; i<itemCodeArray.count; i++) {
                itemCodes = [[[itemCodes stringByAppendingString:@"Item Code:- "]stringByAppendingString:[itemCodeArray objectAtIndex:i]]stringByAppendingString:@"\n"];
            }
            massege = [[massege stringByAppendingString:@"\n"]stringByAppendingString:itemCodes];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Products" message:massege delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
        
        [numberOfCell removeObjectsAtIndexes:indexes];
        
        [alreadyAddDisplayCellData  addObjectsFromArray:numberOfCell];
        
        [[NSUserDefaults standardUserDefaults] setObject:alreadyAddDisplayCellData forKey:self.itemName.text];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [mainTableView reloadData];
    }
    
    
}
/*
- (void)buttonDelegate:(long)tag{
    [alreadyAddDisplayCellData removeObjectAtIndex:tag];
    
    [cellIndexQntyValueDict removeObjectForKey:[NSString stringWithFormat:@"%ld",tag]];
    
    
    NSLog(@"%@",alreadyAddDisplayCellData);
    [[NSUserDefaults standardUserDefaults] setObject:alreadyAddDisplayCellData forKey:self.itemName.text];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [mainTableView reloadData];
}
 */

- (void)buttonDelegate:(long)tag{
    
    NSArray * array = [alreadyAddDisplayCellData objectAtIndex:tag];
    
//    [cellIndexQntyValueDict removeObjectForKey:[NSString stringWithFormat:@"%ld",tag]];
    [cellIndexQntyValueDict removeObjectForKey:[array objectAtIndex:0]];
    [alreadyAddDisplayCellData removeObjectAtIndex:tag];
    
    NSLog(@"%@",alreadyAddDisplayCellData);
    
    NSMutableArray * tempArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i<alreadyAddDisplayCellData.count;i++) {
              [tempArray addObject:[self dictionaryByReplacingNullsWithStrings:[alreadyAddDisplayCellData objectAtIndex:i]]];
          }
    alreadyAddDisplayCellData = [[NSMutableArray alloc ] init];
    [alreadyAddDisplayCellData addObjectsFromArray:tempArray];
    
    [[NSUserDefaults standardUserDefaults] setObject:alreadyAddDisplayCellData forKey:self.itemName.text];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:cellIndexQntyValueDict forKey:@"CELL_QUANTITY_VALUES_DICT"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [mainTableView reloadData];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    
    
    NSLog(@"FormVC keyboardWasShown");
    NSDictionary* info = [aNotification userInfo];
    keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height+35, 0.0);
    
    
    
    mainTableView.contentInset = contentInsets;
    mainTableView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = mainTableView.frame;
    aRect.size.height -= keyboardSize.height;
    if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
        [mainTableView scrollRectToVisible:activeTextField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSLog(@"FormVC keyboardWillBeHidden");
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    mainTableView.contentInset = contentInsets;
    mainTableView.scrollIndicatorInsets = contentInsets;
    
}


-(void)keyboard
{
    // Register notification when the keyboard will be show
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    // Register notification when the keyboard will be hide
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
- (void)textFieldDelegate:(UITextField *)textfield
{
    activeTextField = textfield;
    [self keyboard];
}
- (void)textFieldValue:(UITextField *)textfield :(long)cellIndex
{
    NSArray * array = [alreadyAddDisplayCellData objectAtIndex:cellIndex];
   
//    [ cellIndexQntyValueDict setValue:textfield.text forKey:[NSString stringWithFormat:@"%ld",cellIndex]];
      [ cellIndexQntyValueDict setValue:textfield.text forKey:[array objectAtIndex:0]];
    
    [[NSUserDefaults standardUserDefaults] setObject:cellIndexQntyValueDict forKey:@"CELL_QUANTITY_VALUES_DICT"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)returnPackSizeFlag:(BOOL)flag
{
    packSizeFlagCheck = flag;
    
    if (flag) {
        [searchButton setBackgroundColor:nil];
        UIImage *blueImage          = [UIImage imageNamed:@"blueButton.png"];
        UIImage *blueButtonImage    = [blueImage stretchableImageWithLeftCapWidth:8 topCapHeight:0];
        [searchButton setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
        
    }
}


-(BOOL) roundingForPacksize:(NSString*) packsize inputQuantity:(NSString**) quantityValueString
{
    BOOL retVal = false;
    
    int packSizeInt = [packsize intValue];
    int quantityValueInt = [(*quantityValueString) intValue];
    
    if (quantityValueInt >= packSizeInt) {
        if (packSizeInt > 1) {
             float theFloat = (float)quantityValueInt / (float)packSizeInt;
             int rounded = round(theFloat);
             int finalQuantityValue  = packSizeInt * rounded;
            // using rounding function to round of the quantity
             if (quantityValueInt != finalQuantityValue) {
                 // finalQuantityValue is the value to be used
                 *quantityValueString = [NSString stringWithFormat:@"%d", finalQuantityValue];
                 retVal = true;
             }
         }
    } else {
        // return the pack size, minimum packsize
        *quantityValueString = [packsize copy];
        retVal = true;
    }
    return retVal;
}



// on continue, send requestPayload
-(void) showAlertForRoundingMessage:(NSDictionary*) requestPayload roundingDetails:(NSMutableArray*) lineRoundingDetails
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Polycab" message:@"Your Order Quantity is rounded off according to pack size." preferredStyle:UIAlertControllerStyleAlert];
    
       UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault
            handler:^(UIAlertAction * action)
            {
                // on continue call create Sales Order API
                [self call_CreateSalesOrderAPI:requestPayload];
            }];
        [alertController addAction:defaultAction];
    
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
         handler:^(UIAlertAction * action)
         {
             // Do nothing just close
         }];
     [alertController addAction:cancelAction];
    
    
     
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


-(void) call_CreateSalesOrderAPI:(NSDictionary*) requestPayload
{
    loadingView= [LoadingView loadingViewInView:self.view];
    networkHelper = [[NetworkHelper alloc]init];
    NSString *url = XmwcsConst_OPCODE_URL;
    networkHelper.serviceURLString = url;
    [networkHelper genericJSONPayloadRequestWith:requestPayload :self :@"createSalesOrder"];
}



-(void) showCreditLimitMessage:(NSArray*)clNumbers
{
    NSMutableArray* tableRows = [[NSMutableArray alloc] init];
    
    if([clNumbers count]>3) {
        NSMutableArray* row0 = [[NSMutableArray alloc] init];
        [row0 addObject:@"Total Credit Limit"];
        [row0 addObject:[clNumbers objectAtIndex:0]];
        [tableRows addObject:row0];
        
        NSMutableArray* row1 = [[NSMutableArray alloc] init];
        [row1 addObject:@"Utilized - Ledger Balance + Pending Orders"];
        [row1 addObject:[clNumbers objectAtIndex:1]];
        [tableRows addObject:row1];
        
        NSMutableArray* row2 = [[NSMutableArray alloc] init];
        [row2 addObject:@"Balance Available Limit"];
        [row2 addObject:[clNumbers objectAtIndex:2]];
        [tableRows addObject:row2];
        
        NSMutableArray* row3 = [[NSMutableArray alloc] init];
        [row3 addObject:@"Order Value"];
        [row3 addObject:[clNumbers objectAtIndex:3]];
        [tableRows addObject:row3];
        
        CreditLimitDetailsMessage* popup = [CreditLimitDetailsMessage createInstance];
        popup.tableRows = tableRows;
        popup.title = @"Your account is not having enough credit limit so order is not getting accepted.";
        
        [self.view addSubview:popup];
    }
    
}


@end

