//
//  HamBurgerMenuView.m
//  QCMSProject
//
//  Created by Pradeep Singh on 10/5/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "HamBurgerMenuView.h"
#import "MXButton.h"
#import "Styles.h"

@implementation HamBurgerMenuView

- (id)initWithFrame:(CGRect)frame withMenu:(NSArray*) menus handler:(id<HamBurgerMenuHandler>) menuHandler;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSMutableArray* menuList = [[NSMutableArray alloc] initWithArray:menus];
                
        float y = 0.0f;
        for(int i=0; i<menuList.count; i++) {
            
            MXButton* menuButton = [[MXButton alloc] initWithFrame:CGRectMake( 0.0f, y, 160.0f, 30.0f)];
            [menuButton setTitle:[menuList objectAtIndex:i] forState:UIControlStateNormal];
            [menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [menuButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            
            UIImage *buttonImagePressed = [UIImage imageNamed:@"grey.png"];
            UIImage *strechableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:12 topCapHeight:0];
            [menuButton setBackgroundImage:strechableButtonImagePressed forState:UIControlStateHighlighted];
            [menuButton addTarget:self action:@selector(menuClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            menuButton.elementId = [[NSString alloc] initWithFormat:@"%d", i ];
            
            [self addSubview:menuButton];
            UIView* line = [[UIView alloc] initWithFrame:CGRectMake( 0.0f, y + 31.0f, 160.0f, 1.0f)];
            line.backgroundColor = [UIColor grayColor];
            [self addSubview:line];
            y = y + 32.0f;
        }
        burgerMenuHandler = menuHandler;
        self.backgroundColor = [Styles menuBackgroundColor];
        
    }
    return self;
}

-(IBAction)menuClicked:(id)sender
{
    MXButton* menuButton = (MXButton*) sender;
    NSLog(@"menuClicked");
    NSLog(@"menu idx selected is %d", [menuButton.elementId   intValue]);
    [burgerMenuHandler menuClicked:[menuButton.elementId   intValue]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
