//
//  HttpUtil.m
//  ZhiBo
//
//  Created by lvming on 16/6/12.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "HttpUtil.h"
#import "Tips.h"



@implementation HttpUtil

{
    AFHTTPRequestOperationManager *_httpManager;
}

static HttpUtil* _instance = nil;


+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
    }) ;
    
    return _instance ;
}
-(instancetype) init {

    if (self == [super init]) {
        _httpManager = [AFHTTPRequestOperationManager manager];
        
        [self initConfig];
    }
    return self;
}

-(void) initConfig {
    [_httpManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringCacheData];// to do

}
-(void) post:(NSString *)url
            parameters:(id)parameters
            formBody:(void (^)(id <AFMultipartFormData> formData))block
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    
    
    
    [_httpManager POST:url
           parameters:parameters
           constructingBodyWithBlock:block
           success:success
           failure:failure];
    
    
}
-(NSString*) getCacheKey:(NSDictionary*) dic url:(NSString*)url {
    NSURLComponents *components = [NSURLComponents componentsWithString:url];
    NSDictionary *queryDictionary = dic;
    NSMutableArray *queryItems = [NSMutableArray array];
    for (NSString *key in queryDictionary) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:queryDictionary[key]]];
    }
    components.queryItems = queryItems;
    
    return [components string];
}
-(void) commonFail:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure operation:(AFHTTPRequestOperation *) operation error:(NSError*) error {
    
    [Tips showTips:nil text:@"请求失败"];
    failure( operation,  error);

}
-(void) get:(NSString *)url
  parameters:(id)parameters
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject, BOOL isCache))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure cachePolicy:(CachePolicy)policy {
    
    
    
    // 如果不使用cache
    if (policy == CachePolicyOne) {
        [_httpManager GET:url
               parameters:parameters
                  success:^(AFHTTPRequestOperation *operation, id responseObject){
                      
                    
                      success(operation, responseObject, NO);
                      
                      
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error){
                      
                      [self commonFail:failure operation:operation error:error];
                      
                  }];
    }
    else // 如果使用cache
    {
        NSString *key = [self getCacheKey:parameters url:url];
        
        
        // 先检查是否有cache
        id object = [[PINCache sharedCache] objectForKey:key];
        
        // 如果没有就直接发请求
        if (!object) {
            [_httpManager GET:url
                   parameters:parameters
                      success:^(AFHTTPRequestOperation *operation, id responseObject){
                          
                          success(operation, responseObject, NO);
                          
                          // 将数据存入缓存
                          [[PINCache sharedCache] setObject:responseObject forKey:key block:nil];
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error){
                          
                          
                          [self commonFail:failure operation:operation error:error];
                          
                          
                      }];
            
        } else {
            success(nil, object, YES);
            
            
            // 如果使用第二种策略
            if (policy == CachePolicyTwo) {
                [_httpManager GET:url
                       parameters:parameters
                          success:^(AFHTTPRequestOperation *operation, id responseObject){
                              
                              // 将数据存入缓存
                              [[PINCache sharedCache] setObject:responseObject forKey:key block:nil];
                              
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error){
                              
                              [self commonFail:failure operation:operation error:error];

                              
                              
                          }];
            }
            // 如果使用第三种策略
            else if (policy == CachePolicyThree) {
                [_httpManager GET:url
                       parameters:parameters
                          success:^(AFHTTPRequestOperation *operation, id responseObject){
                              
                              // 将数据存入缓存
                              [[PINCache sharedCache] setObject:responseObject forKey:key block:nil];
                              
                              // 同时在执行一遍回调
                              success(nil, object, NO);
                              
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error){
                              
                              

                              [self commonFail:failure operation:operation error:error];
                              
                              
                          }];
            }
        }
        
        
    }
    

    

    
}
-(void) get:(NSString *)url
 parameters:(id)parameters
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure  {

    
    [_httpManager GET:url
           parameters:parameters
              success:success
              failure:failure];
    
    
}
@end
