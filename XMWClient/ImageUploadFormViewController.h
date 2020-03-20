//
//  ImageUploadFormViewController.h
//  QCMSProject
//
//  Created by Anoop Kundal on 6/23/17.
//  Copyright © 2017 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpEventListener.h"
#import "LoadingView.h"

@interface ImageUploadFormViewController : UIViewController<HttpEventListener>
{
     LoadingView* loadingView;
}

@property (weak, nonatomic) IBOutlet UITextField *gstnTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)uploadImageBtn:(id)sender;
- (IBAction)submitBtn:(id)sender;

@end
