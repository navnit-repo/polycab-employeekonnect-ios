//
//  DotFieldDataOperationUtils.m
//  QCMSProject
//
//  Created by Ashish Tiwari on 01/07/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "DotFieldDataOperationUtils.h"
#import "XmwcsConstant.h"
#import "MXLabel.h"
#import "MXTextField.h"
#import "DotDropDownPicker.h"

@implementation DotFieldDataOperationUtils





+(NSString *) calculateData : (NSString *) firstString : (NSString *) secondString : (NSString*) operator
{
    NSString *result = @"";
    if ([firstString isEqualToString: @""]&& ![operator isEqualToString : XmwcsConst_FIELD_OPERATION_STRING_CONCAT]) {
        firstString = @"0";
    } 
    
    if ([secondString isEqualToString : @""] && ![operator isEqualToString :XmwcsConst_FIELD_OPERATION_STRING_CONCAT]) {
        secondString = @"0";
    }
    if ([operator isEqualToString : XmwcsConst_FIELD_OPERATION_GREATER_THAN] ||
        [operator isEqualToString : XmwcsConst_FIELD_OPERATION_MULTIPLICATION]
        || [operator isEqualToString : XmwcsConst_FIELD_OPERATION_ADDITION]
        || [operator isEqualToString : XmwcsConst_FIELD_OPERATION_SUBSTRACTION]) {
        if ([operator isEqualToString : XmwcsConst_FIELD_OPERATION_GREATER_THAN]) {
            result = [self greaterEqualCheck : firstString : secondString];
        } else if ([operator isEqualToString : XmwcsConst_FIELD_OPERATION_MULTIPLICATION]) {
            result = [self multiply : firstString : secondString ];
        } else if ([operator isEqualToString : XmwcsConst_FIELD_OPERATION_ADDITION]) {
            result = [self addition :firstString : secondString];
        } else if ([operator isEqualToString : XmwcsConst_FIELD_OPERATION_SUBSTRACTION]) {
            result = [self substract : firstString : secondString];
        }
    } else if ([operator isEqualToString : XmwcsConst_FIELD_OPERATION_STRING_CONCAT]) {
        
        result = [firstString stringByAppendingString:secondString];
       
        
    }
    return result;
}

+(NSString *) greaterEqualCheck : (NSString *) firstNumber : (NSString *) secondNumber
{
    NSString *result = [self compareNumber : firstNumber : secondNumber];
    if([result isEqualToString : XmwcsConst_FIELD_OPERATION_RESULT_GT] || [result isEqualToString : XmwcsConst_FIELD_OPERATION_RESULT_EQUAL]){
        return XmwcsConst_BOOLEAN_VALUE_TRUE;
    }else{
        return XmwcsConst_BOOLEAN_VALUE_FALSE;
    }
    
}

+(NSString *) compareNumber : (NSString *) firstNumber : (NSString *) secondNumber
{
    if(([firstNumber indexOfAccessibilityElement : @"."]>0) ||([secondNumber indexOfAccessibilityElement : @"."]>0)) 
    {
     
        
        double firstNum = [firstNumber doubleValue];
        double secondNum = [secondNumber doubleValue];       
        if(firstNum > secondNum){
            return XmwcsConst_FIELD_OPERATION_RESULT_GT;
        }else if(firstNum == secondNum ){
            return XmwcsConst_FIELD_OPERATION_RESULT_EQUAL;
        }else{
            return XmwcsConst_FIELD_OPERATION_RESULT_LESS;
        }
        
    }
    else{
        
        int firstNum = [firstNumber integerValue];
       
        int secondNum = [secondNumber integerValue];
        if(firstNum > secondNum){
            return XmwcsConst_FIELD_OPERATION_RESULT_GT;
        }else if(firstNum == secondNum ){
            return XmwcsConst_FIELD_OPERATION_RESULT_EQUAL;
        }else{
            return XmwcsConst_FIELD_OPERATION_RESULT_LESS;
        }
    }
    
    
}

+(NSString *) multiply : (NSString *) firstNumber : (NSString *) secondNumber
{
    if(([firstNumber indexOfAccessibilityElement: @"."]>0)||([secondNumber indexOfAccessibilityElement: @"."] > 0 )){
        double firstNum =  [firstNumber doubleValue];
        double secondNum = [secondNumber doubleValue];
        return [NSString stringWithFormat : @"%.2f",(firstNum*secondNum)];
    }else{
        int firstNum = [firstNumber integerValue];//Long.parseLong(firstNumber);
        int secondNum = [secondNumber integerValue];
        return [NSString stringWithFormat : @"%d",(firstNum*secondNum)];
       
        }
       
}
+(NSString *) addition : (NSString *) firstNumber : (NSString *) secondNumber
{
    if(([firstNumber indexOfAccessibilityElement: @"."]>0)||([secondNumber indexOfAccessibilityElement: @"."] > 0 ))
    {
        double firstNum = [firstNumber doubleValue];
        double secondNum = [secondNumber doubleValue];
        return [NSString stringWithFormat : @"%.2f",(firstNum + secondNum)];
    }else{
        int firstNum = [firstNumber integerValue];
        int secondNum = [secondNumber integerValue];
        return [NSString stringWithFormat : @"%d",(firstNum + secondNum)];
        
        
       
       
    }
    
}
+(NSString *) substract : (NSString *) firstNumber : (NSString *) secondNumber
{
    if(([firstNumber indexOfAccessibilityElement: @"."]>0)||([secondNumber indexOfAccessibilityElement: @"."] > 0 ))
    {
        double firstNum = [firstNumber doubleValue];
        double secondNum = [secondNumber doubleValue];
        return [NSString stringWithFormat : @"%.2f",(firstNum - secondNum)];
    }
    else{
        int firstNum = [firstNumber integerValue]; 
        int secondNum = [secondNumber integerValue];
        return [NSString stringWithFormat : @" %d" ,(firstNum - secondNum)];
    }
    
}

+(NSString *) operationLostFocus : (NSArray *) valueVector : (FormVC *) baseForm
{
    NSString *operator = @"";
    NSMutableArray *resultVector = [[NSMutableArray alloc]init];
    for (int cntOpertion = 0; cntOpertion < [valueVector count]; cntOpertion++) {
        NSString *valueReturn = (NSString *) [valueVector objectAtIndex:cntOpertion];
          if (cntOpertion % 3 == 0) {
            NSString *valueOfText = @"";
            if ([valueReturn isEqualToString : XmwcsConst_FIELD_TYPE_DOT_FORM_FIELD ]) {
                valueOfText = [self valueOfComponent : (NSString*) [valueVector objectAtIndex:(cntOpertion+1)] : baseForm];
                
            } else if ([valueReturn  isEqualToString : XmwcsConst_FIELD_TYPE_STRING]) {
                valueOfText = (NSString *) [valueVector objectAtIndex:(cntOpertion+1)];
            }
            cntOpertion = cntOpertion + 1;
            [resultVector addObject:valueOfText];
            if (XmwcsConst_IS_DEBUG)
            {
               // System.out.println("Value Of Text " + valueOfText + "resultVector size" + resultVector.size());
            }
        } else if (cntOpertion % 3 == 2) {
            operator = valueReturn;
        }
        if (resultVector.count == 2) {
            NSString *firstString = (NSString *) [resultVector objectAtIndex:0];
            NSString *secondString = (NSString *) [resultVector objectAtIndex:1];
            NSString *result = [ self calculateData : firstString : secondString : operator];
            [resultVector removeAllObjects];
           [resultVector addObject:result];
        }
    }
    if (XmwcsConst_IS_DEBUG) {
        //System.out.println("Result --> " + resultVector.size());
       // System.out.println("Result --> " + resultVector.elementAt(0).toString());
    }
   return [resultVector objectAtIndex:0];
    

    
    
}
+(NSString *) valueOfComponent : (NSString *) objectId : (FormVC *) baseForm
{
    NSString *valueOfText = @"";
     
    id component = [baseForm getDataFromId : objectId];
    if ([component isKindOfClass:[DotDropDownPicker class]])
    {
        DotDropDownPicker *dropDown = (DotDropDownPicker *) component;
        valueOfText = dropDown.selectedPickerValue;
       
    } else if([component isKindOfClass:[MXLabel class]])
    {
        MXLabel *dotTF = (MXLabel *) component;
        valueOfText = dotTF.text;
    }
    else if([component isKindOfClass : [MXTextField class]])
    {
        MXTextField *dotTF = (MXTextField *) component;
        valueOfText = dotTF.text;
    }
    else if([component isKindOfClass : [MXTextField class]])
    {
        MXTextField *dotTF = (MXTextField *) component;
        valueOfText = dotTF.text;
    }
    return valueOfText;
    
}

+(void) setComponentValue : (NSString *) objectId : (FormVC *) baseForm : (NSString *) value
{
   id component = [baseForm getDataFromId : objectId];
    if ([component isKindOfClass:[MXLabel class]])
    {
        MXLabel *dotTF = (MXLabel *) component;
        [dotTF setText:value];
    }
    else if ([component isKindOfClass : [MXTextField class]])
    {
        MXTextField *dotTF = (MXTextField *) component;
        [dotTF setText:value];
    }
    else if ([component isKindOfClass : [MXTextField class]])
    {
        MXTextField *dotTF = (MXTextField *) component;
        [dotTF setText:value];
    }
}



@end
