//
//  ButtonControl.h
//  TestControll
//
//  Created by Ashish Tiwari on 27/06/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchScreenButtonControl : UIButton
{
    NSString *SEARCH_TEXT_FIELD_ID;// = "SEARCH_TEXT_FIELD_ID";
    NSString *SEARCH_BY;// = "SEARCH_BY";
	NSString *SEARCH_TEXT;// = "SEARCH_TEXT";
}


- (void) buttonEvent : (id) sender;
-(void) cancleButtonEvent :(id)sender;


@end
