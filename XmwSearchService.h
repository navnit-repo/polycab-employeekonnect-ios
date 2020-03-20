//
//  XmwSearchService.h
//  QCMSProject
//
//  Created by Pradeep Singh on 4/14/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DotFormPost.h"
#import "NetworkHelper.h"
#import "SearchResponse.h"

@interface XmwSearchService : NSObject <HttpEventListener>

@property (weak, nonatomic) DotFormPost* searchFormPost;
@property (weak, nonatomic) NSString* searchContext;


-(id) initWithPostData:(DotFormPost*) searchRequest withContext:(NSString*) context;

-(void) search:(DotFormPost*) searchRequest success:(void(^)(DotFormPost*, SearchResponse*)) successBlock  fail:(void(^)(DotFormPost*, NSString*))failedBlock;

-(void) searchUsingSuccess:(void(^)(DotFormPost*, SearchResponse*)) successBlock  fail:(void(^)(DotFormPost*, NSString*))failedBlock;


@end
