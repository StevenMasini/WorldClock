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

@interface TimezonesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSFetchedResultsController *timezones;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
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
    return self.timezones.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo>sectionInfo = self.timezones.sections[section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    Timezone *timezone = [self.timezones objectAtIndexPath:indexPath];
    cell.textLabel.text = [timezone formattedName];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Timezone *timezone = [self.timezones objectAtIndexPath:indexPath];
    NSLog(@"NAME: %@", timezone.city);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"order > -1"];
    timezone.order = @([Timezone MR_countOfEntitiesWithPredicate:predicate] + 1);
    NSLog(@"ORDER: %@", timezone.order);
    
    [timezone.managedObjectContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    Timezone *timezone = [self.timezones objectAtIndexPath:indexPath];
    
    return timezone.alphabeticIndex;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return  @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"SEARCH: %@", self.searchBar.text);
}

#pragma mark - IBActions

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
