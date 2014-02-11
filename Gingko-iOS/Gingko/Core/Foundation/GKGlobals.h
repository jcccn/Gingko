//
//  GKGlobals.h
//  Gingko
//
//  Created by Jiang Chuncheng on 12/10/13.
//  Copyright (c) 2013 SenseForce. All rights reserved.
//

/**
 *  全局使用的一些类型定义
 */

#ifndef Gingko_GKGlobals_h
#define Gingko_GKGlobals_h

#define WeakSelfType __weak __typeof(&*self)

#define WeakSelf WeakSelfType weakSelf = self;

#pragma mark - Blocks typedef

typedef void (^ResultOkCallback)(id data, NSString *msg);
typedef void (^ResultErrorCallback)(id data, NSInteger errorCode, NSString *errorMsg);


#endif
