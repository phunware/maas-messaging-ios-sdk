//
//  PubUtils.m
//  PWMessaging
//
//  Created on 3/31/15.
//  Copyright (c) 2016 Phunware Inc. All rights reserved.
//

#import "PubUtils.h"
#import "MBProgressHUD.h"

@implementation PubUtils {
    UIView *topMostView;
}

+ (id)getUserDefaultsFor:(NSString*)key
{
    @synchronized(self){
        return [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
}

+ (void)setUserDefaultsWithValue:(NSObject*)value for:(NSString*)key
{
    @synchronized(self){
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)toast:(NSString*)message {
    [self toast:nil detail:message];
}

+ (void)toast:(NSString*)message detail:(NSString*)detail{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[PubUtils getTopMostView] animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    hud.detailsLabel.text = detail;
    hud.detailsLabel.font = [UIFont systemFontOfSize:11];
    hud.alpha = 0.6;
    hud.opaque = NO;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hideAnimated:YES afterDelay:1];
}

+ (void)showLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *topmostView = [PubUtils getTopMostView];
        while (!topmostView) {
            topmostView = [PubUtils getTopMostView];
        }
        [MBProgressHUD showHUDAddedTo:topmostView animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // Just in case it can't be dismissed properly
            [PubUtils dismissLoading];
        });
    });
}

+ (void)dismissLoading {
    [MBProgressHUD hideHUDForView:[PubUtils getTopMostView] animated:YES];
}

+ (void)displayTitle:(NSString*)title content:(id)content {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:[content description]
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                          otherButtonTitles:nil, nil];
    [alert show];
}

+ (void)displayError:(NSError*)error {
    NSString *title = [NSString stringWithFormat:@"%@ %ld", error.domain, (long)error.code];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:[error description]
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                          otherButtonTitles:nil, nil];
    [alert show];
}

+ (void)displayWarning:(NSString*)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", @"Warning")
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                          otherButtonTitles:nil, nil];
    [alert show];
}

+ (UIView*)getTopMostView {
    UIView *topmostView = [[((UIWindow*)[[UIApplication sharedApplication].windows firstObject]) subviews] lastObject];
    return topmostView;
}



@end
