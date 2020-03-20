//
//  CurrencyConversationClass.h
//  XMWClient
//
//  Created by dotvikios on 05/03/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CurrencyConversationClass : UIView
-(NSString*)formateCurrency:(NSString *)actualAmount;
-(CurrencyConversationClass *) init;
@end

NS_ASSUME_NONNULL_END
