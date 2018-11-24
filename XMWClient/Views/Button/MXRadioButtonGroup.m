//
//  MXRadioButtonGroup.m
//  EMSV3CommonMobilet
//
//  Created by Puneet on 12-May-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MXRadioButtonGroup.h"
#import "MXButton.h"


@implementation MXRadioButtonGroup


@synthesize radioButtons;
@synthesize simpleFormViewController;
@synthesize isSimpleForm;


- (id)initWithFrame:(CGRect)frame andOptions:(NSArray *)options andColumns:(int)columns andButtonData:(NSMutableDictionary *) buttonData
{	
	NSMutableArray *arrTemp =[[NSMutableArray alloc]init];
	self.radioButtons =	arrTemp;
	//[arrTemp release];
	
    if (self = [super initWithFrame:frame]) 
	{
        // Initialization code
		int framex =0;
		framex= frame.size.width/columns;
		int framey = 0;
		framey = frame.size.height/([options count]/(columns));
		int rem =[options count]%columns;
		if(rem !=0){
			framey = frame.size.height/(([options count]/columns)+1);
		}
		int k = 0;
		for(int i=0;i<([options count]/columns);i++)
		{
			for(int j=0; j< columns; j++)
			{				
			    int x = framex*0.25;
				int y = framey*0.25;
				MXButton *btTemp = [[MXButton alloc]initWithFrame:CGRectMake(framex*j+x, framey*i+y, framex/2+x, framey/2+y)];
				[btTemp addTarget:self action:@selector(radioButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
				btTemp.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
				[btTemp setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];				
			    [btTemp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
				btTemp.elementId = [options objectAtIndex:k];
				btTemp.titleLabel.font =[UIFont systemFontOfSize:14.f];

				[btTemp setTitle:(NSString *)[buttonData objectForKey:[options objectAtIndex:k]] forState:UIControlStateNormal];
				
				[self.radioButtons addObject:btTemp];
				[self addSubview:btTemp];
		        //[btTemp release];
				k++;
				
			}
		}
		
		for(int j=0;j<rem;j++)
		{			
			int x = framex*0.25;
			int y = framey*0.25;
			MXButton *btTemp = [[MXButton alloc]initWithFrame:CGRectMake(framex*j+x, framey*([options count]/columns), framex/2+x, framey/2+y)];
			[btTemp addTarget:self action:@selector(radioButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
			btTemp.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
			[btTemp setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];			
			[btTemp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			btTemp.elementId = [options objectAtIndex:k];
			btTemp.titleLabel.font =[UIFont systemFontOfSize:14.f];
			
			[btTemp setTitle:(NSString *)[buttonData objectForKey:[options objectAtIndex:k]]  forState:UIControlStateNormal];
			
			[self.radioButtons addObject:btTemp];
			[self addSubview:btTemp];
			//[btTemp release];
			k++;
		}	
		
	}
    return self;
}

/*- (void)dealloc
{
	[radioButtons release];
    [super dealloc];
}
*/
-(IBAction) radioButtonClicked:(UIButton *) sender
{
	for(int i=0;i<[self.radioButtons count];i++){
		[[self.radioButtons objectAtIndex:i] setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
		[[self.radioButtons objectAtIndex:i] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	}
	[sender setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
	[sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
	
	if (isSimpleForm) 
	{
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            
        }
			//formController_Pad.selectedRadioKey = ((MXButton *)sender).keyValue;
		else 
			simpleFormViewController.selectedRadioKey = ((MXButton *)sender).elementId;
	}
	else
	{
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            
        }
	}
}

-(void) removeButtonAtIndex:(int)index
{
	[[self.radioButtons objectAtIndex:index] removeFromSuperview];	
}

-(void) setSelected:(int) index
{
	for(int i=0;i<[self.radioButtons count];i++)
	{
		[[self.radioButtons objectAtIndex:i] setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
		[[self.radioButtons objectAtIndex:i] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	}
	[[self.radioButtons objectAtIndex:index] setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
	[[self.radioButtons objectAtIndex:index] setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
	
	if (isSimpleForm) 
	{
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            
        }
			
		else 
			simpleFormViewController.selectedRadioKey = ((MXButton *)[self.radioButtons objectAtIndex:index]).elementId;
	}
	else
	{
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            
        }
    }
		
	
}

-(void)clearAll
{
	for(int i=0;i<[self.radioButtons count];i++)
	{
		[[self.radioButtons objectAtIndex:i] setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];		
	}
}

@end

