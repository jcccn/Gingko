//
//  GKConstants.m
//  Gingko
//
//  Created by Jiang Chuncheng on 2/12/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

#import "GKConstants.h"

@interface GKConstants ()

+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSString *homePath;

@end


@implementation GKConstants

+ (instancetype)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^ {
        return [[self alloc] init];
    })
}

- (id)init {
    self = [super init];
    if (self) {
        self.homePath = NSHomeDirectory();
    }
    return self;
}

+ (NSString *)homePath {
    return [GKConstants sharedInstance].homePath;
}

@end
