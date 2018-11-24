//
//  MenuScreenVC.h
//  Dummy_pro_ashish
//
//  Created by Ashish Tiwari on 08/07/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpEventListener.h"
#import "LoadingView.h"
@interface HavellsMenuScreenVC : UIViewController <HttpEventListener>
{
    int screenId;
    LoadingView* loadingView;
    
}

@property int screenId;

-(IBAction)Logout :(id)sender;
@property (strong, nonatomic) NSString *headerStr;

-(IBAction)ESSButtonPressed:(id)sender;
-(IBAction)SalesButtonPressed:(id)sender;
-(IBAction)WorkFlowButtonPressed:(id)sender;
@property(nonatomic) BOOL menuScreen;
-(void) drawHeaderItem;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
