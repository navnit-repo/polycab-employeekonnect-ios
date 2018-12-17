//
//  ProductSearchVC.m
//  QCMSProject
//
//  Created by Pradeep Singh on 3/23/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import "ProductSearchVC.h"
#import "SearchResponse.h"
#import "SearchViewController.h"
#import "XmwcsConstant.h"
#import "LoadingView.h"
#import "Styles.h"
#import "ClientVariable.h"
#import "DVAppDelegate.h"
#import "ProductCatObject.h"
#import "CategoryResponse.h"
#import "ProductResponse.h"
#import "PolycabProductCatObject.h"
#import "CreateOrderVC2.h"

#define DotSearchConst_SEARCH_TEXT @"SEARCH_TEXT"
#define DotSearchConst_SEARCH_BY @"SEARCH_BY"


@protocol ProductCatTreeTblViewDelegate <NSObject>

@required
- (NSArray *)getAllProductCategoriesDataWithSender:(id)sender; // return complete model Array

@optional
- (void)didSelectProductCategory:(ProductCatObject *)category
       withCategoryPathString:(NSString *)categoryPathString
                       sender:(id)sender;
- (void)didExpandProductCategory:(ProductCatObject *)category sender:(id)sender;
- (void)didCollapseProductCategory:(ProductCatObject *)category sender:(id)sender;

@end



@interface ProductSearchVC () <ProductCatTreeTblViewDelegate>
{
    NetworkHelper* networkHelper;
    LoadingView* loadingView;
    UITextField*  searchInputField;
    RadioGroup *radioGroup;
    NSArray* radioGroupData;
   
}
 
@property (nonatomic, weak) id<ProductCatTreeTblViewDelegate> myDelegate;
@property (nonatomic, strong) NSArray *myCatInputData;
@property (nonatomic, strong) NSMutableArray *categoryPathStringArr;
@property (nonatomic) ProductCatObject *lastSelectedObject;


@property (nonatomic, strong) NSArray* serverCatalogCategoryTree;

@end

@implementation ProductSearchVC
{
    NSString *searchButtonClickTag;
    NSString *primarayCat;
    NSString *subCat;
}
@synthesize parentController;
@synthesize elementId;
@synthesize inMasterValueMapping;
@synthesize searchTitleDisplayText;
@synthesize multiSelect;
@synthesize multiSelectDelegate;
@synthesize dependentValueMap;
@synthesize defaultSelectionRadio;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parentForm:(FormVC *)parent formElement:(NSString *)formElementId elementData:(NSString *)masterValueMapping radioGroupData:(NSMutableArray *)keyValueDoubleArray{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self!=nil) {
        self.parentController = parent;
        self.elementId = formElementId;
        self.inMasterValueMapping = masterValueMapping;
        radioGroupData = keyValueDoubleArray;
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.myDelegate = self;
    
    
    [self fetchProductCatalogTree];
    
    
   // [self fetchProductsForCatalog:@"49B8A6B0F561005EE1008000C009017B" ofCategory:@"4AB4D8F2821D008CE1008000C009017B"];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) fetchProductCatalogTree
{
    
    loadingView = [LoadingView loadingViewInView:self.view];
    
    NSMutableDictionary* catalogQuery = [[NSMutableDictionary alloc] init];
    
    if(self.productDivision!=nil) {
        
        [catalogQuery setObject:self.productDivision forKey:@"BUSINESS_VERTICAL"];
        [catalogQuery setObject:self.productDivision forKey:@"CUSTOMER_NUMBER"];
        [catalogQuery setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"REGISTRY_ID"]  forKey:@"USERNAME"]; //for employee changes

    //    [catalogQuery setObject:[ClientVariable getInstance].CLIENT_USER_LOGIN.userName forKey:@"USERNAME"];
        
        // sample division fan, 45
    } else {
        [catalogQuery setObject:@"" forKey:@"CATALOGID"];
    }
    
    
    networkHelper = [[NetworkHelper alloc] init];
    networkHelper.serviceURLString = XmwcsConst_PRODUCT_TREE_SERVICE_URL;
    [networkHelper makeXmwNetworkCall:catalogQuery :self :nil :@"GET_CATEGORY_FROM_CATALOG"];
    
}

-(void) fetchProductsForCatalog:(PolycabProductCatObject *)category
{
    
    loadingView = [LoadingView loadingViewInView:self.view];
    
    
    NSMutableDictionary* catalogQuery = [[NSMutableDictionary alloc] init];
   // [catalogQuery setObject:[ClientVariable getInstance].CLIENT_USER_LOGIN.userName forKey:@"USERNAME"];
    [catalogQuery setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"REGISTRY_ID"]  forKey:@"USERNAME"]; //for employee changes
    [catalogQuery setObject:category.lobCode  forKey:@"BUSINESS_VERTICAL"];
    [catalogQuery setObject:self.productDivision forKey:@"CUSTOMER_NUMBER"];
    [catalogQuery setObject:category.primaryCategory forKey:@"PRIMARY_CATEGORY"];
     [catalogQuery setObject:category.primarySubCategory forKey:@"PRIMARY_SUBCATEGORY"];
     [catalogQuery setObject:category.secondaryItemCategory forKey:@"secondaryItemCategory"];
     [catalogQuery setObject:category.secondaryItemSubCategory forKey:@"secondaryItemSubCategory"];
    
    
    networkHelper = [[NetworkHelper alloc] init];
    networkHelper.serviceURLString = XmwcsConst_PRODUCT_TREE_SERVICE_URL;
    [networkHelper makeXmwNetworkCall:catalogQuery :self :nil :@"GET_PRODUCTS"];

}

#pragma mark - NetworkHelper delegate

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
    
}


-(void) httpFailureHandler:(NSString *)callName :(NSString *)message
{
    [loadingView removeFromSuperview];
    
    
}

-(void) handleCatalogResults:(id) xmwResponse
{
    CategoryResponse* catalogCategories = (CategoryResponse*) xmwResponse;
    
    self.serverCatalogCategoryTree = catalogCategories.categoryList;
    
    self.categoryPathStringArr = nil;
    self.categoryPathStringArr = [[NSMutableArray alloc] init];
    self.myCatInputData = nil; // so it will fetch Data again see myInputData function
    self.myCatTableDataArray = nil;
    
    [self.mainTableView reloadData];
    
}


-(void) handleCategoryProducts:(id) xmwResponse
{
    ProductResponse* categoryProducts = (ProductResponse*)xmwResponse;
    
    SearchResponse* searchResponse  = [self adaptorProductToSearch:categoryProducts];
    
    
    [self handleSearchResult:searchResponse];
}

-(SearchResponse*) adaptorProductToSearch:(ProductResponse*) categoryProducts
{
 

    
    SearchResponse* searchResult = [[SearchResponse alloc] init];
    searchResult.searchMessage = nil;
    searchResult.searchDataForSubmit = @"ITEMNO";
    searchResult.searchHeaderDetail = [[NSMutableArray alloc] initWithObjects:@"ITEMNO:SKU Code", @"SHORTDESC:Desc", @"INVENTORYITEMID: Inventory Id",@"UOM:Unit",@"COLOR:Color",@"CORE:Core",@"SQUAREMM:Square MM",@"VOLTAGE:Voltage", nil];
    
    searchResult.searchDataForDisplay =  [[NSMutableArray alloc] initWithObjects:searchResult.searchHeaderDetail,@"SHORTDESC", @"UOM", nil];
    
    searchResult.searchRecord = [[NSMutableArray alloc] init];
    
    for(id prodObj in categoryProducts.productList) {
        
        NSMutableArray* searchRec = [[NSMutableArray alloc] initWithObjects:[prodObj objectForKey:@"itemNo"],
        [prodObj objectForKey:@"shortDesc"], [prodObj objectForKey:@"inventoryItemId"],[prodObj objectForKey:@"uom"],[prodObj objectForKey:@"color"],[prodObj objectForKey:@"core"],[prodObj objectForKey:@"squaremm"],[prodObj objectForKey:@"voltage"], [prodObj objectForKey:@"price"],nil];
        
        
        
        [searchResult.searchRecord addObject:searchRec];
    }
    
    return searchResult;
}



-(void) handleSearchResult:(id) xmwResponse
{
    SearchResponse *searchResponse = (SearchResponse*)xmwResponse;
    
    SearchViewController* searchVC = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    searchVC.screenId = XmwcsConst_SCREEN_ID_SEARCH_RESULT;
    searchVC.searchResponse = searchResponse;
    
    searchVC.elementId = elementId;
    searchVC.masterValueMapping = inMasterValueMapping;
    searchVC.parentController = parentController;
    searchVC.multiSelect = self.multiSelect;
    searchVC.multiSelectDelegate = self.multiSelectDelegate;
    searchVC.headerTitle = @"Product Search Results";
    searchVC.primaryCat = primarayCat;
    searchVC.subCat = subCat;
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [viewControllers replaceObjectAtIndex:([viewControllers count]-1) withObject:searchVC];
    [self.navigationController setViewControllers:viewControllers animated:YES ];
    
}



#pragma mark -  UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0) {
        // search section
        return 3;
        
    } else if(section==1) {
        // catalog tree section
        return [self.myCatTableDataArray count];
        
    }
    return 0;
}

#pragma  mark - UITableViewDelegate

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==0) {
        UIView* holderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        
        UILabel* searchSectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.frame.size.width , 40)];
        searchSectionLabel.text = @"Search Products";
        searchSectionLabel.backgroundColor = [UIColor whiteColor];
        [holderView addSubview:searchSectionLabel];
        
        
       // return holderView;
        return nil;
    } else if(section==1) {
        UIView* holderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        
        UILabel* browserSectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.frame.size.width , 44)];
        browserSectionLabel.text = @"Browser Catalog";
        browserSectionLabel.backgroundColor = [UIColor whiteColor];
        [holderView addSubview:browserSectionLabel];
    
        return holderView;
    }
    return nil;
}

     
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
  
    if(indexPath.section==0) {
        
        // this section is for search control
        if(indexPath.row==0) {
            // add search text field here
            cell = [tableView dequeueReusableCellWithIdentifier:@"textField"];
            if(cell==nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"textField"];
                [cell.contentView addSubview:[self addSearchTextField]];
            }
        } else if(indexPath.row==1) {
            // add radio group here
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"radioGroup"];
            if(cell==nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"radioGroup"];
                [cell.contentView addSubview:[self addRadioGroup]];
            }
        } else if(indexPath.row==2) {
            // add search button here
            cell = [tableView dequeueReusableCellWithIdentifier:@"searchButton"];
            if(cell==nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"searchButton"];
                [cell.contentView addSubview:[self addSearchButton]];
            }
        }
        
    }
    
    else if(indexPath.section==1) {
        // this section is for browsing product catalog
        cell = [self catTreeTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    return cell;
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
        if(indexPath.row==0) {
            return 44.0f;
        } else if(indexPath.row==1) {
            return [radioGroupData[1] count]*44;
        } else if(indexPath.row==2) {
            return 44.0f;
        }
        
    } else if(indexPath.section==1) {
        return 40.0f;
    }
    return 0.0f;
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

-(RadioGroup*) addRadioGroup
{
    radioGroup = [[RadioGroup alloc]initWithFrame: CGRectMake(20, 0 , 300, [radioGroupData[1] count]*40) : radioGroupData[1] :self.defaultSelectionRadio :radioGroupData[0]];
    
    return radioGroup;
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

- (void) buttonEvent : (id) sender
{
    DotFormPost *formPost = [[DotFormPost alloc]init];
    [formPost.postData setObject:searchInputField.text forKey:DotSearchConst_SEARCH_TEXT];
    [formPost.postData setObject:radioGroup.selectedKey forKey:DotSearchConst_SEARCH_BY];
    
    if(self.dependentValueMap!=nil) {
        NSArray* keys = [dependentValueMap allKeys];
        for(int i=0; i<[keys count]; i++) {
            NSString* key = [keys objectAtIndex:i];
            NSString* value = [dependentValueMap objectForKey:key];
            [formPost.postData setObject:value forKey:key];
        }
    }
    
 
   [formPost.postData setObject:[ClientVariable getInstance].CLIENT_USER_LOGIN.userName forKey:@"USERNAME"];
    
    [formPost setModuleId: [DVAppDelegate currentModuleContext]];
    [formPost setDocId: inMasterValueMapping];
    
    loadingView = [LoadingView loadingViewInView:self.view];
    
    networkHelper = [[NetworkHelper alloc] init];
    [networkHelper makeXmwNetworkCall:formPost :self : nil :  XmwcsConst_CALL_NAME_FOR_SEARCH];
    
}


#pragma  mark - Catalog Tree table view delegates


- (NSArray *)myCatInputData {
    if ((!_myCatInputData && self.myDelegate) || _myCatInputData.count == 0) {
        _myCatInputData = [self.myDelegate getAllProductCategoriesDataWithSender:self];
    }
    return _myCatInputData? _myCatInputData : @[];
}

- (NSArray *) myCatTableDataArray {
    if (!_myCatTableDataArray && self.myCatInputData) {
        _myCatTableDataArray = [NSMutableArray array];
        [_myCatTableDataArray addObjectsFromArray:self.myCatInputData];
    }
    return _myCatTableDataArray? _myCatTableDataArray : @[];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)catTreeTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell ;
    if(cell==nil) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CategoryCell"];
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    
    
    PolycabProductCatObject *currObject =self.myCatTableDataArray[indexPath.row];
    cell.textLabel.text = [ self getDisplayName:currObject];
    
    if ([currObject.childList count] > 0) {
        if ([self checkIfChildrenInserted:currObject]) {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        } else {
            // [cell setAccesoryType:DotMenuCellAccesoryStatusClose];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    
    
    
    /*
     PRADEEP changing the code here
    if([currObject.ACCESORY_IMAGE isEqualToString:@"Yes"]) {
        [cell setAccesoryTypeAsImageName:DotMenuCellAccesoryDefaultImage : currObject.MENU_NAME];
    } else {
        [cell setAccesoryType:DotMenuCellAccesoryStatusNone];
    }*/
    
    UIColor *level0 = [UIColor colorWithRed:(0xdb/255.0) green:(0x31/255.0) blue:(0x31/255.0) alpha:1];
    UIColor *level1 = [UIColor colorWithRed:(0xdb/255.0) green:(0x31/255.0) blue:(0x31/255.0) alpha:1];
    UIColor *level2 = [UIColor colorWithRed:(125.0/255.0) green:(125.0/255.0) blue:(125.0/255.0) alpha:1];
    UIColor *level3 = [UIColor colorWithRed:(150.0/255.0) green:(150.0/255.0) blue:(150.0/255.0) alpha:1];
    
    
//    switch (currObject.levelDepth) {
//        case 0: {
//            [cell.textLabel setTextColor:level0];
//            NSMutableAttributedString *titltTxt = [[NSMutableAttributedString alloc] initWithString:currObject.CATAGORY_ID];
//            [titltTxt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, currObject.CATAGORY_ID.length)];
//            [titltTxt addAttribute:NSForegroundColorAttributeName value:level0 range:NSMakeRange(0, currObject.CATAGORY_ID.length)];
//            //[titltTxt appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" (%i)",[currObject.numberOfProducts intValue]]]];
//            cell.textLabel.attributedText = titltTxt;
//            cell.textLabel.numberOfLines = 0;
//            break;
//        }
//        case 1:
//            [cell.textLabel setTextColor:level1];
//            cell.textLabel.font = [UIFont systemFontOfSize:13.0];
//            cell.textLabel.numberOfLines = 0;
//            break;
//        case 2:
//            [cell.textLabel setTextColor:level2];
//            cell.textLabel.font = [UIFont systemFontOfSize:12.0];
//            cell.textLabel.numberOfLines = 0;
//            break;
//        default:
//            [cell.textLabel setTextColor:level3];
//            cell.textLabel.font = [UIFont systemFontOfSize:11.0];
//            cell.textLabel.numberOfLines = 0;
//            break;
//    }
//    tableView.separatorColor = [UIColor lightGrayColor];
    return cell;
}

-(NSString *)getDisplayName:(PolycabProductCatObject*) catObject {
        NSString *displayName;
    
        NSString *level = [catObject.level description];
        
        if ([level isEqualToString:@"1"]) {
            displayName = [catObject.primaryCategory copy];
    
        }
        else if ([level isEqualToString:@"2"])
        {
            displayName = [catObject.primarySubCategory copy];
         
        }
        else if ([level isEqualToString:@"3"])
        {
            displayName = [catObject.secondaryItemCategory copy];
        
        }
        else if ([level isEqualToString:@"4"])
        {
            displayName = [catObject.secondaryItemSubCategory copy];
           
        }
    

    return displayName;
}

-(NSInteger) tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1) {
        PolycabProductCatObject *currObject = self.myCatTableDataArray[indexPath.row];
        return [currObject.level intValue]*4;
    } else {
        return 1;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   if(indexPath.section==1) {
    
        PolycabProductCatObject *currObject = self.myCatTableDataArray[indexPath.row];
        [self updateCategoryPathWithCategory:currObject];
       
       primarayCat = currObject.primaryCategory;
       subCat = currObject.primarySubCategory;
       
        if([currObject.childList count] > 0) {
            BOOL isAlreadyInserted=[self checkIfChildrenInserted:currObject];
            
            if(isAlreadyInserted) {
                currObject.isOpen = NO;
                [self miniMizeThisRows:currObject.childList];
            } else {
                currObject.isOpen = YES;
                NSUInteger count=indexPath.row+1;
                NSMutableArray *arCells=[NSMutableArray array];
                for(NSDictionary *dInner in currObject.childList ) {
                    [arCells addObject:[NSIndexPath indexPathForRow:count inSection:1]];
                    [self.myCatTableDataArray insertObject:dInner atIndex:count++];
                }
                [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationLeft];
            }
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone]; // reload for arrow status
        } else {
            if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(didSelectProductCategory:withCategoryPathString:sender:)])
                [self.myDelegate didSelectProductCategory:currObject withCategoryPathString:[self.categoryPathStringArr componentsJoinedByString:@">>"] sender:self];
        }
        
        if (currObject.level.intValue == 0) {
            // check if new parent category and minimise previously opened
            if (self.lastSelectedObject != currObject) {
                [self removeLastOpenCategory];
            }
            
            self.lastSelectedObject = currObject;
        }

    }
}





#pragma  mark - Catalog Tree and its delegates

-(NSArray *)createModalDataSourceFromJson:(id)jsonArrayObject {
    NSMutableArray *returnArr = [NSMutableArray array];
    
    for (id object in jsonArrayObject) {
        PolycabProductCatObject *newObj = [[PolycabProductCatObject alloc]initWithObject:object];
        [returnArr addObject:newObj];
    }
    return returnArr;
}


- (BOOL)checkIfChildrenInserted: (PolycabProductCatObject *) parentObject {
    BOOL childrenInserted=NO;
    
    for(PolycabProductCatObject *dInner in parentObject.childList ){
        NSUInteger index=[self.myCatTableDataArray indexOfObject:dInner];
        childrenInserted=(index>0 && index!=NSIntegerMax);
        if(childrenInserted) break;
    }
    return childrenInserted;
}

-(void)miniMizeThisRows:(NSArray*)ar{
    
    for(PolycabProductCatObject *dInner in ar ) {
        NSUInteger indexToRemove=[self.myCatTableDataArray indexOfObject:dInner];
        NSArray *arInner=dInner.childList;
        if(arInner && [arInner count]>0){
            [self miniMizeThisRows:arInner];
        }
        
        if([self.myCatTableDataArray indexOfObject:dInner]!=NSNotFound) {
            [self.myCatTableDataArray removeObject:dInner];
            [self.mainTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                          [NSIndexPath indexPathForRow:indexToRemove inSection:1]
                                          ]
                        withRowAnimation:UITableViewRowAnimationRight];
        }
    }
}

- (void)removeLastOpenCategory {
    if (self.lastSelectedObject) {
        [self miniMizeThisRows:self.lastSelectedObject.childCategories];
        NSIndexPath *indexPAthCatMain = [NSIndexPath indexPathForRow:[self.myCatTableDataArray indexOfObject:self.lastSelectedObject] inSection:1];
        [self.mainTableView reloadRowsAtIndexPaths:@[indexPAthCatMain] withRowAnimation:UITableViewRowAnimationNone]; // reload for arrow status
    }
}

- (void)updateCategoryPathWithCategory:(PolycabProductCatObject *)categoryObject {
    if ((categoryObject.level.intValue-1) == self.categoryPathStringArr.count)
    {
        [self.categoryPathStringArr addObject:[self getDisplayName:categoryObject]];
    }
    else
    {
        [self.categoryPathStringArr subarrayWithRange:NSMakeRange(0, categoryObject.level.intValue)];
        
        [self.categoryPathStringArr setObject:[self getDisplayName:categoryObject] atIndexedSubscript:categoryObject.level.intValue-1 ];
    }
}

- (void)selectProductCategoryWithPanelXPath:(NSString *)categoryPanelXPath {
    NSArray *arraySequenceCatselected = [categoryPanelXPath componentsSeparatedByString:@">>"];
    
    NSUInteger searchIndexPointer = 0;
    for (NSString *catIdStr in arraySequenceCatselected) {
        for (; searchIndexPointer<[self.myCatTableDataArray count]; searchIndexPointer++) {
            
            ProductCatObject *object = self.myCatTableDataArray[searchIndexPointer];
            if ([object.identifier isEqualToString:catIdStr]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:searchIndexPointer inSection:1];
                if (object.childCategories.count > 0)
                    [self tableView:self.mainTableView didSelectRowAtIndexPath:indexPath]; // select tableview row to expand
                else {
                    [self.mainTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
                    return;
                }
                break;
            }
        }
    }
}



#pragma  mark - ProductCatTreeTblViewDelegate


- (void)didSelectProductCategory:(PolycabProductCatObject *)category
       withCategoryPathString:(NSString *)categoryPathString
                       sender:(id)sender
{
    NSLog(@"SDCategory Data = %@",category);
    
    [self fetchProductsForCatalog:category];
    
}

- (NSArray *)getAllProductCategoriesDataWithSender:(id)sender
{
    return [self createModalDataSourceFromJson:self.serverCatalogCategoryTree];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [searchInputField resignFirstResponder];
    
    return YES;
}

@end
