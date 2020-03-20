//
//  ImageUploadFormViewController.m
//  QCMSProject
//
//  Created by Anoop Kundal on 6/23/17.
//  Copyright © 2017 dotvik. All rights reserved.
//

#import "ImageUploadFormViewController.h"
#import "Styles.h"
#import "DotFormPost.h"
#import "NetworkHelper.h"

@interface ImageUploadFormViewController ()
{
    
}

@end

@implementation ImageUploadFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self drawNavigationButtonItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) drawNavigationButtonItem
{
    self.title              = @"GSTN Form";
    
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor], NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName, nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    self.navigationController.navigationBar.translucent = NO;
    
    UILabel*  titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
    titleLabel.text =@"GSTN Form";
    titleLabel.textColor = [Styles headerTextColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.navigationItem setTitleView: titleLabel];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStyleBordered target:self
                                                                  action:@selector(backHandler:)];
    backButton.tintColor = [Styles barButtonTextColor];
     [self.navigationItem setLeftBarButtonItem:backButton];
    
}

- (void) backHandler : (id) sender
{
    
    [ [self navigationController]  popViewControllerAnimated:YES];
    
}



- (IBAction)uploadImageBtn:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Take Photo" otherButtonTitles:@"Choose Photo", nil];
    [actionSheet showInView:self.view];
    
}

- (IBAction)submitBtn:(id)sender {
    
    DotFormPost *dotFormPost = [[DotFormPost alloc]init];
    
   /* [dotFormPost setAdapterType:adapterType];
    [dotFormPost setAdapterId:adapterId];
    [dotFormPost setModuleId:AppConst_MOBILET_ID_DEFAULT];
    [dotFormPost setDocId:adapterId];
    */
    loadingView = [LoadingView loadingViewInView:self.view];
    
    NetworkHelper *networkHelper = [[NetworkHelper alloc] init];
    [networkHelper makeXmwNetworkCall:dotFormPost :self : nil :  @"GSTNFormSubmit"];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *choice = [actionSheet buttonTitleAtIndex:buttonIndex];
    //if (buttonIndex == [actionSheet destructiveButtonIndex]) {
    if ([choice isEqualToString:@"Take Photo"])
    {
        //  NSLog(@"Open Camera");
        UIImagePickerController *imagePickController=[[UIImagePickerController alloc]init];
        imagePickController.sourceType=UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController    isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            imagePickController.sourceType=UIImagePickerControllerSourceTypeCamera;
            imagePickController.showsCameraControls=YES;
        }
        imagePickController.delegate=self;
        // imagePickController.allowsEditing=NO;
        [self presentModalViewController:imagePickController animated:YES];
        
    }
    else if ([choice isEqualToString:@"Choose Photo"])
    {
        // NSLog(@"Open Gallery");
        UIImagePickerController *imagePickController=[[UIImagePickerController alloc]init];
        imagePickController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        if ([UIImagePickerController  isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            imagePickController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        }
        else if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
        {
            imagePickController.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
        imagePickController.delegate=self;
        // imagePickController.allowsEditing=NO;
        [self presentModalViewController:imagePickController animated:YES];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker  didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    UIImage *originalImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    CGFloat newwidth = 960;
    CGFloat newheight = (originalImage.size.height / originalImage.size.width) * newwidth;
    
    CGRect rect = CGRectMake(0.0,0.0,newwidth,newheight);
    UIGraphicsBeginImageContext(rect.size);
    [originalImage drawInRect:rect];
    originalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *data = UIImageJPEGRepresentation (
                                              originalImage,
                                              0.0
                                              );
    //  NSLog(@"%@ = camera Data",data);
    
    self.imageView.image = originalImage;
    [self dismissModalViewControllerAnimated:YES];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //NSLog(@"textFieldShouldReturn field tag = %d", textField.tag);
    [textField resignFirstResponder];
    return TRUE;
}


- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    [loadingView removeView];
    
    if ([callName isEqualToString : @"GSTNFormSubmit"])
    {
        
    }

}

- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    
    [loadingView removeView];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Polycab Error!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
        
    
}




@end
