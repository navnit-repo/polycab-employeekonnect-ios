//
//  ExpendObjectClass.h
//  XMWClient
//
//  Created by dotvikios on 07/05/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatThreadList_Object.h"
NS_ASSUME_NONNULL_BEGIN

@interface ExpendObjectClass : NSObject
@property (nonatomic, strong)NSString *MENU_NAME;
@property (nonatomic, strong)NSArray *childCategories;
@end

NS_ASSUME_NONNULL_END
