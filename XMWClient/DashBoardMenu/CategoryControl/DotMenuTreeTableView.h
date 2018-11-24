#import <UIKit/UIKit.h>
#import "DotMenuObject.h"
@protocol DotMenuTreeTblViewDelegate <NSObject,UIPickerViewDelegate,UIAlertViewDelegate>

@required
- (NSArray *)getAllMenuCategoriesDataWithSender:(id)sender; // return complete model Array

@optional
- (void)didSelectMenuCategory:(DotMenuObject *)category
   withCategoryPathString:(NSString *)categoryPathString
                   sender:(id)sender;
- (void)didExpandMenuCategory:(DotMenuObject *)category sender:(id)sender;
- (void)didCollapseMenuCategory:(DotMenuObject *)category sender:(id)sender;

@end

@interface DotMenuTreeTableView : UITableView

@property (nonatomic, weak) id<DotMenuTreeTblViewDelegate> myDelegate;
+ (NSArray *)createModalDataSourceFromJson:(id)jsonArrayObject;

- (void)selectMenuCategoryWithPanelXPath:(NSString *)categoryPanelXPath;

@end
