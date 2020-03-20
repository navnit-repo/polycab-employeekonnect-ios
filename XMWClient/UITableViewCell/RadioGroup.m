//
//  RadioGroup.m
//  TestControll
//
//  Created by Ashish Tiwari on 24/06/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "RadioGroup.h"
#import "RadioButton.h"
#import <QuartzCore/QuartzCore.h>
@implementation RadioGroup

@synthesize displayValueArray;
@synthesize keyArray;
@synthesize selectedIndex;
@synthesize  buttonArray;
@synthesize elementId;
@synthesize selectedKey;




- (id)initWithFrame:(CGRect)frame : (NSArray*) inDisplayValueArray : (NSInteger)  defaultIndex : (NSArray*) inKeyArray
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.displayValueArray = inDisplayValueArray;
        self.keyArray = inKeyArray;
        
        if(defaultIndex >= displayValueArray.count)
            self.selectedIndex = 0;
        else
            self.selectedIndex = defaultIndex;
        
        
        self.selectedKey = [keyArray objectAtIndex:self.selectedIndex];
        
        self.buttonArray = [[NSMutableArray alloc] initWithCapacity:displayValueArray.count];
       

        int j = 0;
        for (int i =0; i<displayValueArray.count; i++,j++)
        {      
             CGRect imageFrame = CGRectMake(10,  j*50, 40, 40);//CGRectMake(0,  i*40, 40, 80);
             CGRect labelFrame = CGRectMake(50,  j*50, 200, 40);//CGRectMake(40, i*40, 200, 40);
           
            
            UILabel *myLabel = [[UILabel alloc] initWithFrame:labelFrame];
            
           
            RadioButton *radioButtonControl = [[RadioButton alloc]initWithFrame:imageFrame :(i == self.selectedIndex) : i]  ;
            
            
            [buttonArray setObject:radioButtonControl atIndexedSubscript:i ];
            
                      //  [radioButtonControl addTarget:self action:@selector(myEvent:) forControlEvents:UIControlEventTouchDown];
            [radioButtonControl addTarget:self action:@selector(myEvent:) forControlEvents:UIControlEventTouchDown];
                        
           // [myLabel setBackgroundColor:[UIColor orangeColor]];
            //[radioButtonControl setBackgroundColor:[UIColor redColor]];
            //[self setBackgroundColor: [UIColor greenColor]];
            NSString *name = [displayValueArray objectAtIndex:i];
            [myLabel setText : name];
           //  myLabel.backgroundColor = [UIColor lightGrayColor];
            
            // Tell the label to use an unlimited number of lines
            
            [self addSubview:myLabel];
            [self addSubview:radioButtonControl];
          
        }
     }
    
    
  
    return self;
}


- (void) myEvent : (id) sender
{
    
    
    RadioButton* selectedButton = (RadioButton*) sender;
    RadioButton *previousSelectedButton =   [buttonArray objectAtIndex:selectedIndex];
    self.selectedIndex = selectedButton.positionInGroup;
    self.selectedKey = [keyArray objectAtIndex:selectedButton.positionInGroup];
    [previousSelectedButton changeToOffState];
    [selectedButton changeToOnState];
      
    
}






@end
