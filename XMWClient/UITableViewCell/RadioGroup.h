//
//  RadioGroup.h
//  TestControll
//
//  Created by Ashish Tiwari on 24/06/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RadioGroup : UIView
{
    NSArray* displayValueArray;
    NSArray* keyArray;
    NSMutableArray* buttonArray;
    NSInteger selectedIndex;
    NSString* elementId;
    NSString* selectedKey;
    
}
@property NSString* selectedKey;
@property(nonatomic,retain) NSArray* displayValueArray;
@property(nonatomic,retain) NSArray* keyArray;

@property (nonatomic ,assign) NSInteger selectedIndex;
@property(nonatomic , retain)NSMutableArray *buttonArray;
@property NSString* elementId;

- (id)initWithFrame:(CGRect)frame : (NSArray*) inDisplayValueArray : (NSInteger)  defaultIndex : (NSArray*) inKeyArray ;

@end
