//
//  DocPostResponse.h
//  QCMSProject
//
//  Created by Pradeep Singh on 5/21/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Network/JSONStructure.h"

@interface DocPostResponse : NSObject <JSONStructure>
{
@private
    int jsonStructureId;
    
    NSString* trackerNumber;
    NSString* submittedMessage;
    NSString* submitStatus; //S-->Success, E-->Error(Error in Submission but Submitted Successfully), W--> Warning in Submission but Submitted Successfully
    //EXCEPTION if the Exception is getting some where that handled in code, 1--> default
    
    NSDictionary* submittedData;

}


@property NSString* trackerNumber;
@property NSString* submittedMessage;
@property NSString* submitStatus;
@property NSDictionary* submittedData;




@end
