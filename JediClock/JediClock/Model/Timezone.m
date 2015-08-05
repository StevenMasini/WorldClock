//
//  Timezone.m
//  JediClock
//
//  Created by Steven Masini on 8/5/15.
//  Copyright (c) 2015 Steven Masini. All rights reserved.
//

#import "Timezone.h"
#import <MagicalRecord/MagicalRecord.h>

@implementation Timezone

@dynamic city;
@dynamic continent;
@dynamic country;
@dynamic identifier;
@dynamic order;
@dynamic timezone;

+ (Timezone *)timezoneWithIdentifier:(NSString *)identifier inContext:(NSManagedObjectContext *)context {
    if (!identifier || identifier.length == 0 || !context) {
        return nil;
    }
    
    Timezone *timezone = [Timezone MR_createEntityInContext:context];
    timezone.identifier = identifier;
    timezone.order      = @(-1);
    
    // parse identifier components
    NSArray *components = [identifier componentsSeparatedByString:@"/"];
    for (NSInteger i = 0; i < components.count; i++) {
        timezone.continent = components[0];
        if (components.count == 3) {
            timezone.country    = [components[1] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
            timezone.city       = [components[2] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        } else if (components.count == 2) {
            timezone.city       = [components[1] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        }
    }
    
    return timezone;
}

@end
