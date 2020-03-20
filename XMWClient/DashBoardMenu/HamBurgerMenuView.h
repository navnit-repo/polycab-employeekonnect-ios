//
//  HamBurgerMenuView.h
//  QCMSProject
//
//  Created by Pradeep Singh on 10/5/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DotMenuTreeTableView.h"
#import "DotMenuObject.h"


@protocol HamBurgerMenuHandler <NSObject>
-(void) humbergerMenuClicked : (int) idx : (DotMenuObject *)selectedMenuData;
@end


@interface HamBurgerMenuView : UIView <DotMenuTreeTblViewDelegate>
{
    id<HamBurgerMenuHandler> burgerMenuHandler;
    
    
    NSMutableArray* menuTree;
    
    NSArray *menuAndDashImageIcon;
        
}

@property UITableView* menuTable;
@property NSMutableArray* menuItems;

- (id)initWithFrame:(CGRect)frame withMenu:(NSArray*) menus handler:(id<HamBurgerMenuHandler>) menuHandler : (NSMutableDictionary *)menuDetail : (NSMutableArray *)keyIdName;



@property NSMutableArray* keyIdName;
@property (strong, nonatomic) NSMutableDictionary *menuDetail;



+ (NSMutableDictionary*) getMenuMap;
+ (NSString*) getMenuImage:(NSString*) keyName;
+ (NSString*) getMenuDashImage:(NSString*) keyName;


@end


