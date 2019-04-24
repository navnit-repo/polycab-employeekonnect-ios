//
//  ChatHistory_Object.h
//  XMWClient
//
//  Created by dotvikios on 17/04/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatHistory_Object : NSObject
{
@private
    int chatThreadId;
    NSString *from;
    NSString *to;
    NSString *message;
    NSString *messageDate;
    NSString *messageType;
    int messageId;
    int KEY_ID;
}
@property int messageId;
@property int chatThreadId;
@property NSString *from;
@property NSString *to;
@property NSString *message;
@property int KEY_ID;
@property NSString *messageDate;
@property NSString *messageType;
@end

NS_ASSUME_NONNULL_END
