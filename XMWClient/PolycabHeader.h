//
//  PolycabHeader.h
//  XMWClient
//
//  Created by dotvikios on 07/08/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PolycabHeader : UIView
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
+(PolycabHeader*) createInstance;
@end
