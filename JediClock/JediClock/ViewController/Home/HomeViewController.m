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
#import "UITableView+Sugar.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>
// gesture
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;

// views
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBarButtonItem;

// property
@property (strong, nonatomic) NSMutableArray *timezones;
@end

@implementation HomeViewController

static NSString *kWorldClockCellIdentifier    = @"ClockCell";
static NSString *kNoWorldClockCellIdentifier  = @"NoWorldClockCell";

#pragma mark - UIViewController inherited methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.editBarButtonItem setPossibleTitles:[NSSet setWithObjects:@"", @"Edit", @"Done", nil]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"order > -1"];
    self.timezones = [[Timezone MR_findAllSortedBy:@"order" ascending:YES withPredicate:predicate] mutableCopy];
    self.tableView.scrollEnabled = self.timezones.count ? YES : NO;
    self.editBarButtonItem.title = self.timezones.count ? @"Edit" : @"";
    
    [self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // reset
    self.editBarButtonItem.title = self.timezones.count ? @"Edit" : @"";
    self.tableView.editing = NO;
    self.tapGestureRecognizer.enabled = YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.timezones.count;
    } else {
        return self.timezones.count > 0 ? 0 : 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return tableView.rowHeight;
    }
    return tableView.sugar_allAvailableSpace;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ClockCell *cell = [tableView dequeueReusableCellWithIdentifier:kWorldClockCellIdentifier
                                                          forIndexPath:indexPath];
        cell.showsReorderControl = YES;
        
        Timezone *timezone = self.timezones[indexPath.row];
        cell.timezone = timezone;
        
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNoWorldClockCellIdentifier
                                                                forIndexPath:indexPath];
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Timezone *timezone = self.timezones[indexPath.row];
        timezone.order = @(-1);
        [timezone.managedObjectContext MR_saveToPersistentStoreAndWait];
        
        [self.timezones removeObjectAtIndex:indexPath.row];
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        // avoid a crash if there is no more timezone to display
        if (self.timezones.count == 0) {
            NSIndexPath *noClockIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            [self.tableView insertRowsAtIndexPaths:@[noClockIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            self.editBarButtonItem.title = @"";
            self.tableView.editing = NO;
            self.tableView.scrollEnabled = NO;
        }
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

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

#pragma mark - IBAction

- (IBAction)editAction:(UIBarButtonItem *)sender {
    if (self.timezones.count > 0) {
        [self.tableView setEditing:!self.tableView.editing animated:YES];
        sender.title = self.tableView.editing ? @"Done" : @"Edit";
        self.tapGestureRecognizer.enabled = !self.tableView.editing;
    }
}

- (IBAction)tapGestureAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kSwitchClockNotification object:nil];
}

@end
