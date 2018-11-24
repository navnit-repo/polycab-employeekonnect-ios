//
//  OperationManagerUtil.m
//  QCMSProject
//
//  Created by Pradeep Singh on 5/25/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "OperationManagerUtil.h"
#import "XmwcsConstant.h"
#import "XmwUtils.h"

@implementation OperationManagerUtil


+ (NSMutableDictionary*) handleOnClickOperation : (NSMutableDictionary*) addDataMap {
    
    NSMutableDictionary* operationDetailMap = (NSMutableDictionary*) [addDataMap objectForKey: XmwcsConst_MENU_CONSTANT_OPERATION_DETAIL];
    NSMutableDictionary* makeMenuOperationMap = [[NSMutableDictionary alloc] init];
    
    NSMutableArray* operationCodeVec = [OperationManagerUtil getOperationVec : operationDetailMap ];
    for (int cntOperation = 0; cntOperation < [operationCodeVec count]; cntOperation++) {
        NSString* operationCode = (NSString*) [operationCodeVec objectAtIndex:cntOperation];
        NSMutableDictionary* oneOperationDetail = (NSMutableDictionary*) [operationDetailMap objectForKey : operationCode ];
        //successive element on the operation Detail
      //  int sequenceVal = Integer.parseInt((String) oneOperationDetail.get(XmwcsConstant.MENU_CONSTANT_SEQUENCE));
        
        NSNumber* sequenceVal = [[NSNumber alloc] initWithInt: [(NSString*)[oneOperationDetail objectForKey: XmwcsConst_MENU_CONSTANT_SEQUENCE] intValue]];
        [makeMenuOperationMap setObject:oneOperationDetail forKey:sequenceVal];
    }
    return makeMenuOperationMap;
}

+ (NSMutableArray*) getOperationVec : (NSMutableDictionary*) operationDetail {
    NSString* operationName = (NSString*) [operationDetail objectForKey: XmwcsConst_MENU_CONSTANT_OPERATION_NAME];
    return [XmwUtils breakStringTokenAsVector : operationName :@"$"];
}

@end
