//
//  MXLabel.m
//  XMW Base client
//
//  Created by Ashish Tiwari on 22/05/2013.
//  Copyright (c) 2013 Dotvik Solutions. All rights reserved.
//

#import "MXLabel.h"


@implementation MXLabel


@synthesize elementId;
@synthesize attachedData;

-(MXLabel *) init
{
	self = [super init];
	
	if ( self ) 
	{
		elementId = [[NSString alloc] init];
	}	
	return self;
}
//- (void)drawTextInRect:(CGRect)rect {
//    UIEdgeInsets insets = {0, 8, 0, 5};
//    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
//}
@end
