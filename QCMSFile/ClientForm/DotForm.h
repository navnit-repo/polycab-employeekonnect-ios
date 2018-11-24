//
//  DotForm.h
//  QCMSProject
//
//  Created by Pradeep Singh on 5/21/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Network/JSONStructure.h"

@interface DotForm : NSObject <JSONStructure>
{
@private
    int jsonStructureId;
    
    NSString* formId;           // Id of the form that is unique for the application
	NSString* screenDesc;       //Description of the form
	NSString* screenName;;
	NSString* screenHeader;     //Header of the form that display on the application
	NSString* screenMenuConfig;//Form's Left Menu
	
	NSString* formType;         //as submit or view
	NSString* formSubType;      //sub Type is as SIMPLE,BUTTON,ADDROW,ADDROW_SIMPLE,NEXT_FORM
	
	NSString* adapterType;
	//sap(For the Sap )	hibernate (For the Hibernate Framework,Always sink to server when submit the doc)
	//webservices(for the webservices integration ),independed(For the in depended integration Also sink to server )
	NSString* submitAdapterId;          //import integration Id
	NSString* viewAdapterId;                //export integration Id
	NSString* extendedPropertyForm;         //column Name that is use for add row column
	NSMutableDictionary* formElements;      //Components of the Form
    
    NSMutableDictionary* extendedPropertyMap;
	NSString* addRowColumn; //Extended Property "ADD_ROW_COLUMN" column Name that is use for add row column
	NSString* tableName; //Extended Property "TABLE_NAME"  Name of the table or structure for Adapter submit identity it mainly use in RFC type function group
	NSString* subGroupInfo; //Extended Property "SUB_GROUP"
    
}


@property NSString* formId;        
@property NSString* screenDesc;      
@property NSString* screenName;;
@property NSString* screenHeader;     
@property NSString* screenMenuConfig;

@property NSString* formType;         
@property NSString* formSubType;      

@property NSString* adapterType;
@property NSString* submitAdapterId;          
@property NSString* viewAdapterId;                
@property NSString* extendedPropertyForm;         
@property NSMutableDictionary* formElements;

@property NSMutableDictionary* extendedPropertyMap;
@property NSString* addRowColumn;
@property NSString* tableName;
@property NSString* subGroupInfo; 


- (void) initTagOnRequest : (DotForm*) dotFrm;

-(NSArray*) nonAddRowFormElements;
-(NSArray*) addRowFormElements;

@end
