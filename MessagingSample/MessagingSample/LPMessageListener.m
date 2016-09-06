//
//  LPMessageListener.m
//  PWMessaging
//
//  Created on 4/20/15.
//  Copyright (c) 2016 Phunware Inc. All rights reserved.
//

#import "PWMessaging+Helper.h"
#import "LPMessageListener.h"
#import "MessagesManager.h"
#import "AppSettingsDataSource.h"
#import "PubUtils.h"

@implementation LPMessageListener

#pragma mark - Public methods

- (void)startListening {
    // Register for event notification of adding message
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMessageNotification:) name:PWLMReceiveMessageNotificationKey object:nil];
    
    // Register for event notification of updating message
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didModifyMessageNotification:) name:PWLMModifyMessageNotificationKey object:nil];
    
    // Register for event notification of deleting message
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDeleteMessageNotification:) name:PWLMDeleteMessageNotificationKey object:nil];
    
    // Register for event notification of reading message
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReadMessageNotification:) name:PWLMReadMessageNotificationKey object:nil];
}

- (void)stopListening {
    // Unregister for event notification of adding message
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWLMReceiveMessageNotificationKey object:nil];
    
    // Unregister for event notification of updating message
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWLMModifyMessageNotificationKey object:nil];
    
    // Unregister for event notification of deleting message
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWLMDeleteMessageNotificationKey object:nil];
    
    // Unregister for event notification of reading message
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWLMReadMessageNotificationKey object:nil];
}

#pragma mark - Private methods

/**
 The selector to handle notification when a new message is added
 @param notification A object of `NSNotification`
 */
- (void)didReceiveMessageNotification:(NSNotification*)notification {
    NSString *messageId = [notification.userInfo valueForKey:PWLMMessageIdentifierKey];
    PWMSGZoneMessage *message = [PWMessaging getMessage:messageId];
    if (message) {
        [[MessagesManager sharedManager] refreshBadgeCounter];
        
        // Newly added message is fetched
        NSNumber * value = (NSNumber*) [[AppSettingsDataSource sharedInstance] getValueForSettingWithKey:SAMessageNotificationsListenerShowMessageAlerts];
        BOOL showAlert = value?value.boolValue:NO;
        if (showAlert)
        {
            [PubUtils displayTitle:@"Received Message" content:[NSString stringWithFormat:@"[%@]%@", [message identifier], [message alertTitle]]];
        }
    };
}

/**
 The selector to handle notification when a message is modified
 @param notification A object of `NSNotification`
 */
- (void)didModifyMessageNotification:(NSNotification*)notification {
    NSString *messageId = [notification.userInfo valueForKey:PWLMMessageIdentifierKey];
    PWMSGZoneMessage *message = [PWMessaging getMessage:messageId];
    if (message) {
        [[MessagesManager sharedManager] refreshBadgeCounter];
        // Modified message is fetched
        NSNumber * value = (NSNumber*) [[AppSettingsDataSource sharedInstance] getValueForSettingWithKey:SAMessageNotificationsListenerShowMessageAlerts];
        BOOL showAlert = value?value.boolValue:NO;
        if (showAlert)
        {
            [PubUtils displayTitle:@"Modified Message" content:[NSString stringWithFormat:@"[%@]%@", [message identifier], [message alertTitle]]];
        }
    }
}

/**
 The selector to handle notification when a message is removed
 @param notification A object of `NSNotification`
 */
- (void)didDeleteMessageNotification:(NSNotification*)notification {
    // Deleted message identifier
    [[MessagesManager sharedManager] refreshBadgeCounter];
    NSString *messageId = [notification.userInfo valueForKey:PWLMMessageIdentifierKey];
    
    NSNumber * value = (NSNumber*) [[AppSettingsDataSource sharedInstance] getValueForSettingWithKey:SAMessageNotificationsListenerShowMessageAlerts];
    BOOL showAlert = value?value.boolValue:NO;
    if (showAlert)
    {
        [PubUtils displayTitle:@"Removed Message" content:[NSString stringWithFormat:@"id:%@",messageId]];
    }
}

/**
 The selector to handle notification when a message is marked as read in the server
 @param notification A object of `NSNotification`
 */
- (void)didReadMessageNotification:(NSNotification*)notification {
    NSString *messageId = [notification.userInfo valueForKey:PWLMMessageIdentifierKey];
    PWMSGZoneMessage *message = [PWMessaging getMessage:messageId];
    
    if (message) {
        [[MessagesManager sharedManager] refreshBadgeCounter];
        // Message is read
        NSNumber * value = (NSNumber*) [[AppSettingsDataSource sharedInstance] getValueForSettingWithKey:SAMessageNotificationsListenerShowMessageAlerts];
        BOOL showAlert = value?value.boolValue:NO;
        if (showAlert)
        {
            [PubUtils displayTitle:@"Read Message" content:[NSString stringWithFormat:@"[%@]%@", [message identifier], [message alertTitle]]];
        }
    }
}

- (void)dealloc {
    [self stopListening];
}

@end
