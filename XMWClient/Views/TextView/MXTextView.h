//
//  MXTextView.h
//  XMWClient
//
//  Created by Tushar Gupta on 04/12/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MXTextView : UITextView <UITextViewDelegate>
//@property (strong, nonatomic) NSString *textValue;

@property (strong, nonatomic) NSString *elementId;

@property (strong, nonatomic) NSString *attachedData;

@property(strong, nonatomic) NSString *keyvalue;
//@property(strong, nonatomic) NSString *text;

-(MXTextView *) init;
@end

NS_ASSUME_NONNULL_END
