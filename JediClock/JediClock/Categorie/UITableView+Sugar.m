//
//  UITableView+Sugar.m
//  JediClock
//
//  Created by Steven Masini on 8/8/15.
//  Copyright (c) 2015 Steven Masini. All rights reserved.
//

#import "UITableView+Sugar.h"

@implementation UITableView (Sugar)
- (CGFloat)sugar_allAvailableSpace {
    CGFloat availableSpace = CGRectGetHeight(self.frame) - self.contentInset.top - self.contentInset.bottom - CGRectGetHeight(self.tableHeaderView.frame) - CGRectGetHeight(self.tableFooterView.frame);
    return availableSpace;
}
@end
