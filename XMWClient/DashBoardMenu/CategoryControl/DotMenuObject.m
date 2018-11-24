#import "DotMenuObject.h"

@implementation DotMenuObject

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
    _visible = (BOOL)jsonObject[@"visible"];
    _identifier = jsonObject[@"id"];
    _FORM_TYPE = jsonObject[@"FORM_TYPE"];
    _MENU_NAME = jsonObject[@"MENU_NAME"];
    _numberOfProducts = jsonObject[@"noOfResults"];
    _FORM_ID = jsonObject[@"FORM_ID"];
    _MODULE = jsonObject[@"MODULE"];
    _IS_OPERATION_AVAL = jsonObject[@"IS_OPERATION_AVAL"];
    _LAST_FORM_ID = jsonObject[@"LAST_FORM_ID"];
    _ACCESORY_IMAGE = jsonObject[@"ACCESORY_IMAGE"];
    _ACCESORY_IMAGE_NUM = jsonObject[@"ACCESORY_IMAGE_NUM"];
    _ACCSRY_DASH_IMAGE_NAME = jsonObject[@"ACCSRY_DASH_IMAGE_NAME"];
    
    id children = jsonObject[@"childCategories"];
    
    if ([children isKindOfClass:[NSArray class]] && ((NSArray *)children).count > 0) {
        NSMutableArray *childrenObjArray = [NSMutableArray array];
        
        NSArray *childrenArray = (NSArray *)children;
        for (id child in childrenArray) {
            DotMenuObject *object = [[DotMenuObject alloc] initWithObject:child atDepth:self.levelDepth+1];
            [childrenObjArray addObject:object];
        }
        _childCategories = childrenObjArray;
    }
}



@end
