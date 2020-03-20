//
//  ProductCatObject.m
//  QCMSProject
//
//  Created by Pradeep Singh on 3/25/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import "ProductCatObject.h"

@implementation ProductCatObject

- (id)initWithObject:(id)jsonObject {
    self = [super init];
    if (self) {
        // init
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            [self setJsonObject:jsonObject];
        }
    }
    return self;
}

- (id)initWithObject:(id)jsonObject atDepth:(NSUInteger)depth {
    self = [super init];
    if (self) {
        // init
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            self.levelDepth = depth;
            [self setJsonObject:jsonObject];
        }
    }
    return self;
}

- (void)setJsonObject:(id)jsonObject {
    
    self.identifier = jsonObject[@"CAT_GUI"];
    self.CATAGORY_ID = jsonObject[@"CATAGORY_ID"];
    self.CAT_GUI = jsonObject[@"CAT_GUI"];
    self.PARENT_CATALOG = jsonObject[@"PARENT_CATALOG"];
    self.PARENT_CATEGORY = jsonObject[@"PARENT_CATEGORY"];
    
    id children = jsonObject[@"CATEGORY_LIST"];
    
    if ([children isKindOfClass:[NSArray class]] && ((NSArray *)children).count > 0) {
        NSMutableArray *childrenObjArray = [NSMutableArray array];
        
        NSArray *childrenArray = (NSArray *)children;
        for (id child in childrenArray) {
            ProductCatObject *object = [[ProductCatObject alloc] initWithObject:child atDepth:self.levelDepth+1];
            [childrenObjArray addObject:object];
        }
        _childCategories = childrenObjArray;
    }
}



@end
