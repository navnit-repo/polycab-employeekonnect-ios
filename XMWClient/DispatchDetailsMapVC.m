//
//  DispatchDetailsMapVC.m
//  XMWClient
//
//  Created by dotvikios on 03/10/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import "DispatchDetailsMapVC.h"
#import "LoadingView.h"
#import "NetworkHelper.h"
#import "XmwcsConstant.h"
#import "XmwUtils.h"

@interface DispatchDetailsMapVC ()

@end

@implementation DispatchDetailsMapVC
{
    LoadingView *loadingView;
    NetworkHelper *networkHelper;
    NSString *latitude;
    NSString *longitude;
    NSString *location;
}
@synthesize mapView;
@synthesize vehicleNo;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setNavigationBar];
    [self netWorkCall];
    
}
-(void)setNavigationBar{
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage
                                                                          imageNamed:@"back-button.png"] style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(backHandler:)];
    
    backButton.tintColor = [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
    
    
    [self.navigationItem setLeftBarButtonItem:backButton];
    
    UIImageView *polycabLogo = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"polycab_logo"]];
    self.navigationItem.titleView.contentMode = UIViewContentModeCenter;
    self.navigationItem.titleView = polycabLogo;
    
}
- (void) backHandler : (id) sender
{
    
    
    [ [self navigationController]  popViewControllerAnimated:YES];
    
}

-(void)netWorkCall
{
    NSLog(@"%@",vehicleNo);
    if (vehicleNo.length ==0) {
        //do nothing
        
          [XmwUtils toastView:@"Vehicle No not available."];
    }
    else{
        //Network Call
        loadingView= [LoadingView loadingViewInView:self.view];
        NSMutableDictionary *tracker = [[NSMutableDictionary alloc]init];
        [tracker setObject:@"vehicleTracker" forKey:@"opcode"];
        [tracker setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"AUTH_TOKEN"] forKey:@"authToken"];
        
        NSMutableDictionary * data = [[NSMutableDictionary  alloc]init];
        [data setObject:@"MH04DD3533" forKey:@"vehiclenumber"];
        [tracker setObject:data  forKey:@"data"];
        networkHelper = [[NetworkHelper alloc]init];
        NSString * url=XmwcsConst_OPCODE_URL;
        networkHelper.serviceURLString = url;
        [networkHelper genericJSONPayloadRequestWith:tracker :self :@"vehicleTracker"];
        
        
    }
    
    
}


- (void) httpResponseObjectHandler : (NSString*) callName : (id) respondedObject : (id) requestedObject
{
    [loadingView removeView];
    if ([callName isEqualToString:@"vehicleTracker"]) {
        if ([[respondedObject valueForKey:@"status"]isEqualToString:@"SUCCESS"]) {
            latitude = [respondedObject valueForKey:@"Latitude"];
            longitude =[respondedObject valueForKey:@"Longitude"];
            location = [respondedObject valueForKey:@"Location"];
            [self loadMap];
        }
       
    }
}
- (void) httpFailureHandler : (NSString*) callName : (NSString*) message {
    [loadingView removeView];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"mKonnect Authentication!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [myAlertView show];
    
}


-(void)loadMap{
    MKPointAnnotation*    annotation = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D myCoordinate;
    myCoordinate.latitude= [latitude doubleValue];
    myCoordinate.longitude= [longitude doubleValue];
   // myCoordinate.latitude=  28.4541908;
   // myCoordinate.longitude= 77.0750448;
    annotation.coordinate = myCoordinate;
    [self.mapView addAnnotation:annotation];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = annotation.coordinate;
    point.subtitle = location;
    
    [self.mapView addAnnotation:point];
    
    
    
}

@end
