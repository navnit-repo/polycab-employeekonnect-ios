//
//  MXBarButton.m
//  EMSV3CommonMobilet
//
//  Created by Puneet on 18-May-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MXBarButton.h"


@implementation MXBarButton

@synthesize attachedData;
@synthesize elementId;


-(MXBarButton *) init
{
	self = [super init];
	
	if ( self ) 
	{
		elementId = [[NSString alloc] init];
	    attachedData = [[NSMutableDictionary alloc] init];
	}	
	return self;
}


@end
