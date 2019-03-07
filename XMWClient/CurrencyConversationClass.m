//
//  CurrencyConversationClass.m
//  XMWClient
//
//  Created by dotvikios on 05/03/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "CurrencyConversationClass.h"

@implementation CurrencyConversationClass

-(CurrencyConversationClass *) init
{
    self = [super init];
    
    if ( self )
    {
        
    }
    return self;
}

-(NSString*)formateCurrency:(NSString *)actualAmount{
    
    float shortenedAmount = [actualAmount floatValue];
    NSString *suffix = @"";
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setPositiveFormat:@"##,##,###.#"];
    [formatter setRoundingMode: NSNumberFormatterRoundDown];
    float currency = [actualAmount floatValue];
    
     if (currency ==0)
    {
        suffix = @"";
        shortenedAmount = currency;
        return [NSString stringWithFormat:@"%0.1f", shortenedAmount] ;
    }
    else
    {
        if(currency >= 100.0f) {
            suffix = @"Cr";
            shortenedAmount /= 100.0f;
        }

    else
    {
        suffix = @"L";
        shortenedAmount = currency;
        [formatter setRoundingMode: NSNumberFormatterRoundHalfDown];
    }
        
        
       
        
        
        NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithFloat:shortenedAmount]];
        NSString *requiredString = [formatted stringByAppendingString:suffix];
        NSLog(@"return : %@",requiredString);
        return requiredString;
}
    
    
}

@end
