//
//  SearchResponse.h
//  QCMSProject
//
//  Created by Ashish Tiwari on 11/06/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Network/JSONStructure.h"
//#import "JSONStructure.h"

@interface SearchResponse : NSObject <JSONStructure>
{


@private
    int jsonStructureId;
    NSString *searchMessage;
    NSString *searchDataForSubmit;
    NSMutableArray *searchHeaderDetail;
    NSMutableArray *searchDataForDisplay;
    NSMutableArray *searchRecord ;

}

@property NSString *searchMessage;
@property NSString *searchDataForSubmit;
@property NSMutableArray *searchHeaderDetail;
@property NSMutableArray *searchDataForDisplay;
@property NSMutableArray *searchRecord ;






@end
