//
//  DotHAxis.m
//  QCMSProject
//
//  Created by Pradeep Singh on 1/26/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import "DotHAxis.h"


void draw1PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color)
{
    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, startPoint.x + 0.5, startPoint.y + 0.5);
    CGContextAddLineToPoint(context, endPoint.x + 0.5, endPoint.y + 0.5);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}


void drawAxisMajorTicks(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color, int parts, int height)
{
    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetLineWidth(context, 1.0);
    
    
    CGContextMoveToPoint(context, startPoint.x + 0.5, startPoint.y + 0.5);
    
    float tickGap = (endPoint.x - startPoint.x)/parts;
    
    for(int i=0; i<=parts; i++) {
        CGContextMoveToPoint(context, startPoint.x + tickGap*i, startPoint.y + 0.5);
        CGContextAddLineToPoint(context, startPoint.x + tickGap*i, startPoint.y - height );
        CGContextStrokePath(context);
    }

    CGContextRestoreGState(context);
}


void drawAxisTextOnMajorTicks(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color, int parts, int height, double minValue, double maxValue)
{
    CGContextSaveGState(context);
    
    float tickGap = (endPoint.x - startPoint.x)/parts;
    
    CGRect textFrame;
    
    for(int i=0; i<=parts; i++) {
        
        if(i==0) {
            textFrame = CGRectMake(startPoint.x + tickGap*i , startPoint.y - height - 20, 50, 20);
        } else if(i==parts) {
            textFrame = CGRectMake(startPoint.x - 50 + tickGap*i , startPoint.y - height - 20, 50, 20);
        } else {
            textFrame = CGRectMake(startPoint.x - 25 + tickGap*i , startPoint.y - height - 20, 50, 20);
        }
        
        if(i==0) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setAlignment:NSTextAlignmentLeft];
            
            NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:paragraphStyle,
                                        NSParagraphStyleAttributeName, [UIFont systemFontOfSize:12.0], NSFontAttributeName, nil];
            
            NSString* textToDisplay  = [NSString stringWithFormat:@"%.00f", (minValue + i*(maxValue - minValue)/parts) ];
            [textToDisplay drawInRect:textFrame withAttributes:attributes];
        } else if(i==parts) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setAlignment:NSTextAlignmentRight];
            
            NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:paragraphStyle,
                                        NSParagraphStyleAttributeName, [UIFont systemFontOfSize:12.0], NSFontAttributeName, nil];
            
            NSString* textToDisplay  = [NSString stringWithFormat:@"%.00f", (minValue + i*(maxValue - minValue)/parts) ];
            [textToDisplay drawInRect:textFrame withAttributes:attributes];
        } else {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setAlignment:NSTextAlignmentRight];
            
            NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:paragraphStyle,
                                        NSParagraphStyleAttributeName, [UIFont systemFontOfSize:12.0], NSFontAttributeName, nil];
            
            NSString* textToDisplay  = [NSString stringWithFormat:@"%.00f", (minValue + i*(maxValue - minValue)/parts) ];
            [textToDisplay drawInRect:textFrame withAttributes:attributes];
        }
        
    }
    
    CGContextRestoreGState(context);
    
}


void drawAxisTextOnFirstAndLastTick(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color, int parts, int height, double minValue, double maxValue)
{
    CGContextSaveGState(context);
    
    CGRect textFrame;
    
    textFrame = CGRectMake(startPoint.x+5, startPoint.y - height - 15, 100, 20);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:paragraphStyle,
                                NSParagraphStyleAttributeName, [UIFont systemFontOfSize:12.0], NSFontAttributeName, nil];
    
    NSString* textToDisplay  = [NSString stringWithFormat:@"%.00f", minValue ];
    [textToDisplay drawInRect:textFrame withAttributes:attributes];
    
    
    textFrame = CGRectMake(endPoint.x - 105, startPoint.y - height - 15, 100, 20);

    
    paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentRight];
    
    attributes = [NSDictionary dictionaryWithObjectsAndKeys:paragraphStyle,
                                NSParagraphStyleAttributeName, [UIFont systemFontOfSize:12.0], NSFontAttributeName, nil];
    
    textToDisplay  = [NSString stringWithFormat:@"%.00f", maxValue ];
    [textToDisplay drawInRect:textFrame withAttributes:attributes];

    
    CGContextRestoreGState(context);
    
}


void drawAxisTextOnMinorTicks(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color, int parts, int height, double minValue, double maxValue)
{
    CGContextSaveGState(context);
    
    float tickGap = (endPoint.x - startPoint.x)/parts;
    
    CGRect textFrame;
    
    for(int i=1; i<parts; i++) {
        textFrame = CGRectMake(startPoint.x + tickGap*i - 25 , startPoint.y - height - 15, 50, 20);
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:paragraphStyle,
                                    NSParagraphStyleAttributeName, [UIFont systemFontOfSize:12.0], NSFontAttributeName, nil];
        
        NSString* textToDisplay  = [NSString stringWithFormat:@"%.00f", (minValue + i*(maxValue - minValue)/parts) ];
        [textToDisplay drawInRect:textFrame withAttributes:attributes];
        
    }
    
    CGContextRestoreGState(context);
}

/*
 *  System Versioning Preprocessor Macros
 */

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)




@implementation DotHAxis


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
    const BOOL anyAxisToDraw = (self.maxValue > 0.0);
    
    if (anyAxisToDraw)
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        const CGFloat marginToDrawInside = 5.0;
        const CGRect rectToDraw = CGRectInset(rect, 0, marginToDrawInside);
        

        
       //  UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:rectToDraw byRoundingCorners:(UIRectCorner)UIRectCornerAllCorners cornerRadii:CGSizeMake(SDFilterBadgeViewCornerRadius, SDFilterBadgeViewCornerRadius)];
        
        /* Background and shadow */
        CGContextSaveGState(ctx);
        {
          //  CGContextAddPath(ctx, borderPath.CGPath);
            
          //  CGContextSetFillColorWithColor(ctx, self.badgeBackgroundColor.CGColor);
          //  CGContextSetShadowWithColor(ctx, self.badgeShadowSize, SDFilterBadgeViewShadowRadius, self.badgeShadowColor.CGColor);
            
          //  CGContextDrawPath(ctx, kCGPathFill);
        }
        CGContextRestoreGState(ctx);
        
        // const BOOL colorForOverlayPresent = self.badgeOverlayColor && ![self.badgeOverlayColor isEqual:[UIColor clearColor]];
        

        
        /* Text */
        
        CGContextSaveGState(ctx);
        {
           // CGContextSetFillColorWithColor(ctx, self.badgeTextColor.CGColor);
           //  CGContextSetShadowWithColor(ctx, self.badgeTextShadowOffset, 1.0, self.badgeTextShadowColor.CGColor);
            
            CGRect textFrame = rectToDraw;
           const CGSize textSize = CGSizeMake(15.0, 30);
            
            textFrame.size.height = textSize.height;
            textFrame.origin.y = rectToDraw.origin.y;
            
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                // textFrame.origin.y += 5.0;
                
                NSDictionary *attributes = nil;
                NSMutableParagraphStyle *paragraphStyle;
                
                paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setAlignment:NSTextAlignmentCenter];
                // paragraphStyle setLineBreakMode:NSLine
                
               attributes = [NSDictionary dictionaryWithObjectsAndKeys:paragraphStyle,
                              NSParagraphStyleAttributeName, [UIFont systemFontOfSize:11.0], NSFontAttributeName,  nil];
                
                [self.displayText drawInRect:textFrame withAttributes:attributes];
            } else {
                [self.displayText drawInRect:textFrame
                                  withFont:[UIFont systemFontOfSize:11]
                             lineBreakMode:NSLineBreakByClipping
                                 alignment:NSTextAlignmentCenter];
                 
            }
        }
        CGContextRestoreGState(ctx);
        
        
        draw1PxStroke(ctx, CGPointMake(0, self.frame.size.height-2), CGPointMake(self.frame.size.width, self.frame.size.height-2), [UIColor blackColor].CGColor);
        
        drawAxisMajorTicks(ctx, CGPointMake(0, self.frame.size.height-2), CGPointMake(self.frame.size.width, self.frame.size.height-2), [UIColor blackColor].CGColor, self.parts, 5);
        
        if(self.isDescending==NO) {
            drawAxisTextOnFirstAndLastTick(ctx, CGPointMake(0, self.frame.size.height-2), CGPointMake(self.frame.size.width, self.frame.size.height-2), [UIColor blackColor].CGColor, self.parts, 5, self.minValue, self.maxValue);
            
            drawAxisTextOnMinorTicks(ctx, CGPointMake(0, self.frame.size.height-2), CGPointMake(self.frame.size.width, self.frame.size.height-2), [UIColor blackColor].CGColor, self.parts, 5, self.minValue, self.maxValue);
        } else {
            drawAxisTextOnFirstAndLastTick(ctx, CGPointMake(0, self.frame.size.height-2), CGPointMake(self.frame.size.width, self.frame.size.height-2), [UIColor blackColor].CGColor, self.parts, 5, self.maxValue, self.minValue);
            drawAxisTextOnMinorTicks(ctx, CGPointMake(0, self.frame.size.height-2), CGPointMake(self.frame.size.width, self.frame.size.height-2), [UIColor blackColor].CGColor, self.parts, 5, self.maxValue, self.minValue);
        }
    }
    
}




@end
