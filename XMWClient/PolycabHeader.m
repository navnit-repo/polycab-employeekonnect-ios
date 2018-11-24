//
//  PolycabHeader.m
//  XMWClient
//
//  Created by dotvikios on 07/08/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "PolycabHeader.h"

@implementation PolycabHeader
@synthesize menuButton;
+(PolycabHeader*) createInstance

{
    
    PolycabHeader *view = (PolycabHeader *)[[[NSBundle mainBundle] loadNibNamed:@"PolycabHeader" owner:self options:nil] objectAtIndex:0];
    return view;
}


@end
