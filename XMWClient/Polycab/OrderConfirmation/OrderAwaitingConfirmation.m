//
//  OrderAwaitingConfirmation.m
//  XMWClient
//
//  Created by Pradeep Singh on 23/07/20.
//  Copyright © 2020 dotvik. All rights reserved.
//

#import "OrderAwaitingConfirmation.h"

#import "DotReportDraw.h"
#import "NetworkHelper.h"
#import "XmwcsConstant.h"
#import "ClientVariable.h"
#import "DVAppDelegate.h"
#import "CreateOrderStatusVC.h"
#import "LoadingView.h"


@interface OrderAwaitingConfirmation () <DrilldownControlDelegate>
{
    NetworkHelper* networkHelper;
    
    NSString* trackerId;
    NSString* billTo;
    NSString* billToAddress;
    NSString* shipTo;
    NSString* shipToAddress;
    NSString* registryId;
    NSString* customerAccount;
    NSString* businessVertical;
    
    
}

@end

@implementation OrderAwaitingConfirmation

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.drilldownDelegate = self;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void) handleDrilldownForRow:(NSInteger) rowIndex withRowData:(NSArray*) rowData
{
    NSLog(@"handleDrilldownForRow(): rowIndex = %ld", rowIndex);
    
    // self.dotReport.reportElements
    
    
    NSMutableArray* sortedElementIds = [DotReportDraw sortRptComponents:self.dotReport.reportElements :@"TABLE"];
    
    
    
    // SYSTEM_NUMBER, BILL_TO, BILL_TO_ADDRESS, SHIP_TO, SHIP_TO_ADDRESS, REGISTRY_ID, CUSTOMER_ACCOUNT,
    // BUSINESS_VERTICAL
    
    trackerId = [rowData objectAtIndex:[sortedElementIds indexOfObject:@"SYSTEM_NUMBER"]];
    billTo = [rowData objectAtIndex:[sortedElementIds indexOfObject:@"BILL_TO"]];
    billToAddress = [rowData objectAtIndex:[sortedElementIds indexOfObject:@"BILL_TO_ADDRESS"]];
    shipTo = [rowData objectAtIndex:[sortedElementIds indexOfObject:@"SHIP_TO"]];
    shipToAddress = [rowData objectAtIndex:[sortedElementIds indexOfObject:@"SHIP_TO_ADDRESS"]];
    registryId = [rowData objectAtIndex:[sortedElementIds indexOfObject:@"REGISTRY_ID"]];
    customerAccount = [rowData objectAtIndex:[sortedElementIds indexOfObject:@"CUSTOMER_ACCOUNT"]];
    businessVertical = [rowData objectAtIndex:[sortedElementIds indexOfObject:@"BUSINESS_VERTICAL"]];
    
    
    
    [self trackNetworkCall];
    
    
}

-(void)trackNetworkCall
{
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    NSMutableDictionary *sendDict = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    [data setObject:trackerId forKey:@"TRACKER_ID"];
    [data setObject:registryId forKey:@"USERNAME"];
    [data setObject:customerAccount forKey:@"ACCOUNT_NUMBER"];
    
    [sendDict setValue:@"statusSalesOrder" forKey:@"opcode"];
    [sendDict setValue:clientVariables.CLIENT_LOGIN_RESPONSE.authToken forKey:@"authToken"];
    [sendDict setObject: data forKey:@"data"];
    
    
    loadingView= [LoadingView loadingViewInView:self.view];
    
    networkHelper = [[NetworkHelper alloc]init];
    
    NSString *url = XmwcsConst_OPCODE_URL;
    networkHelper.serviceURLString = url;
    [networkHelper genericJSONPayloadRequestWith:sendDict :self :@"statusSalesOrder"];
    
}




- (void) httpResponseObjectHandler:(NSString*) callName :(id) respondedObject :(id) requestedObject
{
    [loadingView removeView];
    
    [super httpResponseObjectHandler:callName :respondedObject :requestedObject];
    
    if ([callName isEqualToString:@"statusSalesOrder"]) {
        
        NSString *status_flag = [[respondedObject valueForKey:@"so_header"]valueForKey:@"STATUS_FLAG"];
        if ([status_flag isEqualToString:@"S"] || [status_flag isEqualToString:@"E"]) {
            if ([status_flag isEqualToString:@"S"]) {
                [self configureSummaryVC:respondedObject];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Polycab" message: [[respondedObject valueForKey:@"so_header"]valueForKey:@"ERROR_MESSAGE"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }

}

- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
    
}

-(void)configureSummaryVC :(id)respondedObject {
    
    CreateOrderStatusVC *vc = [[CreateOrderStatusVC alloc] init];
    vc.jsonResponse = respondedObject;
    vc.businessVerticalName = businessVertical;
    vc.ALLOW_BACK = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
