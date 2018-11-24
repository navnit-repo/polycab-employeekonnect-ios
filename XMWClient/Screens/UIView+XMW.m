//
//  UIView+XMW.m
//  QCMSProject
//
//  Created by Pradeep Singh on 2/23/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//

#import "UIView+XMW.h"
#import <objc/runtime.h>

@implementation UIView (XMW)


- (NSString*)elementId;
{
    return objc_getAssociatedObject(self, "elementId");
}

- (void)setElementId:(NSString*)property;
{
    objc_setAssociatedObject(self, "elementId", property, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
