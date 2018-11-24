//
//  XmwReportService.m
//  QCMSProject
//
//  Created by Pradeep Singh on 1/18/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import "XmwReportService.h"
#import "XmwcsConstant.h"
#import "ReportPostResponse.h"

@interface XmwReportService ()
{
    NetworkHelper* networkHelper;
    void (^success)(DotFormPost*, ReportPostResponse*);
    void (^failed)(DotFormPost*, NSString* message);
}
@end

@implementation XmwReportService

-(id) init
{
    self = [super init];
    if(self!=nil) {
        networkHelper = [[NetworkHelper alloc] init];
    }
    return self;
}

-(id) initWithPostData:(DotFormPost*) reportRequest withContext:(NSString*) context
{
    self = [super init];
    
    if(self!=nil) {
        self.reportFormPost = reportRequest;
        self.reportContext = context;
        networkHelper = [[NetworkHelper alloc] init];
    }
    return self;
}

-(void) fetchReport:(DotFormPost*) reportRequest success:(void(^)(DotFormPost*, ReportPostResponse*)) successBlock  fail:(void(^)(DotFormPost*, NSString*))failedBlock
{
    self.reportFormPost = reportRequest;
    success = successBlock;
    failed = failedBlock;
    
    [networkHelper makeXmwNetworkCall:self.reportFormPost :self : nil :XmwcsConst_CALL_NAME_FOR_REPORT];
}


// assumed, already reportRequest set
-(void) fetchReportUsingSuccess:(void(^)(DotFormPost*, ReportPostResponse*)) successBlock  fail:(void(^)(DotFormPost*, NSString*))failedBlock
{
    success = successBlock;
    failed = failedBlock;
    
    [networkHelper makeXmwNetworkCall:self.reportFormPost :self :nil :XmwcsConst_CALL_NAME_FOR_REPORT];
    
}

- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    if([callName isEqualToString:XmwcsConst_CALL_NAME_FOR_REPORT]) {
        ReportPostResponse *reportPostResponse = (ReportPostResponse*) respondedObject;
        if(success!=nil) {
            success(self.reportFormPost, reportPostResponse);
        }
    }
}

- (void) httpFailureHandler : (NSString*) callName : (NSString*) message
{
    if([callName isEqualToString:XmwcsConst_CALL_NAME_FOR_REPORT]) {
        if(failed!=nil) {
            failed(self.reportFormPost, message);
        }
    }
}



@end
