//
//  ReportQuantityValue.h
//  QCMSProject
//
//  Created by Pradeep Singh on 9/4/16.
//  Copyright © 2016 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DotForm.h"
#import "DotFormPost.h"
#import "DotFormElement.h"
@interface XmwCompareTupleQV : NSObject
@property NSString* fieldName;

@property NSString* firstValue;
@property NSString* firstQuantity;

@property NSString* secondValue;
@property NSString* secondQuantity;

@property NSString* thirdValue;
@property NSString* thirdQuantity;

@property NSString* uomValue;
@property NSArray* firstRawData;
@property NSArray* secondRawData;
@property NSArray* thirdRawData;

@end




@interface ReportQuantityValue : UIViewController
{
    NSArray* sortedDataSetKeys;
    NSMutableDictionary* dataSet;
}
@property (weak, nonatomic) DotForm* dotForm;

@property (strong, nonatomic) DotFormPost* firstFormPost;
@property (strong, nonatomic) DotFormPost* secondFormPost;
@property (strong, nonatomic) DotFormPost* thirdFormPost;

@property (nonatomic, retain) NSMutableDictionary* forwardedDataDisplay;
@property (nonatomic, retain) NSMutableDictionary* forwardedDataPost;
@property (weak, nonatomic) IBOutlet UITableView* mainTable;
-(NSArray*) pickGoodRawData:(NSArray*) best option:(NSArray*)other1 option:(NSArray*) other2;
-(DotFormPost*)ddColumnDotFormPost:(DotFormPost*) dotFormPost rowIndex:(NSInteger) rowIndex columnRowData:(NSArray*) colRowData;
@end
