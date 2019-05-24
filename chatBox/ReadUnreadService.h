//
//  ReadUnreadService.h
//  XMWClient
//
//  Created by dotvikios on 24/05/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkHelper.h"
NS_ASSUME_NONNULL_BEGIN

@interface ReadUnreadService : UIView
{
    NSMutableDictionary *requestDict;
    NSString *callName;
}
@property  NSMutableDictionary *requestDict;
@property NSString *callName;
-(id) initWithPostData:(NSMutableDictionary*) request withContext:(NSString*) context;
@end

NS_ASSUME_NONNULL_END
