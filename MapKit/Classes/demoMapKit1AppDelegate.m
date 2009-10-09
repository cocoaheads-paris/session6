//
//  demoMapKit1AppDelegate.m
//  demoMapKit1
//
//  Created by Michel Ho Fong Fat on 10/8/09.
//  Copyright Michel Ho Fong Fat 2009. All rights reserved.
//

#import "demoMapKit1AppDelegate.h"

@implementation demoMapKit1AppDelegate

@synthesize window;
@synthesize mMapView;
@synthesize mActivityIndicator;
@synthesize mAddressTextField;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    

	// Default YES
	[mMapView setScrollEnabled:YES];
	[mMapView setZoomEnabled:YES];

	// Enable User Location
	[mMapView setShowsUserLocation:YES];
	
	// Set Title and Subtitle
	[[mMapView userLocation] setTitle:@"Tu tournes en rond?"];
	[[mMapView userLocation] setSubtitle:@"Depuis combien de temps?"];
 
	// Set the delegate
	[mMapView setDelegate:self];
    // Override point for customization after application launch
    [window makeKeyAndVisible];
}

- (IBAction)setMapTypeToStandard {
	[mMapView setMapType:MKMapTypeStandard];
}

- (IBAction)setMapTypeToSatellite {
	[mMapView setMapType:MKMapTypeSatellite];
}

- (IBAction)setMapTypeToHybrid {
	[mMapView setMapType:MKMapTypeHybrid];
}

// Spirit Cafe coordinates
#define SpiritCafeLatitude	48.8678726
#define SpiritCafeLongitude	 2.3369155

- (IBAction)setRegion1 {

	// Create the region
	MKCoordinateRegion region;
	
	// Specify the center of the region
	region.center.latitude = SpiritCafeLatitude;
	region.center.longitude = SpiritCafeLongitude;
	
	// Set Zoom level using Span
	region.span.latitudeDelta = 9.0; // 9 degrees equals 999 kilometers for France
	region.span.longitudeDelta = 1.0;
	// Note : value of 0.0 makes 3.1 crashing
	
	// Apply the region to the MapView
	[mMapView setRegion:region animated:YES];
}

- (IBAction)setRegion2 {
	// Create the region
	MKCoordinateRegion region;
	
	// Specify the center of the region
	region.center.latitude = SpiritCafeLatitude;
	region.center.longitude = SpiritCafeLongitude;
	
	// Set Zoom level using Span
	region.span.latitudeDelta = 0.09; // 0.09 degrees equals 9.99 kilometers for Paris

	region.span.longitudeDelta = 0.09;
	// Note : value of 0.0 makes 3.1 crashing
	
	// Apply the region to the MapView
	[mMapView setRegion:region animated:YES];
	
	MKCoordinateRegion fitRegion = [mMapView regionThatFits:region];
	
	NSLog(@"region - %f, %f, %f, %f",
		  region.center.latitude,
		  region.center.longitude,
		  region.span.latitudeDelta,
		  region.span.longitudeDelta);
	NSLog(@"fitRegion - %f, %f, %f, %f",
		  fitRegion.center.latitude,
		  fitRegion.center.longitude,
		  fitRegion.span.latitudeDelta,
		  fitRegion.span.longitudeDelta);
}

- (IBAction)setCenter {
	CLLocationCoordinate2D center;
	center.latitude = 37.783795;
	center.longitude = -122.403754;
	[mMapView setCenterCoordinate:center animated:YES];
}

- (IBAction)zoomToUserLocation {
	if ([[mMapView userLocation] location] != nil) {
		// Center the map to User Location
		// Create the region
		MKCoordinateRegion region;
		
		// Specify the center of the region
		region.center = [[mMapView userLocation] coordinate];
		
		// Set Zoom level using Span
		region.span.latitudeDelta = 0.005;
		region.span.longitudeDelta = 0.005;
		// Note : value of 0.0 makes 3.1 crashing
		
		// Apply the region to the MapView
		[mMapView setRegion:region animated:YES];
	}
}

- (IBAction)addAnnotation1 {
	// Create an annotation
	MyAnnotation *newAnnotation = [[MyAnnotation alloc] init];
	CLLocationCoordinate2D coord;
	coord.latitude = SpiritCafeLatitude;
	coord.longitude = SpiritCafeLongitude;	
	[newAnnotation setCoordinate:coord];
	[newAnnotation setTitle:@"CocoaHeads Paris"];
	[newAnnotation setSubtitle:@"Session 6"]; 
	// Add this annotation to the map
	[mMapView addAnnotation:newAnnotation];
	[newAnnotation release];
}

- (void)dealloc {
	[mMapView release];
	[mActivityIndicator release];
	[mAddressTextField release];
    [window release];
    [super dealloc];
}

#pragma mark -
#pragma mark MKMapViewDelegate Map Change

// Tell that the region displayed by the map view is about to change.
- (void)mapView:(MKMapView *)mapView
regionWillChangeAnimated:(BOOL)animated {
	//NSLog(@"MapViewController - mapView:regionWillChangeAnimated:");
	[mActivityIndicator startAnimating];
}

// Tell that the region displayed by the map view just changed.
- (void)mapView:(MKMapView *)mapView
regionDidChangeAnimated:(BOOL)animated {
	NSLog(@"MapViewController - mapView:regionDidChangeAnimated:");
	NSLog(@"%f, %f",[mMapView region].span.latitudeDelta,[mMapView region].span.longitudeDelta);
	[mActivityIndicator stopAnimating];
}

// Tells the delegate that the specified map view is about to retrieve some map data.
- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView {
	NSLog(@"MapViewController - mapView:mapViewWillStartLoadingMap:");
	[mActivityIndicator startAnimating];
	
}

// Tell that the specified map view successfully loaded the needed map data.
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
	//NSLog(@"MapViewController - mapViewDidFinishLoadingMap:");
	[mActivityIndicator stopAnimating];
}

// Tell that the specified view was unable to load the map data. 
- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView
					   withError:(NSError *)error {
	//NSLog(@"MapViewController - mapViewDidFailLoadingMap:withError:");
	[mActivityIndicator stopAnimating];
}


// Tell that one or more annotation views were added to the map.
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
	//NSLog(@"MapViewController - mapView:didAddAnnotationViews:");
	
}


#pragma mark -
#pragma mark MKMapViewDelegate Annotation

// Returns the view associated with the specified annotation object.
- (MKAnnotationView *)mapView:(MKMapView *)mapView
			viewForAnnotation:(id<MKAnnotation>)annotation {

	if ([annotation isKindOfClass:[MyAnnotation class]]) {
	
		NSString *identifier = @"CocoaHeadsIdentifier";
		MKPinAnnotationView *myCocoaHeadsView = (MKPinAnnotationView *)
		[mMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
		
		if (myCocoaHeadsView == nil) {
			NSLog(@"Create A New Annotation View for CocoaHeads");
			myCocoaHeadsView = [[[MKPinAnnotationView alloc]
								 initWithAnnotation:annotation
								 reuseIdentifier:identifier] autorelease];
			// Set the pin color
			[myCocoaHeadsView setPinColor:MKPinAnnotationColorPurple];
			// Enable animation drop
			[myCocoaHeadsView setAnimatesDrop:YES];
			// Enable the callout
			[myCocoaHeadsView setCanShowCallout:YES];
			// Set the Left Callout Accessory View
			UIImageView *imageView = [[[UIImageView alloc]
									   initWithImage:[UIImage imageNamed:@"logo_croissant_pinpoint.png"]]
									  autorelease];
			[myCocoaHeadsView setLeftCalloutAccessoryView:imageView];
			// Set the Right Callout Accessory View
			UIButton * button;
			button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
			[button setTag:123];
			[myCocoaHeadsView setRightCalloutAccessoryView:button];
		}
		
		return myCocoaHeadsView;
	}

	// If it is user location 
	if ([annotation isKindOfClass:[MKUserLocation class]]) {
		NSLog(@"This is me");
		
		MKAnnotationView *newAnnotationView = nil;
		NSString *identifier = @"UserLocationIdentifier";
		newAnnotationView = (MKAnnotationView *)[mMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
		if (newAnnotationView == nil) {
			// Create the annotation view
			newAnnotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
			[newAnnotationView setImage:[UIImage imageNamed:@"lutinDeClaire.png"]];
			[newAnnotationView setCenterOffset:CGPointMake(0,-98)];
			[newAnnotationView setCanShowCallout:YES];
		}		
		return newAnnotationView;
	}
	return nil;
}

// Tell that the user tapped one of the annotation view’s accessory buttons.
- (void)mapView:(MKMapView *)mapView
					annotationView:(MKAnnotationView *)view
					calloutAccessoryControlTapped:(UIControl *)control {

	 if ([((UIButton *)control) tag] == 123) {
		 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.spiritcafe.fr"]];
	 }
}

#pragma mark -
#pragma mark Geocoder
- (IBAction)lookupAddress {
	NSLog(@"MapViewController - lookupAddress");
	
	// Getting the coordinate of the user location
	CLLocationCoordinate2D userCoordinate =
				[[mMapView userLocation] coordinate];
	// Initialize the geocoder with the coordinate of the user
	MKReverseGeocoder *reverseGeocoder =
				[[MKReverseGeocoder alloc] initWithCoordinate:userCoordinate];
	// Set the delegate
	[reverseGeocoder setDelegate:self];
	// Start the query
	[reverseGeocoder start];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
	NSLog(@"MapViewController - reverseGeocoder:didFindPlacemark:");
	
	NSLog(@"[placemark addressDictionary] : %@",[placemark addressDictionary]);
	NSLog(@"[placemark thoroughfare] : %@",[placemark thoroughfare]);
	NSLog(@"[placemark subThoroughfare] : %@",[placemark subThoroughfare]);
	NSLog(@"[placemark locality] : %@",[placemark locality]);
	NSLog(@"[placemark subLocality] : %@",[placemark subLocality]);
	NSLog(@"[placemark administrativeArea] : %@",[placemark administrativeArea]);
	NSLog(@"[placemark subAdministrativeArea] : %@",[placemark subAdministrativeArea]);
	NSLog(@"[placemark postalCode] : %@",[placemark postalCode]);
	NSLog(@"[placemark country] : %@",[placemark country]);
	NSLog(@"[placemark countryCode] : %@",[placemark countryCode]);
	
	[geocoder release];

	// Set the title and subtitle of the user location callout view
	NSString *addressTitle = [NSString stringWithFormat:@"%@ %@",[placemark subThoroughfare],[placemark thoroughfare]];
	NSString *addressSubtitle = [NSString stringWithFormat:@"%@, %@",[placemark locality],[placemark administrativeArea]];
	[[mMapView userLocation] setTitle:addressTitle];
	[[mMapView userLocation] setSubtitle:addressSubtitle];
	
	MKCoordinateRegion region;
	region.center = [placemark coordinate];
	MKCoordinateSpan span;
	span.latitudeDelta = 0.001770;
	span.longitudeDelta = 0.001717;
	region.span = span;
	[mMapView setRegion:region animated:YES];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
	NSLog(@"MapViewController - reverseGeocoder:didFailWithError:");
	
	[geocoder release];
}

#pragma mark -
#pragma mark Last thing

// Get location from an address
-(CLLocationCoordinate2D)locationFromAddress:(NSString*)address {
    NSString *urlString =
	[NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv",
	 [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];	
	
    NSString *locationString = [NSString stringWithContentsOfURL:
								[NSURL URLWithString:urlString]
									encoding:NSUTF8StringEncoding error:nil];
	
	NSArray *listColumns = [locationString componentsSeparatedByString:@","];
	
    double latitude = 0.0;
    double longitude = 0.0;
	
    if([[listColumns objectAtIndex:0] isEqualToString:@"200"]) {
        latitude = [[listColumns objectAtIndex:2] doubleValue];
        longitude = [[listColumns objectAtIndex:3] doubleValue];
    }
    else {
        //Show error
    }

    CLLocationCoordinate2D location;
    location.latitude = latitude;
    location.longitude = longitude;	
    return location;
}

- (IBAction)editingEnded:(id)sender{
    [sender resignFirstResponder];
	
	if ([mAddressTextField text]) {
		NSLog(@"lookupAddress %@",[mAddressTextField text]);
		
		CLLocationCoordinate2D newLocation;
		newLocation = [self locationFromAddress:[mAddressTextField text]];
		
		NSLog(@"latitude = %f, longitude = %f",newLocation.latitude,newLocation.longitude);
				
		MyAnnotation *newAnnotation = [[MyAnnotation alloc] init];
		[newAnnotation setTitle:@"Adresse"];
		[newAnnotation setSubtitle:[mAddressTextField text]]; 
		[newAnnotation setCoordinate:newLocation];
		[mMapView addAnnotation:newAnnotation];
		[newAnnotation release];
		
		MKCoordinateRegion region;
		region.center = newLocation;
		MKCoordinateSpan span;
		span.latitudeDelta = 0.001770;
		span.longitudeDelta = 0.001717;
		region.span = span;
		[mMapView setRegion:region animated:YES];
	}
}



@end
