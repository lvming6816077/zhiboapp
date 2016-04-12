//
//  PersonPageData.h
//  ZhiBo
//
//  Created by tenny on 16/3/27.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonPageData : NSObject
@property(nonatomic,strong) NSString *avatarImageUrl;
@property(nonatomic,strong) NSString *bgImageUrl;
@property(nonatomic,strong) NSString *nickname;
@property(nonatomic,strong) NSString *address;
@property(nonatomic,strong) NSString *flowers;
@property(nonatomic,strong) NSString *follows;
@property(nonatomic,strong) NSString *totalZhiboCount;


-(instancetype) initWithDict:(NSDictionary *)dict;
@end
