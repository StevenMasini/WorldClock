//
//  TimezonesViewController.m
//  JediClock
//
//  Created by Steven Masini on 8/5/15.
//  Copyright (c) 2015 Steven Masini. All rights reserved.
//

#import "TimezonesViewController.h"
#import "TimezoneManager.h"
#import "Timezone.h"

@interface TimezonesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
// views
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// property
@property (nonatomic, strong) NSFetchedResultsController *timezones;
@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, strong) NSArray *filteredTimezones;
@end

@implementation TimezonesViewController

static NSString *cellIdentifier = @"TimezoneCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"alphabeticIndex != nil"];
    self.timezones = [Timezone MR_fetchAllGroupedBy:@"alphabeticIndex" withPredicate:predicate sortedBy:@"city" ascending:YES];
    
    self.tableView.sectionIndexColor = [UIColor colorWithRed:253.f/255.f
                                                       green:61.f/255.f
                                                        blue:57.f/255.f
                                                       alpha:1.0f];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchText.length) {
        return 1;
    }
    return self.timezones.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchText.length) {
        return self.filteredTimezones.count;
    }
    id<NSFetchedResultsSectionInfo>sectionInfo = self.timezones.sections[section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    Timezone *timezone;
    if (self.searchText.length) {
        timezone = self.filteredTimezones[indexPath.row];
    } else {
        timezone = [self.timezones objectAtIndexPath:indexPath];
    }
    
    cell.textLabel.text = [timezone formattedName];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Timezone *timezone;
    if (self.searchText.length) {
        timezone = self.filteredTimezones[indexPath.row];
    } else {
        timezone = [self.timezones objectAtIndexPath:indexPath];
    }
    NSLog(@"NAME: %@", timezone.city);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"order > -1"];
    timezone.order = @([Timezone MR_countOfEntitiesWithPredicate:predicate] + 1);
    NSLog(@"ORDER: %@", timezone.order);
    
    [timezone.managedObjectContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.searchText.length) {
        return @"";
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    Timezone *timezone = [self.timezones objectAtIndexPath:indexPath];
    
    return timezone.alphabeticIndex;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.searchText.length) {
        return 0.0f;
    }
    return tableView.sectionHeaderHeight;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.searchText.length) {
        return @[];
    }
    return  @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchText = searchText;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"city CONTAINS %@ || country CONTAINS %@ || continent CONTAINS %@", searchText, searchText, searchText];
    self.filteredTimezones = [Timezone MR_findAllWithPredicate:predicate];
    [self.tableView reloadData];
}

#pragma mark - IBActions

- (IBAction)cancelAction:(id)sender {
    [self.searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
