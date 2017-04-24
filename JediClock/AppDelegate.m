//
//  AppDelegate.m
//  JediClock
//
//  Created by Steven Masini on 8/3/15.
//  Copyright (c) 2015 Steven Masini. All rights reserved.
//

#import "AppDelegate.h"
#import "TimezoneManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 1) setup core data
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"JediClock"];
    
    // 2) retrieve the timezone from the system
    [TimezoneManager setupTimezoneDatabase];
    
    return YES;
}

@end
