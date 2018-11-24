//
//  AddRowFormVC.h
//  EMSSales
//
//  Created by Puneet Arora on 28/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@class DotForm, DotFormPost, DotFormElement;
@class Reachability;
@class LoadingView;

@interface AddRowFormVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ABPeoplePickerNavigationControllerDelegate>
{
    @private
    
    DotForm *formDef;
	DotFormPost *formPost;
	
    NSMutableDictionary *dataForNextScreenDisplay;
	NSMutableDictionary *dataForNextScreenPost;
    NSMutableDictionary *formData;
    
	NSString *lastFormId;
	NSString *formId;
    NSString *headerStr;
    NSString *selectedSecKey;
    NSString *selectedSearchText;
    // Replace with Array for the Case SubForm in SubForm
    NSString *selectedRowStr;
    NSString *selButtonKey;
    
    NSUInteger tableTag;
    BOOL isFormIsSubForm;
    NSIndexPath *selectedIndexPath;
    
    NSMutableArray *subFormSectKeys;
    NSMutableArray *subFormKeys;
    NSMutableArray *formSectKeys;
    NSMutableArray *autoFillData;
    NSMutableDictionary *subFormKeyRange;
    NSMutableDictionary *sectionList;
    NSMutableDictionary *subFormList;
    NSMutableDictionary *sectHeaderList;
    
    Reachability* internetReachable;
    LoadingView *loadingView;
    UITableView *addRowFormTableView;
	

    
    UITextField *cellField;
    UITableView *subFormTableView;
    UIView *subFormView;
    CGFloat textFieldAnimatedDistance;
}

@property (strong, nonatomic) IBOutlet UITableView *formTableView;
@property (nonatomic, retain) UITableView *addRowFormTableView;

@property (strong, nonatomic) NSMutableArray *componentArray;

@property (strong, nonatomic) id contactData;
@property (strong, nonatomic) id dateData;

@property (nonatomic) BOOL internetActive;

@property (nonatomic) BOOL isUpdateForm;

@property (nonatomic) BOOL isSimple;
@property (nonatomic, retain) NSString *selectedRadioKey;
@property (nonatomic, retain) NSString *selectedSearchText;

-(AddRowFormVC *) initWithData:(NSMutableDictionary *)_formData : (DotFormPost *)_formPost :(BOOL)_isFormIsSubForm :(NSMutableDictionary *)_dataForNextScreenDisplay :(NSMutableDictionary *)_dataForNextScreenPost;

-(void) initializeData;
-(void) initializeTitle;
-(void) initUpdateForm: (NSString *)trackId :(BOOL)isTracker;
-(void) initializeUpdateMode;

-(id) getGradientColor:(UIView *)myView;

-(void) initializeSection:(NSMutableArray *)compArray sectionData:(NSMutableDictionary *)sectData keysOfSection:(NSMutableArray *)sectKeys 
               withFormId:(NSString *)_formId;

-(void) updateNetworkStatus:(Reachability *) curReach;

-(NSString *) subFormInUpdateMode :(id)subFormDef: (NSString *)reportKey;

-(void) multiButtonPressed: (id)sender;
-(void) submitPressed: (id)sender;
-(void) addLineItemPressed: (id)sender;

- (BOOL) validateSubForm:(BOOL)isAddRow;
-(BOOL) validateForm;

//-(void) processDocId:(FormPost *)_formPost;

-(void) prepareFormPost;

-(NSMutableArray *) getHeaderData: (DotForm *)_formDef;
-(NSMutableArray *) getAddRowData: (DotForm *)_formDef;
-(NSMutableArray *) getRowElements: (DotForm *)_formDef reportData:(NSMutableArray *)rptData sectionKey:(NSString *)addRowKey
                                  :(BOOL)hasAddRow:(NSUInteger)secIndex;
  
-(void) addRowDataToFormPost: (NSNumber *)addRowNumber: (DotForm *)_formDef;
-(void) addReportElements: (NSMutableDictionary *)buttonData;

-(void) fillSubForm:(NSString *)sectionKey selectRowAtIndexPath:(NSIndexPath *)anIndexPath;
-(void) updateSubForm:(NSMutableDictionary *)buttonData;
-(void) prepareSubForm:(NSString *)subFormId didSelectRowAtSectionKey:(NSString *)sectionKey;
-(void) drawSubForm;

-(void) postRequest:(NSData *)postData :(BOOL)isSubmit;

-(NSMutableDictionary *) getSectionDataForDocumentView: (NSMutableArray *)keyList :(NSMutableDictionary *)headerData;

-(void) dismissLoadingView;

@end
