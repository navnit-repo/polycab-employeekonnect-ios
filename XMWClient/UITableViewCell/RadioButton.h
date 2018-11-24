//
//  RadioButton.h
//  TestControll
//
//  Created by Ashish Tiwari on 25/06/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioButton : UIControl
{
    BOOL state;

    NSInteger positionInGroup;
}
@property (nonatomic, assign) BOOL state;
@property (nonatomic ,assign) NSInteger positionInGroup;

- (void) myEvent : (id) sender;

- (id)initWithFrame:(CGRect)frame : (BOOL) selected : (NSInteger) pos;

-(void)changeToOffState;
-(void)changeToOnState;





@end
