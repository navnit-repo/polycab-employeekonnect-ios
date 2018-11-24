//
//  GoldCardTableFormDelegate.m
//  QCMSProject
//
//  Created by Pradeep Singh on 6/7/16.
//  Copyright © 2016 dotvik. All rights reserved.
//

#import "GoldCardTableFormDelegate.h"


@interface GoldCardTableFormDelegate ()
{
     CGFloat columnOffsets[10];
}

@end


@implementation GoldCardTableFormDelegate


-(id)init
{
    self  = [super init];
    
    columnOffsets[0] = 0.0f;
    columnOffsets[1] = 30.0f;
    columnOffsets[2] = 100.0f;
    columnOffsets[3] = 190.0f;
    columnOffsets[4] = 330.0f;
    columnOffsets[5] = 430.0f;
    columnOffsets[6] = 530.0f;
    columnOffsets[7] = 600.0f;
    columnOffsets[8] = 670.0f;
    columnOffsets[9] = 740.0f;
    
    return self;
    
}


-(CGFloat) columnOffsetForColumn:(int) colIdx
{
    if(colIdx<10) {
        return columnOffsets[colIdx];
    } else {
        return columnOffsets[9] + (11-colIdx)*70.0f;
    }
}





@end
