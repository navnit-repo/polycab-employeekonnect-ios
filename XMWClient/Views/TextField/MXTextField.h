//
//  MXTextField.h
//  XMW Base client
//
//  Created by Ashish Tiwari on 22/05/2013.
//  Copyright (c) 2013 Dotvik Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MXTextField : UITextField <UITextFieldDelegate>

//@property (strong, nonatomic) NSString *textValue;

@property (strong, nonatomic) NSString *elementId;

@property (strong, nonatomic) NSString *attachedData;

@property(strong, nonatomic) NSString *keyvalue;
//@property(strong, nonatomic) NSString *text;

-(MXTextField *) init;

@end
