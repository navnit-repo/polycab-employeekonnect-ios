//
//  FunctionMenu.m
//  EMSV3BaseMobilet
//
//  Created by Puneet on 11-Mar-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FunctionMenu.h"
//#import "MitrString.h"


@implementation FunctionMenu


@synthesize userLoginStatus,userLoginMessage,passwrdState,passwrdStateMessage;

@synthesize menuDetail, maxUserDocNumber, serverDateTime;





//@synthesize loginMasterInfo;


-(FunctionMenu *)init
{
	if ( self )
	{
		typeId = 2;
    }	
    return self;
}

-(FunctionMenu *)initWithMitrVector:(NSMutableArray *)funcMenuVec
{
	if ( self ) 
	{
		typeId = 2;
		
		userLoginStatus			= (NSString *)[funcMenuVec mitrElementAt:0] ;
		userLoginMessage		= (NSString *)[funcMenuVec mitrElementAt:1] ;
		passwrdState			= (NSString *)[funcMenuVec mitrElementAt:2] ;
		passwrdStateMessage		= (NSString *)[funcMenuVec mitrElementAt:3] ;
		menuDetail				= (NSMutableDictionary *)[funcMenuVec mitrElementAt:4];
		maxUserDocNumber		= (NSInteger *)[funcMenuVec mitrElementAt:5];
		serverDateTime			= (NSMutableArray *)[funcMenuVec mitrElementAt:6];
		//loginMasterInfo			= (LoginMasterInfo *)[funcMenuVec mitrElementAt:7];
		
//		NSLog(@"1st Element of FunctionMenu i.e userLoginStatus :%@		",[(MitrString *)[funcMenuVec mitrElementAt:0] toString]);		
//		NSLog(@"2nd Element of FunctionMenu i.e userLoginMessage :%@	",[(MitrString *)[funcMenuVec mitrElementAt:1] toString]);		
//		NSLog(@"3rd Element of FunctionMenu i.e passwrdState :%@		",[(MitrString *)[funcMenuVec mitrElementAt:2] toString]);		
//		NSLog(@"4th Element of FunctionMenu i.e passwrdStateMessage :%@	",[(MitrString *)[funcMenuVec mitrElementAt:3] toString]);		
//		NSLog(@"5th Element of FunctionMenu i.e menuDetail :%@			",(MitrHashtable *)[funcMenuVec mitrElementAt:4]);		
//		NSLog(@"6th Element of FunctionMenu i.e maxUserDocNumber :%@	",(MitrInteger *)[funcMenuVec mitrElementAt:5]);		
//		NSLog(@"7th Element of FunctionMenu i.e funcMenuVec :%@			",(MitrVector *)[funcMenuVec mitrElementAt:6]);		
//		NSLog(@"8th Element of FunctionMenu i.e funcMenuVec :%@			",(LoginMasterInfo *)[funcMenuVec mitrElementAt:7]);		
	}		
    return self;
}

-(NSMutableArray *)toVector
{
    NSMutableArray *funcMenuVec = [[NSMutableArray alloc] init];
	
	[funcMenuVec addElement:[[NSString alloc] initWithString:userLoginStatus]];
	[funcMenuVec addElement:[[NSString alloc] initWithString:userLoginMessage]];
	[funcMenuVec addElement:[[NSString alloc] initWithString:passwrdState]];
	[funcMenuVec addElement:[[NSString alloc] initWithString:passwrdStateMessage]];
	[funcMenuVec addElement:menuDetail];
	[funcMenuVec addElement:maxUserDocNumber];
	[funcMenuVec addElement:serverDateTime];	
	[funcMenuVec addElement:loginMasterInfo];			
	
	return funcMenuVec;	 
}


-(int) getType
{
	return typeId;
}

@end
