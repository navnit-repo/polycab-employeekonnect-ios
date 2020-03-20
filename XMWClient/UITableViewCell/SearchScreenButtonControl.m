//
//  ButtonControl.m
//  TestControll
//
//  Created by Ashish Tiwari on 27/06/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "SearchScreenButtonControl.h"
#import "DotFormPost.h"
#import "SearchTextField.h"

@implementation SearchScreenButtonControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    [super sendAction:action to:target forEvent:event];
    
    
}
- (void) buttonEvent : (id) sender
{    DotFormPost *formPost = [[DotFormPost alloc]init];
  
  /*  UITextField * searchTextField = (UITextField *) this.getDataFromId(DotSearchComponent.SEARCH_TEXT_FIELD_ID);
    
        
    
    formPost.getPostData().put(DotSearchComponent.SEARCH_TEXT, dotTextField.getText());
    [formPost.postData setObject:id forKey:<#(id<NSCopying>)#>];
    formPost.getPostData().put(DotSearchComponent.SEARCH_BY, "SBC");
    [formPost.postData setObject:searchTextField forKey:<#(id<NSCopying>)#>]
    
    formPost.setModule(ClientVariable.CLIENT_LOGIN_RESPONSE.getUserModule());
    formPost.setDocId(DotSearchComponent.SEARCH_MASTER_ID);
    dotSearchComponent.dispose();
    networkCall(dotFormPost, this, XmwcsConstant.CALL_NAME_FOR_SEARCH);
   */   
}
-(void) cancleButtonEvent :(id)sender
{
   
}




@end
