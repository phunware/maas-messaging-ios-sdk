//
//  PWMessaging+Helper.m
//  PWMessaging
//
//  Created on 2/8/16.
//  Copyright © 2016 Phunware Inc. All rights reserved.
//

#import "PWMessaging+Helper.h"

@implementation PWMessaging(Helper)

+ (NSArray *)monitoredGeozones {
    return [[PWMessaging geozones] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"monitored == YES"]];
}

+ (NSArray *)insideGeozones {
    return [[PWMessaging geozones] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"inside == YES"]];
}

+ (PWMSGZoneMessage *)getMessage:(NSString *)messageId {
    for (PWMSGZoneMessage *message in [PWMessaging messages]) {
        if ([messageId isEqualToString:message.identifier]) {
            return message;
        }
    }
    
    return nil;
}

@end
