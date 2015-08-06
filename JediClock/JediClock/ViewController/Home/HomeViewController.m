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
@property (strong, nonatomic) NSMutableArray *timezones;
@end

@implementation HomeViewController

static NSString *clockCellIdentifier = @"ClockCell";

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"order > -1"];
    self.timezones = [[Timezone MR_findAllWithPredicate:predicate] mutableCopy];
    for (Timezone *t in self.timezones) {
        NSLog(@"T: %@", t.city);
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.timezones.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClockCell *cell = [tableView dequeueReusableCellWithIdentifier:clockCellIdentifier forIndexPath:indexPath];
    cell.timezone = self.timezones[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Timezone *timezone = self.timezones[indexPath.row];
        timezone.order = @(-1);
        [timezone.managedObjectContext MR_saveToPersistentStoreAndWait];
        [self.timezones removeObjectAtIndex:indexPath.row];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
}

#pragma mark - IBAction

- (IBAction)editAction:(id)sender {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

@end
