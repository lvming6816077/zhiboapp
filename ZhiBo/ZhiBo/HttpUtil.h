//
//  HttpUtil.h
//  ZhiBo
//
//  Created by lvming on 16/6/12.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "PINCache.h"

// 三种缓存策略
typedef NS_ENUM(NSUInteger, CachePolicy)
{
    CachePolicyOne = 1,
    CachePolicyTwo = 2,
    CachePolicyThree = 3
};

@interface HttpUtil : NSObject

+ (instancetype)shareInstance;

-(void) post:(NSString *)url
  parameters:(id)parameters
    formBody:(void (^)(id <AFMultipartFormData> formData))block
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void) get:(NSString *)url
 parameters:(id)parameters
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject, BOOL isCache))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
    cachePolicy:(CachePolicy) policy;

-(void) get:(NSString *)url
 parameters:(id)parameters
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;





@end
