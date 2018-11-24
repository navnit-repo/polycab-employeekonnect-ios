//
//  MXLabel.h
//  XMW Base client
//
//  Created by Ashish Tiwari on 22/05/2013.
//  Copyright (c) 2013 Dotvik Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MXLabel : UILabel {
	
	NSString *elementId;
}

@property (nonatomic, retain) NSString *elementId;
@property (nonatomic, retain) NSString *attachedData;

-(MXLabel *) init;

@end
