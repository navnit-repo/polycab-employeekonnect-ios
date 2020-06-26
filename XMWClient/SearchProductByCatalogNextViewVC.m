//
//  SearchProductByCatalogNextViewVC.m
//  XMWClient
//
//  Created by dotvikios on 21/01/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "SearchProductByCatalogNextViewVC.h"
#import "MXTextField.h"
#import "MXButton.h"
#define DotSearchConst_SEARCH_TEXT @"SEARCH_TEXT"
#define DotSearchConst_SEARCH_BY @"SEARCH_BY"
#import "SearchProductListVC.h"
#import "DVAppDelegate.h"
#import "LoadingView.h"
#import "NetworkHelper.h"
#import "Styles.h"
#import "ClientVariable.h"
#import "PolycabSearchViewController.h"
@interface SearchProductByCatalogNextViewVC ()

@end

@implementation SearchProductByCatalogNextViewVC
{
    UITableView *mainTableView;
    int count;
    SearchProductListVC *searchProductListVC;
    
    NSMutableDictionary *componentMap;
    BOOL isOpenPicker;
    NetworkHelper* networkHelper;
    LoadingView* loadingView;
}
@synthesize shipTo;
@synthesize billTo;
@synthesize itemNameString;
@synthesize catalogReqstData;
@synthesize coreTextField,colorTextField,squareTextField,uomDescriptionTextField;
@synthesize coreButton,colorButton,squareButton,uomDescriptionButton;
- (void)viewDidLoad {
    [super viewDidLoad];
    componentMap =[[NSMutableDictionary alloc]init];
    NSLog(@"Selected Data %@",catalogReqstData);
    NSLog(@"Selected Item %@",itemNameString);
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage
                                                                          imageNamed:@"back-button.png"] style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(backHandler:)];
    
    backButton.tintColor = [UIColor whiteColor];
    
    UIImageView *polycabLogo = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"polycab_logo"]];
    self.navigationItem.titleView.contentMode = UIViewContentModeCenter;
    self.navigationItem.titleView = polycabLogo;
    [self.navigationItem setLeftBarButtonItem:backButton];
    
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    
    mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.bounces = NO;

    [self.view addSubview:mainTableView];
    
   
}


- (void) backHandler : (id) sender {
    if(multiSelectDelegate !=nil && [multiSelectDelegate respondsToSelector:@selector(selectionCancelled)]) {
        [multiSelectDelegate selectionCancelled];
    }
    [ [self navigationController]  popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(IBAction)extraDropDown:(id)sender{
    MXButton* button = (MXButton*) sender;
    self.mxButton = (MXButton*) sender;
    NSLog(@"%@",((MXButton *)sender).tag);
    NSMutableArray* dropDownList = [[NSMutableArray alloc] init];
    NSMutableArray* dropDownListKey = [[NSMutableArray alloc] init];
    NSMutableArray *keys = button.attachedData[0];
    NSMutableArray *values =button.attachedData[1];
    [dropDownListKey addObjectsFromArray : keys];
    [dropDownList addObjectsFromArray : values];
    searchProductListVC=[[SearchProductListVC alloc]initWithNibName:@"SelectedListVC" bundle:nil];
    searchProductListVC.dropDownList = dropDownList;
    searchProductListVC.dropDownListKey = dropDownListKey;
    searchProductListVC.delegate=self;
    [self.navigationController pushViewController:searchProductListVC animated:YES];
}
-(id) getDataFromId : (NSString *) objectId
{
    
    return[componentMap objectForKey : objectId];
    
}
-(void) cancel:(SelectedListVC*) selectedListVC context:(NSString*) context;
{
    isOpenPicker = YES;
    
}
-(void) done:(SelectedListVC*) selectedListVC context:(NSString*) context code:(NSString*) code display:(NSString*) display;
{
    
    //for polycab chnage some handling
    NSString *search= [self.mxButton.elementId stringByReplacingOccurrencesOfString:@"_Button" withString:@""];
    MXTextField *dropDownField = (MXTextField *) [self getDataFromId:search];
    dropDownField.keyvalue = code;
    dropDownField.text = display;
    
    if ([dropDownField.elementId isEqualToString:@"CORE"]) {
        NSArray *key = [[NSArray alloc]init];
        key = @[@""];
        NSArray *value = [[NSArray alloc]init];
        value = @[@""];
        NSMutableArray *attachDataArray = [[NSMutableArray alloc]init];
        [attachDataArray addObject:key];
        [attachDataArray addObject:value];
        
        //first rest other button data and text field
        self.colorButton.attachedData =attachDataArray;
        self.uomDescriptionButton.attachedData = attachDataArray;
        self.squareTextField.text = @"";
        self.colorTextField.text = @"";
        self.uomDescriptionTextField.text = @"";
        
        
        
        DotFormPost *formPost = [[DotFormPost alloc]init];
        [formPost.postData setObject:@""forKey:DotSearchConst_SEARCH_TEXT];
        [formPost.postData setObject: @"SBN"forKey:DotSearchConst_SEARCH_BY];
        [formPost.postData setObject:billTo forKey:@"BILL_TO"];
        [formPost.postData setObject:shipTo forKey:@"SHIP_TO"];
        [formPost.postData setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedRegisterIDCode"] forKey:@"USERNAME"];
        [formPost.postData setObject:[catalogReqstData valueForKey:@"CUSTOMER_NUMBER"] forKey:@"BUSINESS_VERTICAL"];
        [formPost.postData setObject:[catalogReqstData valueForKey:@"PRY_ITEMCATEGORY"] forKey:@"PRY_ITEMCATEGORY"];
        [formPost.postData setObject:[catalogReqstData valueForKey:@"PRY_SUBITEMCATEGORY"] forKey:@"PRY_SUBITEMCATEGORY"];
        [formPost.postData setObject:[catalogReqstData valueForKey:@"SECOND_ITEMCATEGORY"] forKey:@"SECOND_ITEMCATEGORY"];
        [formPost.postData setObject:[catalogReqstData valueForKey:@"SECOND_SUBITEMCATEGORY"] forKey:@"SECOND_SUBITEMCATEGORY"];
        [formPost.postData setObject:self.coreTextField.text forKey:@"CORE"];
        [formPost setModuleId: [DVAppDelegate currentModuleContext]];
        [formPost setDocId: @"SQAUREMM_BY_WNC_CORE"];
        [formPost setReportCacheRefresh:@"false"];
        
        loadingView = [LoadingView loadingViewInView:self.view];
        
        networkHelper = [[NetworkHelper alloc] init];
        [networkHelper makeXmwNetworkCall:formPost :self : nil :  @"FOR_SEARCH_IGNORE_SESSION"];
        
    }
    
    if ([dropDownField.elementId isEqualToString:@"SQAUREMM"]) {
        NSArray *key = [[NSArray alloc]init];
        key = @[@""];
        NSArray *value = [[NSArray alloc]init];
        value = @[@""];
        NSMutableArray *attachDataArray = [[NSMutableArray alloc]init];
        [attachDataArray addObject:key];
        [attachDataArray addObject:value];
        
        //first rest other button data and text field
        self.colorTextField.text = @"";
        self.uomDescriptionTextField.text = @"";
        self.uomDescriptionButton.attachedData = attachDataArray;
        
        
        
        DotFormPost *formPost = [[DotFormPost alloc]init];
        [formPost.postData setObject:@"" forKey:DotSearchConst_SEARCH_TEXT];
        [formPost.postData setObject:@"SBN" forKey:DotSearchConst_SEARCH_BY];
        [formPost.postData setObject:billTo forKey:@"BILL_TO"];
        [formPost.postData setObject:shipTo forKey:@"SHIP_TO"];
        [formPost.postData setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedRegisterIDCode"] forKey:@"USERNAME"];
        [formPost.postData setObject:[catalogReqstData valueForKey:@"CUSTOMER_NUMBER"] forKey:@"BUSINESS_VERTICAL"];
        [formPost.postData setObject:[catalogReqstData valueForKey:@"CUSTOMER_NUMBER"] forKey:@"BUSINESS_VERTICAL"];
        [formPost.postData setObject:[catalogReqstData valueForKey:@"PRY_ITEMCATEGORY"] forKey:@"PRY_ITEMCATEGORY"];
        [formPost.postData setObject:[catalogReqstData valueForKey:@"PRY_SUBITEMCATEGORY"] forKey:@"PRY_SUBITEMCATEGORY"];
        [formPost.postData setObject:[catalogReqstData valueForKey:@"SECOND_ITEMCATEGORY"] forKey:@"SECOND_ITEMCATEGORY"];
        [formPost.postData setObject:[catalogReqstData valueForKey:@"SECOND_SUBITEMCATEGORY"] forKey:@"SECOND_SUBITEMCATEGORY"];
        [formPost.postData setObject:self.coreTextField.text forKey:@"CORE"];
        //        [formPost.postData setObject:self.colorTextField.text forKey:@"COLOR"];
        [formPost.postData setObject:self.squareTextField.text forKey:@"SQAUREMM"];
        [formPost setModuleId: [DVAppDelegate currentModuleContext]];
        [formPost setDocId: @"COLORS_BY_WNC_CORE_SQAUREMM"];
        [formPost setReportCacheRefresh:@"false"];
        
        loadingView = [LoadingView loadingViewInView:self.view];
        
        networkHelper = [[NetworkHelper alloc] init];
        [networkHelper makeXmwNetworkCall:formPost :self : nil :  @"FOR_SEARCH_IGNORE_SESSION"];
    }
    
    if ([dropDownField.elementId isEqualToString:@"COLOR"]) {
        
        NSArray *key = [[NSArray alloc]init];
        key = @[@""];
        NSArray *value = [[NSArray alloc]init];
        value = @[@""];
        NSMutableArray *attachDataArray = [[NSMutableArray alloc]init];
        [attachDataArray addObject:key];
        [attachDataArray addObject:value];
        
        //first rest other button data and text field
        self.uomDescriptionButton.attachedData = attachDataArray;
        self.uomDescriptionTextField.text = @"";
        
        DotFormPost *formPost = [[DotFormPost alloc]init];
        [formPost.postData setObject:@"" forKey:DotSearchConst_SEARCH_TEXT];
        [formPost.postData setObject:@"SBN" forKey:DotSearchConst_SEARCH_BY];
        [formPost.postData setObject:billTo forKey:@"BILL_TO"];
        [formPost.postData setObject:shipTo forKey:@"SHIP_TO"];
        [formPost.postData setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedRegisterIDCode"] forKey:@"USERNAME"];
        [formPost.postData setObject:[catalogReqstData valueForKey:@"CUSTOMER_NUMBER"] forKey:@"BUSINESS_VERTICAL"];
        [formPost.postData setObject:[catalogReqstData valueForKey:@"CUSTOMER_NUMBER"] forKey:@"BUSINESS_VERTICAL"];
        [formPost.postData setObject:[catalogReqstData valueForKey:@"PRY_ITEMCATEGORY"] forKey:@"PRY_ITEMCATEGORY"];
        [formPost.postData setObject:[catalogReqstData valueForKey:@"PRY_SUBITEMCATEGORY"] forKey:@"PRY_SUBITEMCATEGORY"];
        [formPost.postData setObject:[catalogReqstData valueForKey:@"SECOND_ITEMCATEGORY"] forKey:@"SECOND_ITEMCATEGORY"];
        [formPost.postData setObject:[catalogReqstData valueForKey:@"SECOND_SUBITEMCATEGORY"] forKey:@"SECOND_SUBITEMCATEGORY"];
        [formPost.postData setObject:self.coreTextField.text forKey:@"CORE"];
        [formPost.postData setObject:self.squareTextField.text forKey:@"SQAUREMM"];
        [formPost.postData setObject:self.colorTextField.text forKey:@"COLOR"];
        [formPost setModuleId: [DVAppDelegate currentModuleContext]];
        [formPost setDocId: @"UOMDESC_BY_WNC_CORE_SQAUREMM_COLOR"];
        [formPost setReportCacheRefresh:@"false"];
        
        loadingView = [LoadingView loadingViewInView:self.view];
        
        networkHelper = [[NetworkHelper alloc] init];
        [networkHelper makeXmwNetworkCall:formPost :self : nil :  @"FOR_SEARCH_IGNORE_SESSION"];
        
    }

}
-(UIView*) coreDropDown
{
    UIView *coreDropDown=[[UIView alloc]initWithFrame:CGRectMake(16, 0, self.view.frame.size.width-32, 40)];
    coreDropDown.backgroundColor = [UIColor clearColor];
    coreTextField= [[MXTextField alloc]initWithFrame:CGRectMake(0, 0, coreDropDown.bounds.size.width, coreDropDown.bounds.size.height)];
    
    coreTextField.userInteractionEnabled = NO;
    coreTextField.borderStyle = UITextBorderStyleRoundedRect;
    coreTextField.returnKeyType = UIReturnKeyDefault;
    coreTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    coreTextField.adjustsFontSizeToFitWidth = TRUE;
    coreTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    coreTextField.minimumFontSize = 10;
    coreTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    coreTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    coreTextField.font = [UIFont systemFontOfSize:14.0];
    coreTextField.placeholder= @"Select Core";
    coreTextField.textColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
    coreTextField.font = [UIFont fontWithName:@"Helvetica-Light" size:16.0];
    
    UIImage *dropImage = [UIImage imageNamed:@"downarrow_right_arrow.png"];
    UIImageView *buttonIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    buttonIcon.contentMode = UIViewContentModeCenter;
    [buttonIcon setImage:dropImage];
    
    //set textfield border
    coreTextField.layer.masksToBounds=YES;
    coreTextField.layer.cornerRadius = 5.0f;
    coreTextField.layer.borderColor= [[UIColor lightGrayColor]CGColor];
    coreTextField.layer.borderWidth= 1.0f;
    [coreTextField setRightView:buttonIcon];
    [coreTextField setRightViewMode:UITextFieldViewModeAlways];
    
    
    coreButton = [[MXButton alloc]initWithFrame:CGRectMake(0, 0, coreDropDown.bounds.size.width, coreDropDown.bounds.size.height)];
    [coreButton addTarget:self action:@selector(extraDropDown:) forControlEvents:UIControlEventTouchUpInside];
    
    coreButton.elementId = @"CORE_Button";
    coreTextField.elementId = @"CORE";
    
    [componentMap setObject:coreTextField forKey:@"CORE"];
    
    
    //attach data
    
    NSArray *key = [[NSArray alloc]init];
    //  key = [[[NSUserDefaults standardUserDefaults]valueForKey:@"COLOR"]allKeys];
    key = @[@""];
    
    NSArray *value = [[NSArray alloc]init];
    //value =[[[NSUserDefaults standardUserDefaults]valueForKey:@"COLOR"]allValues];
    value = @[@""];
    
    NSMutableArray *attachDataArray = [[NSMutableArray alloc]init];
    [attachDataArray addObject:key];
    [attachDataArray addObject:value];
    
    coreButton.attachedData = attachDataArray;
    
    //network call for core
//    "PRY_ITEMCATEGORY": "WRE",
//    "PRY_SUBITEMCATEGORY": "COMPUTER CABLE",
//    "SECOND_ITEMCATEGORY": "COPPER",
//    "SECOND_SUBITEMCATEGORY": "FRLS"
    
    DotFormPost *formPost = [[DotFormPost alloc]init];
    [formPost.postData setObject:@"" forKey:DotSearchConst_SEARCH_TEXT];
    [formPost.postData setObject:@"SBN" forKey:DotSearchConst_SEARCH_BY];
    [formPost.postData setObject:billTo forKey:@"BILL_TO"];
    [formPost.postData setObject:shipTo forKey:@"SHIP_TO"];
    [formPost.postData setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedRegisterIDCode"] forKey:@"USERNAME"];
    [formPost.postData setObject:[catalogReqstData valueForKey:@"CUSTOMER_NUMBER"] forKey:@"BUSINESS_VERTICAL"];
    [formPost.postData setObject:[catalogReqstData valueForKey:@"PRY_ITEMCATEGORY"] forKey:@"PRY_ITEMCATEGORY"];
    [formPost.postData setObject:[catalogReqstData valueForKey:@"PRY_SUBITEMCATEGORY"] forKey:@"PRY_SUBITEMCATEGORY"];
    [formPost.postData setObject:[catalogReqstData valueForKey:@"SECOND_ITEMCATEGORY"] forKey:@"SECOND_ITEMCATEGORY"];
    [formPost.postData setObject:[catalogReqstData valueForKey:@"SECOND_SUBITEMCATEGORY"] forKey:@"SECOND_SUBITEMCATEGORY"];
    [formPost setModuleId: [DVAppDelegate currentModuleContext]];
    [formPost setDocId: @"CORES_BY_CAT_TREE"];
    [formPost setReportCacheRefresh:@"false"];
    

    loadingView = [LoadingView loadingViewInView:self.view];

    networkHelper = [[NetworkHelper alloc] init];
    [networkHelper makeXmwNetworkCall:formPost :self : nil :  @"FOR_SEARCH_IGNORE_SESSION"];
    
    
    [coreDropDown addSubview:coreButton];
    [coreDropDown addSubview:coreTextField];
    
    
    
    
    return coreDropDown;
}




-(UIView*) colorDropDown
{
    UIView *colorDropDown = [[UIView alloc]initWithFrame:CGRectMake(16, 0, self.view.frame.size.width-32, 40)];
    colorDropDown.backgroundColor = [UIColor clearColor];
    
    
    
    
    colorTextField= [[MXTextField alloc]initWithFrame:CGRectMake(0, 0, colorDropDown.bounds.size.width, colorDropDown.bounds.size.height)];
    
    colorTextField.userInteractionEnabled = NO;
    colorTextField.borderStyle = UITextBorderStyleRoundedRect;
    colorTextField.returnKeyType = UIReturnKeyDefault;
    colorTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    colorTextField.adjustsFontSizeToFitWidth = TRUE;
    colorTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    colorTextField.minimumFontSize = 10;
    colorTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    colorTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    colorTextField.font = [UIFont systemFontOfSize:14.0];
    colorTextField.placeholder= @"Select Color";
    
    colorTextField.textColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
    colorTextField.font = [UIFont fontWithName:@"Helvetica-Light" size:16.0];
    
    UIImage *dropImage = [UIImage imageNamed:@"downarrow_right_arrow.png"];
    UIImageView *buttonIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    buttonIcon.contentMode = UIViewContentModeCenter;
    [buttonIcon setImage:dropImage];
    
    
    //set textfield border
    colorTextField.layer.masksToBounds=YES;
    colorTextField.layer.cornerRadius = 5.0f;
    colorTextField.layer.borderColor= [[UIColor lightGrayColor]CGColor];
    colorTextField.layer.borderWidth= 1.0f;
    [colorTextField setRightView:buttonIcon];
    [colorTextField setRightViewMode:UITextFieldViewModeAlways];
    
    colorButton = [[MXButton alloc]initWithFrame:CGRectMake(0, 0, colorDropDown.bounds.size.width, colorDropDown.bounds.size.height)];
    [colorButton addTarget:self action:@selector(extraDropDown:) forControlEvents:UIControlEventTouchUpInside];
    colorButton.backgroundColor= [UIColor clearColor];
    colorButton.elementId = @"COLOR_Button";
    colorTextField.elementId = @"COLOR";
    
    //attach data
    
    NSArray *key = [[NSArray alloc]init];
    //  key = [[[NSUserDefaults standardUserDefaults]valueForKey:@"COLOR"]allKeys];
    key = @[@""];
    
    NSArray *value = [[NSArray alloc]init];
    //value =[[[NSUserDefaults standardUserDefaults]valueForKey:@"COLOR"]allValues];
    value = @[@""];
    NSMutableArray *attachDataArray = [[NSMutableArray alloc]init];
    [attachDataArray addObject:key];
    [attachDataArray addObject:value];
    
    colorButton.attachedData = attachDataArray;
    
    [componentMap setObject:colorTextField forKey:@"COLOR"];
    
    [colorDropDown addSubview:colorButton];
    [colorDropDown addSubview:colorTextField];
    
    
    return colorDropDown;
}
-(UIView*) squareMMDropDown
{
    UIView *squareMMDropDown =[[UIView alloc]initWithFrame:CGRectMake(16, 0, self.view.frame.size.width-32, 40)];
    squareMMDropDown.backgroundColor = [UIColor clearColor];
    
    squareTextField= [[MXTextField alloc]initWithFrame:CGRectMake(0, 0, squareMMDropDown.bounds.size.width, squareMMDropDown.bounds.size.height)];
    
    squareTextField.userInteractionEnabled = NO;
    squareTextField.borderStyle = UITextBorderStyleRoundedRect;
    squareTextField.returnKeyType = UIReturnKeyDefault;
    squareTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    squareTextField.adjustsFontSizeToFitWidth = TRUE;
    squareTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    squareTextField.minimumFontSize = 10;
    squareTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    squareTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    squareTextField.font = [UIFont systemFontOfSize:14.0];
    squareTextField.placeholder= @"Select Square";
    
    
    squareTextField.textColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
    squareTextField.font = [UIFont fontWithName:@"Helvetica-Light" size:16.0];
    
    UIImage *dropImage = [UIImage imageNamed:@"downarrow_right_arrow.png"];
    UIImageView *buttonIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    buttonIcon.contentMode = UIViewContentModeCenter;
    [buttonIcon setImage:dropImage];
    
    
    //set textfield border
    squareTextField.layer.masksToBounds=YES;
    squareTextField.layer.cornerRadius = 5.0f;
    squareTextField.layer.borderColor= [[UIColor lightGrayColor]CGColor];
    squareTextField.layer.borderWidth= 1.0f;
    [squareTextField setRightView:buttonIcon];
    [squareTextField setRightViewMode:UITextFieldViewModeAlways];
    
    
    squareButton = [[MXButton alloc]initWithFrame:CGRectMake(0, 0, squareMMDropDown.bounds.size.width, squareMMDropDown.bounds.size.height)];
    [squareButton addTarget:self action:@selector(extraDropDown:) forControlEvents:UIControlEventTouchUpInside];
    squareButton.elementId = @"SQAUREMM_Button";
    squareTextField.elementId = @"SQAUREMM";
    
    
    //attach data
    
    NSArray *key = [[NSArray alloc]init];
    // key = [[[NSUserDefaults standardUserDefaults]valueForKey:@"SQAUREMM"]allKeys];
    key = @[@""];
    NSArray *value = [[NSArray alloc]init];
    //value =[[[NSUserDefaults standardUserDefaults]valueForKey:@"SQAUREMM"]allValues];
    value = @[@""];
    NSMutableArray *attachDataArray = [[NSMutableArray alloc]init];
    [attachDataArray addObject:key];
    [attachDataArray addObject:value];
    
    squareButton.attachedData = attachDataArray;
    
    
    
    [componentMap setObject:squareTextField forKey:@"SQAUREMM"];
    [squareMMDropDown addSubview:squareButton];
    [squareMMDropDown addSubview:squareTextField];
    
    
    
    
    
    return squareMMDropDown;
}
-(UIView*) uomDescriptionDropDown
{
    UIView *uomDescriptionDropDown=[[UIView alloc]initWithFrame:CGRectMake(16, 0, self.view.frame.size.width-32, 40)];
    uomDescriptionDropDown.backgroundColor = [UIColor clearColor];
    
    
    uomDescriptionTextField= [[MXTextField alloc]initWithFrame:CGRectMake(0, 0, uomDescriptionDropDown.bounds.size.width, uomDescriptionDropDown.bounds.size.height)];
    
    uomDescriptionTextField.userInteractionEnabled = NO;
    uomDescriptionTextField.borderStyle = UITextBorderStyleRoundedRect;
    uomDescriptionTextField.returnKeyType = UIReturnKeyDefault;
    uomDescriptionTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    uomDescriptionTextField.adjustsFontSizeToFitWidth = TRUE;
    uomDescriptionTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    uomDescriptionTextField.minimumFontSize = 10;
    uomDescriptionTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    uomDescriptionTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    uomDescriptionTextField.font = [UIFont systemFontOfSize:14.0];
    uomDescriptionTextField.placeholder= @"Select UOM Description";
    
    uomDescriptionTextField.textColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
    uomDescriptionTextField.font = [UIFont fontWithName:@"Helvetica-Light" size:16.0];
    
    UIImage *dropImage = [UIImage imageNamed:@"downarrow_right_arrow.png"];
    UIImageView *buttonIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    buttonIcon.contentMode = UIViewContentModeCenter;
    [buttonIcon setImage:dropImage];
    
    
    //set textfield border
    uomDescriptionTextField.layer.masksToBounds=YES;
    uomDescriptionTextField.layer.cornerRadius = 5.0f;
    uomDescriptionTextField.layer.borderColor= [[UIColor lightGrayColor]CGColor];
    uomDescriptionTextField.layer.borderWidth= 1.0f;
    [uomDescriptionTextField setRightView:buttonIcon];
    [uomDescriptionTextField setRightViewMode:UITextFieldViewModeAlways];
    uomDescriptionButton = [[MXButton alloc]initWithFrame:CGRectMake(0, 0, uomDescriptionDropDown.bounds.size.width, uomDescriptionDropDown.bounds.size.height)];
    [uomDescriptionButton addTarget:self action:@selector(extraDropDown:) forControlEvents:UIControlEventTouchUpInside];
    
    uomDescriptionButton.elementId = @"UOMDESC_Button";
    uomDescriptionTextField.elementId = @"UOMDESC";
    
    
    //attach data
    
    NSArray *key = [[NSArray alloc]init];
    //key = [[[NSUserDefaults standardUserDefaults]valueForKey:@"UOMDESC"]allKeys];
    key = @[@""];
    NSArray *value = [[NSArray alloc]init];
    // value =[[[NSUserDefaults standardUserDefaults]valueForKey:@"UOMDESC"]allValues];
    value = @[@""];
    NSMutableArray *attachDataArray = [[NSMutableArray alloc]init];
    [attachDataArray addObject:key];
    [attachDataArray addObject:value];
    
    uomDescriptionButton.attachedData = attachDataArray;
    
    
    [componentMap setObject:uomDescriptionTextField forKey:@"UOMDESC"];
    [uomDescriptionDropDown addSubview:uomDescriptionButton];
    [uomDescriptionDropDown addSubview:uomDescriptionTextField];
    
    
    
    return uomDescriptionDropDown;
}
-(UIButton*) addSearchButton
{
    UIImage *blueImage          = [UIImage imageNamed:@"blueButton.png"];
    UIImage *blueButtonImage    = [blueImage stretchableImageWithLeftCapWidth:8 topCapHeight:0];
    
    
    UIButton *searchButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [searchButton setFrame:CGRectMake(16, 0,self.view.frame.size.width-32, 36)];
    
    [searchButton setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
    
    [searchButton setTitleColor:[Styles buttonTextColor] forState: UIControlStateNormal];
    
    [searchButton setTitle:@"Search" forState:UIControlStateNormal];
    
    [searchButton addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    return searchButton;
}
-(void) httpResponseObjectHandler:(NSString *)callName :(id)respondedObject :(id)requestedObject
{
      [loadingView removeFromSuperview];
    
    if([callName isEqualToString:@"GET_CATEGORY_FROM_CATALOG"]) {
      
        [self handleCatalogResults:respondedObject];
        
    }
    else if([callName isEqualToString:@"GET_PRODUCTS"]) {
       
        
        [self handleCategoryProducts:respondedObject];
        
    }
    else if([callName isEqualToString:XmwcsConst_CALL_NAME_FOR_SEARCH]) {
       
        [self handleSearchResult:respondedObject];
    }
    else if ([callName isEqualToString:@"FOR_SEARCH_IGNORE_SESSION"])
    {

        [self core_color_square_umo:respondedObject docID:[requestedObject docId]];
        
        
    }
    
}
- (void)core_color_square_umo:(id)jsonresponse docID:(NSString*)ID
{
    
  
    if ([ID isEqualToString:@"CORES_BY_CAT_TREE"]) {
     
        SearchResponse* searchResponse  = (SearchResponse*)jsonresponse;
        NSMutableArray *data  = [[NSMutableArray alloc]init];
        [data addObjectsFromArray:[searchResponse searchRecord]];
        
        NSMutableArray *key = [[NSMutableArray alloc]init];
        NSMutableArray *value = [[NSMutableArray alloc]init];
        
        
        for (int i=0; i<data.count; i++) {
            [key addObject:[[data objectAtIndex:i]objectAtIndex:0]];
            [value addObject:[[data objectAtIndex:i]objectAtIndex:0]];
        }
        NSMutableArray *attachDataArray = [[NSMutableArray alloc]init];
        [key removeObjectIdenticalTo:[NSNull null]];
        [value removeObjectIdenticalTo:[NSNull null]];
        [attachDataArray addObject:key];
        [attachDataArray addObject:value];
        coreButton.attachedData = attachDataArray;
    }
    
    
    if ([ID isEqualToString:@"COLORS_BY_WNC_CORE_SQAUREMM"]) {
     
        SearchResponse* searchResponse  = (SearchResponse*)jsonresponse;
        NSMutableArray *data  = [[NSMutableArray alloc]init];
        [data addObjectsFromArray:[searchResponse searchRecord]];
        
        NSMutableArray *key = [[NSMutableArray alloc]init];
        NSMutableArray *value = [[NSMutableArray alloc]init];
        for (int i=0; i<data.count; i++) {
            [key addObject:[[data objectAtIndex:i]objectAtIndex:0]];
            [value addObject:[[data objectAtIndex:i]objectAtIndex:0]];
        }
        NSMutableArray *attachDataArray = [[NSMutableArray alloc]init];
        [key removeObjectIdenticalTo:[NSNull null]];
        [value removeObjectIdenticalTo:[NSNull null]];
        [attachDataArray addObject:key];
        [attachDataArray addObject:value];
        colorButton.attachedData = attachDataArray;
    }
    if ([ID isEqualToString:@"SQAUREMM_BY_WNC_CORE"]) {
       
        SearchResponse* searchResponse  = (SearchResponse*)jsonresponse;
        NSMutableArray *data  = [[NSMutableArray alloc]init];
        [data addObjectsFromArray:[searchResponse searchRecord]];
        
        NSMutableArray *key = [[NSMutableArray alloc]init];
        NSMutableArray *value = [[NSMutableArray alloc]init];
        for (int i=0; i<data.count; i++) {
            [key addObject:[[data objectAtIndex:i]objectAtIndex:0]];
            [value addObject:[[data objectAtIndex:i]objectAtIndex:0]];
        }
        NSMutableArray *attachDataArray = [[NSMutableArray alloc]init];
        [key removeObjectIdenticalTo:[NSNull null]];
        [value removeObjectIdenticalTo:[NSNull null]];
        [attachDataArray addObject:key];
        [attachDataArray addObject:value];
        squareButton.attachedData = attachDataArray;
    }
    
    if ([ID isEqualToString:@"UOMDESC_BY_WNC_CORE_SQAUREMM_COLOR"]) {
      
        SearchResponse* searchResponse  = (SearchResponse*)jsonresponse;
        NSMutableArray *data  = [[NSMutableArray alloc]init];
        [data addObjectsFromArray:[searchResponse searchRecord]];
        
        NSMutableArray *key = [[NSMutableArray alloc]init];
        NSMutableArray *value = [[NSMutableArray alloc]init];
        for (int i=0; i<data.count; i++) {
            [key addObject:[[data objectAtIndex:i]objectAtIndex:0]];
            [value addObject:[[data objectAtIndex:i]objectAtIndex:0]];
        }
        NSMutableArray *attachDataArray = [[NSMutableArray alloc]init];
        [key removeObjectIdenticalTo:[NSNull null]];
        [value removeObjectIdenticalTo:[NSNull null]];
        [attachDataArray addObject:key];
        [attachDataArray addObject:value];
        uomDescriptionButton.attachedData = attachDataArray;
    }
    
      if ([ID isEqualToString:@"MATERIAL_LOB_TREE_JDBC"]) {
     
        
          [self handleSearchResult:jsonresponse];
                
      }
}
-(void) handleSearchResult:(id) xmwResponse
{
    
    SearchResponse *searchResponse = (SearchResponse*)xmwResponse;
    
    PolycabSearchViewController* searchVC = [[PolycabSearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [viewControllers replaceObjectAtIndex:([viewControllers count]-1) withObject:searchVC];
  
   
    searchVC.screenId = XmwcsConst_SCREEN_ID_SEARCH_RESULT;
    searchVC.searchResponse = searchResponse;
    
    searchVC.elementId = elementId;
    searchVC.masterValueMapping = inMasterValueMapping;
    searchVC.parentController = [viewControllers objectAtIndex:2];
    searchVC.multiSelect = YES;
    searchVC.multiSelectDelegate = [viewControllers objectAtIndex:2];
    searchVC.headerTitle = @"Product Search Results";
    searchVC.primaryCat = primarayCat;
    searchVC.subCat = subCat;
    [self.navigationController setViewControllers:viewControllers animated:YES ];
    

    
    
   
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
       if(indexPath.row==0) {
            
            
            // add search button here
            cell = [tableView dequeueReusableCellWithIdentifier:@"coreDropDown"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(cell==nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"coreDropDown"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.contentView addSubview:[self coreDropDown]];
                cell.tag = 500;
            }
        }
        else if(indexPath.row==1) {
            // add search button here
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"squareMMDropDown"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(cell==nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"squareMMDropDown"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.contentView addSubview:[self squareMMDropDown]];
                cell.tag = 501;
            }
        }
        else if(indexPath.row==2) {
            // add search button here
            
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"colorDropDown"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(cell==nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"colorDropDown"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.contentView addSubview:[self colorDropDown]];
                cell.tag = 502;
            }
            
            
        }
        else if(indexPath.row==3) {
            // add search button here
            cell = [tableView dequeueReusableCellWithIdentifier:@"uomDescriptionDropDown"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(cell==nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"uomDescriptionDropDown"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.contentView addSubview:[self uomDescriptionDropDown]];
                cell.tag = 503;
            }
        }
        
        
        else if(indexPath.row==4) {
            // add search button here
            cell = [tableView dequeueReusableCellWithIdentifier:@"searchButton"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(cell==nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"searchButton"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.contentView addSubview:[self addSearchButton]];
            }
        }

    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     if(indexPath.row==0) {
        return 44.0f;
    }
    else if(indexPath.row==1) {
        return 44.0f;
    }
    else if(indexPath.row==2) {
        return 44.0f;
    }
    else if(indexPath.row==3) {
        return 44.0f;
    }
    else if(indexPath.row==4) {
        return 44.0f;
    }
    
    else
       return 0.0f;
}
- (void) buttonEvent : (id) sender
{
    
    MXButton *button = (MXButton*) sender;
    button.userInteractionEnabled = NO;// this code for resolve button crashes due to next screen load delay handlling
    
    DotFormPost *formPost = [[DotFormPost alloc]init];
    [formPost.postData setObject:@"" forKey:DotSearchConst_SEARCH_TEXT];
    [formPost.postData setObject:@"SBN" forKey:DotSearchConst_SEARCH_BY];
    
    if (self.coreTextField.text.length !=0) {
        
        [formPost.postData setObject:self.coreTextField.text forKey:@"CORE"];
    }
    
    if (self.colorTextField.text.length !=0){
        
        [formPost.postData setObject:self.colorTextField.text forKey:@"COLOR"];
        
    }
    
    if (self.squareTextField.text.length !=0){
        
        [formPost.postData setObject:self.squareTextField.text forKey:@"SQAUREMM"];
        
    }
    if (self.uomDescriptionTextField.text.length !=0){
        
        [formPost.postData setObject:self.uomDescriptionTextField.text forKey:@"UOMDESC"];
        
    }
    
    
    
    if(self.dependentValueMap!=nil) {
        NSArray* keys = [dependentValueMap allKeys];
        for(int i=0; i<[keys count]; i++) {
            NSString* key = [keys objectAtIndex:i];
            NSString* value = [dependentValueMap objectForKey:key];
            [formPost.postData setObject:value forKey:key];
        }
    }
    
    
    [formPost.postData setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedRegisterIDCode"] forKey:@"USERNAME"];
    [formPost setModuleId: [DVAppDelegate currentModuleContext]];
    [formPost setDocId: @"MATERIAL_LOB_TREE_JDBC"];
     [formPost.postData setObject:[catalogReqstData valueForKey:@"CUSTOMER_NUMBER"] forKey:@"BUSINESS_VERTICAL"];
     [formPost.postData setObject:billTo forKey:@"BILL_TO"];
     [formPost.postData setObject:shipTo forKey:@"SHIP_TO"];
    [formPost.postData setObject:[catalogReqstData valueForKey:@"PRIMARY_CATEGORY"] forKey:@"PRIMARY_CATEGORY"];
    [formPost.postData setObject:[catalogReqstData valueForKey:@"PRIMARY_SUBCATEGORY"] forKey:@"PRIMARY_SUBCATEGORY"];
    [formPost.postData setObject:[catalogReqstData valueForKey:@"SECONDARY_CATEGORY"] forKey:@"SECONDARY_CATEGORY"];
    [formPost.postData setObject:[catalogReqstData valueForKey:@"SECONDARY_SUBCATEGORY"] forKey:@"SECONDARY_SUBCATEGORY"];
    
 
    loadingView = [LoadingView loadingViewInView:self.view];
    
    networkHelper = [[NetworkHelper alloc] init];
    [networkHelper makeXmwNetworkCall:formPost :self : nil :  @"FOR_SEARCH_IGNORE_SESSION"];
    
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return nil;
}


@end
