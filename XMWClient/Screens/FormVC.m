
//
//  FormVC
//  XMW iOS Form controller
//
//  Created by Ashish Tiwar / Pradeep Singh on 01/06/2013.
//  Copyright 2013 Dotvik Solutions. All rights reserved.
//


#import "FormVC.h"

#import "UIView+XMW.h"

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
#import "ClientVariable.h"
#import "DotFormPost.h"
#import "DotForm.h"
#import "XmwUtils.h"

#import "ClientMasterDetail.h"
#import "MXBarButton.h"
#import "CheckBoxButton.h"
#import "CheckBoxGroup.h"
#import "MXRadioButtonGroup.h"

#import "DotSearchComponent.h"
#import "SearchFormControl.h"
#import "DotFormElement.h"
#import "DotFormPostUtil.h"
#import "DVAppDelegate.h"
#import "DotDropDownPicker.h"
#import "DotFormDraw.h"
#import "AppConstants.h"

#import <sqlite3.h>
#import "DropDownTableViewCell.h"
#import "DVCalendarController.h"
#import "NSDate+Helpers.h"

#import "AddRowFormUtils.h"
#import "SearchRequestStorage.h"
#import "TimePickerViewController.h"
#import "DotFieldDataOperationUtils.h"
#import "DotRowContainer.h"
#import "TagKeyConstant.h"
#import "Styles.h"
#import "DVTableFormView.h"
#import "DotMenuObject.h"
#import "OrderFeedbackPopup.h"

#import "EditSearchField.h"
#import "BarcodeScanVC.h"

#import "BarCodeScanField.h"
#import "CustomerClaimInvoiceDetailsVC.h"
#import "MyClaimVC.h"
#import "CreateOrderVC2.h"
#import "SelectedListVC.h"
#import "AttachmentViewCell.h"
#import "ProgressBarView.h"
#import "SimpleEditForm.h"
#import "LogInVC.h"
#if 0
#import "ZBarSDK.h"
#endif



@interface FormVC ()
{
    UIView* pickerContainer;
   
}


@end



@implementation FormVC
{
    BOOL isKeyboardOpen;
    int  movedbyHeight;
    ProgressBarView *progressBarView;
    NSString *ufmrefid;
}


@synthesize fieldTag;
@synthesize formData;
@synthesize scrollFormView;
@synthesize screenId;
@synthesize headerStr,selectedDate,selectedRadioKey;
@synthesize selectedCalendarTag;
@synthesize componentArray;
@synthesize menuViewController;
@synthesize navController;
@synthesize selectedSearchText,selectedTextFieldKey;
@synthesize addedRowData;
@synthesize auth_Token;


@synthesize checkBoxButton;

//for check box group
@synthesize keyValue,textValue;

@synthesize checkBoxGroupField,checkBoxGroupButton;
@synthesize titleLabel,mandatoryLabel;

//for check box group

@synthesize checkboxes;// for radio group


@synthesize periodLabel;
@synthesize pmCC;

@synthesize searchPopUp;

@synthesize forwardedDataDisplay;
@synthesize forwardedDataPost;
@synthesize dotForm;
@synthesize dotFormPost;
@synthesize isFormIsSubForm;



static const CGFloat KEYBOARD_ANIMATION_DURATION       = 0.3;

SelectedListVC *selectedListVC;
DotDropDownPicker *dotDropDownPicker;
CGSize keyboardSize;
UITextField* activeTextField = nil;

#pragma mark Initialize View

-(instancetype) init
{
    self = [super init];
    if(self) {
        dotFormDraw = [[DotFormDraw alloc] init];
    
    }
    
    return self;
}

-(instancetype) initWithData : (DotMenuObject *)_formData : (DotFormPost *)_dotFormPost : (BOOL)_isFormIsSubForm : (NSMutableDictionary*) _forwardedDataDisplay : (NSMutableDictionary*) _forwardedDataPost
{
    self = [super initWithNibName:FORMVC bundle:nil];
	if ( self )
	{
		formData		= _formData;
		dotFormPost		= _dotFormPost;
		isFormIsSubForm = _isFormIsSubForm;
        dotFormDraw = [[DotFormDraw alloc] init];
        self.forwardedDataDisplay = _forwardedDataDisplay;
        self.forwardedDataPost = _forwardedDataPost;
    }
    return self;
}

-(instancetype) initWithNibName:(NSString*) nibNameOrNil : (DotMenuObject *)_formData : (DotFormPost *)_dotFormPost : (BOOL)_isFormIsSubForm : (NSMutableDictionary*) _forwardedDataDisplay : (NSMutableDictionary*) _forwardedDataPost
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if ( self )
    {
        formData		= _formData;
        dotFormPost		= _dotFormPost;
        isFormIsSubForm = _isFormIsSubForm;
        dotFormDraw = [[DotFormDraw alloc] init];
        self.forwardedDataDisplay = _forwardedDataDisplay;
        self.forwardedDataPost = _forwardedDataPost;
    }
    return self;
}


-(void) initializePhoneData
{
    ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    if(dotFormPost == nil) {
		dotFormPost			= [[DotFormPost alloc] init];
    }
    
    if(dotFormDraw == nil) {
        dotFormDraw = [[DotFormDraw alloc] init];
    }
	
    if(isFormIsSubForm) {
        lastFormId			=   formData.LAST_FORM_ID;
        //(NSString*) [formData  objectForKey: XmwcsConst_MENU_CONSTANT_LAST_FORM_ID] ;
    }
   
	
    dotFormId					=  formData.FORM_ID;//(NSString*) [formData  objectForKey: XmwcsConst_MENU_CONSTANT_FORM_ID] ;
    
    dotForm = (DotForm*) [clientVariables.DOT_FORM_MAP objectForKey: dotFormId] ;
	
	//formParam				= (DotForm *)[[[MXData getInstance] getFORM_DEFMAP] getString:[[NSString alloc] initWithString:formId]];
	
	dotFormElements			=  [XmwUtils  sortedDotFormElementIds : [dotForm formElements]];
	
	inputFieldDictionary	= [[NSMutableDictionary alloc] init];
	//postFieldDictionary		= [[NSMutableDictionary alloc] init];
	mandatoryTagList		= [[NSMutableArray alloc] init];
	cellDropDownDictionary	= [[NSMutableDictionary alloc] init];
	selectedCalendarTag		= -1;
	selectedTextFieldTag	= -1;										//**
	//selectedTextFieldKey	= [[NSString alloc] init];
	selectedCalendarKey		= [[NSString alloc] init];
	dropDownContentList		= [[NSMutableArray alloc] init];
	isSubmit				= NO;
    
    componentMap = [[NSMutableDictionary alloc]init];
    
    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    if(isiPhone10) {
        self.view.frame = CGRectMake(0, 64, 375, 748);
    }
    
    else if(isiPhone6Plus) {
        self.view.frame = CGRectMake(0, 64, 414, 672);
    }
    else if(isiPhone6) {
        self.view.frame = CGRectMake(0, 64, 375, 600);
    } else if(isiPhone5) {
        self.view.frame = CGRectMake(0, 64, 320, 504);
    } else {
        // 0, 64, 320, 416
        self.view.frame = CGRectMake(0, 64, 320, 416);
    }
    
	[self initializePhoneData];
    [self loadForm];
	[self drawNavigationBar:headerStr];
    [self drawHeaderItem];
    [self registerForKeyboardNotifications];

    
         
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
    
}

-(void) drawHeaderItem
{


    
   // self.navigationController.navigationBar.tintColor = [Styles barButtonTextColor];
  
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage
                                                                          imageNamed:@"back-button"]  style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(backHandler:)];


    
    backButton.tintColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
    
    
    UIImageView *polycabLogo = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"polycab_logo"]];
    self.navigationItem.titleView.contentMode = UIViewContentModeCenter;
    self.navigationItem.titleView = polycabLogo;
   [self.navigationItem setLeftBarButtonItem:backButton];

}


- (void) backHandler : (id) sender
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReportNeedRefresh" object:nil];

    [ [self navigationController]  popViewControllerAnimated:YES];
    
}

-(void)headerView:(NSString*)headername{
    NSLog(@"Header Name : %@",headername);
   
    UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(0, 10, self.scrollFormView.bounds.size.width, 0)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor: [UIColor blackColor]];
    [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [label setText: [headername uppercaseString]];
    
    [label setNumberOfLines: 0];
    [label sizeToFit];
    [label setCenter: CGPointMake(self.view.center.x, label.center.y)];
    [self.scrollFormView addSubview:label];
    
    
    
    
    
    
}


-(void)loadForm
{
   
    
    
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext]];
      
    scrollFormView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    scrollFormView.scrollEnabled = YES;
    scrollFormView.pagingEnabled = NO;
    scrollFormView.showsVerticalScrollIndicator = YES;
    scrollFormView.showsHorizontalScrollIndicator = NO;
    
    scrollFormView.delegate = self;
    addRowFormUtils = nil;

    
    [self.view addSubview:scrollFormView];
     [self headerView:headerStr];
    
    
   
    // mainFormContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320 , 480)];
    
    
    [dotFormDraw drawForm:dotForm :scrollFormView :self];
   // [scrollFormView addSubview:mainFormContainer];
    scrollFormView.contentSize = CGSizeMake(self.view.bounds.size.width, dotFormDraw.yArguForDrawComp);
    
    // [scrollFormView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin];
    



}

// make sure tag id used is 10000 in the DotFormDraw
-(UIView*) rowFormInSameForm
{
    return (UIView*)[scrollFormView viewWithTag:10000];
}


-(void) drawNavigationBar:(NSString *)title
{
	
	self.title = title;
    
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    // self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    UILabel*  titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
    //titleLabel.text = title;
    titleLabel.textColor = [Styles headerTextColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.navigationItem setTitleView: titleLabel];
	   
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    self.navigationItem.backBarButtonItem.tintColor = [Styles barButtonTextColor];
   
}



-(NSMutableDictionary *) getButtonData:(DotFormElement *)component
{
	NSMutableDictionary *butttonData = [[NSMutableDictionary alloc] init];
	/*[butttonData putWithString:[[NSString alloc] initWithString:@"INTEGRATION_ID"] :[[NSString alloc] initWithString:dotFormElements.dependedCompValue]];
	[butttonData putWithString:[[NSString alloc] initWithString:@"DISPLAY_REPORT"] :[[NSString alloc] initWithString:dotFormElements.valueSetCompName]];*/
	
	return butttonData;
}

#pragma mark Action Methods

-(IBAction) backAction:(id) sender
{
	if([sender isKindOfClass:[MXTextField class]])
	{
		[(MXTextField *)sender resignFirstResponder];
		[self setViewMovedUp:NO :0];
	}
	[UIView commitAnimations];
    

	[self.navigationController popViewControllerAnimated:YES];
}


-(void) dismissLoadingView
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//	[loadingView removeView];
}

-(IBAction) submitPressed:(id) sender
{
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext]];
    MXButton* button = (MXButton*) sender;
    NSString* attachedData = (NSString*)button.attachedData;
        
    DotFormElement *dotFormElement = [dotForm.formElements objectForKey:button.elementId];
    selectedTextFieldKey = ((MXButton *)sender).elementId;

    DotFormPostUtil *dotFormPostUtil = [[DotFormPostUtil alloc]init];
    if([attachedData isEqualToString:XmwcsConst_DE_BUTTON_DATA_TYPE_FORM_SUBMIT] || [attachedData isEqualToString:XmwcsConst_DE_BUTTON_DATA_TYPE_VIEW_REPORT]) {
        // [dotFormPostUtil mandatoryCheck : dotForm : self];
        [dotFormPostUtil checkTypeOfFormAndSubmit:dotForm :self : dotFormPost :forwardedDataDisplay :forwardedDataPost :true :dotFormElement];
    }
    
    else if ([attachedData isEqualToString:XmwcsConst_DE_BUTTON_DATA_TYPE_NEXT]) {
     
        
          [dotFormPostUtil checkTypeOfFormAndSubmit:dotForm :self : dotFormPost :forwardedDataDisplay :forwardedDataPost :false :dotFormElement];

    }
    
    else if ([attachedData isEqualToString:XmwcsConst_DE_BUTTON_DATA_TYPE_ADD_ROW]){
               
      UIView* tableContainer =  [scrollFormView viewWithTag:TAG_FORM_TABLE_CONTAINER];
        if(tableContainer==nil) {
            tableContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
            tableContainer.tag = TAG_FORM_TABLE_CONTAINER;
            rowNoOfTable = 0;
            [scrollFormView insertSubview:tableContainer belowSubview:mainFormContainer];
        }
        
        rowNoOfTable++;
        if(addRowFormUtils == nil) {
            addRowFormUtils = [[AddRowFormUtils alloc]init];
        }
        
        int errorCheck =  [addRowFormUtils addDocDetailAsRow : dotFormId : rowNoOfTable : dotFormPost : self : tableContainer : true];
        if(errorCheck>0) {
            yArguForAddRowFormDraw =  errorCheck;
            mainFormContainer.frame = CGRectMake(0, yArguForAddRowFormDraw, 320, dotFormDraw.yArguForDrawComp);
            int y = dotFormDraw.yArguForDrawComp + yArguForAddRowFormDraw + 60;
            scrollFormView.contentSize = CGSizeMake(self.view.bounds.size.width,y);
        } else {
            rowNoOfTable--;
        }
    }
    
}


- (void) networkCall : (id) requestObject : (NSString*) callName
{
    loadingView = [LoadingView loadingViewInView:self.view];
    NetworkHelper *networkHelper = [[NetworkHelper alloc] init];
    [networkHelper makeXmwNetworkCall:requestObject :self : nil :callName];
}

-(IBAction)fileAttactmentButtonPressed:(id)sender{
    MXButton* button = (MXButton*) sender;
    self.mxButton = (MXButton*) sender;


    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@"Take a Photo",@"Gallery",nil];
    
    UIAlertView *fileAttachmentAlertView = [[UIAlertView alloc] initWithTitle:@"File Upload"
                                                        message:nil delegate:self
                                              cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    
    fileAttachmentAlertView.alertViewStyle = UIAlertViewStyleDefault;
    
    for(NSString *buttonTitle in array)
    {
        [fileAttachmentAlertView addButtonWithTitle:buttonTitle];
    }
    fileAttachmentAlertView.tag = 100; //handle alertview action according to tag
    
    [fileAttachmentAlertView show];
   
    
}

- (void)takePhoto {
    
    if (! [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *deviceNotFoundAlert = [[UIAlertView alloc] initWithTitle:@"No Device" message:@"Camera is not available"
                                                                     delegate:nil
                                                            cancelButtonTitle:@"Okay"
                                                            otherButtonTitles:nil];
        [deviceNotFoundAlert show];
        
    } else {
        
        UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
        cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraPicker.allowsEditing = YES;
        cameraPicker.delegate =self;
        [self presentViewController:cameraPicker animated:YES completion:nil];
    }
    
    
}
- (void)selectPhotoFromGallery {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    AttachmentViewCell *fileAttach =[(AttachmentViewCell *) self.view viewWithTag:1000]; //get view with tag 1000 tag define in dotformDraw 
    UIImage *originalImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    [fileAttach.imageView setImage:originalImage];
    [fileAttach.imageViewAttachButton setEnabled:NO];
    
      NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    if ([info objectForKey:UIImagePickerControllerReferenceURL] == NULL) {
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd_MM_yyyy HH:mm"];
        // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
        NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
        NSString *clickImageDate = [dateFormatter stringFromDate:[NSDate date]];
        
        [dict setObject:clickImageDate forKey:@"image_id"];
        [dict setObject:self.dotForm.formId forKey:@"formID"];
        
    }
    
    else{
    NSString *imagePath = [[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
    
    NSRange r1 = [imagePath rangeOfString:@"id="];
    NSRange r2 = [imagePath rangeOfString:@"&ext="];
    NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
    NSString *sub = [imagePath substringWithRange:rSub];
    NSLog(@"image id %@",sub);
    
    [dict setObject:sub forKey:@"image_id"];
    [dict setObject:self.dotForm.formId forKey:@"formID"];
    
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    CGFloat newwidth = 960;
    CGFloat newheight = (originalImage.size.height / originalImage.size.width) * newwidth;
    
    CGRect rect = CGRectMake(0.0,0.0,newwidth,newheight);
    UIGraphicsBeginImageContext(rect.size);
    [originalImage drawInRect:rect];
    originalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    

    NSData *data = UIImageJPEGRepresentation (
                                              originalImage,
                                              0.0
                                              );
  
    
    
    progressBarView = [ProgressBarView progressBarViewInView:fileAttach.imageView];
    networkHelper = [[NetworkHelper alloc] init];
    
   [networkHelper makeXmwNetworkCallForImagePost:dict :self : nil :@"ImagePostDataRequest" : data];

    
    
    

}




- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];

}
-(IBAction) dropDownPressed:(id) sender
{
        MXButton* button = (MXButton*) sender;
    
       self.mxButton = (MXButton*) sender;
    
    


        selectedTextFieldTag = ((MXButton *)sender).tag;
        NSLog(@"%@",((MXButton *)sender).tag);
        selectedTextFieldKey = ((MXButton *)sender).elementId;



        NSMutableArray* dropDownList = [[NSMutableArray alloc] init];

        NSMutableArray* dropDownListKey = [[NSMutableArray alloc] init];

        NSMutableArray *keys = button.attachedData[0];
        NSMutableArray *values =button.attachedData[1];


        [dropDownListKey addObjectsFromArray : keys];

        [dropDownList addObjectsFromArray : values];




      // dropDownList = [[NSMutableArray alloc] initWithArray: ((MXButton*)sender).attachedData[1]];

    selectedListVC=[[SelectedListVC alloc]initWithNibName:@"SelectedListVC" bundle:nil];
    selectedListVC.dropDownList = dropDownList;
    selectedListVC.dropDownListKey = dropDownListKey;
    selectedListVC.delegate=self;
    
    [self.navigationController pushViewController:selectedListVC animated:YES];
    
    
//        pickerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 216.0f, self.view.frame.size.width, 216.0f)];
//
//
//        dotDropDownPicker = [[DotDropDownPicker alloc]initWithFrame:CGRectMake(0.0, 40, self.view.frame.size.width, 216)];
//        dotDropDownPicker.backgroundColor = [UIColor whiteColor];
//
//
//        dotDropDownPicker.dropDownList = dropDownList;
//        dotDropDownPicker.dropDownListKey = dropDownListKey;
//
//        dotDropDownPicker.tag            = ((MXButton *)sender).tag;
//
//
//        dotDropDownPicker.delegate        = dotDropDownPicker;
//        dotDropDownPicker.dataSource    = dotDropDownPicker;
//        [dotDropDownPicker setShowsSelectionIndicator:YES];
//
//        pickerDoneButtonView = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 40)];
//        pickerDoneButtonView.barStyle = UIBarStyleBlackTranslucent;
//        [pickerDoneButtonView sizeToFit];
//
//
//        MXBarButton *doneButton = [[MXBarButton alloc] initWithTitle:@"Done"
//                                                               style:UIBarButtonItemStyleBordered  target:self
//                                                               action:@selector(donePicker:)];
//        doneButton.elementId = [button elementId];
//        doneButton.attachedData = [button attachedData];
//
//        MXBarButton *BtnSpace = [[MXBarButton alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//        MXBarButton *leftButton = [[MXBarButton alloc] initWithTitle:@"Cancel"
//                                                               style:UIBarButtonItemStyleBordered  target:self
//                                                              action:@selector(cancelBarButtonPressed:)];
//
//
//        if(searching)
//        {
//
//        }
//        else    dropDownList = [[NSMutableArray alloc] initWithArray: ((MXButton*)sender).attachedData[1]];
//        {
//            [pickerDoneButtonView setItems:[NSArray arrayWithObjects:leftButton, BtnSpace,doneButton, nil]];
//        }
//
//        dropDownPicker = dotDropDownPicker;
//
//        [pickerContainer addSubview:pickerDoneButtonView];
//        [pickerContainer addSubview:dotDropDownPicker];
//
//        [[UIApplication sharedApplication].keyWindow addSubview:pickerContainer];

}

-(IBAction) dropDownSearchPressed:(id) sender
{
   
        MXButton* button = (MXButton*) sender;
        DotFormElement *searchFormComponent = [dotForm.formElements objectForKey:button.elementId];
		
		selectedTextFieldTag = ((MXButton *)sender).tag;
		selectedTextFieldKey = ((MXButton *)sender).elementId;
        
        if([sender isKindOfClass:MXButton.class])
        {
            selectedTextFieldKey = ((MXButton *)sender).elementId;
        
        }
        NSLog(@"value id :%@",selectedTextFieldKey);
              
    
        pickerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 216.0f, self.view.frame.size.width, 216.0f)];
       	
        dotDropDownPicker = [[DotDropDownPicker alloc]initWithFrame:CGRectMake(0.0f, 40.0f, [UIScreen mainScreen].bounds.size.width, 216)];
        
        dotDropDownPicker.dropDownList = [[NSMutableArray alloc] initWithArray: ((MXButton*)sender).attachedData[1]];
        dotDropDownPicker.dropDownListKey = [[NSMutableArray alloc] initWithArray: ((MXButton*)sender).attachedData[0]];
		dotDropDownPicker.tag			= ((MXButton *)sender).tag;
		dotDropDownPicker.delegate		= dotDropDownPicker;
		dotDropDownPicker.dataSource	= dotDropDownPicker;
		[dotDropDownPicker setShowsSelectionIndicator:YES];
        dotDropDownPicker.backgroundColor = [UIColor whiteColor];
		
		pickerDoneButtonView = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width , 40)];
		pickerDoneButtonView.barStyle = UIBarStyleBlackTranslucent;
		[pickerDoneButtonView sizeToFit];
        
        		
		MXBarButton *doneButton = [[MXBarButton alloc] initWithTitle:@"Done"
                                                               style:UIBarButtonItemStyleBordered  target:self
                                                              action:@selector(doneSearchPicker:)];
        
        MXBarButton *leftButton = [[MXBarButton alloc] initWithTitle:@"Cancel"
                                                               style:UIBarButtonItemStyleBordered  target:self
                                                              action:@selector(cancelBarButtonPressed:)];
       
        doneButton.elementId = [button elementId];
        doneButton.attachedData = [button attachedData];
        
        
        
		
		MXBarButton *BtnSpace = [[MXBarButton alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
		
       
		if(searching)
		{
			
		}
		else
		{
            [pickerDoneButtonView setItems:[NSArray arrayWithObjects:leftButton, BtnSpace, doneButton, nil]];
		}
        
        dropDownPicker = dotDropDownPicker;
        
		[pickerContainer addSubview:pickerDoneButtonView];
		[pickerContainer addSubview:dotDropDownPicker];
    
    [[UIApplication sharedApplication].keyWindow addSubview:pickerContainer];
    
    
}
                                       
-(IBAction)cancelBarButtonPressed:(id)sender
{
    [pickerContainer removeFromSuperview];
    
}

-(IBAction) doneSearchPicker :(id) sender
{
    if(searching)
	{
		[self animatePicker:0];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		
		searching		= NO;
	}
    MXBarButton* button = (MXBarButton*) sender;
    DotFormElement *searchFormComponent = [dotForm.formElements objectForKey:button.elementId];

    
	NSMutableDictionary *searchButtonData = [[NSMutableDictionary alloc] init];
	
	if([sender isKindOfClass:MXButton.class])
	{
		selectedTextFieldKey = ((MXButton *)sender).elementId;
		searchButtonData = (NSMutableDictionary *)((MXButton *)sender).attachedData;
	}
	else if([sender isKindOfClass:MXBarButton.class])
	{
		selectedTextFieldKey = ((MXBarButton *)sender).elementId;
		searchButtonData = (NSMutableDictionary *)((MXBarButton *)sender).attachedData;
	}
	
        
	NSString *groupName;
    NSString *masterValueMapping;
    NSString *elementId;
    for(DotFormElement *comp in componentArray)
	{
		if([comp.elementId isEqualToString:selectedTextFieldKey])
			searchFormComponent = comp;
	}
	groupName					= searchFormComponent.dependedCompName;
    masterValueMapping        = searchFormComponent.masterValueMapping;
    elementId                  =searchFormComponent.elementId;
    
    if([dotDropDownPicker.selectedPickerValue isEqualToString: @"None"])
    {
        DropDownTableViewCell *dropDownCell = [self getDataFromId:selectedTextFieldKey];
        MXTextField *dropDownField = dropDownCell.dropDownField;
        dropDownField.keyvalue = dotDropDownPicker.selectedPickerKey;
        dropDownField.text = dotDropDownPicker.selectedPickerValue;

        
    }
   else if([dotDropDownPicker.selectedPickerValue isEqualToString: @"Search"])
   {
       
    DotSearchComponent *searchObject = [[DotSearchComponent alloc]init];
    NSMutableArray *searchValues = [searchObject getRadioGroupData: groupName];
    
	
    CGRect textFrame = CGRectMake(0,0,320,320);//(20, 90, 280, 300) ;
       searchPopUp = [[SearchFormControl alloc]initWithFrame:textFrame : searchValues : 0 : self : masterValueMapping : elementId : searchFormComponent.displayText];
    [self.view  addSubview : searchPopUp];
    
   }else
   {
       if(dotDropDownPicker.selectedPickerKey ==0)
       {
           dotDropDownPicker.selectedPickerKey = [dotDropDownPicker.dropDownListKey objectAtIndex:0];
           dotDropDownPicker.selectedPickerValue = [dotDropDownPicker.dropDownList objectAtIndex:0];
       }
       DropDownTableViewCell *dropDownCell = [self getDataFromId:selectedTextFieldKey];
       MXTextField *dropDownField = dropDownCell.dropDownField;
       dropDownField.keyvalue = dotDropDownPicker.selectedPickerKey;
       dropDownField.text = dotDropDownPicker.selectedPickerValue;
   }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];

    [pickerContainer removeFromSuperview];
    
    [UIView commitAnimations];
   
}

// Pradeep:
// this is added to handle search click for edit searchable control
//
-(void) editSearchAction:(id) sender
{
    
    MXButton* button = (MXButton*) sender;
    
    DotFormElement *searchFormComponent = [dotForm.formElements objectForKey:button.elementId];
    
    
    NSMutableDictionary *searchButtonData = [[NSMutableDictionary alloc] init];
    
    if([sender isKindOfClass:MXButton.class])
    {
        selectedTextFieldKey = ((MXButton *)sender).elementId;
        searchButtonData = (NSMutableDictionary *)((MXButton *)sender).attachedData;
    }
    
    
    NSString *groupName;
    NSString *masterValueMapping;
    NSString *elementId;
    for(DotFormElement *comp in componentArray)
    {
        if([comp.elementId isEqualToString:selectedTextFieldKey])
            searchFormComponent = comp;
    }
    groupName					= searchFormComponent.dependedCompName;
    masterValueMapping        = searchFormComponent.masterValueMapping;
    elementId                  =searchFormComponent.elementId;
    
    DotSearchComponent *searchObject = [[DotSearchComponent alloc]init];
    NSMutableArray *searchValues = [searchObject getRadioGroupData: groupName];
    
    
    CGRect textFrame = CGRectMake(0,0,320,320);//(20, 90, 280, 300) ;
    searchPopUp = [[SearchFormControl alloc]initWithFrame:textFrame : searchValues : 0 : self : masterValueMapping : elementId : searchFormComponent.displayText];
    [self.view  addSubview : searchPopUp];

}

-(IBAction) donePicker:(id) sender
{
    MXBarButton* doneButton = (MXBarButton*)sender;
    
     [self animatePicker:0];
     [UIView beginAnimations:nil context:NULL];
     [UIView setAnimationDuration:0.5];
    if(dotDropDownPicker.selectedPickerKey ==0)
    {
        dotDropDownPicker.selectedPickerKey = [dotDropDownPicker.dropDownListKey objectAtIndex:0];
        dotDropDownPicker.selectedPickerValue = [dotDropDownPicker.dropDownList objectAtIndex:0];
    }
   
    
    MXTextField *dropDownField = (MXTextField *) [self getDataFromId:doneButton.elementId];
    dropDownField.keyvalue = dotDropDownPicker.selectedPickerKey;
    dropDownField.text = dotDropDownPicker.selectedPickerValue;

    //my code
    CustomerClaimValue=dotDropDownPicker.selectedPickerValue;
    CustomerClaimKey =dotDropDownPicker.selectedPickerKey;
    selectDropDownFieldKey =dotDropDownPicker.selectedPickerKey;
    selectDropDownFieldValue =dotDropDownPicker.selectedPickerValue;
    //
   
    searching = NO;
    
    if( [[DVAppDelegate currentModuleContext] isEqualToString: XmwcsConst_APP_MODULE_ESS] &&
       [dotForm.formId isEqualToString : @"DOT_FORM_34"] &&
       [dropDownField.elementId isEqualToString : @"RM_MODE"])
    {
        NSLog(@"I am inside special handling for dot_form_34");
        if([dropDownField.keyvalue isEqualToString:@"02"]) {
            [self changeToEditableTotalAmount];
        } else {
            [self changeToUneditableTotalAmount];
            
            DotFormElement* formElement = [dotForm.formElements valueForKey:dropDownField.elementId];
            NSArray* list = [self getDependedDropDownValue :dropDownField.keyvalue :formElement.valueSetCompName  :formElement.dependedCompName];
            
            ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext]];
            UIView* rowCont = nil;
            NSNumber* tagNumber = [dotFormDraw.tag_elementId_map objectForKey:formElement.dependedCompName];
            if(tagNumber!=nil) {
                rowCont = [mainFormContainer viewWithTag:tagNumber.intValue ];
            }
            int tagVal = [dotFormDraw removeFormRowContainer :mainFormContainer : formElement.dependedCompName];
            
            
            DotFormElement* dependFormElement = [dotForm.formElements objectForKey:formElement.dependedCompName];
            
            UIView* dependentDropDownRowCont = [dotFormDraw drawDropDown :self :dependFormElement  customMaster:(id) list];
            dependentDropDownRowCont.tag = tagVal;
        
            dependentDropDownRowCont.frame = CGRectMake(0, rowCont.frame.origin.y, dependentDropDownRowCont.frame.size.width, dependentDropDownRowCont.frame.size.height);
            
            [dotFormDraw insertFormRowContainer : mainFormContainer : dependentDropDownRowCont : tagVal];
        
        }
    } else {
        DotFormElement* formElement = [dotForm.formElements valueForKey:dropDownField.elementId];
        [self dropDownPickerDoneHandle:formElement];
    }
    
    [pickerContainer removeFromSuperview];
    
    [UIView commitAnimations];

}

-(void) cancel:(SelectedListVC*) selectedListVC context:(NSString*) context;
{
    isOpenPicker = YES;
    
}
-(void) done:(SelectedListVC*) selectedListVC context:(NSString*) context code:(NSString*) code display:(NSString*) display;
{
    //for polycab chnage some handling
    NSString *search= [self.mxButton.elementId stringByReplacingOccurrencesOfString:@"_button" withString:@""];
    MXTextField *dropDownField = (MXTextField *) [self getDataFromId:search];
    
    
    
    // this code for set selected reg id
    if ([dropDownField.elementId isEqualToString:@"REGISTRY_ID"]) {
        regIDCheck = YES;
        [[NSUserDefaults standardUserDefaults ] setObject:display forKey:@"selectedRegisterID"];
        [[NSUserDefaults standardUserDefaults ] setObject:code forKey:@"selectedRegisterIDCode"];
    }

    
   //// for employee dependent drop down add code
    MXButton *customerAccountButton = (MXButton*)[self getDataFromId:@"CUSTOMER_ACCOUNT_button"];
    if (customerAccountButton !=nil) {
        NSMutableArray *key = [[NSMutableArray alloc]init];
        NSMutableArray *value = [[NSMutableArray alloc]init];
        NSMutableArray *customerAccountButtonDropDownArray = [[NSMutableArray alloc]init];
        
        NSString *selectKey = [@"BUSINESS_VERTICAL_" stringByAppendingString:code];
        NSMutableArray *getDataArray = [[NSMutableArray alloc]init];
        [getDataArray addObjectsFromArray:[masterDataForEmployee  valueForKey:selectKey]];
        NSLog(@"%@",getDataArray);
        
        for (int i=0; i<getDataArray.count; i++) {
            [key addObject: [[getDataArray objectAtIndex:i] objectAtIndex:0]];
            [value addObject: [[getDataArray objectAtIndex:i] objectAtIndex:1]];
        }
        
    
        [customerAccountButtonDropDownArray addObject:key];
        [customerAccountButtonDropDownArray addObject:value];
        
        if (getDataArray.count !=0) {
            MXTextField *customerAccountdropDownField = (MXTextField *) [self getDataFromId:@"CUSTOMER_ACCOUNT"];
            customerAccountdropDownField.text = @"";
            customerAccountButton.attachedData = customerAccountButtonDropDownArray;
        }
    }
    NSLog(@"accessoryView details %@",   [customerAccountButton description]);
    /////  for employee add new code 999 to 1027
    
    
    dropDownField.keyvalue = code;
    dropDownField.text = display;
    
    isOpenPicker = YES;
    pickerDoneButtonView.hidden = YES;
    dotDropDownPicker.hidden = YES;
    searching = NO;
    
    if( [[DVAppDelegate currentModuleContext] isEqualToString: XmwcsConst_APP_MODULE_ESS] &&
       [dotForm.formId isEqualToString : @"DOT_FORM_34"] &&
       [dropDownField.elementId isEqualToString : @"RM_MODE"])
    {
        NSLog(@"I am inside special handling for dot_form_34");
        if([dropDownField.keyvalue isEqualToString:@"02"] || [dropDownField.keyvalue isEqualToString:@"04"] || [dropDownField.keyvalue isEqualToString:@"05"]) {
            [self changeToEditableTotalAmount];
        } else {
            [self changeToUneditableTotalAmount];
            
            DotFormElement* formElement = [dotForm.formElements valueForKey:dropDownField.elementId];
            NSArray* list = [self getDependedDropDownValue :dropDownField.keyvalue :formElement.valueSetCompName  :formElement.dependedCompName];
            
            ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext]];
            UIView* rowCont = nil;
            NSNumber* tagNumber = [dotFormDraw.tag_elementId_map objectForKey:formElement.dependedCompName];
            if(tagNumber!=nil) {
                rowCont = [scrollFormView viewWithTag:tagNumber.intValue ];
            }
            int tagVal = [dotFormDraw removeFormRowContainer :scrollFormView : formElement.dependedCompName];
            
            
            DotFormElement* dependFormElement = [dotForm.formElements objectForKey:formElement.dependedCompName];
            
            UIView* dependentDropDownRowCont = [dotFormDraw drawDropDown :self :dependFormElement  customMaster:(id) list];
            dependentDropDownRowCont.tag = tagVal;
            
            dependentDropDownRowCont.frame = CGRectMake(0, rowCont.frame.origin.y, dependentDropDownRowCont.frame.size.width, dependentDropDownRowCont.frame.size.height);
            
            [dotFormDraw insertFormRowContainer : scrollFormView : dependentDropDownRowCont : tagVal];
            
        }
    } else {
        
        DotFormElement* formElement = [dotForm.formElements valueForKey:dropDownField.elementId];
        [self dropDownPickerDoneHandle:formElement];
    }
    
    [UIView commitAnimations];
    
}




// override this method in your class for any specific custom handling
-(void) dropDownPickerDoneHandle:(DotFormElement*) ddFormElement
{
    if(self.formControlDelegate != nil && [self.formControlDelegate respondsToSelector:@selector(dropDownPickerDoneHandle:) ]) {
        [self.formControlDelegate dropDownPickerDoneHandle:ddFormElement];
    }
    NSString* eventDetail = ddFormElement.eventDetail;
    
    if(eventDetail!=nil && [eventDetail length]>0) {
        
        NSString* eventAction = [XmwUtils getPropertyValue : eventDetail :XmwcsConst_DE_EVENT_DETAIL_EVENT_ACTION];
        NSArray* selectedValueVector = [XmwUtils breakStringTokenAsVector : eventAction : @"$"];
        NSString* result = [DotFieldDataOperationUtils operationLostFocus : selectedValueVector :  self ];
        NSString* eventSet = [XmwUtils getPropertyValue : eventDetail : XmwcsConst_DE_EVENT_DETAIL_REFRESH_FIELD];
        
        NSLog(@"eventDetails = %@", eventDetail);
        NSLog(@"result = %@", result);
        NSLog(@"eventSet = %@", eventSet);
        
        if ([result isEqualToString : XmwcsConst_BOOLEAN_VALUE_FALSE] ) {
            NSString* message = [XmwUtils getPropertyValue : eventDetail :XmwcsConst_DE_EVENT_EVENT_ALERT_WINODW];
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"mKonnect Alert" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
            myAlertView.tag = 3;
            [myAlertView show];
            
        } else {
            [DotFieldDataOperationUtils setComponentValue : eventSet : self : result ];
        }
    }
    
}

-(void) changeToEditableTotalAmount
{
    UIView* rmAmtCont = nil;
    
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext]];
    
    [dotFormDraw hideFormRowContainer :mainFormContainer : @"RM_DIST" : YES];
    [dotFormDraw hideFormRowContainer :mainFormContainer : @"RM_RATE" : YES];
    [dotFormDraw hideFormRowContainer :mainFormContainer : @"PARKING" : YES];
    
    
    UIView* childCont = nil;
    NSNumber* tagNumber = [dotFormDraw.tag_elementId_map objectForKey:@"RM_AMT"];
    if(tagNumber!=nil) {
        childCont = [mainFormContainer viewWithTag:tagNumber.intValue ];
    }
    
    int tagVal = [dotFormDraw removeFormRowContainer :mainFormContainer : @"RM_AMT"];
    
    DotFormElement* formElement = [dotForm.formElements valueForKey:@"RM_AMT"];
    rmAmtCont = [dotFormDraw drawTextField:self :formElement :false];
    rmAmtCont.tag = tagVal;
    rmAmtCont.frame = CGRectMake(0, childCont.frame.origin.y, rmAmtCont.frame.size.width, rmAmtCont.frame.size.height);
    
    [dotFormDraw insertFormRowContainer : mainFormContainer : rmAmtCont : tagVal];
}

-(void) changeToUneditableTotalAmount
{
    UIView* rmAmtCont = nil;
    
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext]];
    
    [dotFormDraw hideFormRowContainer :mainFormContainer : @"RM_DIST" : NO];
    [dotFormDraw hideFormRowContainer :mainFormContainer : @"RM_RATE" : NO];
    [dotFormDraw hideFormRowContainer :mainFormContainer : @"PARKING" : NO];
    
    
    UIView* childCont = nil;
    NSNumber* tagNumber = [dotFormDraw.tag_elementId_map objectForKey:@"RM_AMT"];
    if(tagNumber!=nil) {
        childCont = [mainFormContainer viewWithTag:tagNumber.intValue ];
    }
    
    
    int tagVal = [dotFormDraw removeFormRowContainer :mainFormContainer : @"RM_AMT"];

    
    DotFormElement* formElement = [dotForm.formElements valueForKey:@"RM_AMT"];
    rmAmtCont = [dotFormDraw drawLabel:self: formElement];
    rmAmtCont.tag = tagVal;
    rmAmtCont.frame = CGRectMake(0, childCont.frame.origin.y, rmAmtCont.frame.size.width, rmAmtCont.frame.size.height);
    
    [dotFormDraw insertFormRowContainer : mainFormContainer : rmAmtCont : tagVal];
}


- (NSArray*) getDependedDropDownValue : (NSString*) selectedValue :  (NSString*)valueSetElementName :(NSString*) refersedDDMasterValueMapping
{
	NSArray* selectedValueVector = [XmwUtils breakStringTokenAsVector : selectedValue : @"$"];
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext]];

    NSArray* valueMappingData = [clientVariables.CLIENT_APP_MASTER_DATA objectForKey:valueSetElementName];
	NSMutableArray* dropDownCode = [[NSMutableArray alloc] init];
    
	for (int cntValueMapping = 0; cntValueMapping < valueMappingData.count; cntValueMapping++) {
		NSArray* mappedElement = [valueMappingData objectAtIndex:cntValueMapping];
		BOOL elementFlag = YES;
		for (int cntOneRecord = 0; cntOneRecord < mappedElement.count - 1 && elementFlag; cntOneRecord++) {
			NSString* serviceMappedElement = [mappedElement objectAtIndex:cntOneRecord];
			NSString* valueSelected = [selectedValueVector objectAtIndex:cntOneRecord];
			if (![serviceMappedElement isEqualToString:valueSelected]) {
				elementFlag = NO;
				break;
			}
		}
		if (elementFlag) {
            [dropDownCode addObject:[mappedElement objectAtIndex:mappedElement.count - 1 ]];
		}
	}
    NSMutableDictionary* dropDownValueService = [clientVariables.CLIENT_APP_MASTER_DATA objectForKey:refersedDDMasterValueMapping];
	NSMutableArray* returnKey = [[NSMutableArray alloc] init];
	NSMutableArray* returnValue = [[NSMutableArray alloc] init];
	// I am not using None
	for (int cntRefreshDD = 0; cntRefreshDD < (dropDownCode.count); cntRefreshDD++) {
		NSString* value = [dropDownValueService objectForKey:[dropDownCode objectAtIndex:cntRefreshDD] ];
		[returnKey addObject: [dropDownCode objectAtIndex:cntRefreshDD ]];
		[returnValue addObject : value];
	}
	NSMutableArray* returnList = [[NSMutableArray alloc] init];
	[returnList addObject : returnKey];
	[returnList addObject : returnValue];
	return returnList;
}


// - (void)calendarPressed:(UITapGestureRecognizer *) recognizer {
-(IBAction) calendarPressed:(id) sender
{
    
    NSDate* defCal = [[NSDate alloc] init];
    NSDate* minCal = [[NSDate alloc] init];
    NSDate* maxCal = [[NSDate alloc] init];
    
	selectedCalendarKey = ((MXButton *)sender).elementId;
    DotFormElement* dotFormElement = [[self.dotForm formElements ] objectForKey:selectedCalendarKey];
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext]];
    
    NSMutableArray* serverDate = clientVariables.CLIENT_LOGIN_RESPONSE.serverDateTime;
    if( (serverDate!=nil) && ([serverDate count]>2)) {
        NSDateComponents* dateComp = [[NSDateComponents alloc] init];
        
        dateComp.year = [[serverDate objectAtIndex:0] intValue]; // 0 is year
        dateComp.month = [[serverDate objectAtIndex:1] intValue] + 1; // 1 is month
        dateComp.day = [[serverDate objectAtIndex:2] intValue];
        
        NSString* defDate = [XmwUtils getPropertyValue:dotFormElement.defaultVal :XmwcsConst_DE_DATE_DEFAULT];
        if([defDate length]>0) {
            NSArray* dateArr = [defDate componentsSeparatedByString:@"/"];
            
            if([[dateArr objectAtIndex:0] isEqualToString:@"99"]) {
                dateComp.day =  1;
            } else {
                if([dateArr count]>2) {
                    
                    if(![[dateArr objectAtIndex:1] isEqualToString:@"0"]) {
                        dateComp.day =  1;
                        NSString* monthStr = [dateArr objectAtIndex:1];
                        dateComp.month =  dateComp.month + [monthStr intValue ];
                    } else {
                        dateComp.day =  dateComp.day + [[dateArr objectAtIndex:0] intValue];
                        NSString* monthStr = [dateArr objectAtIndex:1];
                        dateComp.month =  dateComp.month + [monthStr intValue ];
                    }
                }
            }

        }
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSGregorianCalendar];
        defCal = [gregorian dateFromComponents:dateComp];
    }
    
    //for minimum date condition
	NSString* minDate = [XmwUtils getPropertyValue:dotFormElement.defaultVal :XmwcsConst_DE_DATE_LOWER_LIMIT];
    if([minDate length]>0) {
        NSArray* dateArr = [minDate componentsSeparatedByString:@"/"];
        @try {
            NSString* date  = [dateArr objectAtIndex:0];
            NSString* month = [dateArr objectAtIndex:1];
            NSString* year = [dateArr objectAtIndex:2];
            
            NSCalendar *gregorian = [[NSCalendar alloc]
                                     initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *dateComp =[gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:minCal];
            dateComp.year = dateComp.year + year.integerValue;
            if(month.integerValue!=0) {
                dateComp.month = dateComp.month + month.integerValue;
                dateComp.day = 1;
            } else {
                dateComp.day = dateComp.day + date.integerValue;
            }
            minCal = [gregorian dateFromComponents:dateComp];
        }
        @catch (NSException *exception) {
            NSLog(@"Lower Limit Date exception : %@ ", exception.description );
            minCal = [[NSDate alloc] initWithTimeIntervalSince1970:3600*24];
        }
        @finally {
            
        }
    }

    //for Maximum date condition
    
	NSString* maxDate = [XmwUtils getPropertyValue:dotFormElement.defaultVal :XmwcsConst_DE_DATE_UPPER_LIMIT];
    if([maxDate length]>0) {
        NSArray* dateArr = [maxDate componentsSeparatedByString:@"/"];
        @try {
            NSString* date  = [dateArr objectAtIndex:0];
            NSString* month = [dateArr objectAtIndex:1];
            NSString* year = [dateArr objectAtIndex:2];
            
            NSCalendar *gregorian = [[NSCalendar alloc]
                                     initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *dateComp =[gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:maxCal];
            dateComp.year = dateComp.year + year.integerValue;
            if(month.integerValue!=0) {
                dateComp.month = dateComp.month + month.integerValue;
                dateComp.day = 1;
            } else {
                dateComp.day = dateComp.day + date.integerValue;
            }
            maxCal = [gregorian dateFromComponents:dateComp];
        }
        @catch (NSException *exception) {
            NSLog(@"Upper Limit Date exception : %@ ", exception.description );
            // maxCal = [[NSDate alloc] initWithTimeIntervalSince1970:3600*24];
        }
        @finally {
            
        }
    }
    
    self.pmCC = [[DVCalendarController alloc] initWithNibName:@"DVCalendarController" bundle:nil];
    self.pmCC.lowerDate = minCal;
    self.pmCC.upperDate = maxCal;
    self.pmCC.displayDate = defCal;
    self.pmCC.calendarDelegate = self;
    self.pmCC.contextId = selectedCalendarKey;
    
    [[self navigationController] pushViewController:self.pmCC  animated:YES];
}


-(IBAction) timeButtonPressed:(id) sender
{
    selectedCalendarTag = ((MXButton *)sender).tag;
	selectedCalendarKey = ((MXButton *)sender).elementId;
    
    TimePickerViewController* timePickerViewController = [[TimePickerViewController alloc]init];
    
    timePickerViewController.parentController = self;
    
    [[self navigationController] pushViewController:timePickerViewController animated:YES];
    
}

#pragma - mark  DVCalendarControllerDelegate

-(void) dateSelected:(DVDateStruct*) dateStruct :(NSString*) contextId
{
    if(dateStruct !=nil) {
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        // [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* date = [dateStruct convertToNSDate];
        
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        
        NSString *mySelectedDate = [dateFormatter stringFromDate:date];
        
        
        MXTextField *calendarField = (MXTextField *) [self getDataFromId:selectedCalendarKey];
        NSLog(@"checkdate : %@",mySelectedDate);
        calendarField.text = mySelectedDate;
    }
}

-(void) userCancelled:(NSString*) contextId
{
    
    
}

/*

- (BOOL)calendarControllerShouldDismissCalendar:(PMCalendarController *)calendarController
{
    
   
    NSLog(@"startdate of calendar :%@",calendarController.period.startDate);
    NSLog(@"enddate of calendar :%@",calendarController.period.endDate);
        
    return YES;
        
}

- (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod
{
    periodLabel.text = [NSString stringWithFormat:@"%@ - %@"
                        , [newPeriod.startDate dateStringWithFormat:@"dd-MM-yyyy"]
                        , [newPeriod.endDate dateStringWithFormat:@"dd-MM-yyyy"]];
}


- (void)calendarControllerDidDismissCalendar:(PMCalendarController *)calendarController
{
    

    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSDate* date = calendarController.period.startDate;
      
	[dateFormatter setDateFormat:@"dd/MM/yyyy"];
	
	NSString *mySelectedDate = [dateFormatter stringFromDate:date];
  
    
	MXTextField *calendarField = (MXTextField *) [self getDataFromId:selectedCalendarKey];
    NSLog(@"checkdate : %@",mySelectedDate);
    calendarField.text = mySelectedDate;
    
    [self textFieldDidEndEditing:calendarField];
         
}

*/

-(void)dismissTimePicker : (NSDate*) dateTimeObj
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"hh:mm aa"];
    
    MXTextField *calendarField = (MXTextField *) [self getDataFromId:selectedCalendarKey];
    calendarField.text = [dateformatter stringFromDate:dateTimeObj];
   
    [dateformatter setDateFormat:@"HH:mm"];
    calendarField.attachedData = [dateformatter stringFromDate:dateTimeObj];
    
}



-(void) animateSearchView:(int) direction
{
	if(direction == 1)
	{
		[UIView beginAnimations:@"searchView" context:nil];
		[UIView setAnimationDuration:0.5];
		searchView.transform = CGAffineTransformMakeTranslation(0,-236);
	}
	else if(direction == 0)
	{
		[UIView beginAnimations:@"searchView" context:nil];
		[UIView setAnimationDuration:0.5];
		searchView.transform = CGAffineTransformMakeTranslation(0,236);
	}
	[UIView commitAnimations];
}

-(void) animatePicker:(int) direction

{
    DotDropDownPicker *dotDropDownPicker = (DotDropDownPicker *) dropDownPicker;
    
     
	if(direction == 1)
	{
		[UIView beginAnimations:@"pickerDoneButtonView" context:nil];
		[UIView setAnimationDuration:0.5];
		pickerContainer.transform = CGAffineTransformMakeTranslation(0,-216);
        [UIView commitAnimations];
	}
	else if(direction == 0)
	{
		[UIView beginAnimations:@"pickerDoneButtonView" context:nil];
		[UIView setAnimationDuration:0.5];
		pickerContainer.transform = CGAffineTransformMakeTranslation(0,216);
        [UIView commitAnimations];
	}
}

- (void)setViewMovedUp:(BOOL)movedUp : (int)textField_Scroll
{
	
	if(textField_Scroll > 155)
		textField_Scroll = 150;
	// Make changes to the view's frame inside the animation block. They will be animated instead of taking place immediately.
	CGRect rect = self.view.frame;
	
	if (movedUp)
	{
		// If moving up, not only decrease the origin but increase the height so the view
		// covers the entire screen behind the keyboard.
		[UITextField setAnimationBeginsFromCurrentState:YES];
		[UITextField setAnimationDuration:KEYBOARD_ANIMATION_DURATION];

		
		scrollFormView.frame = CGRectMake(0, 0-textField_Scroll, scrollFormView.frame.size.width, scrollFormView.frame.size.height);
	}
	else
	{
		[UITextField setAnimationBeginsFromCurrentState:YES];
		[UITextField setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
		
		
		scrollFormView.frame = CGRectMake(0, 0, scrollFormView.frame.size.width, scrollFormView.frame.size.height);
	}
	self.view.frame = rect;
	[UIView commitAnimations];
}

#pragma mark Other Methods



-(NSMutableDictionary *) prepareDisplayData:(NSMutableDictionary *) _valueDictionary
{
	NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
	NSString *valueText = @"";
	NSMutableArray *keys = [[NSMutableArray alloc] initWithArray:[_valueDictionary allKeys]];
	
	@try
	{
		for(NSString *currentKey in keys)
		{
			if ([dropDownContentList containsObject:currentKey])
				valueText = ((MXTextField *)[_valueDictionary objectForKey:currentKey]).text;
			
			else if([[_valueDictionary objectForKey:currentKey] isKindOfClass:[MXTextField class]])
				valueText = ((MXTextField *)[_valueDictionary objectForKey:currentKey]).text;
			
			else if([[_valueDictionary objectForKey:currentKey] isKindOfClass:[MXLabel class]])
				valueText = ((MXLabel *)[_valueDictionary objectForKey:currentKey]).text;
			
			if(valueText == NULL)
				valueText = @"";
			
		//	[postData putWithString:[[NSString alloc] initWithString:currentKey] :[[NSString alloc] initWithString:valueText]];
		}
	}
	@catch (NSException * e)
	{
		NSLog(@"exception in post table data :%@",[e reason]);
	}
		return postData;
}

-(NSMutableDictionary *) prepareSendData:(NSMutableDictionary *) _valueDictionary
{
	NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
	NSString *valueText = @"";
	NSMutableArray *keys = [[NSMutableArray alloc] initWithArray:[_valueDictionary allKeys]];
	@try
	{
		for(NSString *currentKey in keys)
		{
			if ([dropDownContentList containsObject:currentKey])
				valueText = ((MXTextField *)[_valueDictionary objectForKey:currentKey]).elementId;
			
			else if([[_valueDictionary objectForKey:currentKey] isKindOfClass:[MXTextField class]])
				valueText = ((MXTextField *)[_valueDictionary objectForKey:currentKey]).text;
			
			else if([[_valueDictionary objectForKey:currentKey] isKindOfClass:[MXLabel class]])
				valueText = ((MXLabel *)[_valueDictionary objectForKey:currentKey]).text;
			
			if(valueText == NULL)
				valueText = @"";
			//NSLog(@"value text :%@",valueText);
		//	[postData putWithString:[[NSString alloc] initWithString:currentKey] :[[NSString alloc] initWithString:valueText]];
		}
	}
	@catch (NSException * e)
	{
		NSLog(@"exception in post table data :%@",[e reason]);
	}
	//NSLog(@"postData hashtable:%@",postData.hashTable);
	
//	[valueText release];
	return postData;
}

-(int) dataTypeCheck:(NSString *)dataType
{
	if([dataType isEqualToString:@"CHAR"])
		return 0;								// 0 for UIKeyboardTypeDefault
	
	else if([dataType isEqualToString:@"NUMC"])
		return 1;								// 1 for UIKeyboardTypeNumberPad
	
	return 0;
}


#pragma mark UISearchBarDelegate Methods

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsScopeBar = YES;
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:YES animated:YES];
	
	[UIView beginAnimations:@"searchView" context:nil];
	[UIView setAnimationDuration:0.3];
	searchView.transform = CGAffineTransformMakeTranslation(0,-436);
	[UIView commitAnimations];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsScopeBar = NO;
    [searchBar sizeToFit];
	
    [searchBar setShowsCancelButton:NO animated:YES];
	
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar 
{
    
	[searchBar resignFirstResponder];
	[self animateSearchView:0];
	if([searchBar.text isEqualToString:@""] || [searchBar.text length] < 3)
	{
		UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Info!" message:@"Search Text should be more than two characters." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
		[myAlertView show];
		
	}
	else
	{
		isSearch = YES;
		DotFormPost *searchFormPost	= [[DotFormPost alloc] init];
		
		searchFormPost.moduleId	= AppConst_MOBILET_ID_DEFAULT;
		
	}
     
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
	isSearch = NO;
	[searchBar resignFirstResponder];
	[self animateSearchView:0];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
    
    [UIView commitAnimations];
	
}


#pragma mark TextField Delegate Methods
-(UIView *)getTextFieldAccessoryView{
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setFrame:CGRectMake(0, self.view.bounds.size.height, 320.0, 42.0)];
    [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelTapped) forControlEvents:UIControlEventTouchUpInside];
    return cancel;
}
-(void)cancelTapped{
    [self.view endEditing:YES];
}
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    
    NSLog(@"FormVC textFieldShouldBeginEditing");
    activeTextField = textField;
    if( (activeTextField.keyboardType == UIKeyboardTypeNumberPad) && [activeTextField.text isEqualToString:@"0"]) {
        activeTextField.text = @"";
    }
    
	if(textField.tag > 100)
        return NO;
    else
        return YES;
    
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{

    NSLog(@"FormVC textFieldDidBeginEditing field tag = %d", textField.tag);
    activeTextField = textField;

    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
     NSLog(@"FormVC textFieldShouldReturn field tag = %d", textField.tag);
	 [textField resignFirstResponder];
    
	//[self setViewMovedUp:NO :0];
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"FormVC textFieldDidEndEditing field tag = %d", textField.tag);
	[self setViewMovedUp:NO :0];
    
    
   if([textField isKindOfClass: [MXTextField class]]) {
   
       MXTextField* mxTextField = (MXTextField*)textField;
       NSString* elementId = mxTextField.elementId;
    
       if(elementId==nil) return;
    
       DotFormElement* formElement = [dotForm.formElements valueForKey:elementId];
    
       NSString* eventDetail = formElement.eventDetail;
    
       if(eventDetail!=nil) {
           NSString* eventAction = [XmwUtils getPropertyValue : eventDetail :XmwcsConst_DE_EVENT_DETAIL_EVENT_ACTION];
           NSArray* selectedValueVector = [XmwUtils breakStringTokenAsVector : eventAction : @"$"];
           NSString* result = [DotFieldDataOperationUtils operationLostFocus : selectedValueVector :  self ];
           NSString* eventSet = [XmwUtils getPropertyValue : eventDetail : XmwcsConst_DE_EVENT_DETAIL_REFRESH_FIELD];

           NSLog(@"eventDetails = %@", eventDetail);
           NSLog(@"result = %@", result);
           NSLog(@"eventSet = %@", eventSet);
        
           if ([result isEqualToString : XmwcsConst_BOOLEAN_VALUE_FALSE] ) {
               NSRange pos = [eventSet rangeOfString:XmwcsConst_DE_EVENT_EVENT_ALERT_WINODW];
               if(pos.location != NSNotFound) {
                   pos.location = pos.location + 13;
                   pos.length = eventSet.length - pos.location;
                   NSString* message = [eventSet substringWithRange:pos];
                   UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"mKonnect Alert" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
                   myAlertView.tag = 3;
                   [myAlertView show];
                   if(mxTextField.text.length > 0) {
                       mxTextField.text = @""; // clear the value
                   }
               }
           } else {
               [DotFieldDataOperationUtils setComponentValue : eventSet : self : result ];
           }
       }
   }
    
}

#pragma mark Posting REQUEST


-(void)onKeyboardHide:(NSNotification *)notification
{
    //keyboard will hide
    NSLog(@"Got the keyboard hide event");
    [searchPopUp.searchInputField becomeFirstResponder];
   
}

-(void) postRequest:(NSData *)postData
{
    
}

#pragma mark Database Query Methods

-(BOOL) hasSearchElements:(NSString *)_tableName						// check for element exists in Customer table
{
	BOOL isElement = NO;
   	return isElement;
}

-(NSString *) concatSearchData:(NSString *) code : (NSString *) name
{
	code = [code stringByAppendingString:@"-"];
	code = [code stringByAppendingString:name];
	return code;
}

-(NSMutableDictionary *) getSearchData:(NSString *)_tableName
{
	NSMutableDictionary *searchData = [[NSMutableDictionary alloc] init];
       
	return nil;
}

-(void) insertRequest:(DotFormPost *)_formPost
{
   
}


-(BOOL) isMaxDocIdExists:(NSString *) _maxDocId
{
	sqlite3 *database;
	BOOL isDocIdExist = NO;
    
	return isDocIdExist;
}

-(void) processRecentRequest:(DotFormPost *)_formPost : (DocPostResponse *) _docResponse
{
    
}

#pragma mark Clean Up

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;


}




-(IBAction) checkBoxClicked :(id) sender { 
    
    MXButton *mxButton  = (MXButton*) sender;
    CheckBoxButton* checkBoxCell = (CheckBoxButton*)mxButton.parent;
    
    
    if(checkBoxCell.isChecked ==NO){
        checkBoxCell.isChecked =YES;
    
		//[checkBoxCell setFrame:CGRectMake( 190.0f, 6.0f, 169.0f, 31.0f)];
		[checkBoxCell.checkBoxButton setImage:[UIImage imageNamed:@"checkedbox.png"] forState:UIControlStateNormal];
    }else{
        checkBoxCell.isChecked =NO;
        
		//[checkBoxButton setFrame:CGRectMake( 190.0f, 6.0f, 169.0f, 31.0f)];
		[checkBoxCell.checkBoxButton setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    }
    
}

-(IBAction) checkBoxGroupClicked :(id) sender {
    
   // MXButton *mxButton  = (MXButton*) sender;
    //CheckBoxGroup* checkBoxGroupCell = (CheckBoxGroup*)mxButton.parent;
    
    
    if(isCheckedGroup ==NO){
      isCheckedGroup =YES;
        
		//[checkBoxCell setFrame:CGRectMake( 190.0f, 6.0f, 169.0f, 31.0f)];
		
        [checkBoxGroupButton setImage:[UIImage imageNamed:@"checkbox-checked.png"] forState:UIControlStateNormal];
    }else{
        isCheckedGroup =NO;
        
		//[checkBoxButton setFrame:CGRectMake( 190.0f, 6.0f, 169.0f, 31.0f)];
		[checkBoxGroupButton setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    }
    
}


-(id) getDataFromId : (NSString *) objectId
{
  
    return[componentMap objectForKey : objectId];
    
}

-(void) putToDataIdMap : (id) component : (NSString *) objectId
{
    
    [componentMap setObject:component forKey:objectId];
    
}
-(void)searchItemSelected : (NSInteger)rowIdx : (NSMutableArray *)selectedRowElement : (NSString*)elementId : (NSString*)masterValueMapping;
{
    id controlObj = [self getDataFromId:elementId];
    
    if([controlObj isKindOfClass:[DropDownTableViewCell class]]) {
        
        DropDownTableViewCell *dropDownCell = [self getDataFromId:elementId];
        MXTextField *dropDownField = dropDownCell.dropDownField;
        dropDownField.keyvalue =  [selectedRowElement objectAtIndex:0];
        dropDownField.text = (NSString *)  [selectedRowElement objectAtIndex:1];
        
        
        NSMutableArray *arrayToValuePicker =  dropDownCell.dropDownButton.attachedData;
        NSMutableArray *keyList = [arrayToValuePicker objectAtIndex:0];
        NSMutableArray* optionList = [arrayToValuePicker objectAtIndex:1];
        
        
        [keyList addObject:[selectedRowElement objectAtIndex:0]];
        [optionList addObject:[selectedRowElement objectAtIndex:1]];
        
        if(dropDownField){
            SearchRequestStorage* searchStorage = [SearchRequestStorage getInstance];
            SearchRequestItem* searchItem = [[SearchRequestItem alloc] init];
            searchItem.keyValue = [selectedRowElement objectAtIndex:0];
            searchItem.nameValue = [selectedRowElement objectAtIndex:1];
            searchItem.searchId =  masterValueMapping;
            searchItem.module = [DVAppDelegate currentModuleContext];
            
            NSDate *today = [NSDate date];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
            NSString *dateString = [dateFormat stringFromDate:today];
            searchItem.createdDate =   dateString;
            [searchStorage insertDoc:searchItem];
        }
    } else if([controlObj isKindOfClass:[EditSearchField class]]) {
        EditSearchField* editSearchField = (EditSearchField*) controlObj;
        
        MXTextField *editTextField = editSearchField.editText;
        editTextField.keyvalue =  (NSString *)  [selectedRowElement objectAtIndex:1] ; //[selectedRowElement objectAtIndex:0];
        editTextField.text = (NSString *)  [selectedRowElement objectAtIndex:1];
        
    }

}


#pragma mark - HttpEventListener

- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    
    [loadingView removeView];
    
    DotFormPost* reqFormPost = (DotFormPost*) requestedObject;
    
    if ([callName isEqualToString : XmwcsConst_CALL_NAME_FOR_REPORT])
    {
        ClientVariable* clientVariable = [ClientVariable getInstance];
        
        ReportPostResponse *reportPostResponse = (ReportPostResponse*) respondedObject;
        
        UIViewController* objVC = [clientVariable reportVCForId:reqFormPost.adapterId];
        
        if([objVC isKindOfClass:[SimpleEditForm class]]) {
            SimpleEditForm* formVC  = (SimpleEditForm*) objVC;
            formVC.requestFormPost = reqFormPost;
            formVC.reportFormResponse = reportPostResponse;
            
            formVC.forwardedDataPost = forwardedDataPost;
            formVC.forwardedDataDisplay = forwardedDataDisplay;
            formVC.screenId = AppConst_SCREEN_ID_REPORT;
            
        } else if([objVC isKindOfClass:[ReportVC class]]) {
            ReportVC *reportVC = (ReportVC*) objVC;
            
            reportVC.requestFormPost = reqFormPost;
            reportVC.screenId = AppConst_SCREEN_ID_REPORT;
            reportVC.reportPostResponse = reportPostResponse;
            reportVC.forwardedDataDisplay = forwardedDataDisplay;
            reportVC.forwardedDataPost = forwardedDataPost;
            
        }
        
        [[self navigationController] pushViewController:objVC  animated:YES];
        
    }
    else if([callName isEqualToString : XmwcsConst_CALL_NAME_FOR_SUBMIT]){
        
        if([AppConst_MOBILET_ID_DEFAULT isEqualToString:@"xhavellsdealer"] && [dotFormPost.adapterId isEqualToString: @"ADT_SAP_FORM_31" ])
        {
            // this is special case, we need to post the form again after user say OK
            DocPostResponse *docPostResponse = (DocPostResponse *)respondedObject;
            NSString *message = docPostResponse.submittedMessage;
            NSString* status = docPostResponse.submitStatus;
            if(NSOrderedSame==[status compare:@"E" options:NSCaseInsensitiveSearch]) {
                // we ask user to cancel or back
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Create Order" message:message delegate:self cancelButtonTitle:@"Back" otherButtonTitles:@"Cancel Order" , nil];
                myAlertView.tag = 2001;
                [myAlertView show];
            } else if(NSOrderedSame==[status compare:@"S" options:NSCaseInsensitiveSearch]){
                
                
                OrderFeedbackPopup* orderFeedbackPopup = [OrderFeedbackPopup createInstance];
                orderFeedbackPopup.delegate = self;
                [orderFeedbackPopup setDocPostRespnose:docPostResponse];
                [[UIApplication sharedApplication].keyWindow addSubview:orderFeedbackPopup];
                
                
                /*
                // on S, we have to ask user to confirm the order and submit again.
                // we ask user to cancel or back
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Create Order" message:message delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No" , nil];
                myAlertView.tag = 2002;
                [myAlertView show];
                 */
            }
        } else {
            DocPostResponse *docPostResponse = (DocPostResponse *)respondedObject;
            NSString *message = docPostResponse.submittedMessage;
            NSString* status = docPostResponse.submitStatus;
            
            if((NSOrderedSame==[status compare:@"1" options:NSCaseInsensitiveSearch]) || (NSOrderedSame==[status compare:@"S" options:NSCaseInsensitiveSearch]) )
            {
                if([AppConst_MOBILET_ID_DEFAULT isEqualToString:@"xhavellsdealer"] && [dotFormPost.adapterId isEqualToString: @"ADT_SAP_FORM_3" ])
                {
                    NSString* title = [NSString stringWithFormat:@"Order Number: %@", docPostResponse.trackerNumber];
                    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
                    myAlertView.tag = 2003;
                    [myAlertView show];
                } else {
                    NSString* title = [NSString stringWithFormat:@"Doc Number: %@", docPostResponse.trackerNumber];
                    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
                    myAlertView.tag = 2004;
                    [myAlertView show];
                }
            } else {
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Info!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
                myAlertView.tag = 2005;
                [myAlertView show];
            }
        }
        
    } else if([callName isEqualToString : XmwcsConst_CALL_NAME_FOR_CHANGE_PASSWORD]) {
        
        DocPostResponse *docPostResponse = (DocPostResponse *)respondedObject;
        NSString *message = docPostResponse.submittedMessage;
        NSString* status = docPostResponse.submitStatus;
        
        if((NSOrderedSame==[status compare:@"0" options:NSCaseInsensitiveSearch]) || (NSOrderedSame==[status compare:@"1" options:NSCaseInsensitiveSearch]) )
        {
           
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
            
            [alertView show];
        }
    }
    else if([callName isEqualToString:@"ImagePostDataRequest"])
    {
        AttachmentViewCell *fileAttach =[(AttachmentViewCell *) self.view viewWithTag:1000]; //get view with tag 1000 tag define in dotformDraw
        [fileAttach.imageViewAttachButton setEnabled:YES];
        
        
        [progressBarView removeView];
        if ([[respondedObject valueForKey:@"status"]isEqualToString:@"SUCCESS"]) {
    
            //save key ufmrefid
            
             ufmrefid = [[[respondedObject valueForKey:@"xmwuploadfilemaster"] valueForKey:@"ufmrefid"] componentsJoinedByString:@""];
            NSLog(@"File Upload ufmrefid : %@",ufmrefid);
            
            AttachmentViewCell *vc = [(AttachmentViewCell*) self.view viewWithTag:1000];//get view with tag 1000 tag define in dotformDraw
            vc.ufmrefid = ufmrefid;
            
            
        }
        else
        {
             AttachmentViewCell *fileAttach =[(AttachmentViewCell *) self.view viewWithTag:1000]; //get view with tag 1000 tag define in dotformDraw
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"File Upload" message:@"File upload failed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
            [fileAttach.imageView setImage:[UIImage imageNamed:@"default_file_upload.png"]];
            myAlertView.tag = 101;
            [myAlertView show];
            
        }
    }
    
    else  if ([callName isEqualToString : XmwcsConst_CALL_NAME_FOR_VIEW_EDIT]) {
        
        
        
    }
}



- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];
    
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"mKonnect Response!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
    
}

- (void) httpInterruptHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];
    
    
    
}



#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    
    
    if (alertView.tag == 1 || alertView.tag == 2 || alertView.tag == 3)
    {
       // do nothing here
    } else if(alertView.tag==2001) {
        // from order creation server validation error message alert delegate
        if(buttonIndex==0) {
            
        } else if(buttonIndex==1) {
            
            
        }
    } else if(alertView.tag==2002) {
        // from order creation server validation success message alert delegate
        // now data needs to be posted on user confirmation on the validation message
        if(buttonIndex==0) {
            NSLog(@"Pressed YES");
            dotFormPost.adapterId = @"ADT_SAP_FORM_3";
            [self networkCall:dotFormPost :XmwcsConst_CALL_NAME_FOR_SUBMIT];
        } else if(buttonIndex==1) {
            NSLog(@"Pressed NO");
        }
    } else if(alertView.tag==2003) {
        // from order creation server order confirmation success message alert delegate
        // user to be shown order number
        if(buttonIndex==0) {
            
        } else if(buttonIndex==1) {
            
        }
        
        // clear any draft order state
        NSString* productKey = [NSString stringWithFormat:@"SPART:%@", [self.forwardedDataPost objectForKey:@"SPART"]];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:productKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[self navigationController]  popViewControllerAnimated:YES];
    } else if(alertView.tag==2004) {
        // from  server document submit confirmation success message alert delegate
        // user to be shown document number
        if(buttonIndex==0) {
            
        } else if(buttonIndex==1) {
            
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReportNeedRefresh" object:nil];
        
        [ [self navigationController]  popViewControllerAnimated:YES];
    } else if(alertView.tag==2005) {
        // server respond with not positive message for order creation or document submit
        if(buttonIndex==0) {
            
        } else if(buttonIndex==1) {
            
        }
        // nothing to do
    }
    
    else if (alertView.tag == 100){ // file attachment alertview
        
        NSString *click = [alertView buttonTitleAtIndex:buttonIndex];
        
        if([click isEqualToString:@"Take a Photo"])
        {
            
            [self takePhoto];
            
        }
        else if([click isEqualToString: @"Gallery"])
        {
            [self selectPhotoFromGallery];
        }
        
    }
    
    else if (alertView.tag == 101){ // file attachment alertview
        
//       alertView
        
    }
    else {
        [ [self navigationController]  popViewControllerAnimated:YES];
        
    }
    
}


- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}


// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSLog(@"FormVC keyboardWasShown");
    NSDictionary* info = [aNotification userInfo];
    keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);

    /*
     int text_Y = activeTextField.tag * 40 + yArguForAddRowFormDraw + 128;            // cell tag multiply by cell height
     // int text_Y = (activeTextField.superview.superview.tag - 1001) * 40 + yArguForAddRowFormDraw + 70;
     int formHeightNow = [[UIScreen mainScreen] bounds].size.height - keyboardSize.height;

     NSLog(@" textY = %d, formHeightNow = %d, height of screen = %f", text_Y, formHeightNow, [[UIScreen mainScreen] bounds].size.height);

     if(text_Y  > formHeightNow) {
     [self setViewMovedUp:YES :(text_Y - formHeightNow)];
     }

     */

    scrollFormView.contentInset = contentInsets;
    scrollFormView.scrollIndicatorInsets = contentInsets;

    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardSize.height;
    if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
        [scrollFormView scrollRectToVisible:activeTextField.frame animated:YES];
    }

}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSLog(@"FormVC keyboardWillBeHidden");

    UIEdgeInsets contentInsets = UIEdgeInsetsZero;

    scrollFormView.contentInset = contentInsets;
    scrollFormView.scrollIndicatorInsets = contentInsets;

}


// for tabular data, one row can be deleted
-(IBAction) rowDeleteClicked:(id) sender
{
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext]];

    UIButton* deleteButton = (UIButton*)  sender;
    NSLog(@"FormVC rowDeleteClicked , and tag is %d", deleteButton.tag);
    
    UIView* tableContainer =  [scrollFormView viewWithTag:TAG_FORM_TABLE_CONTAINER];
    if(tableContainer!=nil) {
        DotRowContainer* containerAddRow = (DotRowContainer*)[tableContainer viewWithTag:(TAG_FORM_TABLE_CONTAINER + deleteButton.tag - TAG_FORM_TABLE_ROWCONTAINER)];
        if(containerAddRow!=nil) {
            yArguForAddRowFormDraw = [addRowFormUtils deleteRow : self : dotFormPost : tableContainer: rowNoOfTable  :containerAddRow : (deleteButton.tag - TAG_FORM_TABLE_ROWCONTAINER)];
            
            mainFormContainer.frame = CGRectMake(0, yArguForAddRowFormDraw, mainFormContainer.frame.size.width, dotFormDraw.yArguForDrawComp);
            
            int y = dotFormDraw.yArguForDrawComp + yArguForAddRowFormDraw + 60;
            scrollFormView.contentSize = CGSizeMake(self.view.bounds.size.width,y);
            
        }
        
    }
}

-(UINavigationController*)navigationController
{
    if( [super navigationController] )//self.navigationController )
    {
        return [super navigationController];
    }
    else
    {
        return self.surrogateParent.navigationController;
    }
}



#pragma  mark - TextField inputaccessory view button events
-(void)cancelNumberPad:(id) sender
{
    [activeTextField resignFirstResponder];
    // activeField.text = @"";
}

-(void)doneWithNumberPad:(id) sender
{
    // NSString *numberFromTheKeyboard = activeField.text;
    [activeTextField resignFirstResponder];
}


#pragma  mark - OrderFeedbackPopup.h

-(void) cancelOrder
{
 
    
}

-(void) confirmOrder
{
    dotFormPost.adapterId = @"ADT_SAP_FORM_3";
    [self networkCall:dotFormPost :XmwcsConst_CALL_NAME_FOR_SUBMIT];
}


-(DVTableFormView*) childTableForm:(CGRect) frame
{
    return [[DVTableFormView alloc] initWithFrame:frame];
}


-(void) setFormEditable
{

}



-(void)barCodeScanButtonAction:(id) sender
{
    NSLog(@"Bar Code Scanner");
    
    MXButton* mxButton = (MXButton*) sender;
    
    NSString* formElementId = mxButton.elementId;
    
    BarcodeScanVC* scanVC = [[BarcodeScanVC alloc] initWithNibName:@"BarcodeScanVC" bundle:nil];
    scanVC.scanDelegate = self;
    scanVC.contextId = formElementId;
    
    [self.navigationController pushViewController:scanVC animated:YES];
    
}


#pragma mark - BarcodeScanDelegate

-(void) barcodeResult:(NSString*) scanCode forContext:(NSString*) contextId
{
    NSLog(@"barcodeResult is %@", scanCode);
    NSString* formElementId =  contextId;
    
    if(scanCode!=nil && [scanCode isKindOfClass:[NSString class]] && [scanCode length]>0) {
        BarCodeScanField* barcodeScanField = (BarCodeScanField*)[self getDataFromId:formElementId];
        barcodeScanField.editText.text = scanCode;
    }
    
}

-(void) barcodeCancelledForContext:(NSString*) contextId
{
    
    
}


@end
