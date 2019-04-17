//
//  ContactList_Object.h
//  XMWClient
//
//  Created by dotvikios on 15/04/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContactList_Object : NSObject
{
    @private
    NSString *emailId;
    NSString *userId;
    NSString *name;
}
@property NSString *emailId;
@property NSString *userId;
@property NSString *name;
@end

NS_ASSUME_NONNULL_END
