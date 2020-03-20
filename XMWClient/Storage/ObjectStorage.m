//
//  ObjectStorage.m
//  QCMSProject
//
//  Created by Pradeep Singh on 7/6/13.
//  Copyright (c) 2013 dotvik. All rights reserved.
//

#import "ObjectStorage.h"
#import "SBJson.h"


static NSMutableDictionary* ObjectStorage_INSTANCE_MAP = nil;
static ObjectStorage* ObjectStorage_DEFAULT_INSTANCE = nil;
static NSString* ObjectStorage_BASE_FOLDER = nil;


@implementation ObjectStorage

@synthesize rootJson;
@synthesize storageName;
@synthesize fullStorageFilePath;



- (id) initWithName : (NSString*) inStorageName {
    self = [super init];
    if(self!=nil) {
        self.storageName = inStorageName;
                           
        NSString *docsDir;
        NSArray *dirPaths;
        // Get the documents directory
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = dirPaths[0];
        self.fullStorageFilePath = [[NSString alloc] initWithString:
                             [docsDir stringByAppendingPathComponent: self.storageName]];
    }
    return self;
}

- (void) loadStorage {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath: self.fullStorageFilePath]) {
        NSData *data = [fileManager contentsAtPath:self.fullStorageFilePath];
        SBJsonParser* sbParser = [[SBJsonParser alloc] init];
        self.rootJson = [sbParser objectWithData: data];
    }
    // file doesn't exist
        if(self.rootJson == nil) {
            self.rootJson = [[NSMutableDictionary alloc] init];
        }
}


- (void) flushStorage {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath: self.fullStorageFilePath]) {
        [fileManager removeItemAtPath: self.fullStorageFilePath error:NULL];
    }
    
    SBJsonWriter* jsonWriter = [[SBJsonWriter alloc] init];
    NSData* data = [jsonWriter dataWithObject:self.rootJson];
    [fileManager createFileAtPath:self.fullStorageFilePath contents:data attributes:nil];
    
}


- (void) writeJsonObject : (NSString*) keyName : (NSMutableDictionary*) jsonObject {
    if(self.rootJson != nil) {
		@try {
            
            if([self.rootJson objectForKey:keyName] != nil ) {
                [self.rootJson removeObjectForKey:keyName];
            }
			[self.rootJson setObject:jsonObject forKey:keyName];
        }
        @catch(NSExpression* nse) {
            NSLog(@"detail = %@",nse);

		}
	}
}

- (NSMutableDictionary*) readJsonObject : (NSString*) keyName {
    if(rootJson != 0) {
        @try {
            return [self.rootJson objectForKey:keyName];
        }
        @catch(NSExpression* nse) {

        }
	}
    return nil;
}

- (void) writeStringObject : (NSString*) keyName : (NSString*) value {
    
    if(self.rootJson != nil) {
		@try {
            
            if([self.rootJson objectForKey:keyName] != nil ) {
                [self.rootJson removeObjectForKey:keyName];
            }
			[self.rootJson setObject:value forKey:keyName];
        }
        @catch(NSExpression* nse) {
            
		}
	}
    
}

- (NSString*) readStringObject : (NSString*) keyName {
    if(rootJson != 0) {
        @try {
            return [self.rootJson objectForKey:keyName];
        }
        @catch(NSExpression* nse) {
            
        }
	}
    return nil;
}




+ (id) createInstance : (NSString*) inStorageName : (BOOL) isDefault {
    ObjectStorage* newInstance = nil;
	@try {
		 //newInstance->fileStore = new QFile(RecentRequestStorage::BASE_FOLDER + contextId + ".sqlite.db");
		// NSString* dbName = @"recentrequest.sqlite.db";
        newInstance = [[ObjectStorage alloc] initWithName : inStorageName];
        [newInstance loadStorage];
    }
	@catch (NSException *exception)  {
        NSLog(@"ObjectStorage.createInstance = %@", [exception reason]);
    }
    
	if(ObjectStorage_INSTANCE_MAP == nil) {
		ObjectStorage_INSTANCE_MAP = [[NSMutableDictionary alloc] init];
	}
    
	[ObjectStorage_INSTANCE_MAP  setObject:newInstance forKey: inStorageName];
    
    
	if(isDefault) {
		ObjectStorage_DEFAULT_INSTANCE = newInstance;
	}
    
    return newInstance;
}
+ (BOOL) isInitialized : (NSString*) inStorageName {
    if(ObjectStorage_INSTANCE_MAP!=nil) {
        if ([ObjectStorage_INSTANCE_MAP objectForKey:inStorageName] != nil) {
            return true;
        }
    }
    return false;
}


+ (ObjectStorage*) getInstance :(NSString*) inStorageName {
    if(ObjectStorage_INSTANCE_MAP != nil) {
        return [ObjectStorage_INSTANCE_MAP objectForKey:inStorageName];
	}
    return nil;
}

// for default instance;
+ (ObjectStorage*) getInstance {
    return ObjectStorage_DEFAULT_INSTANCE;
}




@end
