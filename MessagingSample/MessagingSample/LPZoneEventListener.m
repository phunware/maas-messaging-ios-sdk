//
//  LPZoneEventListener.m
//  PWMessaging
//
//  Created on 4/20/15.
//  Copyright (c) 2016 Phunware Inc. All rights reserved.
//

#import <PWMessaging/PWMessaging.h>

#import "LPZoneEventListener.h"
#import "PubUtils.h"
#import "AppSettingsDataSource.h"

@implementation LPZoneEventListener

#pragma mark - Public methods

- (void)startListening {
    // Register for event notification of entering zone
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterZoneNotification:) name:PWLMEnterGeoZoneNotificationKey object:nil];
    
    // Register for event notification of exiting zone
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didExitZoneNotification:) name:PWLMExitGeoZoneNotificationKey object:nil];
    
    // Register for event notification of adding new zones
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddZonesNotification:) name:PWLMAddGeoZonesNotificationKey object:nil];
    
    // Register for event notification of removing zones
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDeleteZonesNotification:) name:PWLMDeleteMessageNotificationKey object:nil];
    
    // Register for event notification of updating zones
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didModifyZonesNotification:) name:PWLMModifyMessageNotificationKey object:nil];
}

- (void)stopListening {
    // Unegister for event notification of entering zone
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWLMEnterGeoZoneNotificationKey object:nil];
    
    // Unegister for event notification of exiting zone
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWLMExitGeoZoneNotificationKey object:nil];
    
    // Unegister for event notification of adding new zone
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWLMAddGeoZonesNotificationKey object:nil];
    
    // Unegister for event notification of deleting zone
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWLMDeleteMessageNotificationKey object:nil];
    
    // Unegister for event notification of updating zone
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWLMModifyMessageNotificationKey object:nil];
}

#pragma mark - Private methods

/**
 The selector to handle notification when entering a zone
 @param notification A object of `NSNotification`
 */
- (void)didEnterZoneNotification:(NSNotification*)notification {
    id<PWMSGZone> zone = [self getZoneFromNotification:notification];
    if (zone) {
        // You shoud customize the code here to do what you need to do.
        // [[LPBeaconManager sharedManager] startMonitorBeaconsInGeofence:[zone identifier]];
        
        // SJS This is where the beacon bundle magic happens
        // 1. Load the bundle if neccessary
        // 2. Start it up
        
        
        NSNumber * value = (NSNumber*) [[AppSettingsDataSource sharedInstance] getValueForSettingWithKey:SAZoneNotificationsListenerShowRegionAlerts];
        BOOL showAlert = value?value.boolValue:NO;
        if (showAlert)
        {
            [PubUtils displayTitle:@"Entered Zone" content:[NSString stringWithFormat:@"[%@]%@", [zone identifier], [zone name]]];
        }
    }
}

/**
 The selector to handle notification when exiting a zone
 @param notification A object of `NSNotification`
 */
- (void)didExitZoneNotification:(NSNotification*)notification {
    id<PWMSGZone> zone = [self getZoneFromNotification:notification];
    if (zone) {
        // You shoud customize the code here to do what you need to do.
        // [[LPBeaconManager sharedManager] stopMonitorBeaconsInGeofence:[zone identifier]];
        
        // SJS This is where the beacon bundle magic happens
        // 1. stop the bundle
        
        NSNumber * value = (NSNumber*) [[AppSettingsDataSource sharedInstance] getValueForSettingWithKey:SAZoneNotificationsListenerShowRegionAlerts];
        BOOL showAlert = value?value.boolValue:NO;
        if (showAlert)
        {
            [PubUtils displayTitle:@"Exited Zone" content:[NSString stringWithFormat:@"[%@]%@", [zone identifier], [zone name]]];
        }
    }
}


/**
 The selector to handle notification when new zones are added due to your location has changed
 @param notification A object of `NSNotification`
 */
- (void)didAddZonesNotification:(NSNotification*)notification {
    NSArray *identifierArray =  notification.userInfo[PWLMGeoZoneIdentifierArrayKey];
    if (identifierArray.count > 0) {
        // You shoud customize the code here to do what you need to do.
        
        NSNumber * value = (NSNumber*) [[AppSettingsDataSource sharedInstance] getValueForSettingWithKey:SAZoneNotificationsListenerShowZoneAddRemoveUpdateAlerts];
        BOOL showAlert = value?value.boolValue:NO;
        if (showAlert)
        {
            [PubUtils displayTitle:[NSString stringWithFormat:@"%ld Zones added", (long)identifierArray.count] content:nil];
        }
    }
}

/**
 The selector to handle notification when zones are removed due to your location has significant changed or the zone are not available any more
 @param notification A object of `NSNotification`
 */
- (void)didDeleteZonesNotification:(NSNotification*)notification {
    NSArray *identifierArray =  notification.userInfo[PWLMGeoZoneIdentifierArrayKey];
    if (identifierArray.count > 0) {
        // You shoud customize the code here to do what you need to do.
        
        NSNumber * value = (NSNumber*) [[AppSettingsDataSource sharedInstance] getValueForSettingWithKey:SAZoneNotificationsListenerShowZoneAddRemoveUpdateAlerts];
        BOOL showAlert = value?value.boolValue:NO;
        if (showAlert)
        {
            [PubUtils displayTitle:[NSString stringWithFormat:@"%lul Zones removed", (unsigned long)identifierArray.count] content:nil];
        }
    }
}

/**
 The selector to handle notification when it's failed to check in
 @param notification A object of `NSNotification`
 */
- (void)didModifyZonesNotification:(NSNotification*)notification {
    NSArray *identifierArray =  notification.userInfo[PWLMGeoZoneIdentifierArrayKey];
    if (identifierArray.count > 0) {
        // You shoud customize the code here to do what you need to do.
        
        NSNumber * value = (NSNumber*) [[AppSettingsDataSource sharedInstance] getValueForSettingWithKey:SAZoneNotificationsListenerShowZoneAddRemoveUpdateAlerts];
        BOOL showAlert = value?value.boolValue:NO;
        if (showAlert)
        {
            //[PubUtils displayTitle:[NSString stringWithFormat:@"%lul Zones modified", (unsigned long)identifierArray.count] content:nil];
        }
    }
}

#pragma mark - Helper metheds

/**
 Get the specific `PWMSGZone` from notification
 @param notification A NSNotification which has the zone identifier in its userInfo.
 */
- (id<PWMSGZone>)getZoneFromNotification:(NSNotification*)notification {
    NSString *identifier =  notification.userInfo[PWLMGeoZoneIdentifierKey];
    if (identifier) {
        for (id<PWMSGZone> zone in [PWMessaging geozones]) {
            if ([zone.identifier isEqualToString:identifier]) {
                return zone;
            }
        }
    }
    return nil;
}

/**
 Get a list of `PWLPZone` from notification
 @param notification A NSNotification which has a list of zone identifier in its userInfo.
 */
- (NSArray*)getZoneListFromNotification:(NSNotification*)notification {
    NSArray *identifierArray =  notification.userInfo[PWLMGeoZoneIdentifierArrayKey];
    NSMutableArray *zoneArray = [NSMutableArray array];
    
    for (id<PWMSGZone> zone in [PWMessaging geozones]) {
        if ([identifierArray containsObject:zone.identifier]) {
            [zoneArray addObject:zone];
        }
    }
    
    return [zoneArray copy];
}

- (void)dealloc {
    [self stopListening];
}



@end
