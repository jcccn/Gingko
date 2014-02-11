//
//  GKApiKit.m
//  Gingko
//
//  Created by Jiang Chuncheng on 2/11/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

#import "GKApiKit.h"

#import <BlocksKit/BlocksKit.h>

#import "GKFileUtils.h"
#import "GKStringUtils.h"

@interface GKApiKit () {
    
}

@property (nonatomic, copy) NSString *restBaseUrl;
@property (nonatomic, strong) RKObjectManager *objectManager;
@property (nonatomic, strong) id<GKApiKitHelper> apiKitHelper;

+ (instancetype)sharedInstance;
- (RKObjectManager *)reloadObjectManager;

/**
 *	API请求。这里会自动做参数检查。
 *
 *	@param	path	REST的PATH
 *	@param	method	请求方式
 *	@param	rootMapping	根对象映射表
 *	@param	parameters	参数字典。【注意】不包含client、sid、sign这三个基本参数
 *	@param	object	要上传的对象（如果是POST）
 *	@param	success	请求成功的回调Block
 *	@param	failure	请求失败的回调Block
 */
+ (void)requestObjectsAtPath:(NSString *)path
                      method:(RKRequestMethod)method
                 rootMapping:(RKMapping *)rootMapping
                  parameters:(NSDictionary *)parameters
                      object:(id)object
                     success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                     failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

/**
 *	API请求
 *
 *	@param	path	REST的PATH
 *	@param	method	请求方式
 *	@param	rootMapping	根对象映射表
 *	@param	parameters	参数字典。【注意】不包含client、sid、sign这三个基本参数
 *	@param	object	要上传的对象（如果是POST）
 *	@param	ok	接口调用成功的回调Block
 *	@param	error	接口调用错误的回调Block
 */
+ (void)requestObjectsAtPath:(NSString *)path
                      method:(RKRequestMethod)method
                 rootMapping:(RKMapping *)rootMapping
                  parameters:(NSDictionary *)parameters
                      object:(id)object
                          ok:(ResultOkCallback)ok
                       error:(ResultErrorCallback)error;
/**
 *	上传多个数据。这里会自动做参数检查。
 *
 *	@param	datas	数据的数组
 *	@param	names	数据名字的数组
 *	@param	fileNames	数据文件名的数组
 *	@param	mimeTypes	数据MEME类型的数组
 *	@param	path	REST的PATH
 *	@param	dataMapping	数据映射表
 *	@param	parameters	参数字典。【注意】不包含client、sid、sign这三个基本参数
 *	@param	ok	接口调用成功的回调Block
 *	@param	error	接口调用错误的回调Block
 */
+ (void)uploadFileDatas:(NSArray *)datas
                  names:(NSArray *)names
              fileNames:(NSArray *)fileNames
              mimeTypes:(NSArray *)mimeTypes
                   path:(NSString *)path
                mapping:(RKObjectMapping *)dataMapping
             parameters:(NSDictionary *)parameters
                     ok:(ResultOkCallback)ok
                  error:(ResultErrorCallback)error;
/**
 *	上传单个数据
 *
 *	@param	data	数据
 *	@param	name	数据名字
 *	@param	fileName	数据文件名
 *	@param	mimeType	数据MEME类型
 *	@param	path	REST的PATH
 *	@param	dataMapping	数据映射表
 *	@param	parameters	参数字典。【注意】不包含client、sid、sign这三个基本参数
 *	@param	ok	接口调用成功的回调Block
 *	@param	error	接口调用错误的回调Block
 */
+ (void)uploadFileData:(NSData *)data
                  name:(NSString *)name
              fileName:(NSString *)fileName
              mimeType:(NSString *)mimeType
                  path:(NSString *)path
               mapping:(RKObjectMapping *)dataMapping
            parameters:(NSDictionary *)parameters
                    ok:(ResultOkCallback)ok
                 error:(ResultErrorCallback)error;

@end

@implementation GKApiKit

+ (void)setBaseUrl:(NSString *)baseUrl {
    [GKApiKit sharedInstance].restBaseUrl = baseUrl;
    [[GKApiKit sharedInstance] reloadObjectManager];
}

+ (void)setHttpHeader:(NSString *)header value:(NSString *)value {
    NSAssert([GKApiKit sharedInstance].objectManager, @"baseUrl must be set before headers");
    [[GKApiKit sharedInstance].objectManager.HTTPClient setDefaultHeader:header value:value];
}

+ (void)setHelper:(id<GKApiKitHelper>)apiKitHelper {
    [GKApiKit sharedInstance].apiKitHelper = apiKitHelper;
}

#pragma mark - Object Requeset

+ (void)getObjectsAtPath:(NSString *)path
             dataMapping:(RKMapping *)dataMapping
              parameters:(NSDictionary *)parameters
                      ok:(ResultOkCallback)ok
                   error:(ResultErrorCallback)error {
    [self requestObjectsAtPath:path
                        method:RKRequestMethodGET
                   rootMapping:[[GKApiKit sharedInstance].apiKitHelper rootMappingWithDataMapping:dataMapping]
                    parameters:parameters
                        object:nil
                            ok:ok
                         error:error];
}

+ (void)postObjectsAtPath:(NSString *)path
              dataMapping:(RKMapping *)dataMapping
               parameters:(NSDictionary *)parameters
                   object:(id)postedObject
                       ok:(ResultOkCallback)ok
                    error:(ResultErrorCallback)error {
    [self requestObjectsAtPath:path
                        method:RKRequestMethodPOST
                   rootMapping:[[GKApiKit sharedInstance].apiKitHelper rootMappingWithDataMapping:dataMapping]
                    parameters:parameters
                        object:postedObject
                            ok:ok
                         error:error];
}

#pragma mark - File Uploading

+ (void)uploadImage:(UIImage *)image
      fileParamName:(NSString *)fileParamName
               path:(NSString *)path
            mapping:(RKObjectMapping *)dataMapping
         parameters:(NSDictionary *)parameters
                 ok:(ResultOkCallback)ok
              error:(ResultErrorCallback)error {
    [self uploadImage:image
         imageQuality:GKImageQualityAuto
        fileParamName:fileParamName
                 path:path
              mapping:dataMapping
           parameters:parameters
                   ok:ok
                error:error];
}

+ (void)uploadImage:(UIImage *)image
       imageQuality:(GKImageQuality)quality
      fileParamName:(NSString *)fileParamName
               path:(NSString *)path
            mapping:(RKObjectMapping *)dataMapping
         parameters:(NSDictionary *)parameters
                 ok:(ResultOkCallback)ok
              error:(ResultErrorCallback)error {
    long long timestamp = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *picturePath = [[GKFileUtils tmpDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.jpg", timestamp]];
    UIImage *scaledImage = [image adjustImageToQuality:quality];
    [GKFileUtils saveImage:scaledImage
                    toFile:picturePath
                  maxWidth:MAX(scaledImage.size.width, scaledImage.size.height)];     //这个有点绕
    NSString *pictureParam = [GKStringUtils nonnilString:fileParamName];
    [self uploadFile:picturePath
       fileParamName:pictureParam
                path:path
             mapping:nil
          parameters:parameters
                  ok: ^(id data, NSString *msg) {
                      if (ok) {
                          ok(data, msg);
                      }
                      [[NSFileManager defaultManager] removeItemAtPath:picturePath error:NULL];
                  }
               error:^(id data, NSInteger errorCode, NSString *errorMsg) {
                   if (error) {
                       error(data, errorCode, errorMsg);
                   }
                   [[NSFileManager defaultManager] removeItemAtPath:picturePath error:NULL];
               }];
}

+ (void)uploadFiles:(NSArray *)filePaths
     fileParamNames:(NSArray *)fileParamNames
               path:(NSString *)path
            mapping:(RKObjectMapping *)dataMapping
         parameters:(NSDictionary *)parameters
                 ok:(ResultOkCallback)ok
              error:(ResultErrorCallback)error {
    if ([filePaths count] && [filePaths bk_any:^BOOL(id obj) {
        return [[NSFileManager defaultManager] fileExistsAtPath:obj];
    }]) {
        
        __weak NSMutableArray *fileDatas = [NSMutableArray array];
        __weak NSMutableArray *mimeTypes = [NSMutableArray array];
        [filePaths bk_each:^(id sender) {
            [fileDatas addObject:[NSData dataWithContentsOfFile:sender]];
            [mimeTypes addObject:@"application/octet-stream"];
        }];
        [self uploadFileDatas:fileDatas
                        names:fileParamNames
                    fileNames:filePaths
                    mimeTypes:mimeTypes
                         path:path
                      mapping:dataMapping
                   parameters:parameters
                           ok:ok
                        error:error];
    }
    else {
        [self postObjectsAtPath:path
                    dataMapping:dataMapping
                     parameters:parameters
                         object:nil
                             ok:ok
                          error:error];
    }
}

+ (void)uploadFile:(NSString *)filePath
     fileParamName:(NSString *)fileParamName
              path:(NSString *)path
           mapping:(RKObjectMapping *)dataMapping
        parameters:(NSDictionary *)parameters
                ok:(ResultOkCallback)ok
             error:(ResultErrorCallback)error {
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [self uploadFileData:[NSData dataWithContentsOfFile:filePath]
                        name:fileParamName
                    fileName:filePath
                    mimeType:@"application/octet-stream"
                        path:path
                     mapping:dataMapping
                  parameters:parameters
                          ok:ok
                       error:error];
    }
    else {
        [self postObjectsAtPath:path
                    dataMapping:dataMapping
                     parameters:parameters
                         object:nil
                             ok:ok
                          error:error];
    }
}

#pragma mark - Object Request (Private)

+ (void)requestObjectsAtPath:(NSString *)path
                      method:(RKRequestMethod)method
                 rootMapping:(RKMapping *)rootMapping
                  parameters:(NSDictionary *)parameters
                      object:(id)object
                     success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                     failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure {
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:rootMapping method:method pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    RKObjectManager *objectManager = [[self sharedInstance] objectManager];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    NSDictionary *processedParam = [[[self sharedInstance] apiKitHelper] processParameters:parameters];
    
    if (method == RKRequestMethodPOST) {
        [objectManager postObject:object ? object : @""
                             path:path
                       parameters:processedParam
                          success:success
                          failure:failure];
    }
    else {
        [objectManager getObjectsAtPath:path
                             parameters:processedParam
                                success:success
                                failure:failure];
    }
}

+ (void)requestObjectsAtPath:(NSString *)path
                      method:(RKRequestMethod)method
                 rootMapping:(RKMapping *)rootMapping
                  parameters:(NSDictionary *)parameters
                      object:(id)object
                          ok:(ResultOkCallback)ok
                       error:(ResultErrorCallback)error {
    [self requestObjectsAtPath:path
                        method:method
                   rootMapping:rootMapping
                    parameters:parameters
                        object:object
                       success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                           id response = [mappingResult firstObject];
                           id<GKApiKitHelper> apiKitHelper = [[self sharedInstance] apiKitHelper];
                           if ( ! [response isKindOfClass:[apiKitHelper rootMappingObjectClass]]) {
                               if (error) {
                                   error(nil, -1, @"数据映射错误");
                               }
                           }
                           else {
                               [apiKitHelper dispatcGKootResult:response
                                                             ok:ok
                                                          error:error];
                           }
                       }
                       failure:^(RKObjectRequestOperation *operation, NSError *err) {
                           if (error) {
                               error(nil, -1, @"网络访问错误");
                           }
                       }];
    
}

+ (void)uploadFileDatas:(NSArray *)datas
                  names:(NSArray *)names
              fileNames:(NSArray *)fileNames
              mimeTypes:(NSArray *)mimeTypes
                   path:(NSString *)path
                mapping:(RKObjectMapping *)dataMapping
             parameters:(NSDictionary *)parameters
                     ok:(ResultOkCallback)ok
                  error:(ResultErrorCallback)error {
    
    id<GKApiKitHelper> apiKitHelper = [[self sharedInstance] apiKitHelper];
    
    RKObjectManager *objectManager = [[self sharedInstance] objectManager];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[apiKitHelper rootMappingWithDataMapping:dataMapping] method:RKRequestMethodAny pathPattern:nil keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    RKObjectMapping *attachmentMapping = [RKObjectMapping requestMapping];
    [attachmentMapping addAttributeMappingsFromArray:@[@"attachment"]];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:attachmentMapping objectClass:[GKMOAttachment class] rootKeyPath:@"" method:RKRequestMethodAny];
    [objectManager addRequestDescriptor:requestDescriptor];
    
    NSInteger countData = [datas count];
    NSInteger countNames = [names count];
    NSInteger countFileNames = [fileNames count];
    NSInteger countMimeTypes = [mimeTypes count];
    
    NSInteger countFile = MIN(MIN(MIN(countData, countNames), countFileNames), countMimeTypes);
    
    NSMutableURLRequest *request = [objectManager multipartFormRequestWithObject:@""
                                                                          method:RKRequestMethodPOST
                                                                            path:path
                                                                      parameters:[apiKitHelper processParameters:parameters]
                                                       constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                           for (NSInteger index = 0; index < countFile; index ++) {
                                                               [formData appendPartWithFileData:datas[index]
                                                                                           name:[GKStringUtils nonnilString:names[index]]
                                                                                       fileName:[fileNames[index] lastPathComponent]
                                                                                       mimeType:mimeTypes[index]];
                                                           }
                                                       }];
    [objectManager enqueueObjectRequestOperation:
     [objectManager objectRequestOperationWithRequest:request
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  id response = [mappingResult firstObject];
                                                  id<GKApiKitHelper> apiKitHelper = [[self sharedInstance] apiKitHelper];
                                                  if ( ! [response isKindOfClass:[apiKitHelper rootMappingObjectClass]]) {
                                                      if (error) {
                                                          error(nil, -1, @"数据映射错误");
                                                      }
                                                  }
                                                  else {
                                                      [apiKitHelper dispatcGKootResult:response
                                                                                    ok:ok
                                                                                 error:error];
                                                  }
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *theError) {
                                                  if (error) {
                                                      error(nil, -1, @"网络访问错误");
                                                  }
                                              }]];
}

+ (void)uploadFileData:(NSData *)data
                  name:(NSString *)name
              fileName:(NSString *)fileName
              mimeType:(NSString *)mimeType
                  path:(NSString *)path
               mapping:(RKObjectMapping *)dataMapping
            parameters:(NSDictionary *)parameters
                    ok:(ResultOkCallback)ok
                 error:(ResultErrorCallback)error {
    [self uploadFileDatas:@[data]
                    names:@[name]
                fileNames:@[fileName]
                mimeTypes:@[mimeType]
                     path:path
                  mapping:dataMapping
               parameters:parameters
                       ok:ok
                    error:error];
}

#pragma mark - 私有方法

+ (instancetype)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^ {
        return [[self alloc] init];
    })
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (RKObjectManager *)reloadObjectManager {
    RKObjectManager *objectManager;
    if ([self.restBaseUrl length]) {
        objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:self.restBaseUrl]];
        [objectManager setAcceptHeaderWithMIMEType:RKMIMETypeJSON];
        [objectManager.HTTPClient setParameterEncoding:AFJSONParameterEncoding];
        self.objectManager = objectManager;
    }
    return objectManager;
}

@end
