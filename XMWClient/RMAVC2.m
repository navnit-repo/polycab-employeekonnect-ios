//
//  RMAVC2.m
//  XMWClient
//
//  Created by dotvikios on 24/09/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "RMAVC2.h"
#import "LayoutClass.h"
#import "HttpEventListener.h"
#import "AppConstants.h"
#import "RMACardCell.h"
#import "DVAppDelegate.h"
@interface RMAVC2 ()

@end

@implementation RMAVC2
{
    NSMutableDictionary *responseDict;
    RMACardCell *rmaCardCell;
    NSMutableArray *allCardViewData;
    long int totalCell;
    int tag;
    int cellHeight;
    UIButton *submit;
    NSMutableArray *searchedInvoiceNoArray;
    UIPickerView *picker;
    NSArray *pickerData;
    NSArray *keys;
    NSArray *values;
    UIView *pickerView;
    long int rmaReturnForReasonTag;
    
    bool allFieldValueNotEmpty;
    

}
@synthesize scrollView;

- (void)viewDidLoad {
    
   
    
    [super viewDidLoad];
    
    [self customizeView];
    self.searchButton.layer.masksToBounds = YES;
    self.searchButton.layer.cornerRadius = 5.0f;
    
    allCardViewData = [[NSMutableArray alloc]init];
    tag = 1001;//card view tag number
    cellHeight = 0;
    searchedInvoiceNoArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view from its nib.
  
    self.invoiceTextField.layer.cornerRadius = 5;
    self.invoiceTextField.layer.masksToBounds = YES;
    self.invoiceTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.invoiceTextField.layer.borderWidth= 1.0f;
    self.invoiceTextField.delegate = self;
    self.searchButton.layer.cornerRadius = 5;
    self.searchButton.layer.masksToBounds = YES;
    
    [self autoLayout];
    
    
    if ([[forwardedDataPost valueForKey:@"RMA_RETURN_TYPE"] isEqualToString:@"With Invoice"]) {
        [self.costan2 removeFromSuperview];

    }
    else if ([[forwardedDataPost valueForKey:@"RMA_RETURN_TYPE"] isEqualToString:@"Without Invoice"])
    {
        self.costan2.frame = CGRectMake(self.costan2.frame.origin.x, 50, self.costan2.frame.size.width, self.costan2.frame.size.height);

        [self.invoiceTextField removeFromSuperview];
        [self.searchButton removeFromSuperview];
        [self blankCard];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewHeight:) name:@"scrollViewHeightUpdate" object:nil];
    
    [self addSubmitButtonView];
    
}

-(void)scrollViewHeight:(NSNotification*)notification{
    CGFloat height = [[notification.object  valueForKey:@"height"] floatValue];
    
    [scrollView setContentSize: CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height-height)];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"submitButton" object: nil];
}

-(void)autoLayout{
    [LayoutClass setLayoutForIPhone6:self.scrollView];
    [LayoutClass textfieldLayout:self.invoiceTextField forFontWeight:UIFontWeightRegular];
    [LayoutClass buttonLayout:self.searchButton forFontWeight:UIFontWeightRegular];
    [LayoutClass labelLayout:self.constant1 forFontWeight:UIFontWeightBold];
    [LayoutClass buttonLayout:self.costan2 forFontWeight:UIFontWeightRegular];
}
-(void)customizeView{
    NSArray *arrofView = [[self view] subviews];
    [[arrofView objectAtIndex:1] removeFromSuperview];

}
- (IBAction)addMoreButton:(id)sender {
    [self blankCard];
}
- (void)cellTag:(RMACardCell *)viewTag :(long)tag{
    rmaReturnForReasonTag = tag;
    pickerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    pickerView.backgroundColor = [UIColor clearColor];
    
    picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0,pickerView.bounds.size.height/2, self.view.frame.size.width, 160)];
    picker.backgroundColor = [UIColor whiteColor];
    [pickerView addSubview:picker];
    
    
    UIToolbar* pickerToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, (pickerView.frame.size.height/2)-40, pickerView.frame.size.width, 40)];
    pickerToolBar.barStyle = UIBarStyleBlackTranslucent;
    [pickerToolBar sizeToFit];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(closedPickerViewButton)];
    doneButton.tintColor = [UIColor whiteColor];
    
    
    pickerToolBar.items = @[doneButton];
    
    [pickerView addSubview:pickerToolBar];
    
    
    NSLog(@"FeedbackFormCustomerVC Call");
    picker.delegate= self;
    picker.dataSource = self;
    
    NSMutableArray  *dropDownData = [[NSMutableArray alloc]init];
    keys= [[[NSUserDefaults standardUserDefaults]valueForKey:@"RMA_REASON"] allKeys];
    values =[[[NSUserDefaults standardUserDefaults]valueForKey:@"RMA_REASON"] allValues];
    
    [dropDownData addObject:keys];
    [dropDownData addObject:values];
    
    pickerData = [[NSArray alloc]init];
    pickerData = values;
    
    [self.view addSubview:pickerView];
    
    
    
}

-(void)closedPickerViewButton{
    pickerView.hidden = YES;
   
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return pickerData.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
return pickerData[row];
 
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *selectedResult;
    selectedResult = pickerData[row];
    
    if ([selectedResult isEqualToString:@"Others"]) {
        RMACardCell *vc = [(RMACardCell*)self.view viewWithTag:rmaReturnForReasonTag];
        vc.reasonForReturnTextField.userInteractionEnabled = true;
        vc.reasonForReturnTextField.text = @"";
        vc.reasonForReturnTextField.placeholder = @"Write back to us";
    }
    else{
    RMACardCell *vc = [(RMACardCell*)self.view viewWithTag:rmaReturnForReasonTag];
    vc.reasonForReturnTextField.userInteractionEnabled = false;
    vc.reasonForReturnTextField.text = selectedResult;
    }
}
-(void)addSubmitButtonView{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    submit = [[UIButton alloc]initWithFrame:CGRectMake(10,0 ,screenWidth-20, 50)];
    
    submit.backgroundColor = [UIColor colorWithRed:204.0/255 green:41.0/255 blue:43.0/255 alpha:1.0];
    submit.titleLabel.textColor= [UIColor whiteColor];
    [submit setTitle:@"Submit" forState:UIControlStateNormal];
    [submit.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [submit addTarget:self action:@selector(submitButton:) forControlEvents:UIControlEventTouchUpInside];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSubmitButtonAxis:) name:@"submitButton" object:nil];
    
    submit.layer.cornerRadius  = 5.0f;
    submit.layer.masksToBounds = YES;
    submit.tag =50;
    
  
}
-(void)updateSubmitButtonAxis:(NSNotification*)notification{
    
    submit.frame = CGRectMake(submit.frame.origin.x,cellHeight+(148*deviceHeightRation) , submit.frame.size.width, submit.frame.size.height);
    
}
-(void)blankCard{
      rmaCardCell = [RMACardCell createInstance];
      rmaCardCell.delegate = self;
     [rmaCardCell configCellBlankCard:tag];
     rmaCardCell.tag= tag;
     tag = tag+1;
    //-50 for y axis changed ui
     rmaCardCell.frame = CGRectMake(10,((145-50)*deviceHeightRation)+cellHeight, rmaCardCell.bounds.size.width*deviceWidthRation, rmaCardCell.bounds.size.height*deviceHeightRation);
    [[NSNotificationCenter defaultCenter] addObserver:rmaCardCell selector:@selector(deleteView:) name:@"deleteView" object:nil];
    cellHeight = cellHeight+(250*deviceHeightRation);
    [self.scrollView addSubview:rmaCardCell];
    totalCell= totalCell+1;
    
    
    [[self.view viewWithTag:50]removeFromSuperview];//first remove submit button
      [[NSNotificationCenter defaultCenter] postNotificationName:@"submitButton" object: nil]; //update button frame
    [scrollView addSubview:submit];
    [scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width,(totalCell*250*deviceHeightRation)+200)];
    
    CGRect rect = [[UIScreen mainScreen]bounds];
    CGFloat mainScreenHeight = rect.size.height;
    if (scrollView.contentSize.height>mainScreenHeight) {
       [scrollView setContentOffset:CGPointMake(0, cellHeight-(300*deviceHeightRation)) animated:YES];
    }
   
    
    
}
-(void)addCard{
    
    totalCell = totalCell+[allCardViewData count];
    
    
    for (int i=0; i<allCardViewData.count; i++) {
        rmaCardCell = [RMACardCell createInstance];
        rmaCardCell.delegate = self;
        [rmaCardCell configCell:[allCardViewData objectAtIndex:i] :self.invoiceTextField.text :tag];
        rmaCardCell.tag= tag;
        tag = tag+1;
        //-50 for y axis changed ui
        rmaCardCell.frame = CGRectMake(10, ((138-50)*deviceHeightRation)+cellHeight, rmaCardCell.bounds.size.width*deviceWidthRation, rmaCardCell.bounds.size.height*deviceHeightRation);
   
        [[NSNotificationCenter defaultCenter] addObserver:rmaCardCell selector:@selector(deleteView:) name:@"deleteView" object:nil];

   
        
        cellHeight = cellHeight+(250*deviceHeightRation);
        [self.scrollView addSubview:rmaCardCell];
    }
    
    [[self.view viewWithTag:50]removeFromSuperview]; //first remove submit button
   
    if (allCardViewData.count!=0) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"submitButton" object: nil];//update button frame
        
        [scrollView addSubview:submit];
        
        [scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width,cellHeight+(200*deviceHeightRation))];
    }
    
    
    if (allCardViewData.count==0){ // when no card added then remove submit button
        [[self.view viewWithTag:50]removeFromSuperview];//first remove submit button
        [scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width,self.scrollView.frame.size.height)];//update scrollView frame
    }
    
}


- (IBAction)searchButton:(id)sender {

    
    bool contain = [searchedInvoiceNoArray containsObject:self.invoiceTextField.text];
    if (contain) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Already Searched" message:@"You have already search this invoice no." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 3;
        [alert show];
    }
    else{
    //Network Call
    loadingView = [LoadingView loadingViewInView:self.view];
    NSMutableDictionary *data = [[NSMutableDictionary alloc ]init];
    [data setObject:self.invoiceTextField.text forKey:@"invoice_number"];
    [data setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"USERNAME"] forKey:@"registry_id"];
    [data setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"USERNAME"] forKey:@"customer_number"];
    
    NSMutableDictionary * json = [[NSMutableDictionary  alloc]init];
    [json setObject:data forKey:@"data"];
    [json setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"AUTH_TOKEN"] forKey:@"authToken"];
    [json setObject:@"searchRma" forKey:@"opcode"];
    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=XmwcsConst_OPCODE_URL;
    networkHelper.serviceURLString = url;
    [networkHelper genericJSONPayloadRequestWith:json :self :@"searchRma"];

    }
}
- (void)httpResponseObjectHandler:(NSString *)callName :(id)respondedObject :(id)requestedObject{
    [loadingView removeView];
    if ([callName isEqualToString:@"searchRma"]) {
        if ([[respondedObject valueForKey:@"status"] isEqualToString:@"SUCCESS"]) {
            responseDict = [[NSMutableDictionary alloc]init];
            [responseDict setDictionary:respondedObject];
            NSLog(@"Searched Invoice : %@",responseDict);
            allCardViewData = [[NSMutableArray alloc]init];
            [allCardViewData addObjectsFromArray:[responseDict valueForKey:@"responseData"]];
            [searchedInvoiceNoArray addObject:self.invoiceTextField.text];
            [self addCard];
        }
        
        if ([[respondedObject valueForKey:@"status"] isEqualToString:@"failed"]) {
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Polycab" message:[respondedObject valueForKey:@"message"]  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [loadingView removeView];
            alert.tag= 1;
            [alert show];
            
        }
        
    }
    
    if ([callName isEqualToString:@"submitRma"]) {
       if ([[respondedObject valueForKey:@"status"] isEqualToString:@"SUCCESS"]) {
           UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[respondedObject valueForKey:@"message"]  message:[respondedObject valueForKey:@"trackerid"]  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [loadingView removeView];
           alert.tag= 2;
           [alert show];
          
       }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
   
    if (alertView.tag == 1 || alertView.tag ==3)
    {
        
    }
    else if (alertView.tag==2)
    {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Authentication!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
    
}


-(IBAction)submitButton:(id)sender{
    
    //Network Call
    NSMutableDictionary *data = [[NSMutableDictionary alloc ]init];
    [data setObject:@"Gurgaon" forKey:@"sales_location"];
    [data setObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"customer_name"] forKey:@"dealer_name"];
    [data setObject:[self.forwardedDataDisplay valueForKey:@"BUSINESS_VERTICAL"]  forKey:@"department"];
    NSMutableArray *returnProduct = [[NSMutableArray alloc]init];
    
    
    
    
    for (int i=0; i<totalCell; i++) { // check all field length
        RMACardCell *vc = [(RMACardCell*)self.view viewWithTag:i+1001];

        
        if (vc.productCategoryTextField.text.length==0    ) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Card :%ld Product Category", (long)vc.tag-1000]  message:@"Blank Field" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            break;
        }

        else if ( vc.skuCodeTextField.text.length==0){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Card :%ld SKU Code", (long)vc.tag-1000] message:@"Blank Field" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            break;

        }
        else if (vc.quantityTextField.text.length==0){

            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Card :%ld Quantity", (long)vc.tag-1000] message:@"Blank Field" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];

            [alert show];
            break;
        }
        //        else if (vc.polycabInvoiceTextField.text.length==0){
        //
        //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Invalid Input" message:@"Blank Field" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        //            [alert show];
        //        }
        else if (vc.reasonForReturnTextField.text.length==0){

            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Card :%ld Reason For Return", (long)vc.tag-1000] message:@"Blank Field" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];

            [alert show];
            break;
        }

        else if(i+2>totalCell){
            allFieldValueNotEmpty =YES; //all field correct
        }

    }


   if ( allFieldValueNotEmpty ==YES) {
        loadingView = [LoadingView loadingViewInView:self.view];
        for (int i=0; i<totalCell; i++) {
            NSMutableDictionary *array = [[NSMutableDictionary alloc]init];
            RMACardCell *vc = [(RMACardCell*)self.view viewWithTag:i+1001];
            [array setObject:[NSString stringWithFormat:@"%@", vc.productCategoryTextField.text] forKey:@"product_category"];
            [array setObject:[NSString stringWithFormat:@"%@",vc.skuCodeTextField.text] forKey:@"sku_code"];
            [array setObject:[NSString stringWithFormat:@"%@",vc.quantityTextField.text] forKey:@"quantity"];
            [array setObject:[NSString stringWithFormat:@"%@",vc.polycabInvoiceTextField.text] forKey:@"polycab_invoice_ref"];
            [array setObject:[NSString stringWithFormat:@"%@",vc.reasonForReturnTextField.text] forKey:@"reason_return"];
            [returnProduct addObject:array];
        }
        
        [data setObject:returnProduct forKey:@"return_product"];
        
        NSMutableDictionary * json = [[NSMutableDictionary  alloc]init];
        [json setObject:data forKey:@"data"];
        [json setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"AUTH_TOKEN"] forKey:@"authToken"];
        [json setObject:@"submitRma" forKey:@"opcode"];
        [json setObject:[forwardedDataPost valueForKey:@"COMMENT"]  forKey: @"comment"];
        networkHelper = [[NetworkHelper alloc]init];
        NSString * url=XmwcsConst_OPCODE_URL;
        networkHelper.serviceURLString = url;
        
        
        [networkHelper genericJSONPayloadRequestWith:json :self :@"submitRma"];
    
    }

}

- (void)crossButtonHandler:(RMACardCell *)buttonTag :(long)tags{
    UIView * view;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    for (view in self.scrollView.subviews) {
        if (view.tag == tags) {
            [view removeFromSuperview];
            [[NSNotificationCenter defaultCenter] removeObserver:view  name:@"deleteView" object:nil];
            totalCell = totalCell-1;
            tag = tag - 1;
            cellHeight = cellHeight-(250*deviceHeightRation);
            [dict setObject:[NSString stringWithFormat:@"%f", view.frame.size.height] forKey:@"height"];
            [dict setObject:[NSString stringWithFormat:@"%f", view.frame.origin.y] forKey:@"yAxis"];
            break;
        }
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteView" object:dict];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"scrollViewHeightUpdate" object:dict];
    
    if (totalCell==0) {
        [[self.view viewWithTag:50] removeFromSuperview];
    }
    
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}
@end
