//
//  MXBarButton.h
//  EMSV3CommonMobilet
//
//  Created by Puneet on 18-May-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MXBarButton : UIBarButtonItem {

	NSString *elementId;
	
	NSMutableDictionary *attachedData;
}

@property (nonatomic, retain) NSString *elementId;
@property (nonatomic, retain) NSMutableDictionary *attachedData;

-(MXBarButton *) init;

@end
