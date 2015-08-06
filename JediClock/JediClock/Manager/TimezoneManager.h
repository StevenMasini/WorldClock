//
//  TimezoneManager.h
//  JediClock
//
//  Created by Steven Masini on 8/5/15.
//  Copyright (c) 2015 Steven Masini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MagicalRecord/MagicalRecord.h>
#import "Timezone.h"

@interface TimezoneManager : NSObject
@property (nonatomic, strong) NSManagedObjectContext *context;

// singleton
+ (TimezoneManager *)sharedManager;

// setup
- (void)setupTimezoneDatabase;

+ (NSDateComponents *)dateComponentsFromDate:(NSDate *)date;

@end
