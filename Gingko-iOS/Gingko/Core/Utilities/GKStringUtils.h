//
//  GKStringUtils.h
//  Gingko
//
//  Created by Jiang Chuncheng on 12/10/13.
//  Copyright (c) 2013 SenseForce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKStringUtils : NSObject

+ (BOOL)isEmpty:(NSString *)string;
+ (NSString *)nonnilString:(NSString *)originString;
+ (NSString *)nonemptyString:(NSString *)firstString andString:(NSString *)secondString;

@end

@interface NSString (GKStringUtils)

- (NSString *)trimAll;
- (NSArray *)nonemptyComponentsSeparatedByString:(NSString *)separator;
- (NSString *)md5;
- (NSString *)deviceToken;
- (NSString *)pinyinLetter;
- (NSString *)UTF8EncodedString;
- (NSString *)UTF8DecodedString;

@end