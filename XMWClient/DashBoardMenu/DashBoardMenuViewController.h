//
//  DashBoardMenuViewController.h
//  UroMedica
//
//  Created by Ashish Tiwari on 30/12/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HamBurgerMenuView.h"
#import "HttpEventListener.h"
#import "LoadingView.h"
#import "ClientVariable.h"
#import "ReportPostResponse.h"
#import "MarqueeLabel.h"



@interface DashBoardMenuViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, HamBurgerMenuHandler,HttpEventListener>
{
    UICollectionView *myCollectionView;
    
    int screenId;
    NSMutableArray *keyIdName;
    NSMutableArray *menuItems;
    
     LoadingView* loadingView;
    
    
    NSMutableArray *secondCellFLippedDataTextArray;
    

}
-(void) humbergerMenuClicked : (int) idx;
-(IBAction)humbergerMenuRemoved:(id)sender;

@property (weak, nonatomic) IBOutlet MarqueeLabel* marqueeText;
@property (weak, nonatomic) IBOutlet UILabel* fyLabel;
@property (strong, nonatomic) NSMutableDictionary *menuDetail;
@property int screenId;
@property(nonatomic) BOOL isFirstScreen;

-(void)fllipedFirstCellCooletionView;

@property ReportPostResponse *forthCellreportPostResData;

@property NSMutableArray *secondCellFLippedDataTextArray;
-(void)secondCellFlippedStartNotifications : (NSNotification*) notification;
@end
