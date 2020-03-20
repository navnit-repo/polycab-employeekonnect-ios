//
//  HamBurgerMenuView.m
//  QCMSProject
//
//  Created by Pradeep Singh on 10/5/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "HamBurgerMenuView.h"
#import "MXButton.h"
#import "DotMenuTreeTableView.h"




#import "XmwcsConstant.h"
#import "XmwUtils.h"
#import "OperationManagerUtil.h"
#import "ClientVariable.h"
#import "DotForm.h"
#import "DotFormElement.h"
#import "AppConstants.h"

#import "XmwFileExplorer.h"
#import "XmwNotificationViewController.h"
#import "DVAppDelegate.h"
#import "SBJson.h"


static NSMutableDictionary* g_MenuImageMap = nil;




@implementation HamBurgerMenuView


@synthesize menuTable;
@synthesize menuItems;
@synthesize menuDetail;
@synthesize keyIdName;


+ (NSMutableDictionary*) getMenuMap {
    if(g_MenuImageMap==nil) {
        srandomdev();
        NSString* pathForQuotesJson = [[NSBundle mainBundle] pathForResource:@"menus"  ofType:@"json"];
        
        SBJsonParser* sbParser = [[SBJsonParser alloc] init];
        NSData* jsonData = [[NSData alloc] initWithContentsOfFile:pathForQuotesJson];
        g_MenuImageMap = (NSMutableDictionary*)[sbParser objectWithData:jsonData];
    }
    return g_MenuImageMap;
}


+ (NSString*) getMenuImage:(NSString*) keyName {
    //comment all line for not show images
    
    
    NSArray* imageArray = [[HamBurgerMenuView getMenuMap] objectForKey:keyName];
    if(imageArray!=nil && [imageArray count]>0) {
        return [imageArray objectAtIndex:0];
    } else {
        return @"sales.png";
    }
    return @"";
}

+ (NSString*) getMenuDashImage:(NSString*) keyName {
     //comment all line for not show images
   NSArray* imageArray = [[HamBurgerMenuView getMenuMap] objectForKey:keyName];

    if(imageArray!=nil && [imageArray count]>0) {
        return [imageArray objectAtIndex:1];
    } else {
      return @"sales.png";

    }
    return @"";
}



- (id)initWithFrame:(CGRect)frame withMenu:(NSArray*) menus handler:(id<HamBurgerMenuHandler>) menuHandler :(NSMutableDictionary *)in_menuDetail : (NSMutableArray *)in_keyIdName;
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        // Initialization code
        self.menuItems = [[NSMutableArray alloc] initWithArray:menus];
        self.menuDetail = in_menuDetail;
        self.keyIdName = in_keyIdName;
       
        
        menuAndDashImageIcon = [[NSArray alloc]initWithObjects:@"my_details",@"create_order",@"request_for_return",@"reports",@"proofofdelivery",@"statutory_requirement",@"policies",@"manage_sub_user",@"feedback",@"logout", nil];
        
        
        NSLog(@"frame Width = %f",frame.size.width);
        NSLog(@"frame Height = %f",frame.size.height);
        
        NSBundle* appBundle = [NSBundle mainBundle];
        NSString* bundlePath = [appBundle resourcePath];
        NSLog(@"bundlePath = %@", bundlePath);
        
        NSString* sampleDataFile = [ NSBundle pathForResource:@"categoryJson.json" ofType:nil inDirectory:bundlePath];
        NSLog(@"sample data File %@", sampleDataFile);
//        
//        NSData* jsonData = [[NSData alloc] initWithContentsOfFile:sampleDataFile];
//        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
        // NSLog(@"%@", [jsonObject description]);
        /*
        productCategories = [jsonObject objectForKey:@"productCategorySros"];
        NSLog(@"Product Categories = %@", [productCategories description]);
        */
       
        menuTree = [[NSMutableArray alloc]init];
        
        int sizeOfKeyVec    = [self.keyIdName count];
                
        for (int idx = 0; idx < sizeOfKeyVec; idx++)
        {
            NSMutableArray *childMenuTree = [[NSMutableArray alloc]init];
            NSMutableDictionary* menuTypeData = [[NSMutableDictionary alloc]init];
            menuTypeData = [self.menuDetail objectForKey: [self.keyIdName objectAtIndex:idx]];
            
            
            [menuTypeData setValue:[NSNumber numberWithInt:[[self.keyIdName objectAtIndex:idx] intValue]] forKey:@"id"];
            [menuTypeData setValue:[NSNumber numberWithBool:YES] forKey:@"visible"];
            [menuTypeData setValue:@"Yes"forKey:@"ACCESORY_IMAGE"];
            [menuTypeData setValue:[NSNumber numberWithInt:idx] forKey:@"ACCESORY_IMAGE_NUM"];
            
            
            
            // getMenuImage
            
           // [menuTypeData setValue:[menuAndDashImageIcon objectAtIndex:idx] forKey:@"ACCSRY_DASH_IMAGE_NAME"];
            
             [menuTypeData setValue:[HamBurgerMenuView getMenuDashImage: [menuTypeData objectForKey:@"MENU_NAME"]] forKey:@"ACCSRY_DASH_IMAGE_NAME"];
            
            
            
            
            //here add child Data for Tree View
            
           
            NSString* menuKey = (NSString*)[keyIdName   objectAtIndex:idx];
            NSMutableDictionary *selectedButtonDetail = (NSMutableDictionary *)[self.menuDetail objectForKey:menuKey];
            
            [self addChildrenInMenuItem:selectedButtonDetail : childMenuTree : [HamBurgerMenuView getMenuDashImage: [menuTypeData objectForKey:@"MENU_NAME"]]];
            
            
            [menuTypeData setValue:childMenuTree forKey:@"childCategories"];
            
            //close add child data
                       
            [menuTree setObject:menuTypeData atIndexedSubscript:idx];
            
            
        }
        
          NSLog(@"Product Categories = %@", [menuTree description]);
        
        
        DotMenuTreeTableView* categoryPanel = [[DotMenuTreeTableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
       
       
        
//        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//
//        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
//
//            statusBar.backgroundColor = [UIColor whiteColor];//set whatever color you like
//        }
            UIView *statusBar;
            if (@available(iOS 13.0, *)) {
                statusBar = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame] ;
                statusBar.backgroundColor = [UIColor whiteColor];
            } else {
                // Fallback on earlier versions
                if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {

                    statusBar.backgroundColor = [UIColor whiteColor];//set whatever color you like
                }

            }
        
        categoryPanel.separatorStyle = UITableViewCellSelectionStyleNone;
        categoryPanel.backgroundColor = [UIColor whiteColor];
        categoryPanel.bounces = NO;
        [categoryPanel setMyDelegate:self];
        
        [self addSubview:categoryPanel];
        
        burgerMenuHandler = menuHandler;
        
    }
    
    return self;
}

//add children in Menu Item
-(void) addChildrenInMenuItem:(NSMutableDictionary *)menuData : (NSMutableArray *)childMenuTree : (NSString *)menuDashImgIcon
{
    NSDictionary* childMenuDetails = (NSDictionary*)[menuData objectForKey:@"CHILD_MENU_DETAIL"];
    
    if(childMenuDetails != nil && [childMenuDetails count]>0) {
        NSLog(@"Total Child menus %d", [childMenuDetails count]);
        NSArray *keySortList = [XmwUtils sortHashtableKey:childMenuDetails :XmwcsConst_SORT_AS_INTEGER];
        int sizeOfKeyVec    = [keySortList count];
        
        NSArray *childMenuSubTree =  [[NSArray alloc]init];
        for (int idx = 0; idx < sizeOfKeyVec; idx++)
        {
            NSMutableDictionary* subMenuTypeData = [[NSMutableDictionary alloc]init];
            subMenuTypeData = [childMenuDetails objectForKey: [keySortList objectAtIndex:idx]];
            
            [subMenuTypeData setValue:childMenuSubTree forKey:@"childCategories"];
            [subMenuTypeData setValue:[NSNumber numberWithInt:[[keySortList objectAtIndex:idx] intValue]] forKey:@"id"];
            [subMenuTypeData setValue:[NSNumber numberWithBool:YES] forKey:@"visible"];
            
            [subMenuTypeData setValue:menuDashImgIcon forKey:@"ACCSRY_DASH_IMAGE_NAME"];
            
            [childMenuTree setObject:subMenuTypeData atIndexedSubscript:idx];
        }
        return;
    }
    
    NSString *docType = (NSString*) [menuData objectForKey : XmwcsConst_MENU_CONSTANT_FORM_TYPE];
    NSString *isOperation = [menuData objectForKey:XmwcsConst_MENU_CONSTANT_IS_OPERATION_AVAL];
    
    if (isOperation != NULL && [isOperation isEqualToString:XmwcsConst_BOOLEAN_VALUE_TRUE])
    {
        NSMutableDictionary* operationMenuMap = [OperationManagerUtil handleOnClickOperation : menuData];
        
      /*  MenuVC *menuScreen          = [[MenuVC alloc] init];
        menuScreen.headerStr        = [menuData objectForKey: XmwcsConst_MENU_CONSTANT_MENU_NAME];
        menuScreen.menuDetail       =  operationMenuMap;
       	menuScreen.isFirstScreen    = NO;
        [[self navigationController] pushViewController:menuScreen  animated:YES];
       */
        
        [self getSubMenuItems : operationMenuMap : childMenuTree : menuDashImgIcon];
        
        return;
    }
    NSMutableDictionary* forwardDisplay = nil;
    NSMutableDictionary* forwardData = nil;
    
    
    
    if ([docType isEqualToString:XmwcsConst_DOC_TYPE_SUBMIT] || [docType isEqualToString:XmwcsConst_DOC_TYPE_VIEW])
        [self getFormType:menuData :nil :NO:forwardDisplay:forwardData : childMenuTree : menuDashImgIcon];
    
    
    else if ([docType isEqualToString:XmwcsConst_DOC_TYPE_CONTENT_FORM])
    {
        
        
    } else if ([docType isEqualToString:XmwcsConst_DOC_TYPE_VIEWDIRECT]) {
        //for the direct call of the report on clicks of the menu
        NSString *formId = (NSString*)[menuData objectForKey: XmwcsConst_MENU_CONSTANT_FORM_ID] ;
       
        
        NSString *unfilteredString = formId;
        NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"$"] invertedSet];
        NSString *resultString = [[unfilteredString componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
        NSLog (@"Result: %@", resultString);
       
        NSString* adapterId;
        NSRange pos;
        if ([resultString isEqualToString:@"$"]) {
            pos = [formId rangeOfString:@"$" ];
            
            adapterId = [formId substringToIndex:pos.location];
        }
//        NSRange pos = [formId rangeOfString:@"$" ];
//
//        adapterId = [formId substringToIndex:pos.location];
        else{
             pos.location = 0;
             adapterId = formId ;
        }
        // starting position (pos.location + 1)
        // end position (.length()
        NSRange valueRange;
        valueRange.location = pos.location + 1;
        valueRange.length = formId.length - valueRange.location;
        
        NSString *adapterType  = [formId substringWithRange:valueRange];
        
        DotFormPost *dotFormPost = [[DotFormPost alloc]init];
        
        [dotFormPost setAdapterType:adapterType];
        [dotFormPost setAdapterId:adapterId];
        [dotFormPost setModuleId:AppConst_MOBILET_ID_DEFAULT];
        [dotFormPost setDocId:adapterId];
        
      //  loadingView = [LoadingView loadingViewInView:self.view];
        
       // NetworkHelper *networkHelper = [[NetworkHelper alloc] init];
       // [networkHelper makeXmwNetworkCall:dotFormPost :self : nil :  XmwcsConst_CALL_NAME_FOR_REPORT];
    }  else if ([docType isEqualToString:XmwcsConst_DOC_TYPE_VIEWDIRECT_EDIT]) {
        //for the direct call of the report on clicks of the menu
        NSString *formId = (NSString*)[menuData objectForKey: XmwcsConst_MENU_CONSTANT_FORM_ID] ;
        NSRange pos = [formId rangeOfString:@"$" ];
        NSString* adapterId = [formId substringToIndex:pos.location];
        
        // starting position (pos.location + 1)
        // end position (.length()
        NSRange valueRange;
        valueRange.location = pos.location + 1;
        valueRange.length = formId.length - valueRange.location;
        
        NSString *adapterType  = [formId substringWithRange:valueRange];
        
        DotFormPost *dotFormPost = [[DotFormPost alloc]init];
        
        [dotFormPost setAdapterType:adapterType];
        [dotFormPost setAdapterId:adapterId];
        [dotFormPost setModuleId:AppConst_MOBILET_ID_DEFAULT];
        [dotFormPost setDocId:adapterId];
        
        //  loadingView = [LoadingView loadingViewInView:self.view];
        
        // NetworkHelper *networkHelper = [[NetworkHelper alloc] init];
        // [networkHelper makeXmwNetworkCall:dotFormPost :self : nil :  XmwcsConst_CALL_NAME_FOR_REPORT];
    } else if ([docType isEqualToString:XmwcsConst_DOC_TYPE_RECENT_REPORT]) {
        
        NSString *formId = (NSString*)[menuData objectForKey: XmwcsConst_MENU_CONSTANT_FORM_ID];
        
      //  RecentRequestController* recentRequestController = [[RecentRequestController alloc] initWithNibName:@"RecentRequestController" bundle:nil];
      //  [recentRequestController  initwithData : XmwcsConst_EssRecentRequestScreen : formId :self];
        
      //  [[self navigationController] pushViewController:recentRequestController  animated:YES];
        
        
        
    } else if ([docType isEqualToString:XmwcsConst_DOC_TYPE_URL_LAUNCH])
    {/*
        NSString *formId = (NSString*)[menuData objectForKey: XmwcsConst_MENU_CONSTANT_FORM_ID];
        ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
        NSString *launchUrl = (NSString*)[clientVariables.CLIENT_MASTERDETAIL.masterData objectForKey: formId];
        //Open browser with launchUrl
        
        XmwWebViewController* webViewController = [[XmwWebViewController alloc] initWithNibName:@"XmwWebViewController" bundle:nil withAdURL:launchUrl];
        
        [[self navigationController] pushViewController:webViewController  animated:YES];
       */
    } else if ([docType isEqualToString:XmwcsConst_DOC_TYPE_EMAIL_LAUNCH]) {
       /*
        NSString *formId = (NSString*)[menuData objectForKey: XmwcsConst_MENU_CONSTANT_FORM_ID];
        ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
        NSString *comaSeparatedEmailReceipients = (NSString*)[clientVariables.CLIENT_MASTERDETAIL.masterData objectForKey: formId];
        //Open browser with launchUrl
        
        [self displayMailComposerSheet: comaSeparatedEmailReceipients];
       */
    } else if ([docType isEqualToString:XmwcsConst_DOC_TYPE_LOGOUT])
    {
      /*  PageViewController *pageViewController = [[PageViewController alloc] initWithNibName:@"PageViewController" bundle:nil];//added by ashish tiwari on aug 2014
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:pageViewController];//addded by ashish tiwari on aug 2014
        [[UIApplication sharedApplication] keyWindow].rootViewController = nc;//added by ashish tiwari on aug 2014
        
        DVAppDelegate* appDelegate =(DVAppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.navController = nc;
        */
        //exit(0);//comment by ashish tiwari on aug 2014
        
    } else if([docType isEqualToString:XmwcsConst_DF_FORM_TYPE_FILE_EXPLORER]) {
        XmwFileExplorer* fileExplorer = [[XmwFileExplorer alloc] initWithNibName:@"XmwFileExplorer" bundle:nil];
        //[[self navigationController] pushViewController:fileExplorer  animated:YES];
        
    }
    else if([docType isEqualToString:XmwcsConst_DF_FORM_TYPE_NOTIFICATION]) {
        XmwNotificationViewController* notificationViewController = [[XmwNotificationViewController alloc] initWithNibName:@"XmwNotificationViewController" bundle:nil];
       // [[self navigationController] pushViewController:notificationViewController  animated:YES];
        
    }
    
    
}

-(void) getFormType : (NSMutableDictionary *) addedData : (DotFormPost *) dotFormPost : (BOOL) isFormIsSubForm :(NSMutableDictionary *) forwardedDataDisplay : (NSMutableDictionary *) forwardedDataPost : (NSMutableArray *)childMenuTree : (NSString *)menuDashImageIcon
{
    ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    NSString *formId = (NSString *)[addedData objectForKey:XmwcsConst_MENU_CONSTANT_FORM_ID];
    DotForm *dotForm = (DotForm *) [clientVariables.DOT_FORM_MAP objectForKey: formId];
    
    if (forwardedDataDisplay == nil)
        forwardedDataDisplay   = [[NSMutableDictionary alloc] init];
    
    if (forwardedDataPost == nil)
        forwardedDataPost      = [[NSMutableDictionary alloc] init];
    
    
    if( [[dotForm formSubType] isEqualToString:XmwcsConst_DF_FORM_TYPE_SIMPLE] ||
       [[dotForm formSubType] isEqualToString:XmwcsConst_DF_FORM_TYPE_CHANGE_PASSWORD] ||
       [[dotForm formSubType] isEqualToString:XmwcsConst_DF_FORM_TYPE_SIMPLEADDROW] ||
       [[dotForm formSubType] isEqualToString:XmwcsConst_DF_FORM_TYPE_ADD_ROW]
       )
    {
        FormVC* formController = [[FormVC alloc] initWithData : addedData
                                                              : dotFormPost
                                                              : isFormIsSubForm
                                                              : forwardedDataDisplay
                                                              : forwardedDataPost];
        formController.headerStr			= dotForm.screenHeader;
        formController.menuViewController = self;
        
        //[[self navigationController] pushViewController:formController  animated:YES];
    } else if([[dotForm formSubType] isEqualToString:XmwcsConst_DF_FORM_TYPE_BUTTON]) {
        
        NSMutableDictionary* subMenuDetails = [DotFormDraw makeMenuForButtonScreen : formId];
        
      
        [self getSubMenuItems : subMenuDetails : childMenuTree : menuDashImageIcon];
        
        
    }
    
    
}

-(void) getSubMenuItems : (NSMutableDictionary *)subMenuDetails : (NSMutableArray *)childMenuTree : (NSString *)munuDashBoardIcon
{
   NSMutableArray *subMenuItems           = [[NSMutableArray alloc] init];
    
    // keyIdName = [menuDetail allKeys];
   NSMutableArray * subMenuKeyIdName           = [[NSMutableArray alloc] initWithArray:[XmwUtils sortHashtableKey : subMenuDetails : XmwcsConst_SORT_AS_INTEGER]];
    
    int sizeOfKeyVec    = [subMenuKeyIdName count];
    
    NSArray *childMenuSubTree =  [[NSArray alloc]init];
    for (int idx = 0; idx < sizeOfKeyVec; idx++)
    {
        NSMutableDictionary* subMenuTypeData = [[NSMutableDictionary alloc]init];
        subMenuTypeData = [subMenuDetails objectForKey: [subMenuKeyIdName objectAtIndex:idx]];
        
        [subMenuTypeData setValue:childMenuSubTree forKey:@"childCategories"];
        
        
        [subMenuTypeData setValue:[NSNumber numberWithInt:[[subMenuKeyIdName objectAtIndex:idx] intValue]] forKey:@"id"];
        [subMenuTypeData setValue:[NSNumber numberWithBool:YES] forKey:@"visible"];
        
        [subMenuTypeData setValue:munuDashBoardIcon forKey:@"ACCSRY_DASH_IMAGE_NAME"];
        
        [childMenuTree setObject:subMenuTypeData atIndexedSubscript:idx];

    }
   // NSLog(@"child category Submenu = %@", childMenuTree);
    
}




-(IBAction)humbergerMenuClicked:(id)sender
{
    MXButton* menuButton = (MXButton*) sender;
    NSLog(@"menuClicked");
    NSLog(@"menu idx selected is %d", [menuButton.elementId    intValue]);
   // [burgerMenuHandler humbergerMenuClicked:[menuButton.elementId   intValue]];
}

- (void)didSelectMenuCategory:(DotMenuObject *)category
   withCategoryPathString:(NSString *)categoryPathString
                   sender:(id)sender
{

    NSLog(@"SDCategory Data = %@",category);
   
    NSMutableDictionary *selectedMenuData;
    
    MXButton* menuButton = (MXButton*) sender;
    NSLog(@"menuClicked");
    NSLog(@"menu idx selected is %d", [menuButton.elementId    intValue]);
    [burgerMenuHandler humbergerMenuClicked:[menuButton.elementId   intValue] : category];
    
}

- (NSArray *)getAllMenuCategoriesDataWithSender:(id)sender
{
    return [DotMenuTreeTableView createModalDataSourceFromJson:menuTree];
}


-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end
