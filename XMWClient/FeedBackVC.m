//
//  FeedBackVC.m
//  XMWClient
//
//  Created by dotvikios on 23/07/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "FeedBackVC.h"

@interface FeedBackVC ()

@end

@implementation FeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"FeedBackVC Call");
 
    self.navigationItem.titleView.hidden = YES;
 }

- (IBAction)attachmentButton:(id)sender {
    [self button];
}
-(void)button{
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@"Image",@"Other",nil];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Attachment"
                                                        message:nil delegate:self
                                              cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    
    alertView.alertViewStyle = UIAlertViewStyleDefault;
    
    for(NSString *buttonTitle in array)
    {
        [alertView addButtonWithTitle:buttonTitle];
    }
    
    [alertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSString *click = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([click isEqualToString:@"Image"])
    {
        NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@"Camera",@"Gallery",nil];
        
        UIAlertView *imageAlertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:nil delegate:self
                                                  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        
        imageAlertView.alertViewStyle = UIAlertViewStyleDefault;
        
        for(NSString *buttonTitle in array)
        {
            [imageAlertView addButtonWithTitle:buttonTitle];
        }
        
        [imageAlertView show];
    }
   
    else if([click isEqualToString: @"Other"])
    {
        
    }
    else if([click isEqualToString: @"Camera"])
    {
        [self takePhoto];
    }
    else if([click isEqualToString: @"Gallery"])
    {
        [self selectPhoto];
    }
}

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
    [self presentViewController:cameraPicker animated:YES completion:nil];
}
    
    
}
- (void)selectPhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    NSString *data = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
