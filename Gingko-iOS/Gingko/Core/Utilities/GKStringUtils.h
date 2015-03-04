//
//  GKStringUtils.h
//  Gingko
//
//  Created by Jiang Chuncheng on 2/14/15.
//  Copyright (c) 2015 SenseForce. All rights reserved.
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
- (NSString *)UTF8EncodedString;
- (NSString *)UTF8DecodedString;

@end