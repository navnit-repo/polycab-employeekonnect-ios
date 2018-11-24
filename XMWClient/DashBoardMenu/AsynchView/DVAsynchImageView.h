//
//  DVAsynchImageView.h
//  AsynchImageLoaderSample
//
//  Created by Pradeep Singh on 1/9/14.
//  Copyright (c) 2014 Dotvik Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DVAsynchImageView : UIImageView <NSURLConnectionDelegate>
{
    NSMutableData* responseData;
}

-(void) getImage:(NSString*) urlString;

@end
