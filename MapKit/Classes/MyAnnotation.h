//
//  MyAnnotation.h
//  demoMapKit1
//
//  Created by Michel Ho Fong Fat on 10/8/09.
//  Copyright 2009 Michel Ho Fong Fat. All rights reserved.
//

#import <MapKit/MKAnnotation.h>

@interface MyAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D	coordinate;
    NSString				*title;
    NSString				*subtitle;
}

@property (nonatomic, assign)	CLLocationCoordinate2D	coordinate;
@property (nonatomic, retain)	NSString				*title;
@property (nonatomic, retain)	NSString				*subtitle;

@end
