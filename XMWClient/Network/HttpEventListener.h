//
//  HttpEventListener.h
//  QCMSProject
//
//  Created by Pradeep Singh on 7/10/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HttpEventListener <NSObject>

- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject;
- (void) httpFailureHandler : (NSString*) callName : (NSString*) message;
- (void) httpServerSessionExpired;

@end
