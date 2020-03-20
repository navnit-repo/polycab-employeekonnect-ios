//
//  RadioButton.m
//  TestControll
//
//  Created by Ashish Tiwari on 25/06/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "RadioButton.h"

@implementation RadioButton


@synthesize state;

bool isSelected;
@synthesize positionInGroup;


- (id)initWithFrame:(CGRect)frame : (BOOL) selected :  (NSInteger) pos
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.state = selected;
        self.positionInGroup = pos;
        
        
        
        CGRect imageFrame = CGRectMake(0, 0 , 40, 40);
        UIImageView *myImage =  [[UIImageView alloc]initWithFrame:imageFrame];
        if(selected == YES)
        {
           myImage.image=[UIImage imageNamed:@"radio-on.png"];
        }
        else
         myImage.image=[UIImage imageNamed:@"radio-off.png"];
        
        [self addSubview : myImage];
       
        // Initialization code
       // [self addTarget:self action:@selector(myEvent:) forControlEvents:UIControlEventTouchDown];
    
            }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    [super sendAction:action to:target forEvent:event];
    
   
}


- (void) myEvent : (id) sender 
{
    NSLog(@"I am inside myEvent");
    
  
    
            
    NSArray* subViewArray = [self  subviews];
    for(int idx = 0; idx < subViewArray.count; idx++) {
       UIView* childView = (UIView*)[subViewArray objectAtIndex:idx];
       [childView removeFromSuperview];
    }
      
          
   
    CGRect imageFrame = CGRectMake(0, 0 , 40, 40);
    UIImageView *myImage =  [[UIImageView alloc]initWithFrame:imageFrame];
    myImage.image=[UIImage imageNamed:@"radio-on.png"];
    [myImage removeFromSuperview];

    
    [self addSubview : myImage];
    
    
    
    
    
}

-(void)changeToOffState
{
    self.state = NO;
    
    NSArray* subViewArray = [self  subviews];
    for(int idx = 0; idx < subViewArray.count; idx++) {
        UIView* childView = (UIView*)[subViewArray objectAtIndex:idx];
        [childView removeFromSuperview];
    }

        
    
    CGRect imageFrame = CGRectMake(0, 0 , 40, 40);
    UIImageView *myImage =  [[UIImageView alloc]initWithFrame:imageFrame];
    myImage.image=[UIImage imageNamed:@"radio-off.png"];
    [myImage removeFromSuperview];
    
    
    [self addSubview : myImage];

    
    
}
-(void)changeToOnState
{
    self.state = YES;
    NSArray* subViewArray = [self  subviews];
    for(int idx = 0; idx < subViewArray.count; idx++) {
        UIView* childView = (UIView*)[subViewArray objectAtIndex:idx];
        [childView removeFromSuperview];
    }
    
    
    
    CGRect imageFrame = CGRectMake(0, 0 , 40, 40);
    UIImageView *myImage =  [[UIImageView alloc]initWithFrame:imageFrame];
    myImage.image=[UIImage imageNamed:@"radio-on.png"];
    [myImage removeFromSuperview];
    
    
    [self addSubview : myImage];
    

    
    
}


@end
