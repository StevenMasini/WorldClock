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
@property (nonatomic, strong) NSArray *timezones;
@end

@implementation TimezonesViewController

static NSString *cellIdentifier = @"TimezoneCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timezones = [NSTimeZone knownTimeZoneNames];
    NSArray *timezones = [[TimezoneManager sharedManager] fetchTimezones];
    for (Timezone *t in timezones) {
        NSLog(@"T: %@", t);
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.timezones.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    cell.textLabel.text = self.timezones[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
}

#pragma mark - IBActions

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
