//
//  DataManager.m
//  Dotvik Solutions
//
//  Created by Pradeep Singh on 11/02/20.
//  Copyright © 2020 Pradeep Singh. All rights reserved.
//

#import "DataManager.h"

static DataManager* g_DataManagerInstance = nil;

@interface DataManager ()
{
    
}

@end

@implementation DataManager


@synthesize non_tsi_accounts;
@synthesize non_tsi_customers;


+ (DataManager*) getInstance
{
    
    if(g_DataManagerInstance==nil) {
        g_DataManagerInstance = [[DataManager alloc] init];
    }
    
    return g_DataManagerInstance;
    
}


-(void) clear
{
    
    non_tsi_accounts = nil;
    non_tsi_customers = nil;
    
}
@end
