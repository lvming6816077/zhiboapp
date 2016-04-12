//
//  MessageSysTableViewCellData.m
//  ZhiBo
//
//  Created by tenny on 16/4/10.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "MessageSysTableViewCellData.h"

@implementation MessageSysTableViewCellData

-(instancetype) initWithDict:(NSDictionary *)dict {
    
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    
    return self;
}

@end
