//
//  FunctionMenu.h
//  EMSV3BaseMobilet
//
//  Created by Puneet on 11-Mar-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MitrStruct.h"
//#import "StructProtocol.h"
//#import "MitrHashtable.h"
//#import "MitrVector.h"
//#import "MitrInteger.h"
//#import "LoginMasterInfo.h"
#import "FunctionMenu.h"



@interface FunctionMenu : NSObject {//MitrStruct <StructProtocol> {
	
@private	
	int typeId;
	
	NSString *userLoginStatus;
	NSString *userLoginMessage;
	NSString *passwrdState;	
	NSString *passwrdStateMessage;
	
	NSMutableDictionary *menuDetail;
	
	NSInteger *maxUserDocNumber;
	
	NSMutableArray *serverDateTime;
	
	//LoginMasterInfo *loginMasterInfo;
	
}

-(FunctionMenu *)init;

-(FunctionMenu *)initWithMitrVector:(NSMutableArray *)funcMenuVec;

@property (nonatomic, readonly) NSString *userLoginStatus;
@property (nonatomic, readonly) NSString *userLoginMessage;
@property (nonatomic, readonly) NSString *passwrdState;
@property (nonatomic, readonly) NSString *passwrdStateMessage;

@property (nonatomic, readonly) NSMutableDictionary *menuDetail;

@property (nonatomic, readonly) NSInteger *maxUserDocNumber;

@property (nonatomic, readonly) NSMutableArray *serverDateTime;

//@property (nonatomic, readonly) LoginMasterInfo *loginMasterInfo;

@end
