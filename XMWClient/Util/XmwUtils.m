//
//  XmwUtils.m
//  QCMSProject
//
//  Created by Pradeep Singh on 5/25/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "XmwUtils.h"
#import "XmwcsConstant.h"
#import "DotFormElement.h"
#import "ClientVariable.h"
#import "LanguageConstant.h"
#import "DVAppDelegate.h"

#import "iToast.h"

@implementation XmwUtils


// no need of language map as we can access data directly from Localizable 
+ (NSString*) getLanguageConstant : (NSString*) key
{
    return NSLocalizedStringFromTable (key, @"Localizable", @"");
	
}

+ (NSString*) makeLanguageText : (NSString*) inFirstStr :  (bool) isFirstStrLanguageConst : (NSString*) inSecondStr : (bool) isSecondStrLanguageConst{
	NSString* firstStr = inFirstStr;
	NSString* secondStr = inSecondStr;
    ClientVariable *clientVariables = [ClientVariable getInstance:[DVAppDelegate currentModuleContext]];
	if (isFirstStrLanguageConst) {
        firstStr = [ XmwUtils getLanguageConstant :firstStr];
    }
    if (isSecondStrLanguageConst) {
        secondStr = [ XmwUtils getLanguageConstant :secondStr];
    }
    
    if ( [[ClientVariable getWriteAs] isEqualToString : LangConst_PREFIX]) {
        return [[secondStr stringByAppendingString: @" " ] stringByAppendingString :firstStr];
    } else {
        return [[firstStr stringByAppendingString: @" " ] stringByAppendingString : secondStr];
    }
}


+ (NSMutableDictionary *) getExtendedPropertyMap : (NSString*) extendedPropertyReport {
    NSString* work = extendedPropertyReport;
    NSMutableDictionary *extendedPropertyMap = [[NSMutableDictionary alloc]init];
    
    while ([work length] > 0) {
        NSRange pos = [work rangeOfString:@":[" ];
        if(pos.length>0) {
            NSString* propertyKey = [work substringToIndex:pos.location];
            
            NSRange left = [work rangeOfString:@"[" ];
            NSRange right = [work rangeOfString:@"]" ];
            NSRange value;
            value.location = left.location + 1;
            value.length  = right.location - left.location - 1;
            
            NSString* propertyValue = [work substringWithRange:value];  //work.mid(work.indexOf("[") + 1, work.indexOf("]"));
            
            [extendedPropertyMap setObject:propertyValue forKey:propertyKey] ; //.insert(propertyKey, propertyValue);
            
            work = [work substringFromIndex:right.location + 1];
            if( ([work length] > 0) &&  ([work characterAtIndex:0] == '$')) {
                work = [work substringFromIndex:1];
            }
        } else {
            break;
        }
    }
    return extendedPropertyMap;
}


+(NSString*)getPropertyValue : (NSString*) combineProprtyStr : (NSString*) searchPropertyName
{
	NSString* returnProperty = @"";
    
    NSRange pos = [combineProprtyStr rangeOfString:searchPropertyName];
    
    if(pos.location != NSNotFound)
    {
        NSRange keyValuePos = [combineProprtyStr rangeOfString:[searchPropertyName stringByAppendingString:@":["]];
        keyValuePos.location = keyValuePos.location + searchPropertyName.length + 2;
        
        
        NSString* restString = [combineProprtyStr substringFromIndex:keyValuePos.location];
        NSRange endIndexPos = [restString rangeOfString:@"]"];
        
        returnProperty = [restString substringToIndex: endIndexPos.location];
    }
	return returnProperty ;
    
    
    
}

+ (NSString*) getPropertyFromMap : (NSMutableDictionary*) exPropMap : (NSString*) keyOfProperty {
    if([exPropMap objectForKey:keyOfProperty] != nil)
        return (NSString *)[exPropMap objectForKey:keyOfProperty];
    else
        return @"";
}


+ (NSArray*)  sortHashtableKey: (NSMutableDictionary*) hashTable : (int) onSortType {
      
    NSArray* keys = [hashTable allKeys];
    
    if(onSortType == XmwcsConst_SORT_AS_INTEGER){
        NSArray* sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSNumber* numa = a;
            NSNumber* numb = b;
            return numa.intValue > numb.intValue;
        }];
        return sortedKeys;
    } else if(onSortType == XmwcsConst_SORT_AS_STRING) {
        NSArray* sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSString* stra = a;
            NSString* strb = b;
            return [stra compare:strb];
        }];
        return sortedKeys;
    }
    return nil;
}


+ (NSArray*)  sortHashtableByValue: (NSMutableDictionary*) hashTable : (int) onSortType {
    
    NSArray* keys = [hashTable allKeys];
    NSArray* values = [hashTable allValues];
    
    NSMutableArray* pairArray = [[NSMutableArray alloc] init];
    for(int i=0; i<[keys count]; i++) {
        NSMutableArray* pair = [[NSMutableArray alloc] init];
        [pair addObject:[keys objectAtIndex:i]];
        [pair addObject:[values objectAtIndex:i]];
        [pairArray addObject:pair];
    }
    
    
    if(onSortType == XmwcsConst_SORT_AS_INTEGER){
        NSArray* sortedPairs = [pairArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSMutableArray* pairA = a;
            NSMutableArray* pairB = b;
            
            NSString* keyA = [pairA objectAtIndex:0];
            NSString* keyB = [pairB objectAtIndex:0];
            
            NSString* valueA = [pairA objectAtIndex:1];
            NSString* valueB = [pairB objectAtIndex:1];
            
            return valueA.intValue > valueB.intValue;
        }];
        return sortedPairs;
    } else if(onSortType == XmwcsConst_SORT_AS_STRING) {
        NSArray* sortedPairs = [pairArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSMutableArray* pairA = a;
            NSMutableArray* pairB = b;
            
            NSString* keyA = [pairA objectAtIndex:0];
            NSString* keyB = [pairB objectAtIndex:0];
            
            NSString* valueA = [pairA objectAtIndex:1];
            NSString* valueB = [pairB objectAtIndex:1];
            
            return [valueA compare:valueB];
        }];
        return sortedPairs;
    }
    return nil;
}


+ (NSArray*)  sortedDotFormElementIds: (NSMutableDictionary*) hashTable {
    
    NSArray* allElementNodes = [hashTable  allValues];
    NSArray* unSortedArray = [[NSArray alloc] initWithArray: allElementNodes];
    
    
    NSArray* sortedElementIdArray = [unSortedArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSString* numa = [(DotFormElement*) a  componentPosition ];
            NSString* numb = [(DotFormElement*) b  componentPosition ];
            return [numa compare:numb];
        }];
        return sortedElementIdArray;
    
}


+ (NSArray*) getKeyList : (NSMutableDictionary*) mapForGettingKeyList {
    return [mapForGettingKeyList allKeys];
}

+ (NSArray*) breakStringTokenAsVector: (NSString*) tokenString : (NSString*) septarator {
    return [tokenString componentsSeparatedByString: septarator];
}
+(void)sortListOnPosition : (NSMutableArray *) in_ComponentIdVec: (NSMutableArray *)in_ComponentPositionVec
{
    NSMutableArray *componentIdVec = [[NSMutableArray alloc]init];
    componentIdVec = in_ComponentIdVec;
    NSMutableArray *componentPositionVec = [[NSMutableArray alloc]init];
    componentPositionVec = in_ComponentPositionVec;
    NSString *temp;
    
    for (int cntIndex = 0; cntIndex<[componentPositionVec count]; cntIndex++)
    {
         for (int j = 0; j < [componentPositionVec count] - cntIndex -1; j++)
         {
             NSString *temp1 = (NSString *)[componentPositionVec objectAtIndex:j];
             int value = [temp1 intValue];
           
             NSString *temp2 = (NSString *)[componentPositionVec objectAtIndex:j+1];
             int value1 = [temp2 intValue];
           
            if(value > value1)
             {
                 temp = (NSString *) [componentIdVec objectAtIndex:j];
                 NSLog(@"temp:%@", temp);
                 temp2 = (NSString *) [componentIdVec objectAtIndex:j];
                 NSLog(@"temp:%@", temp2);
                 id  temp = [componentPositionVec objectAtIndex:j];
                 [componentPositionVec setObject:[componentPositionVec objectAtIndex:j+1] atIndexedSubscript:j];
                 [componentPositionVec setObject:temp atIndexedSubscript:j+1];
                 temp = [componentIdVec objectAtIndex:j];
                 [componentIdVec setObject:[componentIdVec objectAtIndex:j+1] atIndexedSubscript:j];
                 [componentIdVec setObject:temp atIndexedSubscript:j+1];
             
             }
         }
        
                
    }
        
    
}



+(BOOL) exists:(NSString*) item InArray:(NSArray*) list
{
    BOOL retVal = NO;
    
    for(int i=0; i<[list count]; i++) {
        
        if([[list objectAtIndex:i] isEqualToString:item]) {
            retVal = YES;
            return retVal;
        }
    }
    
    return retVal;
}


+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}



/*
 new String[][] {
 {"\\\\", "\\"},
 {"\\\"", "\""},
 {"\\'", "'"},
 {"\\", ""}
 })
 JSON Unescape
 */


+(NSString*) unescapeJson:(NSString*) escapedString
{
    NSString* tString = [escapedString stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
    tString = [tString stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    tString = [tString stringByReplacingOccurrencesOfString:@"\\'" withString:@"'"];
    tString = [tString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    
    return tString;
}

/*
 new String[][] {
 {"\"", "\\\""},
 {"\\", "\\\\"},
 {"/", "\\/"}
 }),
 JSON Escape
 */

+(NSString*) escapeJson:(NSString*) unescapedString
{
    NSString* tString = [unescapedString stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    tString = [tString stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    tString = [tString stringByReplacingOccurrencesOfString:@"/" withString:@"\\/"];
    return tString;
}


+(NSDictionary*)xmwNameValuePair:(NSString*) pairProperties
{
    NSMutableDictionary* pairDictionary = [[NSMutableDictionary alloc] init];
    
    NSArray* pairs = [pairProperties componentsSeparatedByString:@"$"];
    for(int i=0; i<[pairs count];i++) {
        NSString* pair = [pairs objectAtIndex:i];
        NSArray* nameValue = [pair componentsSeparatedByString:@":"];
        if([nameValue count]==1) {
            [pairDictionary setObject:nameValue[0] forKey:nameValue[0]];
        } else if([nameValue count]==2) {
            [pairDictionary setObject:nameValue[1] forKey:nameValue[0]];
        }
    }
    return pairDictionary;
}


+(void) toastView:(NSString*) message
{
    //  iToastSettings* toastSettings = [[iToastSettings alloc] init];
    [UIView setAnimationsEnabled:NO];
    iToast* myToast = [iToast makeText:message ];
    [myToast setGravity:iToastGravityCenter];
    [myToast setDuration:2000];
    
    // [myToast setPostion:CGPointMake(50, [[UIScreen mainScreen] bounds].size.height - 80)];
    [myToast show];
    
}



+(NSString*) nullSafeEmptyString:(NSObject*) jsonValue
{
    NSString* retVal = @"";
    
    if(jsonValue ==nil) {
        // return empty String
        return retVal;
    }
    if([jsonValue isKindOfClass:[NSString class]]) {
        return (NSString*)jsonValue;
    }
    
    if([jsonValue isKindOfClass:[NSNull class]]) {
        return retVal;
    }
    
    if([jsonValue isKindOfClass:[NSNumber class]]) {
        return [(NSNumber*)jsonValue description];
    }
    
    return retVal;
    
}


#pragma mark - PatternMatch

+(NSArray*) findNumbersInMessage:(NSString*) message
{
    NSString* numberPattern = @"\\-?\\d+\\.?\\d+";
    NSRegularExpression *testExpression = [NSRegularExpression regularExpressionWithPattern:numberPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [testExpression matchesInString:message
                                            options:0
                                            range:NSMakeRange(0, [message length])];
    NSLog(@"%@",matches);

    NSMutableArray *array = [@[] mutableCopy];
    
    [matches enumerateObjectsUsingBlock:^(NSTextCheckingResult *obj, NSUInteger idx, BOOL *stop) {
         for (int i = 0; i< [obj numberOfRanges]; ++i) {
             NSRange range = [obj rangeAtIndex:i];

             NSString *string = [message substringWithRange:range];
             if ([string rangeOfString:@";"].location == NSNotFound) {
                 [array addObject: string];
             } else {
                 NSArray *a = [string componentsSeparatedByString:@";"];
                 for (NSString *s  in a) {
                     [array addObject: [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                 }

             }
         }
    }];
    return array;
}


@end
