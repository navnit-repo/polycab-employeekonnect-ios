//
//  MXButton.m
//  XMW Base client
//
//  Created by Ashish Tiwari on 22/05/2013.
//  Copyright (c) 2013 Dotvik Solutions. All rights reserved.
//

#import "MXButton.h"

@implementation MXButton

@synthesize parent;
@synthesize elementId;
@synthesize sortButtonDataType;
@synthesize attachedData;
@synthesize buttonClickFlag;

-(MXButton *) init
{
	self = [super init];
	
	if ( self ) 
	{
		elementId    = [[NSString alloc] init];
        sortButtonDataType = [[NSString alloc] init];
	}	
	return self;
}

@end
