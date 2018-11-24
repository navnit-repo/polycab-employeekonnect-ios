//
//  main.m
//  XMWClient
//
//  Created by Pradeep Singh on 5/22/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DVAppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        int retval;
        
        @try{
            retval = UIApplicationMain(argc, argv, nil, NSStringFromClass([DVAppDelegate class]));
        }
        @catch (NSException *exception)
        {
            NSLog(@"Gosh!!! %@", [exception callStackSymbols]);
            @throw;
        }
        return retval;
    }
}
