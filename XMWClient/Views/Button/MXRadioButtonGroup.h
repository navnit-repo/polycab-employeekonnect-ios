//
//  MXRadioButtonGroup.h
//  EMSV3CommonMobilet
//
//  Created by Puneet on 12-May-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FormVC.h"


@interface MXRadioButtonGroup : UIView {

	NSMutableArray *radioButtons;	
	FormVC *simpleFormViewController;
    BOOL isSimpleForm;
}

@property (nonatomic,retain) NSMutableArray *radioButtons;
@property (nonatomic,retain) FormVC *simpleFormViewController;
@property (nonatomic) BOOL isSimpleForm;


- (id)initWithFrame:(CGRect)frame andOptions:(NSArray *)options andColumns:(int)columns andButtonData:(NSMutableDictionary *) buttonData;

-(IBAction) radioButtonClicked:(UIButton *) sender;

-(void) removeButtonAtIndex:(int)index;
-(void) setSelected:(int) index;
-(void)clearAll;

@end
