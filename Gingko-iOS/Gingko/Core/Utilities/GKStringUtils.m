//
//  GKStringUtils.m
//  Gingko
//
//  Created by Jiang Chuncheng on 2/14/15.
//  Copyright (c) 2015 SenseForce. All rights reserved.
//

#import "GKStringUtils.h"

#import <CommonCrypto/CommonDigest.h>

@interface GKStringUtils ()

+ (BOOL)searchResult:(NSString *)string searchText:(NSString *)searchText;

@end

@implementation GKStringUtils

+ (BOOL)isEmpty:(NSString *)string {
    return !([string length] && [[string stringByReplacingOccurrencesOfString:@" " withString:@""] length]);
}

+ (NSString *)nonnilString:(NSString *)originString {
    if ( ! originString) {
        return @"";
    }
    return originString;
}

+ (NSString *)nonemptyString:(NSString *)firstString andString:(NSString *)secondString {
    if ([firstString length] && [[firstString stringByReplacingOccurrencesOfString:@" " withString:@""] length]) {
        return firstString;
    }
    if ([secondString length] && [[secondString stringByReplacingOccurrencesOfString:@" " withString:@""] length]) {
        return secondString;
    }
    return @"";
}

+ (BOOL)searchResult:(NSString *)string searchText:(NSString *)searchText {
	NSComparisonResult result = [string compare:searchText
                                        options:NSCaseInsensitiveSearch
                                          range:NSMakeRange(0, [searchText length])];
	if (result == NSOrderedSame) {
		return YES;
    }
	else {
		return NO;
    }
}

@end

@implementation NSString (GKStringUtils)

- (NSString *)trimAll {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSArray *)nonemptyComponentsSeparatedByString:(NSString *)separator {
    NSMutableArray *components = [NSMutableArray array];
    for (NSString *component in [self componentsSeparatedByString:separator]) {
        if ( ! [GKStringUtils isEmpty:component]) {
            [components addObject:component];
        }
    }
    return components;
}

- (NSString *)md5 {
    const char *str = [self UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *md5String = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                           r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return md5String;
}

- (NSString *)deviceToken {
    NSString *deviceToken = [self stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"< >"]];
    deviceToken = [deviceToken trimAll];
    return [GKStringUtils nonnilString:[deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""]];
}

- (NSString *)UTF8EncodedString {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)self,
                                                                                 NULL,
                                                                                 CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                 kCFStringEncodingUTF8));
}

- (NSString *)UTF8DecodedString {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                 (CFStringRef)self,
                                                                                                 CFSTR(""),
                                                                                                 kCFStringEncodingUTF8));
}

@end