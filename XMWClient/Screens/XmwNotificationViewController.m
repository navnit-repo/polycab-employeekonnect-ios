//
//  XMWNotification.m
//  QCMSProject
//
//  Created by Ashish Tiwari on 24/09/14.
//  Copyright (c) 2014 dotvik. All rights reserved.
//

#import <objc/runtime.h>

#import "XmwNotificationViewController.h"
#import "XmwNotificationWebViewController.h"
#import "XmwcsConstant.h"
#import "NetworkHelper.h"
#import "LoadingView.h"
#import "ClientVariable.h"
#import "DVAppDelegate.h"
#import "NotificationRequestItem.h"
#import "NotificationRequestStorage.h"

#import "DotNotificationSend.h"
#import "Styles.h"

#import "XmwHttpFileDownloader.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>

#define LOCAL_PLAY_ALERT_TAG 9001

@interface UIAlertView (Play)
@property NSURL* localPlayURL;
@end

@implementation UIAlertView (Play)
- (NSURL*)localPlayURL;
{
    return objc_getAssociatedObject(self, "localPlayURL");
}

- (void)setLocalPlayURL:(NSURL*)property;
{
    objc_setAssociatedObject(self, "localPlayURL", property, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end




@interface XmwNotificationViewController ()
{
    NetworkHelper* networkHelper;
    LoadingView* loadingView;
    NSMutableArray* notificationList;
     NSString *notificationLaunchUrl;
    
     UIRefreshControl *refreshControl;
}

@end

@implementation XmwNotificationViewController

@synthesize imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        notificationList = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    notificationTableViewList.allowsMultipleSelectionDuringEditing = NO;
    
    if(isiPhone5) {
        self.view.frame = CGRectMake(0, 64, 320, 504);
    } else {
        // 0, 64, 320, 416
        self.view.frame = CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 64.0f);
    }
   
    [self drawHeaderItem];
    
    [self recievedNotificationFromStorage];
    
}

-(void) drawHeaderItem
{
    self.title = @"Notification Inbox";
    
    self.navigationController.navigationBar.tintColor = [Styles barButtonTextColor];
    
    [self drawTitle: @"Notification Inbox"];
    
    //animate custom view add
    
    NSArray *images = [NSArray arrayWithObjects:
                       
                       [UIImage imageNamed:@"downloadImage.png"],
                       
                       [UIImage imageNamed:@"downloadImage1.png"],
                       
                       [UIImage imageNamed:@"downloadImage2.png"],
                       
                       [UIImage imageNamed:@"downloadImage3.png"],
                       
                       nil];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"downloadImage.png"]];
    
    self.imageView.animationImages = images;
    
    self.imageView.animationDuration = 0.8;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.bounds = imageView.bounds;
    
    [button addSubview:imageView];
    
    [button addTarget:self action:@selector(downloadButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView: button] ;
    
    
    [self.navigationItem setRightBarButtonItem:rightBarButton];
    
}

- (void)refresh:(UIRefreshControl *)refreshControl {
   
        [self recievedNotificationFromStorage];
    
    
}


-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FETCH_PENDING_NOTF" object:nil];
    }
    [super viewWillDisappear:animated];
}

- (void) backHandler : (id) sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FETCH_PENDING_NOTF" object:nil];
    [ [self navigationController]  popViewControllerAnimated:YES];
    
}

-(void) drawTitle:(NSString *)headerStr
{
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    // self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    UILabel*  titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
    titleLabel.text = @"Notification Inbox";
    titleLabel.textColor = [Styles headerTextColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.navigationItem setTitleView: titleLabel];
    
}


# pragma - mark table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

# pragma - mark tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [notificationList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NotificationCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [self initializeNotificaitonItemCell:cell :indexPath];
    }
    
    [self configureNotificationDataInCell:cell withIndex:indexPath];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self configureNotificationDataInCell:cell withIndex:indexPath];
    
}


// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        

        NotificationRequestItem *notificationRequestItem = [notificationList objectAtIndex:indexPath.row];
        
        NotificationRequestStorage* storage = [NotificationRequestStorage getInstance];
        notificationRequestItem.KEY_DELETE = @"True";
        [storage updateDoc : notificationRequestItem];
        
        [notificationList removeObjectAtIndex:indexPath.row];//added for remove data
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //DotNotificationSend* notificationObject = (DotNotificationSend* )[notificationList objectAtIndex:indexPath.row];
    NotificationRequestItem *notificationRequestItem = [notificationList objectAtIndex:indexPath.row];
    
    notificationLaunchUrl = nil;
    notificationLaunchUrl = notificationRequestItem.KEY_NOTIFY_CONTENT_URL;//notificationObject.notifyContentUrl;
    NSString *notificationContentType = notificationRequestItem.KEY_NOTIFY_CONTENT_TYPE;
    
    NotificationRequestStorage* storage = [NotificationRequestStorage getInstance];
    notificationRequestItem.KEY_READ = @"Read";
    [storage updateDoc : notificationRequestItem];
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    UIView* container = [cell viewWithTag:101];
    UILabel* textLabel = (UILabel*)[container viewWithTag:1001];
    [textLabel setFont:[UIFont systemFontOfSize:15]];
    
    if([notificationContentType isEqualToString:@"url"])
    {
        if(notificationLaunchUrl.length > 0)
        {
            
            if([self isDownloadable:notificationLaunchUrl]) {
                NSRange rangeVideoMp4 =  [notificationLaunchUrl rangeOfString:@".mp4"];
                NSRange rangeImagePng =  [notificationLaunchUrl rangeOfString:@".png"];
                NSRange rangeImageJpg =  [notificationLaunchUrl rangeOfString:@".jpg"];
                if(rangeVideoMp4.length>0)
                {
                    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Would you like to download/open video." delegate:self cancelButtonTitle:@"Download" otherButtonTitles:@"Cancel" ,@"Open", nil];
                    myAlertView.tag = 800;
                    [myAlertView show];
                } else if(rangeImagePng.length>0) {
                    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Would you like to download/open image." delegate:self cancelButtonTitle:@"Download" otherButtonTitles:@"Cancel" ,@"Open", nil];
                    myAlertView.tag = 801;
                    [myAlertView show];
                } else if (rangeImageJpg.length>0) {
                    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Would you like to download/open image." delegate:self cancelButtonTitle:@"Download" otherButtonTitles:@"Cancel" ,@"Open", nil];
                    myAlertView.tag = 802;
                    [myAlertView show];
                }
            } else {
                
                if(notificationLaunchUrl.length > 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //code to be executed in the background
                        XmwNotificationWebViewController *notificationWebViewController = [[XmwNotificationWebViewController alloc]initWithNibName:@"XmwNotificationWebViewController" bundle:nil];
                        
                        notificationWebViewController.urlString = notificationLaunchUrl;
                        
                        [[self navigationController] pushViewController:notificationWebViewController  animated:YES];
                    });
                }
            }
        }
    }
    else
    {//it mean it is text message
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:notificationRequestItem.KEY_NOTIFY_COTENT_MSG delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];

    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void) initializeNotificaitonItemCell:(UITableViewCell*) cell :(NSIndexPath *)indexPath
{
    
    if (cell!=nil) {
        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
        UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
        containerView.backgroundColor = [UIColor clearColor];
        containerView.tag = 101;
        
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width-50, 40)];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.font =  [UIFont systemFontOfSize:16.0];
        textLabel.textAlignment = NSTextAlignmentLeft;
        textLabel.tag = 1001;
        
        [containerView addSubview:textLabel];
        [cell.contentView addSubview:containerView];
        cell.contentView.backgroundColor = [UIColor clearColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
}


-(void)configureNotificationDataInCell:(UITableViewCell*)cell withIndex:(NSIndexPath *)indexPath
{
    
    //DotNotificationSend* notificationObject = (DotNotificationSend* )[notificationList objectAtIndex:indexPath.row];
    NotificationRequestItem *notificationRequestItem = [notificationList objectAtIndex:indexPath.row];
    UIView* containerView  = [cell viewWithTag:101];
    UILabel* textLabel = (UILabel*)[containerView viewWithTag:1001];
    textLabel.text = notificationRequestItem.KEY_NOTIFY_CONTENT_TITLE;//notificationObject.notifyContentTitle;
    if([notificationRequestItem.KEY_READ caseInsensitiveCompare:@"Read"]==NSOrderedSame)
    {
        //containerView.backgroundColor = [UIColor clearColor];
        
        [textLabel setFont:[UIFont systemFontOfSize:15]];
       
        
    } else {
       // containerView.backgroundColor = [UIColor redColor];
        [textLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    
}


-(void)recievedNotificationFromStorage
{
    [NotificationRequestStorage createInstance : @"NOTIFICATION_STORAGE" : true];
    NotificationRequestStorage *notificationStorage = [NotificationRequestStorage getInstance];
    NSMutableArray *notificationStorageData = [notificationStorage getRecentDocumentsData : @"False"];
    
    
    if([notificationStorageData count] >0)
    {
        notificationList = notificationStorageData;
        
        notificationTableViewList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        notificationTableViewList.delegate = self;
        notificationTableViewList.dataSource = self;
        [self.view addSubview:notificationTableViewList];
        
        refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
        [notificationTableViewList addSubview:refreshControl];
    }
    else
    {
       
        
        UILabel *alertMessage = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 300, self.view.bounds.size.height - 100)];
        
        alertMessage.text = @"No Notification alert for the Havells mKonnect User.";
        alertMessage.textAlignment = NSTextAlignmentCenter;
        alertMessage.numberOfLines = 0;
        alertMessage.textColor = [UIColor blackColor];
        [self.view addSubview:alertMessage];
    }
    
     [refreshControl endRefreshing];
   
}


//Swipe Table View Storage

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

//table View Cell Swiping code with delegate

- (void)configureCell:(MCSwipeTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIView *checkView = [self viewWithImageName:@"icon_move_completed"];
    UIColor *greenColor = [self colorWithHexString:@"62D962"];//[UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0];
    
    UIView *crossView = [self viewWithImageName:@"icon_delete"];
    UIColor *redColor = [self colorWithHexString:@"F55200"]; //[UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];
    
    
    [cell setDefaultColor:redColor];//self.curatedContentViewInboxList.backgroundView.backgroundColor];
    
    [cell setDelegate:self];
    [cell setSwipeGestureWithView:crossView color:redColor mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        // //NSLog(@"Did swipe \"Cross\" cell");
        
        [self deleteCell:cell];
    }];
    
}

#pragma mark - MCSwipeTableViewCellDelegate


// When the user starts swiping the cell this method is called
- (void)swipeTableViewCellDidStartSwiping:(MCSwipeTableViewCell *)cell {
    // //NSLog(@"Did start swiping the cell!");
}

// When the user ends swiping the cell this method is called
- (void)swipeTableViewCellDidEndSwiping:(MCSwipeTableViewCell *)cell {
    // //NSLog(@"Did end swiping the cell!");
}

// When the user is dragging, this method is called and return the dragged percentage from the border
- (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didSwipeWithPercentage:(CGFloat)percentage {
    // //NSLog(@"Did swipe with percentage : %f", percentage);
}


- (void)deleteCell:(MCSwipeTableViewCell *)cell {
    NSParameterAssert(cell);
    
    NSIndexPath *indexPath = [notificationTableViewList indexPathForCell:cell];
    NotificationRequestItem *notificationRequestItem = [notificationList objectAtIndex:indexPath.row];
    
    NotificationRequestStorage* storage = [NotificationRequestStorage getInstance];
    notificationRequestItem.KEY_DELETE = @"True";
    [storage updateDoc : notificationRequestItem];
    
    [notificationList removeObjectAtIndex:indexPath.row];//added for remove data
    [notificationTableViewList deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    
}

- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0,0,image.size.width,image.size.height); //add ashish for center alignment of cross & correct image
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //  NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ((alertView.tag == 801) || (alertView.tag == 802) || (alertView.tag == 800))
    {
        NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
        if([title isEqualToString:@"Download"])
        {
            [XmwUtils toastView:@"Your download started."];
            [self.imageView startAnimating];
            
            XmwHttpFileDownloader* fileDownloader = [[XmwHttpFileDownloader alloc] initWithUrl:notificationLaunchUrl];
            
            [fileDownloader downloadStart:self];
        }
        else if ([title isEqualToString:@"Open"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //code to be executed in the background
                XmwNotificationWebViewController *notificationWebViewController = [[XmwNotificationWebViewController alloc]initWithNibName:@"XmwNotificationWebViewController" bundle:nil];
                
                notificationWebViewController.urlString = notificationLaunchUrl;
                
                [[self navigationController] pushViewController:notificationWebViewController  animated:YES];
            });
        }
    } else if(alertView.tag == LOCAL_PLAY_ALERT_TAG) {
        NSURL* localSavedURL = alertView.localPlayURL;
        if(buttonIndex==0) {
            dispatch_async(dispatch_get_main_queue(), ^() {
                MPMoviePlayerViewController *moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:localSavedURL];
                [self presentMoviePlayerViewControllerAnimated:moviePlayerController];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieFinishedCallback:)
                                                             name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayerController];
            });
        }
    }
}

-(void) downloadCompleted :(NSString*) savedFilename
{
    NSLog(@"Video Download Completed");
    
    NSURL *url=[[NSURL alloc] initFileURLWithPath:savedFilename];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    if([library videoAtPathIsCompatibleWithSavedPhotosAlbum:url])
    {
        [library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error)
         {
             if(error)
             {
                 NSLog(@"error=%@",error.localizedDescription);
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"File Downloader" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
                 [alertView show];
             }
             else
             {
                 NSLog(@"URL = %@",assetURL);
                 NSLog(@"Download completed...");
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"File Downloader" message:@"Video Saved. Do you want to play it." delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No" , nil];
                 alertView.localPlayURL = assetURL;
                 alertView.tag = LOCAL_PLAY_ALERT_TAG;
                 [alertView show];
             }
             
         }];
    } else {
        NSLog(@"error, video not saved...");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"File Downloader" message:@"error, video not saved..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        [alertView show];
    }
    
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:savedFilename];
    if(image!=nil)
    {
        [library writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation                          completionBlock:^(NSURL* assetURL, NSError* error)
         {
             if (error) {
                 NSLog(@"image not saved");
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"File Downloader" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
                 [alertView show];
                 
             } else {
                 NSLog(@"image saved ");
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"File Downloader" message:@"Save image" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
                 alertView.localPlayURL = assetURL;
                 alertView.tag = LOCAL_PLAY_ALERT_TAG;
                 [alertView show];
                 
             }
             
         }];
    }
    
    [self.imageView stopAnimating];
    [XmwUtils toastView:@"Download Complete"];
}

-(void) percentDownloadComplete : (float) percent
{
    // NSLog( @"@%f Percent Download ", percent);
}

-(void) failedToDownlad:(NSString*) message
{
    [self.imageView stopAnimating];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"File Downloader Error" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [alertView show];
}


- (void) downloadButtonHandler : (id) sender
{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Downloaded Video/Image is in your device photo gallery." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
    
}


-(BOOL) isDownloadable:(NSString*) urlString
{
    BOOL retVal = NO;
    
    NSRange rangeVideoMp4 =  [urlString rangeOfString:@".mp4"];
    NSRange rangeImagePng =  [urlString rangeOfString:@".png"];
    NSRange rangeImageJpg =  [urlString rangeOfString:@".jpg"];
    if(rangeVideoMp4.length>0) {
        return YES;
    } else if(rangeImagePng.length>0) {
        return YES;
    } else if (rangeImageJpg.length>0) {
        return YES;
    } else {
        return NO;
    }
    return retVal;
}


// When the movie is done, release the controller.
-(void)myMovieFinishedCallback:(NSNotification*)aNotification {
    [self dismissMoviePlayerViewControllerAnimated];
    MPMoviePlayerController* theMovie = [aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];
}

@end
