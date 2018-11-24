//
//  RecentRequestItem.h
//  QCMSProject
//
//  Created by Pradeep Singh on 7/6/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentRequestItem : NSObject
{
@private

    int itemRefId;
	NSString* user;
	NSString* module;
	int maxDocNo;
	NSString* trackerNo;
	NSString* submitDate;
	NSString* status;
	NSString* submittedResponse;
	NSString* formType;
	NSString* formId;
	NSString* dotFormPost;
    
}


@property int itemRefId;
@property NSString* user;
@property NSString* module;
@property int maxDocNo;
@property NSString* trackerNo;
@property NSString* submitDate;
@property NSString* status;
@property NSString* submittedResponse;
@property NSString* formType;
@property NSString* formId;
@property NSString* dotFormPost;




@end
