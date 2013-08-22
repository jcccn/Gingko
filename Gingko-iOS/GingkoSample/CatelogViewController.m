//
//  CatelogViewController.m
//  Gingko
//
//  Created by Jiang Chuncheng on 8/22/13.
//  Copyright (c) 2013 senseforce. All rights reserved.
//

#import "CatelogViewController.h"

@interface CatelogViewController () <RETableViewManagerDelegate>

@property (nonatomic, strong) RETableViewManager *tableViewManager;

@end

@implementation CatelogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.title = @"GINGKO";
    
    __typeof (&*self) __weak weakSelf = self;
    
    self.tableViewManager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    self.tableViewManager.delegate = self;
    
    RETableViewSection *section = [RETableViewSection section];
    [self.tableViewManager addSection:section];
    
    [section addItem:[RETableViewItem itemWithTitle:@"RestKit" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
    }]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
