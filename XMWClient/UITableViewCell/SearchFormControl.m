//
//  SearchFormControl.m
//  TestControll
//
//  Created by Ashish Tiwari on 27/06/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "SearchFormControl.h"
#import "SearchTextField.h"
#import "RadioGroup.h"
#import <QuartzCore/QuartzCore.h>
#import "SearchScreenButtonControl.h"
#import "MXTextField.h"
#import "ClientVariable.h"
#import "DVAppDelegate.h"
#import "NetworkHelper.h"
#import "XmwcsConstant.h"
#import "DotSearchComponent.h"
#import "SearchResponse.h"
#import "SearchViewController.h"
#import "XmwcsConstant.h"
#import "Styles.h"




@implementation SearchFormControl

@synthesize searchInputField;
@synthesize parentController;
@synthesize radioGroup;
@synthesize inMasterValueMapping;
@synthesize searchVC;
@synthesize elementId;
@synthesize multiSelect;
@synthesize multiSelectDelegate;
@synthesize dependentValueMap;



- (id)initWithFrame:(CGRect)frame : (NSMutableArray *) keyValueDoubleArray : (NSInteger) defaultIndex : (FormVC*) parent : (NSString *)masterValueMapping :(NSString *) formElementId :(NSString*) displayText
{
   self = [super initWithFrame:frame];
    

    if (self) {
        self.inMasterValueMapping = masterValueMapping;
        self.elementId = formElementId;
        self.parentController = parent;
        titleDisplayText = displayText;
        self.multiSelectDelegate = nil;
        self.multiSelect = NO;
        self.dependentValueMap = nil;

        
        UIImage *headerImage          = [UIImage imageNamed:@"blueButton.png"];
        UIImage *headerButtonImage    = [headerImage stretchableImageWithLeftCapWidth:18 topCapHeight:0];
         UIButton *Header       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [Header setFrame:CGRectMake(0, 0 , 320 , 36)];
        [Header setBackgroundImage:headerButtonImage forState:UIControlStateNormal];
        [Header setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] forState: UIControlStateNormal];
        [Header setTitle:[NSString stringWithFormat:@"Search %@", displayText] forState:UIControlStateNormal];
        
        UILabel *searchLabel  =  [[UILabel alloc]init];
        searchLabel.frame     =  CGRectMake(10, 40, 120, 25);
        searchLabel.text      =  @"Search ";
        searchLabel.backgroundColor = [UIColor lightGrayColor];
        
        
        searchInputField = [[UITextField alloc]initWithFrame:CGRectMake(120, 40, 180, 25)];
        [searchInputField setBackgroundColor:[UIColor whiteColor]];
        [searchInputField setDelegate:self];
        
      
        
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [doneButton setFrame:CGRectMake(self.bounds.size.width-50, 0, 50, 42.0)];
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(doneTapped) forControlEvents:UIControlEventTouchUpInside];
        
        searchInputField.inputAccessoryView = doneButton;
        

        
        
        
        radioGroup = [[RadioGroup alloc]initWithFrame: CGRectMake(0, 70 , 320, 100) : keyValueDoubleArray[1] : defaultIndex : keyValueDoubleArray[0]];
        
        UIImage *blueImage          = [UIImage imageNamed:@"blueButton.png"];
        UIImage *rightImage          = [UIImage imageNamed:@"closeButton.png"];
        UIImage *blueButtonImage    = [blueImage stretchableImageWithLeftCapWidth:8 topCapHeight:0];
        UIImage *rightButtonImage    = [rightImage stretchableImageWithLeftCapWidth:8 topCapHeight:0];
        UIButton *searchButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        UIButton *cancleButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        [searchButton setFrame:CGRectMake(40, 170 , 100, 36)];
        [cancleButton setFrame: CGRectMake(180, 170 , 100, 36)];
        [searchButton setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
        [cancleButton setBackgroundImage:rightButtonImage forState:UIControlStateNormal];
        [searchButton setTitleColor:[Styles buttonTextColor] forState: UIControlStateNormal];
        [cancleButton setTitleColor:[Styles buttonTextColor] forState: UIControlStateNormal];
        [searchButton setTitle:@"Search" forState:UIControlStateNormal];
        [cancleButton setTitle:@"Cancel" forState:UIControlStateNormal];

               
        [searchButton addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [cancleButton addTarget:self action:@selector(cancelButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        
            
        [self addSubview:Header];
        [self addSubview:searchLabel];
        
      //  [searchInputField becomeFirstResponder];

                
        [self  addSubview : searchInputField];
        [self  addSubview : radioGroup];
        [self addSubview : searchButton];
        [self addSubview : cancleButton];
        
        
        [self setBackgroundColor:[UIColor lightGrayColor]];
        //[[self layer] setCornerRadius:14];
        [[self layer] setBorderWidth:1.0];
        [[self layer] setBorderColor:[[UIColor blackColor] CGColor]];

        
        // Initialization code
    }
    return self;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)doneTapped{
    [self endEditing:YES];
}


- (void) buttonEvent : (id) sender
{

   if(self.buttonsDelegate!=nil && [self.buttonsDelegate respondsToSelector:@selector(searchAction: selectionKey:)]) {
        [self.buttonsDelegate searchAction:searchInputField.text selectionKey:radioGroup.selectedKey];
        [self removeFromSuperview];
        return;
    }
    
    ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
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
            
   
    [formPost setModuleId: [DVAppDelegate currentModuleContext]];
    [formPost setDocId: inMasterValueMapping];
   
    loadingView = [LoadingView loadingViewInView:parentController.view];//self.view];
     
    NetworkHelper *networkHelper = [[NetworkHelper alloc] init];
    [networkHelper makeXmwNetworkCall:formPost :self : nil :  XmwcsConst_CALL_NAME_FOR_SEARCH];
    //[parentController.searchPopUp removeFromSuperview];
    

}

- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    [self removeFromSuperview];
    [loadingView removeFromSuperview];
    SearchResponse *searchResponse = (SearchResponse*)respondedObject;
    searchVC = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    searchVC.screenId = XmwcsConst_SCREEN_ID_SEARCH_RESULT;
    searchVC.searchResponse = searchResponse;
    searchVC.elementId = elementId;
    searchVC.masterValueMapping = inMasterValueMapping;
    searchVC.parentController = parentController;
    searchVC.multiSelect = self.multiSelect;
    searchVC.multiSelectDelegate = self.multiSelectDelegate;
    searchVC.headerTitle = [NSString stringWithFormat:@"%@ Search Results", titleDisplayText];
   [[parentController navigationController] pushViewController:searchVC  animated:YES];
    
      
}

- (void) httpFailureHandler:(NSString*) callName :(NSString*) message;
{
    [loadingView removeFromSuperview];
    
}


-(void) cancelButtonEvent :(id)sender
{
	 if(self.buttonsDelegate!=nil && [self.buttonsDelegate respondsToSelector:@selector(searchCancel)]) {
        [self.buttonsDelegate searchCancel];
        [self removeFromSuperview];
        return;
    }
   
    [self removeFromSuperview];

}

@end
