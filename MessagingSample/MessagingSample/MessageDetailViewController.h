//
//  MessageDetailViewController.h
//  PWMessaging
//
//  Created on 4/7/15.
//  Copyright (c) 2016 Phunware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PWMessaging/PWMessaging.h>

@interface MessageDetailViewController : UIViewController

#pragma mark - Properties

/**
 The current message
 */
@property (nonatomic) PWMSGZoneMessage *message;

/**
 The `UIWebView` is using for display message detail on it
 */
@property (nonatomic, strong) IBOutlet UIWebView *webView;

#pragma mark - Action methods

/**
 Delete a specified message
 */
- (IBAction)deleteMessage:(UIBarButtonItem *)sender;

@end
