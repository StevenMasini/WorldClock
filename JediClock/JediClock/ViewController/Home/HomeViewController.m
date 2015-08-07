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

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *timezones;
@end

@implementation HomeViewController

static NSString *clockCellIdentifier = @"ClockCell";

#pragma mark - UIViewController inherited methods

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"order > -1"];
    self.timezones = [[Timezone MR_findAllSortedBy:@"order" ascending:YES withPredicate:predicate] mutableCopy];
    
    [self.tableView reloadData];
}

#pragma mark - HomeViewController

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.timezones.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClockCell *cell = [tableView dequeueReusableCellWithIdentifier:clockCellIdentifier forIndexPath:indexPath];
    cell.showsReorderControl = YES;
    
    Timezone *timezone = self.timezones[indexPath.row];
    cell.timezone = timezone;
    
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

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    Timezone *timezoneToMove = [self.timezones objectAtIndex:sourceIndexPath.row];
    
    [self.timezones removeObjectAtIndex:sourceIndexPath.row];
    [self.timezones insertObject:timezoneToMove atIndex:destinationIndexPath.row];
    
    timezoneToMove.order = @(destinationIndexPath.row + 1);
    [timezoneToMove.managedObjectContext MR_saveToPersistentStoreAndWait];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

#pragma mark - IBAction

- (IBAction)editAction:(id)sender {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

- (IBAction)tapGestureAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kSwitchClockNotification object:nil];
}

@end
