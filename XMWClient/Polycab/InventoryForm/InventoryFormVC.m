//
//  InventoryFormVC.m
//  XMWClient
//
//  Created by Pradeep Singh on 14/11/20.
//  Copyright © 2020 dotvik. All rights reserved.
//

#import "InventoryFormVC.h"
#import "AppConstants.h"
#import "XmwUtils.h"

@interface InventoryFormVC ()

@end

@implementation InventoryFormVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
}

-(void) postLayoutInitialization
{
    NSLog(@"postLayoutInitialization");
    
    NSString* elementId = @"ORGANIZATION_NAME";
    
    // we need to fetch data for organiztion_name, and then populate it
    DotFormElement* contextElement = [self.dotForm.formElements objectForKey:elementId];
    [self plantValuesFor:elementId element:contextElement];
}

-(void) plantValuesFor:(NSString*) elementId element:(DotFormElement*) element
{
    loadingView = [LoadingView loadingViewInView:self.view];

    DotFormPost *dotFormPost = [[DotFormPost alloc]init];
    
    [dotFormPost setAdapterType:@"SEARCH"];
    [dotFormPost setAdapterId:element.masterValueMapping];
    [dotFormPost setModuleId:AppConst_MOBILET_ID_DEFAULT];
    [dotFormPost setDocId:element.masterValueMapping];
    [dotFormPost setDocDesc:@""];
    [dotFormPost setReportCacheRefresh:@"true"];
    [dotFormPost.postData setObject:@"" forKey:@"SEARCH_TEXT"];
    [dotFormPost.postData setObject:@"SBC" forKey:@"SEARCH_BY"];
    [dotFormPost.postData setObject:element.elementId forKey:@"REQUEST_ELEMENT_ID"];
    
   
    NSDictionary* extendedPropertyMap = [XmwUtils getExtendedPropertyMap:element.extendedProperty];
    
    if (extendedPropertyMap != nil) {
        if ([extendedPropertyMap objectForKey:@"REQUEST_DEFAULT_VALUE"]!=nil
            && [[extendedPropertyMap objectForKey:@"REQUEST_DEFAULT_VALUE"] compare:@"TRUE" options:NSCaseInsensitiveSearch]==NSOrderedSame)
        {
            [dotFormPost setDocId:[extendedPropertyMap objectForKey:@"REQUEST_DOC_ID"]];
            
        } else {
            [dotFormPost setDocId:element.masterValueMapping];
        }
    } else {
        [dotFormPost setDocId:element.masterValueMapping];
    }

    networkHelper = [[NetworkHelper alloc] init];
    [networkHelper makeXmwNetworkCall:dotFormPost :self : nil :  XmwcsConst_CALL_NAME_FOR_SEARCH];
        
}

#pragma mark - HttpEventListener

- (void) httpResponseObjectHandler:(NSString*) callName :(id) respondedObject :(id) requestedObject
{
    [super  httpResponseObjectHandler:callName :respondedObject :requestedObject];
    
    // [self setDropDownResponseDefaultValue :(id)respondedObject :(NSString *) fieldElementId;

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
