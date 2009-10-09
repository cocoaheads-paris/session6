//
//  demoMapKit1AppDelegate.h
//  demoMapKit1
//
//  Created by Michel Ho Fong Fat on 10/8/09.
//  Copyright Michel Ho Fong Fat 2009. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "MyAnnotation.h"

@interface demoMapKit1AppDelegate : NSObject <UIApplicationDelegate, MKMapViewDelegate, MKReverseGeocoderDelegate> {
    UIWindow *window;
	
	IBOutlet MKMapView					*mMapView;
	IBOutlet UIActivityIndicatorView	*mActivityIndicator;
	IBOutlet UITextField				*mAddressTextField;
}
@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet MKMapView *mMapView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *mActivityIndicator;
@property (nonatomic, retain) IBOutlet UITextField *mAddressTextField;

- (IBAction)setMapTypeToStandard;
- (IBAction)setMapTypeToSatellite;
- (IBAction)setMapTypeToHybrid;

- (IBAction)setRegion1;
- (IBAction)setRegion2;
- (IBAction)setCenter;
- (IBAction)zoomToUserLocation;
- (IBAction)addAnnotation1;
- (IBAction)lookupAddress;
- (IBAction)editingEnded:(id)sender;

@end

