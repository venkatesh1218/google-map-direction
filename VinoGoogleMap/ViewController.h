//
//  ViewController.h
//  VinoGoogleMap
//
//  Created by aryvart3 on 03/09/16.
//  Copyright © 2016 aryvart3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>


@interface ViewController : UIViewController<GMSMapViewDelegate>
@property (strong, nonatomic) IBOutlet GMSMapView *mapView;


@end

