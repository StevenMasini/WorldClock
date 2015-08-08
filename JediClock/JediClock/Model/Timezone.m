//
//  Timezone.m
//  JediClock
//
//  Created by Steven Masini on 8/5/15.
//  Copyright (c) 2015 Steven Masini. All rights reserved.
//

#import "Timezone.h"
#import <MagicalRecord/MagicalRecord.h>

#import "NSAttributedString+Jedi.h"
#import "NSMutableAttributedString+Jedi.h"

@implementation Timezone

@dynamic city;
@dynamic continent;
@dynamic country;
@dynamic identifier;
@dynamic order;
@dynamic timezone;
@dynamic alphabeticIndex;

/**
 *  @author Steven Masini, 08-Aug-2015
 *
 *  @brief  Create the timezone entity by cleaning them up
 *
 *  @param identifier The TimeZone identifier
 *  @param context    The managed object context where to save the entities
 *
 *  @return A well-formatted core data entity
 */
+ (Timezone *)timezoneWithIdentifier:(NSString *)identifier inContext:(NSManagedObjectContext *)context {
    if (!identifier || identifier.length == 0 || !context || [identifier isEqualToString:@"GMT"]) {
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
        timezone.alphabeticIndex = [[timezone.city substringToIndex:1] uppercaseString];
    }
    
    return timezone;
}

#pragma mark - Formatted methods

- (NSString *)formattedName {
    if (!self.city) {
        return nil;
    }
    
    NSMutableString *name = [NSMutableString stringWithString:self.city];
    if (self.country) {
        [name appendFormat:@", %@", self.country];
    }
    [name appendFormat:@", %@", self.continent];
    
    return name;
}

- (NSAttributedString *)attributedStringTimelapse {
    NSCalendar *gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitDay;
    
    NSDateComponents *localDateComponents = [gregorian components:unit
                                                         fromDate:[NSDate date]
                                                           toDate:self.date
                                                          options:0];
    
    NSMutableAttributedString *as = [NSMutableAttributedString new];
    NSInteger day = localDateComponents.day;
    if (day == 0) {
        [as appendNewAttributedString:@"Today" attributes:@{ASFONT(@"HelveticaNeue-Bold", 14.0f)}];
    } else if (day > 0) {
        [as appendNewAttributedString:@"Tomorrow" attributes:@{ASFONT(@"HelveticaNeue-Bold", 14.0f)}];
    } else if (day < 0) {
        [as appendNewAttributedString:@"Yesterday" attributes:@{ASFONT(@"HelveticaNeue-Bold", 14.0f)}];
    }
    
    NSTimeZone *destinationTimeZone = [NSTimeZone timeZoneWithName:self.identifier];
    BOOL isDayLightSavingTime = destinationTimeZone.isDaylightSavingTime;
    NSLog(@"%@ - %@ \rDAYLIGHT: %@", self.city, localDateComponents, isDayLightSavingTime ? @"YES" : @"NO");
    
    NSInteger hour = localDateComponents.hour;
    if (hour > 0) {
        hour = hour + (isDayLightSavingTime ? 1 : 0);
        [as appendNewAttributedString:@", " attributes:@{ASFONT(@"HelveticaNeue-Bold", 14.0f)}];
        NSString *hourText = (hour == 1) ? @"hour" : @"hours";
        NSString *aheadText = [NSString stringWithFormat:@"%@ %@ ahead", @(hour), hourText];
        [as appendNewAttributedString:aheadText attributes:@{ASFONT(@"HelveticaNeue", 14.0f)}];
    } else if (hour < 0) {
        hour = (hour * -1) + (isDayLightSavingTime ? 1 : 0);
        [as appendNewAttributedString:@", " attributes:@{ASFONT(@"HelveticaNeue-Bold", 14.0f)}];
        NSString *hourText = (hour == -1) ? @"hour" : @"hours";
        NSString *behindText = [NSString stringWithFormat:@"%@ %@ behind", @(hour), hourText];
        [as appendNewAttributedString:behindText attributes:@{ASFONT(@"HelveticaNeue", 14.0f)}];
    }
    
    return as;
}

- (NSDate *)date {
    NSTimeInterval timeInterval = [self timeInterval];
    return [NSDate dateWithTimeInterval:timeInterval sinceDate:[NSDate date]];
}

- (NSTimeInterval)timeInterval {
    NSTimeZone *locationTimeZone = [NSTimeZone timeZoneWithName:self.identifier];
    
    NSTimeInterval locationTimeInterval = [locationTimeZone secondsFromGMT];
    NSTimeInterval localTimeInterval = [[NSTimeZone systemTimeZone] secondsFromGMT];
    
    return locationTimeInterval - localTimeInterval;
}

- (BOOL)isDay {
    NSCalendar *gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSInteger hour = [gregorian component:NSCalendarUnitHour fromDate:self.date];
    if (hour >= 18 || hour <= 6) {
        return NO;
    }
    return YES;
}

@end
