//
//  XmwUtils.h
//  QCMSProject
//
//  Created by Pradeep Singh on 5/25/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XmwUtils : NSObject

+ (NSString*) getLanguageConstant : (NSString*) key;

+ (NSString*) makeLanguageText : (NSString*) inFirstStr :  (bool) isFirstStrLanguageConst : (NSString*) inSecondStr : (bool) isSecondStrLanguageConst;

+ (NSMutableDictionary *) getExtendedPropertyMap : (NSString*) extendedPropertyReport;

+ (NSString*) getPropertyFromMap : (NSMutableDictionary*) exPropMap : (NSString*) keyOfProperty;


//this is for the sort key element of the Map key is integer or String Value
//returns the List of Sorted Key of Hash table.
+ (NSArray*)  sortHashtableKey: (NSMutableDictionary*) hashTable : (int) onSortType;
+ (NSArray*)  sortHashtableByValue: (NSMutableDictionary*) hashTable : (int) onSortType;

+ (NSArray*)  sortedDotFormElementIds: (NSMutableDictionary*) hashTable;


 //method is for the getting the ArrayList of Key Of Map Form HashMap
+ (NSArray*) getKeyList : (NSMutableDictionary*) mapForGettingKeyList;

//this method is for broke token of the String 
+ (NSArray*) breakStringTokenAsVector: (NSString*) tokenString : (NSString*) septarator;
+(void)sortListOnPosition : (NSMutableArray *) in_ComponentIdVec: (NSMutableArray *)in_ComponentPositionVec;

+(NSString*)getPropertyValue : (NSString*) combineProprtyStr : (NSString*) searchPropertyName;

+(BOOL) exists:(NSString*) item InArray:(NSArray*) list;

+(UIColor*)colorWithHexString:(NSString*)hex;

+(NSString*) unescapeJson:(NSString*) escapedString;
+(NSString*) escapeJson:(NSString*) unescapedString;


+(NSDictionary*)xmwNameValuePair:(NSString*) pairProperties;

+(void) toastView:(NSString*) message;

+(NSString*) nullSafeEmptyString:(NSObject*) jsonValue;

@end
