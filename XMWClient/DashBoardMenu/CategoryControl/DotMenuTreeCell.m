#import "DotMenuTreeCell.h"
#import "HamBurgerMenuView.h"

@interface DotMenuTreeCell ()

@property (nonatomic, strong) UIImageView *arrowImageV;

@end

@implementation DotMenuTreeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.arrowImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    myHumMenuIcon = [[NSArray alloc]initWithObjects:@"notification",@"report",@"create_order",@"popular_scheme",@"special_offer",@"contact_us",@"my_details",@"forgot_password",@"file_explorer",@"logout",@"arrow_open",@"arrow_open", nil];
    // [self.textLabel setFont:[UIFont museoSans100WithSize:14.0]];
}

- (void)setAccesoryType:(DotMenuCellAccesoryStatus)status {
    switch (status) {
        case DotMenuCellAccesoryStatusOpen:
            [self.arrowImageV setImage:[UIImage imageNamed:@"polycab_arrow_open"]];
            [self.arrowImageV setFrame:CGRectMake(0, 0, 15, 5)];
            self.accessoryView = self.arrowImageV;
            break;
        case DotMenuCellAccesoryStatusClose:
            [self.arrowImageV setImage:[UIImage imageNamed:@"polycab_arrow_closed"]];
            [self.arrowImageV setFrame:CGRectMake(0, 0, 15, 5)];
            self.accessoryView = self.arrowImageV;
            break;
        case DotMenuCellAccesoryStatusNone:
            self.accessoryView = nil;
            self.imageView.image = nil;
            break;
        case DotMenuCellAccesoryDefaultImage:
            [self.arrowImageV setImage:[UIImage imageNamed:@"polycab_arrow_open"]];
            self.accessoryView = self.arrowImageV;
            break;
        default:
            break;
    }
}

- (void)setAccesoryTypeAsImage:(DotMenuCellAccesoryStatus)status : (int)index
{
    switch (status) {
        case DotMenuCellAccesoryStatusOpen:
            [self.arrowImageV setImage:[UIImage imageNamed:@"polycab_arrow_open"]];
            self.accessoryView = self.arrowImageV;
            break;
        case DotMenuCellAccesoryStatusClose:
            [self.arrowImageV setImage:[UIImage imageNamed:@"polycab_arrow_closed"]];
            self.accessoryView = self.arrowImageV;
            break;
        case DotMenuCellAccesoryStatusNone:
            self.accessoryView = nil;
            break;
        case DotMenuCellAccesoryDefaultImage:
           // [self.arrowImageV setImage:[UIImage imageNamed:[myHumMenuIcon objectAtIndex:index]]];
           // self.accessoryView = self.arrowImageV;
            [self.imageView setImage:[UIImage imageNamed:[myHumMenuIcon objectAtIndex:index]]];
            self.imageView.contentMode =  UIViewContentModeCenter;
            
            break;
        default:
            break;
    }
    
}

- (void)setAccesoryTypeAsImageName:(DotMenuCellAccesoryStatus)status : (NSString *)menuName
{
    switch (status) {
        case DotMenuCellAccesoryStatusOpen:
            [self.arrowImageV setImage:[UIImage imageNamed:@"polycab_arrow_open.png"]];
            self.accessoryView = self.arrowImageV;
            break;
        case DotMenuCellAccesoryStatusClose:
            [self.arrowImageV setImage:[UIImage imageNamed:@"polycab_arrow_closed.png"]];
            self.accessoryView = self.arrowImageV;
            break;
        case DotMenuCellAccesoryStatusNone:
            self.accessoryView = nil;
            break;
        case DotMenuCellAccesoryDefaultImage:
            // [self.arrowImageV setImage:[UIImage imageNamed:[myHumMenuIcon objectAtIndex:index]]];
            // self.accessoryView = self.arrowImageV;
            [self.imageView setImage:[UIImage imageNamed:[HamBurgerMenuView getMenuImage: menuName]]];
            self.imageView.contentMode = UIViewContentModeCenter;
            
            break;
        default:
            break;
    }
    
}


@end
