//
//  FeedbackFormCustomerVC.m
//  XMWClient
//
//  Created by dotvikios on 31/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "FeedbackFormCustomerVC.h"
#import "NetworkHelper.h"
#import "LoadingView.h"
#import "FeedbackDropDownVC.h"
#import "LayoutClass.h"
@interface FeedbackFormCustomerVC ()

@end

@implementation FeedbackFormCustomerVC
{
    NSArray *pickerData;
     NSArray *deliveryPickerData;
    BOOL click;
    NetworkHelper *networkHelper;
    LoadingView *loadingView;
    NSMutableArray *wire_cables;
    UIScrollView *mainScrollView;
    UIPickerView *picker;
    
    BOOL deliveryPickerClicked;
    bool isKeyboardOpen;
    CGSize keyboardSize;
    int movedbyHeight;
    UITextField* activeTextField;
    
}
@synthesize pickerViewMain;
@synthesize selEnqFld,selComFld,selTechFld,selCAFld,selAnyOthrFld,selPrdFld,selPackFld,selDelFld;
@synthesize finalScrollView;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self autoLayout];
    [self loadForm];
    [self customizeTextField];
    [self configurePickerView];
}
-(void)autoLayout{
    [LayoutClass setLayoutForIPhone6:self.pickerViewMain];
    [LayoutClass setLayoutForIPhone6:self.finalScrollView];
    
    [LayoutClass labelLayout:self.constantView1 forFontWeight:UIFontWeightBold];
    [LayoutClass labelLayout:self.constantView2 forFontWeight:UIFontWeightLight];
    [LayoutClass labelLayout:self.constantView3 forFontWeight:UIFontWeightLight];
    [LayoutClass labelLayout:self.constantView4 forFontWeight:UIFontWeightLight];
    [LayoutClass labelLayout:self.constantView5 forFontWeight:UIFontWeightLight];
    [LayoutClass labelLayout:self.constantView6 forFontWeight:UIFontWeightLight];
    
    [LayoutClass labelLayout:self.constantView7 forFontWeight:UIFontWeightLight];
    [LayoutClass labelLayout:self.constantView9 forFontWeight:UIFontWeightLight];
    [LayoutClass labelLayout:self.constantView11 forFontWeight:UIFontWeightLight];
    
    [LayoutClass textfieldLayout:self.constantView8 forFontWeight:UIFontWeightLight];
    [LayoutClass textfieldLayout:self.constantView10 forFontWeight:UIFontWeightLight];
    [LayoutClass textfieldLayout:self.constantView12 forFontWeight:UIFontWeightLight];
    [LayoutClass setLayoutForIPhone6:self.constantView13];
    
    [LayoutClass setLayoutForIPhone6:self.view4];
    [LayoutClass setLayoutForIPhone6:self.view5];
    [LayoutClass setLayoutForIPhone6:self.view6];
    
     [LayoutClass labelLayout:self.constantView14 forFontWeight:UIFontWeightLight];
     [LayoutClass labelLayout:self.constantView17 forFontWeight:UIFontWeightLight];
     [LayoutClass labelLayout:self.constantView20 forFontWeight:UIFontWeightLight];
     [LayoutClass labelLayout:self.constantView23 forFontWeight:UIFontWeightLight];
     [LayoutClass labelLayout:self.constantView26 forFontWeight:UIFontWeightLight];
     [LayoutClass labelLayout:self.constantView29 forFontWeight:UIFontWeightLight];
     [LayoutClass labelLayout:self.constantView32 forFontWeight:UIFontWeightLight];
     [LayoutClass labelLayout:self.constantView35 forFontWeight:UIFontWeightLight];
     [LayoutClass labelLayout:self.constantView38 forFontWeight:UIFontWeightLight];
    
    [LayoutClass textfieldLayout:self.constantView15 forFontWeight:UIFontWeightLight];
    [LayoutClass textfieldLayout:self.constantView18 forFontWeight:UIFontWeightLight];
    [LayoutClass textfieldLayout:self.constantView21 forFontWeight:UIFontWeightLight];
    [LayoutClass textfieldLayout:self.constantView24 forFontWeight:UIFontWeightLight];
    [LayoutClass textfieldLayout:self.constantView27 forFontWeight:UIFontWeightLight];
    [LayoutClass textfieldLayout:self.constantView30 forFontWeight:UIFontWeightLight];
    [LayoutClass textfieldLayout:self.constantView33 forFontWeight:UIFontWeightLight];
    [LayoutClass textfieldLayout:self.constantView36 forFontWeight:UIFontWeightLight];
    
    [LayoutClass setLayoutForIPhone6:self.constantView16];
    [LayoutClass setLayoutForIPhone6:self.constantView19];
    [LayoutClass setLayoutForIPhone6:self.constantView22];
    [LayoutClass setLayoutForIPhone6:self.constantView25];
    [LayoutClass setLayoutForIPhone6:self.constantView28];
    [LayoutClass setLayoutForIPhone6:self.constantView31];
    [LayoutClass setLayoutForIPhone6:self.constantView34];
    [LayoutClass setLayoutForIPhone6:self.constantView37];
       [LayoutClass setLayoutForIPhone6:self.constantView39];
   
    
    
    
    
    
}
-(void)configurePickerView{
    picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0,pickerViewMain.bounds.size.height/2, self.view.frame.size.width, 160)];
    picker.backgroundColor = [UIColor whiteColor];
    [pickerViewMain addSubview:picker];
    
    
    UIToolbar* pickerToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, (pickerViewMain.frame.size.height/2)-40, pickerViewMain.frame.size.width, 40)];
    pickerToolBar.barStyle = UIBarStyleBlackTranslucent;
    [pickerToolBar sizeToFit];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(closedPickerViewButton)];
    doneButton.tintColor = [UIColor whiteColor];
    
    
    pickerToolBar.items = @[doneButton];
    
    [pickerViewMain addSubview:pickerToolBar];
    
    
    NSLog(@"FeedbackFormCustomerVC Call");
    picker.delegate= self;
    picker.dataSource = self;
    pickerData = [[NSArray alloc]init];
    pickerData = @[@"Meets Expectations(1)",@"Exceeds Expectations(2)",@"Doesn't Meet Expectations(0)"];
    deliveryPickerData = [[NSArray alloc]init];
    deliveryPickerData = @[@"Delayed by 7 days(1)",@"On time as requested(2)",@"Delayed more than 7 days(0)"];
}

-(void)customizeTextField{
    self.customeName.text =[[NSUserDefaults standardUserDefaults]valueForKey:@"CUSTOMER_NAME"];
    self.customeName.userInteractionEnabled = NO;
    self.customeName.borderStyle = UITextBorderStyleRoundedRect;
    self.customeName.layer.masksToBounds=YES;
    self.customeName.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.customeName.layer.cornerRadius=5.0f;
    self.customeName.layer.borderWidth= 1.0f;
    
    self.locationField.borderStyle = UITextBorderStyleRoundedRect;
    self.locationField.layer.masksToBounds=YES;
    self.locationField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.locationField.layer.cornerRadius=5.0f;
    self.locationField.layer.borderWidth= 1.0f;
    
    

    self.selectWireField.userInteractionEnabled = NO;
    self.selectWireField.borderStyle = UITextBorderStyleRoundedRect;
    self.selectWireField.layer.masksToBounds=YES;
    self.selectWireField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.selectWireField.layer.cornerRadius=5.0f;
    self.selectWireField.layer.borderWidth= 1.0f;
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"downarrow_right_arrow.png"]];
    imageView.frame = CGRectMake(0, 0, 20, 20);
    imageView.contentMode = UIViewContentModeCenter;
    [self.selectWireField setRightView:imageView];
    [self.selectWireField setRightViewMode:UITextFieldViewModeAlways];
    
    
    
    selEnqFld.userInteractionEnabled = FALSE;
    selEnqFld.borderStyle = UITextBorderStyleRoundedRect;
    selEnqFld.layer.masksToBounds=YES;
    selEnqFld.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    selEnqFld.layer.cornerRadius=5.0f;
    selEnqFld.layer.borderWidth= 1.0f;
    
    
    selComFld.userInteractionEnabled = FALSE;
    selComFld.borderStyle = UITextBorderStyleRoundedRect;
    selComFld.layer.masksToBounds=YES;
    selComFld.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    selComFld.layer.cornerRadius=5.0f;
    selComFld.layer.borderWidth= 1.0f;
    
    
    selTechFld.userInteractionEnabled = FALSE;
    selTechFld.borderStyle = UITextBorderStyleRoundedRect;
    selTechFld.layer.masksToBounds=YES;
    selTechFld.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    selTechFld.layer.cornerRadius=5.0f;
    selTechFld.layer.borderWidth= 1.0f;
    
    
    
    selCAFld.userInteractionEnabled = FALSE;
    selCAFld.borderStyle = UITextBorderStyleRoundedRect;
    selCAFld.layer.masksToBounds=YES;
    selCAFld.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    selCAFld.layer.cornerRadius=5.0f;
    selCAFld.layer.borderWidth= 1.0f;
    
    
    
    selAnyOthrFld.userInteractionEnabled = FALSE;
    selAnyOthrFld.borderStyle = UITextBorderStyleRoundedRect;
    selAnyOthrFld.layer.masksToBounds=YES;
    selAnyOthrFld.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    selAnyOthrFld.layer.cornerRadius=5.0f;
    selAnyOthrFld.layer.borderWidth= 1.0f;
    
    
    
    selPrdFld.userInteractionEnabled = FALSE;
    selPrdFld.borderStyle = UITextBorderStyleRoundedRect;
    selPrdFld.layer.masksToBounds=YES;
    selPrdFld.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    selPrdFld.layer.cornerRadius=5.0f;
    selPrdFld.layer.borderWidth= 1.0f;
    
    
    
    selPackFld.userInteractionEnabled = FALSE;
    selPackFld.borderStyle = UITextBorderStyleRoundedRect;
    selPackFld.layer.masksToBounds=YES;
    selPackFld.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    selPackFld.layer.cornerRadius=5.0f;
    selPackFld.layer.borderWidth= 1.0f;
    
    
    
    selDelFld.userInteractionEnabled = FALSE;
    selDelFld.borderStyle = UITextBorderStyleRoundedRect;
    selDelFld.layer.masksToBounds=YES;
    selDelFld.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    selDelFld.layer.cornerRadius=5.0f;
    selDelFld.layer.borderWidth= 1.0f;
    
    self.submitButton.layer.masksToBounds = YES;
    self.submitButton.layer.cornerRadius = 5.0f;
    
    selEnqFld.delegate = self;
    selComFld.delegate = self;
    selTechFld.delegate = self;
    selCAFld.delegate = self;
    selAnyOthrFld.delegate = self;
    selPrdFld.delegate = self;
    selPackFld.delegate = self;
    selDelFld.delegate = self;
    self.locationField.delegate = self;
    
    
    
}
- (IBAction)typesOfWireButton:(id)sender {
    FeedbackDropDownVC *vc = [[FeedbackDropDownVC alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)doneButton:(FeedbackDropDownVC *)array :(NSMutableArray *)selectedWireList{
    wire_cables = [[NSMutableArray alloc]init];
    if (selectedWireList.count!=0) {
        [wire_cables addObjectsFromArray:selectedWireList];
        
    }
    
    
    NSString *list =@"";
    for (int i=0; i<wire_cables.count; i++) {
        list = [list stringByAppendingString:[wire_cables objectAtIndex:i]];
        list = [list stringByAppendingString:@","];
        
    }
    NSLog(@"Selected List : %@",list);
    list = [list substringToIndex:(list.length - 1)];
  
    self.selectWireField.backgroundColor = [UIColor clearColor];
    self.selectWireField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.selectWireField.minimumFontSize = 10.0;
    self.selectWireField.adjustsFontSizeToFitWidth = YES;
    self.selectWireField.text = list;
}


- (void)loadForm{
    
    //for empty FormVC load form method & own load custome form
    
    mainScrollView = [[UIScrollView alloc]init];
    mainScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
     mainScrollView.backgroundColor = [UIColor clearColor];
    [mainScrollView addSubview:finalScrollView];
    mainScrollView.contentSize = CGSizeMake(finalScrollView.frame.size.width, finalScrollView.frame.size.height);
    [self.view addSubview:mainScrollView];
    
}

- (IBAction)selectEnquriesButton:(id)sender {
    pickerViewMain.hidden = NO;
    pickerViewMain.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    pickerViewMain.tag = 0;
    [self.view addSubview:pickerViewMain];
}
- (IBAction)selectComplaintsButton:(id)sender {
    pickerViewMain.hidden = NO;
    pickerViewMain.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    pickerViewMain.tag = 1;
    [self.view addSubview:pickerViewMain];
}
- (IBAction)selectTechnicalButton:(id)sender {
    pickerViewMain.hidden = NO;
    pickerViewMain.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    pickerViewMain.tag = 2;
    [self.view addSubview:pickerViewMain];
}
- (IBAction)selectCArequestedButton:(id)sender {
    pickerViewMain.hidden = NO;
    pickerViewMain.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    pickerViewMain.tag = 3;
    [self.view addSubview:pickerViewMain];
}
- (IBAction)selectAnyotherButton:(id)sender {
    pickerViewMain.hidden = NO;
    pickerViewMain.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    pickerViewMain.tag = 4;
    [self.view addSubview:pickerViewMain];
}
- (IBAction)selectProductButton:(id)sender {
    pickerViewMain.hidden = NO;
    pickerViewMain.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    pickerViewMain.tag = 5;
    [self.view addSubview:pickerViewMain];
}
- (IBAction)selectPackagingButton:(id)sender {
    pickerViewMain.hidden = NO;
    pickerViewMain.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    pickerViewMain.tag = 6;
    [self.view addSubview:pickerViewMain];
}
- (IBAction)selectDeliveryButton:(id)sender {
    pickerViewMain.hidden = NO;
    pickerViewMain.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    pickerViewMain.tag = 7;
    
    deliveryPickerClicked = YES;
    
    [self.view addSubview:pickerViewMain];
}
-(void)closedPickerViewButton{
    pickerViewMain.hidden = YES;
    deliveryPickerClicked = NO;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return pickerData.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (deliveryPickerClicked ==YES) {
    return deliveryPickerData[row];
    }
    else{
    return pickerData[row];
    }

}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *selectedResult;
    
    if (deliveryPickerClicked ==YES) {
      selectedResult = deliveryPickerData[row];
    }
    else{
      selectedResult = pickerData[row];
    }
    
    NSLog(@"%@",selectedResult);
    if (pickerViewMain.tag ==0) {
        if ([selectedResult isEqualToString:@"Doesn't Meet Expectations(0)"]) {
            selEnqFld.userInteractionEnabled = true;
            selEnqFld.text = @"";
            selEnqFld.placeholder = @"Write back to us";
        }
        else{
        selEnqFld.userInteractionEnabled = false;
        self.selEnqFld.text =selectedResult;
        }
    }
    else if (pickerViewMain.tag==1) {
        if ([selectedResult isEqualToString:@"Doesn't Meet Expectations(0)"]) {
            selComFld.userInteractionEnabled = true;
            selComFld.text = @"";
            selComFld.placeholder = @"Write back to us";
        }
        else{
        selComFld.userInteractionEnabled = false;
        self.selComFld.text =selectedResult;
        }
    }
    else if (pickerViewMain.tag==2) {
        if ([selectedResult isEqualToString:@"Doesn't Meet Expectations(0)"]) {
            selTechFld.userInteractionEnabled = true;
            selTechFld.text = @"";
            selTechFld.placeholder = @"Write back to us";
        }
        else{
        selTechFld.userInteractionEnabled = false;
        self.selTechFld.text =selectedResult;
        }
    }
    else if (pickerViewMain.tag==3) {
        if ([selectedResult isEqualToString:@"Doesn't Meet Expectations(0)"]) {
            selCAFld.userInteractionEnabled = true;
            selCAFld.text = @"";
            selCAFld.placeholder = @"Write back to us";
        }
        else{
        selCAFld.userInteractionEnabled = false;
        self.selCAFld.text =selectedResult;
        }
    }
    else if (pickerViewMain.tag==4) {
        if ([selectedResult isEqualToString:@"Doesn't Meet Expectations(0)"]) {
            selAnyOthrFld.userInteractionEnabled = true;
            selAnyOthrFld.text = @"";
            selAnyOthrFld.placeholder = @"Write back to us";
        }
        else{
        selAnyOthrFld.userInteractionEnabled = false;
        self.selAnyOthrFld.text =selectedResult;
        }
    }
    else if (pickerViewMain.tag==5) {
        if ([selectedResult isEqualToString:@"Doesn't Meet Expectations(0)"]) {
            selPrdFld.userInteractionEnabled = true;
            selPrdFld.text = @"";
            selPrdFld.placeholder = @"Write back to us";
        }
        else{
        selPrdFld.userInteractionEnabled = false;
        self.selPrdFld.text =selectedResult;
        }
    }
    else if (pickerViewMain.tag==6) {
        if ([selectedResult isEqualToString:@"Doesn't Meet Expectations(0)"]) {
            selPackFld.userInteractionEnabled = true;
            selPackFld.text = @"";
            selPackFld.placeholder = @"Write back to us";
        }
        else{
        selPackFld.userInteractionEnabled = false;
        self.selPackFld.text =selectedResult;
        }
    }
    else if (pickerViewMain.tag==7) {
        if ([selectedResult isEqualToString:@"Delayed more than 7 days(0)"]) {
            selDelFld.userInteractionEnabled = true;
            selDelFld.text = @"";
            selDelFld.placeholder = @"Write back to us";
        }
        else{
        selDelFld.userInteractionEnabled = false;
        self.selDelFld.text =selectedResult;
        }
    }
}
- (IBAction)submitRequstButton:(id)sender {
    NSLog(@"%@",auth_Token);
    //network Call
    loadingView= [LoadingView loadingViewInView:self.view];
    NSString *userName;
    userName= [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    
    [data setObject:userName forKey:@"registry_id"];
    [data setObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"CUSTOMER_NAME"] forKey:@"customer_name"];
    [data setObject:@"" forKey:@"location"];
    [data setObject:wire_cables forKey:@"wire_cable"];
    [data setObject:selPackFld.text forKey:@"packaging"];
    [data setObject:selComFld.text forKey:@"complaint"];
    [data setObject:selEnqFld.text forKey:@"enquiry"];
    [data setObject:selAnyOthrFld.text forKey:@"other"];
    [data setObject:selCAFld.text forKey:@"ca_request"];
    [data setObject:selTechFld.text forKey:@"technical"];
    [data setObject:selDelFld.text forKey:@"delivery"];
    [data setObject:selPrdFld.text forKey:@"product"];
    NSMutableDictionary *customerFeedbackRqst = [[NSMutableDictionary alloc]init];
    [customerFeedbackRqst setObject:data forKey:@"data"];
    [customerFeedbackRqst setObject:auth_Token forKey:@"authToken"];
    [customerFeedbackRqst setValue:@"customer_feedback" forKey:@"opcode"];


    networkHelper = [[NetworkHelper alloc]init];
    NSString * url=XmwcsConst_OPCODE_URL;
    networkHelper.serviceURLString = url;
    [networkHelper genericJSONPayloadRequestWith:customerFeedbackRqst :self :@"customer_feedback"];
    
}
- (void)httpResponseObjectHandler:(NSString *)callName :(id)respondedObject :(id)requestedObject{
    [loadingView removeView];
    if ( [callName isEqualToString:@"customer_feedback"]) {
        if([[respondedObject valueForKey:@"status"]isEqualToString:@"SUCCESS"])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Feedback" message:[respondedObject valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
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
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if(isKeyboardOpen){
        //Cursor on textbox1
        self.view.frame  = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + movedbyHeight, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    isKeyboardOpen=true;
    
    
    NSDictionary* info = [aNotification userInfo];
    keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    
    CGRect textFieldRect = [self.view.window convertRect:activeTextField.bounds fromView:activeTextField];
    
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    NSLog(@"FormVC keyboardWasShown");
    NSLog(@"activeTextField.frame.origin.y = %f", activeTextField.frame.origin.y);
    NSLog(@"self.view.frame.size.height = %f", self.view.frame.size.height);
    
    if(textFieldRect.origin.y > (viewRect.size.height - keyboardSize.height)) {
        movedbyHeight =  textFieldRect.origin.y - (viewRect.size.height  - keyboardSize.height);
        movedbyHeight = movedbyHeight+30;
        //movedbyHeight =  textFieldRect.origin.y - keyboardSize.height ;
        
        self.view.frame  = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - movedbyHeight, self.view.frame.size.width, self.view.frame.size.height);
        
        
        
    }
    
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
    
    isKeyboardOpen=false;
    NSLog(@"FormVC keyboardWillBeHidden");
    
    
    self.view.frame  = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + movedbyHeight, self.view.frame.size.width, self.view.frame.size.height);
    
    
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
    
    
    return YES;
}


@end
