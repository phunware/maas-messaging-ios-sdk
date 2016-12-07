//
//  AppDelegate.m
//  Sample
//
//  Created on 1/26/15.
//  Copyright (c) 2016 Phunware Inc. All rights reserved.
//

#import <PWMessaging/PWMessaging.h>
#import <PWCore/PWCore.h>


#import "AppDelegate.h"
#import "MessagesTableViewController.h"
#import "MessageDetailViewController.h"
#import "MessagesManager.h"
#import "LPMessageListener.h"
#import "LPZoneEventListener.h"
#import "PubUtils.h"
#import "NSObject+GcdHelper.h"
#import "MBProgressHUD.h"


@interface AppDelegate ()

@property (nonatomic, strong) LPMessageListener *messageListener;
@property (nonatomic, strong) LPZoneEventListener *zoneEventListener;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	
	NSString *appID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"MaaSAppId"];
	NSString *accessKey =[[NSBundle mainBundle] objectForInfoDictionaryKey:@"MaaSAccessKey"];
	NSString *signatureKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"MaaSSignatureKey"]	;
	
	
	[PWMessaging startWithMaasAppId:appID
							accessKey:accessKey
						 signatureKey:signatureKey
						encryptionKey:nil
						   completion:^(NSError *error) {
							   
						   }];
		
        // Start listen message events
        self.messageListener = [LPMessageListener new];
        [self.messageListener startListening];
        
        // Start listen zone events
        self.zoneEventListener = [LPZoneEventListener new];
        [self.zoneEventListener startListening];
        
        // Refresh badge on app icon and tabbar
        [[MessagesManager sharedManager] refreshBadgeCounter];
	
        // Notifies SDK the app launches
        [PWMessaging didFinishLaunchingWithOptions:launchOptions withCompletionHandler:^BOOL(PWMSGLocalNotification *notification) {
            if (notification) {
                // Deep linking
                [self pushMessageDetailViewControllerWithMessage:notification.message];
            }
            // YES - prompt when user turns off push notification setting
            return YES;
	}];
	
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Notify Localpoint the app succeed to register for remote notification
    [PWMessaging didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
	

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    // Notify Localpoint the app fail to register for remote notification
    [PWMessaging didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    // Handle the local notification
    [PWMessaging didReceiveLocalNotification:notification withNotificationHandler:^(PWMSGLocalNotification *notification) {
        if (notification) {
            // Deep linking
            [self checkToPromptNotification:notification];
        }
    }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Notify Localpoint the app receives a remote notificaiton
    [PWMessaging didReceiveRemoteNotification:userInfo withNotificationHandler:^(PWMSGLocalNotification *notification) {
        if (notification) {
            // Deep linking
            [self checkToPromptNotification:notification];
        }
    }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Notify Localpoint the app receives a remote notificaiton
	UIView *mainView = self.window.rootViewController.view;

	[[self class] runAsyncTaskInForeground:^{
		[MBProgressHUD showHUDAddedTo:mainView animated:NO];
	}];

    [PWMessaging didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler withNotificationHandler:^(PWMSGLocalNotification *notification) {
		
		[[self class] runAsyncTaskInForeground:^{
			[MBProgressHUD hideHUDForView:mainView animated:NO];
		}];
        if (notification) {
            // Deep linking
            [self checkToPromptNotification:notification];
        }
    }];
}


#pragma mark - Private
- (void)checkToPromptNotification:(PWMSGLocalNotification *)notification {
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        NSString *title = notification.alertTitle ? notification.alertTitle : notification.message.alertTitle;
        NSString *body = notification.alertBody;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                       message:body
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        if (notification.message.identifier) {
            UIAlertAction* viewAction = [UIAlertAction actionWithTitle:@"VIEW" style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {
                                                                   [self pushMessageDetailViewControllerWithMessage:notification.message];
                                                               }];
            
            
            [alert addAction:viewAction];
        }
        
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }
}

- (void)pushMessageDetailViewControllerWithMessage:(PWMSGZoneMessage*)message {
    // Try to get message detail view controller from story board
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MessageDetailViewController *messageDetailController = [storyboard instantiateViewControllerWithIdentifier:@"MessageDetailViewController"];
    // Set the message to display in the message detail view controller
    messageDetailController.message = message;
    
    // Find the message list view controller in the tabbar
    UITabBarController *tabBar = (UITabBarController *)((UIWindow*)[[UIApplication sharedApplication].windows firstObject]).rootViewController;
    NSInteger indexOfController = 0;
    for (UIViewController *controller in tabBar.viewControllers) {
        UIViewController *tabRootController = nil;
        UIViewController *tabVisibleController = nil;
        if ([controller isKindOfClass:[UINavigationController class]]) {
            tabRootController = [(UINavigationController*)controller viewControllers].firstObject;
            tabVisibleController = [(UINavigationController*)controller visibleViewController];
        } else {
            tabRootController = controller;
            tabVisibleController = controller;
        }
        
        // Check every visible view controller to find message list/detail view controller
        if ([tabRootController isKindOfClass:[MessagesTableViewController class]]) {
            if ([tabVisibleController isKindOfClass:[MessageDetailViewController class]]) {
                // It's message detail view controller, it's to reload it with the current message
                tabBar.selectedIndex = indexOfController;
                ((MessageDetailViewController*)tabVisibleController).message = message;
                [tabVisibleController viewDidLoad];
            } else {
                // It's message list view controller, it's to `push` a message detail view controller
                tabBar.selectedIndex = indexOfController;
                [(UINavigationController *)tabBar.selectedViewController pushViewController:messageDetailController animated:YES];
            }
        }
        
        indexOfController ++;
    }
}

@end
