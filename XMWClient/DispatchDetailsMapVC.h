//
//  DispatchDetailsMapVC.h
//  XMWClient
//
//  Created by dotvikios on 03/10/18.
//  Copyright © 2018 dotvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/Mapkit.h>

@interface DispatchDetailsMapVC :UIViewController
{
   
    NSString *vehicleNo;
}
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property NSString *vehicleNo;

@end
