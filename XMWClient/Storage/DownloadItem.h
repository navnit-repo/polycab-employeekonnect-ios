//
//  DownloadItem.h
//  QCMSProject
//
//  Created by Pradeep Singh on 7/26/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadItem : NSObject


@property int itemRefId;
@property NSString* username;
@property NSString* password;
@property NSString* downloadURL;
@property NSString* localFilePath;
@property NSString* createDate;
@property NSString* status;
@property NSString* length;
@property NSString* partial;

@end
