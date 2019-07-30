//
//  DotFormPostUtil.m
//  QCMSProject
//
//  Created by Ashish Tiwari on 01/07/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "DotFormPostUtil.h"
#import "XmwcsConstant.h"
#import "FormVC.h"
#import "MXTextField.h"
#import "XmwUtils.h"
#import "CheckBoxButton.h"
#import "DropDownTableViewCell.h"
#import "DotFormPost.h"
#import "DotForm.h"
#import "ClientUserLogin.h"
#import "LabelTableViewCell.h"
#import "ClientVariable.h"
#import "AppConstants.h"
#import "DotDropDownPicker.h"
#import "LanguageConstant.h"
#import "MandatoryAlertDelegate.h"
#import "DVAppDelegate.h"
#import "ObjectStorage.h"
#import "NetworkHelper.h"
#import "RecentRequestStorage.h"
#import "RecentRequestItem.h"
#import "JSONDataExchange.h"
#import "SBJson.h"
#import "DVTableFormView.h"
#import "NSDate+Helpers.h"

#import "DotMenuObject.h"
#import "CreateOrderVC.h"

#import "EditSearchField.h"
#import "MultiSelectViewCell.h"
#import "MultiSelectSearchViewCell.h"
#import "BarCodeScanField.h"
#import "CreateOrderVC2.h"
#import "AttachmentViewCell.h"
#import "RMAVC2.h"
#import "RMAVC.h"


@implementation DotFormPostUtil


-(BOOL) mandatoryCheckOfDotFormElement : (DotFormElement *) dotFormElement : (FormVC *) baseForm
{
   
    NSString *componentType = dotFormElement.componentType;
    NSString *id = dotFormElement.elementId;
    
    NSString* componentName = dotFormElement.displayText;  
    NSString *mandatoryMessage = @"";
    
    MandatoryAlertDelegate* alertDelegate = [[MandatoryAlertDelegate alloc] init];
       
    if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_TEXTFIELD]
        || [componentType isEqualToString : XmwcsConst_DE_COMPONENT_TEXTFIELD_PASSWORD]
        || [componentType isEqualToString : XmwcsConst_DE_COMPONENT_TEXTFIELD])
    {
        MXTextField *textField = (MXTextField *) [baseForm getDataFromId: dotFormElement.elementId];

        if([textField.text isEqualToString : @""])
        {
            mandatoryMessage = [XmwUtils makeLanguageText : LangConst_PLEASE_ENTER : YES : componentName : NO];
        }
    }
    else if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_TEXTAREA])
    {
        MXTextField *textField = (MXTextField *) [baseForm getDataFromId: dotFormElement.elementId];
         if([textField.text isEqualToString : @""])
         {
            mandatoryMessage = [XmwUtils makeLanguageText : LangConst_PLEASE_ENTER : YES : componentName : NO];
        }
    }
    else if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_DROPDOWN])
    {
        MXTextField *dropDownField = [baseForm getDataFromId: dotFormElement.elementId];
        
        if ([dropDownField.text isEqualToString:@""])//== 0)
        {
            mandatoryMessage = [XmwUtils makeLanguageText : LangConst_PLEASE_SELECT : YES : componentName : NO];
        }
    }
    else if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_CHECKBOX_GROUP])
    {
        // todo later, don't know when we have to use checkbox group
        
    }
    else if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_CHECKBOX]) {
       
        // tushar code
        MXButton *mxButton  = (MXButton*)[baseForm getDataFromId:dotFormElement.elementId];
        CheckBoxButton* checkBoxButton = (CheckBoxButton*)mxButton.parent;
        
//         CheckBoxButton *checkBoxButton = (CheckBoxButton *)[baseForm getDataFromId:dotFormElement.elementId];
        
        if (checkBoxButton.isChecked) {
            mandatoryMessage = @"";
        }
    } else if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_LABEL]) {
    } else if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_TIME_FIELD]) {
        MXTextField *timeField = (MXTextField *) [baseForm getDataFromId: dotFormElement.elementId];
        
        if([timeField.text isEqualToString : @""])
        {
            mandatoryMessage = [XmwUtils makeLanguageText : LangConst_PLEASE_ENTER : YES : componentName : NO];
        }

    }else if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_DATE_FIELD]){
        MXTextField *calendarField = (MXTextField *) [baseForm getDataFromId: dotFormElement.elementId];
        
        if([calendarField.text isEqualToString : @""])
        {
            mandatoryMessage = [XmwUtils makeLanguageText : LangConst_PLEASE_ENTER : YES : componentName : NO];
        }
        
    }
    else if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_RADIO_GROUP]) {
        // Need to add this in future
        //radio group requirement is typically handled in dropdown control
        
        
    } else if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_SEARCH_FIELD]) {
        MXTextField *dropDownField = [baseForm getDataFromId: dotFormElement.elementId];
        
        if ([dropDownField.text isEqualToString:@""])//== 0)
        {
            mandatoryMessage = [XmwUtils makeLanguageText : LangConst_PLEASE_SELECT : YES : componentName : NO];
        }
    } else if([componentType isEqualToString : XmwcsConst_DE_COMPONENT_EDIT_SEARCH_FIELD]) {
        EditSearchField* editSearchField = (EditSearchField *) [baseForm getDataFromId: dotFormElement.elementId];
        if([editSearchField.editText.text isEqualToString:@""]) {
            mandatoryMessage = [XmwUtils makeLanguageText : LangConst_PLEASE_ENTER : YES : componentName : NO];
        }
    } else if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_MULTI_SELECT] ) {
        
        MultiSelectViewCell* multiSelectControl = (MultiSelectViewCell *) [baseForm getDataFromId:dotFormElement.elementId];
        if([multiSelectControl isKindOfClass:[MultiSelectViewCell class]]) {
            if([[multiSelectControl selectedValueItems] count]==0) {
                
                mandatoryMessage = [XmwUtils makeLanguageText : LangConst_PLEASE_SELECT : YES : componentName : NO];
            }
        } else if([multiSelectControl isKindOfClass:[MXTextField class]]) {
            MXTextField* textField = (MXTextField*)multiSelectControl;
            if([textField.text isEqualToString:@""]) {
                mandatoryMessage = [XmwUtils makeLanguageText : LangConst_PLEASE_SELECT : YES : componentName : NO];
            }
        }
    } else if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_MULTI_SELECT_SEARCH] ) {
        
        MultiSelectSearchViewCell* multiSelectSearchControl = (MultiSelectSearchViewCell *) [baseForm getDataFromId:dotFormElement.elementId];
        if([[multiSelectSearchControl selectedValueItems] count]==0) {
            mandatoryMessage = [XmwUtils makeLanguageText : LangConst_PLEASE_SELECT : YES : componentName : NO];
        }
    } else if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_BARCODE_SCAN_FIELD]) {
        BarCodeScanField* barCodeScanField = (BarCodeScanField *) [baseForm getDataFromId:dotFormElement.elementId];
        if([barCodeScanField.editText.text isEqualToString:@""]) {
            mandatoryMessage = [XmwUtils makeLanguageText : LangConst_PLEASE_ENTER : YES : componentName : NO];
        }
    }
    
    
    
    else if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_ATTACHMENT_BUTTON]) {
        AttachmentViewCell* attchmentButton = (AttachmentViewCell *) [baseForm getDataFromId:dotFormElement.elementId];
        if(attchmentButton.ufmrefid==nil) {
            mandatoryMessage = [XmwUtils makeLanguageText : LangConst_PLEASE_SELECT : YES : componentName : NO];
        }
    }
    
    if (![mandatoryMessage isEqualToString :@""]) {
       // UIAlertView * alertView = [[UIAlertView alloc]  initWithTitle:@"Mandatory Validations" message: mandatoryMessage delegate:alertDelegate cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
       // [baseForm.view addSubview:alertView];
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Mandatory Validations" message:mandatoryMessage delegate:baseForm cancelButtonTitle:@"Ok" otherButtonTitles:nil , nil];
		myAlertView.tag = 1;
        
        [myAlertView show];
       
        
        return true;
    }
    return false;
    
}
-(void) mandatoryCheckForCheckBoxGroup : (NSString *) name : (FormVC *) baseForm
{
    
}
-(BOOL) checkForPasswordConfirm : (DotForm *) formDef : (FormVC *) baseForm
{
    MXTextField *textFieldNewPass = (MXTextField *)[baseForm getDataFromId: @"NEW_PASSWORD"];
    MXTextField *textFieldConfirmPass = (MXTextField *)[baseForm getDataFromId: @"CONFIRM_PASSWORD"];
    if (![textFieldNewPass.text isEqualToString : textFieldConfirmPass.text])
    {
        MandatoryAlertDelegate* alertDelegate = [[MandatoryAlertDelegate alloc] init];
        
        UIAlertView * alertView = [[UIAlertView alloc]  initWithTitle:@"Mandatory Validations" message: [XmwUtils getLanguageConstant : LangConst_CONFIRM_PASS] delegate:alertDelegate cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [baseForm.view addSubview:alertView];
      
        return false;
    }
    return true;
 
}
-(BOOL) mandatoryCheck : (DotForm *) formDef : (FormVC *) baseForm
{
 
    //// for simpleform with addrow (like create order form
    NSString* addRowFieldsString = [formDef.extendedPropertyMap objectForKey:@"ADD_ROW_FIELD"];
    NSArray *addRowFields = nil;
    if(addRowFieldsString!=nil) {
        addRowFields = [XmwUtils breakStringTokenAsVector : addRowFieldsString : @"$"];
    } else {
        addRowFields = [[NSArray alloc] init];
    }
    
    NSString* nonAddRowFieldsString = [formDef.extendedPropertyMap objectForKey:@"NON_ADD_ROW_FIELD"];
    NSArray *nonAddRowFields = nil;
    
    if(nonAddRowFieldsString!=nil) {
        nonAddRowFields = [XmwUtils breakStringTokenAsVector : nonAddRowFieldsString : @"$"];
    } else {
        nonAddRowFields = [[NSArray alloc] init];
    }
    //// endfor
    
    
    NSMutableDictionary *dotFormElements =  formDef.formElements;
    NSMutableArray *sortedElements 	=  [XmwUtils  sortedDotFormElementIds : dotFormElements];
    
    // FROM_DATE, TO_DATE
    NSMutableArray *dotFormElementIdArray = [[NSMutableArray alloc] init];
    for (int i=0; i<sortedElements.count; i++) {
        DotFormElement *dotFormElement  = (DotFormElement*)[sortedElements objectAtIndex:i];
        [dotFormElementIdArray addObject: dotFormElement.elementId];
        
    }
    
    if ([dotFormElementIdArray containsObject:@"FROM_DATE"] && [dotFormElementIdArray containsObject:@"TO_DATE"]) {
        
        MXTextField* begdaDateTF = (MXTextField*)[baseForm getDataFromId : @"FROM_DATE"];
        MXTextField* enddaDateTF = (MXTextField*)[baseForm getDataFromId : @"TO_DATE"];
        
        if (begdaDateTF != nil && enddaDateTF != nil) {
            
            NSString* fromDateTime = [NSString stringWithFormat:@"%@", begdaDateTF.text];
            NSString* toDateTime = [NSString stringWithFormat:@"%@", enddaDateTF.text];
            
            if(![self validateRange:baseForm fromDate:fromDateTime toDate:toDateTime])
            {
                return false;
            }
        }
        
        
    }
    
    
    for (int cntElement = 0; cntElement < [sortedElements count]; cntElement++) {
        DotFormElement *dotFormElement  = (DotFormElement*)[sortedElements objectAtIndex:cntElement];
        
        if(addRowFieldsString!=nil) {
            if(![dotFormElement isOptionalBool] && ![XmwUtils exists:dotFormElement.elementId InArray:addRowFields]) {
                BOOL check = [self mandatoryCheckOfDotFormElement : dotFormElement : baseForm];
                if(check) {
                    return false;
                }
            }
        }
        
        else {
            if (![dotFormElement isOptionalBool] && [self mandatoryCheckOfDotFormElement : dotFormElement : baseForm])
            {
                return false;
            }
        }
    }
    
    // checking number of rows in the simple add row form in the same ui
    if([formDef.formSubType isEqualToString:XmwcsConst_DF_FORM_TYPE_SIMPLEADDROW_SAMEFORM]) {
        DVTableFormView* rowForm = (DVTableFormView*)baseForm.rowFormInSameForm;
        if( ([rowForm getRowCount]==0 ) && [formDef.formId isEqualToString:@"DOT_FORM_31"]) {
            
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Mandatory Validations" message:@"Please add atleast one item." delegate:baseForm cancelButtonTitle:@"Ok" otherButtonTitles:nil , nil];
            myAlertView.tag = 1;
            
            [myAlertView show];
            
            return false;
        } else {
            return true;
        }
        
    }
    
    if ([formDef.formSubType isEqualToString : XmwcsConst_DF_FORM_TYPE_CHANGE_PASSWORD])
    {
        return [self checkForPasswordConfirm : formDef : baseForm];
    }
    
    if([[DVAppDelegate currentModuleContext]isEqualToString:XmwcsConst_APP_MODULE_ESS] && [formDef.formId isEqualToString:@"DOT_FORM_2"])
    {
		
        if(![self checkForLeaveReqDates:baseForm])
        {
			return false;
		}
	}
    
    return true;
      
}

-(DotFormPost *) checkTypeOfFormAndSubmit : (DotForm *) formDef : (FormVC *) baseForm : (DotFormPost *) formPost :(NSMutableDictionary *) forwardedDataDisplay :(NSMutableDictionary *) forwardedDataPost :(bool) isSubmitOnServer : (DotFormElement *) dotFormElement
{
    if([formDef.formSubType isEqualToString:XmwcsConst_DF_FORM_TYPE_ADD_ROW])
    {
		// we need to read row table data which can be submitted as table data
		
       // Container* formContainer = baseForm->getPage()->findChild <Container*> ("formContainer");
        UIView* formContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
        UIView* tableContainer = [[UIView alloc]init];
        [tableContainer addSubview:formContainer];
        // Container* tableContainer = formContainer->findChild <Container*> ("tableContainer");
       // if((tableContainer!=0)  && ([tableContainer count]>0))
        if((tableContainer!=0))
        {
            return[self submitSimpleForm : formDef : baseForm : formPost : forwardedDataDisplay : forwardedDataPost : false : isSubmitOnServer : dotFormElement];
        }
        else
        {
            return[self submitSimpleForm : formDef : baseForm : formPost : forwardedDataDisplay : forwardedDataPost : true : isSubmitOnServer : dotFormElement];
        }
        
        
	} else if([formDef.formSubType isEqualToString:XmwcsConst_DF_FORM_TYPE_SIMPLEADDROW_SAMEFORM]) {
        // to do here,
        DVTableFormView* rowForm = (DVTableFormView*)baseForm.rowFormInSameForm;
        [self getSameFormRowData:rowForm :formDef :formPost];
        return [self submitSimpleForm : formDef :baseForm : formPost : forwardedDataDisplay : forwardedDataPost : true : isSubmitOnServer : dotFormElement];
    } else {
		return [self submitSimpleForm : formDef :baseForm : formPost : forwardedDataDisplay : forwardedDataPost : true : isSubmitOnServer : dotFormElement];
	}
    
	return formPost;
    
}

-(void) getSameFormRowData:  (DVTableFormView*) rowForm : (DotForm *) formDef : (DotFormPost *) formPost
{
    NSString* addRowFieldsString = [formDef.extendedPropertyMap objectForKey:@"ADD_ROW_FIELD"];
    NSArray *addRowFields = nil;
    if(addRowFieldsString!=nil) {
        addRowFields = [XmwUtils breakStringTokenAsVector : addRowFieldsString : @"$"];
    } else {
        addRowFields = [[NSArray alloc] init];
    }
    
    NSString* nonAddRowFieldsString = [formDef.extendedPropertyMap objectForKey:@"NON_ADD_ROW_FIELD"];
    NSArray *nonAddRowFields = nil;
    
    if(nonAddRowFieldsString!=nil) {
        nonAddRowFields = [XmwUtils breakStringTokenAsVector : nonAddRowFieldsString : @"$"];
    } else {
        nonAddRowFields = [[NSArray alloc] init];
    }
    
    NSMutableDictionary *dotFormElements = (NSMutableDictionary *)[formDef formElements];
    NSMutableArray *sortedElements =[DotFormDraw sortFormComponents : dotFormElements];
    NSMutableArray* addRowDotFormElementArray = [[NSMutableArray alloc] init];
    
    int cntElement = 0;
    for(cntElement = 0; cntElement < [sortedElements count] ; cntElement++)
    {
        DotFormElement* dotFormElement = (DotFormElement *)[dotFormElements objectForKey:[sortedElements objectAtIndex:cntElement]];
    
        // NSString* tag = dotFormElement.elementId;
        
        if([XmwUtils exists:dotFormElement.elementId InArray:addRowFields]) {
            [addRowDotFormElementArray addObject:dotFormElement];
        }
    }
    
    
    // need to get the data
    if(rowForm!=nil) {
        // rowForm.rowDelegate
        int maxRows = [rowForm getRowCount];
        [formPost.postData setObject:[NSString stringWithFormat:@"%d", maxRows] forKey:formDef.tableName];
        for(int i=1; i<=maxRows; i++) {
            // rows start with i=1
            UIView* rowContent = [rowForm getRowWithRowId:i];
            NSArray* rowData = [rowForm.rowDelegate rowDataForSubmit:rowContent forRow:i];
            
            @try {
                int colIdx = 0;
                for (DotFormElement* dotFormElement in addRowDotFormElementArray) {
                    NSString* rowColumnDataKey = [NSString stringWithFormat:@"%@:%d", dotFormElement.elementId, i];
                    NSString* value  = (NSString*)[rowData objectAtIndex:colIdx];
                    NSLog(@"Debug getSameFormElementData key:  %@", rowColumnDataKey);
                    NSLog(@"Debug getSameFormElementData value:  %@", value);
                    [formPost.postData setObject:value forKey:rowColumnDataKey];
                    [formPost.displayData setObject:value forKey:rowColumnDataKey];
                    colIdx = colIdx + 1;
                }
                NSString* rowKey = [NSString stringWithFormat:@"%@:%d",   formDef.tableName, i];
                [formPost.postData setObject:@"row added" forKey:rowKey];
            }
            @catch (NSException *exception) {
                NSLog(@"This row =%d is invalid. got Excetion %@", i,exception.description);
            }
            @finally {
                NSLog(@"Processing row=%d", i);
            }
            
        }
    }
}

-(DotFormPost *) submitSimpleForm : (DotForm *) formDef : (FormVC *)baseForm : (DotFormPost *)formPost : (NSMutableDictionary *)forwardedDataDisplay : (NSMutableDictionary *)forwardedDataPost : (BOOL)getEnteredData: (BOOL)isSubmitOnServer : (DotFormElement *) dotFormElement
{
    
    BOOL mandatoryCheck = true;
    
    if(getEnteredData) {
        mandatoryCheck = [self mandatoryCheck : formDef : baseForm];
    }
    
    if(mandatoryCheck) {
    
        if (formPost == nil)   {
            formPost = [[DotFormPost alloc]init];
        }
        [formPost setAdapterId: formDef.submitAdapterId];
        NSLog(@"%@",formDef.submitAdapterId);
        // patch for CreateOrder for dealerKonnect
        if([AppConst_MOBILET_ID_DEFAULT isEqualToString:@"xhavellsdealer"] && [formPost.adapterId isEqualToString: @"ADT_SAP_FORM_3" ]){
            formPost.adapterId = @"ADT_SAP_FORM_31";
        }
        
        [formPost setDocId : formDef.formId];
        [formPost setDocDesc : formDef.screenHeader];
        [formPost setAdapterType:formDef.adapterType];
        [formPost setModuleId: [DVAppDelegate currentModuleContext]];
              
        //IF we submit the direct Report then there is not any component in form
        if ([formDef.formSubType isEqualToString : XmwcsConst_DOC_TYPE_VIEWDIRECT] || [formDef.formSubType isEqualToString : XmwcsConst_DOC_TYPE_VIEWDIRECT_EDIT])
        {
            return formPost;
        }
        if(getEnteredData){//gather data if not add row form, or if no row added in add row
            [self getFormComponentData : formDef : baseForm : formPost :  @"" : forwardedDataDisplay : forwardedDataPost];
        }
               
        [self incrementMaxDocId : formPost];
    
    
        if((formDef.tableName  !=nil) && ([formPost.postData objectForKey:formDef.tableName] == nil))
        {
            [formPost.postData setObject:@"row added" forKey:[formDef.tableName stringByAppendingString:@":1"]];
            [formPost.postData setObject:@"1" forKey: formDef.tableName];
        //dotFormPost.getPostData().put(dotForm.getTableName(), new Integer(1));
        }
        
        if(isSubmitOnServer)
        {
            if ([formDef.formType isEqualToString : XmwcsConst_DOC_TYPE_SUBMIT]){
                if([formDef.formSubType isEqualToString:XmwcsConst_DF_FORM_TYPE_CHANGE_PASSWORD])
                {
                    [baseForm networkCall:formPost :XmwcsConst_CALL_NAME_FOR_CHANGE_PASSWORD];
                } else {
                    [baseForm networkCall:formPost :XmwcsConst_CALL_NAME_FOR_SUBMIT];
                    
                   // if(ClientConstants.MOBILET_ID_DEFAULT.equals("xhavellsdealer") && dotFormPost.getAdapterId().equals("ADT_SAP_FORM_31")){

                    if([AppConst_MOBILET_ID_DEFAULT isEqualToString:@"xhavellsdealer"] && [formPost.adapterId isEqualToString: @"ADT_SAP_FORM_31" ])
                    {
                        NSLog(@"It is create order form, not storing in the recent requests");
                    } else {
                        [self storeRecentRequest : formDef : formPost : 0 : false];
                    }
                }
            } else if ([formDef.formType isEqualToString : XmwcsConst_DOC_TYPE_VIEW_EDIT]) {
                [baseForm networkCall:formPost :XmwcsConst_CALL_NAME_FOR_VIEW_EDIT];
            } else if ([formDef.formType isEqualToString : XmwcsConst_DOC_TYPE_VIEW]) {
                [self addCachePolicy:formPost forTheForm:formDef];
                [baseForm networkCall:formPost :XmwcsConst_CALL_NAME_FOR_REPORT];
            }
        } else {
           // NSMutableDictionary *addedData = [[NSMutableDictionary alloc]init];
           // [addedData setObject:dotFormElement.dependedCompValue forKey:XmwcsConst_MENU_CONSTANT_FORM_ID];
           // [addedData setObject:dotFormElement.displayText forKey:XmwcsConst_MENU_CONSTANT_MENU_NAME];
            
             DotMenuObject *addedData = [[DotMenuObject alloc] init];
            addedData.FORM_ID = dotFormElement.dependedCompValue;
            addedData.MENU_NAME = dotFormElement.displayText;
            
            if ([dotFormElement.dependedCompValue isEqualToString:@"DOT_FORM_RMA"]) {
             
                RMAVC2 *nextDotForm = [[RMAVC2 alloc] initWithNibName:@"RMAVC2" :addedData :formPost :false :forwardedDataDisplay :forwardedDataPost];
    
                [[baseForm.self navigationController] pushViewController:nextDotForm  animated:YES];
            } else  if([dotFormElement.dependedCompValue isEqualToString:@"DOT_FORM_31"]) {
                //my code
                CreateOrderVC2 *nextDotForm = [[CreateOrderVC2 alloc] initWithNibName:@"CreateOrderVC2" :addedData :formPost :false :forwardedDataDisplay :forwardedDataPost];
        
                [[baseForm.self navigationController] pushViewController:nextDotForm  animated:YES];
                
            } else {
//                FormVC *nextDotForm = [[FormVC alloc] initWithData:addedData :formPost :false :forwardedDataDisplay :forwardedDataPost];
//
//                [[baseForm.self navigationController] pushViewController:nextDotForm  animated:YES];
            }
           

            
        
           
        
        }
        return formPost;
    } else {
        
                    // Since mandatory check failed, notthing will be posted actually on server.
            return 0;
    }
    
    
}

-(void) getFormComponentData : (DotForm *) formDef : (FormVC *) baseForm : (DotFormPost*) formPost : (NSString *)appendStr : (NSMutableDictionary *)forwardedDataDisplay : (NSMutableDictionary *) forwardedDataPost
{
    NSMutableDictionary *dotFormElements = formDef.formElements;
    
    NSArray *sortedElements 	=  [XmwUtils  sortedDotFormElementIds : dotFormElements];//[formDef formElements]];
    
    for (int cntElement = 0; cntElement < [sortedElements count]; cntElement++) {
        DotFormElement *dotFormElement  = (DotFormElement*)[sortedElements objectAtIndex:cntElement];
        NSMutableArray *elementValue =[self getDotFormElementData : dotFormElement :baseForm];
        
        if(elementValue.count>0) {
            NSString *valueToSubmit = elementValue[0];
            NSString *valueToDisplay = elementValue[1];
       
            if(valueToSubmit!=nil) {
                [formPost.postData setObject:valueToSubmit forKey: [dotFormElement.elementId  stringByAppendingString : appendStr]];
                if(valueToDisplay==nil)
                    valueToDisplay = @"";
                [formPost.displayData setObject:valueToDisplay forKey: [dotFormElement.elementId  stringByAppendingString : appendStr]];
            }
        
            if(dotFormElement.isUseForward) {
                if(valueToSubmit!=nil) {
                    [forwardedDataPost setObject:valueToSubmit forKey:dotFormElement.elementId];
                
                    if(valueToDisplay==nil)
                        valueToDisplay = @"";
                    [forwardedDataDisplay setObject:valueToDisplay forKey:dotFormElement.elementId];
                
                }
            }
        }
    }
    
    
}

-(NSMutableArray * ) getDotFormElementData : (DotFormElement *) dotFormElement : (FormVC *) baseForm
{
    NSString *componentType = dotFormElement.componentType;
    NSString *elementid = dotFormElement.elementId;
    NSString *valueToSubmit = @"";
    NSString *valueToDisplay = @"";
    
    
    // "USE" field defined for dropdown and multiselect
    // telling to use code (Key value) or name (display value)
    NSString* useValue = @"PARAMCODE";
    NSDictionary* propMap = [XmwUtils getExtendedPropertyMap:dotFormElement.extendedProperty];
    if(propMap!=nil) {
        NSString* tempProp = [propMap objectForKey:@"USE"];
        if(tempProp!=nil && [tempProp isKindOfClass:[NSString class]] && [tempProp length]>0) {
            useValue = tempProp;
            // value is either PARAMCODE or PARAMNAME
        }
    }

   
    NSMutableArray *valueOfComponent = [[NSMutableArray alloc] init];
    
    if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_TEXTFIELD]
        || [componentType isEqualToString : XmwcsConst_DE_COMPONENT_TEXTFIELD_PASSWORD]
        || [componentType isEqualToString : XmwcsConst_DE_COMPONENT_DATE_FIELD])
    {
        MXTextField *textField = (MXTextField *)[baseForm getDataFromId:elementid];
        valueToSubmit = valueToDisplay = textField.text;
        
    }
    else if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_TEXTAREA])
    {
        MXTextField *textField = (MXTextField *)[baseForm getDataFromId:elementid];
        valueToSubmit = valueToDisplay = textField.text;
    }
    else if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_DROPDOWN] )
    {
        if([useValue isEqualToString:@"PARAMCODE"]) {
            MXTextField *dropDownField = (MXTextField *) [baseForm getDataFromId:elementid];
            valueToSubmit =  dropDownField.keyvalue;
            valueToDisplay = dropDownField.text;
        } else {
            MXTextField *dropDownField = (MXTextField *) [baseForm getDataFromId:elementid];
            valueToSubmit =  dropDownField.text;
            valueToDisplay = dropDownField.text;
        }
    }
    else if ([componentType isEqualToString:XmwcsConst_DE_COMPONENT_SEARCH_FIELD])
    {
        DropDownTableViewCell *dropDownCell = [baseForm getDataFromId:elementid];
        MXTextField *dropDownField = dropDownCell.dropDownField;
        valueToDisplay = dropDownField.text;
        valueToSubmit = dropDownField.keyvalue;
    } else if([componentType isEqualToString : XmwcsConst_DE_COMPONENT_EDIT_SEARCH_FIELD]) {
        EditSearchField* editSearchField = (EditSearchField *) [baseForm getDataFromId: dotFormElement.elementId];
        valueToDisplay = editSearchField.editText.text;
        valueToSubmit =  editSearchField.editText.text;
    } else if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_CHECKBOX])
    {
        //tushar code
        
        MXButton *mxButton  = (MXButton*)[baseForm getDataFromId:elementid];
        CheckBoxButton* checkBoxButton = (CheckBoxButton*)mxButton.parent;
        
//        CheckBoxButton *checkBoxButton = (CheckBoxButton *)[baseForm getDataFromId:elementid];

        if(checkBoxButton.isChecked)
        {
            valueToDisplay = @"1";
            valueToSubmit = (NSString *) checkBoxButton.elementId;
            
        }
    } else if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_CHECKBOX_GROUP]) {
        // not used anywhere
        
    } else if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_LABEL])
    {
         MXLabel *label = (MXLabel *) [baseForm getDataFromId:elementid];
         valueToSubmit =  valueToDisplay = label.text;
        if(label.attachedData != nil){
            valueToSubmit = label.attachedData;
        }
        
        
       // valueToSubmit = label.attachedData;
        
    } else if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_TIME_FIELD]){
        
        MXTextField *textField = (MXTextField *)[baseForm getDataFromId:elementid];
        valueToSubmit = valueToDisplay = textField.attachedData;
        
    }
    else if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_RADIO_GROUP]){
        RadioGroup *radioGroup = (RadioGroup*)[baseForm getDataFromId:elementid];
        
        valueToSubmit = valueToDisplay = [radioGroup.displayValueArray objectAtIndex:radioGroup.selectedIndex];
        
    }
    else if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_ATTACHMENT_BUTTON]){
            AttachmentViewCell *vc = (AttachmentViewCell*) [baseForm getDataFromId:elementid];
        valueToSubmit=  vc.ufmrefid;
    }

    else if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_MULTI_SELECT] ) {
        
        MultiSelectViewCell* multiSelectControl = (MultiSelectViewCell *) [baseForm getDataFromId:elementid];
        
        NSError *writeError = nil;
        NSData* jsonData = nil;
        
        if([useValue isEqualToString:@"PARAMCODE"]) {
            if([multiSelectControl selectedValueItems]!=nil) {
                jsonData = [NSJSONSerialization dataWithJSONObject:[multiSelectControl selectedValueItems] options:NSJSONWritingPrettyPrinted error:&writeError];
                valueToSubmit = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            } else {
                valueToSubmit = @"[]";
            }
            
            if([multiSelectControl selectedDisplayItems]!=nil) {
                jsonData = [NSJSONSerialization dataWithJSONObject:[multiSelectControl selectedDisplayItems] options:NSJSONWritingPrettyPrinted error:&writeError];
                valueToDisplay = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            } else {
                valueToDisplay = @"[]";
            }
        } else {
            
            if([multiSelectControl selectedValueItems]!=nil) {
                jsonData = [NSJSONSerialization dataWithJSONObject:[multiSelectControl selectedValueItems] options:NSJSONWritingPrettyPrinted error:&writeError];
                valueToDisplay  = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            } else {
                valueToDisplay  = @"[]";
            }
            
            if([multiSelectControl selectedDisplayItems]!=nil) {
                jsonData = [NSJSONSerialization dataWithJSONObject:[multiSelectControl selectedDisplayItems] options:NSJSONWritingPrettyPrinted error:&writeError];
                valueToSubmit = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            } else {
                valueToSubmit = @"[]";
            }
        }
        
    } else if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_MULTI_SELECT_SEARCH] ) {
        
        MultiSelectSearchViewCell* multiSelectSearchControl = (MultiSelectSearchViewCell *) [baseForm getDataFromId:elementid];
        
        NSError *writeError = nil;
        NSData* jsonData = nil;
        
        if([useValue isEqualToString:@"PARAMCODE"]) {
            if([multiSelectSearchControl selectedValueItems]!=nil) {
                jsonData = [NSJSONSerialization dataWithJSONObject:[multiSelectSearchControl selectedValueItems] options:NSJSONWritingPrettyPrinted error:&writeError];
                valueToSubmit = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            } else {
                valueToSubmit = @"[]";
            }
            
            if([multiSelectSearchControl selectedDisplayItems]!=nil) {
                jsonData = [NSJSONSerialization dataWithJSONObject:[multiSelectSearchControl selectedDisplayItems] options:NSJSONWritingPrettyPrinted error:&writeError];
                valueToDisplay = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            } else {
                valueToDisplay = @"[]";
            }
        } else {
            // only display values to sent
            if([multiSelectSearchControl selectedDisplayItems]!=nil) {
                jsonData = [NSJSONSerialization dataWithJSONObject:[multiSelectSearchControl selectedDisplayItems] options:NSJSONWritingPrettyPrinted error:&writeError];
                valueToSubmit = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            } else {
                valueToSubmit = @"[]";
            }
            
            if([multiSelectSearchControl selectedDisplayItems]!=nil) {
                jsonData = [NSJSONSerialization dataWithJSONObject:[multiSelectSearchControl selectedDisplayItems] options:NSJSONWritingPrettyPrinted error:&writeError];
                valueToDisplay = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            } else {
                valueToDisplay = @"[]";
            }
        }
        
    } else if([componentType isEqualToString : XmwcsConst_DE_COMPONENT_BARCODE_SCAN_FIELD]) {
        
        BarCodeScanField* barCodeScanField = (BarCodeScanField *) [baseForm getDataFromId:elementid];
        valueToDisplay = barCodeScanField.editText.text;
        valueToSubmit =  barCodeScanField.editText.text;
        
    }
    
    else if([componentType isEqualToString : XmwcsConst_DE_COMPONENT_SUGGESTIVE_SEARCH_FIELD]) {
        
        MXTextField *textField = (MXTextField *)[baseForm getDataFromId:elementid];
        valueToSubmit = textField.keyvalue;
        valueToDisplay = textField.text;
        
    }
    
    
    if(XmwcsConst_IS_DEBUG) {
                
    }
    
    if(valueToSubmit!=nil) {
        [valueOfComponent addObject: valueToSubmit];
        [valueOfComponent addObject: valueToDisplay];
    }
    return valueOfComponent;
    
}


-(void) incrementMaxDocId : (DotFormPost *) formPost
{
    ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
   
    
    formPost.maxDocId  = [NSNumber numberWithInt:clientVariables.MAX_DOC_ID_CREATED];//clientVariables.MAX_DOC_ID_CREATED;
    
    clientVariables.MAX_DOC_ID_CREATED = clientVariables.MAX_DOC_ID_CREATED+1;
   
    [[ObjectStorage getInstance] writeStringObject:@"MobileApplication1" : @"My first string"];
    NSMutableDictionary *docUserMaxNo = (NSMutableDictionary *)[[ObjectStorage getInstance]readJsonObject: AppConst_STORAGE_MAX_DOC_ID];
            
    if (docUserMaxNo == 0) {
        docUserMaxNo = [[NSMutableDictionary alloc]init];
    }
    //docUserMaxNo->insert(clientVariables->getClientUserLogin()->getUserName(), clientVariables->getMaxDocIdCreated());
   
    [docUserMaxNo setObject: clientVariables.CLIENT_USER_LOGIN.userName  forKey:[NSNumber numberWithInt:clientVariables.MAX_DOC_ID_CREATED]];
    [[ObjectStorage getInstance]writeJsonObject:AppConst_STORAGE_MAX_DOC_ID :docUserMaxNo];
    [[ObjectStorage getInstance] flushStorage];
    
  
}
-(void) storeRecentRequest : (DotForm*) dotForm :  (DotFormPost*) dotFormPost : (DocPostResponse*) postResponse : (BOOL) removeOld
{
    
    RecentRequestStorage* storage = [RecentRequestStorage getInstance];
    
	if( (storage !=0) && (dotFormPost!=0))
      {
          ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext]];
        
		RecentRequestItem* recentRequestItem = [[RecentRequestItem alloc]init];
          [recentRequestItem setUser:clientVariables.CLIENT_USER_LOGIN.userName];
          [recentRequestItem setModule:clientVariables.CLIENT_USER_LOGIN.moduleId];
          [recentRequestItem setMaxDocNo:[dotFormPost.maxDocId intValue ]];
       		        
		if(postResponse==0)
        {
            [recentRequestItem setTrackerNo:@""];
			[recentRequestItem setStatus:@""];
			[recentRequestItem setSubmittedResponse:@""];
			
		} else {
            [recentRequestItem setTrackerNo:postResponse.trackerNumber];
			[recentRequestItem setStatus:postResponse.submitStatus];
			[recentRequestItem setSubmittedResponse:postResponse.submittedMessage];
        }
          
          NSDate *today = [NSDate date];
          NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
          [dateFormat setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
          NSString *nowDateTime = [dateFormat stringFromDate:today];
          [recentRequestItem setSubmitDate:nowDateTime];
          [recentRequestItem setFormId:dotForm.formId];
          [recentRequestItem setFormType:dotForm.formType];
          NSMutableDictionary* jsonObj = [JSONDataExchange makeBeanToJSONObect:dotFormPost];
                   
          SBJsonWriter* jsonWriter = [[SBJsonWriter alloc] init];
          NSString* jsonStr = [jsonWriter stringWithObject: jsonObj ];
        
	
		@try {
			  NSLog(@"JSON String");
			[recentRequestItem setDotFormPost:jsonStr];
			}
          @catch(NSException *nse)
          {
              NSLog(@"Got Exception");
         }
		jsonObj = 0;
        
		if(removeOld) {
            [storage deleteData:clientVariables.CLIENT_USER_LOGIN.userName :clientVariables.CLIENT_USER_LOGIN.moduleId :[dotFormPost.maxDocId intValue]];
					}
          [storage insertDoc:recentRequestItem];
		
        
	}
    
    
}
-(BOOL) checkForLeaveReqDates : (FormVC*) baseForm
{
	NSLog(@"checkForLeaveReqDates");
	ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext]];
    
	NSMutableDictionary* availLeaveQuotaStatus = [clientVariables.CLIENT_APP_MASTER_DATA objectForKey:@"LEAVE_QUOTA"];
    
    MXTextField *leaveTypeDD = [baseForm getDataFromId:@"SUBTY"];

    NSString* key =  leaveTypeDD.keyvalue ;
    // NSString* value = leaveTypeDD.text ;
	
    if([availLeaveQuotaStatus objectForKey:key] !=nil) {
        MXTextField* begdaDateTF = (MXTextField*)[baseForm getDataFromId : @"BEGDA"];
        MXTextField* enddaDateTF = (MXTextField*)[baseForm getDataFromId : @"ENDDA"];
        
        NSString* begdaDate = begdaDateTF.text;
        NSString* enddaDate = enddaDateTF.text;

        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSDate* fromDate = [dateFormatter dateFromString:begdaDate];
        NSDate* toDate = [dateFormatter dateFromString:enddaDate];
        
        NSString* dayValue = [availLeaveQuotaStatus objectForKey:key];
        NSArray* parts = [dayValue componentsSeparatedByString:@"/"];
        // dayValue
        
        dayValue = [parts objectAtIndex:0];
		int daysRemaining = [dayValue intValue];
        
        NSInteger tempDays = [toDate daysSinceDate:fromDate ];
        
		if(tempDays > daysRemaining) {
            
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Mandatory Validations" message:@"Leave Quota is not available" delegate:baseForm cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
            myAlertView.tag = 2;
            [myAlertView show];
    
			return false;
		}
    }
	return true;
}


-(void) addCachePolicy:(DotFormPost*) formPost forTheForm:(DotForm*) dotForm
{
    // default false
    if([dotForm.formId isEqualToString:@"DOT_FORM_33"]) {
        formPost.reportCacheRefresh = @"true";
    }
    
    NSString* serverCache = [dotForm.extendedPropertyMap objectForKey:@"SERVER_CACHE"];
    if([serverCache isEqualToString:@"FALSE"]) {
        formPost.reportCacheRefresh = @"true";
    }
    
}
-(BOOL)  validateRange:(FormVC *) baseForm fromDate:fromDateTimeStr toDate:toDateTimeStr
{
    // format is 01/05/2018 8:30:AM or format is  01/05/2018 8:30 AM
    NSDateFormatter* dateFormatterT1 = [[NSDateFormatter alloc] init];
    [dateFormatterT1 setDateFormat:@"dd/MM/yyyy"];
    [dateFormatterT1 setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatterT1 setLocale:[NSLocale systemLocale]];
    
    NSDateFormatter* dateFormatterT2 = [[NSDateFormatter alloc] init];
    [dateFormatterT2 setDateFormat:@"dd/MM/yyyy"];
    [dateFormatterT2 setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatterT2 setLocale:[NSLocale systemLocale]];
    
    NSDate* fromDate = [dateFormatterT1 dateFromString:fromDateTimeStr];
    if(fromDate==nil) {
        fromDate = [dateFormatterT2 dateFromString:fromDateTimeStr];
    }
    
    
    NSDate* toDate = [dateFormatterT1 dateFromString:toDateTimeStr];
    if(toDate==nil) {
        toDate = [dateFormatterT2 dateFromString:toDateTimeStr];
    }
    
    
    if([toDate timeIntervalSince1970]<=[fromDate timeIntervalSince1970]) {
        
        NSString* displayMessage = [NSString stringWithFormat:@"To Date %@ should be greater than or equal to From Date %@", toDateTimeStr, fromDateTimeStr];
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Mandatory Validations" message:displayMessage delegate:baseForm cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        myAlertView.tag = 3;
        [myAlertView show];
        return false;
    }
    
    return true;
}
@end
