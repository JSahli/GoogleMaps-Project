//
//  ViewController.m
//  JesseGoogleMapView
//
//  Created by Jesse Sahli on 7/20/16.
//  Copyright © 2016 sahlitude. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"
#import "Keys.h"

@interface ViewController () <GMSMapViewDelegate>


@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:40.741445
                                                            longitude:-73.989966
                                                                 zoom:15.5];
    [self prefersStatusBarHidden];
    self.mapView.myLocationEnabled = YES;
    self.mapView.camera = camera;
    self.mapView.delegate = self;
    [self hardCodePins];
    self.searchBar.delegate = self;
 }



-(void)hardCodePins {
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(40.741445, -73.989966);
    marker.title = @"TurnToTech";
    marker.snippet = @"Mobbile Dev Bootcamp";
    marker.map = self.mapView;
    marker.infoWindowAnchor = CGPointMake(0.5, -0.25);
    
    GMSMarker *marker2 = [[GMSMarker alloc] init];
    marker2.position = CLLocationCoordinate2DMake(40.744292, -73.990459);
    marker2.title = @"Hill Country BBQ";
    marker2.snippet = @"NYC Texas style BBQ";
    marker2.map = self.mapView;
    marker2.infoWindowAnchor = CGPointMake(0.5, -0.25);
    
    GMSMarker *marker3 = [[GMSMarker alloc] init];
    marker3.position = CLLocationCoordinate2DMake(40.740721, -73.988193);
    marker3.title = @"ChopT";
    marker3.snippet = @"Creative Salad Company";
    marker3.map = self.mapView;
    marker3.infoWindowAnchor = CGPointMake(0.5, -0.25);
}



-(UIView*) mapView: (GMSMapView*)mapView markerInfoWindow:(GMSMarker *)marker
{
    JSCustomMarker * infoWindow = [[[NSBundle mainBundle]loadNibNamed:@"JSCustomMarker" owner:self options:nil]objectAtIndex:0];
    
    infoWindow.title.text = marker.title;
    infoWindow.subtitle.text = marker.snippet;
    infoWindow.image.image = [UIImage imageNamed:@"mapicon"];
    
    return infoWindow;
}



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.mapView clear];
    CLLocationCoordinate2D currentCoord = self.mapView.camera.target;
    double currentLat = currentCoord.latitude;
    double currentLong = currentCoord.longitude;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=%@&location=%f,%f&radius=1000&keyword=%@", [Keys getServerKey],currentLat, currentLong, self.searchBar.text]];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    request.HTTPMethod = @"GET";
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"error: %@", error.localizedDescription);
        } else {
            NSError *jsonError;
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            NSLog(@"%@", jsonDictionary);
            
            NSArray *results = [jsonDictionary objectForKey:@"results"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //do work here
                    for (NSDictionary *result in results) {
                        
                        GMSMarker *marker = [[GMSMarker alloc]init];
                        marker.title = [result objectForKey:@"name"];
                        marker.snippet = [NSString stringWithFormat:@"Google Review Rating: %@", [result objectForKey:@"rating"]];
                        NSNumber *latitude = [[[result objectForKey:@"geometry"]objectForKey:@"location"]objectForKey:@"lat"];
                        NSNumber *longitude = [[[result objectForKey:@"geometry"]objectForKey:@"location"]objectForKey:@"lng"];
                        CLLocationCoordinate2D position = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
                        marker.position = position;
                        marker.infoWindowAnchor = CGPointMake(0.5, -0.25);
                        marker.map = self.mapView;
                    }
                });
        }
    }]
     resume];
    [self.view endEditing:YES];
}



-(BOOL)prefersStatusBarHidden{
    return YES;
}



-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    
    JSCustomMarker *myMarker = (JSCustomMarker*)marker;
    WebViewController *webVC = [[WebViewController alloc]init];
    [self presentViewController:webVC animated:YES completion:nil];
}



- (IBAction)setMapType:(id)sender {
    
    switch (((UISegmentedControl *)sender).selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = kGMSTypeNormal;
            break;
        case 1:
            self.mapView.mapType = kGMSTypeHybrid;
            break;
        case 2:
            self.mapView.mapType = kGMSTypeSatellite;
            break;
            
        default:
            self.mapView.mapType = kGMSTypeNormal;
            break;
    }
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
