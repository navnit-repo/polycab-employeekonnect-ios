//
//  CategoryResponse.h
//  QCMSProject
//
//  Created by Pradeep Singh on 3/24/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONStructure.h"

// jsonstructure id is here 302

@interface CategoryResponse : NSObject <JSONStructure>
{
@private
    int jsonStructureId;
    NSString* moduleId;
    NSString* sessionDetail;
    NSString*  userId;
    NSMutableArray*  categoryList;
    
}

@property int jsonStructureId;
@property NSString* moduleId;
@property NSString* sessionDetail;
@property NSString*  userId;
@property NSMutableArray*  categoryList;

@end
