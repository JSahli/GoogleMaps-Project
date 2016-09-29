//
//  ViewController.h
//  JesseGoogleMapView
//
//  Created by Jesse Sahli on 7/20/16.
//  Copyright © 2016 sahlitude. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSCustomMarker.h"

@import GoogleMaps;

@interface ViewController : UIViewController <UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
- (IBAction)setMapType:(id)sender;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;


@end

