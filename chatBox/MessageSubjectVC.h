//
//  MessageSubjectVC.h
//  XMWClient
//
//  Created by dotvikios on 09/04/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageSubjectVC : UIViewController<UITextViewDelegate,UITextFieldDelegate>
{
    NSString *userIDUnique;
}
@property NSString *userIDUnique;
@end

NS_ASSUME_NONNULL_END
