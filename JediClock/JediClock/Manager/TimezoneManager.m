//
//  TimezoneManager.m
//  JediClock
//
//  Created by Steven Masini on 8/5/15.
//  Copyright (c) 2015 Steven Masini. All rights reserved.
//

#import "TimezoneManager.h"
#import "Timezone.h"

@implementation TimezoneManager

#pragma mark - TimezoneManager methods

+ (void)setupTimezoneDatabase {
    if ([Timezone MR_countOfEntities] > 0) {
        return;
    }
    
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    NSArray *identifiers = [NSTimeZone knownTimeZoneNames];
    for (NSString *identifier in identifiers) {
        [Timezone timezoneWithIdentifier:identifier inContext:context];
    }
    [context MR_saveToPersistentStoreAndWait];
}

@end
