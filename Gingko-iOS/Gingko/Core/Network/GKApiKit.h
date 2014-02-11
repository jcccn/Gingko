//
//  GKApiKit.h
//  Gingko
//
//  Created by Jiang Chuncheng on 2/11/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

/**
 *  API访问器
 */

#import "GKGlobals.h"
#import "GKMacros.h"

#import <RestKit/RestKit.h>

#import "GKMOBase.h"
#import "GKImageUtils.h"

@protocol GKApiKitHelper <NSObject>

@required
/**
 *  返回数据的最外层的通用根映射。
 *
 *  @param dataMapping 内层可变的映射表
 *
 *  @return 根映射表
 */
- (RKObjectMapping *)rootMappingWithDataMapping:(RKMapping *)dataMapping;

- (Class)rootMappingObjectClass;

- (NSDictionary *)processParameters:(NSDictionary *)parameters;

- (void)dispatcGKootResult:(id)result ok:(ResultOkCallback)ok error:(ResultErrorCallback)error;

@end

@interface GKApiKit : NSObject

#pragma mark - RestKit 设置

/**
 *  设置Rest请求的基地址
 *
 *  @param baseUrl 基地址
 */
+ (void)setBaseUrl:(NSString *)baseUrl;

/**
 *  设置Rest请求的默认http头
 *
 *  @param header http头的字段
 *  @param value  http头的值
 */
+ (void)setHttpHeader:(NSString *)header value:(NSString *)value;

/**
 *  设置ApiKit助手，用于外插提供基本能力
 *
 *  @param apiKitHelper 助手对象
 */
+ (void)setHelper:(id<GKApiKitHelper>)apiKitHelper;

#pragma mark - RestKit 请求

/**
 *	通过GET获取数据
 *
 *	@param	path	REST的PATH
 *	@param	dataMapping	数据映射表
 *	@param	parameters	参数字典。【注意】不包含client、sid、sign这三个基本参数
 *	@param	ok	接口调用成功的回调Block
 *	@param	error	接口调用错误的回调Block
 */
+ (void)getObjectsAtPath:(NSString *)path
             dataMapping:(RKMapping *)dataMapping
              parameters:(NSDictionary *)parameters
                      ok:(ResultOkCallback)ok
                   error:(ResultErrorCallback)error;

/**
 *	通过POST获取数据
 *
 *	@param	path	REST的PATH
 *	@param	dataMapping	数据映射表
 *	@param	parameters	参数字典。【注意】不包含client、sid、sign这三个基本参数
 *  @param	postedObject    需要POST的对象
 *	@param	ok	接口调用成功的回调Block
 *	@param	error	接口调用错误的回调Block
 */
+ (void)postObjectsAtPath:(NSString *)path
              dataMapping:(RKMapping *)dataMapping
               parameters:(NSDictionary *)parameters
                   object:(id)postedObject
                       ok:(ResultOkCallback)ok
                    error:(ResultErrorCallback)error;

/**
 *	上传图片
 *
 *	@param	image	图片对象
 *	@param	fileParamName	图片表单名字
 *  @param	path	REST的PATH
 *	@param	dataMapping	数据映射表
 *	@param	parameters	参数字典。【注意】不包含client、sid、sign这三个基本参数
 *  @param	postedObject    需要POST的对象
 *	@param	ok	接口调用成功的回调Block
 *	@param	error	接口调用错误的回调Block
 */
+ (void)uploadImage:(UIImage *)image
      fileParamName:(NSString *)fileParamName
               path:(NSString *)path
            mapping:(RKObjectMapping *)dataMapping
         parameters:(NSDictionary *)parameters
                 ok:(ResultOkCallback)ok
              error:(ResultErrorCallback)error;
/**
 *	上传图片
 *
 *	@param	image	图片对象
 *	@param	quality	图片质量
 *	@param	fileParamName	图片表单名字
 *  @param	path	REST的PATH
 *	@param	dataMapping	数据映射表
 *	@param	parameters	参数字典。【注意】不包含client、sid、sign这三个基本参数
 *  @param	postedObject    需要POST的对象
 *	@param	ok	接口调用成功的回调Block
 *	@param	error	接口调用错误的回调Block
 */
+ (void)uploadImage:(UIImage *)image
       imageQuality:(GKImageQuality)quality
      fileParamName:(NSString *)fileParamName
               path:(NSString *)path
            mapping:(RKObjectMapping *)dataMapping
         parameters:(NSDictionary *)parameters
                 ok:(ResultOkCallback)ok
              error:(ResultErrorCallback)error;
/**
 *	上传多个文件
 *
 *	@param	filePaths	文件路径的数组
 *	@param	fileParamNames	文件表单名字的数组
 *	@param	path	REST的PATH
 *	@param	dataMapping	数据映射表
 *	@param	parameters	参数字典。【注意】不包含client、sid、sign这三个基本参数
 *	@param	ok	接口调用成功的回调Block
 *	@param	error	接口调用错误的回调Block
 */
+ (void)uploadFiles:(NSArray *)filePaths
     fileParamNames:(NSArray *)fileParamNames
               path:(NSString *)path
            mapping:(RKObjectMapping *)dataMapping
         parameters:(NSDictionary *)parameters
                 ok:(ResultOkCallback)ok
              error:(ResultErrorCallback)error;
/**
 *	上传单个文件
 *
 *	@param	filePath	文件路径
 *	@param	fileParamName	文件表单名字
 *	@param	path	REST的PATH
 *	@param	dataMapping	数据映射表
 *	@param	parameters	参数字典。【注意】不包含client、sid、sign这三个基本参数
 *	@param	ok	接口调用成功的回调Block
 *	@param	error	接口调用错误的回调Block
 */
+ (void)uploadFile:(NSString *)filePath
     fileParamName:(NSString *)fileParamName
              path:(NSString *)path
           mapping:(RKObjectMapping *)dataMapping
        parameters:(NSDictionary *)parameters
                ok:(ResultOkCallback)ok
             error:(ResultErrorCallback)error;

@end
