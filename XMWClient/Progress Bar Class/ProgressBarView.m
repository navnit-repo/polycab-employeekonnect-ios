//
//  ProgressBarView.m
//  XMWClient
//
//  Created by dotvikios on 12/09/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "ProgressBarView.h"
CGPathRef ProgressNewPathWithRoundRect(CGRect rect, CGFloat cornerRadius)
{
    //
    // Create the boundary path
    //
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL,
                      rect.origin.x,
                      rect.origin.y + rect.size.height - cornerRadius);
    
    // Top left corner
    CGPathAddArcToPoint(path, NULL,
                        rect.origin.x,
                        rect.origin.y,
                        rect.origin.x + rect.size.width,
                        rect.origin.y,
                        cornerRadius);
    
    // Top right corner
    CGPathAddArcToPoint(path, NULL,
                        rect.origin.x + rect.size.width,
                        rect.origin.y,
                        rect.origin.x + rect.size.width,
                        rect.origin.y + rect.size.height,
                        cornerRadius);
    
    // Bottom right corner
    CGPathAddArcToPoint(path, NULL,
                        rect.origin.x + rect.size.width,
                        rect.origin.y + rect.size.height,
                        rect.origin.x,
                        rect.origin.y + rect.size.height,
                        cornerRadius);
    
    // Bottom left corner
    CGPathAddArcToPoint(path, NULL,
                        rect.origin.x,
                        rect.origin.y + rect.size.height,
                        rect.origin.x,
                        rect.origin.y,
                        cornerRadius);
    
    // Close the path at the rounded rect
    CGPathCloseSubpath(path);
    
    return path;
}

@implementation ProgressBarView

+ (id)progressBarViewInView:(UIView *)aSuperview{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    ProgressBarView *loadingView = [[ProgressBarView alloc] initWithFrame:[aSuperview bounds]];
    
    if (!loadingView)
        return nil;
    
    loadingView.opaque = NO;
    loadingView.autoresizingMask =    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [aSuperview addSubview:loadingView];
    
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loadingView addSubview:activityIndicatorView];
    activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |    UIViewAutoresizingFlexibleBottomMargin;
    [activityIndicatorView startAnimating];
    
   
    
    CGRect activityIndicatorRect = activityIndicatorView.frame;
    activityIndicatorRect.origin.x = 0.5 * (loadingView.frame.size.width - activityIndicatorRect.size.width);
    activityIndicatorRect.origin.y =  loadingView.frame.size.height/2;
    activityIndicatorView.frame = activityIndicatorRect;
    
    // Set up the fade-in animation
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    [[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];
    
    return loadingView;
}
// Animates the view out from the superview. As the view is removed from the
// superview, it will be released.
//
- (void)removeView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    UIView *aSuperview = [self superview];
    [super removeFromSuperview];
    
    // Set up the animation
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    
    [[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];
}
// Draw the view.
//
- (void)drawRect:(CGRect)rect
{
    rect.size.height -= 1;
    rect.size.width -= 1;
    
    const CGFloat RECT_PADDING = 8.0;
    rect = CGRectInset(rect, RECT_PADDING, RECT_PADDING);
    
    const CGFloat ROUND_RECT_CORNER_RADIUS = 5.0;
    CGPathRef roundRectPath = ProgressNewPathWithRoundRect(rect, ROUND_RECT_CORNER_RADIUS);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    const CGFloat BACKGROUND_OPACITY = 0.5;
    CGContextSetRGBFillColor(context, 0, 0, 0, BACKGROUND_OPACITY);
    CGContextAddPath(context, roundRectPath);
    CGContextFillPath(context);
    
    const CGFloat STROKE_OPACITY = 0.25;
    CGContextSetRGBStrokeColor(context, 1, 1, 1, STROKE_OPACITY);
    CGContextAddPath(context, roundRectPath);
    CGContextStrokePath(context);
    
    CGPathRelease(roundRectPath);
}


@end
