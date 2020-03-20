//
//  OperationManagerUtil.h
//  QCMSProject
//
//  Created by Pradeep Singh on 5/25/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OperationManagerUtil : NSObject

+ (NSMutableDictionary*) handleOnClickOperation : (NSMutableDictionary*) addDataMap;
+ (NSMutableArray*) getOperationVec : (NSMutableDictionary*) operationDetail;

@end
