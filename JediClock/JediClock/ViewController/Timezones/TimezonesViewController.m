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

#import "UIColor+Jedi.h"

@interface TimezonesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
// views
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomTableViewConstraint;

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
    
    // add notification observer for keyboard events
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShowOrHide:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShowOrHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.tableView.sectionIndexColor = [UIColor redOrangeColor];
    
}

- (void)dealloc {
    NSLog(@"♻️ Dealloc %@", NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Keyboard KVO Callback

- (void)keyboardDidShowOrHide:(NSNotification *)notification {
    //  1) retrieve information from the notification
    NSDictionary *userInfo = notification.userInfo;
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    //  2) calculate the end keyboard position
    CGFloat height = [UIScreen mainScreen].bounds.size.height - keyboardEndFrame.origin.y;
    self.bottomTableViewConstraint.constant = height;
    
    //  3) setup and commit the animation
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];
    
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
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
    __weak typeof(self) wself = self;
    [self dismissViewControllerAnimated:YES completion:^{
        [wself.searchBar resignFirstResponder];
    }];
}


@end
