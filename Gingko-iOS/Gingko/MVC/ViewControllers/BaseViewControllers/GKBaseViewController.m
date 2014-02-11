//
//  GKBaseViewController.m
//  Gingko
//
//  Created by Jiang Chuncheng on 8/25/13.
//  Copyright (c) 2013 SenseForce. All rights reserved.
//

#import "GKBaseViewController.h"

@interface GKBaseViewController () {
    NSString *kvoTokenTitle;
}

@end

@implementation GKBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [self loadParam];
    
    [self loadData];
    
    [super viewDidLoad];
    
	[self initSubviews];
}

- (void)loadParam {
    
}

- (void)loadData {
    
}

- (void)initSubviews {
    WeakSelf
    kvoTokenTitle = [self bk_addObserverForKeyPath:@"title" task:^(id sender) {
        weakSelf.titleBar.title = weakSelf.title;
    }];
}

- (void)freeData {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self freeData];
    
    if (kvoTokenTitle) {
        [self bk_removeObserversWithIdentifier:kvoTokenTitle];
    }
}

@end
