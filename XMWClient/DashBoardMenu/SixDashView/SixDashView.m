//
//  SixDashView.m
//  QCMSProject
//
//  Created by Ashish Tiwari on 14/01/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import "SixDashView.h"
#import "LoadingView.h"
#import "NetworkHelper.h"


@interface SixDashView ()
{
    LoadingView* loadingView;
    NetworkHelper* networkHelper;
}

@end


@implementation SixDashView
@synthesize menuLblName;
@synthesize menuIconImage;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        
              
        
    }
    return self;
}

+(SixDashView*) createInstance
{
    
    SixDashView *view = (SixDashView *)[[[NSBundle mainBundle] loadNibNamed:@"SixDashView" owner:self options:nil] objectAtIndex:0];
    
    
    return view;
}

- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject {
    [loadingView removeFromSuperview];
    if(respondedObject)
    {
        NSLog(@"SetData on Fifth cell of DashBoard");
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
