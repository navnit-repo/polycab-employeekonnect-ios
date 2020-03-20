//
//  FifthDashView.m
//  QCMSProject
//
//  Created by Ashish Tiwari on 14/01/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import "FifthDashView.h"
#import "LoadingView.h"
#import "NetworkHelper.h"

@interface FifthDashView ()
{
    LoadingView* loadingView;
    NetworkHelper* networkHelper;
}

@end


@implementation FifthDashView
@synthesize dashCellImageIcon;
@synthesize dashCellNameLbl;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
               
    }
    return self;
}

+(FifthDashView*) createInstance
{
    
    FifthDashView *view = (FifthDashView *)[[[NSBundle mainBundle] loadNibNamed:@"FifthDashView" owner:self options:nil] objectAtIndex:0];
    
    
    return view;
}

- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject {
    [loadingView removeFromSuperview];
    if(respondedObject)
    {
        NSLog(@"SetData on Fifth cell of DashBoard");
        if([callName isEqualToString:@"PodiumDataRequest"])
        {
            [self setViewContent:respondedObject];
            
        }
    }
}

- (void) httpFailureHandler : (NSString*) callName : (NSString*) message
{
    [loadingView removeFromSuperview];
    
}

-(void) updateData
{
    
        
}

-(void)setViewContent:(NSMutableDictionary *)data
{
    
}



@end
