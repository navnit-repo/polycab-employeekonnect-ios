//
//  EditOrderVC.m
//  QCMSProject
//
//  Created by Pradeep Singh on 5/24/16.
//  Copyright © 2016 dotvik. All rights reserved.
//

#import "EditOrderVC.h"
#import "DVAppDelegate.h"
#import "ClientVariable.h"
#import "Styles.h"
#import "DVTableFormView.h"

#import "EditOrderSubFormVC.h"
#import <objc/runtime.h>
#import "DotFormPostUtil.h"


#import <CoreText/CoreText.h>

#import "DotReportDraw.h"


@interface UIButton (RowState)
@property NSNumber* rowState;
@end


@implementation UIButton (RowState)

- (NSNumber*)rowState;
{
    return objc_getAssociatedObject(self, "rowState");
}

- (void)setRowState:(NSNumber *)rowState
{
    objc_setAssociatedObject(self, "rowState", rowState, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@interface EditOrderVC ()   <DVTableFormRowDelegate, DVTableFormColumnDelegate, SearchViewMultiSelectDelegate>
{
    UIBarButtonItem* editButton;
    UIBarButtonItem* saveButton;
    
    
    DotForm *dotForm;
    NSMutableDictionary* forwardedDataDisplay;
    NSMutableDictionary* forwardedDataPost;
    DotFormPost* dotFormPost;
    
    FormVC* editFormVC;
    
    CGSize keyboardSize;
    UITextField* activeTextField;
    
    NetworkHelper *networkHelper;
    LoadingView* loadingView;
    MXButton* submitButton;

    
    UIDocumentInteractionController* documentInteractionController;
    
}

@property UIDocumentInteractionController* documentInteractionController;

@end

@implementation EditOrderVC

@synthesize documentInteractionController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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



// Overriding Behaviour


-(void) drawHeaderItem
{
    self.title = self.dotReport.screenHeader;
    
    self.navigationController.navigationBar.tintColor = [Styles barButtonTextColor];
    
    
    //self.imageView = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"save-pdf"]];
    // [self.imageView setTintColor:[UIColor redColor]];
    
    
    UIImage *iconImage = [[UIImage imageNamed:@"save-pdf"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.imageView = [[UIImageView alloc] initWithImage:iconImage];
    self.imageView.tintColor = [Styles headerTextColor];
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.bounds = self.imageView.bounds;
    
    [button addSubview:self.imageView];
    
    [button addTarget:self action:@selector(createPdfAndShare:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView: button] ;
    
    rightBarButton.tintColor = [UIColor redColor];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
    
    
    [self drawTitle: self.dotReport.screenHeader];
    
}

-(void) makeReportScreenV2
 {
     
     ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext]];
     
     // we need to add button bar above main edit form for selecting Edit mode, and then Save.
     
     
     
     
     [self drawEditForm];
     
     
     [self setFormData];
     
     
     [self registerForKeyboardNotifications];
     
     
     [self addButtonBar];
     
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


-(void)addButtonBar
{
    UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.0f)];
    
    
    editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonPressed:)];
    editButton.tintColor = [Styles barButtonTextColor];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    saveButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(submitPressed:)];
    saveButton.tintColor = [Styles barButtonTextColor];
    saveButton.enabled = NO;
    
    [toolbar setItems:[[NSArray alloc] initWithObjects:editButton, spacer, saveButton, nil]];
    [toolbar setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    [self.view addSubview:toolbar];
    
    // change scrollView position as well
    
    CGRect oldFrame = editFormVC.view.frame;
    
    editFormVC.view.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y + 44.0f, oldFrame.size.width, oldFrame.size.height - 44.0f);
    
    for(UIView* v in [editFormVC.view subviews]) {
        if([v isKindOfClass:[UIScrollView class]]) {
            v.frame = CGRectMake(0, 0, oldFrame.size.width, oldFrame.size.height - 44.0f);
        }
    }
    
}



#pragma mark - Toolbar ButtonHandlers
-(void)editButtonPressed:(id) sender
{
    
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext]];
    
    saveButton.enabled = YES;
    submitButton.enabled = YES;
    

    [self setFormEditable];

    
}


-(void) setFormEditable
{
    [editFormVC setFormEditable];
    
    // need to set tabular fields editable
    
    DVTableFormView* rowForm  = (DVTableFormView*)editFormVC.rowFormInSameForm;
    NSArray* orderItems = self.reportPostResponse.tableData;
    
    NSInteger maxRows = [orderItems count ];

    for(int i=1; i<=maxRows;i++) {
        
        NSMutableArray* rowDataArray = [orderItems objectAtIndex:(i-1)];
        
        int rowId = i-1;
        
        UIView* quantityCell = [rowForm getRowCellWithRowId:(rowId+1) colId:1];
        MXTextField* qtyTextField = (MXTextField*)[[quantityCell subviews] objectAtIndex:0];
        qtyTextField.enabled = YES;
        
        UIButton* actionButton =  [rowForm getActionButtonWithRowId:i];
        actionButton.enabled = YES;
    }
    
}


-(void)drawEditForm
{
    NSString* dotFormId = @"DOT_FORM_33_1";
    ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    
    
    DotMenuObject* formMenuObject = [[DotMenuObject alloc] init];
    formMenuObject.FORM_ID = dotFormId;
    
    dotForm = (DotForm *) [clientVariables.DOT_FORM_MAP objectForKey: dotFormId];
    if (forwardedDataDisplay == nil)
        forwardedDataDisplay   = [[NSMutableDictionary alloc] init];
    
    if (forwardedDataPost == nil)
        forwardedDataPost      = [[NSMutableDictionary alloc] init];
    
    dotFormPost = [[DotFormPost alloc] init];
    
    
    editFormVC = [[EditOrderSubFormVC alloc] initWithData :formMenuObject
                                                :dotFormPost
                                                :NO
                                                :forwardedDataDisplay
                                                :forwardedDataPost];
    editFormVC.headerStr			= dotForm.screenHeader;
    editFormVC.menuViewController = nil;
    editFormVC.view.frame = self.view.bounds;
    
    editFormVC.surrogateParent = self;
    
    [self.view addSubview:editFormVC.view];
    
    
    DotFormElement* dotFormElement = [dotForm.formElements objectForKey:@"SUBMIT"];
    if( [dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_BUTTON]) {
        submitButton = [editFormVC getDataFromId:dotFormElement.elementId];
        submitButton.enabled = NO;
        
        // remove previous target if already configure
        [submitButton removeTarget:editFormVC action:@selector(submitPressed:)  forControlEvents:UIControlEventTouchUpInside];
        // add customer submit handler so that we can override the behaviour
        [submitButton addTarget:self action:@selector(submitPressed:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
}



-(void) setFormData
{
    NSMutableDictionary * headerData = self.reportPostResponse.headerData;
    
    DVTableFormView* rowForm  = (DVTableFormView*)editFormVC.rowFormInSameForm;
    
    NSArray* addRowDotFormElementArray = editFormVC.dotForm.addRowFormElements;
    NSArray* nonAddRowDotFormElementArray = editFormVC.dotForm.nonAddRowFormElements;
    
    for(int cntElement = 0; cntElement < [nonAddRowDotFormElementArray count] ; cntElement++)
    {
        DotFormElement* dotFormElement = (DotFormElement *)[nonAddRowDotFormElementArray objectAtIndex:cntElement];
        
        if([headerData objectForKey:dotFormElement.elementId]!=nil) {
            if([dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_TEXTFIELD]) {
                MXTextField* mxTextField = (MXTextField*)[editFormVC getDataFromId:dotFormElement.elementId];
                NSString* itemData = [headerData objectForKey:dotFormElement.elementId];
                mxTextField.text = itemData;
            } else if([dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_CHECKBOX]) {
                MXButton* mxbutton = (MXButton*) [editFormVC getDataFromId:dotFormElement.elementId];
                NSString* itemData = [headerData objectForKey:dotFormElement.elementId];
                
                if([itemData isEqualToString:@"True"]) {
                    [mxbutton.parent setChecked];
                } else {
                    [mxbutton.parent setUnchecked];
                }
            } else if([dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_DROPDOWN]) {  // DROPDOWN
                MXTextField* mxTextField = (MXTextField*)[editFormVC getDataFromId:dotFormElement.elementId];
                
                NSString* itemData = [headerData objectForKey:dotFormElement.elementId];
                mxTextField.text = itemData;
                mxTextField.keyvalue = itemData;
            } else if([dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_DATE_FIELD]) {   // DATE_FIELD
                MXTextField* mxTextField = (MXTextField*)[editFormVC getDataFromId:dotFormElement.elementId];
                NSString* itemData = [headerData objectForKey:dotFormElement.elementId];
                mxTextField.text = itemData;
                mxTextField.enabled = NO;
            } else if([dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_LABEL]) {
                MXLabel* mxLabel = (MXLabel*)[editFormVC getDataFromId:dotFormElement.elementId];
                // here we should have code for the dropdown value
                NSString* itemData = [headerData objectForKey:dotFormElement.elementId];
                mxLabel.text = itemData;
                mxLabel.attachedData = itemData;
            }
        } else {
            id tObject = [editFormVC getDataFromId:dotFormElement.elementId];
            if([tObject isKindOfClass:[MXTextField class]]) {
                MXTextField* mxTextField = (MXTextField*)tObject;
                NSString* itemData = [headerData objectForKey:dotFormElement.elementId];
                mxTextField.text = itemData;
                mxTextField.enabled = NO;
            }
        }
    }
    
    NSArray* orderItems = self.reportPostResponse.tableData;
    
    
    // now we need to add table row data
    
    NSInteger maxRows = [orderItems count ];
    
    
    for(int i=1; i<=maxRows;i++) {
       //  NSDictionary* rowDataDict = [formData objectForKey:[NSString stringWithFormat:@"row_%d", i]];
        
            NSMutableArray* rowDataArray = [orderItems objectAtIndex:(i-1)];
        
            // we need to insert data on the new rows after rowId
            int rowId = i-1;
            
            [rowForm insertRowAfterRow:rowId withData:nil header:nil];
        
            
            UIView* productCell = [rowForm getRowCellWithRowId:(rowId+1) colId:0];
            MXLabel* productSKU = (MXLabel*)[[productCell subviews] objectAtIndex:0];
            productSKU.text = [rowDataArray objectAtIndex:1];
        
        
            UIView* quantityCell = [rowForm getRowCellWithRowId:(rowId+1) colId:1];
            MXTextField* qtyTextField = (MXTextField*)[[quantityCell subviews] objectAtIndex:0];
            qtyTextField.text = [rowDataArray objectAtIndex:5];
            qtyTextField.enabled = NO;
        
            qtyTextField.keyboardType = UIKeyboardTypeDecimalPad;
            // qtyTextField.delegate = self;
        
            UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
            
            numberToolbar.items = [NSArray arrayWithObjects:
                                   [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad:)],
                                   [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                   [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad:)],
                                   nil];
            
            qtyTextField.inputAccessoryView = numberToolbar;
            
            
            
            UIView* descCell = [rowForm getRowCellWithRowId:(rowId+1) colId:2];
        
            MXLabel* descLabel = (MXLabel*)[[descCell subviews] objectAtIndex:0];
            descLabel.font = [UIFont systemFontOfSize:11];
            descLabel.numberOfLines = 0;
            descLabel.text = [rowDataArray objectAtIndex:2];
            descLabel.backgroundColor = [UIColor clearColor];
            descLabel.textColor = [UIColor blackColor];
        
        
            
            UIView* unitCell = [rowForm getRowCellWithRowId:(rowId+1) colId:3];
            MXLabel* unitLabel = (MXLabel*)[[unitCell subviews] objectAtIndex:0];
            unitLabel.font = [UIFont systemFontOfSize:11];
            unitLabel.text = [rowDataArray objectAtIndex:4];
            unitLabel.backgroundColor = [UIColor clearColor];
            unitLabel.textColor = [UIColor blackColor];

        
        
        
            UIView* statusCell = [rowForm getRowCellWithRowId:(rowId+1) colId:4];
            MXLabel* itemStatusLabel = (MXLabel*)[[statusCell subviews] objectAtIndex:0];
            itemStatusLabel.font = [UIFont systemFontOfSize:11];
            itemStatusLabel.text = [rowDataArray objectAtIndex:6];
            itemStatusLabel.backgroundColor = [UIColor clearColor];
            itemStatusLabel.textColor = [UIColor blackColor];
        

        UIButton* actionButton =  [rowForm getActionButtonWithRowId:i];
        actionButton.rowState = [[NSNumber alloc] initWithInt:0];
        actionButton.enabled = NO;
        // if need to replace the image for Undo action for already existing rows
        // adding custom action button handler (For overriding delete feature)
        [rowForm updateActionButtonTarget:self action:@selector(rowAction:) forControlEvents:UIControlEventTouchUpInside forRowId:i];
        
        // for new rows, actionButton would not be having rowState property
        
    }
}



#pragma  mark - TextField inputaccessory view button events
-(void)cancelNumberPad:(id) sender
{
    [activeTextField resignFirstResponder];
   // activeTextField.text = @"";
    [self.view endEditing:YES];
}

-(void)doneWithNumberPad:(id) sender
{
    // NSString *numberFromTheKeyboard = activeField.text;
    [activeTextField resignFirstResponder];
    [self.view endEditing:YES];
}



#pragma mark TextField Delegate Methods

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
    
    
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"FormVC textFieldDidBeginEditing field tag = %d", textField.tag);
    
    activeTextField = textField;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
     activeTextField = textField;
    
    NSLog(@"FormVC textFieldShouldReturn field tag = %d", textField.tag);
    // [textField resignFirstResponder];
    
    //[self setViewMovedUp:NO :0];
    return TRUE;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    NSDictionary* info = [aNotification userInfo];
    keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
 
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    //keyboard will hide
    NSLog(@"Got the keyboard hide event");
    
    
}


#pragma  mark - row action

-(IBAction)rowAction:(id)sender
{
    UIButton* actionButton = (UIButton*)sender;
    

    DVTableFormView* rowForm  = (DVTableFormView*)editFormVC.rowFormInSameForm;
    
    int rowIdx = [rowForm rowIndexOfActionButton:actionButton];
    
    // if current status is already deleted, then show undo
    
   // actionButton.
    if(actionButton.rowState == nil) {
        // initially no rowState, means current state action is delete, we need to set the state to forUndo
        actionButton.rowState = [[NSNumber alloc] initWithInt:1];
        // means marking for delete
        
        
        // it can also mean, this was new row
        
    } else {
        if([actionButton.rowState intValue] == 1) {
            // it is already 1, means, need to undo operation
            actionButton.rowState = [[NSNumber alloc] initWithInt:0];
            // we are unmarking for delete
            [actionButton setBackgroundImage:[UIImage imageNamed:@"minus_normal"] forState:UIControlStateNormal];
            [actionButton setBackgroundImage:[UIImage imageNamed:@"minus_pressed"] forState:UIControlStateHighlighted];
        } else if([actionButton.rowState intValue] == 0)  {
            // it is already 1, means, need to undo operation
            actionButton.rowState = [[NSNumber alloc] initWithInt:1];
            
            [actionButton setBackgroundImage:[UIImage imageNamed:@"undo_normal"] forState:UIControlStateNormal];
            [actionButton setBackgroundImage:[UIImage imageNamed:@"undo_normal"] forState:UIControlStateHighlighted];
            
            // we need to mark for delete
            
        }
    }
}



#pragma mark - SubmitClicked

-(IBAction)submitPressed:(id)sender
{
     DotFormPostUtil* postUtil = [[DotFormPostUtil alloc] init];
    
    if([postUtil mandatoryCheck:dotForm :editFormVC ]) {
        
        // we need to check if any row has quantity 0 also,
        // already existing rows have status other then Open, then It cannot be updated
        //
        
        if([self orderUpdateAllow]) {
            DotFormPost* needToPost = [self createUpdateOrderDataForSubmit];
        
            if(needToPost!=nil) {
                
                [needToPost setAdapterId: dotForm.submitAdapterId];
                [needToPost setDocId : dotForm.formId];
                [needToPost setDocDesc : dotForm.screenHeader];
                [needToPost setAdapterType:dotForm.adapterType];
                [needToPost setModuleId: [DVAppDelegate currentModuleContext]];
                
                
                [postUtil incrementMaxDocId : needToPost];
                
                dotFormPost = needToPost;
                
                loadingView = [LoadingView loadingViewInView:self.view];
                networkHelper = [[NetworkHelper alloc] init];
                [networkHelper makeXmwNetworkCall:dotFormPost :self : nil :XmwcsConst_CALL_NAME_FOR_SUBMIT];
                
            } else {
                // means some validation failed
                
            }
        }
    }

    
    
}


-(BOOL) orderUpdateAllow
{
    BOOL retVal = YES;
    
    
    NSArray* lineItems = self.reportPostResponse.tableData;
    
    for(int i=1; i<=[lineItems count]; i++) {
        
        NSMutableArray* rowDataArray = [lineItems objectAtIndex:(i-1)];
        
        NSString* lineItemStatus = [rowDataArray objectAtIndex:6];
        
        if([lineItemStatus caseInsensitiveCompare:@"OPEN"]!=NSOrderedSame) {
            retVal = NO;
        }
    }
    
    // Since some item is in Non-Open state, this form can updated.
    
    if(retVal==NO) {
        // Show user alertview
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Sales Order Validation" message:@"Partial open order cannot be updated." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil , nil];
        myAlertView.tag = 1;
        
        [myAlertView show];
    }
    
    
    
    return retVal;
}

-(DotFormPost*) createUpdateOrderDataForSubmit
{
    BOOL validationNotFailed = YES;
    NSString* validationMessage = @"";
    
    DotFormPost* orderDataPost = [[DotFormPost alloc] init];
    
    DotForm* formDef = dotForm;
    
    NSArray* addRowDotFormElementArray = formDef.addRowFormElements;
    NSArray* nonAddRowDotFormElementArray = formDef.nonAddRowFormElements;
    
    NSMutableDictionary* reportElements = self.dotReport.reportElements;
    
    
    // I_OBJID->ORDER,  I_DIVISION->DIVISION
    // I_DESCRIPTION, I_DELIVERY_DATE
    NSMutableDictionary * headerData = self.reportPostResponse.headerData;

    [orderDataPost.postData setObject:[headerData objectForKey:@"ORDER"] forKey:@"I_OBJID"];
    [orderDataPost.postData setObject:[headerData objectForKey:@"SPART"] forKey:@"I_DIVISION"];
    

    DotFormPostUtil* postUtil = [[DotFormPostUtil alloc] init];
    NSArray *descValue = [postUtil getDotFormElementData:[formDef.formElements objectForKey:@"ORDER_DESCRIPTION"] :editFormVC];
    NSArray *dateValue = [postUtil getDotFormElementData:[formDef.formElements objectForKey:@"I_DELIVERY_DATE"] :editFormVC];
    
    [orderDataPost.postData setObject:descValue[0] forKey:@"I_DESCRIPTION"];
    [orderDataPost.postData setObject:dateValue[0] forKey:@"I_DELIVERY_DATE"];
    
    
    
    NSArray* lineItems = self.reportPostResponse.tableData;
    
    // now we need to add table row data
    
    DVTableFormView* rowForm  = (DVTableFormView*)editFormVC.rowFormInSameForm;
    NSInteger maxRows =  [rowForm getRowCount];
    
    
    for(int i=1; i<=maxRows && (validationNotFailed == YES);i++) {
        
        NSMutableArray* rowDataArray = nil;
        if((i-1)<[lineItems count]) {
            rowDataArray = [lineItems objectAtIndex:(i-1)];
        }
        
        [self addOrderLineItemDetails:i rowData:rowDataArray into:orderDataPost];
    }
    
    return orderDataPost;
}


/*
 ITEM_GUID
 PRODUCT
 PROD_DESC
 QUANT
 UNIT
 ACTION (Q | D | N)
 Q = Quantity Change
 D = Delete
 N = New Item
 */

-(void) addOrderLineItemDetails:(int) rowIdx rowData:(NSArray*) rowDataArray into:(DotFormPost*) orderDataPost
{
    
    [orderDataPost.postData setObject:[NSString stringWithFormat:@"%d", rowIdx] forKey: dotForm.tableName];
    [orderDataPost.postData setObject:@"row added" forKey:[NSString stringWithFormat:@"%@:%d", dotForm.tableName, rowIdx]];
    
    
    DVTableFormView* rowForm  = (DVTableFormView*)editFormVC.rowFormInSameForm;
    
    // filled card no should be 16 and matched with last 4 digit in rowData
    UIView* rowContent = [rowForm getRowWithRowId:rowIdx];
    NSArray* userRowData = [rowForm.rowDelegate rowDataForSubmit:rowContent forRow:rowIdx];
    
    NSString* itemCode = [userRowData objectAtIndex:0];
    NSString* itemQuantity = [userRowData objectAtIndex:1];
    NSString* itemDesc = [userRowData objectAtIndex:2];
    NSString* itemUnits = [userRowData objectAtIndex:3];
    
    NSString* keyProduct = [NSString stringWithFormat:@"PRODUCT:%d", rowIdx];
    [orderDataPost.postData setObject:itemCode forKey:keyProduct];
    
    NSString* keyProductDesc = [NSString stringWithFormat:@"PROD_DESC:%d", rowIdx];
    [orderDataPost.postData setObject:itemDesc forKey:keyProductDesc];
    
    NSString* keyQuant = [NSString stringWithFormat:@"QUANT:%d", rowIdx];
    [orderDataPost.postData setObject:itemQuantity forKey:keyQuant];
    
    NSString* keyUnit = [NSString stringWithFormat:@"UNIT:%d", rowIdx];
    [orderDataPost.postData setObject:itemUnits forKey:keyUnit];
    
    NSString* keyItemGuid = [NSString stringWithFormat:@"ITEM_GUID:%d", rowIdx];
    
    if(rowDataArray!=nil) {
        [orderDataPost.postData setObject:[rowDataArray objectAtIndex:3] forKey:keyItemGuid];
    } else {
        [orderDataPost.postData setObject:@"" forKey:keyItemGuid];
    }
    
    
    /*
    ACTION (Q | D | N)
    Q = Quantity Change
    D = Delete
    N = New Item
    */
    UIButton* actionButton =  [rowForm getActionButtonWithRowId:rowIdx];
    if(actionButton.rowState==nil) {
        // this is new row, action is new item
        NSString* keyAction = [NSString stringWithFormat:@"ACTION:%d", rowIdx];
        [orderDataPost.postData setObject:@"N" forKey:keyAction];
    } else {
        if([actionButton.rowState intValue]==0) {
            // action is to update the line item
            NSString* keyAction = [NSString stringWithFormat:@"ACTION:%d", rowIdx];
            [orderDataPost.postData setObject:@"Q" forKey:keyAction];
        } else if([actionButton.rowState intValue]==1) {
            // action is to delete item
            
            NSString* keyAction = [NSString stringWithFormat:@"ACTION:%d", rowIdx];
            [orderDataPost.postData setObject:@"D" forKey:keyAction];
        }
    }
}




- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    
    [loadingView removeView];
    
    // DotFormPost* dotFormPost = (DotFormPost*) requestedObject;
    
    if([callName isEqualToString : XmwcsConst_CALL_NAME_FOR_SUBMIT]){
        
        DocPostResponse *docPostResponse = (DocPostResponse *)respondedObject;
        NSString *message = docPostResponse.submittedMessage;
        NSString* status = docPostResponse.submitStatus;
        
        if([dotFormPost.adapterId isEqualToString: @"ADT_SAP_FORM_33_1"])
        {
            
            if((NSOrderedSame==[status compare:@"1" options:NSCaseInsensitiveSearch]) || (NSOrderedSame==[status compare:@"S" options:NSCaseInsensitiveSearch]) )
            {
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Update Order" message:message delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No" , nil];
                myAlertView.tag = 2002;
                [myAlertView show];
                
            } else {
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Info!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
                myAlertView.tag = 2004;
                [myAlertView show];
            }
        } else if([dotFormPost.adapterId isEqualToString: @"ADT_SAP_FORM_33_2"]) {
            
            if((NSOrderedSame==[status compare:@"1" options:NSCaseInsensitiveSearch]) || (NSOrderedSame==[status compare:@"S" options:NSCaseInsensitiveSearch]) )
            {
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Order Updated!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                myAlertView.tag = 2003;
                [myAlertView show];
            } else {
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Info!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                myAlertView.tag = 2004;
                [myAlertView show];
            }
        } else {
            
            
        }
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


#pragma mark - AlertView delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 2002) {
        if(buttonIndex==0) {
            NSLog(@"Pressed YES");
            dotFormPost.adapterId = @"ADT_SAP_FORM_33_2";
            loadingView = [LoadingView loadingViewInView:self.view];
            [networkHelper makeXmwNetworkCall:dotFormPost :self : nil :XmwcsConst_CALL_NAME_FOR_SUBMIT];
        } else if(buttonIndex==1) {
            NSLog(@"Pressed NO");
        }
    } else if(alertView.tag == 2003) {
        // order placed, we need to go back to previous screen.
        [ [self navigationController]  popViewControllerAnimated:YES];
        
    }  else if(alertView.tag == 2004) {
        // we need to stay here
    } else  {
        [ [self navigationController]  popViewControllerAnimated:YES];
    }

}


#pragma mark - PDF Saving


-(void)createPdfAndShare:(id) sender
{
    DotReportElement* orderElement = (DotReportElement*)[self.dotReport.reportElements objectForKey:@"ORDER"];
    NSString* orderNumber = [self computeHeaderLineValue: orderElement];
    
    NSMutableArray* orderHeader = [[NSMutableArray alloc] init];
    // first draw header data
    NSArray* headerElementIds = [DotReportDraw sortRptComponents:self.dotReport.reportElements : XmwcsConst_REPORT_PLACE_HEADER];
    
    for(int i=0; i<[headerElementIds count]; i++) {
        NSString *keyOfComp =  (NSString *) [headerElementIds objectAtIndex :i];
        DotReportElement *dotReportElement = (DotReportElement *) [self.dotReport.reportElements objectForKey:keyOfComp];
        
        NSString* headerLabel = dotReportElement.displayText;
        NSString* headerValue = [self computeHeaderLineValue: dotReportElement];
        
        if(headerValue==nil) {
            headerValue = @"";
        }
        
        NSMutableArray* lineItem = [[NSMutableArray alloc] init];
        [lineItem addObject:headerLabel];
        [lineItem addObject:headerValue];
        [orderHeader addObject:lineItem];
    }
    
    
    NSMutableArray* pdfReportTableData = [[NSMutableArray alloc] init];
    
    // table Header
    NSArray* pdfTableRowData = [self pdfReportTableHeaderData];
    [pdfReportTableData addObject:pdfTableRowData];
    
    // table Data
    NSArray* recordTableData = self.reportPostResponse.tableData;
    for(int rowIdx=0; rowIdx<[recordTableData count]; rowIdx++) {
        NSArray* rowData = [recordTableData objectAtIndex:rowIdx];
        // use 0, 1, 2, 5, 4
        NSMutableArray* pdfTableRowData = [[NSMutableArray alloc] init];
        [pdfTableRowData addObject:[rowData objectAtIndex:0]];
        [pdfTableRowData addObject:[rowData objectAtIndex:1]];
        [pdfTableRowData addObject:[rowData objectAtIndex:2]];
        [pdfTableRowData addObject:[rowData objectAtIndex:5]];
        [pdfTableRowData addObject:[rowData objectAtIndex:4]];
        [pdfReportTableData addObject:pdfTableRowData];
    }
    
    // printPDFTable for orderHeader;
    // printPDFTable for Order Line Items;
    [self savePDFFileForOrder:orderNumber orderHeader:orderHeader lineItems:pdfReportTableData];
}


-(NSArray*) pdfReportTableHeaderData
{
    NSMutableArray* pdfTableRowData = [[NSMutableArray alloc] init];
    
    NSArray* tableElementIds = [DotReportDraw sortRptComponents:self.dotReport.reportElements : XmwcsConst_REPORT_PLACE_TABLE];
    
    // use 0, 1, 2, 5, 4
    
    NSString* keyOfComp =  (NSString *) [tableElementIds objectAtIndex :0];
    DotReportElement* dotReportElement = (DotReportElement *) [self.dotReport.reportElements objectForKey:keyOfComp];
    [pdfTableRowData addObject: dotReportElement.displayText];
    
    
    keyOfComp =  (NSString *) [tableElementIds objectAtIndex :1];
    dotReportElement = (DotReportElement *) [self.dotReport.reportElements objectForKey:keyOfComp];
    [pdfTableRowData addObject: dotReportElement.displayText];

    
    keyOfComp =  (NSString *) [tableElementIds objectAtIndex :2];
    dotReportElement = (DotReportElement *) [self.dotReport.reportElements objectForKey:keyOfComp];
    [pdfTableRowData addObject: dotReportElement.displayText];
    
    keyOfComp =  (NSString *) [tableElementIds objectAtIndex :5];
    dotReportElement = (DotReportElement *) [self.dotReport.reportElements objectForKey:keyOfComp];
    [pdfTableRowData addObject: dotReportElement.displayText];
    
    
    keyOfComp =  (NSString *) [tableElementIds objectAtIndex :4];
    dotReportElement = (DotReportElement *) [self.dotReport.reportElements objectForKey:keyOfComp];
    [pdfTableRowData addObject: dotReportElement.displayText];
    

    return pdfTableRowData;
}


-(NSString*) computeHeaderLineValue:(DotReportElement*) dotReportElement
{
    NSString* headerValue = @"";
    NSMutableDictionary * headerData = self.reportPostResponse.headerData;
    
    if((dotReportElement.valueDependOn !=nil) && [self.forwardedDataDisplay objectForKey:dotReportElement.valueDependOn]!=nil) {
        headerValue = (NSString*) [self.forwardedDataDisplay objectForKey:dotReportElement.valueDependOn];
    } else {
        headerValue =  (NSString*) [headerData objectForKey:dotReportElement.elementId];
    }
    
    if(headerValue == nil) {
        headerValue = @"";
    }
    if([headerValue isEqualToString:@""] && ![dotReportElement.defaultVal isEqualToString:@""]) {
        headerValue = dotReportElement.defaultVal;
    }
    return headerValue;
}


- (IBAction)savePDFFileForOrder:(NSString*) orderNumber orderHeader:(NSArray*) orderHeader lineItems:(NSArray*) tableData
{
    NSString *pdfFileName = [self getPDFFileName: orderNumber];
    
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectZero, nil);
            
    CFRange currentRange = CFRangeMake(0, 0);
    NSInteger currentPage = 0;
    BOOL done = NO;
            
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
                
    // Draw a page number at the bottom of each page.
    currentPage++;
    [self drawPageNumber:currentPage];
    
    CGFloat headerColumnOffsets[3];
    headerColumnOffsets[0] = 50.0f;
    headerColumnOffsets[1] = 300.0f;
    headerColumnOffsets[2] = 550.0f;
    
    NSInteger pageOffset = 50;
    [self drawTableOnPDF:orderHeader columnOffsets:headerColumnOffsets pageOffset:pageOffset];
    
    
    
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
    currentPage++;
    [self drawPageNumber:currentPage];
    
    CGFloat itemDetailsOffsets[7];
    itemDetailsOffsets[0] = 50.0f;
    itemDetailsOffsets[1] = 130.0f;
    itemDetailsOffsets[2] = 280.0f;
    itemDetailsOffsets[3] = 480.0f;
    itemDetailsOffsets[4] = 540.0f;
    itemDetailsOffsets[5] = 580.0f;
    itemDetailsOffsets[6] = 640.0f;
    [self drawTableOnPDF:tableData columnOffsets:itemDetailsOffsets pageOffset:pageOffset];
    

    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
    
    
    
    // launch this pdf file using document view controller
    
    NSURL *URL = [NSURL fileURLWithPath:pdfFileName];
    
    if (URL) {
        // Initialize Document Interaction Controller
        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:URL];
        
        // Configure Document Interaction Controller
        [self.documentInteractionController setDelegate:self];
        
        // Preview PDF
        [self.documentInteractionController presentPreviewAnimated:YES];
    }
}

-(NSString*)getPDFFileName:(NSString*) orderNumber
{
    // current document directory
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* docsDir = dirPaths[0];
    
    NSString* orderFolder = [docsDir stringByAppendingPathComponent:@"CustomerOrders"];
    
    NSError* error;
    BOOL isDirectory;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:orderFolder isDirectory:&isDirectory]==NO)  {
        [[NSFileManager defaultManager] createDirectoryAtPath:orderFolder withIntermediateDirectories:NO attributes:nil error:&error];
    }
    NSDate* today = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd_HH:mm:ss"];
    
    NSString* fileName = [NSString stringWithFormat:@"%@_%@.pdf", orderNumber,  [dateFormatter stringFromDate:today] ];
    
    return [ orderFolder stringByAppendingPathComponent:fileName];
    
}


- (void)drawPageNumber:(NSInteger)pageNum
{
    NSString *pageString = [NSString stringWithFormat:@"Page %d", pageNum];
    UIFont *theFont = [UIFont systemFontOfSize:12];
    CGSize maxSize = CGSizeMake(612, 72);
    
    CGSize pageStringSize = [pageString sizeWithFont:theFont
                                   constrainedToSize:maxSize
                                       lineBreakMode:UILineBreakModeClip];
    CGRect stringRect = CGRectMake(((612.0 - pageStringSize.width) / 2.0),
                                   720.0 + ((72.0 - pageStringSize.height) / 2.0),
                                   pageStringSize.width,
                                   pageStringSize.height);
    
    [pageString drawInRect:stringRect withFont:theFont];
}



-(void) drawTableOnPDF:(NSArray*) tableData columnOffsets:(CGFloat[]) offsets pageOffset:(NSInteger) pageOffset
{
    NSInteger tableRows = [tableData count];
    NSInteger tableCols = [[tableData objectAtIndex:0] count];
    // two parts here, draw table, and draw table lines
    
    [self drawTableAt:CGPointMake(0.0f, pageOffset) rowHeight:50.0f rowCount:tableRows columnOffsets:offsets colCount:tableCols];
    
    // now draw data part here
    
    [self drawTableData:tableData at:CGPointMake(0.0f, pageOffset)
              rowHeight:50.0f
          columnOffsets:offsets
               rowCount:tableRows
            columnCount:tableCols];
    
    
}


-(void)drawTableAt:(CGPoint)origin  rowHeight:(int)rowHeight  rowCount:(NSInteger)numberOfRows columnOffsets:(CGFloat[]) offsets colCount:(NSInteger)numberOfColumns
{

    for (int i = 0; i <= numberOfRows; i++) {
        int newOrigin = origin.y + (rowHeight*i);
        CGPoint from = CGPointMake(origin.x + offsets[0], newOrigin);
        CGPoint to = CGPointMake(origin.x + offsets[numberOfColumns], newOrigin);
        [self drawLineFromPoint:from toPoint:to];
        NSLog(@"Drawing line from (%f, %f) - (%f, %f)", from.x, from.y, to.x, to.y);
    }

    
    for (int i = 0; i <= numberOfColumns; i++) {
        int newOrigin = offsets[i];
        
        CGPoint from = CGPointMake(newOrigin, origin.y);
        CGPoint to = CGPointMake(newOrigin, origin.y +(numberOfRows*rowHeight));
        [self drawLineFromPoint:from toPoint:to];
        
        NSLog(@"Drawing line from (%f, %f) - (%f, %f)", from.x, from.y, to.x, to.y);
    }
}


-(void)drawTableData:(NSArray*) tableData at:(CGPoint)origin
       rowHeight:(int)rowHeight
       columnOffsets:(CGFloat[]) offsets
        rowCount:(NSInteger)numberOfRows
      columnCount:(NSInteger)numberOfColumns
{
    int padding = 5;
    
    
    NSArray* allInfo = tableData;
    
    for(int i = 0; i < [allInfo count]; i++)
    {
        NSArray* infoToDraw = [allInfo objectAtIndex:i];
        
        for (int j = 0; j < numberOfColumns; j++)
        {
            int newOriginX = origin.x + offsets[j];
            int newOriginY = origin.y + (i*rowHeight);
            int columnWidth = offsets[j+1] - offsets[j] - (2*padding);
            
            CGRect frame = CGRectMake(newOriginX + padding, newOriginY + padding, columnWidth, rowHeight);
            
            // [self drawText:[infoToDraw objectAtIndex:j] inFrame:frame];
            
            UIFont *theFont = [UIFont systemFontOfSize:12];
            NSString* textToDraw = [infoToDraw objectAtIndex:j];
            [textToDraw drawInRect:frame withFont:theFont];
        }
    }
}


-(void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = {0.2, 0.2, 0.2, 0.3};
    CGColorRef color = CGColorCreate(colorspace, components);
    
    CGContextSetStrokeColorWithColor(context, color);
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);
}


#pragma mark - UIDocumentInteractionControllerDelegate

- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self;
}


@end
