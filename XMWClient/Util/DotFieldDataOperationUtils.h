//
//  DotFieldDataOperationUtils.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 01/07/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormVC.h"

@interface DotFieldDataOperationUtils : NSObject
{
    
}

+(NSString *) calculateData : (NSString *) firstString : (NSString *) secondString : (NSString*) operator;
+(NSString *) greaterEqualCheck : (NSString *) firstNumber : (NSString *) secondNumber;
+(NSString *) compareNumber : (NSString *) firstNumber : (NSString *) secondNumber;
+(NSString *) multiply : (NSString *) firstNumber : (NSString *) secondNumber;
+(NSString *) addition : (NSString *) firstNumber : (NSString *) secondNumber;
+(NSString *) substract : (NSString *) firstNumber : (NSString *) secondNumber;

+(NSString *) operationLostFocus : (NSArray *) valueVector : (FormVC *) baseForm;
+(NSString *) valueOfComponent : (NSString *) objectId : (FormVC *) baseForm;

+(void) setComponentValue : (NSString *) objectId : (FormVC *) baseForm : (NSString *) value;


@end
