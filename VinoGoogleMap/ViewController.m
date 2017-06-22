    //
    //  ViewController.m
    //  VinoGoogleMap
    //
    //  Created by aryvart3 on 03/09/16.
    //  Copyright © 2016 aryvart3. All rights reserved.
    //

    #import "ViewController.h"
    #import "AFJSONRequestOperation.h"
    #import <MapKit/MapKit.h>

    @import GoogleMaps;
    @interface ViewController ()
    {
        BOOL hitted;
        NSArray *array;
        NSDictionary *loc;

    }


    @end

    @implementation ViewController



    - (void)viewDidLoad
    {
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        //Controls whether the My Location dot and accuracy circle is enabled.
        self.mapView.myLocationEnabled = YES;
        
        //Controls the type of map tiles that should be displayed.
    //    self.mapView.mapType = kGMSTypeNormal;
        self.mapView.mapType = kGMSTypeHybrid;

        //Shows the compass button on the map
        self.mapView.settings.compassButton = YES;
        
        //Shows the my location button on the map
        self.mapView.settings.myLocationButton = YES;
        
        //Sets the view controller to be the GMSMapView delegate
        self.mapView.delegate = self;
        
        //    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:9.925201
        //                                                            longitude:78.119775
        //                                                                 zoom:6];
        //    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
        //    self.mapView.myLocationEnabled = YES;
        //    self.back_view= self.mapView;
        GMSCameraPosition *fancy = [GMSCameraPosition cameraWithLatitude:9.925201
                                                               longitude:78.119775
                                                                    zoom:6
                                                                 bearing:30
                                                            viewingAngle:45];
        [_mapView setCamera:fancy];
        
        // Creates a marker at kolkata location.
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.icon=[UIImage imageNamed:@"location_icon.png"];
        marker.position = CLLocationCoordinate2DMake(9.925201, 78.119775);
        marker.title = @"Madurai";
        marker.snippet = @"Kolkata";
        marker.map = self.mapView;
        
        
        GMSMarker *marker1 = [[GMSMarker alloc] init];
        marker.icon=[UIImage imageNamed:@"location_icon.png"];
        marker1.position = CLLocationCoordinate2DMake(13.082680,80.270718);
        marker1.title = @"chennai";
        marker1.snippet = @"cehnnai";
        marker1.map = _mapView;
        
        
        [self loadMapViewWithDirection];
        
        
        
    }


    - (NSString *)parseResponse:(NSDictionary *)response {
        NSArray *routes = [response objectForKey:@"routes"];
        NSDictionary *route = [routes lastObject];
        if (route) {
            NSString *overviewPolyline = [[route objectForKey:
                                           @"overview_polyline"] objectForKey:@"points"];
            return overviewPolyline;
        }
        return @"";
    }
    -(NSMutableArray *)decodePolyLine:(NSString *)encodedStr {
        NSMutableString *encoded = [[NSMutableString alloc]
                                    initWithCapacity:[encodedStr length]];
        [encoded appendString:encodedStr];
        [encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
                                    options:NSLiteralSearch
                                      range:NSMakeRange(0,
                                                        [encoded length])];
        NSInteger len = [encoded length];
        NSInteger index = 0;
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSInteger lat=0;
        NSInteger lng=0;
        while (index < len) {
            NSInteger b;
            NSInteger shift = 0;
            NSInteger result = 0;
            do {
                b = [encoded characterAtIndex:index++] - 63;
                result |= (b & 0x1f) << shift;
                shift += 5;
            } while (b >= 0x20);
            NSInteger dlat = ((result & 1) ? ~(result >> 1)
                              : (result >> 1));
            lat += dlat;
            shift = 0;
            result = 0;
            do {
                b = [encoded characterAtIndex:index++] - 63;
                result |= (b & 0x1f) << shift;
                shift += 5;
            } while (b >= 0x20);
            NSInteger dlng = ((result & 1) ? ~(result >> 1)
                              : (result >> 1));
            lng += dlng;
            NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
            NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
            CLLocation *location = [[CLLocation alloc] initWithLatitude:
                                    [latitude floatValue] longitude:[longitude floatValue]];
            [array addObject:location];
        }
        return array;
    }
    - (void)loadMapViewWithDirection {
        
        float lat = 23.050671;
        float lng = 72.541351;
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat
                                                                longitude:lng
                                                                     zoom:10];
        
        GMSMapView  * mapView = [GMSMapView mapWithFrame:CGRectMake(0, 75, 320, self.view.frame.size.height) camera:camera];
        self.mapView.myLocationEnabled = YES;
        
        float sourceLatitude = 11.913860;
        float sourceLongitude = 79.814472;
        
        float destLatitude = 12.971599;
        float destLongitude = 77.594563;

        
    //    float sourceLatitude = 8.425916;
    //    float sourceLongitude = 78.025247;
    //    
    //    float destLatitude = 8.496308;
    //    float destLongitude = 78.125085;
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(sourceLatitude, sourceLongitude);
        marker.map = self.mapView;
        
        GMSMarker *destmarker = [[GMSMarker alloc] init];
        destmarker.position = CLLocationCoordinate2DMake(destLatitude, destLongitude);
        destmarker.map = self.mapView;
        
        self.mapView.delegate = self;
        
        [self drawDirection:CLLocationCoordinate2DMake(sourceLatitude, sourceLongitude) and:CLLocationCoordinate2DMake(destLatitude, destLongitude)];
        
        
        //[self.view addSubview:self.mapView];
    }
    - (void) drawDirection:(CLLocationCoordinate2D)source and:(CLLocationCoordinate2D) dest {
        
        
        GMSPolyline *polyline = [[GMSPolyline alloc] init];
        GMSMutablePath *path = [GMSMutablePath path];
        
        NSString* saddr = [NSString stringWithFormat:@"%f,%f", source.latitude, source.longitude];
        NSString* daddr = [NSString stringWithFormat:@"%f,%f", dest.latitude, dest.longitude];
        if(!hitted)
        {
            //NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&sensor=false&avoid=highways&mode=driving",saddr,daddr]];
            NSString *loadurl=[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&sensor=false&avoid=highways&mode=driving",saddr,daddr];
            
            //NSURL *url = [[NSURL alloc] initWithString:@"http://itunes.apple.com/search?term=harry&country=us&entity=movie"];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:loadurl]];
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                                    
            NSDictionary *jsonDict = (NSDictionary *) JSON;
            loc=JSON;
                
       
                int points_count = 0;
                points_count = [[[[[[jsonDict objectForKey:@"routes"] objectAtIndex:0] objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"steps"] count];
                
                NSArray *steps = nil;
                if (points_count && [[[[jsonDict objectForKey:@"routes"] objectAtIndex:0] objectForKey:@"legs"] count])
                {
                    steps = [[[[[jsonDict objectForKey:@"routes"] objectAtIndex:0] objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"steps"];
                }
                
                NSMutableArray *coordinates = [[NSMutableArray alloc] initWithCapacity:points_count];
                for (int i = 0; i < points_count; i++)
                {
                    NSString *toDecode = [[[steps objectAtIndex:i] objectForKey:@"polyline"] valueForKey:@"points"];
                    NSArray *locations = [self decodePolylineWithString:toDecode];
                    
                    for (int i = 0 ; i < locations.count ; i++)
                    {
                        if (i != locations.count - 1) {
                            CLLocation *start = [locations objectAtIndex:i];
                            CLLocation *finish = [locations objectAtIndex:i + 1];
                            [coordinates addObject:@{ @"start" : start, @"finish" : finish }];
                        }
                    }
                }
                
                GMSMutablePath *path = [GMSMutablePath path];
                for (NSDictionary *d in coordinates)
                {
                    CLLocation *start = d[@"start"];
                    CLLocation *finish = d[@"finish"];
                    
                    [path addCoordinate:start.coordinate];
                    [path addCoordinate:finish.coordinate];
                }
                
                GMSPolyline *line = [GMSPolyline polylineWithPath:path];
                line.strokeColor = [UIColor redColor];
                line.strokeWidth = 2.0f;
                line.map = self.mapView;
                
                
                
            }
            failure:^(NSURLRequest *request, NSHTTPURLResponse *response,NSError *error, id JSON)
            {
                NSLog(@"Request Failure Because %@",[error userInfo]);
            }];
            
            [operation start];
            
            
            
        }
        

        hitted =YES;
        
//        NSArray * points =array;
//        if(points ==nil)
//        {
//            points=array;
//        }
//        
//        NSInteger numberOfSteps = points.count;
//        
//        for (NSInteger index = 0; index < numberOfSteps; index++)
//        {
//            CLLocation *location = [points objectAtIndex:index];
//            CLLocationCoordinate2D coordinate = location.coordinate;
//            [path addCoordinate:coordinate];
//        }
//        
//        polyline.path = path;
//        polyline.strokeColor = [UIColor redColor];
//        polyline.strokeWidth = 5.f;
//        polyline.map = self.mapView;
//        
//        // Copy the previous polyline, change its color, and mark it as geodesic.
//        polyline = [polyline copy];
//        polyline.strokeColor = [UIColor blueColor];
//        polyline.geodesic = YES;
//        polyline.map = self.mapView;
        
        
        
    }


- (NSArray*)decodePolylineWithString:(NSString *)encodedString
{
    NSMutableArray *coordinates = [NSMutableArray array];
    const char *bytes = [encodedString UTF8String];
    NSUInteger length = [encodedString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger idx = 0;
    
    NSUInteger count = length / 4;
    CLLocationCoordinate2D *coords = calloc(count, sizeof(CLLocationCoordinate2D));
    NSUInteger coordIdx = 0;
    
    float latitude = 0;
    float longitude = 0;
    while (idx < length) {
        char byte = 0;
        int res = 0;
        char shift = 0;
        
        do {
            byte = bytes[idx++] - 63;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLat = ((res & 1) ? ~(res >> 1) : (res >> 1));
        latitude += deltaLat;
        
        shift = 0;
        res = 0;
        
        do {
            byte = bytes[idx++] - 0x3F;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLon = ((res & 1) ? ~(res >> 1) : (res >> 1));
        longitude += deltaLon;
        
        float finalLat = latitude * 1E-5;
        float finalLon = longitude * 1E-5;
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(finalLat, finalLon);
        coords[coordIdx++] = coord;
        CLLocation *location = [[CLLocation alloc] initWithLatitude:finalLat longitude:finalLon];
        [coordinates addObject:location];
        
        if (coordIdx == count) {
            NSUInteger newCount = count + 10;
            coords = realloc(coords, newCount * sizeof(CLLocationCoordinate2D));
            count = newCount;
        }
    }
    
    free(coords);
    return coordinates;
}
    /*
    - (void)viewDidLoad {
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib
        
        
    //    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:37.80948
    //                                                            longitude:5.965699
    //                                                                 zoom:2];
    //    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    //    
    //    // Available map types: kGMSTypeNormal, kGMSTypeSatellite, kGMSTypeHybrid,
    //    // kGMSTypeTerrain, kGMSTypeNone
    //    
    //    // Set the mapType to Satellite
    //        mapView.myLocationEnabled = YES;
    //
    //    mapView.mapType = kGMSTypeHybrid;
    //        GMSMarker *marker = [[GMSMarker alloc] init];
    //    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    //        marker.title = @"Sydney";
    //        marker.snippet = @"Australia";
    //        marker.map = mapView;
    //
    //    self.view = mapView;
        
        
        

        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                                longitude:151.20
                                                                     zoom:6];
        GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
        mapView.myLocationEnabled = YES;
        self.view = mapView;
            mapView.mapType = kGMSTypeHybrid;

        // Creates a marker in the center of the map.
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
        marker.title = @"Sydney";
        marker.snippet = @"Australia";
        marker.map = mapView;
        
        
    //    GMSMutablePath *path = [GMSMutablePath path];
    //    [path addCoordinate:CLLocationCoordinate2DMake(@(18.520).doubleValue,@(73.856).doubleValue)];
    //    [path addCoordinate:CLLocationCoordinate2DMake(@(16.7).doubleValue,@(73.8567).doubleValue)];
    //    
    //    GMSPolyline *rectangle = [GMSPolyline polylineWithPath:path];
    //    rectangle.strokeWidth = 2.f;
    //    rectangle.map = mapView;
        
        
        
        GMSMutablePath *path = [GMSMutablePath path];
        [path addLatitude:11.913860 longitude:79.814472]; // Sydney
        [path addLatitude:13.082680 longitude:80.270718]; // Fiji
      //  [path addLatitude:21.291 longitude:-157.821]; // Hawaii
       // [path addLatitude:37.423 longitude:-122.091]; // Mountain View
      //
        GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
        polyline.strokeColor = [UIColor blueColor];
        polyline.strokeWidth = 5.f;
        polyline.map = mapView;
        
        
        
    //    CLLocationCoordinate2D panoramaNear = {50.059139,-122.958391};
    //    
    //    GMSPanoramaView *panoView =
    //    [GMSPanoramaView panoramaWithFrame:CGRectZero
    //                        nearCoordinate:panoramaNear];
    //    
    //    self.view = panoView;
        
        
        
    //    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.868
    //                                                            longitude:151.2086
    //                                                                 zoom:6];
    //    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    //    
    //    GMSMarker *marker = [[GMSMarker alloc] init];
    //    marker.position = camera.target;
    //    marker.snippet = @"Hello World";
    //    marker.appearAnimation = kGMSMarkerAnimationPop;
    //    marker.map = mapView;
    //    
    //    self.view = mapView;
    }
    */


    - (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

    @end
