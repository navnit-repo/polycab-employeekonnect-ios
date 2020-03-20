//
//  PolycabProductCatObject.h
//  XMWClient
//
//  Created by dotvikios on 17/08/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PolycabProductCatObject : NSObject
@property (nonatomic, strong) NSString *categoryDesc;
@property (nonatomic, strong) NSString* level;
@property (nonatomic, strong) NSString* lobCode;
@property (nonatomic, strong) NSString* primaryCategory;
@property (nonatomic, strong) NSString* primarySubCategory;
@property (nonatomic, strong) NSString* secondaryItemCategory;
@property (nonatomic, strong) NSString* secondaryItemSubCategory;


@property (nonatomic, strong) NSArray *childList;
@property (nonatomic) BOOL isOpen; // Donot alter this parameter

- (id)initWithObject:(id)jsonObject;

@end
