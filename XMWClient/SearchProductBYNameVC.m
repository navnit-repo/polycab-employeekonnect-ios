//
//  SearchProductBYNameVC.m
//  XMWClient
//
//  Created by dotvikios on 17/08/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "SearchProductBYNameVC.h"
#import "Styles.h"
#import "DVAppDelegate.h"
#import "LoadingView.h"
#import "NetworkHelper.h"
#import "ClientVariable.h"
#import "SearchProductListVC.h"
#import "MXTextField.h"
#define DotSearchConst_SEARCH_TEXT @"SEARCH_TEXT"
#define DotSearchConst_SEARCH_BY @"SEARCH_BY"
@interface SearchProductBYNameVC ()

@end

@implementation SearchProductBYNameVC
{
    NSString *searchButtonClickTag;
    NSArray* radioGroupData;
    RadioGroup *radioGroup;
    NetworkHelper* networkHelper;
    LoadingView* loadingView;
    UITextField*  searchInputField;
    SearchProductListVC *searchProductListVC;
    NSMutableDictionary *componentMap;
    BOOL isOpenPicker;
    NSString *item;
    int count;
    NSString *billTo;
    NSString *shipTo;
}
@synthesize coreTextField,colorTextField,squareTextField,uomDescriptionTextField;
@synthesize coreButton,colorButton,squareButton,uomDescriptionButton;
@synthesize itemNameString;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parentForm:(FormVC *)parent formElement:(NSString *)formElementId elementData:(NSString *)masterValueMapping radioGroupData:(NSMutableArray *)keyValueDoubleArray :(NSString *)buttonSender :(NSString *)itemName :(NSString*)bill_To :(NSString*)ship_To{
    
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self!=nil) {
        self.parentController = parent;
        self.elementId = formElementId;
        self.inMasterValueMapping = masterValueMapping;
        radioGroupData = keyValueDoubleArray;
        searchButtonClickTag = buttonSender;
        NSLog(@"Button Tag %@ ",searchButtonClickTag);
        billTo = bill_To;
        shipTo = ship_To;
        
        item= itemName;
        
        
        itemNameString = nil;
        
        NSCharacterSet *numbersSet = [NSCharacterSet characterSetWithCharactersInString:@"-0123456789"];
        itemNameString = [item stringByTrimmingCharactersInSet:numbersSet];
        NSLog(@"%@",itemNameString);
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    // Do any additional setup after loading the view from its nib.
    componentMap =[[NSMutableDictionary alloc]init];
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage
                                                                          imageNamed:@"back-button.png"] style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(backHandler:)];
    
    backButton.tintColor = [UIColor whiteColor];
    
    UIImageView *polycabLogo = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"polycab_logo"]];
    self.navigationItem.titleView.contentMode = UIViewContentModeCenter;
    self.navigationItem.titleView = polycabLogo;
    [self.navigationItem setLeftBarButtonItem:backButton];
    
    
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.bounces = NO;
}

- (void) backHandler : (id) sender {
    if(multiSelectDelegate !=nil && [multiSelectDelegate respondsToSelector:@selector(selectionCancelled)]) {
        [multiSelectDelegate selectionCancelled];
    }
    [ [self navigationController]  popViewControllerAnimated:YES];
}

-(void) fetchProductCatalogTree
{
    // not requried
}
-(UITextField*) addSearchTextField
{
    searchInputField = [[UITextField alloc]initWithFrame:CGRectMake(20, 3, 280, 35)];
    searchInputField.placeholder = @"Search product";
    [searchInputField setBackgroundColor:[UIColor whiteColor]];
    searchInputField.borderStyle = UITextBorderStyleRoundedRect;
    [searchInputField setDelegate:self];
    return searchInputField;
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
        [formPost.postData setObject:searchInputField.text forKey:DotSearchConst_SEARCH_TEXT];
        [formPost.postData setObject:@"SBN" forKey:DotSearchConst_SEARCH_BY];
        [formPost.postData setObject:billTo forKey:@"BILL_TO"];
        [formPost.postData setObject:shipTo forKey:@"SHIP_TO"];
        [formPost.postData setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedRegisterIDCode"] forKey:@"USERNAME"];
        [formPost.postData setObject:self.productDivision forKey:@"BUSINESS_VERTICAL"];
        
        
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
        [formPost.postData setObject:searchInputField.text forKey:DotSearchConst_SEARCH_TEXT];
        [formPost.postData setObject:@"SBN" forKey:DotSearchConst_SEARCH_BY];
        [formPost.postData setObject:billTo forKey:@"BILL_TO"];
        [formPost.postData setObject:shipTo forKey:@"SHIP_TO"];
        [formPost.postData setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedRegisterIDCode"] forKey:@"USERNAME"];
        [formPost.postData setObject:self.productDivision forKey:@"BUSINESS_VERTICAL"];
        
        
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
        [formPost.postData setObject:searchInputField.text forKey:DotSearchConst_SEARCH_TEXT];
        [formPost.postData setObject:@"SBN" forKey:DotSearchConst_SEARCH_BY];
        [formPost.postData setObject:billTo forKey:@"BILL_TO"];
        [formPost.postData setObject:shipTo forKey:@"SHIP_TO"];
        [formPost.postData setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedRegisterIDCode"] forKey:@"USERNAME"];
        [formPost.postData setObject:self.productDivision forKey:@"BUSINESS_VERTICAL"];
        
        
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
    
    DotFormPost *formPost = [[DotFormPost alloc]init];
    [formPost.postData setObject:searchInputField.text forKey:DotSearchConst_SEARCH_TEXT];
    [formPost.postData setObject:@"SBN" forKey:DotSearchConst_SEARCH_BY];
    [formPost.postData setObject:billTo forKey:@"BILL_TO"];
    [formPost.postData setObject:shipTo forKey:@"SHIP_TO"];
    [formPost.postData setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedRegisterIDCode"] forKey:@"USERNAME"];
    [formPost.postData setObject:self.productDivision forKey:@"BUSINESS_VERTICAL"];
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
-(void) httpResponseObjectHandler:(NSString *)callName :(id)respondedObject :(id)requestedObject
{
    [loadingView removeFromSuperview];
    if([callName isEqualToString:@"GET_CATEGORY_FROM_CATALOG"]) {
        
        [self handleCatalogResults:respondedObject];
        
    }
    else if([callName isEqualToString:@"GET_PRODUCTS"]) {
        
        
        [self handleCategoryProducts:respondedObject];
        
    } else if([callName isEqualToString:XmwcsConst_CALL_NAME_FOR_SEARCH]) {
        
        [self handleSearchResult:respondedObject];
    }
    else if ([callName isEqualToString:@"FOR_SEARCH_IGNORE_SESSION"])
    {
        [self core_color_square_umo:respondedObject docID:[requestedObject docId]];
        // [self core_color_square_umo:respondedObject];
        
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
}
-(RadioGroup*) addRadioGroup
{
    radioGroup = [[RadioGroup alloc]initWithFrame: CGRectMake(20, 0 , 300, [radioGroupData[1] count]*40) : radioGroupData[1] :self.defaultSelectionRadio :radioGroupData[0]];
    
    return radioGroup;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([itemNameString isEqualToString:@"Cables"] || [itemNameString isEqualToString:@"Wires"] ||[itemNameString isEqualToString:@"PP & Flexibles"] )
    {
        count= 7;
    }
    
    else{
        
        count= 3;
    }
    
    return count;
    
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    if (count ==7 ) {
        // this section is for search control
        if(indexPath.row==0) {
            // add search text field here
            cell = [tableView dequeueReusableCellWithIdentifier:@"textField"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(cell==nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"textField"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.contentView addSubview:[self addSearchTextField]];
                
            }
        }
        
        else if(indexPath.row==1) {
            // add radio group here
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"radioGroup"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(cell==nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"radioGroup"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.contentView addSubview:[self addRadioGroup]];
            }
        }
        
        
        
        else if(indexPath.row==2) {
            
            
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
        else if(indexPath.row==3) {
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
        else if(indexPath.row==4) {
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
        else if(indexPath.row==5) {
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
        
        
        else if(indexPath.row==6) {
            // add search button here
            cell = [tableView dequeueReusableCellWithIdentifier:@"searchButton"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(cell==nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"searchButton"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.contentView addSubview:[self addSearchButton]];
            }
        }
    }
    
    
    
    
    if(count ==3) {
        
        if(indexPath.row==0) {
            // add search text field here
            cell = [tableView dequeueReusableCellWithIdentifier:@"textField"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(cell==nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"textField"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.contentView addSubview:[self addSearchTextField]];
                
            }
        }
        
        else if(indexPath.row==1) {
            // add radio group here
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"radioGroup"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(cell==nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"radioGroup"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.contentView addSubview:[self addRadioGroup]];
            }
        }
        
        else if(indexPath.row==2) {
            // add search button here
            cell = [tableView dequeueReusableCellWithIdentifier:@"searchButton"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(cell==nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"searchButton"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.contentView addSubview:[self addSearchButton]];
            }
        }
    }
    
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row==0) {
        return 44.0f;
    } else if(indexPath.row==1) {
        return [radioGroupData[1] count]*44;
    } else if(indexPath.row==2) {
        return 44.0f;
    }
    
    else if(indexPath.row==3) {
        return 44.0f;
    }
    else if(indexPath.row==4) {
        return 44.0f;
    }
    else if(indexPath.row==5) {
        return 44.0f;
    }
    else if(indexPath.row==6) {
        return 44.0f;
    }
    
    
    return 0.0f;
}
- (void) buttonEvent : (id) sender
{
    DotFormPost *formPost = [[DotFormPost alloc]init];
    [formPost.postData setObject:searchInputField.text forKey:DotSearchConst_SEARCH_TEXT];
    [formPost.postData setObject:radioGroup.selectedKey forKey:DotSearchConst_SEARCH_BY];
    
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
    [formPost.postData setObject:billTo forKey:@"BILL_TO"];
    [formPost.postData setObject:shipTo forKey:@"SHIP_TO"];
    [formPost.postData setObject:self.productDivision forKey:@"BUSINESS_VERTICAL"];
    [formPost setModuleId: [DVAppDelegate currentModuleContext]];
    [formPost setDocId: @"MATERIAL_LOB_JDBC"];
    loadingView = [LoadingView loadingViewInView:self.view];
    
    networkHelper = [[NetworkHelper alloc] init];
    [networkHelper makeXmwNetworkCall:formPost :self : nil :  XmwcsConst_CALL_NAME_FOR_SEARCH];
    
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [searchInputField resignFirstResponder];
    
    return YES;
}


@end
