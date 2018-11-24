//
//  ManageSubUserScrennFlow2nd.h
//  XMWClient
//
//  Created by dotvikios on 23/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data.h"

@interface ManageSubUserScrennFlow2nd : UIViewController<DataDelegate>
{
    NSString *authToken;
   
}
@property (weak, nonatomic) IBOutlet UIButton *constantView1;

@property (weak, nonatomic) IBOutlet UIScrollView *constantView2;



@property NSString *authToken;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@end
