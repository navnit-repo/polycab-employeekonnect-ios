//
//  CustomerClaimInvoiceDetailsVC.m
//  XMWClient
//
//  Created by dotvikios on 20/06/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "CustomerClaimInvoiceDetailsVC.h"
#import "NetworkHelper.h"
#import "HttpEventListener.h"
#import "CustomerClaimInvoiceFetchDetailsVC.h"
#import "ClientUserLogin.h"
#import "LoadingView.h"
@interface CustomerClaimInvoiceDetailsVC ()
{
    LoadingView *loadingView;
    NetworkHelper* networkHelper;
}
@end
@implementation CustomerClaimInvoiceDetailsVC
@synthesize invoiceNumber;
@synthesize claimSubType;
@synthesize claimType;
@synthesize reason;
@synthesize claimTypeLable;
@synthesize claimSubTypeLable;
@synthesize reasonLable;
@synthesize topView;
@synthesize ccLableName;
@synthesize requestData;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //add custome Header View
    [self.navigationItem setHidesBackButton:YES animated:YES];
    ccLableName.text = claimType;
    self.navigationItem.titleView = topView;
    
    NSLog(@"Customer Claim Invoice Details VC Call");
    NSLog(@"%@,%@,%@",claimType,claimSubType,reason);
    claimTypeLable.text=claimType;
    claimSubTypeLable.text=claimSubType;
    reasonLable.text = reason;
    self.invoiceNumber.delegate =self;
}
- (IBAction)searchButton:(id)sender {
    loadingView= [LoadingView loadingViewInView:self.view];
    if ([invoiceNumber.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Havells mKonnect"
                                                        message:@"Blank Invoice Number"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
         [loadingView removeView];
         [alert show];
    }
    else{
        
        //Network Call
    NSString * invoiceSearch1 = @"[";
    NSString * invoiceSearch2 = invoiceNumber.text;
    NSString *invoiceSearch3 = [NSString stringWithFormat: @"%@%@", invoiceSearch1, invoiceSearch2];
    NSString *invoiceSearch4 = @"]";
    NSString * invoiceSearchTextFiled;
    invoiceSearchTextFiled=[NSString stringWithFormat: @"%@%@", invoiceSearch3, invoiceSearch4];
    NSString *userName;
    userName= [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc ]init];
    [data setObject:userName forKey:@"CUSTOMER"];
    [data setObject:invoiceSearchTextFiled forKey:@"INVOICES"];
    NSMutableDictionary * dropdowncall = [[NSMutableDictionary  alloc]init];
    [dropdowncall setObject:data forKey:@"data"];
    [dropdowncall setObject:@"customerInvoices" forKey:@"opcode"];
    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=@"http://qamkonnect.havells.com:8080/xmwcsdealermkonnect/store";
    networkHelper.serviceURLString = url;
    [networkHelper genericJSONPayloadRequestWith:dropdowncall :self :@"Invoice Data"];
    }
}


- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
     [loadingView removeView];
     NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
     [data setDictionary:respondedObject];
    
        NSLog(@"Invoices %@",data);
        CustomerClaimInvoiceFetchDetailsVC *viewController =[[CustomerClaimInvoiceFetchDetailsVC alloc]init];
        viewController.InvoiceData = data;
        viewController.previousInvoice= invoiceNumber.text;
        viewController.cclable=claimType;
        viewController.requestData = requestData;
        [[self navigationController] pushViewController:viewController animated:YES];
        invoiceNumber.text =@"";
    
}
- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Authentication!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
   [textField resignFirstResponder];
    return true;
}
- (IBAction)topViewbackButton:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}


@end
