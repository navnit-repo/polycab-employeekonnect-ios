//
//  XMWTableFormDelegate.m
//  QCMSProject
//
//  Created by Pradeep Singh on 4/11/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//
//  Class name has been changed
//
#import <objc/runtime.h>
#import "XMWTableFormDelegate.h"
#import "XmwcsConstant.h"
#import "MXTextField.h"
#import "MXBarButton.h"
#import "MXButton.h"
#import "Styles.h"
#import "SearchRequestStorage.h"
#import "DVAppDelegate.h"
#import "DotDropDownPicker.h"
#import "DotSearchComponent.h"
#import "DotForm.h"
#import "DotFormPostUtil.h"
#import "ProductSearchVC.h"
#import "DotFormDraw.h"
#import "ClientVariable.h"
#import "SearchProductBYNameVC.h"
#import "SearchProductByCatalogVC.h"

@interface MXLabel (DVTableFormView)
@property NSNumber* tvfRowIndex;
@property NSNumber* tvfColIndex;
@end

@implementation MXLabel (DVTableFormView)

- (NSNumber*)tvfRowIndex;
{
    return objc_getAssociatedObject(self, "tvfRowIndex");
}

- (void)setTvfRowIndex:(NSNumber*)property;
{
    objc_setAssociatedObject(self, "tvfRowIndex", property, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber*)tvfColIndex;
{
    return objc_getAssociatedObject(self, "tvfColIndex");
}

- (void)setTvfColIndex:(NSNumber*)property;
{
    objc_setAssociatedObject(self, "tvfColIndex", property, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


@interface MXTextField (DVTableFormView)
@property NSNumber* tvfRowIndex;
@property NSNumber* tvfColIndex;
@end

@implementation MXTextField (DVTableFormView)

- (NSNumber*)tvfRowIndex;
{
    return objc_getAssociatedObject(self, "tvfRowIndex");
}

- (void)setTvfRowIndex:(NSNumber*)property;
{
    objc_setAssociatedObject(self, "tvfRowIndex", property, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber*)tvfColIndex;
{
    return objc_getAssociatedObject(self, "tvfColIndex");
}

- (void)setTvfColIndex:(NSNumber*)property;
{
    objc_setAssociatedObject(self, "tvfColIndex", property, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end

@interface MXButton (DVTableFormView)
@property NSNumber* tvfRowIndex;
@property NSNumber* tvfColIndex;
@end

@implementation MXButton (DVTableFormView)

- (NSNumber*)tvfRowIndex;
{
    return objc_getAssociatedObject(self, "tvfRowIndex");
}

- (void)setTvfRowIndex:(NSNumber*)property;
{
    objc_setAssociatedObject(self, "tvfRowIndex", property, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber*)tvfColIndex;
{
    return objc_getAssociatedObject(self, "tvfColIndex");
}

- (void)setTvfColIndex:(NSNumber*)property;
{
    objc_setAssociatedObject(self, "tvfColIndex", property, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end


@interface MXBarButton (DVTableFormView)
@property NSNumber* tvfRowIndex;
@property NSNumber* tvfColIndex;
@end

@implementation MXBarButton (DVTableFormView)

- (NSNumber*)tvfRowIndex;
{
    return objc_getAssociatedObject(self, "tvfRowIndex");
}

- (void)setTvfRowIndex:(NSNumber*)property;
{
    objc_setAssociatedObject(self, "tvfRowIndex", property, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber*)tvfColIndex;
{
    return objc_getAssociatedObject(self, "tvfColIndex");
}

- (void)setTvfColIndex:(NSNumber*)property;
{
    objc_setAssociatedObject(self, "tvfColIndex", property, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end


@interface XMWTableFormDelegate ()
{
    UIView* pickerContainer;
    DotDropDownPicker* dotDropDownPicker;
    UIToolbar* pickerDoneButtonView;
    DVTableFormView* _ctxTableFormView;
    NSString* _currentCtx;
    
    NSMutableDictionary* componentsMap;
    NSMutableDictionary* formElementsDic;
    NSMutableArray* formElementsArray;
    NSMutableDictionary* formElementColumnDelegateDic;
}

@end



@implementation XMWTableFormDelegate

@synthesize formViewController;

-(id) init
{
    self = [super init];
    if(self!=nil) {
        componentsMap = [[NSMutableDictionary alloc] init];
        formElementsDic = [[NSMutableDictionary alloc] init];
        formElementsArray = [[NSMutableArray alloc] init];
        formElementColumnDelegateDic = [[NSMutableDictionary alloc] init];
        
        
        //my code
    
        [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(polycabButtonHandler:) name:@"setButtonHandler" object:nil];
        
    }
    return self;
}


-(DVTableFormView*) ctxTableFormView
{
    return _ctxTableFormView;
}

-(NSString*) currentCtx
{
    return _currentCtx;
}

#pragma - mark DefaultRowDelegate

-(void) addColumn:(NSString*) columnName formElement:(DotFormElement*)element delegate:(id<DVTableFormColumnDelegate>) columnDelegate
{
    [formElementsDic setObject:element forKey:columnName];
    [formElementsArray addObject:element];
    if(columnDelegate==nil){
        columnDelegate = self;
    }
    [formElementColumnDelegateDic setObject:columnDelegate forKey:element.elementId];
}


-(id<DVTableFormColumnDelegate>) columnDelegateForColumn:(NSString*) columnName
{
    DotFormElement* element = [formElementsDic objectForKey:columnName];
    return [formElementColumnDelegateDic  objectForKey:element.elementId];
}


-(id<DVTableFormColumnDelegate>) columnDelegateForColumnIndex:(int) colIdx
{
    DotFormElement* element = [formElementsArray objectAtIndex:colIdx ];
    return [formElementColumnDelegateDic  objectForKey:element.elementId];
}

-(DotFormElement*) formElementForColumnIndex:(int) colIdx
{
    return [formElementsArray objectAtIndex:colIdx ];
}

-(DotFormElement*) formElementForColumn:(NSString*) columnName
{
    return [formElementsDic objectForKey:columnName];
}

/*
 -(NSString*) heading
 {
 return formElement.displayText;
 }
 
 -(NSString*) columnType
 {
 return formElement.componentType;
 }
 */




-(void) columnHeadingRenderer:(DVTableFormView*) tfv column:(int) colIdx cell:(UIView*) view
{
    _ctxTableFormView = tfv;
    DotFormElement* formElement = [formElementsArray objectAtIndex:colIdx];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, view.frame.size.width - 4, view.frame.size.height)];
    label.text = formElement.displayText;
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];
}

-(void) columnCellRenderer:(DVTableFormView*) tfv  row:(int) rowIdx column:(int) colIdx cell:(UIView*) view
{
    _ctxTableFormView = tfv;
    DotFormElement* formElement = [formElementsArray objectAtIndex:colIdx];
    NSString* componentType = formElement.componentType;
    if([componentType isEqualToString:XmwcsConst_DE_COMPONENT_TEXTFIELD])
    {
        [self drawTextField:view :rowIdx :colIdx];
    } else if([componentType isEqualToString:XmwcsConst_DE_COMPONENT_SEARCH_FIELD])
    {
        [self drawSearchLabelField:view :rowIdx :colIdx];
        // [self drawSearchField:view :rowIdx :colIdx];
    } else if([componentType isEqualToString:XmwcsConst_DE_COMPONENT_LABEL])
    {
        [self drawLabelField:view :rowIdx :colIdx];
    } else if([componentType isEqualToString:XmwcsConst_DE_COMPONENT_DATE_FIELD])
    {
        [self drawDateField:view :rowIdx :colIdx];
    } else if([componentType isEqualToString:XmwcsConst_DE_COMPONENT_DROPDOWN])
    {
        [self drawDropdownField:view :rowIdx :colIdx];
    }
    
}

-(void) columnCellToBeRemoved:(DVTableFormView*) tfv  row:(int) rowIdx column:(int) colIdx  cell:(UIView*) view
{
    
    _ctxTableFormView = tfv;
    DotFormElement* formElement = [formElementsArray objectAtIndex:colIdx];
    NSString* componentType = formElement.componentType;
    
    
    if([componentType isEqualToString:XmwcsConst_DE_COMPONENT_TEXTFIELD])
    {
        [self removeTextField:view :rowIdx :colIdx];
    } else if([componentType isEqualToString:XmwcsConst_DE_COMPONENT_SEARCH_FIELD])
    {
        [self removeSearchLabelField:view :rowIdx :colIdx];
        // [self drawSearchField:view :rowIdx :colIdx];
    } else if([componentType isEqualToString:XmwcsConst_DE_COMPONENT_LABEL])
    {
        [self removeLabelField:view :rowIdx :colIdx];
    } else if([componentType isEqualToString:XmwcsConst_DE_COMPONENT_DATE_FIELD])
    {
        [self removeDateField:view :rowIdx :colIdx];
    } else if([componentType isEqualToString:XmwcsConst_DE_COMPONENT_DROPDOWN])
    {
        [self removeDropdownField:view :rowIdx :colIdx];
    }
    
}

-(CGFloat) columnOffsetForColumn:(int) colIdx
{
    float preferedColumnWidth = 70.0f;
    if(self.maxColumns>0 && self.maxColumns<4) {
        preferedColumnWidth = 280.0f/self.maxColumns;
    }
    
    return colIdx*preferedColumnWidth;
}

-(void) updateRowNumber:(UIView*) rowContainer oldNumber:(int) oldRowId action:(int) minusOrPlus
{
    // Do any update
    
    UIView* firstSearchColumnCell = [[rowContainer subviews] objectAtIndex:0];
    MXLabel* productClickableLabel = (MXLabel*)[[firstSearchColumnCell subviews] objectAtIndex:0];
    if( productClickableLabel.tvfRowIndex.intValue == oldRowId ) {
        if(minusOrPlus<0) {
            productClickableLabel.tvfRowIndex = [[NSNumber alloc ] initWithInt:(productClickableLabel.tvfRowIndex.intValue - 1)];
        } else if (minusOrPlus>0){
            productClickableLabel.tvfRowIndex = [[NSNumber alloc ] initWithInt:(productClickableLabel.tvfRowIndex.intValue + 1)];
        }
    }
}

-(NSArray*) rowDataForSubmit:(UIView*) rowContainer forRow:(int) rowIdx
{
    NSLog(@"rowDataForSubmit rowIdx = %d", rowIdx);
    
    NSMutableArray* rowData = [[NSMutableArray alloc] init];
    
    for(int i=0; i< [formElementsArray count]; i++) {
        DotFormElement* dotFormElement = [formElementsArray objectAtIndex:i];
        
         NSLog(@"rowDataForSubmit dotFormElement id = %@", dotFormElement.elementId);
        
        if([dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_TEXTFIELD]) {
            MXTextField* cellTextField = [componentsMap objectForKey:[NSString stringWithFormat:@"%d:%d", rowIdx, i]];
            [rowData addObject: [cellTextField.text copy]];
        }  else if([dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_LABEL]) {
            MXLabel* cellLabelField = [componentsMap objectForKey:[NSString stringWithFormat:@"%d:%d", rowIdx, i]];
            [rowData addObject: [cellLabelField.text copy]];
        } else if([dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_DATE_FIELD]) {
            MXLabel* labelField = [componentsMap objectForKey:[NSString stringWithFormat:@"%d:%d", rowIdx, i]];
            [rowData addObject: [labelField.text copy]];
        } else if([dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_DROPDOWN]) {
            NSMutableArray* fields = [componentsMap objectForKey:[NSString stringWithFormat:@"%d:%d", rowIdx, i]];
            MXTextField *dropDownField = [fields objectAtIndex:0];
            [rowData addObject: [dropDownField.keyvalue copy]];
        } else if([dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_SEARCH_FIELD]) {
            MXLabel* labelField = [componentsMap objectForKey:[NSString stringWithFormat:@"%d:%d", rowIdx, i]];
            [rowData addObject: [labelField.text copy]];
        } else if([dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_CHECKBOX]) {
            CheckBoxButton *checkBoxButton = [componentsMap objectForKey:[NSString stringWithFormat:@"%d:%d", rowIdx, i]];
            if(checkBoxButton.isChecked)
            {
                [rowData addObject: @"True"];
            } else {
                [rowData addObject: @"False"];
            }
        } else if([dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_TEXTAREA]) {
            MXTextField *textField = [componentsMap objectForKey:[NSString stringWithFormat:@"%d:%d", rowIdx, i]];
            [rowData addObject: [textField.keyvalue copy]];
        } else if([dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_MULTI_SELECT]) {
            // typically not used here
            [componentsMap objectForKey:[NSString stringWithFormat:@"%d:%d", rowIdx, i]];
            [rowData addObject: @"Not Implemented"];
        } else if([dotFormElement.componentType isEqualToString:XmwcsConst_DE_COMPONENT_MULTI_SELECT_SEARCH]) {
            // typically not used here in the tabular data
            [componentsMap objectForKey:[NSString stringWithFormat:@"%d:%d", rowIdx, i]];
            [rowData addObject: @"Not Implemented"];
        }
    }
    
    return rowData;
}


-(void) drawTextField:(UIView*) view :(int) rowIdx :(int) colIdx
{
    DotFormElement* formElement = [formElementsArray objectAtIndex:colIdx];
    
    MXTextField* cellTextField = [[MXTextField alloc] initWithFrame:CGRectMake(2, 2, view.frame.size.width-4 , view.frame.size.height-4)];
    cellTextField.borderStyle = UITextBorderStyleRoundedRect;
    cellTextField.returnKeyType = UIReturnKeyDefault;
    cellTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    cellTextField.adjustsFontSizeToFitWidth = TRUE;
    cellTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    cellTextField.minimumFontSize = 10;
    cellTextField.clearButtonMode = UITextFieldViewModeNever;
    cellTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    cellTextField.font = [UIFont systemFontOfSize:12.0];
    [cellTextField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    cellTextField.adjustsFontSizeToFitWidth = YES;
    cellTextField.keyboardType = UIKeyboardTypeDefault;
    cellTextField.delegate	= formViewController;
    
    cellTextField.tvfColIndex = [[NSNumber alloc] initWithInt:colIdx];
    cellTextField.tvfRowIndex = [[NSNumber alloc] initWithInt:rowIdx];
    
    if([formElement.dataType isEqualToString:XmwcsConst_DE_TEXTFIELD_DATA_TYPE_NUMERIC]) {
        cellTextField.keyboardType = UIKeyboardTypeNumberPad;
    } else if([formElement.dataType isEqualToString:XmwcsConst_DE_TEXTFIELD_DATA_TYPE_AMOUNT]) {
        cellTextField.keyboardType = UIKeyboardTypeDecimalPad;
    } else if([formElement.dataType isEqualToString:XmwcsConst_DE_TEXTFIELD_DATA_TYPE_FLOAT]) {
        cellTextField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:formViewController action:@selector(cancelNumberPad:)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:formViewController action:@selector(doneWithNumberPad:)],
                           nil];
    
    cellTextField.inputAccessoryView = numberToolbar;
    
    cellTextField.text = formElement.optional;
    
    cellTextField.elementId = formElement.elementId;
    [view addSubview:cellTextField];
    
    [componentsMap setObject:cellTextField forKey:[NSString stringWithFormat:@"%d:%d", rowIdx, colIdx]];
    
}



-(void) removeTextField:(UIView*) cellView :(int) rowIdx :(int) colIdx
{
    for(UIView* view in [cellView subviews]) {
        [view removeFromSuperview];
    }
}




//
// this is another implementation but no picker opens
// it opens search form directly
//
-(void) drawSearchLabelField:(UIView*) view :(int) rowIdx :(int) colIdx
{
    DotFormElement* formElement = [formElementsArray objectAtIndex:colIdx];
    
    MXLabel* labelField = [[MXLabel alloc] initWithFrame:CGRectMake( 1.0f, 1.0f, view.frame.size.width-2, view.frame.size.height-2)];
    labelField.text = formElement.displayText;
    labelField.numberOfLines = 0;
    labelField.font = [UIFont systemFontOfSize:11];
    labelField.userInteractionEnabled = YES;
    labelField.textColor = [UIColor whiteColor];
    
    
    labelField.elementId = formElement.elementId;
    
    
    labelField.tvfColIndex = [[NSNumber alloc] initWithInt:colIdx];
    labelField.tvfRowIndex = [[NSNumber alloc] initWithInt:rowIdx];
    
    labelField.backgroundColor = [UIColor redColor];
    
    
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapHandling:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    [labelField addGestureRecognizer:tapGestureRecognizer];
    
    [view addSubview:labelField];
    
    [componentsMap setObject:labelField forKey:[NSString stringWithFormat:@"%d:%d", rowIdx, colIdx]];
}

-(void) removeSearchLabelField:(UIView*) cellView :(int) rowIdx :(int) colIdx
{
    for(UIView* view in [cellView subviews]) {
        [view removeFromSuperview];
    }
}


-(void)polycabButtonHandler:(NSNotification*)notification {
    
    
    NSString *buttonTag = [NSString stringWithFormat:@"%@",[notification.userInfo valueForKey:@"ButtonTag"]];
    NSLog(@"%@",buttonTag);
    
    NSString *item = [NSString stringWithFormat:@"%@",[notification.userInfo valueForKey:@"BUSINESS_VERTICAL"]];
    NSLog(@"%@",item);
    DotFormElement *searchFormComponent = [formElementsArray objectAtIndex:0];
    NSString *groupName                    = searchFormComponent.dependedCompName;
    NSString *masterValueMapping        = searchFormComponent.masterValueMapping;
    NSString *elementId                  = searchFormComponent.elementId;
    
    NSString *itemName =[NSString stringWithFormat:@"%@",[notification.userInfo valueForKey:@"itemName"]];

    DotFormElement* formElement = [formElementsArray objectAtIndex:0];

    DotSearchComponent *searchObject = [[DotSearchComponent alloc]init];
    NSMutableArray *searchValues = [searchObject getRadioGroupData: groupName];
//for Search Product
    if ([buttonTag isEqualToString:@"101"]) {
        
        SearchProductBYNameVC *searchProductBYNameVC = [[SearchProductBYNameVC alloc]initWithNibName:@"SearchProductBYNameVC" bundle:nil parentForm:formViewController formElement:elementId elementData:masterValueMapping radioGroupData:searchValues :buttonTag :itemName];
        
        NSMutableDictionary* dependentValueMap = nil;
        if(formElement.dependedCompValue !=nil   && ![formElement.dependedCompValue isEqualToString:@""]){
            NSString* dependentElement = formElement.dependedCompValue;
            dependentValueMap = [ self getDependentDataValue: dependentElement : formViewController.dotForm];
        }
        searchProductBYNameVC.dependentValueMap = dependentValueMap;
        searchProductBYNameVC.productDivision = [dependentValueMap objectForKey:formElement.dependedCompValue]; // using hard coding here as productSearch is specially for products
        searchProductBYNameVC.multiSelect = YES;
        searchProductBYNameVC.multiSelectDelegate = formViewController;
        
        [formViewController.navigationController pushViewController:searchProductBYNameVC animated:YES];
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    // for add to catalog
    else if ([buttonTag isEqualToString:@"100"]){
        SearchProductByCatalogVC * searchProductByCatalogVC = [[SearchProductByCatalogVC alloc]initWithNibName:@"SearchProductByCatalogVC" bundle:nil parentForm:formViewController formElement:elementId elementData:masterValueMapping radioGroupData:searchValues :buttonTag];
        
        
        
            
        
        
        NSMutableDictionary* dependentValueMap = nil;
        if(formElement.dependedCompValue !=nil   && ![formElement.dependedCompValue isEqualToString:@""]){
            NSString* dependentElement = formElement.dependedCompValue;
            dependentValueMap = [ self getDependentDataValue: dependentElement : formViewController.dotForm];
        }
        searchProductByCatalogVC.dependentValueMap = dependentValueMap;
        searchProductByCatalogVC.productDivision = [dependentValueMap objectForKey:formElement.dependedCompValue]; // using hard coding here as productSearch is specially for products
        searchProductByCatalogVC.itmeName = item;
        searchProductByCatalogVC.multiSelect = YES;
        searchProductByCatalogVC.multiSelectDelegate = formViewController;
        
        [formViewController.navigationController pushViewController:searchProductByCatalogVC animated:YES];
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
        
    }
   


}

-(IBAction)labelTapHandling:(UITapGestureRecognizer*)sender
{
   MXLabel* labelField = (MXLabel*)sender.view;
    
    _currentCtx =  [NSString stringWithFormat:@"%d:%d", labelField.tvfRowIndex.intValue, labelField.tvfColIndex.intValue];
    
    DotFormElement *searchFormComponent = [formElementsArray objectAtIndex:labelField.tvfColIndex.intValue];
    
    NSString *groupName					= searchFormComponent.dependedCompName;
    NSString *masterValueMapping        = searchFormComponent.masterValueMapping;
    NSString *elementId                  = searchFormComponent.elementId;
    
    
    DotFormElement* formElement = [formElementsArray objectAtIndex:labelField.tvfColIndex.intValue];
    
    DotSearchComponent *searchObject = [[DotSearchComponent alloc]init];
    NSMutableArray *searchValues = [searchObject getRadioGroupData: groupName];
    
    
    /*
     
     // for Default Search Popup
     
     CGRect textFrame = CGRectMake(0,0,320,320);//(20, 90, 280, 300) ;
     SearchFormControl* searchPopUp = [[SearchFormControl alloc]initWithFrame:textFrame : searchValues : 0 : formViewController : masterValueMapping : elementId : searchFormComponent.displayText];
     
     
     NSMutableDictionary* dependentValueMap = nil;
     if(formElement.dependedCompValue !=nil   && ![formElement.dependedCompValue isEqualToString:@""]){
     NSString* dependentElement = formElement.dependedCompValue;
     dependentValueMap = [ self getDependentDataValue: dependentElement : formViewController.dotForm];
     }
     
     searchPopUp.dependentValueMap = dependentValueMap;
     searchPopUp.multiSelect = YES;
     searchPopUp.multiSelectDelegate = self;
     
     [formViewController.view  addSubview : searchPopUp];
     
     */
    
    
    //
    // for using new ProductSearchVC with product catalog browsing
    //
    ProductSearchVC* productSearchVC = [[ProductSearchVC alloc] initWithNibName:@"ProductSearchVC" bundle:nil parentForm:formViewController formElement:elementId elementData:masterValueMapping radioGroupData:searchValues];
    
    

    
    
    NSMutableDictionary* dependentValueMap = nil;
    if(formElement.dependedCompValue !=nil   && ![formElement.dependedCompValue isEqualToString:@""]){
        NSString* dependentElement = formElement.dependedCompValue;
        dependentValueMap = [ self getDependentDataValue: dependentElement : formViewController.dotForm];
    }
    productSearchVC.dependentValueMap = dependentValueMap;
    productSearchVC.productDivision = [dependentValueMap objectForKey:formElement.dependedCompValue]; // using hard coding here as productSearch is specially for products
    productSearchVC.multiSelect = YES;
    productSearchVC.multiSelectDelegate = self;
    
    [formViewController.navigationController pushViewController:productSearchVC animated:YES];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
   
    
}


#pragma mark - LABEL related functions

-(void) drawLabelField:(UIView*) view :(int) rowIdx :(int) colIdx
{

    DotFormElement* formElement = [formElementsArray objectAtIndex:colIdx];
    
    MXLabel* labelField = [[MXLabel alloc] initWithFrame:CGRectMake( 1.0f, 1.0f, view.frame.size.width-2, view.frame.size.height-2)];
    labelField.text = formElement.displayText;
    labelField.numberOfLines = 0;
    labelField.font = [UIFont systemFontOfSize:11];
    labelField.userInteractionEnabled = YES;
    labelField.textColor = [UIColor blackColor];
    
    
    labelField.elementId = formElement.elementId;
    
    
    labelField.tvfColIndex = [[NSNumber alloc] initWithInt:colIdx];
    labelField.tvfRowIndex = [[NSNumber alloc] initWithInt:rowIdx];
    
    labelField.backgroundColor = [UIColor clearColor];
    
    [view addSubview:labelField];
    
    [componentsMap setObject:labelField forKey:[NSString stringWithFormat:@"%d:%d", rowIdx, colIdx]];
    
    
}


-(void) removeLabelField:(UIView*) cellView :(int) rowIdx :(int) colIdx
{
    for(UIView* view in [cellView subviews]) {
        [view removeFromSuperview];
    }
}


#pragma mark - DateField related functions

-(void) drawDateField:(UIView*) view :(int) rowIdx :(int) colIdx
{
    DotFormElement* formElement = [formElementsArray objectAtIndex:colIdx];
    
    
    MXLabel* labelField = [[MXLabel alloc] initWithFrame:CGRectMake( 1.0f, 1.0f, view.frame.size.width-2, view.frame.size.height-2)];
    labelField.text = formElement.displayText;
    labelField.numberOfLines = 0;
    labelField.font = [UIFont systemFontOfSize:11];
    labelField.userInteractionEnabled = YES;
    labelField.textColor = [UIColor blackColor];
    
    
    labelField.elementId = formElement.elementId;
    
    
    labelField.tvfColIndex = [[NSNumber alloc] initWithInt:colIdx];
    labelField.tvfRowIndex = [[NSNumber alloc] initWithInt:rowIdx];
    
    // labelField.backgroundColor = [UIColor redColor];
    
    
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateTapHandling:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    [labelField addGestureRecognizer:tapGestureRecognizer];
    
    [view addSubview:labelField];
    
    [componentsMap setObject:labelField forKey:[NSString stringWithFormat:@"%d:%d", rowIdx, colIdx]];
    
    
}


-(void) removeDateField:(UIView*) cellView :(int) rowIdx :(int) colIdx
{
    for(UIView* view in [cellView subviews]) {
        [view removeFromSuperview];
    }
}



-(IBAction)dateTapHandling:(UITapGestureRecognizer*)sender
{
    MXLabel* labelField = (MXLabel*)sender.view;
    
    _currentCtx =  [NSString stringWithFormat:@"%d:%d", labelField.tvfRowIndex.intValue, labelField.tvfColIndex.intValue];
    
    DotFormElement *dotFormElement = [formElementsArray objectAtIndex:labelField.tvfColIndex.intValue];
    
    
    NSDate* defCal = nil;
    NSDate* minCal = nil;
    NSDate* maxCal = nil;
    
    // default date
    defCal = [self defaultDate:dotFormElement];
    
    //for minimum date condition
    minCal = [self dateLowerBound:dotFormElement];
    
    //for Maximum date condition
    maxCal = [self dateUpperBound:dotFormElement];
    
    DVCalendarController* pmCC = [[DVCalendarController alloc] initWithNibName:@"DVCalendarController" bundle:nil];
    pmCC.lowerDate = minCal;
    pmCC.upperDate = maxCal;
    pmCC.displayDate = defCal;
    pmCC.calendarDelegate = self;
    pmCC.contextId = _currentCtx;
    
    [[formViewController navigationController] pushViewController:pmCC  animated:YES];
    
    
}

-(NSDate*) defaultDate:(DotFormElement*) dotFormElement
{
    
    NSDate* defCal = [[NSDate alloc] init];
    
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
            if([dateArr count]>2) {
                
                if(![[dateArr objectAtIndex:1] isEqualToString:@"0"]) {
                    dateComp.day =  1;
                } else {
                    dateComp.day = dateComp.day + [[dateArr objectAtIndex:0] integerValue];
                }
            }
        }
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSGregorianCalendar];
        defCal = [gregorian dateFromComponents:dateComp];
    }
    
    return defCal;
    
}


-(NSDate*) dateLowerBound:(DotFormElement*) dotFormElement
{
    NSDate* minCal = [[NSDate alloc] init];
    
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
    
    return minCal;
    
}


-(NSDate*) dateUpperBound:(DotFormElement*) dotFormElement
{
    NSDate* maxCal = [[NSDate alloc] init];
    
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
    return maxCal;
}


-(void) dateSelected:(DVDateStruct*) dateStruct :(NSString*) contextId
{
    if(dateStruct !=nil) {
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        // [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* date = [dateStruct convertToNSDate];
        
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        
        NSString *mySelectedDate = [dateFormatter stringFromDate:date];
        
        
        NSArray* parts = [_currentCtx componentsSeparatedByString:@":"];
        if([parts count]==2) {
            NSString* rowIdxStr = [parts objectAtIndex:0];
            NSString* colIdxStr = [parts objectAtIndex:1];
            
            int rowId = rowIdxStr.intValue;
            int colId = colIdxStr.intValue;
            
            DotFormElement *searchFormComponent = [formElementsArray objectAtIndex:colId];
            
            MXLabel* labelField  = (MXLabel*)[componentsMap objectForKey:contextId];
            NSLog(@"checkdate : %@",mySelectedDate);
            labelField.text = mySelectedDate;
        }
    }
    
}

-(void) userCancelled:(NSString*) contextId
{
    
    
}



#pragma mark - Dropdown functions

-(void) drawDropdownField:(UIView*) view :(int) rowIdx :(int) colIdx
{
    DotFormElement* formElement = [formElementsArray objectAtIndex:colIdx];
    
    NSString *currentCompName = formElement.elementId;
    
    // Check for Drop Down Constraints
    //  NSMutableDictionary*  cellDropDwnDictionary = [self getDropDownList: dotFormElement];

    id masterValues = [DotFormDraw getMasterValueForComponent:[formElement elementId] : [formElement masterValueMapping]];
    // NSMutableDictionary *masterkey = masterValues[0];
    
    if(masterValues != nil) {
        NSMutableDictionary*  cellDropDownDictionary = masterValues[1];
        
        
        UIImage *dropImage = [UIImage imageNamed:@"Icon-Drop.png"];
        
        MXButton* dropDownButton = [MXButton buttonWithType:UIButtonTypeCustom];
        [dropDownButton setFrame:CGRectMake( 0.0f, 0.0f, view.frame.size.height-8, view.frame.size.height-8)];
        [dropDownButton setImage:dropImage forState:UIControlStateNormal];
        
        dropDownButton.tvfColIndex = [[NSNumber alloc] initWithInt:colIdx];
        dropDownButton.tvfRowIndex = [[NSNumber alloc] initWithInt:rowIdx];
        
        MXTextField* dropDownField = [[MXTextField alloc] initWithFrame:CGRectMake(2, 2, view.frame.size.width-4 , view.frame.size.height-4)];
        dropDownField.borderStyle = UITextBorderStyleRoundedRect;
        dropDownField.returnKeyType = UIReturnKeyDefault;
        dropDownField.minimumFontSize = 10.0;
        dropDownField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        dropDownField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        dropDownField.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        dropDownField.adjustsFontSizeToFitWidth = TRUE;
        dropDownField.adjustsFontSizeToFitWidth = YES;
        dropDownField.tvfColIndex = [[NSNumber alloc] initWithInt:colIdx];
        dropDownField.tvfRowIndex = [[NSNumber alloc] initWithInt:rowIdx];
        
        [dropDownField setRightView:dropDownButton];
        [dropDownField setRightViewMode:UITextFieldViewModeAlways];
        [dropDownField setPlaceholder:@"Select..."];
        
        view.backgroundColor = [Styles formBackgroundColor];
        
        
        dropDownButton.attachedData = masterValues;
        dropDownField.tag = 101;
        
        
        [dropDownButton addTarget:self action:@selector(dropDownLaunch:) forControlEvents:UIControlEventTouchUpInside];
        
        dropDownButton.elementId	= formElement.elementId;
        
        [view addSubview:dropDownField];
        
        [componentsMap setObject:[[NSMutableArray alloc] initWithObjects:dropDownField, dropDownButton, nil] forKey:[NSString stringWithFormat:@"%d:%d", rowIdx, colIdx]];
    }
}


-(void) removeDropdownField:(UIView*) cellView :(int) rowIdx :(int) colIdx
{
    for(UIView* view in [cellView subviews]) {
        [view removeFromSuperview];
    }
}


-(IBAction)dropDownLaunch:(id)sender
{
    
    MXButton* button = (MXButton*) sender;
    
    pickerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, formViewController.view.bounds.size.width, formViewController.view.bounds.size.height)];
    pickerContainer.alpha = 1;
    
    
    dotDropDownPicker = [[DotDropDownPicker alloc]initWithFrame:CGRectMake(0.0, formViewController.view.bounds.size.height-200, 320, 200)];
    
    dotDropDownPicker.dropDownList = [[NSMutableArray alloc] initWithArray: ((MXButton*)sender).attachedData[1]];
    dotDropDownPicker.dropDownListKey = [[NSMutableArray alloc] initWithArray: ((MXButton*)sender).attachedData[0]];
    dotDropDownPicker.tag			= ((MXButton *)sender).tag;
    dotDropDownPicker.delegate		= dotDropDownPicker;
    dotDropDownPicker.dataSource	= dotDropDownPicker;
    [dotDropDownPicker setShowsSelectionIndicator:YES];
    dotDropDownPicker.backgroundColor = [UIColor whiteColor];
    
    pickerDoneButtonView = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, formViewController.view.bounds.size.height-240, 320, 40)];
    pickerDoneButtonView.barStyle = UIBarStyleBlackTranslucent;
    [pickerDoneButtonView sizeToFit];
    
    
    MXBarButton *doneButton = [[MXBarButton alloc] initWithTitle:@"Done"
                                                           style:UIBarButtonItemStyleBordered  target:self
                                                          action:@selector(doneDropdownPicker:)];
    
    MXBarButton *leftButton = [[MXBarButton alloc] initWithTitle:@"Cancel"
                                                           style:UIBarButtonItemStyleBordered  target:self
                                                          action:@selector(cancelBarButtonPressed:)];
    
    doneButton.elementId = [button elementId];
    doneButton.attachedData = [button attachedData];
    
    doneButton.tvfColIndex = button.tvfColIndex;
    doneButton.tvfRowIndex = button.tvfRowIndex;
    
    MXBarButton *BtnSpace = [[MXBarButton alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    [pickerDoneButtonView setItems:[NSArray arrayWithObjects:leftButton, BtnSpace, doneButton, nil]];
    
    [pickerContainer addSubview:pickerDoneButtonView];
    [pickerContainer addSubview:dotDropDownPicker];
    
    [formViewController.view addSubview:pickerContainer];
    
}


-(IBAction) doneDropdownPicker :(id) sender
{
    MXBarButton* button = (MXBarButton*) sender;
    
    _currentCtx =  [NSString stringWithFormat:@"%d:%d", button.tvfRowIndex.intValue, button.tvfColIndex.intValue];
    
    DotFormElement *searchFormComponent = [formElementsArray objectAtIndex:button.tvfColIndex.intValue];
    
    
    
    NSString* selectedTextFieldKey = nil;
    NSMutableDictionary* dropdownData = nil;
    
    if([sender isKindOfClass:MXBarButton.class])
    {
        selectedTextFieldKey = button.elementId;
        dropdownData = (NSMutableDictionary *)button.attachedData;
    }
    
    
    NSMutableArray* fields = [componentsMap objectForKey:[NSString stringWithFormat:@"%d:%d", button.tvfRowIndex.intValue, button.tvfColIndex.intValue ]];
    MXTextField *dropDownField = [fields objectAtIndex:0];
    
    dropDownField.keyvalue = dotDropDownPicker.selectedPickerKey;
    dropDownField.text = dotDropDownPicker.selectedPickerValue;
    
    
    
    [dotDropDownPicker removeFromSuperview];
    [pickerDoneButtonView removeFromSuperview];
    [pickerContainer removeFromSuperview];
}



#pragma mark - SearchField with dropdown

//
// this function implementation is same is search field in our normal form.
// opens a picker having none, search, and may be last other stuff. On clicking
// search it opens search form.
//
-(void) drawSearchField:(UIView*) view :(int) rowIdx :(int) colIdx
{
    NSMutableArray *arrayToValuePicker = [[NSMutableArray alloc] initWithCapacity:2];
    
    NSMutableArray *keyList = [[NSMutableArray alloc] init];
    NSMutableArray* optionList = [[NSMutableArray alloc] init];
    
    [keyList addObject:@"N"];
    [keyList addObject:@"S"];
    [arrayToValuePicker addObject:keyList];
    
    [optionList addObject:@"None"];
    [optionList addObject:@"Search"];
    [arrayToValuePicker addObject:optionList];
    
    //storage code start here
    DotFormElement* formElement = [formElementsArray objectAtIndex:colIdx];
    SearchRequestStorage* searchStorage =  [SearchRequestStorage getInstance];
    NSMutableArray* cacheItemList = [searchStorage getSearchRecords:[DVAppDelegate currentModuleContext] :formElement.masterValueMapping];
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
    
    
    UIImage *dropImage = [UIImage imageNamed:@"Icon-Drop.png"];
    
    MXButton* dropDownButton = [MXButton buttonWithType:UIButtonTypeCustom];
    [dropDownButton setFrame:CGRectMake( 0.0f, 0.0f, view.frame.size.height-8, view.frame.size.height-8)];
    [dropDownButton setImage:dropImage forState:UIControlStateNormal];
    
    dropDownButton.tvfColIndex = [[NSNumber alloc] initWithInt:colIdx];
    dropDownButton.tvfRowIndex = [[NSNumber alloc] initWithInt:rowIdx];
    
    MXTextField* dropDownField = [[MXTextField alloc] initWithFrame:CGRectMake(2, 2, view.frame.size.width-4 , view.frame.size.height-4)];
    dropDownField.borderStyle = UITextBorderStyleRoundedRect;
    dropDownField.returnKeyType = UIReturnKeyDefault;
    dropDownField.minimumFontSize = 10.0;
    dropDownField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    dropDownField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    dropDownField.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    dropDownField.adjustsFontSizeToFitWidth = TRUE;
    dropDownField.adjustsFontSizeToFitWidth = YES;
    dropDownField.tvfColIndex = [[NSNumber alloc] initWithInt:colIdx];
    dropDownField.tvfRowIndex = [[NSNumber alloc] initWithInt:rowIdx];
    
    [dropDownField setRightView:dropDownButton];
    [dropDownField setRightViewMode:UITextFieldViewModeAlways];
    [dropDownField setPlaceholder:@"Select a row.."];
    
    
    view.backgroundColor = [Styles formBackgroundColor];
    
    
    // dropDownField.delegate		= formController;
    dropDownButton.attachedData = masterValues;
    dropDownField.tag = 101;
    
    
    [dropDownButton addTarget:self action:@selector(dropDownSearchPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    dropDownButton.elementId	= formElement.elementId;
    
    [view addSubview:dropDownField];
    
    [componentsMap setObject:[[NSMutableArray alloc] initWithObjects:dropDownField, dropDownButton, nil] forKey:[NSString stringWithFormat:@"%d:%d", rowIdx, colIdx]];
    
}


-(void) removeSearchField:(UIView*) cellView :(int) rowIdx :(int) colIdx
{
    for(UIView* view in [cellView subviews]) {
        [view removeFromSuperview];
    }
}


-(IBAction) dropDownSearchPressed:(id) sender
{
    MXButton* button = (MXButton*) sender;
    
    pickerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, formViewController.view.bounds.size.width, formViewController.view.bounds.size.height)];
    pickerContainer.alpha = 1;
    
    
    dotDropDownPicker = [[DotDropDownPicker alloc]initWithFrame:CGRectMake(0.0, formViewController.view.bounds.size.height-200, 320, 200)];
    
    dotDropDownPicker.dropDownList = [[NSMutableArray alloc] initWithArray: ((MXButton*)sender).attachedData[1]];
    dotDropDownPicker.dropDownListKey = [[NSMutableArray alloc] initWithArray: ((MXButton*)sender).attachedData[0]];
    dotDropDownPicker.tag			= ((MXButton *)sender).tag;
    dotDropDownPicker.delegate		= dotDropDownPicker;
    dotDropDownPicker.dataSource	= dotDropDownPicker;
    [dotDropDownPicker setShowsSelectionIndicator:YES];
    dotDropDownPicker.backgroundColor = [UIColor whiteColor];
    
    pickerDoneButtonView = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, formViewController.view.bounds.size.height-240, 320, 40)];
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
    
    doneButton.tvfColIndex = button.tvfColIndex;
    doneButton.tvfRowIndex = button.tvfRowIndex;
    
    MXBarButton *BtnSpace = [[MXBarButton alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    [pickerDoneButtonView setItems:[NSArray arrayWithObjects:leftButton, BtnSpace, doneButton, nil]];
    
    [pickerContainer addSubview:pickerDoneButtonView];
    [pickerContainer addSubview:dotDropDownPicker];
    
    [formViewController.view addSubview:pickerContainer];
}




-(IBAction)cancelBarButtonPressed:(id)sender
{
    
    [dotDropDownPicker removeFromSuperview];
    [pickerDoneButtonView removeFromSuperview];
    [pickerContainer removeFromSuperview];
    
}

-(IBAction) doneSearchPicker :(id) sender
{
    
    MXBarButton* button = (MXBarButton*) sender;
    
    _currentCtx =  [NSString stringWithFormat:@"%d:%d", button.tvfRowIndex.intValue, button.tvfColIndex.intValue];
    
    DotFormElement *searchFormComponent = [formElementsArray objectAtIndex:button.tvfColIndex.intValue];
    NSString* selectedTextFieldKey = nil;
    NSMutableDictionary* searchButtonData = nil;
    
    if([sender isKindOfClass:MXBarButton.class])
    {
        selectedTextFieldKey = button.elementId;
        searchButtonData = (NSMutableDictionary *)button.attachedData;
    }
    
    
    NSString *groupName;
    NSString *masterValueMapping;
    NSString *elementId;
    
    
    groupName					= searchFormComponent.dependedCompName;
    masterValueMapping        = searchFormComponent.masterValueMapping;
    elementId                  =searchFormComponent.elementId;
    
    if([dotDropDownPicker.selectedPickerValue isEqualToString: @"None"])
    {
        NSMutableArray* fields = [componentsMap objectForKey:[NSString stringWithFormat:@"%d:%d", button.tvfRowIndex.intValue, button.tvfColIndex.intValue ]];
        MXTextField *dropDownField = [fields objectAtIndex:0];
        dropDownField.keyvalue = dotDropDownPicker.selectedPickerKey;
        dropDownField.text = dotDropDownPicker.selectedPickerValue;
        
        
    }
    else if([dotDropDownPicker.selectedPickerValue isEqualToString: @"Search"])
    {
        DotFormElement* formElement = [formElementsArray objectAtIndex:button.tvfColIndex.intValue];
        
        DotSearchComponent *searchObject = [[DotSearchComponent alloc]init];
        NSMutableArray *searchValues = [searchObject getRadioGroupData: groupName];
        
        
        CGRect textFrame = CGRectMake(0,0,320,320);//(20, 90, 280, 300) ;
        SearchFormControl* searchPopUp = [[SearchFormControl alloc]initWithFrame:textFrame : searchValues : 0 : formViewController : masterValueMapping : elementId : searchFormComponent.displayText];
        
        
        NSMutableDictionary* dependentValueMap = nil;
        if(formElement.dependedCompValue !=nil   && ![formElement.dependedCompValue isEqualToString:@""]){
            NSString* dependentElement = formElement.dependedCompValue;
            dependentValueMap = [ self getDependentDataValue: dependentElement : formViewController.dotForm];
        }
        
        searchPopUp.dependentValueMap = dependentValueMap;
        searchPopUp.multiSelect = YES;
        searchPopUp.multiSelectDelegate = self;
        
        [formViewController.view  addSubview : searchPopUp];
        
    } else
    {
        if(dotDropDownPicker.selectedPickerKey ==0)
        {
            dotDropDownPicker.selectedPickerKey = [dotDropDownPicker.dropDownListKey objectAtIndex:0];
            dotDropDownPicker.selectedPickerValue = [dotDropDownPicker.dropDownList objectAtIndex:0];
        }
        
        
        
        NSMutableArray* fields = [componentsMap objectForKey:[NSString stringWithFormat:@"%d:%d", button.tvfRowIndex.intValue, button.tvfColIndex.intValue ]];
        MXTextField *dropDownField = [fields objectAtIndex:0];
        
        dropDownField.keyvalue = dotDropDownPicker.selectedPickerKey;
        dropDownField.text = dotDropDownPicker.selectedPickerValue;
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    
    [dotDropDownPicker removeFromSuperview];
    [pickerDoneButtonView removeFromSuperview];
    [pickerContainer removeFromSuperview];
    
    
}



-(NSMutableDictionary*) getDependentDataValue:(NSString*) dependentListValue :(DotForm*) dotForm
{
    NSMutableDictionary* retMap = [[NSMutableDictionary alloc] init];
    
    NSArray* depElements = [XmwUtils breakStringTokenAsVector: dependentListValue : @"$"];
    for(int i=0; i<[depElements count]; i++) {
        NSString* key = [depElements objectAtIndex:i];
        DotFormElement* formElement = [dotForm.formElements objectForKey:key];
        DotFormPostUtil* dotFormPostUtil = [[DotFormPostUtil alloc] init];
        NSMutableArray* returnValues = [dotFormPostUtil getDotFormElementData : formElement : self.formViewController ];
        if(returnValues!=nil && [returnValues count]>0) {
            [retMap setObject:[returnValues objectAtIndex:0] forKey:key];
        }
    }
    return retMap;
}


#pragma mark - keyboard

-(void)onKeyboardHide:(NSNotification *)notification
{
    //keyboard will hide
    NSLog(@"Got the keyboard hide event");
    
    
}

-(IBAction) textFieldDone:(id) sender
{
    [sender resignFirstResponder];
    
}


#pragma  mark - MultiSelect search

-(void) multipleItemsSelected:(NSArray*) headerData   :(NSArray*) selectedRows
{
  
    
    
    if([formViewController.dotForm.formId isEqualToString:@"DOT_FORM_31"]) {
        [self multipleItemsSelectedForCreateOrder:headerData   :selectedRows];
    } else if([formViewController.dotForm.formId isEqualToString:@"DOT_FORM_32"]) {
        [self multipleItemsSelectedForItemWiseReport:headerData   :selectedRows];
    }
    
}




-(void) multipleItemsSelectedForCreateOrder:(NSArray*) headerData   :(NSArray*) selectedRows
{
    NSLog(@"XMWCreateOrderTFVDelegate.multipleItemsSelected : total items selected = %d", [selectedRows count]);
    NSLog(@"currentCTX = %@", _currentCtx);
    NSArray* parts = [_currentCtx componentsSeparatedByString:@":"];
    if([parts count]==2) {
        NSString* rowIdxStr = [parts objectAtIndex:0];
        NSString* colIdxStr = [parts objectAtIndex:1];
        
        int rowId = rowIdxStr.intValue;
        int colId = colIdxStr.intValue;
        
        if(selectedRows!=nil && ([selectedRows count]>0)) {
            for(int i=0; i<[selectedRows count]; i++) {
                NSArray* searchRecord = (NSArray*)[selectedRows objectAtIndex:i];
                if(i==0) {
                    // we need to update data on the row identified by rowId
                    [_ctxTableFormView updateRowAfterRow:rowId withData:searchRecord header:headerData];
                    
                    UIView* searchCell = [_ctxTableFormView getRowCellWithRowId:(rowId+i) colId:0];
                    MXLabel* labelField = (MXLabel*)[[searchCell subviews] objectAtIndex:0];
                    labelField.text = [searchRecord objectAtIndex:0];
                    
                    UIView* descCell = [_ctxTableFormView getRowCellWithRowId:(rowId+i) colId:2];
                    MXLabel* descLabel = (MXLabel*)[[descCell subviews] objectAtIndex:0];
                    descLabel.text = [searchRecord objectAtIndex:1];
                    descLabel.font = [UIFont systemFontOfSize:11];
                    descLabel.numberOfLines = 0;
                    
                    UIView* unitCell = [_ctxTableFormView getRowCellWithRowId:(rowId+i) colId:3];
                    MXLabel* unitLabel = (MXLabel*)[[unitCell subviews] objectAtIndex:0];
                    unitLabel.font = [UIFont systemFontOfSize:11];
                    unitLabel.text = [searchRecord objectAtIndex:2];
                    
                } else {
                    // we need to insert data on the new rows after rowId
                    [_ctxTableFormView insertRowAfterRow:rowId withData:searchRecord header:headerData];
                    
                    rowId = rowId + 1;
                    
                    UIView* searchCell = [_ctxTableFormView getRowCellWithRowId:rowId colId:0];
                    MXLabel* labelField = (MXLabel*)[[searchCell subviews] objectAtIndex:0];
                    labelField.text = [searchRecord objectAtIndex:0];
                    
                    UIView* descCell = [_ctxTableFormView getRowCellWithRowId:rowId colId:2];
                    MXLabel* descLabel = (MXLabel*)[[descCell subviews] objectAtIndex:0];
                    descLabel.text = [searchRecord objectAtIndex:1];
                    descLabel.font = [UIFont systemFontOfSize:11];
                    descLabel.numberOfLines = 0;
                    
                    UIView* unitCell = [_ctxTableFormView getRowCellWithRowId:rowId colId:3];
                    MXLabel* unitLabel = (MXLabel*)[[unitCell subviews] objectAtIndex:0];
                    unitLabel.font = [UIFont systemFontOfSize:11];
                    unitLabel.text = [searchRecord objectAtIndex:2];
                    
                }
            }
        }
    }
}


-(void) multipleItemsSelectedForItemWiseReport:(NSArray*) headerData   :(NSArray*) selectedRows
{
    
    NSLog(@"XMWCreateOrderTFVDelegate.multipleItemsSelected : total items selected = %d", [selectedRows count]);
    NSLog(@"currentCTX = %@", _currentCtx);
    NSArray* parts = [_currentCtx componentsSeparatedByString:@":"];
    if([parts count]==2) {
        NSString* rowIdxStr = [parts objectAtIndex:0];
        NSString* colIdxStr = [parts objectAtIndex:1];
        
        int rowId = rowIdxStr.intValue;
        int colId = colIdxStr.intValue;
        
        if(selectedRows!=nil && ([selectedRows count]>0)) {
            for(int i=0; i<[selectedRows count]; i++) {
                NSArray* searchRecord = (NSArray*)[selectedRows objectAtIndex:i];
                if(i==0) {
                    // we need to update data on the row identified by rowId
                    [_ctxTableFormView updateRowAfterRow:rowId withData:searchRecord header:headerData];
                    
                    UIView* searchCell = [_ctxTableFormView getRowCellWithRowId:(rowId+i) colId:0];
                    MXLabel* labelField = (MXLabel*)[[searchCell subviews] objectAtIndex:0];
                    labelField.text = [searchRecord objectAtIndex:0];
                    
                    UIView* descCell = [_ctxTableFormView getRowCellWithRowId:(rowId+i) colId:1];
                    MXLabel* descLabel = (MXLabel*)[[descCell subviews] objectAtIndex:0];
                    descLabel.text = [searchRecord objectAtIndex:1];
                    descLabel.font = [UIFont systemFontOfSize:11];
                    descLabel.numberOfLines = 0;
                } else {
                    // we need to insert data on the new rows after rowId
                    [_ctxTableFormView insertRowAfterRow:rowId withData:searchRecord header:headerData];
                    
                    rowId = rowId + 1;
                    
                    UIView* searchCell = [_ctxTableFormView getRowCellWithRowId:rowId colId:0];
                    MXLabel* labelField = (MXLabel*)[[searchCell subviews] objectAtIndex:0];
                    labelField.text = [searchRecord objectAtIndex:0];
                    
                    UIView* descCell = [_ctxTableFormView getRowCellWithRowId:rowId colId:1];
                    MXLabel* descLabel = (MXLabel*)[[descCell subviews] objectAtIndex:0];
                    descLabel.text = [searchRecord objectAtIndex:1];
                    descLabel.font = [UIFont systemFontOfSize:11];
                    descLabel.numberOfLines = 0;
                    
                }
            }
        }
    }
}



-(void) selectionCancelled
{
    NSLog(@"XMWCreateOrderTFVDelegate.selectionCancelled");
    
    
}



-(id) componentAt:(int) rowIdx :(int) colIdx
{
    return [componentsMap objectForKey:[NSString stringWithFormat:@"%d:%d", rowIdx, colIdx ]];
}


@end
