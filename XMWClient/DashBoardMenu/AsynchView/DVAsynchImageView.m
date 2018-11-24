//
//  DVAsynchImageView.m
//  AsynchImageLoaderSample
//
//  Created by Pradeep Singh on 1/9/14.
//  Copyright (c) 2014 Dotvik Solutions. All rights reserved.
//

#import "DVAsynchImageView.h"
#import "UIImage+animatedGIF.h"

@implementation DVAsynchImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSURL *imageUrl = [[NSBundle mainBundle] URLForResource:@"ajax-loader" withExtension:@"gif"];
        self.image = [UIImage animatedImageWithAnimatedGIFURL:imageUrl];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    //NSLog(@"Not implemented : (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge");
    
    
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    
    //NSLog(@"Not implemented : connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace ");
    
    
    return false;
}


- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    //NSLog(@"Not implemented : - (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge ");
    
    
    
}


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    //NSLog(@"Not implemented : - (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge");
    
    
    
}


- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection {
    
    //NSLog(@"Not implemented : - (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection");
    
    return false;
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    //NSLog (@"Not implemented : - (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error %@", [error description]);
    

    
}


- (NSInputStream *)connection:(NSURLConnection *)connection needNewBodyStream:(NSURLRequest *)request {
    //NSLog(@"Not implemented : - (NSInputStream *)connection:(NSURLConnection *)connection needNewBodyStream:(NSURLRequest *)request");
    
    return nil;
}


- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    
    //NSLog(@"Not implemented : - (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite");
    
    
}


// there will be repeat calls and data needs to be appended
// Sent as a connection loads data incrementally.
// The newly available data. The delegate should concatenate the contents of each data object
// delivered to build up the complete data for a URL load.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //NSLog(@"To be implemented : - (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data");
    //NSLog(@"Data Received = %d", data.length);
    
    // //NSLog(@"%@", [[NSString alloc ] initWithData:data encoding:NSUTF8StringEncoding]);
    
    [responseData appendData:data];
}


// Sent when the connection has received sufficient data to construct the URL response for its request.
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    //NSLog(@"To be implemented : - (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response");
    
    // – expectedContentLength
    // – suggestedFilename
    // – MIMEType
    // – textEncodingName
    //  – URL
    
    //NSLog(@"expectedContentLength = %lld", response.expectedContentLength);
    //NSLog(@"MIMEType = %@", response.MIMEType);
    //NSLog(@"textEncodingName = %@", response.textEncodingName);
    
    if(response.expectedContentLength>0) {
        responseData = [[NSMutableData alloc] initWithCapacity: response.expectedContentLength ];
    } else {
        responseData = [[NSMutableData alloc] init];
    }
}


// Sent before the connection stores a cached response in the cache, to give the delegate an opportunity to alter it.
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    
    //NSLog(@"May not implemented : - (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse");
    
    
    
    return cachedResponse;
}



// Sent when the connection determines that it must change URLs in order to continue loading a request.
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
    
    //NSLog(@"May not implement: - (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse ");
    
    return request;
}


//Sent when a connection has finished loading successfully. (required)

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //NSLog(@"(void)connectionDidFinishLoading:(NSURLConnection *)connection");
    //NSLog(@"All content received = %d", responseData.length);
    
    // we should get all image data here
    
    UIImage* webImage = [[UIImage alloc] initWithData:responseData];
    self.image = webImage;
    
}

-(void) getImage:(NSString*) urlString {
    
    NSURL *url                      = [NSURL URLWithString: urlString];
    NSMutableURLRequest *request    = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    NSURLConnection* urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [urlConnection start];
    
}

@end
