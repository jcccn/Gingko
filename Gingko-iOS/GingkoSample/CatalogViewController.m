//
//  CatalogViewController.m
//  Gingko
//
//  Created by Jiang Chuncheng on 2/14/15.
//  Copyright (c) 2015 SenseForce. All rights reserved.
//

#import "CatalogViewController.h"

@interface CatalogViewController () <RETableViewManagerDelegate>

@property (nonatomic, strong) RETableViewManager *tableViewManager;

@end

@implementation CatalogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.title = @"GINGKO";
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:[[UIViewController alloc] init] animated:YES];
//    [self presentViewController:[[UIViewController alloc] init] animated:YES completion:NULL];
}

@end
