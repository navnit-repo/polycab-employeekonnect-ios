//
//  ProductResponse.h
//  QCMSProject
//
//  Created by Pradeep Singh on 3/24/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONStructure.h"

//
// for product catalog response structure id is 303
//
@interface ProductResponse : NSObject <JSONStructure>
{
@private
    int jsonStructureId;
    NSString* moduleId;
    NSString* sessionDetail;
    NSString*  userId;
    NSMutableArray*  productList;
    
}


@property int jsonStructureId;
@property NSString* moduleId;
@property NSString* sessionDetail;
@property NSString*  userId;
@property NSMutableArray*  productList;

@end
