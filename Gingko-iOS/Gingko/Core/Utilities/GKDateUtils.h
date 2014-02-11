//
//  GKDateUtils.h
//  Gingko
//
//  Created by Jiang Chuncheng on 12/10/13.
//  Copyright (c) 2013 SenseForce. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, Constellation) {
    ConstellationAries = 0,         //白羊座
    ConstellationTaurus = 1,        //金牛座
    ConstellationGemini = 2,        //双子座
    ConstellationCancer = 3,        //巨蟹座
    ConstellationLeo = 4,           //狮子座
    ConstellationVirgo = 5,         //处女座
    ConstellationLibra = 6,         //天秤座
    ConstellationScorpio = 7,       //天蝎座
    ConstellationSagittarius = 8,   //人马座
    ConstellationCapricorn = 9,     //摩羯座
    ConstellationAquarius = 10,     //水瓶座
    ConstellationPisces = 11        //双鱼座
};

@interface GKDateUtils : NSObject

+ (NSString *)timestamp;

+ (NSString *)timeStringFromDate:(NSDate *)date withFormat:(NSString *)format;
+ (NSDate *)dateFromTimeString:(NSString *)string withFormat:(NSString *)format;
+ (NSString *)convertTimeString:(NSString *)string fromFormat:(NSString *)oldFormat toFormat:(NSString *)newFormat;

+ (NSString *)timeStringFromTimeStamp:(NSString *)timestamp withFormat:(NSString *)format;

/**
 *  查询某天对应的星座
 *
 *  @param date 日期
 *
 *  @return 星座序数
 */
+ (Constellation)constellationFromDate:(NSDate *)date;

/**
 *  查询某天对应的星座
 *
 *  @param date 日期
 *
 *  @return 星座名字
 */
+ (NSString *)constellationNameFromDate:(NSDate *)date;

@end
