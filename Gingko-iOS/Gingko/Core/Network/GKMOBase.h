//
//  GKMOBase.h
//  Gingko
//
//  Created by Jiang Chuncheng on 2/14/15.
//  Copyright (c) 2015 SenseForce. All rights reserved.
//

/**
 *  RestKit对象映射的基类
 */

#import <Foundation/Foundation.h>
#import <RestKit/ObjectMapping.h>

@interface GKMOBase : NSObject

/**
 *  对基本属性做对象映射并返回映射表对象
 *
 *  @return 映射表对象
 */
+ (RKObjectMapping *)commonMapping;
+ (RKObjectMapping *)commonMappingWithArray:(NSArray *)arrayOfAttributeNamesOrMappings;
+ (RKObjectMapping *)commonMappingWithDictionary:(NSDictionary *)keyPathToAttributeNames;

@end

@interface GKMOAttachment : GKMOBase

@property (nonatomic, strong) NSData *attachment;

@end
