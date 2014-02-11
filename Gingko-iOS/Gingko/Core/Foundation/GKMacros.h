//
//  GKMacros.h
//  Gingko
//
//  Created by Jiang Chuncheng on 12/10/13.
//  Copyright (c) 2013 SenseForce. All rights reserved.
//

/**
 *  全局使用的宏定义相关
 */

#import <Foundation/Foundation.h>

#ifndef Gingko_GKMacros_h
#define Gingko_GKMacros_h

/***************************************/

#pragma mark - Logging

/*
 * if GK_DEBUG is not defined, or if it is 0 then
 *	all GKLogXXX macros will be disabled
 *
 * if GK_DEBUG==1 then:
 *		GKLog() will be enabled
 *		GKLogError() will be enabled
 *		GKLogInfo()	will be disabled
 *
 * if GK_DEBUG==2 or higher then:
 *		GKLog() will be enabled
 *		GKLogError() will be enabled
 *		GKLogInfo()	will be enabled
 */

#define __GKLogWithFunction(s, ...) \
NSLog(@"%s : %@",__FUNCTION__,[NSString stringWithFormat:(s), ##__VA_ARGS__])

#define __GKLog(s, ...) \
NSLog(@"[%@(%d)] %@",[[NSString stringWithUTF8String:__FILE__] lastPathComponent],__LINE__,[NSString stringWithFormat:(s), ##__VA_ARGS__])

#if !defined(GK_DEBUG) || GK_DEBUG == 0
#define GKLog(...) do {} while (0)
#define GKLogError(...) do {} while (0)
#define GKLogInfo(...) do {} while (0)

#elif GK_DEBUG == 1
#define GKLog(...) __GKLog(__VA_ARGS__)
#define GKLogError(...) __GKLogWithFunction(__VA_ARGS__)
#define GKLogInfo(...) do {} while (0)

#elif GK_DEBUG > 1
#define GKLog(...) __GKLOG(__VA_ARGS__)
#define GKLogError(...) __GKLogWithFunction(__VA_ARGS__)
#define GKLogInfo(...) __GKLog(__VA_ARGS__)
#endif

/***************************************/

#pragma mark - ARC

#if defined(__has_feature) && __has_feature(objc_arc)
// ARC (used for inline functions)
#define GK_ARC_RETAIN(value)	value
#define GK_ARC_RELEASE(value)	value = 0
#define GK_ARC_AUTORELEASE(value)	value
#define GK_ARC_UNSAFE_RETAINED	__unsafe_unretained
#define GK_ARC_DEALLOC

#else
// No ARC
#define GK_ARC_RETAIN(value)	[value retain]
#define GK_ARC_RELEASE(value)	[value release]
#define GK_ARC_AUTORELEASE(value)	[value autorelease]
#define GK_ARC_UNSAFE_RETAINED
#define GK_ARC_DEALLOC          [super dealloc]
#endif

/***************************************/

#pragma mark - Singleton

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject; \

/***************************************/

#pragma mark - CGRect

#define CGRectSetX(rect, x)             CGRectMake(x, rect.origin.y, rect.size.width, rect.size.height)
#define CGRectSetY(rect, y)             CGRectMake(rect.origin.x, y, rect.size.width, rect.size.height)
#define CGRectSetWidth(rect, width)     CGRectMake(rect.origin.x, rect.origin.y, width, rect.size.height)
#define CGRectSetHeight(rect, height)   CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, height)
#define CGRectSetSize(rect, size)       CGRectMake(rect.origin.x, rect.origin.y, size.width, size.height)
#define CGRectSetOrigin(rect, origin)   CGRectMake(origin.x, origin.y, rect.size.width, rect.size.height)

#endif
