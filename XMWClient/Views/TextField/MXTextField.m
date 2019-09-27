//
//  MXTextField.m
//  XMW Base client
//
//  Created by Ashish Tiwari on 22/05/2013.
//  Copyright (c) 2013 Dotvik Solutions. All rights reserved.
//

#import "MXTextField.h"

@implementation MXTextField

//@synthesize textValue;
@synthesize elementId;
@synthesize attachedData;
@synthesize keyvalue;
//@synthesize text;


-(MXTextField *) init
{
	self = [super init];	
	if ( self ) 
	{
		//textValue	= [[NSString alloc] init];
		//elementId	= [[NSString alloc] init];
	}	
	return self;
}


- (CGRect) rightViewRectForBounds:(CGRect)bounds {
 CGRect textRect = [super rightViewRectForBounds:bounds];
    if (@available(iOS 13.0, *)) {
           
        textRect.origin.x -= 10;
        return textRect;
       } else {
           
         return textRect;
       }

}
@end
