//
//  SearchFormControl.h
//  TestControll
//
//  Created by Ashish Tiwari on 27/06/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DotFormPost.h"
#import "HttpEventListener.h"
#import "RadioGroup.h"
#import "SearchViewController.h"
#import "FormVC.h"
#import "LoadingView.h"


@class FormVC;
@class SearchViewController;
@protocol SearchViewMultiSelectDelegate;


@protocol SearchButtonsDelegate <NSObject>
-(void) searchAction:(NSString*) userText selectionKey:(NSString*)key;
-(void) searchCancel;
@end

@interface SearchFormControl : UIView <UITextFieldDelegate, HttpEventListener>
{
    FormVC* parentController;
    UITextField*  searchInputField;
    RadioGroup *radioGroup;
    NSString *inMasterValueMapping;
    SearchViewController *searchVC;
    NSString *elementId;
    LoadingView* loadingView;
    NSString* titleDisplayText;
    
    BOOL multiSelect;
    id<SearchViewMultiSelectDelegate> multiSelectDelegate;
    NSMutableDictionary* dependentValueMap;
            
}

@property NSString *elementId;
@property FormVC* parentController;
@property SearchViewController *searchVC;
@property NSString *inMasterValueMapping;
@property RadioGroup *radioGroup;
@property UITextField* searchInputField;
@property id<SearchButtonsDelegate> buttonsDelegate;


@property BOOL multiSelect;
@property id<SearchViewMultiSelectDelegate> multiSelectDelegate;
@property NSMutableDictionary* dependentValueMap;


-(void) buttonEvent:(id) sender;
-(void) cancelButtonEvent:(id)sender;

- (id)initWithFrame :(CGRect)frame : (NSMutableArray *) keyValueDoubleArray : (NSInteger) defaultIndex :(UIViewController*) parent : (NSString *)masterValueMapping : (NSString *)formElementId :(NSString*) displayText;;

@end
