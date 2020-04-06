//
//  MultipleFileAttachmentView.m
//  XMWClient
//
//  Created by Tushar Gupta on 20/08/19.
//  Copyright © 2019 dotvik. All rights reserved.
//

#import "MultipleFileAttachmentView.h"
#import "ProgressBarView.h"
#import "NetworkHelper.h"
#import "Styles.h"
#import <MobileCoreServices/MobileCoreServices.h>
@implementation MultipleFileAttachmentView
{
    FormVC *vc;
    NSIndexPath *selectedImageViewIndexPath;
    NSMutableDictionary *imageDataDict;
    int imageCount;
    ProgressBarView* progressBarView;
    NSMutableDictionary *imageViewServerImagesNameDict;
    NSMutableDictionary *imageSuccessfullUploadedFlagDict;
    UIDocumentInteractionController* documentInteractionController;
    
}
@synthesize isUploadImageOnServer;
@synthesize addMore;
@synthesize imageTableView;
@synthesize ufmrefidArray;
@synthesize formElement;
@synthesize singleUFMRefid;
- (instancetype)initWithFrame:(CGRect)frame :(FormVC*) formVC
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self configureSomeObjecjs :formVC];
        
        addMore = [[MXButton alloc ] initWithFrame:CGRectMake(24, 11, self.frame.size.width-48, 40)];
        
        [addMore setTitleColor:[UIColor colorWithRed:204.0/255 green:43.0/255 blue:43.0/255 alpha:1.0] forState:UIControlStateNormal];
        addMore.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        addMore.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        [addMore addTarget:self action:@selector(addMoreImageView:) forControlEvents:UIControlEventTouchUpInside];
        
        imageTableView = [[UITableView alloc ] initWithFrame:CGRectMake(16, 55, self.frame.size.width - 32, 140)];
        imageTableView.dataSource = self;
        imageTableView.delegate = self;
        [self addSubview:imageTableView];
        [self addSubview:addMore];
    }
    return self;
}
-(void) configureSomeObjecjs :(FormVC *) formVC
{
    ufmrefidArray = [[NSMutableArray alloc ] init];
    imageDataDict = [[NSMutableDictionary alloc ] init];
    vc = (FormVC *) formVC;
    imageCount = 0;
    UIImage *imageName = [UIImage imageNamed:@"lixil_add_grey.png"];
    [imageDataDict setObject:imageName forKey:@"0"];
    
    imageViewServerImagesNameDict = [[NSMutableDictionary alloc ] init];
    imageSuccessfullUploadedFlagDict = [[NSMutableDictionary alloc ] init];
    NSString *defaultImageViewTag = @"6000";
    [imageSuccessfullUploadedFlagDict setObject:@"false" forKey:defaultImageViewTag];
}


#pragma mark - Table View Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [imageDataDict count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifire= [NSString stringWithFormat:@"cell_%ld",(long)indexPath.row];
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifire];
    if (cell == nil) {
        cell = [[UITableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifire];
        
        UIImageView*     imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width/3.5, 3, 120, 120)];
        [imageView setContentMode:UIViewContentModeCenter];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.layer.cornerRadius = 10;
        imageView.clipsToBounds = YES;
        //            [imageView setImage:[UIImage imageNamed:@"lixil_add_grey.png"]];
        imageView.tag = indexPath.row + 6000;
        imageView.layer.borderWidth = 1.0f;
        imageView.layer.borderColor = [[UIColor colorWithRed:217.0/255.0 green:230.0/255.0 blue:236.0/255.0 alpha:1.0] CGColor ];
        imageView.layer.masksToBounds = YES;
        
        [cell.contentView addSubview:imageView];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
       // return cell;
    }
    
    return cell;
    
}
    - (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
    {
        UIImageView *imageView = [vc.view viewWithTag:(indexPath.row +6000)];
        NSString * index = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        UIImage *image =[imageDataDict objectForKey: index];
        [imageView setImage:image];
        
        long tag = indexPath.row + 6000;
        NSString *imageViewtag = [NSString stringWithFormat:@"%ld",tag];
        if ([[imageSuccessfullUploadedFlagDict objectForKey: imageViewtag] isEqualToString:@"false"]) {
            [imageView setContentMode:UIViewContentModeCenter];
        }
        
    }

-(void)goToBottom
{
    NSIndexPath *lastIndexPath = [self lastIndexPath];
    
    [imageTableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
-(NSIndexPath *)lastIndexPath
{
    NSInteger lastSectionIndex = MAX(0, [imageTableView numberOfSections] - 1);
    NSInteger lastRowIndex = MAX(0, [imageTableView numberOfRowsInSection:lastSectionIndex] - 1);
    return [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedImageViewIndexPath = indexPath;
    long tag = 6000 + indexPath.row;
    NSString *imageViewTag = [NSString stringWithFormat:@"%ld",tag];
//    if (![[imageSuccessfullUploadedFlagDict objectForKey:imageViewTag] isEqualToString:@"true"]) {
        // Fetch extended Property Map
         NSMutableArray *array = [[NSMutableArray alloc] init];
        if(formElement.extendedProperty!=nil && [formElement.extendedProperty length]>0) {
           
            NSDictionary* extendedPropMap =  [XmwUtils getExtendedPropertyMap:formElement.extendedProperty];
            NSString* acceptedTypes = [extendedPropMap objectForKey:@"ACCEPTED_MIME_TYPE"];
            if(acceptedTypes!=nil && [acceptedTypes length]>0) {
                NSArray* parts = [acceptedTypes componentsSeparatedByString:@"$"];
                if([parts count]>0) {
                    array = [[NSMutableArray alloc] init];
                    if([parts containsObject:@"jpg"] || [parts containsObject:@"png"]) {
                        [array addObject:@"Take a Photo"];
                        [array addObject:@"Gallery"];
                    }
                    
                    for(int i=0; i<[parts count]; i++) {
                        NSString* part = [parts objectAtIndex:i];
                        if(([part compare:@"jpg" options:NSCaseInsensitiveSearch]!=NSOrderedSame)
                           && ([part compare:@"png" options:NSCaseInsensitiveSearch]!=NSOrderedSame) )
                        {
                            [array addObject:[part copy]];
                        }
                    }
                }
            }
        }

        
        
        else
        {
             array = [[NSMutableArray alloc] initWithObjects:@"Take a Photo",@"Gallery",@"Document",nil];
        }
   
        
        UIAlertView *fileAttachmentAlertView = [[UIAlertView alloc] initWithTitle:@"File Upload"
                                                                          message:nil delegate:self
                                                                cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        
        fileAttachmentAlertView.alertViewStyle = UIAlertViewStyleDefault;
        
        for(NSString *buttonTitle in array)
        {
            [fileAttachmentAlertView addButtonWithTitle:buttonTitle];
        }
        fileAttachmentAlertView.tag = 100; //handle alertview action according to tag
        
        [fileAttachmentAlertView show];
//    }
    
//    else {
        // do nothing
//    }
 
}

#pragma mark - HttpEventListener

- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
   
    [progressBarView removeView];
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        if([callName isEqualToString:@"ImagePostDataRequest"])
        {
            if ([[respondedObject valueForKey:@"status"]isEqualToString:@"SUCCESS"]) {
                NSString * uploadedImageName = [[[respondedObject valueForKey:@"xmwuploadfilemaster"] valueForKey:@"ufmfilename"]componentsJoinedByString:@""];
                NSLog(@"uploaded Image Name : %@",uploadedImageName);

                NSArray *array = [uploadedImageName componentsSeparatedByString:@"."];
                NSString *finalImageName = [array objectAtIndex:0];
                NSLog(@"Final uploaded Image Name : %@",finalImageName);
                
                int imageViewTag = [[imageViewServerImagesNameDict objectForKey:finalImageName] intValue];
            
                [imageSuccessfullUploadedFlagDict setObject:@"true" forKey:[NSString stringWithFormat:@"%d",imageViewTag]];
                
                UIImageView *imageView  = [vc.view viewWithTag:imageViewTag];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                UIImage *image =[imageDataDict objectForKey: [NSString stringWithFormat:@"%d",(imageViewTag - 6000)]];
                [imageView setImage:image];
                
                 isUploadImageOnServer = true;
                MXButton* button = (MXButton*)  [vc getDataFromId:@"SUBMIT"];
                button.backgroundColor = [UIColor colorWithRed:233.0/255 green:86.0/255 blue:0.0/255 alpha:1.0];
                button.userInteractionEnabled = YES;
                
                NSString * ufmrefid = [[[respondedObject valueForKey:@"xmwuploadfilemaster"] valueForKey:@"ufmrefid"] componentsJoinedByString:@""];
                NSLog(@"File Upload ufmrefid : %@",ufmrefid);
                [ufmrefidArray addObject:ufmrefid];
                self.singleUFMRefid = ufmrefid;
                
            }
            
            else
            {
                NSLog(@"bug catch");
                isUploadImageOnServer = true;
                   MXButton* button = (MXButton*)  [vc getDataFromId:@"SUBMIT"];
                   button.backgroundColor = [UIColor colorWithRed:233.0/255 green:86.0/255 blue:0.0/255 alpha:1.0];
                   button.userInteractionEnabled = YES;
                   
                   NSArray *imageViewArray = [[imageDataDict allKeys] mutableCopy];
                   for (int i=0; i<imageViewArray.count; i++) {
                       int tag = 6000 + [[imageViewArray objectAtIndex:i] intValue];
                       NSString *tagString = [NSString stringWithFormat:@"%d",tag];
                       if ([[imageSuccessfullUploadedFlagDict objectForKey:tagString] isEqualToString:@"false"]) {
                           UIImage *imageName = [UIImage imageNamed:@"lixil_add_grey.png"];
                           NSString *replaceDisplayImageWithTag = [NSString stringWithFormat:@"%d",i];
                           [imageDataDict setObject:imageName forKey:replaceDisplayImageWithTag];
                           
                           UIImageView *imageView  = [vc.view viewWithTag:tag];
                           imageView.contentMode = UIViewContentModeCenter;
                           [imageView setImage:imageName];
                       }

                   }
                
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Connect Response!" message:[respondedObject valueForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
                   [myAlertView show];
            }
        }
        
        else if ([callName isEqualToString:@"DocumentPostDataRequest"])
        {
             if ([[respondedObject valueForKey:@"status"]isEqualToString:@"SUCCESS"]) {
             isUploadImageOnServer = true;
            MXButton* button = (MXButton*)  [vc getDataFromId:@"SUBMIT"];
            button.backgroundColor = [UIColor colorWithRed:233.0/255 green:86.0/255 blue:0.0/255 alpha:1.0];
            button.userInteractionEnabled = YES;
            
            NSString * ufmrefid = [[[respondedObject valueForKey:@"xmwuploadfilemaster"] valueForKey:@"ufmrefid"] componentsJoinedByString:@""];
            NSLog(@"File Upload ufmrefid : %@",ufmrefid);
            [ufmrefidArray addObject:ufmrefid];
            self.singleUFMRefid = ufmrefid;
        }
            
            else
            {
                NSLog(@"bug catch");
                isUploadImageOnServer = true;
                MXButton* button = (MXButton*)  [vc getDataFromId:@"SUBMIT"];
                button.backgroundColor = [UIColor colorWithRed:233.0/255 green:86.0/255 blue:0.0/255 alpha:1.0];
                button.userInteractionEnabled = YES;
                
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Connect Response!" message:[respondedObject valueForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
                                  [myAlertView show];
            }
        }
        
    });
    
    
}

- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    [progressBarView removeView];
    isUploadImageOnServer = true;
    MXButton* button = (MXButton*)  [vc getDataFromId:@"SUBMIT"];
    button.backgroundColor = [UIColor colorWithRed:233.0/255 green:86.0/255 blue:0.0/255 alpha:1.0];
    button.userInteractionEnabled = YES;
    
    NSArray *imageViewArray = [[imageDataDict allKeys] mutableCopy];
    for (int i=0; i<imageViewArray.count; i++) {
        int tag = 6000 + [[imageViewArray objectAtIndex:i] intValue];
        NSString *tagString = [NSString stringWithFormat:@"%d",tag];
        if ([[imageSuccessfullUploadedFlagDict objectForKey:tagString] isEqualToString:@"false"]) {
            UIImage *imageName = [UIImage imageNamed:@"lixil_add_grey.png"];
            NSString *replaceDisplayImageWithTag = [NSString stringWithFormat:@"%d",i];
            [imageDataDict setObject:imageName forKey:replaceDisplayImageWithTag];
            
            UIImageView *imageView  = [vc.view viewWithTag:tag];
            imageView.contentMode = UIViewContentModeCenter;
            [imageView setImage:imageName];
        }

    }
    
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Connect Response!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
    
    //for single attachment
    singleUFMRefid = nil;
    
}

- (void) httpInterruptHandler : (NSString*) callName : (NSString*) message {
    [progressBarView removeView];
    isUploadImageOnServer = true;
    MXButton* button = (MXButton*)  [vc getDataFromId:@"SUBMIT"];
    button.backgroundColor = [UIColor colorWithRed:233.0/255 green:86.0/255 blue:0.0/255 alpha:1.0];
    button.userInteractionEnabled = YES;
    
    NSArray *imageViewArray = [[imageDataDict allKeys] mutableCopy];
    for (int i=0; i<imageViewArray.count; i++) {
        int tag = 6000 + [[imageViewArray objectAtIndex:i] intValue];
        NSString *tagString = [NSString stringWithFormat:@"%d",tag];
        if ([[imageSuccessfullUploadedFlagDict objectForKey:tagString] isEqualToString:@"false"]) {
            UIImage *imageName = [UIImage imageNamed:@"lixil_add_grey.png"];
            NSString *replaceDisplayImageWithTag = [NSString stringWithFormat:@"%d",i];
            [imageDataDict setObject:imageName forKey:replaceDisplayImageWithTag];
            
            UIImageView *imageView  = [vc.view viewWithTag:tag];
            imageView.contentMode = UIViewContentModeCenter;
            [imageView setImage:imageName];
        }
        
    }
    //for single attachment
    singleUFMRefid = nil;
}


#pragma mark- Add File Button Handler
-(IBAction)addMoreImageView:(id)sender
{
   
    
    if (imageCount<4) {
         imageCount = imageCount + 1;
        
        NSString * index = [NSString stringWithFormat:@"%d",imageCount];
        UIImage *imageName = [UIImage imageNamed:@"lixil_add_grey.png"];
        [imageDataDict setObject:imageName forKey:index];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [imageTableView reloadData];
            
            [self goToBottom];
        });
    }
    
    else // max limit excced
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"You can't add more than 5 attachment." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
                                        {
                                            // do nothing
                                            
                                        }];
        
        [alertController addAction:defaultAction];
    
        
        
        UIViewController* root = [[[[UIApplication sharedApplication]windows]objectAtIndex:0] rootViewController];
        UIViewController *assignViewController = nil;
        
      
            assignViewController = root;
    
        
        
        [assignViewController presentViewController:alertController animated:YES completion:nil];
    }
   
    
   
}

#pragma mark - ImagePickerView methods

- (void)takePhoto {
    
    if (! [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *deviceNotFoundAlert = [[UIAlertView alloc] initWithTitle:@"No Device" message:@"Camera is not available"
                                                                     delegate:nil
                                                            cancelButtonTitle:@"Okay"
                                                            otherButtonTitles:nil];
        [deviceNotFoundAlert show];
        
    } else {
        
        UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
        cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraPicker.allowsEditing = YES;
        cameraPicker.delegate =self;
        [vc presentViewController:cameraPicker animated:YES completion:nil];
    }
    
    
}
- (void)selectPhotoFromGallery {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [vc presentViewController:picker animated:YES completion:NULL];
    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
     NSString * index = [NSString stringWithFormat:@"%ld",(long)selectedImageViewIndexPath.row];
     UIImage *originalImage=[info objectForKey:UIImagePickerControllerOriginalImage];
//     [imageDataDict setObject:originalImage forKey:index];
    
     UIImageView *imageView  = [vc.view viewWithTag:(selectedImageViewIndexPath.row + 6000)];
    // imageView.contentMode = UIViewContentModeScaleAspectFill;
//     [imageView setImage:originalImage];
     [picker dismissViewControllerAnimated:YES completion:NULL];
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    if ([info objectForKey:UIImagePickerControllerReferenceURL] == NULL) {
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd_MM_yyyy_HH-mm-ss"];
        // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
        NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
        NSString *clickImageDate = [dateFormatter stringFromDate:[NSDate date]];
        
        [dict setObject:clickImageDate forKey:@"image_id"];
        [dict setObject:vc.dotForm.formId forKey:@"formID"];
        
    }
    
    else{
        NSString *imagePath = [[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
        
        NSRange r1 = [imagePath rangeOfString:@"id="];
        NSRange r2 = [imagePath rangeOfString:@"&ext="];
        NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
        NSString *sub = [imagePath substringWithRange:rSub];
        NSLog(@"image id %@",sub);
        
        [dict setObject:sub forKey:@"image_id"];
        [dict setObject:vc.dotForm.formId forKey:@"formID"];
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    NSData *orignalData = UIImageJPEGRepresentation (
                                               originalImage,
                                               0.0
                                               );
    
       CGFloat newwidth;
       CGFloat newheight;
    
    if (orignalData.length >= 4000000) {
    // 1/4
        newwidth = originalImage.size.width /4;
        newheight = originalImage.size.height/4;
    }
    
    else if (orignalData.length > 2000000 && orignalData.length < 4000000)
    {
        // 1/2
        newwidth = originalImage.size.width /2;
        newheight = originalImage.size.height/2;
    }
    
    else
    {
        // same size
        
        newwidth = originalImage.size.width;
        newheight = originalImage.size.height;
    }
    
    
//    CGFloat newwidth = 960;
//    CGFloat newheight = (originalImage.size.height / originalImage.size.width) * newwidth;
    
    CGRect rect = CGRectMake(0.0,0.0,newwidth,newheight);
    UIGraphicsBeginImageContext(rect.size);
    [originalImage drawInRect:rect];
    originalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [imageDataDict setObject:originalImage forKey:index];
    
    NSData *data = UIImageJPEGRepresentation (
                                              originalImage,
                                              0.0
                                              );
    
   progressBarView = [ProgressBarView progressBarViewInView:imageView];
   NetworkHelper*   networkHelper = [[NetworkHelper alloc] init];
    
    [networkHelper makeXmwNetworkCallForImagePost:dict :self : nil :@"ImagePostDataRequest" : data];
    
    NSString *imageViewTag = [NSString stringWithFormat:@"%ld",(selectedImageViewIndexPath.row + 6000)];
    [imageViewServerImagesNameDict setObject:imageViewTag forKey:[dict objectForKey:@"image_id"]];
    
    [imageSuccessfullUploadedFlagDict setObject:@"false" forKey:imageViewTag];
    
    
    isUploadImageOnServer = false;
    MXButton* button = (MXButton*)  [vc getDataFromId:@"SUBMIT"];
    button.backgroundColor = [Styles disableTextFieldColor];
    button.userInteractionEnabled = NO;
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - AlertView Delegate Mathods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    
  if (alertView.tag == 100){ // file attachment alertview
        
        NSString *click = [alertView buttonTitleAtIndex:buttonIndex];
        
        if([click isEqualToString:@"Take a Photo"])
        {
            
            [self takePhoto];
            
        }
        else if([click isEqualToString: @"Gallery"])
        {
            [self selectPhotoFromGallery];
        }
      
     
      
        else if (  [click compare:@"pdf" options:NSCaseInsensitiveSearch] == NSOrderedSame || [click isEqualToString: @"Document"])
      {
          // working progress

          [self configureDocumentsPicker];
          
      }
      
        
    }
    
    
}
#pragma mark - Document Methods

-(void)configureDocumentsPicker
{
    NSArray*types=@[(NSString*)kUTTypePDF];


    //Create a object of document picker view and set the mode to Import
    UIDocumentPickerViewController *docPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:types inMode:UIDocumentPickerModeImport];

    //Set the delegate
    docPicker.delegate = self;
    //present the document picker
    [vc presentViewController:docPicker animated:YES completion:nil];

}
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url
{
    UIImageView *imageView  = [vc.view viewWithTag:(selectedImageViewIndexPath.row + 6000)];
    NSString *filename = [url lastPathComponent];
    NSString *fileExtension = [url pathExtension];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    progressBarView = [ProgressBarView progressBarViewInView:imageView];
    NetworkHelper*   networkHelper = [[NetworkHelper alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:filename forKey:@"image_id"];
    [dict setObject:vc.dotForm.formId forKey:@"formID"];
    [networkHelper makeXmwNetworkCallForDocumentPost:dict :self : nil :@"ImagePostDataRequest" : data];
    
    isUploadImageOnServer = false;
    
    
    
    NSString *imageViewTag = [NSString stringWithFormat:@"%ld",(selectedImageViewIndexPath.row + 6000)];
    
    NSArray *array = [[dict objectForKey:@"image_id"] componentsSeparatedByString:@"."];
    NSString *finalImageName = [array objectAtIndex:0];

    
    [imageViewServerImagesNameDict setObject:imageViewTag forKey:finalImageName];
    
    [imageSuccessfullUploadedFlagDict setObject:@"false" forKey:imageViewTag];
    
    NSString * index = [NSString stringWithFormat:@"%ld",(long)selectedImageViewIndexPath.row];
    [imageDataDict setObject:[UIImage imageNamed:@"doc_uploaded.png"] forKey:index];
}
- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
   
}


@end
