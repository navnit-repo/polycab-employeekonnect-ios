//
//  SearchRequestItem.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 30/09/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchRequestItem : NSObject

{ @private
    int itemRefId;
	NSString* module;
	NSString* searchId;
	NSString* nameValue;
	NSString* keyValue;
	NSString* createdDate;
}

@property int itemRefId;
@property NSString* module;
@property NSString* searchId;
@property NSString* nameValue;
@property NSString* keyValue;
@property NSString* createdDate;


@end
