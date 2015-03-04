//
//  GKDateUtils.m
//  Gingko
//
//  Created by Jiang Chuncheng on 2/14/15.
//  Copyright (c) 2015 SenseForce. All rights reserved.
//

#import "GKDateUtils.h"

@interface GKDateUtils ()

+ (NSDateFormatter *)dateFormaterWithFormat:(NSString *)formatString;

@end

@implementation GKDateUtils

+ (NSString *)timestamp {
    return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
}

+ (NSString *)timeStringFromDate:(NSDate *)date withFormat:(NSString *)format {
    return [[self dateFormaterWithFormat:format] stringFromDate:date];
}

+ (NSDate *)dateFromTimeString:(NSString *)string withFormat:(NSString *)format {
    return [[self dateFormaterWithFormat:format] dateFromString:string];
}

+ (NSString *)convertTimeString:(NSString *)string fromFormat:(NSString *)oldFormat toFormat:(NSString *)newFormat {
    NSDate *date = [self dateFromTimeString:string withFormat:oldFormat];
    return [[self dateFormaterWithFormat:newFormat] stringFromDate:date];
}

+ (NSString *)timeStringFromTimeStamp:(NSString *)timestamp withFormat:(NSString *)format {
    return [[self dateFormaterWithFormat:format] stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timestamp longLongValue]]];
}

+ (Constellation)constellationFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [self dateFormaterWithFormat:@"MM"];
    
    NSInteger theMonth=0;
    NSString *monthString = [dateFormatter stringFromDate:date];
    if([[monthString substringToIndex:0] isEqualToString:@"0"]){
        theMonth = [[monthString substringFromIndex:1] integerValue];
    }
    else{
        theMonth = [monthString integerValue];
    }
    
    [dateFormatter setDateFormat:@"dd"];
    int theDay=0;
    NSString *dayString = [dateFormatter stringFromDate:date];
    if([[dayString substringToIndex:0] isEqualToString:@"0"]){
        theDay = [[dayString substringFromIndex:1] integerValue];
    }
    else{
        theDay = [dayString integerValue];
    }
    /*
     摩羯座 12月22日------1月19日
     水瓶座 1月20日-------2月18日
     双鱼座 2月19日-------3月20日
     白羊座 3月21日-------4月19日
     金牛座 4月20日-------5月20日
     双子座 5月21日-------6月21日
     巨蟹座 6月22日-------7月22日
     狮子座 7月23日-------8月22日
     处女座 8月23日-------9月22日
     天秤座 9月23日------10月23日
     天蝎座 10月24日-----11月21日
     射手座 11月22日-----12月21日
     */
    Constellation constellation = ConstellationAquarius;
    switch (theMonth) {
        case 1: {
            if(theDay <= 19){
                constellation = ConstellationCapricorn;
            }
            else {
                constellation = ConstellationAquarius;
            }
        }
            break;
            
        case 2: {
            if (theDay <= 18) {
                constellation = ConstellationAquarius;
            }
            else {
                constellation = ConstellationPisces;
            }
        }
            break;
            
        case 3: {
            if (theDay <= 20) {
                constellation = ConstellationPisces;
            }
            else {
                constellation = ConstellationAries;
            }
        }
            break;
            
        case 4: {
            if (theDay <= 19) {
                constellation = ConstellationAries;
            }
            else {
                constellation = ConstellationTaurus;
            }
        }
            break;
            
        case 5: {
            if (theDay <= 20) {
                constellation = ConstellationTaurus;
            }
            else {
                constellation = ConstellationGemini;
            }
        }
            break;
            
        case 6: {
            if (theDay <= 21) {
                constellation = ConstellationGemini;
            }
            else {
                constellation = ConstellationCancer;
            }
        }
            break;
            
        case 7: {
            if (theDay <= 22) {
                constellation = ConstellationCancer;
            }
            else {
                constellation = ConstellationLeo;
            }
        }
            break;
            
        case 8: {
            if (theDay <= 22) {
                constellation = ConstellationLeo;
            }
            else {
                constellation = ConstellationVirgo;
            }
        }
            break;
            
        case 9: {
            if (theDay <= 22) {
                constellation = ConstellationVirgo;
            }
            else {
                constellation = ConstellationLibra;
            }
        }
            break;
            
        case 10: {
            if (theDay <= 23) {
                constellation = ConstellationLibra;
            }
            else {
                constellation = ConstellationScorpio;
            }
        }
            break;
            
        case 11: {
            if (theDay <= 21) {
                constellation = ConstellationScorpio;
            }
            else {
                constellation = ConstellationSagittarius;
            }
        }
            break;
            
        case 12: {
            if (theDay <= 21) {
                constellation = ConstellationSagittarius;
            }
            else {
                constellation = ConstellationCapricorn;
            }
        }
            break;
            
        default: {
            constellation = ConstellationAquarius;
        }
    }
    return constellation;
}

+ (NSString *)constellationNameFromDate:(NSDate *)date {
    static NSArray *constellationNames;
    if ( ! constellationNames) {
        constellationNames = @[ @"白羊座", @"金牛座", @"双子座", @"巨蟹座", @"狮子座", @"处女座", @"天秤座", @"天蝎座", @"射手座", @"摩羯座", @"水瓶座", @"双鱼座" ];
    }
    Constellation constellation = [self constellationFromDate:date];
    if (constellation > [constellationNames count]) {
        return @"";
    }
    else {
        return [constellationNames[constellation] copy];
    }
}

#pragma mark - private metholds

+ (NSDateFormatter *)dateFormaterWithFormat:(NSString *)formatString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    return dateFormatter;
}

@end
