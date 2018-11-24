//
//  XMWTableFormDelegate.h
//  QCMSProject
//
//  Created by Pradeep Singh on 4/11/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DVTableFormView.h"
#import "DotFormElement.h"
#import "SearchFormControl.h"
@class FormVC;

@interface XMWTableFormDelegate : NSObject <DVTableFormRowDelegate, DVTableFormColumnDelegate, SearchViewMultiSelectDelegate>
{
    FormVC* formViewController;
}

@property FormVC* formViewController;
@property NSInteger maxColumns;


-(id) init;
-(DVTableFormView*) ctxTableFormView;
-(NSString*) currentCtx;
-(CGFloat) columnOffsetForColumn:(int) colIdx;
-(void) drawTextField:(UIView*) view :(int) rowIdx :(int) colIdx;
-(void) drawDateField:(UIView*) view :(int) rowIdx :(int) colIdx;
-(void) drawSearchLabelField:(UIView*) view :(int) rowIdx :(int) colIdx;
-(void) drawDropdownField:(UIView*) view :(int) rowIdx :(int) colIdx;
-(void) drawLabelField:(UIView*) view :(int) rowIdx :(int) colIdx;
-(void) removeTextField:(UIView*) view :(int) rowIdx :(int) colIdx;
-(void) removeDateField:(UIView*) view :(int) rowIdx :(int) colIdx;
-(void) removeSearchLabelField:(UIView*) view :(int) rowIdx :(int) colIdx;
-(void) removeDropdownField:(UIView*) view :(int) rowIdx :(int) colIdx;
-(void) removeLabelField:(UIView*) view :(int) rowIdx :(int) colIdx;
-(id) componentAt:(int) rowIdx :(int) colIdx;
-(NSDate*) defaultDate:(DotFormElement*) dotFormElement;
-(NSDate*) dateLowerBound:(DotFormElement*) dotFormElement;
-(NSDate*) dateUpperBound:(DotFormElement*) dotFormElement;
-(IBAction)labelTapHandling:(UITapGestureRecognizer*)sender;
-(IBAction)dateTapHandling:(UITapGestureRecognizer*)sender;
-(void) multipleItemsSelected:(NSArray*) headerData   :(NSArray*) selectedRows;
-(NSArray*) rowDataForSubmit:(UIView*) rowContainer forRow:(int) rowIdx;
@end





