//
//  GKTitleBar.m
//  Gingko
//
//  Created by Jiang Chuncheng on 2/14/15.
//  Copyright (c) 2015 SenseForce. All rights reserved.
//

#import "GKTitleBar.h"

#import "GKRouter.h"

@interface GKTitleBar () {
    NSString *kvoTokenTitle;
    NSString *kvoTokenBackButtonHidden;
    NSString *kvoTokenLeftButton;
    NSString *kvoTokenRightButton;
}

- (void)initSubviews;

@end

@implementation GKTitleBar

+ (instancetype)defaultTitleBar {
    return [[self alloc] initWithFrame:CGRectMake(0, 0, 320, kDefaultTitleBarHeight)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)awakeFromNib {
    [self initSubviews];
}

- (void)initSubviews {
    WeakSelf
    
    self.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, CGRectGetWidth(self.bounds) - 10 * 2, CGRectGetHeight(self.bounds) - 5 * 2)];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_titleLabel];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.backButton.frame = CGRectMake(10, 10, 40, CGRectGetHeight(self.bounds) - 5 * 2);
    self.backButton.center = CGPointMake(self.backButton.center.x + 5, CGRectGetMidY(self.bounds));
    self.backButton.contentMode = UIViewContentModeCenter;
    [self.backButton setTitle:@"后退" forState:UIControlStateNormal];
    [self addSubview:self.backButton];
    [self.backButton bk_addEventHandler:^(id sender) {
        if ([weakSelf.viewController respondsToSelector:@selector(navigateBack:)]) {
            [weakSelf.viewController performSelector:@selector(navigateBack:) withObject:weakSelf];
        }
        else {
            [GKRouter closeCurrentViewController];
        }
    }
                    forControlEvents:UIControlEventTouchUpInside];
    
    kvoTokenTitle = [self bk_addObserverForKeyPath:@"title" task:^(id sender) {
        weakSelf.titleLabel.text= weakSelf.title;
    }];
    kvoTokenBackButtonHidden = [self bk_addObserverForKeyPath:@"hidesBackButton" task:^(id sender) {
        weakSelf.backButton.hidden = weakSelf.hidesBackButton;
        [weakSelf setNeedsLayout];
    }];
    kvoTokenLeftButton = [self bk_addObserverForKeyPath:@"leftBarButton" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew task:^(id obj, NSDictionary *change) {
        UIButton *oldButton = ([change[NSKeyValueChangeOldKey] isKindOfClass:[UIView class]] ? change[NSKeyValueChangeOldKey] : nil);
        UIButton *newButton = ([change[NSKeyValueChangeNewKey] isKindOfClass:[UIView class]] ? change[NSKeyValueChangeNewKey] : nil);
        [oldButton removeFromSuperview];
        if (newButton) {
            [weakSelf addSubview:newButton];
            weakSelf.backButton.hidden = YES;
        }
        else {
            if ( ! weakSelf.hidesBackButton) {
                weakSelf.backButton.hidden = NO;
            }
        }
        [weakSelf setNeedsLayout];
    }];
    kvoTokenRightButton = [self bk_addObserverForKeyPath:@"rightBarButton" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew task:^(id obj, NSDictionary *change) {
        UIButton *oldButton = ([change[NSKeyValueChangeOldKey] isKindOfClass:[UIView class]] ? change[NSKeyValueChangeOldKey] : nil);
        UIButton *newButton = ([change[NSKeyValueChangeNewKey] isKindOfClass:[UIView class]] ? change[NSKeyValueChangeNewKey] : nil);
        [oldButton removeFromSuperview];
        if (newButton) {
            [weakSelf addSubview:newButton];
        }
        [weakSelf setNeedsLayout];
    }];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat leftButtonWidth = 0.0f;
    CGFloat rightButtonWidth = 0.0f;
    
    if (self.leftBarButton) {
        leftButtonWidth = MIN(CGRectGetWidth(self.bounds) / 2 - 10, CGRectGetWidth(self.leftBarButton.frame));
    }
    else if (self.backButton) {
        if ( ! self.backButton.hidden) {
            leftButtonWidth = MIN(CGRectGetWidth(self.bounds) / 2 - 10, CGRectGetWidth(self.backButton.frame));
        }
    }
    
    if (self.rightBarButton) {
        rightButtonWidth = MIN(CGRectGetWidth(self.bounds) / 2 - 10, CGRectGetWidth(self.rightBarButton.frame));
    }
    
    CGRect frame = self.backButton.frame;
    frame.origin.x = 10;
    frame.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(frame)) / 2;
    frame.size.width = leftButtonWidth;
    self.backButton.frame = frame;
    self.leftBarButton.frame = frame;
    
    frame = self.rightBarButton.frame;
    frame.origin.x = CGRectGetWidth(self.bounds) - 10 - rightButtonWidth;
    frame.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(frame)) / 2;
    frame.size.width = rightButtonWidth;
    self.rightBarButton.frame = frame;
    
    frame = self.titleLabel.frame;
    frame.origin.x = 10 + leftButtonWidth;
    frame.size.width = CGRectGetWidth(self.bounds) - 2 * (10 + MAX(leftButtonWidth, rightButtonWidth));
    self.titleLabel.frame = frame;
}

- (void)dealloc {
    if (kvoTokenTitle) {
        [self bk_removeObserversWithIdentifier:kvoTokenTitle];
    }
    if (kvoTokenBackButtonHidden) {
        [self bk_removeObserversWithIdentifier:kvoTokenBackButtonHidden];
    }
    if (kvoTokenLeftButton) {
        [self bk_removeObserversWithIdentifier:kvoTokenLeftButton];
    }
    if (kvoTokenRightButton) {
        [self bk_removeObserversWithIdentifier:kvoTokenRightButton];
    }
}

@end
