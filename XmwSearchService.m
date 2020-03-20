//
//  XmwSearchService.m
//  QCMSProject
//
//  Created by Pradeep Singh on 4/14/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import "XmwSearchService.h"

#import "XmwcsConstant.h"
#import "SearchResponse.h"

@interface XmwSearchService ()
{
    NetworkHelper* networkHelper;
    void (^success)(DotFormPost*, SearchResponse*);
    void (^failed)(DotFormPost*, NSString* message);
}
@end

@implementation XmwSearchService

-(id) init
{
    self = [super init];
    if(self!=nil) {
        networkHelper = [[NetworkHelper alloc] init];
    }
    return self;
}

-(id) initWithPostData:(DotFormPost*) searchRequest withContext:(NSString*) context
{
    self = [super init];
    
    if(self!=nil) {
        self.searchFormPost = searchRequest;
        self.searchContext = context;
        networkHelper = [[NetworkHelper alloc] init];
    }
    return self;
}

-(void) search:(DotFormPost*) searchRequest success:(void(^)(DotFormPost*, SearchResponse*)) successBlock  fail:(void(^)(DotFormPost*, NSString*))failedBlock
{
    self.searchFormPost = searchRequest;
    success = successBlock;
    failed = failedBlock;
    
    [networkHelper makeXmwNetworkCall:self.searchFormPost :self : nil :XmwcsConst_CALL_NAME_FOR_SEARCH];
}


// assumed, already reportRequest set
-(void) searchUsingSuccess:(void(^)(DotFormPost*, SearchResponse*)) successBlock  fail:(void(^)(DotFormPost*, NSString*))failedBlock
{
    success = successBlock;
    failed = failedBlock;
    
    [networkHelper makeXmwNetworkCall:self.searchFormPost :self :nil :XmwcsConst_CALL_NAME_FOR_SEARCH];
    
}

- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    if([callName isEqualToString:XmwcsConst_CALL_NAME_FOR_SEARCH]) {
        SearchResponse *searchResponse = (SearchResponse*) respondedObject;
        if(success!=nil) {
            success(self.searchFormPost, searchResponse);
        }
    }
}

- (void) httpFailureHandler : (NSString*) callName : (NSString*) message
{
    if([callName isEqualToString:XmwcsConst_CALL_NAME_FOR_SEARCH]) {
        if(failed!=nil) {
            failed(self.searchFormPost, message);
        }
    }
}



@end
