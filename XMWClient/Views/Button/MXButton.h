//
//  MXButton.h
//  XMW Base client
//
//  Created by Ashish Tiwari on 22/05/2013.
//  Copyright (c) 2013 Dotvik Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXButton : UIButton 

@property id parent;
@property (strong, nonatomic) NSString *elementId;

@property (strong, nonatomic) id attachedData;

-(MXButton *) init;

@end
