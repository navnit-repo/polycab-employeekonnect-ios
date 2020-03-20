//
//  ProductCatObject.h
//  QCMSProject
//
//  Created by Pradeep Singh on 3/25/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductCatObject : NSObject


@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString* CATAGORY_ID;
@property (nonatomic, strong) NSString* CAT_GUI;
@property (nonatomic, strong) NSString* PARENT_CATALOG;  // Lob Code
@property (nonatomic, strong) NSString* PARENT_CATEGORY; //

@property (nonatomic, strong) NSArray *childCategories;
@property (nonatomic) NSUInteger levelDepth;
@property (nonatomic) BOOL isOpen; // Donot alter this parameter

- (id)initWithObject:(id)jsonObject;


@end
