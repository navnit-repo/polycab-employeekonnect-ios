//
//  PolycabSearchViewController.m
//  XMWClient
//
//  Created by dotvikios on 22/01/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "PolycabSearchViewController.h"

@implementation PolycabSearchViewController




- (void) doneHandler : (id) sender {
    
    
    if(multiSelectDelegate !=nil&& [multiSelectDelegate respondsToSelector:@selector(multipleItemsSelected::)]
       )
    {
        [multiSelectDelegate multipleItemsSelected:self.searchResponse.searchHeaderDetail   :selectedRows.allValues];
        
    }
    
    
    [ [self navigationController]  popViewControllerAnimated:YES];
    [ [self navigationController]  popViewControllerAnimated:YES];
    
}

@end
