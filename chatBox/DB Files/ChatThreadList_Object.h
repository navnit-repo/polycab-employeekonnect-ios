//
//  ChatThreadList_Object.h
//  XMWClient
//
//  Created by dotvikios on 16/04/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatThreadList_Object : NSObject
{
@private
    int chatThreadId;
    NSString *from;
    NSString *to;
    NSString *status;
    NSString *subject;
    NSString *lastMessageOn;
    int KEY_ID;
    NSString *displayName;
}
@property NSString *displayName;
@property int chatThreadId;
@property NSString *from;
@property NSString *to;
@property NSString *status;
@property int KEY_ID;
@property NSString *subject;
@property NSString *lastMessageOn;
@end

NS_ASSUME_NONNULL_END
