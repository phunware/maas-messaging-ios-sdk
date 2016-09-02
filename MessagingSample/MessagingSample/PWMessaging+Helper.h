//
//  PWMessaging+Helper.h
//  PWMessaging
//
//  Created on 2/8/16.
//  Copyright © 2016 Phunware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PWMessaging/PWMessaging.h>

@interface PWMessaging(Helper)

+ (NSArray *)monitoredGeozones;

+ (NSArray *)insideGeozones;

+ (PWMSGZoneMessage *)getMessage:(NSString *)messageId;

@end
