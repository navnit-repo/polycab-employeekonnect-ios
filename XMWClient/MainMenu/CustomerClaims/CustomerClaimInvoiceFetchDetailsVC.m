//
//  CustomerClaimInvoiceFetchDetailsVC.m
//  XMWClient
//
//  Created by dotvikios on 22/06/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "CustomerClaimInvoiceFetchDetailsVC.h"
#import "InvoiceView.h"
#import "NetworkHelper.h"
#import "HttpEventListener.h"
#import "showInfoClaimVC.h"
#import "LoadingView.h"
#define InvoiceStartTag 1000
@interface CustomerClaimInvoiceFetchDetailsVC ()
{
     NetworkHelper* networkHelper;
     InvoiceView* invoiceView ;
     LoadingView *loadingView;
}

@end

@implementation CustomerClaimInvoiceFetchDetailsVC
{
    int i;
    int j;
    int tagNumbar;
    int totalInvoiceCount;
    int cellConut;
    long int viewCartHeight;
    NSMutableArray *previousSearchInvoiceNumberArray;
    NSString *checkInvoiceNo;
    NSMutableArray *pushInvoceTagArray;
    NSMutableDictionary *searchInvoiceData;
    
}

@synthesize InvoiceData;
@synthesize invoiceSearchField;
@synthesize scroll;
@synthesize search;
@synthesize searchView;
@synthesize previousInvoice;
@synthesize rateDifference;
@synthesize claimReason;
@synthesize ccLableName;
@synthesize topView;
@synthesize cclable;
@synthesize requestData;


- (void)viewDidLoad {
 
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setHidesBackButton:YES animated:YES];
    ccLableName.text = cclable;
    self.navigationItem.titleView = topView;
    
    
    NSLog(@"Customer Claim Invoice Fetch Details VC Call %@",InvoiceData);
    //Already Search Invoice number add in NSMutableArray
    previousSearchInvoiceNumberArray = [[NSMutableArray alloc]init];
    [previousSearchInvoiceNumberArray addObject:previousInvoice];
    
    NSLog(@"Invoice search result %@",InvoiceData);
    self.invoiceSearchField.delegate = self;
    searchInvoiceData = [[NSMutableDictionary alloc]init];
    self.claimReason.delegate = self;
    [self cellDataLoad];
}

// create button and text Filed and Lable
-(void)viewField{
    
    //searchView
    searchView.frame = CGRectMake(0 , viewCartHeight *380, 320.0, 182.0);
    [scroll addSubview:searchView];
}
//cell Data
-(void)cellDataLoad{
    
    NSArray* responseData = [InvoiceData objectForKey:@"responseData"];
    viewCartHeight = viewCartHeight + [responseData count];
    for ( i=0 ; i < responseData.count; i++) {
        long int cal = InvoiceStartTag + j;
        NSString *invoice = [NSString stringWithFormat:@"%ld",cal];
        [searchInvoiceData setObject:[responseData objectAtIndex:i] forKey:invoice];
        invoiceView = [InvoiceView createInstance:cellConut*380];
        invoiceView.delegate = self;
        cellConut = cellConut+1;
        invoiceView.tag = InvoiceStartTag + j;
        [invoiceView configure:[responseData objectAtIndex:i]];
         [scroll addSubview:invoiceView];
       
      
        j= j+1;
        totalInvoiceCount = j;
        NSLog(@"%i View Cart Tag:- %ld",i+1,invoiceView.tag);
    }
    tagNumbar = i;
     [scroll setContentSize:CGSizeMake(320 , (viewCartHeight *380)+182)];
    [self viewField];
}


- (IBAction)search:(id)sender {
    loadingView= [LoadingView loadingViewInView:self.view];
    if ([invoiceSearchField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Havells mKonnect"
                                                        message:@"Blank Invoice Number"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
         [loadingView removeView];
         [alert show];
    }
    else if (invoiceSearchField.text !=nil)
    {
        checkInvoiceNo = invoiceSearchField.text;
        BOOL contains = [previousSearchInvoiceNumberArray containsObject:checkInvoiceNo];
        if (contains == YES) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Havells mKonnect"
                                                            message:@"Already Searched Invoice Number"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            [loadingView removeView];
            [alert show];

        }
            else{
                [self againSearch];
                
                }
        }

    
}

-(void)againSearch{
     //If search invoice number not present in NSMutableArray then add searched invoice in NSMutablearray
    BOOL contains = [previousSearchInvoiceNumberArray containsObject:checkInvoiceNo];
    if (contains != YES){
    [previousSearchInvoiceNumberArray addObject:checkInvoiceNo];
    }
    //Network Call
    NSString * invoiceSearch1 = @"[";
    NSString * invoiceSearch2 = invoiceSearchField.text;
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

- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    [loadingView removeView];
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    [data setDictionary:respondedObject];
    NSLog(@"Invoices %@",data);
    InvoiceData = data;
    invoiceSearchField.text = @"";
    [self cellDataLoad];
}
- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];
    
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Authentication!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
    
}
- (void)didTextFieldLoad:(InvoiceView *)Difference Rate:(NSString *)claimAmount
{
    NSLog(@"Total Tags %D",tagNumbar);
    double amount =0.00 ;
    for (int i=0; i<totalInvoiceCount; i++) {
        InvoiceView* iv = (InvoiceView*)[self.view viewWithTag:InvoiceStartTag+i];

            NSString*claimAmountSelectformCart;
            claimAmountSelectformCart= iv.claimedAmount.text;
            amount = amount + [claimAmountSelectformCart doubleValue];
    }
    NSString *calculatedAmount;
    
    calculatedAmount =[NSString stringWithFormat:@"%0.2f",amount];
    rateDifference.text = calculatedAmount;
    
}

- (IBAction)showClaimInfo:(id)sender {
    showInfoClaimVC *vc = [[showInfoClaimVC alloc]init];
    NSMutableDictionary *dataDictWithTag = [[NSMutableDictionary alloc]init];
   
     pushInvoceTagArray = [[NSMutableArray alloc]init];
    for (int i=0; i<totalInvoiceCount; i++) {
        InvoiceView* iv = (InvoiceView*)[self.view viewWithTag:InvoiceStartTag+i];

        if ([iv.claimedAmount.text isEqualToString:@""] ||[iv.claimedAmount.text isEqualToString:@"0.00"]) {
            //do nothing
        }
        else{
             long int  invoiceTag= iv.tag;
             NSString *tag = [NSString stringWithFormat:@"%ld",invoiceTag];
             [pushInvoceTagArray addObject:tag];
             NSMutableDictionary *dataData= [[NSMutableDictionary alloc]init];
            
             [dataData setObject:iv.invoiceNo.text forKey:@"IN"];
             [dataData setObject:iv.date.text forKey:@"D"];
             [dataData setObject:iv.billingItem.text forKey:@"BI"];
             [dataData setObject:iv.division.text forKey:@"DIV"];
             [dataData setObject:iv.productInfo.text forKey:@"PI"];
             [dataData setObject:iv.salesUnit.text forKey:@"SU"];
             [dataData setObject:iv.invoiceQty.text forKey:@"IQ"];
             [dataData setObject:iv.netValue.text forKey:@"NV"];
             [dataData setObject:iv.ratePerUnit.text forKey:@"RPU"];
             [dataData setObject:iv.perUnitCustomerValue.text forKey:@"PUCV"];
             [dataData setObject:iv.nwNetValue.text forKey:@"NNV"];
             [dataData setObject:iv.claimedAmount.text forKey:@"CA"];
             [dataData setObject:iv.remark.text forKey:@"R"];
             [dataDictWithTag setObject:dataData forKey:tag];
        }
    }
       vc.totalAmount = rateDifference.text;
       vc.reason = claimReason.text;
       vc.requestData = requestData;
       vc.invoiceTagNumber = pushInvoceTagArray;
       vc.ccLable =ccLableName.text;
       vc.showViewData= searchInvoiceData;
       vc.chagedData = dataDictWithTag;
      [[self navigationController] pushViewController:vc animated:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}
- (IBAction)topViewBackButton:(id)sender {
[self.navigationController popViewControllerAnimated:YES];
}


@end
