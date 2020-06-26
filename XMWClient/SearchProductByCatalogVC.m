//
//  SearchProductByCatalogVC.m
//  XMWClient
//
//  Created by dotvikios on 17/08/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "SearchProductByCatalogVC.h"
#import "SearchProductByCatalogNextViewVC.h"
#import "ClientVariable.h"
#import "LoadingView.h"
#import "NetworkHelper.h"
#import "DVAppDelegate.h"
#define DotSearchConst_SEARCH_TEXT @"SEARCH_TEXT"
#define DotSearchConst_SEARCH_BY @"SEARCH_BY"
@interface SearchProductByCatalogVC ()

@end

@implementation SearchProductByCatalogVC
{
    NSString *searchButtonClickTag;
    NSArray* radioGroupData;
    NSString *item;
    NetworkHelper* networkHelper;
    LoadingView* loadingView;
    NSString *billTO;
    NSString *shipTO;
}
@synthesize itmeName;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parentForm:(FormVC *)parent formElement:(NSString *)formElementId elementData:(NSString *)masterValueMapping radioGroupData:(NSMutableArray *)keyValueDoubleArray :(NSString *)buttonSender :(NSString*)itemName :(NSString*)bill_To :(NSString*)ship_To{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self!=nil) {
        self.parentController = parent;
        self.elementId = formElementId;
        self.inMasterValueMapping = masterValueMapping;
        radioGroupData = keyValueDoubleArray;
        searchButtonClickTag = buttonSender;
        NSLog(@"Button Tag %@ ",searchButtonClickTag);
        billTO = bill_To;
        shipTO = ship_To;
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
-(void) fetchProductCatalogTree
{
    
    loadingView = [LoadingView loadingViewInView:self.view];
    
    NSMutableDictionary* catalogQuery = [[NSMutableDictionary alloc] init];
    
    if(self.productDivision!=nil) {
        
        [catalogQuery setObject:self.productDivision forKey:@"BUSINESS_VERTICAL"];
        [catalogQuery setObject:self.productDivision forKey:@"CUSTOMER_NUMBER"];
        [catalogQuery setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedRegisterIDCode"] forKey:@"USERNAME"];
        
        
        
        [catalogQuery setObject:billTO forKey:@"BILL_TO"];
        [catalogQuery setObject:shipTO forKey:@"SHIP_TO"];
        // sample division fan, 45
    } else {
        [catalogQuery setObject:@"" forKey:@"CATALOGID"];
    }
    
    
    networkHelper = [[NetworkHelper alloc] init];
    networkHelper.serviceURLString = XmwcsConst_PRODUCT_TREE_SERVICE_URL;
    [networkHelper makeXmwNetworkCall:catalogQuery :self :nil :@"GET_CATEGORY_FROM_CATALOG"];
    
}
- (void) backHandler : (id) sender {
    if(multiSelectDelegate !=nil && [multiSelectDelegate respondsToSelector:@selector(selectionCancelled)]) {
        [multiSelectDelegate selectionCancelled];
    }
    [ [self navigationController]  popViewControllerAnimated:YES];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if(indexPath.section==1) {
        // this section is for browsing product catalog
        cell = [self catTreeTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==1) {
        UIView* holderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        
        UILabel* browserSectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , 22)];
        browserSectionLabel.text = @"ADD FROM CATALOGUE";
        [browserSectionLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        browserSectionLabel.textAlignment = UITextAlignmentCenter;
        browserSectionLabel.backgroundColor = [UIColor whiteColor];
        
        NSLog(@"%@",itmeName);
        
        UILabel* itemValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 23, self.view.frame.size.width , 21)];
        itemValue.text = [[@"FOR"stringByAppendingString:@" "]stringByAppendingString:itmeName];
        [itemValue setFont:[UIFont fontWithName:@"Helvetica-Light" size:16]];
        itemValue.textColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
        itemValue.textAlignment = UITextAlignmentCenter;
        itemValue.backgroundColor = [UIColor whiteColor];
        
        
        [holderView addSubview:browserSectionLabel];
        [holderView addSubview:itemValue];
        
        return holderView;
    }
    return nil;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0) {
        // search section
        return 0;
        
    }
    else if(section==1) {
        // catalog tree section
        return [self.myCatTableDataArray count];
        
    }
    return 0;
    
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0) {
        // return 44.0f;
        return 0.0f;
    } else if(section==1) {
        return 44.0f;
    }
    return 0.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0) {
        return 0.0f;
    }
    
    else if(indexPath.section==1) {
        return 40.0f;
    }
    return 0.0f;
}

-(void) fetchProductsForCatalog:(PolycabProductCatObject *)category
{

    NSMutableDictionary* catalogQuery = [[NSMutableDictionary alloc] init];
    [catalogQuery setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedRegisterIDCode"] forKey:@"USERNAME"];
    [catalogQuery setObject:category.lobCode  forKey:@"BUSINESS_VERTICAL"];
    [catalogQuery setObject:self.productDivision forKey:@"CUSTOMER_NUMBER"];
    [catalogQuery setObject:category.primaryCategory forKey:@"PRY_ITEMCATEGORY"];
    [catalogQuery setObject:category.primarySubCategory forKey:@"PRY_SUBITEMCATEGORY"];
    [catalogQuery setObject:category.secondaryItemCategory forKey:@"SECOND_ITEMCATEGORY"];
    [catalogQuery setObject:category.secondaryItemSubCategory forKey:@"SECOND_SUBITEMCATEGORY"];
    
    if ([itemNameString isEqualToString:@"Cables"] || [itemNameString isEqualToString:@"Wires"] ||[itemNameString isEqualToString:@"PP & Flexibles"] )
    {
        SearchProductByCatalogNextViewVC *vc = [[SearchProductByCatalogNextViewVC alloc]init];
        //  [vc.catalogReqstData setDictionary:catalogQuery];
        vc.catalogReqstData = catalogQuery;
        vc.itemNameString = itemNameString;
        vc.billTo = billTO;
        vc.shipTo = shipTO;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        
        
        DotFormPost *formPost = [[DotFormPost alloc]init];
        [formPost.postData setObject:@"" forKey:DotSearchConst_SEARCH_TEXT];
        [formPost.postData setObject:@"SBN" forKey:DotSearchConst_SEARCH_BY];
        [formPost.postData setObject:billTO forKey:@"BILL_TO"];
        [formPost.postData setObject:shipTO forKey:@"SHIP_TO"];
        [formPost.postData setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedRegisterIDCode"] forKey:@"USERNAME"];
        //[formPost.postData setObject:category.lobCode  forKey:@"CUSTOMER_NUMBER"];
        [formPost.postData setObject:self.productDivision forKey:@"BUSINESS_VERTICAL"];
        [formPost.postData setObject:category.primaryCategory forKey:@"PRY_ITEMCATEGORY"];
        [formPost.postData setObject:category.primarySubCategory forKey:@"PRY_SUBITEMCATEGORY"];
        [formPost.postData setObject:category.secondaryItemCategory forKey:@"SECOND_ITEMCATEGORY"];
        [formPost.postData setObject:category.secondaryItemSubCategory forKey:@"SECOND_SUBITEMCATEGORY"];
        
        
        
        [formPost setModuleId: [DVAppDelegate currentModuleContext]];
        [formPost setDocId: @"MATERIAL_LOB_TREE_JDBC"];
        [formPost setReportCacheRefresh:@"true"];
        
        
        loadingView = [LoadingView loadingViewInView:self.view];
        
        networkHelper = [[NetworkHelper alloc] init];
        [networkHelper makeXmwNetworkCall:formPost :self : nil :  @"FOR_SEARCH_IGNORE_SESSION"];
        
        
//        loadingView = [LoadingView loadingViewInView:self.view];
//        networkHelper = [[NetworkHelper alloc] init];
//        networkHelper.serviceURLString = XmwcsConst_PRODUCT_TREE_SERVICE_URL;
//        [catalogQuery setObject:billTO forKey:@"SHIP_TO"];
//        [networkHelper makeXmwNetworkCall:catalogQuery :self :nil :@"FOR_SEARCH_IGNORE_SESSION"];
    }
    
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
    else if ([callName isEqualToString:@"FOR_SEARCH_IGNORE_SESSION"])
    {
        [self handleSearchResult:respondedObject];
    }
    else if([callName isEqualToString:XmwcsConst_CALL_NAME_FOR_SEARCH]) {
        
        [self handleSearchResult:respondedObject];
    }
    
}

@end
