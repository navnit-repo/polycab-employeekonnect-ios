//
//  ObjectStorage.h
//  QCMSProject
//
//  Created by Pradeep Singh on 7/6/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectStorage : NSObject

{
	NSMutableDictionary* rootJson;
	NSString* storageName;
    NSString* fullStorageFilePath;

}


@property NSMutableDictionary* rootJson;
@property NSString* storageName;
@property NSString* fullStorageFilePath;


- (id) initWithName : (NSString*) inStorageName;
- (void) loadStorage;
- (void) flushStorage;

- (void )writeJsonObject : (NSString*) keyName : (NSMutableDictionary*) jsonObject;
- (NSMutableDictionary*) readJsonObject : (NSString*) keyName;
- (void) writeStringObject : (NSString*) keyName : (NSString*) value;
- (NSString*) readStringObject : (NSString*) keyName;


+ (id) createInstance : (NSString*) inStorageName : (BOOL) isDefault;
+ (BOOL) isInitialized : (NSString*) inStorageName;
+ (ObjectStorage*) getInstance :(NSString*) inStorageName;
+ (ObjectStorage*) getInstance;    // for default instance;

@end
