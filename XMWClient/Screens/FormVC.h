//
//  FormVC.h
//  XMW iOS Client
//
//  Created by Pradeep Singh on 03/06/2013.
//  Copyright 2013 Dotvik Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DotForm.h"
#import "DotFormPost.h"
#import "DotFormElement.h"

#import "DocPostResponse.h"
#import "MenuVC.h"
#import "MXButton.h"
//#import "MXBarButton.h"
#import "MXTextField.h"

#import "FormTableViewCell.h"
#import "ButtonTableViewCell.h"
#import "DropDownTableViewCell.h"
#import "CalendarTableViewCell.h"
#import "LabelTableViewCell.h"
#import "SearchTableViewCell.h"
#import "RadioTableViewCell.h"
#import "XmwcsConstant.h"
#import "XmwUtils.h"
#import "SearchFormControl.h"
#import "ReportVC.h"
#import "HttpEventListener.h"
#import "LoadingView.h"




 //for check box group
#import "MXTextField.h"
#import "MXButton.h"
#import "MXLabel.h" //for check box group


#import "DVCalendarController.h"

#import "DotMenuObject.h"
#import "SelectedListVC.h"
#import "NetworkHelper.h"

@class SearchFormControl;
@class AddRowFormUtils;
@class DVTableFormView;
@class DotFormDraw;

@protocol FormElementsControlDelegate <NSObject>

-(void) dropDownPickerDoneHandle:(DotFormElement*) ddFormElement;
@end

@protocol XmwCallnameForReportHandler <NSObject>
-(void) handleNetworkReportResponse:(ReportPostResponse*) reportPostResponse;
@end


@interface FormVC : UIViewController <UITextFieldDelegate, UISearchBarDelegate, DVCalendarControllerDelegate, HttpEventListener,SelectedPopUpdelegate,UIPickerViewDelegate>
{
    
@protected
    
    int screenId;
    // core members as similar to members of SimpleDotForm
    NSString *auth_Token;
	DotMenuObject *formData;
	DotFormPost *dotFormPost;
	BOOL isFormIsSubForm;
    NSMutableDictionary* forwardedDataDisplay;
    NSMutableDictionary* forwardedDataPost;
	NSString *lastFormId;
	NSString *dotFormId;
    DotForm *dotForm;

	
    
	NSArray *dotFormElements;
	NSMutableDictionary *inputFieldDictionary;			// Contains the component objects for all input values
	
	NSMutableArray *mandatoryTagList;					// Contains the list of tags of mandatory fields
	NSMutableDictionary *cellDropDownDictionary;
	
	NSString *headerStr;
	BOOL isOpenPicker;
	
	UIView *searchView;
	
	NSString *selectedDate;
	int selectedCalendarTag;
	NSString *selectedCalendarKey;
	
	NSString *selectedTextFieldKey;
	int selectedTextFieldTag;
    NSString * CustomerClaimValue;
    NSString * CustomerClaimKey;
    NSString * selectDropDownFieldKey;
    NSString * selectDropDownFieldValue;
    // Contains the list of values for selected dropdown
   
	NSMutableDictionary *dropDownDictionaryList;		// Contains the dropdown list elements with its key
	NSMutableArray *dropDownContentList;				// Contains the drop down component objects
	UIPickerView *dropDownPicker;
	UIToolbar* pickerDoneButtonView;
	//UINavigationBar* pickerDoneButtonView;				// For Search bar
	
	NSString *selectedButton;
	BOOL isSubmit;
	
	//LoadingView *loadingView;
	
	MenuVC *menuViewController;
	
	UISearchBar *sBar;
	NSString *selectedRadioKey;
	//DotFormElement *searchFormComponent;
	BOOL isSearch;
	BOOL searching;
	UINavigationController *navController;
	NSString *selectedSearchText;
	NSString *searchTableName;
	
	NSMutableArray *addedRowData;
    
    
    MXButton *checkBoxButton;
    
    
    
    //for check box group
    NSString *keyValue;
    NSString *textValue;
    
    MXTextField *checkBoxGroupField;
    MXButton *checkBoxGroupButton;
    MXLabel *titleLabel;
    MXLabel *mandatoryLabel;
    BOOL isCheckedGroup; //for check box group
    NSMutableArray *checkboxes;//for radio group
    
        
    NSMutableDictionary *componentMap;
        
    SearchFormControl *searchPopUp;
    
  
    
   
    UIScrollView* scrollFormView;
    
     int rowNoOfTable;
    UIView *addRowView;
    int yArguForAddRowFormDraw;
    UIView *mainFormContainer;
    
    LoadingView* loadingView;
    NetworkHelper *networkHelper;
    AddRowFormUtils *addRowFormUtils;
    
@protected
    DotFormDraw* dotFormDraw;
    NSMutableArray *fieldTag;
        
}
@property NSMutableArray *fieldTag;
@property DotMenuObject *formData;
@property UIScrollView* scrollFormView;

@property SearchFormControl *searchPopUp;
@property int screenId;
@property (nonatomic, retain) NSMutableArray *checkboxes;   // for radio button
@property (nonatomic, retain) MXButton *checkBoxButton;

@property (nonatomic, retain) NSString *headerStr;

@property (nonatomic, retain) NSString *selectedDate;
@property (readwrite) int selectedCalendarTag;

@property (nonatomic, retain) NSString *selectedRadioKey;

@property (nonatomic, retain) NSMutableArray *componentArray;

@property (nonatomic, retain) MenuVC *menuViewController;

@property (nonatomic, retain) UINavigationController *navController;

@property (nonatomic, retain) NSString *selectedSearchText;
@property (nonatomic, retain) NSString *selectedTextFieldKey;
@property (nonatomic, retain) NSMutableArray *addedRowData;

//for check box group
@property (nonatomic, assign) BOOL isCheckedGroup;
@property (nonatomic, retain) NSString *keyValue;
@property (nonatomic, retain) NSString *textValue;
@property MXButton* mxButton;
@property (nonatomic, retain) MXTextField *checkBoxGroupField;
@property (nonatomic, retain) MXButton *checkBoxGroupButton;
@property (nonatomic, retain) MXLabel *titleLabel;
@property (nonatomic, retain) MXLabel *mandatoryLabel; //for check box group

@property (nonatomic, strong) IBOutlet UILabel *periodLabel;
@property (nonatomic, strong) DVCalendarController *pmCC;

@property  NSMutableDictionary* forwardedDataDisplay;
@property NSMutableDictionary* forwardedDataPost;
@property DotForm *dotForm;
@property DotFormPost *dotFormPost;
@property BOOL isFormIsSubForm;
@property NSString *auth_Token;



// for PowerPlus, formVC added in the power plus VC as child VC
@property (nonatomic, assign) IBOutlet UIViewController *surrogateParent;
@property (nonatomic, assign) id<FormElementsControlDelegate> formControlDelegate;

// Initialization Methods

-(instancetype) initWithData:(DotMenuObject *) _formData : (DotFormPost *) _dotFormPost : (BOOL) _isFormIsSubForm : (NSMutableDictionary*) _forwardedDataDisplay : (NSMutableDictionary*) _forwardedDataPost;

-(instancetype) initWithNibName:(NSString*) nibNameOrNil : (DotMenuObject *)_formData : (DotFormPost *)_dotFormPost : (BOOL)_isFormIsSubForm : (NSMutableDictionary*) _forwardedDataDisplay : (NSMutableDictionary*) _forwardedDataPost;


-(void) initializePhoneData;
-(void)loadForm;
-(UIView*) rowFormInSameForm;

-(void) drawNavigationBar:(NSString *)title;

// Other Methods

-(NSMutableDictionary *) getButtonData:(DotFormElement *)component;

-(void) animateSearchView :(int) direction;
-(void) animatePicker :(int) direction;
- (void) setViewMovedUp : (BOOL)movedUp : (int)textField_Scroll;

-(int) dataTypeCheck:(NSString *)dataType;

-(NSMutableDictionary *) prepareDisplayData:(NSMutableDictionary *) _valueDictionary;
-(NSMutableDictionary *) prepareSendData:(NSMutableDictionary *) _valueDictionary;
-(void) postRequest:(NSData *)postData;

-(BOOL) isMaxDocIdExists:(NSString *)  _maxDocId;
-(BOOL) hasSearchElements:(NSString *) _tableName;
-(void) insertRequest:(DotFormPost *) _formPost;

-(void) dismissLoadingView;

-(NSMutableDictionary *) getSearchData:(NSString *)_tableName;

-(void) processRecentRequest:(DotFormPost *)_formPost : (DocPostResponse *) _docResponse;

-(NSString *) concatSearchData:(NSString *) code :  (NSString *) name;

-(IBAction) checkBoxClicked :(id) sender;
//for check box group
-(IBAction) checkBoxGroupClicked :(id) sender;
//for check box group

-(id) getDataFromId : (NSString *) objectId;
-(void) putToDataIdMap : (id) component : (NSString *) objectId;

-(void)searchItemSelected : (NSInteger)rowIdx : (NSMutableArray *)selectedRowElement: (NSString*)elementId : (NSString*)masterValueMapping;

-(IBAction) timeButtonPressed:(id) sender;
-(void)dismissTimePicker : (NSDate*) dismissTimePicker;

- (void) networkCall : (id) requestObject : (NSString*) callName;

-(DVTableFormView*) childTableForm:(CGRect) frame;

-(void) setFormEditable;

-(void) dropDownPickerDoneHandle:(DotFormElement*) ddFormElement;

-(void)barCodeScanButtonAction:(id) sender;
@end


