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
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"JediClock"];
    
    [[TimezoneManager sharedManager] setupTimezoneDatabase];
    
    return YES;
}

@end
