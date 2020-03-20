#import <Foundation/Foundation.h>

@interface DotMenuObject : NSObject

@property (nonatomic)BOOL visible;
@property (nonatomic, strong)NSNumber *identifier;
@property (nonatomic, strong)NSString *MENU_NAME;
@property (nonatomic, strong)NSString *FORM_TYPE;
@property (nonatomic, strong)NSNumber *numberOfProducts;
@property (nonatomic, strong)NSString *FORM_ID;
@property (nonatomic, strong)NSString *MODULE;
@property (nonatomic, strong)NSArray *childCategories;
@property (nonatomic, strong)NSString *IS_OPERATION_AVAL;
@property (nonatomic) NSUInteger levelDepth;
@property (nonatomic, strong)NSString *LAST_FORM_ID;
@property (nonatomic, strong)NSString *ACCESORY_IMAGE;
@property (nonatomic, strong)NSNumber *ACCESORY_IMAGE_NUM;
@property (nonatomic,strong)NSString *ACCSRY_DASH_IMAGE_NAME;


@property (nonatomic) BOOL isOpen; // Donot alter this parameter

- (id)initWithObject:(id)jsonObject;


@end
