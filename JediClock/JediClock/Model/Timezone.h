//
//  Timezone.h
//  JediClock
//
//  Created by Steven Masini on 8/5/15.
//  Copyright (c) 2015 Steven Masini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Timezone : NSManagedObject

@property (nonatomic, retain) NSString * alphabeticIndex;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * continent;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSNumber * timezone;

@end

@interface Timezone (Factory)
// factory
+ (Timezone *)timezoneWithIdentifier:(NSString *)identifier inContext:(NSManagedObjectContext *)context;

@property (weak, nonatomic, readonly) NSString          *formattedName;
@property (weak, nonatomic, readonly) NSDate            *date;
@property (assign, nonatomic, readonly) NSTimeInterval  timeInterval;
@property (assign, nonatomic, readonly) BOOL isDay;

- (NSAttributedString *)attributedStringTimelapse;

@end