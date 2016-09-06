//
//  DetailsViewController.m
//  LocalpointTester_iOS
//
//  Created on 2/21/13.
//  Copyright (c) 2013 Jason Schmitt. All rights reserved.
//

#import "AppInfoViewController.h"
#import <PWMessaging/PWMSGGeozone.h>

#import "PWMessaging+Helper.h"

static NSString *const MaxMonitorRegionRadius = @"50,000";


@interface AppInfoViewController ()

@end

@implementation AppInfoViewController

#pragma mark - UIViewController

-(void)awakeFromNib{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:PWLMAddGeoZonesNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:PWLMModifyGeoZonesNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:PWLMDeleteGeoZonesNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:PWLMEnterGeoZoneNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:PWLMExitGeoZoneNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:PWLMReceiveMessageNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:PWLMDeleteGeoZonesNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:PWLMMonitoredGeoZoneChangesNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:PWLMLocationServiceReadyNotificationKey object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self updateUI:nil];
}

#pragma mark - Internal

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateUI:nil];
    });
}

- (void)updateUI:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.appId.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"MaaSAppId"];
        self.server.text = @"PROD";
        self.sdkVersion.text = [PWMessaging version];
        self.deviceID.text = [PWMessaging deviceId];
        self.deviceOS.text = [[UIDevice currentDevice] systemVersion];
        self.searchRadius.text = MaxMonitorRegionRadius;
        self.numberOfMessages.text = [NSString stringWithFormat:@"%lu", (long)[[PWMessaging messages] count]];
        
        NSArray *locations = [PWMessaging geozones];
        NSArray *monitoredZones = [PWMessaging monitoredGeozones];
        NSArray *insideZones = [PWMessaging insideGeozones];
        
        self.numberOfZones.text = [NSString stringWithFormat:@"%lu", (unsigned long)[locations count]];
        self.numberOfMonitoredZones.text = [NSString stringWithFormat:@"%lu", (unsigned long)[monitoredZones count]];
        self.numberOfInsideZones.text = [NSString stringWithFormat:@"%lu", (long)[insideZones count]];
    });
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWLMAddGeoZonesNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWLMModifyGeoZonesNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWLMDeleteGeoZonesNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWLMEnterGeoZoneNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWLMExitGeoZoneNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWLMReceiveMessageNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWLMDeleteMessageNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWLMMonitoredGeoZoneChangesNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWLMLocationServiceReadyNotificationKey object:nil];
}


@end
