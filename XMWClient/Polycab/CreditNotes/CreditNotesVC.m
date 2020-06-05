//
//  CreditNotesVC.m
//  XMWClient
//
//  Created by Pradeep Singh on 21/05/20.
//  Copyright © 2020 dotvik. All rights reserved.
//

#import <objc/runtime.h>

#import "CreditNotesVC.h"

#import "NetworkHelper.h"
#import "ClientVariable.h"
#import "DVAppDelegate.h"

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

@interface CreditNotesVC () <CustomRenderDelegate, UIDocumentInteractionControllerDelegate>
{
    NSMutableArray* pdfStatusList;
    NSArray* spinnerImages;
    UIDocumentInteractionController* docController;
}

@end

@implementation CreditNotesVC

- (void)viewDidLoad {
    self.customRenderDelegate = self;
    
    pdfStatusList = [[NSMutableArray alloc] initWithCapacity:self.reportPostResponse.tableData.count];
    
    // this will store all the data related for pdf status
    for(int i=0; i<self.reportPostResponse.tableData.count; i++) {
        [pdfStatusList addObject:[[NSMutableDictionary alloc] init]];
    }
    
    
    spinnerImages = [[NSArray alloc] initWithObjects:
    [UIImage imageNamed:@"frame-0"],
    [UIImage imageNamed:@"frame-1"],
    [UIImage imageNamed:@"frame-2"],
    [UIImage imageNamed:@"frame-3"],
    [UIImage imageNamed:@"frame-4"],
    [UIImage imageNamed:@"frame-5"],
    [UIImage imageNamed:@"frame-6"],
    [UIImage imageNamed:@"frame-7"],
    [UIImage imageNamed:@"frame-8"],
    [UIImage imageNamed:@"frame-9"],
    [UIImage imageNamed:@"frame-10"],
    [UIImage imageNamed:@"frame-11"],
    [UIImage imageNamed:@"frame-12"],
    [UIImage imageNamed:@"frame-13"],
    [UIImage imageNamed:@"frame-14"],
    [UIImage imageNamed:@"frame-15"],
    [UIImage imageNamed:@"frame-16"],
    [UIImage imageNamed:@"frame-17"],
    [UIImage imageNamed:@"frame-18"],
    [UIImage imageNamed:@"frame-19"],
    [UIImage imageNamed:@"frame-20"],
    [UIImage imageNamed:@"frame-21"],
    [UIImage imageNamed:@"frame-22"], nil];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void) makeReportScreenV2
{
    self.searchBar.frame = CGRectMake(0, 0, 0, 0);
    [super makeReportScreenV2];
}



- (void) httpResponseObjectHandler:(NSString*) callName :(id) respondedObject :(id) requestedObject
{
    [super httpResponseObjectHandler:callName :respondedObject :requestedObject ];
    
    if([callName isEqualToString:@"cn_checkStatus"]) {
        
        NSNumber* rowNumber =  [requestedObject objectForKey:@"rowIndex"];
        
        [self handleCheckStatusResponse:respondedObject  forRow:[rowNumber integerValue]];
        
    } else if([callName isEqualToString:@"cn_regenerate"]) {
        NSNumber* rowNumber =  [requestedObject objectForKey:@"rowIndex"];
        
        [self handleRegenerateStatusResponse:respondedObject  forRow:[rowNumber integerValue]];
        
    }
    
}
- (void) httpFailureHandler: (NSString*) callName :(NSString*) message
{
    [super httpFailureHandler:callName :message];
    
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
   // NSLog(@"Custom Cell Render: %ld, %ld", (long)rowIndex, (long)colIndex);
    
    UIView* innerView = [view viewWithTag:1000];
    
    if(innerView!=nil) {
        innerView.itemIndex = [NSNumber numberWithInteger:rowIndex];
    }
    
    NSDictionary* pdfStatus = [pdfStatusList objectAtIndex:rowIndex];
    NSNumber* status = [pdfStatus objectForKey:@"status"];
    
    if(status==nil) {
        status = [NSNumber numberWithInteger:-1];
    }
    
    // initial status, we need to check from server for this entry
    if(status.intValue==-1) {
        UIImageView* iconView = [innerView viewWithTag:kICON_TAG];
        
        [iconView removeFromSuperview];
       
        UIImage* iconImage = [UIImage imageNamed:@"genrate"];
        iconView = [[UIImageView alloc] initWithImage:iconImage];
        iconView.frame = innerView.bounds;
        iconView.contentMode = UIViewContentModeCenter;
        iconView.tag = kICON_TAG;
        [innerView addSubview:iconView];
        
        
        // we need to send checkStatus call
        [self checkDocumentStatus:rowIndex];
    } else if(status.intValue==0) {
        UIImageView* iconView = [innerView viewWithTag:kICON_TAG];
        
        [iconView removeFromSuperview];
        
        UIImage* iconImage = [UIImage imageNamed:@"genrate"];
        iconView = [[UIImageView alloc] initWithImage:iconImage];
        iconView.frame = innerView.bounds;
        iconView.contentMode = UIViewContentModeCenter;
        iconView.tag = kICON_TAG;
        [innerView addSubview:iconView];
        
        // user need to click and send regenerate request
        
    } else if(status.intValue==1) {
        // 1 is processing
        // we need to check after 10 secs check again, if it is generated
        innerView.userInteractionEnabled = NO;
        
        UIImageView* iconView = [innerView viewWithTag:kICON_TAG];
         [iconView removeFromSuperview];
                
        iconView = [[UIImageView alloc] initWithFrame:innerView.bounds];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        iconView.tag = kICON_TAG;
        
        iconView.animationImages = nil;
        iconView.animationImages = self->spinnerImages;
        iconView.animationDuration = 0.8;
        [iconView startAnimating];
        
        [innerView addSubview:iconView];

        [innerView setGestureRecognizers:[[NSArray alloc] init]];
        
    } else if(status.intValue==2) {
        // 2 is download
        
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
        
        
    } else if(status.intValue==3) {
        // 3 is for regenerate
    
        UIImageView* iconView = [innerView viewWithTag:kICON_TAG];
        [iconView removeFromSuperview];
        
        UIImage* iconImage = [UIImage imageNamed:@"genrate"];
        iconView = [[UIImageView alloc] initWithImage:iconImage];
        iconView.frame = innerView.bounds;
        iconView.contentMode = UIViewContentModeCenter;
        iconView.tag = kICON_TAG;
        [innerView addSubview:iconView];
        
        innerView.userInteractionEnabled = YES;
        
        [innerView setGestureRecognizers:[[NSArray alloc] init]];
        
        UIGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(generateTapped:)];
        [innerView addGestureRecognizer:tapGesture];
        
    }
    
}

-(void) checkDocumentStatus:(NSInteger) rowIndex
{
    NSArray* rowData = [self.reportPostResponse.tableData objectAtIndex:rowIndex];
    
    NSString* invoiceNumber = [rowData objectAtIndex:3];
    NSString* invoiceDate = [rowData objectAtIndex:4];
    
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    
    NSString* displayAccount = [self.forwardedDataDisplay objectForKey:@"CUSTOMER_NUMBER"];
    NSArray* parts = [displayAccount componentsSeparatedByString:@"-"];
    
    
    NSString *user= [clientVariables.CLIENT_USER_LOGIN userName];
    NSMutableDictionary *postData = [[NSMutableDictionary alloc]init];
    [postData setObject:user forKey: @"registryid" ];
    [postData setObject:[self.forwardedDataPost objectForKey:@"CUSTOMER_NUMBER"] forKey:@"customernumber"];
    [postData setObject:invoiceNumber forKey:@"invoicenumber"];
    [postData setObject:invoiceDate forKey:@"invoicedate"];
    [postData setObject:parts[1] forKey:@"bugroup"];
    
    
    NSMutableDictionary * postCall = [[NSMutableDictionary  alloc]init];
    [postCall setObject:@"cn_checkStatus" forKey:@"opcode"];
    [postCall setObject: postData forKey:@"data"];
    [postCall setObject:clientVariables.CLIENT_LOGIN_RESPONSE.authToken forKey:@"authToken"];
    [postCall setObject:[NSNumber numberWithInteger:rowIndex] forKey:@"rowIndex"];
    
    NetworkHelper * networkHelper = [[NetworkHelper alloc] init];
    NSString* url = XmwcsConst_DEALER_OPCODE_URL;
    networkHelper.serviceURLString = url;
    [networkHelper genericJSONPayloadRequestWith:postCall :self :@"cn_checkStatus"];
}


-(void) handleCheckStatusResponse:(NSDictionary*) statusResponse forRow:(NSInteger) rowIndex
{
    /*
    {"status":"SUCCESS","message":"Download CN","downloadurl":"documentdownload?registryid=10461&customernumber=3453&taxinvoicenumber=2003010550&doctype=CN","generateurl":""}
     */
    if(rowIndex==11) {
        NSLog(@"special case");
    }
    NSDictionary* pdfStatus = [pdfStatusList objectAtIndex:rowIndex];
    
    
    NSString* apiStatus  = [statusResponse objectForKey:@"status"];
    NSString* apiMessage = [statusResponse objectForKey:@"message"];
    NSString* downloadUrl = [statusResponse objectForKey:@"downloadurl"];
    NSString* generateurl = [statusResponse objectForKey:@"generateurl"];
    
    
    if([apiStatus isEqualToString:@"SUCCESS"]) {
        if([apiMessage compare:@"Processing" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            // it is still processing
            NSNumber* status =  [NSNumber numberWithInteger:1];
            [pdfStatus setValue:status forKey:@"status"];
            [pdfStatus setValue:@"" forKey:@"downloadurl"];
            [pdfStatus setValue:@"" forKey:@"generateurl"];
            
            
            NSNumber* retryCount = [pdfStatus objectForKey:@"retryCount"];
            if(retryCount==nil) {
                retryCount = [NSNumber numberWithInteger:0];
            }
            
            retryCount = [NSNumber numberWithInteger:retryCount.integerValue + 1];
            [pdfStatus setValue:retryCount forKey:@"retryCount"];
            
            if(retryCount.integerValue < 10) {
                // we need to create timer request, and change status for Processing
                NSTimer* statusCheckTimer = [NSTimer scheduledTimerWithTimeInterval:10 repeats:NO block:^(NSTimer* timer) {
                    [self checkDocumentStatus:rowIndex];
                }];
            }

        } else {
            if([downloadUrl length]>0) {
                // download available, 2
                NSNumber* status =  [NSNumber numberWithInteger:2];
                [pdfStatus setValue:status forKey:@"status"];
                [pdfStatus setValue:[downloadUrl copy] forKey:@"downloadurl"];
                [pdfStatus setValue:@"" forKey:@"generateurl"];
                
            } else if([generateurl length]>0) {
                // download not available, we need to re/generate it
                // 3
                NSNumber* status =  [NSNumber numberWithInteger:3];
                [pdfStatus setValue:status forKey:@"status"];
                [pdfStatus setValue:@"" forKey:@"downloadurl"];
                [pdfStatus setValue:[generateurl copy] forKey:@"generateurl"];
                
            }
        }
        
        
        for(int i=0; i<[sectionArray count]; i++) {
            NSObject* section = [sectionArray objectAtIndex:i];
            if([section isKindOfClass:[ReportTabularDataSection class]]) {
                NSIndexPath* sectionRow = [NSIndexPath indexPathForItem:rowIndex inSection:i];
                [self.reportTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:sectionRow, nil] withRowAnimation:UITableViewRowAnimationFade];
                break;
            }
        }
        
    }

}


-(void) handleRegenerateStatusResponse:(NSDictionary*) statusResponse forRow:(NSInteger) rowIndex
{
    NSDictionary* pdfStatus = [pdfStatusList objectAtIndex:rowIndex];
    
    NSString* apiStatus  = [statusResponse objectForKey:@"status"];
    NSString* apiMessage = [statusResponse objectForKey:@"message"];
    
    if([apiStatus isEqualToString:@"SUCCESS"]) {
        // message format is Regenerate Request created: <Some Number>
        
        if(apiMessage!=nil && [apiMessage containsString:@"Regenerate Request"]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Polycab" message:@"Credit Note PDF generation request is in process." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault
                handler:^(UIAlertAction * action)
                {
                       // we need to create timer request, and change status for Processing
                    NSTimer* statusCheckTimer = [NSTimer scheduledTimerWithTimeInterval:10 repeats:NO block:^(NSTimer* timer) {
                        [self checkDocumentStatus:rowIndex];
                    }];
                
                    // set the status
                    NSNumber* status =  [NSNumber numberWithInteger:1];
                    [pdfStatus setValue:status forKey:@"status"];
                    [pdfStatus setValue:@"" forKey:@"downloadurl"];
                    [pdfStatus setValue:@"" forKey:@"generateurl"];
                
                // reload the row view
                    for(int i=0; i<[self->sectionArray count]; i++) {
                        NSObject* section = [self->sectionArray objectAtIndex:i];
                        if([section isKindOfClass:[ReportTabularDataSection class]]) {
                            NSIndexPath* sectionRow = [NSIndexPath indexPathForItem:rowIndex inSection:i];
                            [self.reportTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:sectionRow, nil] withRowAnimation:UITableViewRowAnimationFade];
                            break;
                        }
                    }
                }];
            
            [alertController addAction:defaultAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    } else {
        
        if(apiMessage!=nil && [apiMessage length]>0) {
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Polycab" message:apiMessage preferredStyle:UIAlertControllerStyleAlert];
                
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                              
                        }];
            [alertController addAction:defaultAction];
                    
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
    }
    
}



// cn_regenerate

/*
 String registryId = requestData.getString("registryid");
                String customerNumber = requestData.getString("customernumber");
                String invoiceNum = requestData.getString("invoicenumber");
                String invoiceDate = requestData.getString("invoicedate");
                String buGroup = requestData.getString("bugroup");
 */

-(void)downloadTapped:(UIGestureRecognizer*) gesture
{
    NSLog(@"downloadTapped enter, rowIndex = %ld",  [gesture.view.itemIndex integerValue]);
    
    [self  downloadPDF:[gesture.view.itemIndex integerValue]];
    
}


-(void) downloadPDF:(NSInteger) rowIndex
{
    
    loadingView = [LoadingView loadingViewInView:self.view];
    
    NSArray* rowData = [self.reportPostResponse.tableData objectAtIndex:rowIndex];
    
    NSDictionary* pdfStatus = [pdfStatusList objectAtIndex:rowIndex];
    
    NSNumber* status  = [pdfStatus objectForKey:@"status"];
    NSString* downloadUrl = [pdfStatus objectForKey:@"downloadurl"];
    
    NSString* invoiceNum = [rowData objectAtIndex:3];
    
    
    if(status!=nil && status.integerValue==2 && downloadUrl!=nil && downloadUrl.length>0) {
    
        NSString *url;
        NSString *str = XmwcsConst_DEALER_OPCODE_URL;
        
        NSRange replaceRange = [str rangeOfString:@"jsonservice"];
        if (replaceRange.location != NSNotFound){
            NSString* result = [str stringByReplacingCharactersInRange:replaceRange withString:downloadUrl];
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
                            
                            // docController.UTI = [[invoiceNum stringByAppendingString:@"_INV"] stringByAppendingString:@".pdf"];
                      
                            docController.name = [[invoiceNum stringByAppendingString:@"_INV"] stringByAppendingString:@".pdf"];
                      
                            [docController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
                      
                  });
                  
              }
              
          }] resume];
        
    }
            
}


-(void)generateTapped:(UIGestureRecognizer*) gesture
{
    NSLog(@"generateTapped enter, rowIndex = %ld",  [gesture.view.itemIndex integerValue]);
    
    [self  generatePDF:[gesture.view.itemIndex integerValue]];
}


-(void) generatePDF:(NSInteger) rowIndex
{
     loadingView = [LoadingView loadingViewInView:self.view];
     
     NSArray* rowData = [self.reportPostResponse.tableData objectAtIndex:rowIndex];

    NSString* invoiceNumber = [rowData objectAtIndex:3];
    NSString* invoiceDate = [rowData objectAtIndex:4];
    
    ClientVariable* clientVariables = [ClientVariable getInstance : [DVAppDelegate currentModuleContext] ];
    
    NSString* displayAccount = [self.forwardedDataDisplay objectForKey:@"CUSTOMER_NUMBER"];
    NSArray* parts = [displayAccount componentsSeparatedByString:@"-"];
    
    
    NSString *user= [clientVariables.CLIENT_USER_LOGIN userName];
    NSMutableDictionary *postData = [[NSMutableDictionary alloc]init];
    [postData setObject:user forKey: @"registryid" ];
    [postData setObject:[self.forwardedDataPost objectForKey:@"CUSTOMER_NUMBER"] forKey:@"customernumber"];
    [postData setObject:invoiceNumber forKey:@"invoicenumber"];
    [postData setObject:invoiceDate forKey:@"invoicedate"];
    [postData setObject:parts[1] forKey:@"bugroup"];
    
    
    NSMutableDictionary * postCall = [[NSMutableDictionary  alloc]init];
    [postCall setObject:@"cn_regenerate" forKey:@"opcode"];
    [postCall setObject: postData forKey:@"data"];
    [postCall setObject:clientVariables.CLIENT_LOGIN_RESPONSE.authToken forKey:@"authToken"];
    [postCall setObject:[NSNumber numberWithInteger:rowIndex] forKey:@"rowIndex"];
    
    NetworkHelper * networkHelper = [[NetworkHelper alloc] init];
    NSString* url = XmwcsConst_DEALER_OPCODE_URL;
    networkHelper.serviceURLString = url;
    [networkHelper genericJSONPayloadRequestWith:postCall :self :@"cn_regenerate"];
    
}



- (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end
