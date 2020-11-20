//
//  ChatHeadReportVC.m
//  XMWClient
//
//  Created by Pradeep Singh on 15/11/20.
//  Copyright © 2020 dotvik. All rights reserved.
//

#import <objc/runtime.h>
#import "ChatHeadReportVC.h"
#import "XmwcsConstant.h"

#import "XmwReportService.h"
#import "DotFormPost.h"
#import "AppConstants.h"


#define kICON_TAG 9999


@interface UIView (GenerateIcon)
@property NSNumber* itemIndex;
@end

@implementation UIView (GenerateIcon)
- (NSNumber*)itemIndex;
{
    return objc_getAssociatedObject(self, "itemIndex");
}

- (void)setItemIndex:(NSNumber*)property;
{
    objc_setAssociatedObject(self, "itemIndex", property, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end


@interface ChatHeadReportVC () <CustomRenderDelegate, UIDocumentInteractionControllerDelegate>
{
    UIDocumentInteractionController* docController;
}

@end

@implementation ChatHeadReportVC

- (void)viewDidLoad {
    self.customRenderDelegate = self;
    self.disableSearchBar = YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void) makeReportScreenV2
{
   
    [super makeReportScreenV2];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - CustomRenderDelegate
-(void) renderElement:(DotReportElement*) element row:(NSInteger) rowIndex col:(NSInteger) colIndex data:(NSString*) text view:(UIView*) view
{
    NSLog(@"renderElement() for row =  %ld, col = %ld", (long)rowIndex, colIndex);
    
    UIView* innerView = [view viewWithTag:1000];
    
    if(innerView!=nil) {
        innerView.itemIndex = [NSNumber numberWithInteger:rowIndex];
    }
    
    if(colIndex == 15) {
        
        UILabel* textView = [innerView viewWithTag:kICON_TAG];
        [textView removeFromSuperview];
               
        textView = [[UILabel alloc] initWithFrame:innerView.bounds];
        textView.contentMode = UIViewContentModeCenter;
        textView.text = @"View";
        textView.textAlignment = NSTextAlignmentCenter;
        
        textView.tag = kICON_TAG;
        
       [innerView addSubview:textView];
        
        innerView.userInteractionEnabled = YES;
        
        [innerView setGestureRecognizers:[[NSArray alloc] init]];
        
        UIGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(linkTapped:)];
        [innerView addGestureRecognizer:tapGesture];
        
        
    } else if(colIndex == 16) {
        
        UIImageView* iconView = [innerView viewWithTag:kICON_TAG];
        [iconView removeFromSuperview];
               
       UIImage* iconImage = [UIImage imageNamed:@"download"];
       iconView = [[UIImageView alloc] initWithImage:iconImage];
       iconView.frame = innerView.bounds;
       iconView.contentMode = UIViewContentModeCenter;
        iconView.tag = kICON_TAG;
        
       [innerView addSubview:iconView];
        
        innerView.userInteractionEnabled = YES;
        
        [innerView setGestureRecognizers:[[NSArray alloc] init]];
        
        UIGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downloadTapped:)];
        [innerView addGestureRecognizer:tapGesture];
        
    }
}


-(void)downloadTapped:(UIGestureRecognizer*) gesture
{
    NSLog(@"downloadTapped enter, rowIndex = %ld",  [gesture.view.itemIndex integerValue]);
    
    [self  downloadPDF:[gesture.view.itemIndex integerValue]];
    
}

-(void)linkTapped:(UIGestureRecognizer*) gesture
{
    NSLog(@"linkTapped enter, rowIndex = %ld",  [gesture.view.itemIndex integerValue]);
    
    [self  getLinkAndLaunch:[gesture.view.itemIndex integerValue]];
}

-(void) downloadPDF:(NSInteger) rowIndex
{
    NSArray* rowData = [self.reportPostResponse.tableData objectAtIndex:rowIndex];
    
    NSString* threadId = [rowData objectAtIndex:17];
    NSString* spaNo = [rowData objectAtIndex:7];
    NSString* from = [rowData objectAtIndex:2];
    NSString* to = [rowData objectAtIndex:5];
    
    
    NSMutableString* uri = [[NSMutableString alloc] init];
    [uri appendString:@"/chatpdf?threadid="];
    [uri appendString:threadId];
    
    [uri appendString:@"&spaNo="];
    [uri appendString:spaNo];
    
    [uri appendString:@"&from="];
    [uri appendString:from];
    
    [uri appendString:@"&to="];
    [uri appendString:to];
    
    [uri appendString:@"&authToken="];
    [uri appendString:[[NSUserDefaults standardUserDefaults] objectForKey:@"AUTH_TOKEN"]];
    
         
    NSString *url;
    NSString *str = XmwcsConst_SERVICE_URL;
        
    NSRange replaceRange = [str rangeOfString:@"feed"];
    if (replaceRange.location != NSNotFound){
        NSString* result = [str stringByReplacingCharactersInRange:replaceRange withString:uri];
        NSLog(@"%@",result);
        url =result;
    }
        
    NSURL *fileURL = [NSURL URLWithString:url];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:fileURL completionHandler:^(NSData *data,
                                                          NSURLResponse *response,
                                                          NSError *error)
      {
          if(!error)
          {
              NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[response suggestedFilename]];
              
              // NSString *filePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:[response suggestedFilename]];
              NSLog(@"PDF path: %@", filePath);
              [data writeToFile:filePath atomically:YES];
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  
                  [self->loadingView removeView];
                  
                  NSURL* savedFileURL = [NSURL fileURLWithPath:filePath isDirectory:NO];
                  
                  docController = [UIDocumentInteractionController interactionControllerWithURL:savedFileURL];
                        docController.delegate = self;
                                              
                        docController.name = filePath;
                        [docController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
                  
              });
              
          }
          
      }] resume];
        
}

-(void) getLinkAndLaunch:(NSInteger) rowIndex
{
    NSArray* rowData = [[self.reportPostResponse tableData] objectAtIndex:rowIndex];
    
    NSString* threadId = [rowData objectAtIndex:17];
    
    NSString* from = [rowData objectAtIndex:2];
    NSString* to = [rowData objectAtIndex:5];
    
    
    DotFormPost* formPost = [[DotFormPost alloc] init];
    
    formPost.moduleId = AppConst_MOBILET_ID_DEFAULT;
    
    formPost.adapterId = @"DR_XMW_CHAT_LINK";
    formPost.adapterType = @"CLASSLOADER";
    
    [formPost.postData setObject:from forKey:@"FROM"];
    [formPost.postData setObject:to forKey:@"TO"];
    [formPost.postData setObject:threadId forKey:@"THREAD_ID"];

    XmwReportService* reportService = [[XmwReportService alloc] initWithPostData:formPost withContext:@"DR_XMW_CHAT_LINK"];
    
    
    [reportService fetchReportUsingSuccess:^(DotFormPost* formPosted, ReportPostResponse* reportResponse) {
        
        NSString* chatLink = [reportResponse.headerData objectForKey:@"CHAT_LINK"];
        
        if(chatLink!=nil && [chatLink length]>0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: chatLink] options:@{} completionHandler:nil];
        }
        
    }   fail:^(DotFormPost* formPosted, NSString* message) {
        

    }];
    
    
}

@end
