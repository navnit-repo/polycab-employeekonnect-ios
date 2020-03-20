//
//  XmwHttpFileDownloader.h
//  QCMSProject
//
//  Created by Pradeep Singh on 3/27/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XmwDownloadNotify <NSObject>
-(void) downloadCompleted :(NSString*) savedFilename;
-(void) percentDownloadComplete : (float) percent;
@end


@interface XmwHttpFileDownloader : NSObject <NSURLConnectionDelegate>
{
    NSString* username;
    NSString* password;
    NSString* downloadHttpUrl;
    NSURL* downloadUrl;
    NSString* saveFolderPath;
    NSString* fileName;
    
    NSFileManager *fileManager;
    id<XmwDownloadNotify> delegate;
}

@property NSString* username;
@property NSString* password;
@property NSString* downloadHttpUrl;
@property NSString* saveFolderPath;
@property NSString* fileName;
@property (retain, nonatomic) NSFileManager *fileManager;
@property (retain, nonatomic) id<XmwDownloadNotify> delegate;


-(id)initWithUrl:(NSString*) downloadUrlStr;

-(id)initWithUrl:(NSString*) downloadUrlStr saveLocation:(NSString*) folder;

-(id)initWithUrl :(NSString*) downloadUrlStr saveLocation:(NSString*) folder saveAs:(NSString*) fileNameStr;

-(void) downloadStart:(id<XmwDownloadNotify>) statusDelegate;
-(void) downloadStart:(id<XmwDownloadNotify>) statusDelegate username:(NSString*) loginid password:(NSString*) pwd;
@end
