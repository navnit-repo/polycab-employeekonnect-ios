//
//  ItemWiseSalesReport.m
//  XMWClient
//
//  Created by Pradeep Singh on 29/11/20.
//  Copyright © 2020 dotvik. All rights reserved.
//

#import <objc/runtime.h>

#import "ItemWiseSalesReport.h"
#import "XmwcsConstant.h"


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


@interface ItemWiseSalesReport () <CustomRenderDelegate, UIDocumentInteractionControllerDelegate>
{
    UIDocumentInteractionController* docController;
}

@end

@implementation ItemWiseSalesReport

- (void)viewDidLoad {
    self.customRenderDelegate = self;
    self.disableSearchBar = YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

-(CGFloat) cellHeight:(DotReportElement*) element row:(NSInteger) rowIndex col:(NSInteger) colIndex data:(NSString*) text
{
    NSLog(@"cellHeight() for row =  %ld, col = %ld", (long)rowIndex, colIndex);
    
    if(colIndex==0) {
        NSArray* rowData = [self.reportPostResponse.tableData objectAtIndex:rowIndex];
        
        NSString* itemCode = [rowData objectAtIndex:0];
        NSString* invoiceDesc = [rowData objectAtIndex:1];
        
        NSString *string = [NSString stringWithFormat:@"%@\n%@", itemCode, invoiceDesc];
        
        CGSize maximumLabelSize = CGSizeMake([element.length intValue]-10, FLT_MAX);
        
        CGRect expectedLabelSize =  [string boundingRectWithSize:maximumLabelSize
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:@{ NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0f] }
                                                             context:nil];
        return expectedLabelSize.size.height;

    } else {
        return 50.0f;
    }
}

-(void) renderElement:(DotReportElement*) element row:(NSInteger) rowIndex col:(NSInteger) colIndex data:(NSString*) text view:(UIView*) view
{
    NSLog(@"renderElement() for row =  %ld, col = %ld", (long)rowIndex, colIndex);

    
    UIView* innerView = [view viewWithTag:1000];
    
    if(innerView!=nil) {
        innerView.itemIndex = [NSNumber numberWithInteger:rowIndex];
    }
    
    if(colIndex==0) {
        
        NSArray* rowData = [self.reportPostResponse.tableData objectAtIndex:rowIndex];
        
        NSString* itemCode = [rowData objectAtIndex:0];
        NSString* invoiceDesc = [rowData objectAtIndex:1];
        
        UILabel* label = [innerView viewWithTag:kICON_TAG];
        [label removeFromSuperview];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, view.frame.size.width - 10.0f, 100.0f)];
        label.tag = kICON_TAG;
       // label.text = itemCode;
        label.font = [UIFont boldSystemFontOfSize:14.0f];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        
        NSString *string = [NSString stringWithFormat:@"%@\n%@", itemCode, invoiceDesc];
        NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:string];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        
        [attrString beginEditing];

        [attrString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(0, itemCode.length)];
        
        [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(itemCode.length + 1, invoiceDesc.length)];
        
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(itemCode.length + 1, invoiceDesc.length)];

        [attrString endEditing];
        
        label.attributedText = attrString;
        
        CGSize maximumLabelSize = CGSizeMake([element.length intValue] - 10, FLT_MAX);
        
        CGRect expectedLabelSize =  [string boundingRectWithSize:maximumLabelSize
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:@{ NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0f] }
                                                             context:nil];
        
        label.frame = CGRectMake(5, 0, expectedLabelSize.size.width, expectedLabelSize.size.height);
        
       [innerView addSubview:label];
        
    } else if(colIndex==7) {
        
        UIImageView* iconView = [innerView viewWithTag:kICON_TAG];
        [iconView removeFromSuperview];
        
        if([text isKindOfClass:[NSString class]] && [text length]>0) {
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
    
}


-(void)downloadTapped:(UIGestureRecognizer*) gesture
{
    NSLog(@"downloadTapped enter, rowIndex = %ld",  [gesture.view.itemIndex integerValue]);
    
    [self  downloadPDF:[gesture.view.itemIndex integerValue]];
    
}


-(void) downloadPDF:(NSInteger) rowIndex
{
    NSArray* rowData = [self.reportPostResponse.tableData objectAtIndex:rowIndex];
    
    NSString* sheetUri = [rowData objectAtIndex:7];
    
    NSMutableString* uri = [[NSMutableString alloc] init];
    [uri appendString:sheetUri];
    
         
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

@end
