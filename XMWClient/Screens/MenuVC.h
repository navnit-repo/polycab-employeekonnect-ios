//
//  MenuVC.h
//  EMSSales
//
//  Created by Ashish Tiwari on 07/05/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "HttpEventListener.h"
#import "LoadingView.h"


@class FormPost;
@class Reachability;


@interface MenuVC : UIViewController <UITableViewDelegate, UITableViewDataSource ,HttpEventListener>
{
    NSMutableArray *keyIdName;
	NSMutableArray *menuItems;
    int screenId;
    LoadingView* loadingView;
}

@property (strong, nonatomic) IBOutlet UITableView *menuTableView;

@property (nonatomic) BOOL internetActive;

@property (strong, nonatomic) NSString *headerStr;

@property (strong, nonatomic) NSMutableDictionary *menuDetail;

@property(nonatomic) BOOL isFirstScreen;
@property(nonatomic) BOOL isSecondScreen;
@property int screenId;


-(void) updateNetworkStatus:(Reachability *) curReach;

- (void) backHandler : (id) sender;

-(void) drawHeaderItem;

-(void) getMenuItems;

-(void) getFormType :(NSMutableDictionary *) addedData :(FormPost *)formPost : (BOOL)isFormIsSubForm :(NSMutableDictionary *) dataForNextScrDisplay :(NSMutableDictionary *) dataForNextScrPost;

-(void) postRequest:(NSData *)postData;

-(void) dismissLoadingView;



@end
