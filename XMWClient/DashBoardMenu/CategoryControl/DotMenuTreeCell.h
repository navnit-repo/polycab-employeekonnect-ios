#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DotMenuCellAccesoryStatus) {
    DotMenuCellAccesoryStatusNone = 0,
    DotMenuCellAccesoryStatusOpen,
    DotMenuCellAccesoryStatusClose,
    DotMenuCellAccesoryDefaultImage
};

@interface DotMenuTreeCell : UITableViewCell
{
    NSArray *myHumMenuIcon;
}

- (void)setAccesoryType:(DotMenuCellAccesoryStatus)status;
- (void)setAccesoryTypeAsImage:(DotMenuCellAccesoryStatus)status : (int)index;
- (void)setAccesoryTypeAsImageName:(DotMenuCellAccesoryStatus)status : (NSString *)menuName;
@end
