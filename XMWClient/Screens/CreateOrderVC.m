//
//  CreateOrderVC.m
//  QCMSProject
//
//  Created by Pradeep Singh on 7/5/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import "CreateOrderVC.h"
#import "DVTableFormView.h"
#import "CheckBoxButton.h"
#import "CheckBoxGroup.h"
#import "XMWTableFormDelegate.h"
#import "DotFormDraw.h"


@interface CreateOrderTableFormDelegate : XMWTableFormDelegate
{
    CGFloat columnOffsets[10];
}

@end


@implementation CreateOrderTableFormDelegate

-(id)init
{
    self  = [super init];
    
    columnOffsets[0] = 0.0f;
    columnOffsets[1] = 110.0f;
    columnOffsets[2] = 170.0f;
    columnOffsets[3] = 300.0f;
    columnOffsets[4] = 340.0f;
    columnOffsets[5] = 380.0f;
    columnOffsets[6] = 450.0f;
    columnOffsets[7] = 520.0f;
    columnOffsets[8] = 590.0f;
    columnOffsets[9] = 660.0f;
    
    return self;
}


-(CGFloat) columnOffsetForColumn:(int) colIdx
{
    if(colIdx<10) {
        return columnOffsets[colIdx];
    } else {
        return columnOffsets[9] + (11-colIdx)*70.0f;
    }
}


@end



@implementation CreateOrderVC

- (void)viewDidLoad {
    self.headerStr = @"Create Order";
    
    dotFormDraw.tableFormDelegate = [[CreateOrderTableFormDelegate alloc] init];
    dotFormDraw.tableFormDelegate.formViewController = self;

    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    // we need to fill data from the draft data saved in the user preference
    
    // save it in the use defaults
    NSString* productKey = [NSString stringWithFormat:@"SPART:%@", [self.forwardedDataPost objectForKey:@"SPART"]];
    
    id cacheDataObj = [[NSUserDefaults standardUserDefaults] objectForKey:productKey];

    if(cacheDataObj !=nil && [cacheDataObj isKindOfClass:[NSDictionary class]]) {
        NSDictionary* formData = (NSDictionary*) cacheDataObj;
        [self setFormData:formData];
        
    }

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


- (void) backHandler : (id) sender
{
    if([self.dotForm.formId isEqualToString:@"DOT_FORM_31"]) {
        NSLog(@"User pressed back, so we need to state the save of this form as it is transaction form");
        [self saveSameFormRowDataDraft];
        
    }
    [ [self navigationController]  popViewControllerAnimated:YES];
    
}


//
// TODO @@@@Pradeep@@@@
// we need to save user filled form data in case of Create Order as Draft state
// When this form gets visible again, then ask user show last draft data here
//



#pragma mark - Form Draft

-(void) saveSameFormRowDataDraft
{
    NSMutableDictionary* formViewSerializedData = [[NSMutableDictionary alloc] init];
    
    DVTableFormView* rowForm  = (DVTableFormView*)self.rowFormInSameForm;
    DotForm* formDef = self.dotForm;
    
    NSArray* addRowDotFormElementArray = formDef.addRowFormElements;
    NSArray* nonAddRowDotFormElementArray = formDef.nonAddRowFormElements;
    
    // need to get the row table data
    if(rowForm!=nil) {
        // rowForm.rowDelegate
        int maxRows = [rowForm getRowCount];
        // [formPost.postData setObject:[NSString stringWithFormat:@"%d", maxRows] forKey:formDef.tableName];
        for(int i=1; i<=maxRows; i++) {
            // rows start with i=1
            UIView* rowContent = [rowForm getRowWithRowId:i];
            NSArray* rowData = [rowForm.rowDelegate rowDataForSubmit:rowContent forRow:i];
            
            @try {
                int colIdx = 0;
                NSMutableDictionary* rowDic = [[NSMutableDictionary alloc] init];
                for (DotFormElement* dotFormElement in addRowDotFormElementArray) {
                    NSString* value  = (NSString*)[rowData objectAtIndex:colIdx];
                    [rowDic setObject:value forKey:dotFormElement.elementId];
                    colIdx = colIdx + 1;
                }
                [formViewSerializedData setObject:rowDic forKey:[NSString stringWithFormat:@"row_%d", i]];
            }
            @catch (NSException *exception) {
                NSLog(@"This row =%d is invalid. got Excetion %@", i,exception.description);
            }
            @finally {
                NSLog(@"Processing row=%d", i);
            }
        }
        [formViewSerializedData setObject:[NSString stringWithFormat:@"%d", maxRows] forKey:@"row_count"];
    }
    
    // reading rest other data
    for (int cntElement = 0; cntElement < [nonAddRowDotFormElementArray count]; cntElement++) {
        DotFormElement *dotFormElement  = (DotFormElement*)[nonAddRowDotFormElementArray objectAtIndex:cntElement];
        NSMutableArray *elementValue =[self getDotFormElementData: dotFormElement];
        
        // at 0, is submit data, and 1 is display data
        [formViewSerializedData setObject:elementValue forKey:dotFormElement.elementId];
    }
    
    // save it in the use defaults
    NSString* productKey = [NSString stringWithFormat:@"SPART:%@", [self.forwardedDataPost objectForKey:@"SPART"]];
    
    [[NSUserDefaults standardUserDefaults] setObject:formViewSerializedData forKey:productKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}



-(NSMutableArray * ) getDotFormElementData:(DotFormElement *) dotFormElement
{
    NSString *componentType = dotFormElement.componentType;
    NSString *id = dotFormElement.elementId;
    NSString *valueToSubmit = @"";
    NSString *valueToDisplay = @"";
    
    NSMutableArray *valueOfComponent = [[NSMutableArray alloc] init];
    
    if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_TEXTFIELD]
        || [componentType isEqualToString : XmwcsConst_DE_COMPONENT_TEXTFIELD_PASSWORD]
        || [componentType isEqualToString : XmwcsConst_DE_COMPONENT_DATE_FIELD])
    {
        MXTextField *textField = (MXTextField *)[self getDataFromId:id];
        valueToSubmit = valueToDisplay = textField.text;
        
    }
    else if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_TEXTAREA])
    {
        MXTextField *textField = (MXTextField *)[self getDataFromId:id];
        valueToSubmit = valueToDisplay = textField.text;
    }
    else if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_DROPDOWN] )
    {
        MXTextField *dropDownField = (MXTextField *) [self getDataFromId:id];
        valueToSubmit =  dropDownField.keyvalue ;
        valueToDisplay = dropDownField.text ;
    }
    else if ([componentType isEqualToString:XmwcsConst_DE_COMPONENT_SEARCH_FIELD])
    {
        DropDownTableViewCell *dropDownCell = [self getDataFromId:id];
        MXTextField *dropDownField = dropDownCell.dropDownField;
        valueToDisplay = dropDownField.text;
        valueToSubmit = dropDownField.keyvalue;
    }
    else if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_CHECKBOX])
    {
        CheckBoxButton *checkBoxButton = (CheckBoxButton *)[self getDataFromId:id];
        if(checkBoxButton.isChecked)
        {
            valueToDisplay = @"1";
            valueToSubmit = (NSString *) checkBoxButton.elementId;
            
        }
    }
    else if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_CHECKBOX_GROUP]) {
    }
    else if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_LABEL])
    {
        MXLabel *label = (MXLabel *) [self getDataFromId:id];
        valueToSubmit =  valueToDisplay = label.text;
        if(label.attachedData != nil){
            valueToSubmit = label.attachedData;
        }
        
        
        // valueToSubmit = label.attachedData;
        
    } else if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_TIME_FIELD]){
        
        MXTextField *textField = (MXTextField *)[self getDataFromId:id];
        valueToSubmit = valueToDisplay = textField.attachedData;
        
    } else if ([componentType isEqualToString : XmwcsConst_DE_COMPONENT_RADIO_GROUP]){
    }
    
    
    if(valueToSubmit!=nil) {
        [valueOfComponent addObject: valueToSubmit];
        [valueOfComponent addObject: valueToDisplay];
    }
    return valueOfComponent;
}


-(void) setFormData:(NSDictionary*) formData
{
    DVTableFormView* rowForm  = (DVTableFormView*)self.rowFormInSameForm;
    
    NSArray* addRowDotFormElementArray = self.dotForm.addRowFormElements;
    NSArray* nonAddRowDotFormElementArray = self.dotForm.nonAddRowFormElements;

    for(int cntElement = 0; cntElement < [nonAddRowDotFormElementArray count] ; cntElement++)
    {
        DotFormElement* dotFormElement = (DotFormElement *)[nonAddRowDotFormElementArray objectAtIndex:cntElement];
        
        if([formData objectForKey:dotFormElement.elementId]!=nil) {
            if([dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_TEXTFIELD]) {
                MXTextField* mxTextField = (MXTextField*)[self getDataFromId:dotFormElement.elementId];
                NSArray* itemsArray = [formData objectForKey:dotFormElement.elementId];
                mxTextField.text = [itemsArray objectAtIndex:0];
            } else if([dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_CHECKBOX]) {
                MXButton* mxbutton = (MXButton*) [self getDataFromId:dotFormElement.elementId];
                NSArray* itemsArray = [formData objectForKey:dotFormElement.elementId];
                
                if([[itemsArray objectAtIndex:0] isEqualToString:@"True"]) {
                    [mxbutton.parent setChecked];
                } else {
                    [mxbutton.parent setUnchecked];
                }
            } else if([dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_DROPDOWN]) {  // DROPDOWN
                MXTextField* mxTextField = (MXTextField*)[self getDataFromId:dotFormElement.elementId];

                NSArray* itemsArray = [formData objectForKey:dotFormElement.elementId];
                mxTextField.text = [itemsArray objectAtIndex:1];
                mxTextField.keyvalue = [itemsArray objectAtIndex:0];
            } else if([dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_DATE_FIELD]) {   // DATE_FIELD
                MXTextField* mxTextField = (MXTextField*)[self getDataFromId:dotFormElement.elementId];
                NSArray* itemsArray = [formData objectForKey:dotFormElement.elementId];
                mxTextField.text = [itemsArray objectAtIndex:0];
            } else if([dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_TEXTAREA]) {  // TEXTAREA
                MXTextField* mxTextField = (MXTextField*)[self getDataFromId:dotFormElement.elementId];
                NSArray* itemsArray = [formData objectForKey:dotFormElement.elementId];
                mxTextField.text = [itemsArray objectAtIndex:0];
            } else if([dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_CHECKBOX_GROUP]) {
                // for checkbox group
                NSDictionary* cbGroupData = [formData objectForKey: dotFormElement.elementId];
                if(cbGroupData!=nil) {
                    CheckBoxGroup* checkBoxGroup = (CheckBoxGroup*)[self getDataFromId:dotFormElement.elementId];
                    for(int i=0; i<[checkBoxGroup.checkBoxItems count]; i++) {
                        CheckBoxGroupItem* cbGroupItem = (CheckBoxGroupItem*)[checkBoxGroup.checkBoxItems objectAtIndex:i];
                        NSDictionary* checkNodeObj = [cbGroupData objectForKey:cbGroupItem.checkBoxGroupButton.elementId];
                        NSString* checkValue = [checkNodeObj objectForKey:@"checked"];
                        if([checkValue isEqualToString:@"True"]) {
                            [cbGroupItem setChecked];
                        } else {
                            [cbGroupItem setUnChecked];
                        }
                    }
                }
            } else if([dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_LABEL]) {
                MXLabel* mxLabel = (MXLabel*)[self getDataFromId:dotFormElement.elementId];
                // here we should have code for the dropdown value
                NSArray* itemsArray = [formData objectForKey:dotFormElement.elementId];
                mxLabel.text = [itemsArray objectAtIndex:1];
                mxLabel.attachedData = [itemsArray objectAtIndex:0];
            }
        }
    }
    
    
    
    
    // now we need to add table row data
    NSString* numOfRows = [formData objectForKey:@"row_count"];
    int maxRows = 0;
    if(numOfRows!=nil) {
        maxRows = [numOfRows intValue];
    }

    
    for(int i=1; i<=maxRows;i++) {
        NSDictionary* rowDataDict = [formData objectForKey:[NSString stringWithFormat:@"row_%d", i]];
        
        if(rowDataDict!=nil) {

            NSMutableArray* rowDataArray = [[NSMutableArray alloc] init];
            
            DotFormElement* dotFormElement = (DotFormElement*)[addRowDotFormElementArray objectAtIndex:0];
            [rowDataArray addObject:[rowDataDict objectForKey:dotFormElement.elementId ]]; //  PRODUCT
            
            dotFormElement = (DotFormElement*)[addRowDotFormElementArray objectAtIndex:1];
            [rowDataArray addObject:[rowDataDict objectForKey:dotFormElement.elementId]]; //  QUANT
            
            dotFormElement = (DotFormElement*)[addRowDotFormElementArray objectAtIndex:2];
            [rowDataArray addObject:[rowDataDict objectForKey:dotFormElement.elementId]]; //  MTNR_DESC
            
            dotFormElement = (DotFormElement*)[addRowDotFormElementArray objectAtIndex:3];
            [rowDataArray addObject:[rowDataDict objectForKey:dotFormElement.elementId]]; //  UNIT
            
            
            // we need to insert data on the new rows after rowId
            int rowId = i-1;
            
            [rowForm insertRowAfterRow:rowId withData:nil header:nil];
            
            UIView* searchCell = [rowForm getRowCellWithRowId:(rowId+1) colId:0];
            MXLabel* labelField = (MXLabel*)[[searchCell subviews] objectAtIndex:0];
            labelField.text = [rowDataArray objectAtIndex:0];
            
            
            UIView* quantCell = [rowForm getRowCellWithRowId:(rowId+1) colId:1];
            MXTextField* textField = (MXTextField*)[[quantCell subviews] objectAtIndex:0];
            textField.text = [rowDataArray objectAtIndex:1];
            

            textField.keyboardType = UIKeyboardTypeDecimalPad;
        
            UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        
            numberToolbar.items = [NSArray arrayWithObjects:
                               [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad:)],
                               [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                               [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad:)],
                               nil];
        
            textField.inputAccessoryView = numberToolbar;
            

            
            UIView* descCell = [rowForm getRowCellWithRowId:(rowId+1) colId:2];
            MXLabel* descLabel = (MXLabel*)[[descCell subviews] objectAtIndex:0];
            descLabel.text = [rowDataArray objectAtIndex:2];
            descLabel.font = [UIFont systemFontOfSize:11];
            descLabel.numberOfLines = 0;
            
            UIView* unitCell = [rowForm getRowCellWithRowId:(rowId+1) colId:3];
            MXLabel* unitLabel = (MXLabel*)[[unitCell subviews] objectAtIndex:0];
            unitLabel.font = [UIFont systemFontOfSize:11];
            unitLabel.text = [rowDataArray objectAtIndex:3];
            
        }

    }
}

@end
