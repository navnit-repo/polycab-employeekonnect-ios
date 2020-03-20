//
//  NationalWisePolycabSalesComparisonChat.m
//  XMWClient
//
//  Created by dotvikios on 14/02/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "NationalWisePolycabSalesComparisonChat.h"
#import "AppConstants.h"
@implementation NationalWisePolycabSalesComparisonChat

- (DotFormPost *)salesReportFormPost:(NSString *)fromDate toDate:(NSString *)toDate{
    DotFormPost *dotFormPost = [[DotFormPost alloc]init];
    
    [dotFormPost setAdapterId:AppConst_EMPLOYEE_SALES_AGGREGATE_CARD_DOC_ID];
    [dotFormPost setAdapterType:@"CLASSLOADER"];
    [dotFormPost setModuleId:AppConst_MOBILET_ID_DEFAULT];
    
    NSMutableDictionary *sendData = [[NSMutableDictionary alloc]init];
    [sendData setObject:@"" forKey:@"CUSTOMER_ACCOUNT"];
    [sendData setObject:fromDate forKey:@"FROM_DATE"];
    [sendData setObject:toDate forKey:@"TO_DATE"];
    [dotFormPost setPostData:sendData];
    
    return dotFormPost;
}

-(NSString*)formateCurrency:(NSString *)actualAmount{
    
    float shortenedAmount = [actualAmount floatValue];
    NSString *suffix = @"";
    float currency = [actualAmount floatValue];
    if(currency >= 100.0f) {
        suffix = @"Cr";
        shortenedAmount /= 100.0f;
    }
    //    if (currency <=0.0) {
    //        suffix=@"";
    //    }
    else {
        suffix = @"L";
        
    }
    //    else if(currency >= 1000.0f) {
    //        suffix = @"K";
    //        shortenedAmount /= 1000.0f;
    //    }
    
    NSString *requiredString = [NSString stringWithFormat:@"%0.1f%@", shortenedAmount, suffix];
    return requiredString;
    
}

@end
