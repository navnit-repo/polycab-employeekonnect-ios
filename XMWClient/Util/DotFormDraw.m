//
//  DotFormDraw.m
//  QCMSProject
//
//  Created by Ashish Tiwari on 29/05/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "DotFormDraw.h"
#import "UIView+XMW.h"
#import "ClientVariable.h"
#import "DVAppDelegate.h"
#import "SearchRequestStorage.h"
#import "SearchRequestItem.h"
#import "XmwUtils.h"
#import "DVTableFormView.h"
#import "XMWTableFormDelegate.h"

#import "EditSearchField.h"
#import "MultiSelectViewCell.h"
#import "MultiSelectSearchViewCell.h"
#import "BarCodeScanField.h"
#import "AttachmentViewCell.h"
#import "JSONStructureConstant.h"
#import "JSONDataExchange.h"
#import "FormVC.h"

#import "SuggestiveSearchFieldControl.h"

@implementation UIView (DVTFVDelegate)



-(void) notifyRowAdded_HeightIncreased:(int) heightInc{
    NSLog(@"notifyRowAdded_HeightIncreased");
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + heightInc, self.frame.size.width, self.frame.size.height);
}

-(void) notifyRowDeleted_HeightDecreased:(int) heightDec
{
    NSLog(@"notifyRowDeleted_HeightDecreased");
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - heightDec, self.frame.size.width, self.frame.size.height);
}

@end


@implementation UIScrollView (DVTFVDelegate)

-(void) notifyRowAdded_HeightIncreased:(int) heightInc{
    NSLog(@"notifyRowAdded_HeightIncreased");
    self.contentSize = CGSizeMake(self.contentSize.width, self.contentSize.height + heightInc);
    // self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + heightInc, self.frame.size.width, self.frame.size.height);
}

-(void) notifyRowDeleted_HeightDecreased:(int) heightDec
{
    NSLog(@"notifyRowDeleted_HeightDecreased");
    self.contentSize = CGSizeMake(self.contentSize.width, self.contentSize.height - heightDec);
    // self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - heightDec, self.frame.size.width, self.frame.size.height);
}

@end


@implementation DotFormDraw

@synthesize formViewController;
@synthesize searchViewController;
@synthesize yArguForDrawComp;
@synthesize tag_elementId_map;



int formLineHeight = 70;
int screenWidth = 320;
int tagFormIdx = 1;
int uiViewStartIdx = 1001;



-(void) drawForm:(DotForm*) dotForm :(UIView *) formContainer  :(FormVC*) inFormVC
{
    if([dotForm.formSubType isEqualToString:XmwcsConst_DF_FORM_TYPE_SIMPLEADDROW_SAMEFORM ] ) {
        [self simpleAddRowFormInSameForm : dotForm : formContainer : inFormVC];
    } else {
        screenWidth = [[UIScreen mainScreen] bounds].size.width;
        tagFormIdx = 1;
        yArguForDrawComp = 40;
    
        
        tag_elementId_map = [[NSMutableDictionary alloc] init];

        NSMutableDictionary *dotFormElements = (NSMutableDictionary *)[dotForm formElements];
        
        NSMutableArray *sortedElements =[DotFormDraw sortFormComponents : dotFormElements];
    
        for(int cntElement = 0; cntElement < [sortedElements count] ; cntElement++)
        {
            DotFormElement* dotFormElement = (DotFormElement *)[dotFormElements objectForKey:[sortedElements objectAtIndex:cntElement]];
            UIView* temp =    [self drawDotFormElement : dotFormElement : inFormVC];
            if(temp !=nil) {
                [tag_elementId_map setObject: [[NSNumber alloc]  initWithInt:(uiViewStartIdx + cntElement)] forKey:dotFormElement.elementId];
                temp.tag = uiViewStartIdx + cntElement;
                [formContainer addSubview:temp];
            }
        }
    }
    
    
}

-(void) simpleAddRowFormInSameForm:(DotForm *)dotForm :(UIView *)formContainer :(FormVC *)inFormVC
{
    NSString* addRowFieldsString = [dotForm.extendedPropertyMap objectForKey:@"ADD_ROW_FIELD"];
    NSArray *addRowFields = nil;
    if(addRowFieldsString!=nil) {
        addRowFields = [XmwUtils breakStringTokenAsVector : addRowFieldsString : @"$"];
    } else {
        addRowFields = [[NSArray alloc] init];
    }
    
    NSString* nonAddRowFieldsString = [dotForm.extendedPropertyMap objectForKey:@"NON_ADD_ROW_FIELD"];
    NSArray *nonAddRowFields = nil;
    
    if(nonAddRowFieldsString!=nil) {
        nonAddRowFields = [XmwUtils breakStringTokenAsVector : nonAddRowFieldsString : @"$"];
    } else {
        nonAddRowFields = [[NSArray alloc] init];
    }
    
   
        
    NSLog(@"add row fields are %@", addRowFields );
    NSLog(@"non add row fields are %@", nonAddRowFields );
    
    screenWidth = [[UIScreen mainScreen] bounds].size.width;
    tagFormIdx = 1;
    yArguForDrawComp = 0;
        
    tag_elementId_map = [[NSMutableDictionary alloc] init];
        
    NSMutableDictionary *dotFormElements = (NSMutableDictionary *)[dotForm formElements];
    NSMutableArray *sortedElements =[DotFormDraw sortFormComponents : dotFormElements];
    DotFormElement* formSubmitElement = nil;
    DVTableFormView*  tableFormView = nil;
    int cntElement = 0;
    for(cntElement = 0; cntElement < [sortedElements count] ; cntElement++)
    {
        DotFormElement* dotFormElement = (DotFormElement *)[dotFormElements objectForKey:[sortedElements objectAtIndex:cntElement]];
            
        if([XmwUtils exists:dotFormElement.elementId InArray:nonAddRowFields] && ![dotFormElement.dataType isEqualToString : @"FORM_SUBMIT"])
        {
            UIView* temp =    [self drawDotFormElement : dotFormElement : inFormVC];
            if(temp !=nil) {
                [tag_elementId_map setObject: [[NSNumber alloc]  initWithInt:(uiViewStartIdx + cntElement)] forKey:dotFormElement.elementId];
                temp.tag = uiViewStartIdx + cntElement;
                [formContainer addSubview:temp];
            }
        } else  if([XmwUtils exists:dotFormElement.elementId InArray:addRowFields]) {
            
            if(tableFormView==nil) {
                tableFormView = [inFormVC childTableForm:CGRectMake(0, yArguForDrawComp, formContainer.frame.size.width, 40)];
                // tableFormView = [[DVTableFormView alloc] initWithFrame:CGRectMake(0, yArguForDrawComp, formContainer.frame.size.width, 40)];
                if(self.tableFormDelegate==nil) {
                    XMWTableFormDelegate* tfvDelegate = [[XMWTableFormDelegate alloc] init];
                    tfvDelegate.maxColumns = [addRowFields count];
                    tfvDelegate.formViewController = inFormVC;
                    tableFormView.rowDelegate = tfvDelegate;
                    self.tableFormDelegate = tfvDelegate;
                } else {
                    tableFormView.rowDelegate = self.tableFormDelegate;
                }
                
                yArguForDrawComp = yArguForDrawComp + formLineHeight;
                tableFormView.tag = 10000;
                [formContainer addSubview:tableFormView];
            }
            [tableFormView addColumn:dotFormElement];
        }
        
        if([dotFormElement.dataType isEqualToString : @"FORM_SUBMIT"]) {
            formSubmitElement = dotFormElement;
        }
    }
    
    
        // add tablular item row form
    
    // [self drawTabularForm: sortedElements ]
    
    
        // add form submit
    if (formSubmitElement!=nil) {
        UIView* temp = [self drawDotFormElement : formSubmitElement : inFormVC];
        if(temp !=nil) {
            [tag_elementId_map setObject: [[NSNumber alloc]  initWithInt:(uiViewStartIdx + cntElement)] forKey:formSubmitElement.elementId];
            temp.tag = uiViewStartIdx + cntElement;
            [formContainer addSubview:temp];
            [tableFormView subscribeTableUIEvent:temp];
        }
    }
    
    [tableFormView subscribeTableUIEvent:(UIScrollView*)formContainer];

}



+(NSMutableArray *)sortFormComponents :(NSMutableDictionary *)dotFormElements
{
    NSArray *keys = [dotFormElements allKeys];
    NSMutableArray *componentIdVec = [[NSMutableArray alloc]init];
    NSMutableArray *componentPositionVec = [[NSMutableArray alloc]init];
    
    for(int i=0; i<[keys count];i++)
    {
        NSString*  elementId =  (NSString*)[keys objectAtIndex:i];
        DotFormElement *dotFormElement = [dotFormElements objectForKey:elementId];
        if([dotFormElement isComponentDisplayBool]) {
            [componentIdVec setObject: dotFormElement.elementId atIndexedSubscript:i];
            [componentPositionVec setObject:dotFormElement.componentPosition atIndexedSubscript:i];
           
        }
    }

	[DotFormDraw sortListOnPosition : componentIdVec :componentPositionVec ];
	
	componentPositionVec = 0;
	return componentIdVec ;
}


+(void)sortListOnPosition : (NSMutableArray *) in_ComponentIdVec: (NSMutableArray *)in_ComponentPositionVec
{
    NSMutableArray *componentIdVec = [[NSMutableArray alloc]init];
    componentIdVec = in_ComponentIdVec;
    NSMutableArray *componentPositionVec = [[NSMutableArray alloc]init];
    componentPositionVec = in_ComponentPositionVec;
    NSString *temp;
    
    for (int cntIndex = 0; cntIndex<[componentPositionVec count]; cntIndex++)
    {
        for (int j = 0; j < [componentPositionVec count] - cntIndex -1; j++)
        {    
            NSString *temp1 = (NSString *)[componentPositionVec objectAtIndex:j];
            int value = [temp1 intValue];
            NSString *temp2 = (NSString *)[componentPositionVec objectAtIndex:j+1];
            int value1 = [temp2 intValue];
            if(value > value1)
            {
                temp = (NSString *) [componentIdVec objectAtIndex:j];
                temp2 = (NSString *) [componentIdVec objectAtIndex:j];
                id  temp = [componentPositionVec objectAtIndex:j];
                [componentPositionVec setObject:[componentPositionVec objectAtIndex:j+1] atIndexedSubscript:j];
                [componentPositionVec setObject:temp atIndexedSubscript:j+1];
                temp = [componentIdVec objectAtIndex:j];
                [componentIdVec setObject:[componentIdVec objectAtIndex:j+1] atIndexedSubscript:j];
                [componentIdVec setObject:temp atIndexedSubscript:j+1];
                
            }
        }
    }
} 

-(UIView *)drawDotFormElement : (DotFormElement *) formElement : (FormVC *) formController
{       
    NSString* componentType = formElement.componentType;
       
    if([componentType isEqualToString:XmwcsConst_DE_COMPONENT_TEXTFIELD])
    {
        tagFormIdx = tagFormIdx + 1;
        return [self drawTextField : formController : formElement : false];
    }
    else if([componentType isEqualToString:XmwcsConst_DE_COMPONENT_TEXTAREA])
    {
        tagFormIdx = tagFormIdx + 1;
         return [self drawTextArea :formController : formElement ];
    }
    else if([componentType isEqualToString:XmwcsConst_DE_COMPONENT_TEXTFIELD_PASSWORD])
    {
        tagFormIdx = tagFormIdx + 1;
        return [self drawTextField :formController : formElement : true];
    }
    else if([componentType isEqualToString:XmwcsConst_DE_COMPONENT_BUTTON])
    {
        tagFormIdx = tagFormIdx + 1;
         return [self drawButton :formController : formElement ];
    }
    else if([componentType isEqualToString:XmwcsConst_DE_COMPONENT_DATE_FIELD])
    {
        tagFormIdx = tagFormIdx + 1;
         return [self drawDateField : formController : formElement ];
    }
    else if([componentType isEqualToString:XmwcsConst_DE_COMPONENT_DROPDOWN])
    {
        tagFormIdx = tagFormIdx + 1;
        
      
        
         return [self  drawDropDown :formController : formElement ];
    }
    else if([componentType isEqualToString:XmwcsConst_DE_COMPONENT_CHECKBOX_GROUP])
    {
        tagFormIdx = tagFormIdx + 1;
         return [self  drawCheckBoxGroup : formController :  formElement ];
    }
    else if([componentType isEqualToString:XmwcsConst_DE_COMPONENT_CHECKBOX])
    {
        tagFormIdx = tagFormIdx + 1;
         return [self drawCheckBox :formController : formElement ];
    }
    else if([componentType isEqualToString:XmwcsConst_DE_COMPONENT_LABEL])
    {
        tagFormIdx = tagFormIdx + 1;
         return [self drawLabel :formController : formElement ];
    }
    else if([componentType isEqualToString:XmwcsConst_DE_COMPONENT_TIME_FIELD])
    {
        tagFormIdx = tagFormIdx + 1;
         return [self drawTimeField : formController : formElement ];
    }
    else if([componentType isEqualToString:XmwcsConst_DE_COMPONENT_RADIO_GROUP])
    {
        tagFormIdx = tagFormIdx + 1;
         return [self drawRadioGroup : formController : formElement ];
    }
    else if([componentType isEqualToString:XmwcsConst_DE_COMPONENT_SEARCH_FIELD])
    {
        tagFormIdx = tagFormIdx + 1;
    	 return [self drawSearchField : formController : formElement ];
    }
    else if([componentType isEqualToString:XmwcsConst_DE_COMPONENT_SUB_HEADER])
    {
        tagFormIdx = tagFormIdx + 1;
    	 return [self drawSubHeader : formController : formElement ];
    }
    else if([componentType isEqualToString:XmwcsConst_DE_COMPONENT_EDIT_SEARCH_FIELD])
    {
        tagFormIdx = tagFormIdx + 1;
        return [self drawEditSearchField:formController :formElement];
    } else if([componentType isEqualToString:XmwcsConst_DE_COMPONENT_MULTI_SELECT]) {
        tagFormIdx = tagFormIdx + 1;
        return [self drawMultiSelect : formController : formElement];
    } else if([componentType isEqualToString:XmwcsConst_DE_COMPONENT_MULTI_SELECT_SEARCH]) {
        tagFormIdx = tagFormIdx + 1;
        return [self drawMultiSelectSearch : formController : formElement];
    } else if([componentType isEqualToString:XmwcsConst_DE_COMPONENT_BARCODE_SCAN_FIELD]) {
        tagFormIdx = tagFormIdx + 1;
        return [self drawBarcodeScanField:formController : formElement];
    }
    else if([componentType isEqualToString:XmwcsConst_DE_COMPONENT_ATTACHMENT_BUTTON]) {
        tagFormIdx = tagFormIdx + 1;
        return [self drawAttachmentView:formController :formElement];
    }
    
    else if([componentType isEqualToString:XmwcsConst_DE_COMPONENT_SUGGESTIVE_SEARCH_FIELD]) {
        tagFormIdx = tagFormIdx + 1;
        return [self drawSuggestiveSearchField:formController :formElement];
    }
    
    
    return nil;
}


-(UIView*) drawMandatoryLbl : (FormVC *) formController :(DotFormElement*) dotFormElement
{
    UIView *subContainer = [[UIView alloc]initWithFrame:CGRectMake(0, yArguForDrawComp, screenWidth, formLineHeight)];
    NSString *leftLabelString = @"";
	if(![dotFormElement isOptionalBool])
    {
        [leftLabelString stringByAppendingString:@"*"];
    }
	[leftLabelString stringByAppendingString:dotFormElement.displayText];
    	
    MXLabel *leftLable = [[MXLabel alloc]initWithFrame:CGRectMake(0, 0, screenWidth/2, formLineHeight)];
    leftLable.text = leftLabelString;
    
	[subContainer addSubview:leftLable];
	
    yArguForDrawComp =yArguForDrawComp+formLineHeight;
    
    return subContainer;
    
}
-(UIView*) drawTextField : (FormVC *) formController :(DotFormElement*) dotFormElement  : (BOOL)isPasswordField
{
    UIView *subContainer = [[UIView alloc]initWithFrame:CGRectMake(0, yArguForDrawComp, screenWidth, formLineHeight)];
    
    NSString *currentCompName = dotFormElement.elementId;
    
    static NSString *cellIdentifier = @"FormTableViewCell";
    FormTableViewCell *textCell;// = (FormTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
  

    
    if (textCell == nil)
        textCell = [[FormTableViewCell alloc] initWithFrame: CGRectMake(0, 0, screenWidth, formLineHeight)];
    
    if([dotFormElement isOptionalBool])
        textCell.mandatoryLabel.hidden	= YES;
    else
        textCell.mandatoryLabel.hidden	= NO;
    
    textCell.cellTextField.delegate		= formController;
    textCell.cellTextField.keyboardType = UIKeyboardTypeDefault;
    textCell.cellTextField.elementId = currentCompName;
    
    
    
    if([dotFormElement.componentType isEqualToString: XmwcsConst_DE_COMPONENT_TEXTFIELD_PASSWORD])
        textCell.cellTextField.secureTextEntry = YES;
    
   // if([dotFormElement isOptionalBool]){
         textCell.titleLabel.text = dotFormElement.displayText;
    // start code added for keyboard type number only
    if([textCell.titleLabel.text isEqualToString: @"Amount"])
    {
         textCell.cellTextField.keyboardType = UIKeyboardTypeASCIICapable;
    }// close
    
   // }
   // else
    //{
     //   textCell.titleLabel.text = dotFormElement.displayText;
      //  textCell.titleLabel.text = [@"*" stringByAppendingString:textCell.titleLabel.text];
    //}
    

    
    textCell.cellTextField.tag	= tagFormIdx;
    [formController putToDataIdMap : textCell.cellTextField : currentCompName];

    [subContainer addSubview:textCell];
    yArguForDrawComp =yArguForDrawComp+formLineHeight;
    return subContainer;
}

-(UIView*) drawTextArea : (FormVC *) formController :(DotFormElement*) dotFormElement 
{
    UIView *subContainer = [[UIView alloc]initWithFrame:CGRectMake(0, yArguForDrawComp, screenWidth, formLineHeight)];
    
    NSString *currentCompName = dotFormElement.elementId;
    static NSString *cellIdentifier = @"FormTableViewCell";
    FormTableViewCell *textCell;// = (FormTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    
    if (textCell == nil)
        textCell = [[FormTableViewCell alloc] initWithFrame:  CGRectMake(0, 0, screenWidth, formLineHeight)];
   
    if([dotFormElement isOptionalBool])
        textCell.mandatoryLabel.hidden	= YES;
    else
        textCell.mandatoryLabel.hidden	= NO;

    
    textCell.cellTextField.delegate		= formController;
    textCell.cellTextField.keyboardType = UIKeyboardTypeDefault;
    textCell.cellTextField.elementId = currentCompName;
    
    if([dotFormElement.componentType isEqualToString: XmwcsConst_DE_COMPONENT_TEXTFIELD_PASSWORD])
        textCell.cellTextField.secureTextEntry = YES;
    
   // if([dotFormElement isOptionalBool]){
         textCell.titleLabel.text = dotFormElement.displayText;
   // }
   // else
   // {
     //   textCell.titleLabel.text = dotFormElement.displayText;
     //   textCell.titleLabel.text = [@"*" stringByAppendingString:textCell.titleLabel.text];
  //  }

    
    textCell.cellTextField.tag			= tagFormIdx;//indexPath.row + 1;
    [formController putToDataIdMap : textCell.cellTextField : currentCompName];
    
    
    [subContainer addSubview:textCell];
    yArguForDrawComp =yArguForDrawComp+formLineHeight;
    return subContainer;

}
-(UIView*) drawButton : (FormVC *) formController :(DotFormElement*) dotFormElement 
{
    UIView *subContainer = [[UIView alloc]initWithFrame:CGRectMake(0, yArguForDrawComp, screenWidth, formLineHeight)];
    subContainer.alpha = 1.0f;
    NSString *currentCompName = dotFormElement.elementId;
    
    static NSString *cellIdentifier = @"ButtonTableViewCell";
    ButtonTableViewCell *buttonCell;// = (ButtonTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (buttonCell == nil)
        buttonCell = [[ButtonTableViewCell alloc] initWithFrame:CGRectMake(0, 0, screenWidth, formLineHeight)];
    
    [buttonCell.button setTitle:dotFormElement.displayText forState:UIControlStateNormal];
    buttonCell.button.elementId = [[NSString alloc] initWithString:currentCompName];
    //buttonCell.button.tag = indexPath.row + 1;
    buttonCell.button.attachedData = dotFormElement.dataType;
    [buttonCell.button addTarget:formController action:@selector(submitPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [subContainer addSubview:buttonCell];
    yArguForDrawComp =yArguForDrawComp+formLineHeight;
    
    [formController putToDataIdMap : buttonCell.button : currentCompName];
    return subContainer;
    
}


-(UIView*)drawDateField : (FormVC *) formController :(DotFormElement*) dotFormElement
{
    UIView *subContainer = [[UIView alloc]initWithFrame:CGRectMake(0, yArguForDrawComp, screenWidth, formLineHeight)];
    
    NSString *currentCompName = dotFormElement.elementId;
    static NSString *cellIdentifier = @"CalendarTableViewCell";
    CalendarTableViewCell *calendarCell;// = (CalendarTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    if (calendarCell == nil)
        calendarCell = [[CalendarTableViewCell alloc] initWithFrame:CGRectMake(0, 0, screenWidth, formLineHeight)];
    
    if([dotFormElement isOptionalBool])
        calendarCell.mandatoryLabel.hidden	= YES;
    else
        calendarCell.mandatoryLabel.hidden	= NO;

    
    calendarCell.calendarField.delegate		= formController;
    
    calendarCell.titleLabel.text			= dotFormElement.displayText;
//    calendarCell.titleLabel.textColor = [UIColor colorWithRed:0.119f green:0.119f blue:0.119f alpha:1.0];

    calendarCell.calendarField.tag = 101;
    calendarCell.calendarField.elementId = currentCompName;
    calendarCell.calendarButton.attachedData = dotFormElement.elementId;
    calendarCell.calendarButton.elementId = [[NSString alloc] initWithFormat : @"CAL_%@", dotFormElement.elementId];
    [calendarCell.calendarButton addTarget:formController action:@selector(calendarPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    calendarCell.calendarButton.elementId = currentCompName;
   
    subContainer.elementId = currentCompName;
    
    
    [formController putToDataIdMap : calendarCell.calendarField : currentCompName];
    [formController putToDataIdMap : calendarCell.calendarButton : [currentCompName stringByAppendingString:@"_Button"]];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
   
    
    //for default date to display
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
        today = [gregorian dateFromComponents:dateComp];
    
    }
    
    // //
     NSString *dateString = [dateFormat stringFromDate:today];
    calendarCell.calendarField.text =   dateString;
    
   
    [subContainer addSubview :calendarCell];
    yArguForDrawComp =yArguForDrawComp+formLineHeight;
    return subContainer;
    
}

-(UIView*)drawSuggestiveSearchField : (FormVC *) formController :(DotFormElement*) dotFormElement
{
     UIView *subContainer = [[UIView alloc]initWithFrame:CGRectMake(0, yArguForDrawComp, screenWidth, formLineHeight)];
     NSString *currentCompName = dotFormElement.elementId;
    SuggestiveSearchFieldControl *suggestiveSearchFieldView;
    
    if (suggestiveSearchFieldView == nil)
        suggestiveSearchFieldView = [[SuggestiveSearchFieldControl alloc ] initWithFrame:CGRectMake(0, 0, screenWidth, formLineHeight) :yArguForDrawComp +formController.view.frame.origin.y :dotFormElement];
    
    
    
    if([dotFormElement isOptionalBool])
        suggestiveSearchFieldView.mandatoryLabel.hidden    = YES;
    else
        suggestiveSearchFieldView.mandatoryLabel.hidden    = NO;
    
    suggestiveSearchFieldView.titleLabel.text = dotFormElement.displayText;
    suggestiveSearchFieldView.searchField.elementId = currentCompName;
    [formController putToDataIdMap :  suggestiveSearchFieldView.searchField : currentCompName];
  
    
    
    [subContainer addSubview: suggestiveSearchFieldView];
    yArguForDrawComp =yArguForDrawComp+formLineHeight;
     return subContainer;
}

-(UIView*)drawDropDown : (FormVC *) formController :(DotFormElement*) dotFormElement 
{

    
    
    
    UIView *subContainer = [[UIView alloc]initWithFrame:CGRectMake(0, yArguForDrawComp, screenWidth, formLineHeight)];

    NSString *currentCompName = dotFormElement.elementId;

  

    // Check for Drop Down Constraints
    //  NSMutableDictionary*  cellDropDownDictionary = [self getDropDownList: dotFormElement];
    id masterValues = [DotFormDraw getMasterValueForComponent:[dotFormElement elementId] : [dotFormElement masterValueMapping]];
    // NSMutableDictionary *masterkey = masterValues[0];
 
    if(masterValues != nil) {
        
        NSMutableDictionary*  cellDropDownDictionary = masterValues[1];
        
        if([cellDropDownDictionary count] > 0)
        {
           // static NSString *cellIdentifier = @"DropDownTableViewCell";
            DropDownTableViewCell *dropDownCell;// = (DropDownTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (dropDownCell == nil)
                dropDownCell = [[DropDownTableViewCell alloc]initWithFrame:CGRectMake(0, 0, screenWidth, formLineHeight)];

            if([dotFormElement isOptionalBool])
                dropDownCell.mandatoryLabel.hidden	= YES;
            else
                dropDownCell.mandatoryLabel.hidden	= NO;

            dropDownCell.dropDownField.delegate		= formController;
            dropDownCell.dropDownField.tag			= 101;//indexPath.row + 101;
            dropDownCell.dropDownField.elementId = currentCompName;
    
            
            if(dotFormElement.defaultVal !=nil && [dotFormElement.defaultVal length]>0) {
                NSDictionary* defMap = [XmwUtils getExtendedPropertyMap:dotFormElement.defaultVal];
                NSString* displayValue = [defMap objectForKey:@"VALUE"];
                NSString* postValue = [defMap objectForKey:@"KEY"];
                dropDownCell.dropDownField.text = displayValue;   // this is display value
                dropDownCell.dropDownField.keyvalue = postValue;
            }
            
            
            // patch for sorted division listing in the dropdown
            if([dotFormElement masterValueMapping] != nil)
            {
                NSArray* sortedMasterValues = [DotFormDraw getSortedMasterValueForComponent:[dotFormElement elementId] : [dotFormElement masterValueMapping]];
                // hook for division_wise sale report form 'DOT_FORM_26', 23, 24 and elementId = SPART, we need to add "All"  "".
                if( ([formController.dotForm.formId isEqualToString:@"DOT_FORM_26"] ||
                     [formController.dotForm.formId isEqualToString:@"DOT_FORM_23"] ||
                     [formController.dotForm.formId isEqualToString:@"DOT_FORM_24"]) &&
                   [currentCompName isEqualToString:@"SPART"])
                {
          	
                }
                
                dropDownCell.dropDownButton.attachedData = sortedMasterValues;
            } else {
                dropDownCell.dropDownButton.attachedData = masterValues;
            }
           
            dropDownCell.titleLabel.text = dotFormElement.displayText;
            
            //this code for set selected regid
            if ([dropDownCell.dropDownField.elementId isEqualToString:@"REGISTRY_ID"] && regIDCheck ==YES) {
                NSString *selectedRegisterID= [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedRegisterID"];
                dropDownCell.dropDownField.text = selectedRegisterID;
               
            }
            
            [dropDownCell.dropDownButton addTarget:formController action:@selector(dropDownPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            //button elementId = currentCompName + _button
            dropDownCell.dropDownButton.elementId	= [currentCompName stringByAppendingString:@"_button"];
            
            [formController putToDataIdMap : dropDownCell.dropDownField : currentCompName];
            [formController putToDataIdMap : dropDownCell.dropDownButton : [currentCompName stringByAppendingString:@"_button"]];
    
            
            [subContainer addSubview: dropDownCell];
             yArguForDrawComp =yArguForDrawComp+formLineHeight;
            return subContainer;
        }
    } else {
        
        return [self dependentDrawDropDown:formController :dotFormElement];
        
        //return [self drawTextField : formController : dotFormElement : false];
    }
}


-(UIView*)dependentDrawDropDown : (FormVC *) formController :(DotFormElement*) dotFormElement
{
    
    
    UIView *subContainer = [[UIView alloc]initWithFrame:CGRectMake(0, yArguForDrawComp, screenWidth, formLineHeight)];
    
    NSString *currentCompName = dotFormElement.elementId;
    DropDownTableViewCell *dropDownCell;
            
            if (dropDownCell == nil)
                dropDownCell = [[DropDownTableViewCell alloc]initWithFrame:CGRectMake(0, 0, screenWidth, formLineHeight)];
            
            if([dotFormElement isOptionalBool])
                dropDownCell.mandatoryLabel.hidden    = YES;
            else
                dropDownCell.mandatoryLabel.hidden    = NO;
            
            dropDownCell.dropDownField.delegate        = formController;
            dropDownCell.dropDownField.tag            = 101;//indexPath.row + 101;
            dropDownCell.dropDownField.elementId = currentCompName;
            
            
            
            // patch for sorted division listing in the dropdown
            if( ([dotFormElement masterValueMapping] != nil) && ([ [dotFormElement masterValueMapping] compare:@"DIVISION" options: NSCaseInsensitiveSearch ] == NSOrderedSame ))
            {
                NSArray* sortedMasterValues = [DotFormDraw getSortedMasterValueForComponent:[dotFormElement elementId] : [dotFormElement masterValueMapping]];
                // hook for division_wise sale report form 'DOT_FORM_26', 23, 24 and elementId = SPART, we need to add "All"  "".
                if( ([formController.dotForm.formId isEqualToString:@"DOT_FORM_26"] ||
                     [formController.dotForm.formId isEqualToString:@"DOT_FORM_23"] ||
                     [formController.dotForm.formId isEqualToString:@"DOT_FORM_24"]) &&
                   [currentCompName isEqualToString:@"SPART"])
                {
                    NSMutableArray* keysArray = [sortedMasterValues objectAtIndex:0];
                    NSMutableArray* valuesArray = [sortedMasterValues objectAtIndex:1];
                    [keysArray insertObject:@"" atIndex:0];
                    [valuesArray insertObject:@"All" atIndex:0];
                    dropDownCell.dropDownField.text = @"All";
                    dropDownCell.dropDownField.keyvalue = @"";
                }
                
                dropDownCell.dropDownButton.attachedData = sortedMasterValues;
            }
    
            
            dropDownCell.titleLabel.text = dotFormElement.displayText;
            
            [dropDownCell.dropDownButton addTarget:formController action:@selector(dropDownPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            //button elementId = currentCompName + _button
            dropDownCell.dropDownButton.elementId    = [currentCompName stringByAppendingString:@"_button"];
            
            [formController putToDataIdMap : dropDownCell.dropDownField : currentCompName];
            [formController putToDataIdMap : dropDownCell.dropDownButton : [currentCompName stringByAppendingString:@"_button"]];
            
            
            [subContainer addSubview: dropDownCell];
            yArguForDrawComp =yArguForDrawComp+formLineHeight;
    
    //this code for set selected regid according customer account data
    
    if ([dropDownCell.dropDownField.elementId isEqualToString:@"CUSTOMER_ACCOUNT"] &&regIDCheck ==YES) {
        NSMutableArray *key = [[NSMutableArray alloc]init];
        NSMutableArray *value = [[NSMutableArray alloc]init];
        NSMutableArray *customerAccountButtonDropDownArray = [[NSMutableArray alloc]init];
        
        NSString* selectedRegIDCode = [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedRegisterIDCode"];
        if ([selectedRegIDCode isEqualToString:@""] || selectedRegIDCode == nil || selectedRegIDCode.length ==0 || [selectedRegIDCode isKindOfClass:[NSNull class]]) {
            selectedRegIDCode = @"";
        }
        
        NSString *selectKey = [@"BUSINESS_VERTICAL_" stringByAppendingString:selectedRegIDCode];
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
            dropDownCell.dropDownButton.attachedData = customerAccountButtonDropDownArray;
          //  dropDownCell.dropDownField.text = [value objectAtIndex:0];
        }
    }
    
    
    if ([dropDownCell.dropDownField.elementId isEqualToString:@"BUSINESS_VERTICAL"] &&regIDCheck ==YES) {
        NSMutableArray *key = [[NSMutableArray alloc]init];
        NSMutableArray *value = [[NSMutableArray alloc]init];
        NSMutableArray *customerAccountButtonDropDownArray = [[NSMutableArray alloc]init];
        
        
        NSString* selectedRegIDCode = [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedRegisterIDCode"];
        if ([selectedRegIDCode isEqualToString:@""] || selectedRegIDCode == nil || selectedRegIDCode.length ==0 || [selectedRegIDCode isKindOfClass:[NSNull class]]) {
            selectedRegIDCode = @"";
        }
        
        
        NSString *selectKey = [@"BUSINESS_VERTICAL_" stringByAppendingString:selectedRegIDCode];
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
            dropDownCell.dropDownButton.attachedData = customerAccountButtonDropDownArray;
            //dropDownCell.dropDownField.text = [value objectAtIndex:0];
        }
    }
    
   
    
    
    
            return subContainer;
}

-(UIView*)drawCheckBoxGroup : (FormVC *) formController :(DotFormElement*) dotFormElement
{
    NSString *currentCompName = dotFormElement.elementId;
    
    id masterValues = [DotFormDraw getMasterValueForComponent:[dotFormElement elementId] : [dotFormElement masterValueMapping]];
    
    UIView *subContainer = [[UIView alloc]initWithFrame:CGRectMake(0, yArguForDrawComp, screenWidth, formLineHeight*[masterValues[0] count])];
    
    static NSString *cellIdentifier = @"checkBoxGroup";
    
    CheckBoxGroup *checkBoxGroupCell = [[ CheckBoxGroup alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    checkBoxGroupCell.frame = CGRectMake(0, 0, screenWidth, formLineHeight*[masterValues[0] count]);
    checkBoxGroupCell.selectionStyle = UITableViewCellSelectionStyleNone;
    checkBoxGroupCell.attachedData = masterValues;
    
    for (int i = 0; i < [masterValues[0] count]; i++) {
        MXButton* checkBoxGroupItemButton = [MXButton buttonWithType:UIButtonTypeCustom];
        [checkBoxGroupItemButton setFrame:CGRectMake( 144.0f, 6.0f + (i*formLineHeight), 31.0f, 31.0f)];
        [checkBoxGroupItemButton setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        [checkBoxGroupCell.contentView addSubview:checkBoxGroupItemButton];
        checkBoxGroupItemButton.elementId = [masterValues[0] objectAtIndex:i];
        
        [checkBoxGroupItemButton addTarget:checkBoxGroupCell action:@selector(checkBoxClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        MXLabel* checkBoxGroupItemText = [[MXLabel alloc] initWithFrame:CGRectMake( 175.0f, 6.0f + (i*formLineHeight), 120.f, 31.0f)];
        checkBoxGroupItemText.text = [masterValues[1] objectAtIndex:i];
        [checkBoxGroupCell.contentView addSubview:checkBoxGroupItemText];
        checkBoxGroupItemText.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        
        CheckBoxGroupItem* cbGroupItem = [[CheckBoxGroupItem alloc] init];
        cbGroupItem.checkBoxGroupButton = checkBoxGroupItemButton;
        cbGroupItem.titleLabel = checkBoxGroupItemText;
        cbGroupItem.isChecked = NO;
        checkBoxGroupItemButton.parent = cbGroupItem;
        
        [checkBoxGroupCell.checkBoxItems addObject:cbGroupItem];
    }
    
    if([dotFormElement isOptionalBool])
        checkBoxGroupCell.mandatoryLabel.hidden	= YES;
    else
        checkBoxGroupCell.mandatoryLabel.hidden	= NO;
    
    checkBoxGroupCell.titleLabel.text = dotFormElement.displayText;
    
    
    [subContainer addSubview: checkBoxGroupCell];
    yArguForDrawComp = yArguForDrawComp + formLineHeight*[masterValues[0] count];
    
    UIView* hLine = [[UIView alloc] initWithFrame:CGRectMake(10, subContainer.frame.size.height - 2, screenWidth-20, 1.0f)];
    hLine.backgroundColor = [UIColor lightGrayColor];
    [subContainer addSubview:hLine];
    
    [formController putToDataIdMap : checkBoxGroupCell : currentCompName];
    
    return subContainer;
    
}


-(UIView*)drawMultiSelect:(FormVC *) formController :(DotFormElement*) dotFormElement
{
    NSString *currentCompName = dotFormElement.elementId;
    
    // id masterValues = [self getMasterValueForComponent:[dotFormElement elementId] : [dotFormElement masterValueMapping]];
    id masterValues = [DotFormDraw getSortedMasterValueForComponent:[dotFormElement elementId] : [dotFormElement masterValueMapping]];
    
    UIView *subContainer = [[UIView alloc]initWithFrame:CGRectMake(0, yArguForDrawComp, screenWidth, formLineHeight)];
    
    MultiSelectViewCell* multiSelectControl = [[MultiSelectViewCell alloc] initWithFrame:CGRectMake(0, 0, screenWidth, formLineHeight)];
    [multiSelectControl configureViewCellFor:dotFormElement masterDisplayList:masterValues[1] masterValueList:masterValues[0]];
    multiSelectControl.selectDelegate = formController;
    
    [subContainer addSubview:multiSelectControl];
    [formController putToDataIdMap : multiSelectControl : currentCompName];
    yArguForDrawComp = yArguForDrawComp + formLineHeight;
    return subContainer;
}

-(UIView*)drawMultiSelectSearch : (FormVC *) formController :(DotFormElement*) dotFormElement
{
    NSString *currentCompName = dotFormElement.elementId;
    
    id masterValues = [DotFormDraw getMasterValueForComponent:[dotFormElement elementId] : [dotFormElement masterValueMapping]];
    
    UIView *subContainer = [[UIView alloc]initWithFrame:CGRectMake(0, yArguForDrawComp, screenWidth, formLineHeight)];
    
    MultiSelectSearchViewCell* multiSelectSearchControl = [[MultiSelectSearchViewCell alloc] initWithFrame:CGRectMake(0, 0, screenWidth, formLineHeight)];
    
    NSDictionary* exentedPropertyMap = [XmwUtils getExtendedPropertyMap:dotFormElement.extendedProperty];
    
    [multiSelectSearchControl configureViewCell:formController element:dotFormElement masterDisplayList:masterValues[1] masterValueList:masterValues[0]  extendedProperty:exentedPropertyMap];
    
    
    [subContainer addSubview:multiSelectSearchControl];
    [formController putToDataIdMap : multiSelectSearchControl : currentCompName];
    yArguForDrawComp = yArguForDrawComp + formLineHeight;
    return subContainer;
}

// tushar code 
-(UIView*)drawAttachmentView :(FormVC *) inFormVC :(DotFormElement*) dotFormElement
{
     UIView *subContainer = [[UIView alloc]initWithFrame:CGRectMake(0, yArguForDrawComp, screenWidth, 200)];
     NSString *currentCompName = dotFormElement.elementId;
    AttachmentViewCell *attachmentCell;
    if (attachmentCell == nil) {
        attachmentCell = [[AttachmentViewCell alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 200)];
    }
    
     [attachmentCell.attachmentButton setTitle:dotFormElement.displayText forState:UIControlStateNormal];
    
    [attachmentCell.attachmentButton addTarget:inFormVC action:@selector(fileAttactmentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [attachmentCell.imageViewAttachButton addTarget:inFormVC action:@selector(fileAttactmentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    

    attachmentCell.attachmentButton.elementId    = currentCompName;
    attachmentCell.imageViewAttachButton.elementId    = currentCompName;
    attachmentCell.tag = 1000; //get cell with tag
    
    
     [subContainer addSubview:attachmentCell];
     [inFormVC putToDataIdMap : attachmentCell : currentCompName];
     yArguForDrawComp = yArguForDrawComp + 200;
     return subContainer;
}
-(UIView*)drawCheckBox :(FormVC *) inFormVC :(DotFormElement*) dotFormElement
{
     UIView *subContainer = [[UIView alloc]initWithFrame:CGRectMake(0, yArguForDrawComp, screenWidth, 50)];
    
    NSString *currentCompName = dotFormElement.elementId;
    static NSString *cellIdentifier = @"CheckBoxButton";
    CheckBoxButton *checkBoxCell;// = ( CheckBoxButton *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
       if (checkBoxCell == nil)
        checkBoxCell = [[ CheckBoxButton alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 50)] ;
    
    
    if([dotFormElement isOptionalBool])
        checkBoxCell.mandatoryLabel.hidden	= YES;
    else
        checkBoxCell.mandatoryLabel.hidden	= NO;
    

    
    // checkBoxCell.checkBoxField.delegate		= self;
    // checkBoxCell.checkBoxField.tag			= indexPath.row + 101;
    //checkBoxCell.checkBoxButton.tag			= indexPath.row + 101;
   // if([dotFormElement isOptionalBool]){
        checkBoxCell.titleLabel.text = dotFormElement.displayText;
    

   // }
   // else
    //{
     //   checkBoxCell.titleLabel.text = dotFormElement.displayText;
       // checkBoxCell.titleLabel.text = [@"*" stringByAppendingString:checkBoxCell.titleLabel.text];
    //}

    
    
    [checkBoxCell.checkBoxButton addTarget:inFormVC action:@selector(checkBoxClicked:) forControlEvents:UIControlEventTouchUpInside];
    checkBoxCell.checkBoxButton.elementId	= currentCompName;
    
    [inFormVC putToDataIdMap : checkBoxCell.checkBoxButton : currentCompName];
    
      [subContainer addSubview: checkBoxCell];
        yArguForDrawComp =yArguForDrawComp+50;
    return subContainer;
    
}


-(UIView*)drawLabel :(FormVC *) formController :(DotFormElement*) dotFormElement 
{
     UIView *subContainer = [[UIView alloc]initWithFrame:CGRectMake(0, yArguForDrawComp, screenWidth, formLineHeight)];
    NSString *valueSetToLabel = @"";
    ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    
    if((dotFormElement.masterValueMapping != nil) && (![dotFormElement.masterValueMapping isEqualToString:@""]))
    {
        if([clientVariables.CLIENT_APP_MASTER_DATA objectForKey:dotFormElement.masterValueMapping] != nil)
        {
            valueSetToLabel = (NSString *)[clientVariables.CLIENT_APP_MASTER_DATA objectForKey:dotFormElement.masterValueMapping];
        }
    }
    if(([valueSetToLabel isEqualToString:@""]) && ((dotFormElement.defaultVal)!=nil) && (![dotFormElement.defaultVal isEqualToString:@""]))
    {
        valueSetToLabel = dotFormElement.defaultVal;
    }
    NSString *attachedData;
    
    if((dotFormElement.dependedCompName)!= nil && [dotFormElement.dependedCompName isEqualToString:XmwcsConst_DE_LABEL_PREVIOUS_SCREEN])
    {
        attachedData = (NSString *)[formController.forwardedDataPost objectForKey:dotFormElement.elementId];
        valueSetToLabel = (NSString *)[formController.forwardedDataDisplay objectForKey:dotFormElement.elementId];
        
    }
    
    NSString *currentCompName = dotFormElement.elementId;
    static NSString *cellIdentifier = @"LabelTableViewCell";
    LabelTableViewCell *formCell;// = (LabelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    
    if (formCell == nil)
        formCell = [[LabelTableViewCell alloc] initWithFrame:CGRectMake(0, 0, screenWidth, formLineHeight)] ;
    
    if([dotFormElement isOptionalBool])
        formCell.mandatoryLabel.hidden	= YES;
    else
        formCell.mandatoryLabel.hidden	= NO;

    
    formCell.titleLabel.text = dotFormElement.displayText;
    
    //if([dotFormElement isOptionalBool]){
        formCell.titleLabel.text = dotFormElement.displayText;

        
   // }
   // else
   // {
   //     formCell.titleLabel.text = dotFormElement.displayText;
      //  formCell.titleLabel.text = [@"*" stringByAppendingString:formCell.titleLabel.text];

   // }

    if ([[formController.dotForm formId] isEqualToString:@"DOT_FORM_1"] ) {
         formCell.valueLabel.text = valueSetToLabel;//dotFormElement.defaultVal;
    }
    
   // formCell.valueLabel.text = valueSetToLabel;//dotFormElement.defaultVal;
    else
    {
        formCell.valueLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"CUSTOMER_NAME"];
    }
    
    formCell.valueLabel.elementId = currentCompName;
    formCell.valueLabel.attachedData = attachedData;//newly added
    formCell.frame = CGRectMake(0, 0, screenWidth, formLineHeight);
    
    
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentJustified;
    style.firstLineHeadIndent = 8.0f;
    style.headIndent = 10.0f;
    style.tailIndent = -10.0f;
    NSString *text= @"";
    if (formCell.valueLabel.text.length !=0) {
        text = formCell.valueLabel.text;
    }

    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:text attributes:@{ NSParagraphStyleAttributeName : style}];
    formCell.valueLabel.attributedText = attrText;
    
    
    
    [formController putToDataIdMap : formCell.valueLabel : currentCompName];
   
    [subContainer addSubview:formCell];
     yArguForDrawComp =yArguForDrawComp+formLineHeight;
    return subContainer;
}

-(UIView*) drawTimeField : (FormVC *) formController :(DotFormElement*) dotFormElement 
{
    UIView *subContainer = [[UIView alloc]initWithFrame:CGRectMake(0, yArguForDrawComp, screenWidth, formLineHeight)];
    
    NSString *currentCompName = dotFormElement.elementId;
    static NSString *cellIdentifier = @"TimeTableViewCell";
    TimeTableViewCell *timeCell;  
    
    
    if (timeCell == nil)
        timeCell = [[TimeTableViewCell alloc] initWithFrame:CGRectMake(0, 0, screenWidth, formLineHeight) reuseIdentifier:cellIdentifier];
    
    if([dotFormElement isOptionalBool])
        timeCell.mandatoryLabel.hidden	= YES;
    else
        timeCell.mandatoryLabel.hidden	= NO;
    
    
    timeCell.timeField.delegate		= formController;
    
    //if([dotFormElement isOptionalBool]){
    timeCell.titleLabel.text			= dotFormElement.displayText;
    // }
    // else
    // {
    //    calendarCell.titleLabel.text			= dotFormElement.displayText;
    //   calendarCell.titleLabel.text = [@"*" stringByAppendingString:calendarCell.titleLabel.text];
    //}
    
    timeCell.timeField.tag = 101;
    
    timeCell.timeButton.attachedData = dotFormElement.elementId;
    timeCell.timeButton.elementId = [[NSString alloc] initWithFormat : @"CAL_%@", dotFormElement.elementId];
    
    [timeCell.timeButton addTarget:formController action:@selector(timeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    timeCell.timeButton.elementId = currentCompName;
    
    [formController putToDataIdMap : timeCell.timeField : currentCompName];
    
    NSString* defaultVal  = [dotFormElement defaultVal];
    
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext]];
	NSMutableDictionary* clientAppMasterData = clientVariables.CLIENT_APP_MASTER_DATA;
    
	if( dotFormElement.masterValueMapping.length>0) {
        NSString*  tempDefault = [clientAppMasterData objectForKey:dotFormElement.masterValueMapping];
        if(tempDefault!=nil) {
			defaultVal = tempDefault;
		}
	}
    
	int hh = 8;
	int mm = 30;
    
    NSRange amFound = [defaultVal rangeOfString:@"AM" options:NSCaseInsensitiveSearch];
    NSRange pmFound = [defaultVal rangeOfString:@"PM" options:NSCaseInsensitiveSearch];
    // {NSNotFound, 0}
	if( (amFound.location == NSNotFound) &&  (pmFound.location == NSNotFound ))
    {
        NSArray *strTokens = [defaultVal componentsSeparatedByString:@":"];
		if([strTokens count] > 1) {
            hh = [[strTokens objectAtIndex:0]  intValue];
			mm = [[strTokens objectAtIndex:1]  intValue];
            
            if(hh>12) {
                timeCell.timeField.text = [[NSString alloc] initWithFormat:@"%.2d:%.2d PM", (hh-12), mm];
            } else {
                timeCell.timeField.text = [[NSString alloc] initWithFormat:@"%.2d:%.2d AM", hh, mm];
            }
            timeCell.timeField.attachedData = [[NSString alloc] initWithFormat:@"%.2d:%.2d", hh, mm];
		}
	}
    
    if(amFound.location != NSNotFound) {
        timeCell.timeField.text = defaultVal;
        timeCell.timeField.attachedData = defaultVal;
    }
    
    if(pmFound.location != NSNotFound) {
        timeCell.timeField.text = defaultVal;
        timeCell.timeField.attachedData = defaultVal;
        
    }
    
    [subContainer addSubview :timeCell];
    yArguForDrawComp =yArguForDrawComp+formLineHeight;
    return subContainer;
}

-(UIView*) drawRadioGroup : (FormVC *) formController :(DotFormElement*) dotFormElement
{
     UIView *subContainer = [[UIView alloc]initWithFrame:CGRectMake(0, yArguForDrawComp, screenWidth, formLineHeight+60)];
   
    NSString *currentCompName = dotFormElement.elementId;
    static NSString *cellIdentifier = @"RadioTableViewCell";
    RadioTableViewCell *textCell;// = (RadioTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
   
    
    if (textCell == nil)
        textCell = [[RadioTableViewCell alloc] initWithFrame:CGRectMake(0, 0, screenWidth, formLineHeight+60)];
    id masterValues = [DotFormDraw getMasterValueForComponent:[dotFormElement elementId] : [dotFormElement masterValueMapping]];
    
    
    textCell.radioGroup = [[RadioGroup alloc]initWithFrame:CGRectMake(20, 40, 80, 80) :masterValues[1] :0 : masterValues[0]] ;
    
    textCell.titleLabel.text = dotFormElement.displayText;
    
    textCell.radioGroup.elementId = currentCompName;
    
    [textCell addSubview:textCell.radioGroup];
    
 
    
    [formController putToDataIdMap : textCell.radioGroup : currentCompName];
    
    [subContainer addSubview:textCell];
     yArguForDrawComp =yArguForDrawComp+formLineHeight+60;
    return subContainer;

    
}


-(UIView*) drawSearchField : (FormVC *) inFormVC :(DotFormElement*) dotFormElement
{
    UIView *subContainer = [[UIView alloc]initWithFrame:CGRectMake(0, yArguForDrawComp, screenWidth, formLineHeight)];
   
    NSString *currentCompName = dotFormElement.elementId;
        
    NSMutableArray *arrayToValuePicker = [[NSMutableArray alloc] initWithCapacity:2];
    
    NSMutableArray *keyList = [[NSMutableArray alloc] init];
    NSMutableArray* optionList = [[NSMutableArray alloc] init];
    
    [keyList addObject:@"N"];
    [keyList addObject:@"S"];
    [arrayToValuePicker addObject:keyList];
    
    [optionList addObject:@"All"];
    [optionList addObject:@"Search"];
    [arrayToValuePicker addObject:optionList];
    
    //storage code start here
    SearchRequestStorage* searchStorage =  [SearchRequestStorage getInstance];
    NSMutableArray* cacheItemList = [searchStorage getSearchRecords:[DVAppDelegate currentModuleContext] :dotFormElement.masterValueMapping];
	if(cacheItemList!=0 && [cacheItemList count]>0)
    {
        for(int i=0; i<[cacheItemList count];i++)
        {
            SearchRequestItem* item = [cacheItemList objectAtIndex:i];
            [keyList addObject:item.keyValue];
            [optionList addObject:item.nameValue];
        }
    }
    //storage code close here

    
    
    id masterValues = arrayToValuePicker;
        
    static NSString *cellIdentifier = @"DropDownTableViewCell";
    DropDownTableViewCell *dropDownCell;// = [[DropDownTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier];
   
    if(dropDownCell == nil) {
        dropDownCell = [[DropDownTableViewCell alloc] initWithFrame:CGRectMake(0, 0, screenWidth, formLineHeight)];
    }

    if([dotFormElement isOptionalBool])
        dropDownCell.mandatoryLabel.hidden	= YES;
    else
        dropDownCell.mandatoryLabel.hidden	= NO;
    
    dropDownCell.dropDownField.delegate		= inFormVC;
    dropDownCell.dropDownButton.attachedData = masterValues;
    dropDownCell.titleLabel.text = dotFormElement.displayText;
    dropDownCell.dropDownField.tag = 101;
    dropDownCell.frame = CGRectMake(0, 0, screenWidth, formLineHeight);
        
    
    [dropDownCell.dropDownButton addTarget:inFormVC action:@selector(dropDownSearchPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    dropDownCell.dropDownButton.elementId	= currentCompName;
    
    [inFormVC putToDataIdMap : dropDownCell : currentCompName];
    
    [subContainer addSubview:dropDownCell];
     yArguForDrawComp =yArguForDrawComp+formLineHeight;
    return subContainer;
    
}


-(UIView*)drawSubHeader: (FormVC *) inFormVC :(DotFormElement*) dotFormElement
{
   
    NSString *masterValue = dotFormElement.elementId;
    NSLog(@ "Master value 1: %@", masterValue);
    
    ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    
    if((dotFormElement.masterValueMapping != nil) && ![dotFormElement.masterValueMapping isEqualToString : @""])
    {
        masterValue = dotFormElement.masterValueMapping;
        NSLog(@ "Master value 2: %@", masterValue);
    }
    
    NSMutableDictionary *subGroupData = (NSMutableDictionary *)[clientVariables.CLIENT_APP_MASTER_DATA objectForKey: masterValue];;
   
    if (subGroupData != nil)
    {
        NSArray* keysMap = [subGroupData allKeys];
        
        UIView* subContainer = [[UIView alloc]initWithFrame:CGRectMake(0, yArguForDrawComp, screenWidth, formLineHeight*[keysMap count])];
        
        for (int cntIndex = 0; cntIndex<[keysMap count]; cntIndex++)
        {
            NSString* leftLabelString = (NSString*) [keysMap objectAtIndex: cntIndex];
            
            UIView* mainContainer /* *subContainer*/ = [[UIView alloc]initWithFrame:CGRectMake(0, yArguForDrawComp, screenWidth, formLineHeight)];
            //subContainer.backgroundColor = [UIColor redColor];
            MXLabel *leftLabel = [[MXLabel alloc]initWithFrame:CGRectMake(2, 0, screenWidth/2, formLineHeight)];
            // leftLabel.backgroundColor = [UIColor greenColor];
            leftLabel.text = leftLabelString;
            leftLabel.backgroundColor = [UIColor clearColor];
            [mainContainer addSubview:leftLabel];
            NSString *rightLabelString = (NSString *)[subGroupData objectForKey:leftLabelString];
            
            MXLabel *rightLabel = [[MXLabel alloc]initWithFrame:CGRectMake(screenWidth/2, 0, screenWidth/2, formLineHeight)];
            //rightLabel.backgroundColor = [UIColor grayColor];
            rightLabel.text = rightLabelString;
            rightLabel.backgroundColor = [UIColor clearColor];
            [mainContainer addSubview:rightLabel];
            [subContainer addSubview:mainContainer];
            
            yArguForDrawComp= yArguForDrawComp+formLineHeight;
                        
        }
        return subContainer;
    }
    return nil;
}


-(UIView*) drawEditSearchField:(FormVC *) inFormVC :(DotFormElement*) dotFormElement
{
    UIView *subContainer = [[UIView alloc]initWithFrame:CGRectMake(0, yArguForDrawComp, screenWidth, formLineHeight)];
    
    NSString *currentCompName = dotFormElement.elementId;
    
    EditSearchField* editSearchField = [[EditSearchField alloc] initWithFrame:CGRectMake(0, 0, screenWidth , formLineHeight)];
    
    [editSearchField configureViewCellFor:dotFormElement];

    
    [editSearchField.searchButton addTarget:inFormVC action:@selector(editSearchAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [subContainer addSubview:editSearchField];
    
    [inFormVC putToDataIdMap : editSearchField : currentCompName];
    
    yArguForDrawComp =yArguForDrawComp+formLineHeight;
    return subContainer;
}


-(UIView*) drawBarcodeScanField:(FormVC *) inFormVC :(DotFormElement*) dotFormElement
{
    UIView *subContainer = [[UIView alloc]initWithFrame:CGRectMake(0, yArguForDrawComp, screenWidth, formLineHeight)];
    
    NSString *currentCompName = dotFormElement.elementId;
    
    BarCodeScanField* barCodeScanField = [[BarCodeScanField alloc] initWithFrame:CGRectMake(0, 0, screenWidth , formLineHeight)];
    
    [barCodeScanField configureViewCellFor:dotFormElement];
    barCodeScanField.editText.delegate = inFormVC;
    
    
    [barCodeScanField.scanButton addTarget:inFormVC action:@selector(barCodeScanButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [subContainer addSubview:barCodeScanField];
    
    [inFormVC putToDataIdMap : barCodeScanField : currentCompName];
    
    yArguForDrawComp =yArguForDrawComp+formLineHeight;
    return subContainer;
}



+(id) getMasterValueForComponent : (NSString *) elementId :  (NSString *) masterValueMapping
{
    ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    if ((masterValueMapping != nil) && ![masterValueMapping isEqualToString: @""])
    {
        elementId = masterValueMapping;
    }
    
    NSMutableDictionary* ddKeyValue =[clientVariables.CLIENT_APP_MASTER_DATA objectForKey: elementId ];
    
    NSArray* keysMap = [ddKeyValue allKeys];
    
    
    if( [ddKeyValue count] > 0) {
        NSMutableArray* arrayValue = [[NSMutableArray alloc]init];
        NSMutableArray* arrayKey = [[NSMutableArray alloc]init];
    
        for (int cntIndex = 0; cntIndex<[keysMap count]; cntIndex++)
        {
            NSString* key = (NSString*) [keysMap objectAtIndex: cntIndex];  //.nextElement();
            [arrayKey insertObject:key atIndex:cntIndex ];
            [arrayValue insertObject: [ddKeyValue objectForKey:key] atIndex:cntIndex];
        
            // arrayValue[cntIndex] = ((String) ddKeyValue.get(key));
        }
    
        NSMutableArray* finalObjArray = [[NSMutableArray alloc]init];
        [finalObjArray insertObject:arrayKey atIndex:0 ];
        [finalObjArray insertObject:arrayValue atIndex:1 ];
        return finalObjArray;
        
    }
    return nil;
}

+(id) getSortedMasterValueForComponent : (NSString *) elementId :  (NSString *) masterValueMapping
{
    ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    if ((masterValueMapping != nil) && ![masterValueMapping isEqualToString: @""])
    {
        elementId = masterValueMapping;
    }
    
    NSMutableDictionary* ddKeyValue =[clientVariables.CLIENT_APP_MASTER_DATA objectForKey: elementId ];
    
    // NSArray* unsortedKeys = [ddKeyValue allKeys];
    NSArray* sortedPairs = [XmwUtils sortHashtableByValue:ddKeyValue :XmwcsConst_SORT_AS_STRING];
    if( [sortedPairs count] > 0) {
        NSMutableArray* arrayValue = [[NSMutableArray alloc]init];
        NSMutableArray* arrayKey = [[NSMutableArray alloc]init];
        
        for (int cntIndex = 0; cntIndex<[sortedPairs count]; cntIndex++)
        {
            NSArray* pair = (NSArray*) [sortedPairs objectAtIndex: cntIndex];  //.nextElement();
            [arrayKey insertObject:[pair objectAtIndex:0] atIndex:cntIndex ];
            [arrayValue insertObject:[pair objectAtIndex:1] atIndex:cntIndex];            
        }
        
        NSMutableArray* finalObjArray = [[NSMutableArray alloc]init];
        [finalObjArray insertObject:arrayKey atIndex:0 ];
        [finalObjArray insertObject:arrayValue atIndex:1 ];
        return finalObjArray;
    }
    
    /*
    NSArray* sortedKeys = [XmwUtils sortHashtableKey:ddKeyValue :XmwcsConst_SORT_AS_STRING];
    if( [ddKeyValue count] > 0) {
        NSMutableArray* arrayValue = [[NSMutableArray alloc]init];
        NSMutableArray* arrayKey = [[NSMutableArray alloc]init];
        
        for (int cntIndex = 0; cntIndex<[sortedKeys count]; cntIndex++)
        {
            NSString* key = (NSString*) [sortedKeys objectAtIndex: cntIndex];  //.nextElement();
            [arrayKey insertObject:key atIndex:cntIndex ];
            [arrayValue insertObject: [ddKeyValue objectForKey:key] atIndex:cntIndex];
            
            // arrayValue[cntIndex] = ((String) ddKeyValue.get(key));
        }
        
        NSMutableArray* finalObjArray = [[NSMutableArray alloc]init];
        [finalObjArray insertObject:arrayKey atIndex:0 ];
        [finalObjArray insertObject:arrayValue atIndex:1 ];
        return finalObjArray;
    }
     */
    
    return nil;
}

+(NSMutableDictionary*) makeMenuForButtonScreen : (NSString*) formId {
	ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    DotForm* dotForm = [clientVariables.DOT_FORM_MAP objectForKey:formId];
    NSMutableDictionary* dotFormElements = dotForm.formElements;
      
    NSArray* sortedElements = [XmwUtils  sortedDotFormElementIds : dotFormElements];
    
    NSMutableDictionary* buttonDetail = [[NSMutableDictionary alloc] init];
    
	for (int cntElement = 0; cntElement < [sortedElements count]; cntElement++) {
       // DotFormElement* dotFormElement = (DotFormElement*) [dotFormElements objectForKey: [sortedElements objectAtIndex:cntElement]];
        DotFormElement* dotFormElement =  [sortedElements objectAtIndex:cntElement];
                
		NSMutableDictionary* buttonData = [[NSMutableDictionary alloc] init];
        [buttonData setObject:dotFormElement.dependedCompName forKey:XmwcsConst_MENU_CONSTANT_FORM_TYPE ];
		[buttonData setObject:dotFormElement.dependedCompValue forKey:XmwcsConst_MENU_CONSTANT_FORM_ID ];
		[buttonData setObject:dotFormElement.displayText forKey:XmwcsConst_MENU_CONSTANT_MENU_NAME ];

		[buttonDetail setObject:buttonData forKey:dotFormElement.componentPosition];
		
	}
    
	return buttonDetail;
}


    
- (void) hideFormRowContainer :(UIView*) parentCont : (NSString*) nameId : (BOOL) hideState
{
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext]];
    
    NSNumber* tagNumber = [self.tag_elementId_map objectForKey:nameId];
    UIView* childCont = nil;
    if(tagNumber!=nil) {
        childCont = [parentCont viewWithTag:tagNumber.intValue ];
        
        if(childCont!=nil) {
            BOOL prevState = childCont.hidden;
            [childCont setHidden:hideState];
            
            NSArray* viewList = [parentCont subviews];
            
            BOOL reAdjust = NO;
            for(int i=0; i<viewList.count; i++) {
                UIView* tempCont = [viewList objectAtIndex:i];
                if(tempCont==childCont) {
                    reAdjust = YES;
                } else {
                    if(reAdjust==YES) {
                        // change the framerect
                        if(hideState==YES) {
                            if(prevState==NO) {
                                tempCont.frame = CGRectMake(tempCont.frame.origin.x, tempCont.frame.origin.y - childCont.frame.size.height  , tempCont.frame.size.width, tempCont.frame.size.height);
                                yArguForDrawComp = yArguForDrawComp - childCont.frame.size.height;
                            }
                        } else {
                            if(prevState==YES) {
                                tempCont.frame = CGRectMake(tempCont.frame.origin.x, tempCont.frame.origin.y + childCont.frame.size.height  , tempCont.frame.size.width, tempCont.frame.size.height);
                                yArguForDrawComp = yArguForDrawComp + childCont.frame.size.height;
                            }
                        }
                    }
                }
            }
        }
    }
   
}

- (int) removeFormRowContainer : (UIView*) parentCont : (NSString*) nameId
{
    int retVal = 0;
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext]];
    int heightAdjustment = 0;
    UIView* childCont = nil;
    NSNumber* tagNumber = [self.tag_elementId_map objectForKey:nameId];
    if(tagNumber!=nil) {
        childCont = [parentCont viewWithTag:tagNumber.intValue ];
        heightAdjustment = childCont.frame.size.height;
        if(childCont!=nil) {
            
            NSArray* viewList = [parentCont subviews];
            BOOL reAdjust = NO;
            for(int i=0; i<viewList.count; i++) {
                UIView* tempCont = [viewList objectAtIndex:i];
                if(tempCont==childCont) {
                    reAdjust = YES;
                } else {
                    if(reAdjust==YES) {
                        // change the framerect
                        tempCont.frame = CGRectMake(tempCont.frame.origin.x, tempCont.frame.origin.y - childCont.frame.size.height  , tempCont.frame.size.width, tempCont.frame.size.height);
                        yArguForDrawComp = yArguForDrawComp - childCont.frame.size.height;
                    }
                }
            }
            [childCont removeFromSuperview];
        }
        retVal = tagNumber.intValue;
    }

    return retVal;
}


- (UIView*) formRowContainer:(UIView*) parentCont :(NSString*) nameId
{
    UIView* rowContainer = nil;
    
    NSNumber* tagNumber = [self.tag_elementId_map objectForKey:nameId];
    if(tagNumber!=nil) {
        rowContainer = [parentCont viewWithTag:tagNumber.intValue ];
        
    }
    return rowContainer;
}

-(void) insertFormRowContainer : (UIView*) parentCont : (UIView*) rowCont : (int) beforeTag
{
    
    NSArray* viewList = [parentCont subviews];
    
    UIView* iterCont  = nil;
    int idx = 0;
    for(idx = 0; idx < viewList.count; idx++) {
        iterCont = [viewList objectAtIndex:idx];
        if(iterCont.tag > beforeTag) {
            
            break;
        }
    }
    if(idx<viewList.count) {
        [parentCont insertSubview:rowCont belowSubview:iterCont];
        viewList = [parentCont subviews];
        idx = idx +1 ;
        for( ; idx< viewList.count; idx++) {
            UIView* tempCont = [viewList objectAtIndex:idx];
            tempCont.frame = CGRectMake(tempCont.frame.origin.x, tempCont.frame.origin.y + rowCont.frame.size.height  , tempCont.frame.size.width, tempCont.frame.size.height);
            //yArguForDrawComp = yArguForDrawComp - rowCont.frame.size.height;
        }
    } else {
        [parentCont addSubview:rowCont];
    }
}


-(UIView*)drawDropDown : (FormVC *) formController :(DotFormElement*) dotFormElement  customMaster:(id) masterValues
{
    UIView *subContainer = [[UIView alloc]initWithFrame:CGRectMake(0, yArguForDrawComp, screenWidth, formLineHeight)];
    
    NSString *currentCompName = dotFormElement.elementId;
    
    if(masterValues != nil) {
        NSMutableDictionary*  cellDropDownDictionary = masterValues[1];
        
        if([cellDropDownDictionary count] > 0)
        {
            static NSString *cellIdentifier = @"DropDownTableViewCell";
            DropDownTableViewCell *dropDownCell;// = (DropDownTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (dropDownCell == nil)
                dropDownCell = [[DropDownTableViewCell alloc] initWithFrame:CGRectZero] ;
            
            if([dotFormElement isOptionalBool])
                dropDownCell.mandatoryLabel.hidden	= YES;
            else
                dropDownCell.mandatoryLabel.hidden	= NO;
            
            dropDownCell.dropDownField.delegate		= formController;
            dropDownCell.dropDownField.tag			= 101;//indexPath.row + 101;
            dropDownCell.dropDownButton.attachedData	= masterValues;
            dropDownCell.dropDownField.elementId = currentCompName;
            
            dropDownCell.titleLabel.text = dotFormElement.displayText;
            
            [dropDownCell.dropDownButton addTarget:formController action:@selector(dropDownPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            dropDownCell.dropDownButton.elementId	= currentCompName;
            
            [formController putToDataIdMap : dropDownCell.dropDownField : currentCompName];
            
            [subContainer addSubview: dropDownCell];
            yArguForDrawComp =yArguForDrawComp+formLineHeight;
            return subContainer;
        } else {
            return [self drawTextField : formController : dotFormElement : false];
        }
    } else {
        return [self drawTextField : formController : dotFormElement : false];
    }
}


-(void) setFormEditable:(UIView *) formContainer :(DotForm*) dotForm :(FormVC*) inFormVC
{
    NSMutableDictionary *dotFormElements = (NSMutableDictionary *)[dotForm formElements];
    NSMutableArray *sortedElements =[DotFormDraw sortFormComponents : dotFormElements];
    
    for(int cntElement = 0; cntElement < [sortedElements count] ; cntElement++)
    {
        DotFormElement* dotFormElement = (DotFormElement *)[dotFormElements objectForKey:[sortedElements objectAtIndex:cntElement]];
        NSNumber* tagNum =   [tag_elementId_map objectForKey:dotFormElement.elementId];
        UIView* formRowHolder = [formContainer viewWithTag:tagNum.intValue];
        
        NSLog(@"DotFormDraw: elementid = %@, tag index = %d", dotFormElement.elementId, tagNum.intValue);
        
            if([dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_TEXTFIELD]) {
                MXTextField* mxTextField = (MXTextField*)[inFormVC getDataFromId:dotFormElement.elementId];
                mxTextField.enabled = ![dotFormElement isReadonly];
            } else if([dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_CHECKBOX]) {
                MXButton* mxbutton = (MXButton*) [inFormVC getDataFromId:dotFormElement.elementId];
                mxbutton.enabled = ![dotFormElement isReadonly];
            } else if([dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_DROPDOWN]) {  // DROPDOWN
                MXTextField* mxTextField = (MXTextField*)[inFormVC getDataFromId:dotFormElement.elementId];
                // @@@@Pradeep@@@@ Since here, we are not using editable dropdown, they should be disabled.
                mxTextField.enabled = ![dotFormElement isReadonly];
            } else if([dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_DATE_FIELD]) {   // DATE_FIELD
                MXTextField* mxTextField = (MXTextField*)[inFormVC getDataFromId:dotFormElement.elementId];
                // MarriageAnniversary, DateOfBirth, createDate etc, may have time
                mxTextField.enabled = ![dotFormElement isReadonly];
            } else if([dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_TEXTAREA]) {  // TEXTAREA
                MXTextField* mxTextField = (MXTextField*)[inFormVC getDataFromId:dotFormElement.elementId];
                mxTextField.enabled = ![dotFormElement isReadonly];
            } else if([dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_CHECKBOX_GROUP]) {
                // for checkbox group
               
                    CheckBoxGroup* checkBoxGroup = (CheckBoxGroup*)[inFormVC getDataFromId:dotFormElement.elementId];
                    for(int i=0; i<[checkBoxGroup.checkBoxItems count]; i++) {
                        CheckBoxGroupItem* cbGroupItem = (CheckBoxGroupItem*)[checkBoxGroup.checkBoxItems objectAtIndex:i];
                        cbGroupItem.checkBoxGroupButton.enabled = YES;
                    }
            } else if([dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_MULTI_SELECT]) {
                
            }
    }
}


@end
