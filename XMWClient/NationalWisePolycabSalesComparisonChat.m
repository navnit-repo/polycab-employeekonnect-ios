//
//  NationalWisePolycabSalesComparisonChat.m
//  XMWClient
//
//  Created by dotvikios on 14/02/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "NationalWisePolycabSalesComparisonChat.h"

@implementation NationalWisePolycabSalesComparisonChat

- (DotFormPost *)salesReportFormPost:(NSString *)fromDate toDate:(NSString *)toDate{
    DotFormPost *dotFormPost = [[DotFormPost alloc]init];
    
    [dotFormPost setAdapterId:@"DR_NATIONAL_SALES_BU_DASHBOARD"];
    [dotFormPost setAdapterType:@"CLASSLOADER"];
    [dotFormPost setModuleId:AppConst_MOBILET_ID_DEFAULT];
    
    NSMutableDictionary *sendData = [[NSMutableDictionary alloc]init];
    [sendData setObject:@"" forKey:@"CUSTOMER_ACCOUNT"];
    [sendData setObject:fromDate forKey:@"FROM_DATE"];
    [sendData setObject:toDate forKey:@"TO_DATE"];
    [dotFormPost setPostData:sendData];
    
    return dotFormPost;
}

@end
