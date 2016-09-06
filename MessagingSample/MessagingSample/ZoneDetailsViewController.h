//
//  ZoneDetailsViewController.h
//  PWMessaging
//
//  Created on 4/13/15.
//  Copyright (c) 2016 Phunware Inc. All rights reserved.
//

@import MapKit;
@import UIKit;
#import <PWMessaging/PWMessaging.h>


@interface ZoneDetailsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate>

@property (nonatomic,retain) id<PWMSGZone> zone;

@end
