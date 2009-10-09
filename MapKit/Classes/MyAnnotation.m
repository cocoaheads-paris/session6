//
//  MyAnnotation.m
//  demoMapKit1
//
//  Created by Michel Ho Fong Fat on 10/8/09.
//  Copyright 2009 Michel Ho Fong Fat. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

@synthesize coordinate, title, subtitle;

-(void)dealloc {
    [title release];
    [subtitle release];
    [super dealloc];
}
@end
