//
//  LPMapAnnotation.h
//  LocalpointSample
//
//  Created on 9/24/14.
//  Copyright (c) 2016 Phunware, Inc. All rights reserved.
//

#import <PWMessaging/PWMessaging.h>
#import <MapKit/MapKit.h>

@interface LPMapAnnotation : MKPointAnnotation

@property (nonatomic, strong) id<PWMSGZone> zone;

@property (nonatomic) BOOL isLastPosition;

@end
