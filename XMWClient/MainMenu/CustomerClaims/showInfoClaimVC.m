//
//  showInfoClaimVC.m
//  XMWClient
//
//  Created by dotvikios on 29/06/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "showInfoClaimVC.h"
#import "ShowInvoice.h"
#import "CustomerClaimInvoiceFetchDetailsVC.h"
#import "NetworkHelper.h"
#import "HttpEventListener.h"
#import "LoadingView.h"
#define InvoiceStartTag 1000
@interface showInfoClaimVC ()

@end

@implementation showInfoClaimVC
{
    long int viewCartHeight;
    int cellConut;
    int cellHeight;
    NetworkHelper *networkHelper;
    LoadingView *loadingView;
    ShowInvoice *invoiceView;
}
@synthesize topView;
@synthesize buttonView;
@synthesize scroll;
@synthesize claimReason;
@synthesize totalClaimAmount;
@synthesize totalAmount;
@synthesize reason;
@synthesize invoiceTagNumber;
@synthesize ccLableName;
@synthesize navigationTopViewChnage;
@synthesize ccLable;
@synthesize showViewData;
@synthesize chagedData;
@synthesize requestData;
- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self.navigationItem setHidesBackButton:YES animated:YES];
    ccLableName.text = ccLable;
    self.navigationItem.titleView = navigationTopViewChnage;
    cellHeight = 380;
    self.totalClaimAmount.text= totalAmount;
    self.claimReason.text = reason;
    NSLog(@"%@",invoiceTagNumber);
    NSLog(@"%@",chagedData);
    NSLog(@"%@",showViewData);
    NSLog(@"%@",requestData);
    [self showInfoClaimView];
}
-(void)showInfoClaimView{
    topView.frame = CGRectMake(0,0,self.view.frame.size.width,142.0);
    [scroll addSubview:topView];
    viewCartHeight = viewCartHeight + [invoiceTagNumber count];
    for ( int i=0 ; i < invoiceTagNumber.count; i++) {
          NSString *tag = [invoiceTagNumber objectAtIndex:i];
         NSArray* selectedChangeData = [chagedData objectForKey:tag];
         invoiceView = [ShowInvoice createInstance:cellConut*380];
        [invoiceView configure:selectedChangeData];
        invoiceView.frame=CGRectMake(0, 145+(cellConut*cellHeight), 320, 380);
        [scroll addSubview:invoiceView];
        cellConut = cellConut + 1;
    }
    [scroll setContentSize:CGSizeMake(320 , 150+(viewCartHeight *380)+70)];
    buttonView.frame=CGRectMake(0, (viewCartHeight*380)+150,self.view.frame.size.width, 65);
    [scroll addSubview:buttonView];
}

- (IBAction)editButton:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)submitButton:(id)sender {
    loadingView= [LoadingView loadingViewInView:self.view];
    NSString *userName;
    userName= [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
    NSMutableDictionary *header = [[NSMutableDictionary alloc]init];
    [header setObject:[requestData objectForKey:@"CLAIM_TYPE"] forKey:@"CLAIM_TYPE"];
    [header setObject:[requestData objectForKey:@"CLAIM_SUB_TYPE"] forKey:@"CLAIM_SUB_TYPE"];
    [header setObject:[requestData objectForKey:@"CLAIM_REASON"] forKey:@"CLAIM_REASON"];
    [header setObject:@"" forKey:@"EMPLOYEE_ID"];
    [header setObject:userName forKey:@"CUSTOMER"];
    [header setObject:reason forKey:@"REMARK"];
    
    NSMutableDictionary *itemrowsFinal = [[NSMutableDictionary alloc]init];
    NSMutableArray *item = [[NSMutableArray alloc]init];
    
    for ( int i=0 ; i < invoiceTagNumber.count; i++) {
        //Network Call
            NSMutableDictionary *itemrows =[[NSMutableDictionary alloc]init];
            NSString *tag = [invoiceTagNumber objectAtIndex:i];
            NSDictionary* showData = [showViewData objectForKey:tag];
            NSArray* selectedChangeData = [chagedData objectForKey:tag];
            [itemrows setObject:[selectedChangeData valueForKey:@"IN"] forKey:@"VBELN"];
            [itemrows setObject:[showData  objectForKey:@"FKART"] forKey:@"FKART"];
            [itemrows setObject:[showData objectForKey:@"FKTYP"] forKey:@"FKTYP"];
            [itemrows setObject:[showData objectForKey:@"VBTYP"] forKey:@"VBTYP"];
            [itemrows setObject:[showData objectForKey:@"WAERK"] forKey:@"WAERK"];
            [itemrows setObject:[showData objectForKey:@"VKORG"] forKey:@"VKORG"];
            [itemrows setObject:[showData objectForKey:@"VTWEG"] forKey:@"VTWEG"];
            [itemrows setObject:[showData objectForKey:@"FKDAT"] forKey:@"FKDAT"];
            [itemrows setObject:[showData objectForKey:@"BUKRS"] forKey:@"BUKRS"];
            [itemrows setObject:[showData objectForKey:@"NETWR"] forKey:@"NETWR"];
            [itemrows setObject:userName forKey:@"KUNAG"];
            [itemrows setObject:[selectedChangeData valueForKey:@"DIV"] forKey:@"SPART"];
            [itemrows setObject:[selectedChangeData valueForKey:@"BI"] forKey:@"POSNR"];
            [itemrows setObject:[selectedChangeData valueForKey:@"IQ"] forKey:@"FKIMG"];
            [itemrows setObject:[selectedChangeData valueForKey:@"SU"] forKey:@"VRKME"];
            [itemrows setObject:[selectedChangeData valueForKey:@"NV"] forKey:@"NETWR_ITM"];
            [itemrows setObject:[showData objectForKey:@"MATNR"]  forKey:@"MATNR"];
            [itemrows setObject:[showData objectForKey:@"ARKTX"] forKey:@"ARKTX"];
            [itemrows setObject:[showData objectForKey:@"WERKS"] forKey:@"WERKS"];
            [itemrows setObject:[showData objectForKey:@"VKBUR"] forKey:@"VKBUR"];
            [itemrows setObject:[showData objectForKey:@"HSN"] forKey:@"HSN"];
            [itemrows setObject:[selectedChangeData valueForKey:@"PUCV"] forKey:@"CUSTOMER_NETWR_ITM"];
            [itemrows setObject:[selectedChangeData valueForKey:@"R"] forKey:@"ITEM_REMARK"];
            [item addObject:itemrows];
    }
    NSLog(@"%@",item);
    NSMutableDictionary *data = [[NSMutableDictionary alloc ]init];
    [data setObject:header forKey:@"header"];
    [data setObject:item forKey:@"itemrows"];
    NSMutableDictionary * submitCall = [[NSMutableDictionary  alloc]init];
    [submitCall setObject:data forKey:@"data"];
    [submitCall setObject:@"customerClaimSubmit" forKey:@"opcode"];
    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=@"http://qamkonnect.havells.com:8080/xmwcsdealermkonnect/store";
    networkHelper.serviceURLString = url;
    [networkHelper genericJSONPayloadRequestWith:submitCall :self :@"submitCall"];
}

- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    [loadingView removeView];
    NSMutableDictionary *response = [[NSMutableDictionary alloc]init];
    [response setDictionary:respondedObject];
    NSString *status = [response valueForKey:@"status"];
    if ([status isEqualToString:@"SUCCESS"]) {
        NSMutableArray *dataMessage= [[NSMutableArray alloc]init];
        [dataMessage addObject:[response valueForKey:@"responseData"]];
        NSString *m1= [NSString stringWithFormat:@"%@",[dataMessage valueForKey:@"EV_NUMBER"]];
        NSString *unfilteredString = m1;
        NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
        NSString *resultString = [[unfilteredString componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
        NSLog (@"Result: %@", resultString);
        NSLog(@"%@",m1);
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"EV_NUMBER" message:resultString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        [myAlertView show];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Authentication!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
}
@end
