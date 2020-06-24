//
//  NetworkTool.h
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/6/22.
//  Copyright © 2020 CZK. All rights reserved.
//

#import "AFHTTPSessionManager.h"
//之前重命名了一下 不知道编译的时候有没有影响
@interface NetWorkTool : AFHTTPSessionManager
+ (instancetype)sharedInstance;

+ (BOOL)isNetWorkReachable;

+ (void)POSTAction:(NSString *)action
         parameter:(NSDictionary *)parameter
      successBlock:(void (^)(id data))successBlock
        errorBlock:(void (^)(NSString *errorDesc))errorBlock;

+ (void)POSTAction:(NSString *)LoginAction
      formDataParameter:(NSDictionary *)parameter
      progressBlock:(void(^)(CGFloat progress))progressBlock
      successBlock:(void (^)(id data))successBlock
      errorBlock:(void (^)(NSString *errorDesc))errorBlock;

+ (void)GETAction:(NSString *)action
         setCache:(BOOL)setCache
   readCacheFirst:(BOOL) readCacheFirst
        parameter:(NSDictionary *)parameter
     successBlock:(void (^)(id data, BOOL cache))successBlock
       errorBlock:(void (^)(NSString *errorDesc))errorBlock;

+ (void)GETAction:(NSString *)action
        parameter:(NSDictionary *)parameter
     successBlock:(void (^)(id data, BOOL cache))successBlock
       errorBlock:(void (^)(NSString *errorDesc))errorBlock;

+ (void)POSTAction:(NSString *)action
         parameter:(NSDictionary *)parameter
            images:(NSArray *)images
     progressBlock:(void(^)(CGFloat progress))progressBlock
      successBlock:(void (^)(id data))successBlock
        errorBlock:(void (^)(NSString *errorDesc))errorBlock;

@end

@interface BTNetCacheTool : NSObject

+ (id)getJSONCacheWithURL:(NSString *)url  parameter:(NSDictionary *)parameter;

+ (void)setJSONCacheWithURL:(NSString *)url parameter:(NSDictionary *)parameter cacheDict:(id )data;

+ (void)deleteCache;

+ (NSString *)sizeOfCache;

+ (NSUInteger)sizeOfCacheWithoutUnit;

@end
