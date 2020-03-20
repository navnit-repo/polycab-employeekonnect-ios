//
//  AddRowFormUtils.m
//  QCMSProject
//
//  Created by Ashish Tiwari on 01/07/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "AddRowFormUtils.h"
#import "XmwUtils.h"
#import "DotFormPostUtil.h"
#import "LabelTableViewCell.h"
#import "ClientVariable.h"
#import "DVAppDelegate.h"
#import "DotFormPost.h"
#import "DotRowContainer.h"
#import "DotFieldDataOperationUtils.h"
#import "TagKeyConstant.h"

@interface  AddRowFormUtils ()
{
    int rowHeight;
    int screenWidth;

}

@end

@implementation AddRowFormUtils


-(UIView *) drawRowForTable : (DotForm *) formDef : (NSInteger) rowNoOfTable : (DotFormPost *) formPost
{
    int x=0;
    
    DotRowContainer *containerAddRow = [[DotRowContainer alloc]initWithFrame:CGRectMake(0, yOffset, screenWidth, rowHeight)];
    containerAddRow.backgroundColor = [UIColor whiteColor];
    containerAddRow.name = [NSString stringWithFormat : @"addrow%d",rowNoOfTable];
    containerAddRow.tag = TAG_FORM_TABLE_CONTAINER + rowNoOfTable;
    
    NSMutableArray *addData = [[NSMutableArray alloc]init];
    [addData addObject: [[NSNumber alloc] initWithInt:rowNoOfTable]];
    [addData addObject:formDef.formId];
    
    //Attach the vector data to Row and make it focusable
     NSMutableArray *addRowCol = (NSMutableArray *)[XmwUtils breakStringTokenAsVector : formDef.addRowColumn : @"$"];
     NSMutableDictionary *formCompMap = formDef.formElements;
    for (int j = 0; j < [addRowCol count]; j++) {
        DotFormElement *formElement = (DotFormElement *) [formCompMap objectForKey:[addRowCol objectAtIndex:j]];
        
        UIView *tableAddRow = [[DotRowContainer alloc]initWithFrame:CGRectMake(x, 0, (screenWidth-50)/[addRowCol count], rowHeight)];
             
       if ([formElement isComponentDisplayBool])
        {
            // NSString *labelStr = (NSString *)[formPost.postData objectForKey: [formElement.elementId stringByAppendingFormat: @":%d",rowNoOfTable]];
            NSString *labelStrDisp = (NSString *) [formPost.displayData objectForKey: [formElement.elementId stringByAppendingFormat: @":%d",rowNoOfTable]];
            // int width = (screenWidth-50)*([formElement.length intValue])/100;
            MXLabel *labelAddRow = [[MXLabel alloc]initWithFrame:CGRectMake(2, 0, (screenWidth-50)/[addRowCol count], rowHeight)];
            labelAddRow.text = labelStrDisp;
            labelAddRow.backgroundColor = [UIColor clearColor];
            labelAddRow.font = [UIFont systemFontOfSize:12];
            [tableAddRow addSubview:labelAddRow];
            [containerAddRow addSubview:tableAddRow];
            
            x = x + screenWidth/[addRowCol count];
        }
    }
    yOffset = yOffset + rowHeight;
   
    [formPost.postData setObject:@"row added" forKey:[formDef.tableName stringByAppendingFormat : @":%d",rowNoOfTable]];
    [formPost.displayData setObject: @"row added For Display" forKey:[formDef.tableName stringByAppendingFormat:@": %d",rowNoOfTable]];
     NSNumber *tableRowNo = [[NSNumber alloc]initWithInt:rowNoOfTable];
    [formPost.displayData setObject : tableRowNo forKey:formDef.tableName];
    [formPost.postData setObject : tableRowNo forKey:formDef.tableName];
       
    return containerAddRow;
    
    
}
-(int) addDocDetailAsRow : (NSString *) formId : (NSInteger) rowNoOfTable : (DotFormPost *) formPost : (FormVC *)baseForm : (UIView *) addItemContainer : (BOOL) submitButtonFlag
{
    screenWidth = [[UIScreen mainScreen] bounds].size.width;
    rowHeight = 36;
     ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
    DotForm *formDef = (DotForm *) [clientVariables.DOT_FORM_MAP objectForKey:formId];
    //it is check that field is mandatory or optional.
    DotFormPostUtil *dotFormPostUtil = [[DotFormPostUtil alloc]init];
    BOOL flagMandatory = [dotFormPostUtil mandatoryCheck:formDef :baseForm];
    if (!flagMandatory)
    {
        return -1;
    }
    
    [dotFormPostUtil getFormComponentData:formDef :baseForm :formPost :[NSString stringWithFormat : @":%d",rowNoOfTable] :nil :nil];
    
    if (rowNoOfTable == 1) {
        UIView *containerColumn = [self makeItemHeaderTable:formDef];
       [addItemContainer addSubview:containerColumn];
        
        addItemContainer.frame = CGRectMake(addItemContainer.frame.origin.x, addItemContainer.frame.origin.y,
                                            addItemContainer.frame.size.width, addItemContainer.frame.size.height + rowHeight);
        
    }
    
    UIButton *deleteButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setFrame:CGRectMake(screenWidth-40, 2, 32, 32)];
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"defaultDeleteIcon.png"] forState:UIControlStateNormal];
    deleteButton.tag = TAG_FORM_TABLE_ROWCONTAINER + rowNoOfTable;
    [deleteButton addTarget:baseForm action:@selector(rowDeleteClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *containerAddRow = [self drawRowForTable:formDef :rowNoOfTable :formPost];
    [containerAddRow addSubview:deleteButton];
    
    [addItemContainer addSubview:containerAddRow];
    addItemContainer.frame = CGRectMake(addItemContainer.frame.origin.x, addItemContainer.frame.origin.y,
                                        addItemContainer.frame.size.width, addItemContainer.frame.size.height + rowHeight);
    
    if([[DVAppDelegate currentModuleContext] isEqualToString: XmwcsConst_APP_MODULE_ESS] && [formDef.formId isEqualToString :@"DOT_FORM_37"])
    {
		MXLabel* totalAmtTF =  (MXLabel*) [baseForm getDataFromId : @"TOTAL_AMOUNT"];
		NSString* firstString = totalAmtTF.text;
		NSString* appendString = [[NSString alloc] initWithFormat : @"OTH_AMNT:%d", rowNoOfTable];
		// appendString.append(QString::number(rowNoOfTable, 10));
		NSString* secondString = [formPost.displayData objectForKey:appendString];
        
		NSString* result = [DotFieldDataOperationUtils calculateData : firstString : secondString : XmwcsConst_FIELD_OPERATION_ADDITION];
		totalAmtTF.text = result;
	}
    
    
    [self clearForm:formDef : baseForm];
    return yOffset;
}

-(void) clearForm : (DotForm*) formDef : (FormVC*) baseForm
{
    NSMutableDictionary* dotFormElements = formDef.formElements;
    NSArray *sortedElements 	=  [XmwUtils  sortedDotFormElementIds : dotFormElements];
    
    for (int cntElement = 0; cntElement < [sortedElements count]; cntElement++) {
        DotFormElement* dotFormElement  = (DotFormElement*)[sortedElements objectAtIndex:cntElement];
        NSString* componentType = dotFormElement.componentType;
        NSString* elementId = dotFormElement.elementId;
        
        if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_TEXTFIELD] ||
            [componentType isEqualToString : XmwcsConst_DE_COMPONENT_TEXTFIELD_PASSWORD] ||
            [componentType isEqualToString : XmwcsConst_DE_COMPONENT_DATE_FIELD]
            )
        {
            MXTextField* textField = [baseForm getDataFromId:elementId];
            textField.text = @"";
        } else if([componentType isEqualToString : XmwcsConst_DE_COMPONENT_TEXTAREA])
        {
            MXTextField* textField = [baseForm getDataFromId:elementId];
            textField.text = @"";
            
        } else if([componentType isEqualToString : XmwcsConst_DE_COMPONENT_DROPDOWN])
        {
            MXTextField* textField = [baseForm getDataFromId:elementId];
            textField.text = @"";
            
        } else if([componentType isEqualToString : XmwcsConst_DE_COMPONENT_SEARCH_FIELD])
        {
            
            
        }
    }
    
}

-(UIView *) makeItemHeaderTable : (DotForm *) formDef
{
    int x = 0;
    yOffset = 0;
    
    UIView* headerContainer = [[UIView alloc]initWithFrame:CGRectMake(0, yOffset, screenWidth, rowHeight)];
    headerContainer.backgroundColor = [UIColor lightGrayColor];;
    NSMutableDictionary *dotElements = formDef.formElements;
     NSArray *addRowCol = [XmwUtils breakStringTokenAsVector : formDef.addRowColumn : @"$"];
    for (int cntElement = 0; cntElement < [addRowCol count]; cntElement++)
    {
       UIView* headerRow  = [[UIView alloc]initWithFrame:CGRectMake(x, 0, (screenWidth-50)/[addRowCol count], rowHeight)];
       DotFormElement *dotFormElement = (DotFormElement *) [dotElements objectForKey:[addRowCol objectAtIndex:cntElement]];
        MXLabel * lableHeader = [[MXLabel alloc]initWithFrame:CGRectMake(2, 0, (screenWidth-50)/[addRowCol count], rowHeight)];
        lableHeader.text = dotFormElement.displayText;
        lableHeader.backgroundColor = [UIColor lightGrayColor];
        lableHeader.font = [UIFont systemFontOfSize:14];
        [headerRow addSubview:lableHeader];
        [headerContainer addSubview:headerRow];
        x = x+screenWidth/[addRowCol count];
    }
    yOffset = yOffset + rowHeight;
    return headerContainer;
   
}


-(int) deleteRow : (FormVC *) baseForm : (DotFormPost *) formPost : (UIView *) addItemContainer : (NSInteger) rowNoOfTable :(UIView*)toBeRemovedViewed : (int) rowNoDelete
{
    if(toBeRemovedViewed!=nil) {
        [toBeRemovedViewed removeFromSuperview];
        yOffset = yOffset - rowHeight;
        // we need to move up other rows from the tableContainer / addItemContainer
        for(int rowIdx = (rowNoDelete + 1); rowIdx<= rowNoOfTable; rowIdx++) {
            UIView* rowContainer =  [addItemContainer viewWithTag: (TAG_FORM_TABLE_CONTAINER + rowIdx)];
            if(rowContainer!=nil) {
                rowContainer.frame = CGRectMake(rowContainer.frame.origin.x, rowContainer.frame.origin.y - rowHeight,
                                                rowContainer.frame.size.width, rowContainer.frame.size.height);
            }
        }
    }
   // ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];

    DotForm *dotForm = baseForm.dotForm;
    
    
    // special code for other rreimbursement form
    if( [[DVAppDelegate currentModuleContext] isEqualToString: XmwcsConst_APP_MODULE_ESS] &&
       [dotForm.formId isEqualToString : @"DOT_FORM_37"])
    {
        MXLabel* totalAmtTF =  (MXLabel*) [baseForm getDataFromId:@"TOTAL_AMOUNT"];
        NSString* firstString = totalAmtTF.text;
        NSString* appendString = [[NSString alloc] initWithFormat : @"OTH_AMNT:%d", rowNoDelete];
		// appendString.append(QString::number(rowNoOfTable, 10));
		NSString* secondString = [formPost.displayData objectForKey:appendString];
        
        NSString* result = [DotFieldDataOperationUtils calculateData : firstString : secondString : XmwcsConst_FIELD_OPERATION_SUBSTRACTION];
		totalAmtTF.text = result;
    }

    
    NSMutableDictionary *dotElements = dotForm.formElements;
    NSArray *enumElementKeys = [dotElements allKeys];
           
    for (int i=0; i<[enumElementKeys count]; i++)
    {
        NSString *key = [enumElementKeys objectAtIndex:i];
        DotFormElement *formComponent = [dotElements objectForKey:key]; 
                
        [formPost.displayData removeObjectForKey:[formComponent.elementId stringByAppendingFormat:@":%d", rowNoDelete]];
        [formPost.postData removeObjectForKey:[formComponent.elementId stringByAppendingFormat:@":%d", rowNoDelete]];
    }
  
    [formPost.postData removeObjectForKey:[dotForm.tableName stringByAppendingFormat:@":%d", rowNoDelete]];
    [formPost.displayData removeObjectForKey:[dotForm.tableName stringByAppendingFormat:@":%d",rowNoDelete]];
    

    
    return yOffset;
}

@end
