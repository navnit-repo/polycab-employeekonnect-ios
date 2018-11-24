//
//  PolycabProductCatObject.m
//  XMWClient
//
//  Created by dotvikios on 17/08/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "PolycabProductCatObject.h"

@implementation PolycabProductCatObject
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
            [self setJsonObject:jsonObject];
        }
    }
    return self;
}

- (void)setJsonObject:(id)jsonObject {
    
    self.categoryDesc = jsonObject[@"categoryDesc"];
    self.level = jsonObject[@"level"];
    self.lobCode = jsonObject[@"lobCode"];
    self.primaryCategory = jsonObject[@"primaryCategory"];
    self.primarySubCategory = jsonObject[@"primarySubCategory"];
    self.secondaryItemCategory = jsonObject[@"secondaryItemCategory"];
    self.secondaryItemSubCategory = jsonObject[@"secondaryItemSubCategory"];
    
    id children = jsonObject[@"childList"];
    
    if ([children isKindOfClass:[NSArray class]] && ((NSArray *)children).count > 0) {
        NSMutableArray *childrenObjArray = [NSMutableArray array];
        
        NSArray *childrenArray = (NSArray *)children;
        for (id child in childrenArray) {
            PolycabProductCatObject *object = [[PolycabProductCatObject alloc] initWithObject:child atDepth:1];
            [childrenObjArray addObject:object];
        }
        _childList = childrenObjArray;
    }
}

@end
