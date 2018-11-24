//
//  SecondDashDataView.m
//  QCMSProject
//
//  Created by Ashish Tiwari on 06/02/15.
//  Copyright (c) 2015 dotvik. All rights reserved.
//

#import "SecondDashDataView.h"

@interface SecondDashDataView ()
{
   
}

@end

@implementation SecondDashDataView
@synthesize dashBoardMenuViewCtrl;
@synthesize setteledLabelValue;
@synthesize achivedLabelValue;
@synthesize targetLabelValue;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        
        
    }
    return self;
}

+(SecondDashDataView*) createInstance
{
    
    SecondDashDataView *view = (SecondDashDataView *)[[[NSBundle mainBundle] loadNibNamed:@"SecondDashDataView" owner:self options:nil] objectAtIndex:0];
    
    
    return view;
}


-(void) updateData
{
        //register Observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSecondCellFlippedDataTextNotifications:) name:@"SET_SECONDCELL_FLIPPED_DATA_TEXT" object:nil];
    
}


-(void)setViewContent
{
    
    
}

-(void)setSecondCellFlippedDataTextNotifications : (NSNotification*) notification //: (NSMutableArray *)dataArray
{
    
   NSMutableArray  *graphDataTextArray =  self.dashBoardMenuViewCtrl.secondCellFLippedDataTextArray;
    if([graphDataTextArray count]>2)
    {
        /*
        NSNumberFormatter *comaFormatter = [[NSNumberFormatter alloc] init];
        [comaFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [comaFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_IN"] ];
        
        self.setteledLabelValue.text = [comaFormatter stringFromNumber:[NSNumber numberWithDouble:round([[graphDataTextArray objectAtIndex:2] doubleValue])]];
        self.achivedLabelValue.text =[comaFormatter stringFromNumber:[NSNumber numberWithDouble:round([[graphDataTextArray objectAtIndex:0] doubleValue])]];
        self.targetLabelValue.text = [comaFormatter stringFromNumber:[NSNumber numberWithDouble:round([[graphDataTextArray objectAtIndex:1] doubleValue])]];
         */
        
       self.setteledLabelValue.text = [NSString stringWithFormat:@"%.2f", [[graphDataTextArray objectAtIndex:2] doubleValue]/100000.0f ];
       self.achivedLabelValue.text = [NSString stringWithFormat:@"%.2f", [[graphDataTextArray objectAtIndex:0] doubleValue]/100000.0f ];
       self.targetLabelValue.text = [NSString stringWithFormat:@"%.2f", [[graphDataTextArray objectAtIndex:1] doubleValue]/100000.0f ];
        
        
    }
    
    
}

@end
