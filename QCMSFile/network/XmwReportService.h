//
//  XmwReportService.h
//  QCMSProject
//
//  Created by Pradeep Singh on 1/18/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DotFormPost.h"
#import "NetworkHelper.h"
#import "ReportPostResponse.h"

@interface XmwReportService : NSObject <HttpEventListener>

@property (weak, nonatomic) DotFormPost* reportFormPost;
@property (weak, nonatomic) NSString* reportContext;


-(id) initWithPostData:(DotFormPost*) reportRequest withContext:(NSString*) context;

-(void) fetchReport:(DotFormPost*) reportRequest success:(void(^)(DotFormPost*, ReportPostResponse*)) successBlock  fail:(void(^)(DotFormPost*, NSString*))failedBlock;

-(void) fetchReportUsingSuccess:(void(^)(DotFormPost*, ReportPostResponse*)) successBlock  fail:(void(^)(DotFormPost*, NSString*))failedBlock;




@end
