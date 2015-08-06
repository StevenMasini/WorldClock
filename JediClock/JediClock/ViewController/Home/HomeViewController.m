//
//  TimezoneTableViewController.m
//  JediClock
//
//  Created by Steven Masini on 8/3/15.
//  Copyright (c) 2015 Steven Masini. All rights reserved.
//

#import "HomeViewController.h"
#import "ClockCell.h"
#import "TimezoneManager.h"

@interface HomeViewController () <UITableViewDataSource, UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation HomeViewController

static NSString *clockCellIdentifier = @"ClockCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *timezones = [[TimezoneManager sharedManager] fetchTimezones];
    for (Timezone *t in timezones) {
        NSLog(@"T: %@", t.city);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"order > -1"];
    NSLog(@"N: %@", [Timezone MR_numberOfEntitiesWithPredicate:predicate]);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClockCell *cell = [tableView dequeueReusableCellWithIdentifier:clockCellIdentifier forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - IBAction

- (IBAction)editAction:(id)sender {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}


@end
