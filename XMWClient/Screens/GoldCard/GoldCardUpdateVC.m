//
//  GoldCardUpdateVC.m
//  QCMSProject
//
//  Created by Pradeep Singh on 6/1/16.
//  Copyright © 2016 dotvik. All rights reserved.
//

#import "GoldCardUpdateVC.h"

#import "DVAppDelegate.h"
#import "ClientVariable.h"
#import "Styles.h"

#import "GoldCardSubFormVC.h"
#import "DotFormPostUtil.h"

@interface GoldCardUpdateVC ()
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
    
}
@end



@implementation GoldCardUpdateVC

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


-(void) makeReportScreenV2
{
    
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext]];
    
    // we need to add button bar above main edit form for selecting Edit mode, and then Save.
    
    // [self addButtonBar];
    
    
    [self drawEditForm];
    
    
    [self  setFormData];
    
    [self registerForKeyboardNotifications];
    
    
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



-(void)drawEditForm
{
    NSString* dotFormId = @"DOT_FORM_8_1";
    ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    
    
    DotMenuObject* formMenuObject = [[DotMenuObject alloc] init];
    formMenuObject.FORM_ID = dotFormId;
    
    dotForm = (DotForm *) [clientVariables.DOT_FORM_MAP objectForKey: dotFormId];
    if (forwardedDataDisplay == nil)
        forwardedDataDisplay   = [[NSMutableDictionary alloc] init];
    
    if (forwardedDataPost == nil)
        forwardedDataPost      = [[NSMutableDictionary alloc] init];
    
    dotFormPost = [[DotFormPost alloc] init];
    
    
    editFormVC = [[GoldCardSubFormVC alloc] initWithData :formMenuObject
                                              :dotFormPost
                                              :NO
                                              :forwardedDataDisplay
                                              :forwardedDataPost];
    editFormVC.headerStr			= dotForm.screenHeader;
    editFormVC.menuViewController = nil;
    // editFormVC.view.frame = self.view.bounds;
    
    editFormVC.view.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + 80, self.view.bounds.size.width, self.view.bounds.size.height - 80);
    
    //  editFormVC.formControlDelegate = self;
    
    editFormVC.surrogateParent = self;
    // editFormVC.reportResponseDelegate = self;
    
    [self.view addSubview:editFormVC.view];
    
    
    DotFormElement* dotFormElement = [dotForm.formElements objectForKey:@"SUBMIT"];
    if( [dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_BUTTON]) {
        MXButton* submitButton = [editFormVC getDataFromId:dotFormElement.elementId];
        
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
            } else if([dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_LABEL]) {
                MXLabel* mxLabel = (MXLabel*)[editFormVC getDataFromId:dotFormElement.elementId];
                // here we should have code for the dropdown value
                NSString* itemData = [headerData objectForKey:dotFormElement.elementId];
                mxLabel.text = itemData;
                mxLabel.attachedData = itemData;
            }
        }
    }
    
    NSArray* cardItems = self.reportPostResponse.tableData;
    
    
    // now we need to add table row data
    
    NSInteger maxRows = [cardItems count ];
    
    
    for(int i=1; i<=maxRows;i++) {
        //  NSDictionary* rowDataDict = [formData objectForKey:[NSString stringWithFormat:@"row_%d", i]];
        
        NSMutableArray* rowDataArray = [cardItems objectAtIndex:(i-1)];
        
        // we need to insert data on the new rows after rowId
        int rowId = i-1;
        
        [rowForm insertRowAfterRow:rowId withData:nil header:nil];
        
        UIView* serialNumberCell = [rowForm getRowCellWithRowId:(rowId+1) colId:0];
        MXLabel* serialNumberField = (MXLabel*)[[serialNumberCell subviews] objectAtIndex:0];
        serialNumberField.text = [NSString stringWithFormat:@"%d", i];
        
        
        UIView* customerCell = [rowForm getRowCellWithRowId:(rowId+1) colId:1];
        MXLabel* customerField = (MXLabel*)[[customerCell subviews] objectAtIndex:0];
        customerField.text = [rowDataArray objectAtIndex:0];
        
        
        UIView* receiptCell = [rowForm getRowCellWithRowId:(rowId+1) colId:2];
        MXLabel* receiptField = (MXLabel*)[[receiptCell subviews] objectAtIndex:0];
        receiptField.text = [rowDataArray objectAtIndex:1];
        
        
        UIView* cardNumberCell = [rowForm getRowCellWithRowId:(rowId+1) colId:3];
        MXTextField* cardNumberField = (MXTextField*)[[cardNumberCell subviews] objectAtIndex:0];
        NSString* cardNoString = [rowDataArray objectAtIndex:4];
        if(cardNoString !=nil && [cardNoString length]>0 && ![cardNoString isEqualToString:@"0000000000000000"]) {
            cardNumberField.text = [rowDataArray objectAtIndex:4];
            cardNumberField.enabled = NO;
        } else {
            cardNumberField.text = @"";
            cardNumberField.enabled = YES;
            cardNumberField.placeholder = @"xxxxxxxxxxxxxxxx";
        }
        cardNumberField.keyboardType = UIKeyboardTypeNumberPad;
        // cardNumberField.delegate = self;
        
        UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        
        numberToolbar.items = [NSArray arrayWithObjects:
                               [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad:)],
                               [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                               [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad:)],
                               nil];
        
        cardNumberField.inputAccessoryView = numberToolbar;
        
        
        
        UIView* fnameCell = [rowForm getRowCellWithRowId:(rowId+1) colId:4];
        
        MXTextField* fnameField = (MXTextField*)[[fnameCell subviews] objectAtIndex:0];
        fnameField.font = [UIFont systemFontOfSize:11];
        // fnameField.delegate = self;
        
        NSString* firstName = [rowDataArray objectAtIndex:5];
        if(firstName!=nil && [firstName length]>0 ) {
            fnameField.text = [rowDataArray objectAtIndex:5];
            fnameField.enabled = NO;
        } else {
            fnameField.text = @"";
            fnameField.enabled = YES;
            fnameField.placeholder = @"First Name";
        }
        fnameField.backgroundColor = [UIColor clearColor];
        fnameField.textColor = [UIColor blackColor];
        
        
        UIView* lnameCell = [rowForm getRowCellWithRowId:(rowId+1) colId:5];
        
        MXTextField* lnameField = (MXTextField*)[[lnameCell subviews] objectAtIndex:0];
        lnameField.font = [UIFont systemFontOfSize:11];
        // lnameField.delegate = self;
        
        NSString* lastName = [rowDataArray objectAtIndex:6];
        if(lastName!=nil && [lastName length]>0) {
            lnameField.text = [rowDataArray objectAtIndex:6];
            lnameField.enabled = NO;
        } else {
            lnameField.text = @"";
            lnameField.enabled = YES;
            lnameField.placeholder = @"Last Name";
        }
        lnameField.backgroundColor = [UIColor clearColor];
        lnameField.textColor = [UIColor blackColor];

        
    }
}



#pragma  mark - TextField inputaccessory view button events
-(void)cancelNumberPad:(id) sender
{
    [activeTextField resignFirstResponder];
    // activeTextField.text = @"";
}

-(void)doneWithNumberPad:(id) sender
{
    // NSString *numberFromTheKeyboard = activeField.text;
    [activeTextField resignFirstResponder];
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



#pragma mark - SubmitClicked

-(IBAction)submitPressed:(id)sender
{
    DotFormPost* needToPost = [self createGoldCardDataForSubmit];
    if(needToPost!=nil) {
        [needToPost setAdapterId: dotForm.submitAdapterId];
        [needToPost setDocId : dotForm.formId];
        [needToPost setDocDesc : dotForm.screenHeader];
        [needToPost setAdapterType:dotForm.adapterType];
        [needToPost setModuleId: [DVAppDelegate currentModuleContext]];
        
        DotFormPostUtil* postUtil = [[DotFormPostUtil alloc] init];
        [postUtil incrementMaxDocId : needToPost];
        
        dotFormPost = needToPost;
        
        loadingView = [LoadingView loadingViewInView:self.view];
        networkHelper = [[NetworkHelper alloc] init];
        [networkHelper makeXmwNetworkCall:dotFormPost :self : nil :XmwcsConst_CALL_NAME_FOR_SUBMIT];
        
    } else {
        // means some validation failed
    }
}


-(DotFormPost*) createGoldCardDataForSubmit
{
    BOOL validationNotFailed = YES;
    NSString* validationMessage = @"";
    
    DotFormPost* goldCardPost = nil;
    
    DotForm* formDef = dotForm;
    
    NSArray* addRowDotFormElementArray = formDef.addRowFormElements;
    NSArray* nonAddRowDotFormElementArray = formDef.nonAddRowFormElements;
    
    
    NSMutableDictionary* reportElements = self.dotReport.reportElements;
    
    NSArray* cardItems = self.reportPostResponse.tableData;
    
    // now we need to add table row data
    
    NSInteger maxRows = [cardItems count ];
    
    NSMutableArray *sortedElementIds = [DotReportDraw sortRptComponents:self.dotReport.reportElements :XmwcsConst_REPORT_PLACE_TABLE];
    
    for(int i=1; i<=maxRows && (validationNotFailed == YES);i++) {
         NSMutableArray* rowDataArray = [cardItems objectAtIndex:(i-1)];
        // we need to check if this row to be submitted
        if([self needToSubmit:rowDataArray]) {
            int flag = [self validateRowSubmit:i rowData:rowDataArray];
            
            // we can send data when flag == -1
            switch (flag) {
                case -1:
                    NSLog(@"We can submit this row");
                    if(goldCardPost==nil) {
                        goldCardPost = [[DotFormPost alloc] init];
                    }
                    [self addUserGoldCardDetails:i rowData:rowDataArray into:goldCardPost];
                    break;
                case 0:
                    NSLog(@"We need to ignore this row");
                    break;
                case 1:
                    validationMessage = @"Card validation fails, not 16 digits";
                    validationNotFailed = NO;
                    break;
                case 2:
                    validationMessage = @"Card validation fails, last 4 digits not matching.";
                    validationNotFailed = NO;
                    break;
                case 3:
                    validationMessage = @"Name Validation fails, first name and last name pair matches with existing one.";
                    validationNotFailed = NO;
                    break;
                default:
                    break;
            }
        }
    }
    
    if(goldCardPost==nil && [validationMessage length]>0 && validationNotFailed == NO) {
        NSLog(@"%@", validationMessage);
        [[[UIAlertView alloc] initWithTitle:@"Gold Card Validation" message:validationMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        // show alert message
    }
    
    return goldCardPost;
}

// if we need to submit this row
-(BOOL) needToSubmit:(NSArray*) rowDataArray
{
    BOOL retVal = NO;
    // index 4, 5, 6 content empty then this row data can be submitted
    
    NSString* cardNo = [rowDataArray objectAtIndex:4];
    NSString* firstName = [rowDataArray objectAtIndex:5];
    NSString* lastName = [rowDataArray objectAtIndex:6];
    if(([cardNo length]==0 || [cardNo isEqualToString:@"0000000000000000"]) && [firstName length]==0 && [lastName length]==0) {
        return YES;
    }
    return retVal;
}

// need to validate if row data is valid for submission
-(int) validateRowSubmit:(int) rowIdx rowData:(NSArray*) rowDataArray
{
    int status = -1;
    
    DVTableFormView* rowForm  = (DVTableFormView*)editFormVC.rowFormInSameForm;
    
    // filled card no should be 16 and matched with last 4 digit in rowData
    UIView* rowContent = [rowForm getRowWithRowId:rowIdx];
    NSArray* userRowData = [rowForm.rowDelegate rowDataForSubmit:rowContent forRow:rowIdx];
    
    NSString* validationDigits = [rowDataArray objectAtIndex:2];
    NSString* userEnteredCard = [userRowData objectAtIndex:3];
   
    
    NSString* userEnteredFirstName = [userRowData objectAtIndex:4];
    NSString* userEnteredLastName = [userRowData objectAtIndex:5];
    
    //
    // if userEnteredCard,  userEnteredFirstName and userEnteredLastName are empty then we have to ignore the row
    //
    if([userEnteredCard length] == 0 &&  [userEnteredFirstName length] == 0 && [userEnteredLastName length] == 0) {
        // ignore this row
        status = 0;
        
    } else {
        if([userEnteredCard length]==16) {
            // Need to check if last 4 digits matches with validationDigits
            NSRange trange;
            trange.location = 12;
            trange.length = 4;
            if([userEnteredCard compare:validationDigits options:NSLiteralSearch range:trange]==NSOrderedSame) {
                // filled first name and last name cannot be empty, and must not repeat anywhere
                // validate name, it should not be in nameMaster data
                if([self validateFirstName:userEnteredFirstName lastName:userEnteredLastName ignoreRow:rowIdx]==NO) {
                    status = 3;
                }
            } else  {
                // card validation failed
                status = 2; //
            }
        } else {
            // card validation failed
            status = 1; //
        }
    }
    return status;
}


// user cannot enter the same firstname and lastname pair in any row
-(BOOL) validateFirstName:(NSString*) firstName lastName:(NSString*) lastName ignoreRow:(int) rowIdx
{
    BOOL retVal = YES;
    
    DVTableFormView* rowForm  = (DVTableFormView*)editFormVC.rowFormInSameForm;
    
    NSInteger maxRows = [self.reportPostResponse.tableData count];
    
    for(int i=1; i<=maxRows; i++) {
        
        UIView* rowContent = [rowForm getRowWithRowId:i];
        NSArray* rowData = [rowForm.rowDelegate rowDataForSubmit:rowContent forRow:i];
        
        if(i!=rowIdx) {
            NSString* part01 = [rowData objectAtIndex:4];
            NSString* part02 = [rowData objectAtIndex:5];
            
            if( ([firstName caseInsensitiveCompare:part01] == NSOrderedSame)
                   && ([lastName caseInsensitiveCompare:part02] == NSOrderedSame)) {
                retVal = NO;
            } else if( ([firstName caseInsensitiveCompare:part02] == NSOrderedSame)
                          && ([lastName caseInsensitiveCompare:part01] == NSOrderedSame)) {
                retVal = NO;
            }
        }
    }
    return retVal;
}


-(void) addUserGoldCardDetails:(int) rowIdx rowData:(NSArray*) rowDataArray into:(DotFormPost*) goldCardPost
{
    [goldCardPost.postData setObject:[NSString stringWithFormat:@"%d", rowIdx] forKey: dotForm.tableName];
    
    
    [goldCardPost.postData setObject:@"row added" forKey:[NSString stringWithFormat:@"%@:%d", dotForm.tableName, rowIdx]];
    
    
    DVTableFormView* rowForm  = (DVTableFormView*)editFormVC.rowFormInSameForm;
    
    // filled card no should be 16 and matched with last 4 digit in rowData
    UIView* rowContent = [rowForm getRowWithRowId:rowIdx];
    NSArray* userRowData = [rowForm.rowDelegate rowDataForSubmit:rowContent forRow:rowIdx];
    
    NSString* userEnteredCard = [userRowData objectAtIndex:3];
    NSString* userEnteredFirstName = [userRowData objectAtIndex:4];
    NSString* userEnteredLastName = [userRowData objectAtIndex:5];
    
    NSString* keyKunnr = [NSString stringWithFormat:@"KUNNR:%d", rowIdx];
    [goldCardPost.postData setObject:[userRowData objectAtIndex:1] forKey:keyKunnr];
    
    
    NSString* keyRefNo = [NSString stringWithFormat:@"REF_NO:%d", rowIdx];
    [goldCardPost.postData setObject:[userRowData objectAtIndex:2] forKey:keyRefNo];
    
    NSString* keyLastCardNo = [NSString stringWithFormat:@"LAST_CARD_NO:%d", rowIdx];
    [goldCardPost.postData setObject:[rowDataArray objectAtIndex:2] forKey:keyLastCardNo];
    
    NSString* keyDESPDT = [NSString stringWithFormat:@"DESPDT:%d", rowIdx];
    [goldCardPost.postData setObject:[rowDataArray objectAtIndex:3] forKey:keyDESPDT];
    
    
    NSString* keyCardNo = [NSString stringWithFormat:@"CARD_NO:%d", rowIdx];
    [goldCardPost.postData setObject:userEnteredCard forKey:keyCardNo];
    
    
    NSString* keyFNAME = [NSString stringWithFormat:@"FNAME:%d", rowIdx];
    [goldCardPost.postData setObject:userEnteredFirstName forKey:keyFNAME];
    
    
    NSString* keyLNAME = [NSString stringWithFormat:@"LNAME:%d", rowIdx];
    [goldCardPost.postData setObject:userEnteredLastName forKey:keyLNAME];
    
}



- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    
    [loadingView removeView];
    
    DotFormPost* dotFormPost = (DotFormPost*) requestedObject;
    
    if([callName isEqualToString : XmwcsConst_CALL_NAME_FOR_SUBMIT]){
        
        
            DocPostResponse *docPostResponse = (DocPostResponse *)respondedObject;
            NSString *message = docPostResponse.submittedMessage;
            NSString* status = docPostResponse.submitStatus;
            
            if((NSOrderedSame==[status compare:@"1" options:NSCaseInsensitiveSearch]) || (NSOrderedSame==[status compare:@"S" options:NSCaseInsensitiveSearch]) )
            {
                    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Gold Card Scheme" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
                    myAlertView.tag = 2004;
                    [myAlertView show];
                
            } else {
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Info!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
                myAlertView.tag = 2005;
                [myAlertView show];
            }
    }
}

- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];
    
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Response!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
    
}

- (void) httpInterruptHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];
    
    
    
}

@end
