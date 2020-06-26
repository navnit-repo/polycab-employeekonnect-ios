//
//  DataManager.h
//  Dotvik Solutions
//
//  Created by Pradeep Singh on 11/02/20.
//  Copyright © 2020 Pradeep Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataManager : NSObject
{
    NSMutableArray< NSMutableArray< NSString* >* >* non_tsi_customers;
    NSMutableDictionary<NSString*, NSMutableArray< NSMutableArray< NSString*>* >* >*  non_tsi_accounts;
}

@property (strong, nonatomic) NSMutableDictionary* non_tsi_accounts;
@property (strong, nonatomic) NSMutableArray* non_tsi_customers;


+(DataManager*) getInstance;    // for default instance;

-(void) clear;

@end

NS_ASSUME_NONNULL_END
