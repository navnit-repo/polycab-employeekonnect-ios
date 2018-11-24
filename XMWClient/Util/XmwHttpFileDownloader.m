//
//  XmwHttpFileDownloader.m
//  QCMSProject
//
//  Created by Pradeep Singh on 3/27/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//

#import "XmwHttpFileDownloader.h"


@implementation XmwHttpFileDownloader
{
    NSURLConnection* urlConnection;
    dispatch_io_t dispatchFileHandle;
    dispatch_queue_t dispatchQueue;
    off_t currentOffset;
    long long totalLength;
}

@synthesize username;
@synthesize password;
@synthesize downloadHttpUrl;
@synthesize saveFolderPath;
@synthesize fileName;
@synthesize fileManager;
@synthesize delegate;


-(id)initWithUrl:(NSString*) downloadUrlStr
{
    self = [super init];
    
    if(self!=nil) {
        self.downloadHttpUrl = downloadUrlStr;
        
        // default location
        NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.saveFolderPath = dirPaths[0];
        
        NSArray* parts = [downloadUrlStr componentsSeparatedByString:@"/"];
        if([parts count]>0) {
            fileName = [parts objectAtIndex:([parts count] -1)];
        } else {
            fileName = @"SomeRandomString";
        }
        
    }
    return self;
}


-(id)initWithUrl:(NSString*) downloadUrlStr saveLocation:(NSString*) folder
{
    self = [super init];
    
    if(self!=nil) {
        self.downloadHttpUrl = downloadUrlStr;
        self.saveFolderPath = folder;
        
        NSArray* parts = [downloadUrlStr componentsSeparatedByString:@"/"];
        if([parts count]>0) {
            fileName = [parts objectAtIndex:([parts count] -1)];
        } else {
            fileName = @"SomeRandomString";
        }
        
    }
    return self;
}


-(id)initWithUrl :(NSString*) downloadUrlStr saveLocation:(NSString*) folder saveAs:(NSString*) fileNameStr
{
    self = [super init];
    
    if(self!=nil) {
        self.downloadHttpUrl = downloadUrlStr;
        self.saveFolderPath = folder;
        self.fileName = fileNameStr;
        
    }
    return self;
}


-(void) downloadStart:(id<XmwDownloadNotify>) statusDelegate
{
    self.delegate = statusDelegate;
    
    downloadUrl = [NSURL URLWithString: downloadHttpUrl];
    
    NSMutableURLRequest *request    = [NSMutableURLRequest requestWithURL:downloadUrl];
    [request setHTTPMethod:@"GET"];
    
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [urlConnection start];
}

-(void) downloadStart:(id<XmwDownloadNotify>) statusDelegate username:(NSString*) loginid password:(NSString*) pwd
{
    self.delegate = statusDelegate;
    self.username = loginid;
    self.password = pwd;
    
    downloadUrl = [NSURL URLWithString: downloadHttpUrl];
    
    NSMutableURLRequest *request    = [NSMutableURLRequest requestWithURL:downloadUrl];
    [request setHTTPMethod:@"GET"];
    
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [urlConnection start];
    
}


- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    
    NSLog(@"Implementing for downloading secure files : (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge");
    
    if ([challenge previousFailureCount] == 0) {
        NSURLCredential* urlCredentials = [NSURLCredential credentialWithUser:username password:password persistence:NSURLCredentialPersistenceNone];
        
        [[challenge sender] useCredential:urlCredentials forAuthenticationChallenge:challenge];
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
    
    
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    
     NSLog(@"Not implemented : connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace ");
    
    
    return false;
}


- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    NSLog(@"Not implemented : - (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge ");
    
    
    
}


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
     NSLog(@"Not implemented : - (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge");
    
    
    
}


- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection {
    
    NSLog(@"Not implemented : - (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection");
    
    return false;
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Download error" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
    
}


- (NSInputStream *)connection:(NSURLConnection *)connection needNewBodyStream:(NSURLRequest *)request {
    NSLog(@"Not implemented : - (NSInputStream *)connection:(NSURLConnection *)connection needNewBodyStream:(NSURLRequest *)request");
    
    return nil;
}


- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    
     NSLog(@"Not implemented : - (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite");
    
    
}


// there will be repeat calls and data needs to be appended
// Sent as a connection loads data incrementally.
// The newly available data. The delegate should concatenate the contents of each data object
// delivered to build up the complete data for a URL load.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"Data Received = %d", data.length);
    
    // save the received content on the local storage
    
    // dispatchFileHandle     typedef void (^dispatch_io_handler_t)(bool done, dispatch_data_t data, int error);
    
    
    dispatch_data_t dispatchData = dispatch_data_create(
                                                        data.bytes,
                                                        data.length,
                                                        dispatchQueue,
                                                        DISPATCH_DATA_DESTRUCTOR_DEFAULT);
    
    dispatch_io_write(dispatchFileHandle, currentOffset,
                      dispatchData,
                      dispatchQueue,
                      ^(bool done, dispatch_data_t inData, int error) {
                          if(done) {
                              currentOffset = currentOffset + data.length;
                              long long percentage =currentOffset*100/totalLength ;
                              NSLog(@"percentage %lld",percentage);
                              
                              if(self.delegate != nil) {
                                  if([self.delegate respondsToSelector:@selector(percentDownloadComplete:)]) {
                                      [self.delegate percentDownloadComplete : percentage];
                                  }
                              }
                              
                          }
                      }
                      );}


// Sent when the connection has received sufficient data to construct the URL response for its request.
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@" - (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response");
    
    // – expectedContentLength
    // – suggestedFilename
    // – MIMEType
    // – textEncodingName
    //  – URL
    
    NSLog(@"expectedContentLength = %lld", response.expectedContentLength);
    NSLog(@"MIMEType = %@", response.MIMEType);
    NSLog(@"textEncodingName = %@", response.textEncodingName);
    

    totalLength=response.expectedContentLength;
    fileManager = [NSFileManager defaultManager];
    

    NSString* savedFilePath = [ self.saveFolderPath stringByAppendingPathComponent:self.fileName];
    
    dispatchQueue =  dispatch_queue_create("contentUpdateQueue", DISPATCH_QUEUE_SERIAL);
    currentOffset = 0;
    dispatchFileHandle = dispatch_io_create_with_path(DISPATCH_IO_STREAM, savedFilePath.UTF8String,
                                                      O_CREAT | O_WRONLY, S_IRUSR | S_IWUSR,
                                                      dispatchQueue,
                                                      ^(int error) {
                                                          NSLog(@"Error in dispatch_io_create_with_path, error code is %d", error);
                                                      });

}


// Sent before the connection stores a cached response in the cache, to give the delegate an opportunity to alter it.
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    
    // NSLog(@"May not implemented : - (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse");
    
    
    
    return cachedResponse;
}



// Sent when the connection determines that it must change URLs in order to continue loading a request.
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
    
    //  NSLog(@"May not implement: - (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse ");
    
    return request;
}


//Sent when a connection has finished loading successfully. (required)

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"(void)connectionDidFinishLoading:(NSURLConnection *)connection");
    dispatch_io_close(dispatchFileHandle, 0);
    
    // file must have been saved till now.
    NSString* savedFilePath = [ self.saveFolderPath stringByAppendingPathComponent:self.fileName];
    
    if(self.delegate != nil) {
        if([self.delegate respondsToSelector:@selector(downloadCompleted:)]) {
            [self.delegate downloadCompleted: savedFilePath];
        }
    }

}

- (NSString *)urlencode : (NSString*) rawURL {
    
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[rawURL UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
            (thisChar >= 'a' && thisChar <= 'z') ||
            (thisChar >= 'A' && thisChar <= 'Z') ||
            (thisChar >= '0' && thisChar <= '9') ||
            (thisChar == '/') || (thisChar == ':') ||
            (thisChar == '&') || (thisChar == '?') ||
            (thisChar == '%')  || (thisChar == '+') || (thisChar == '=')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}





@end
