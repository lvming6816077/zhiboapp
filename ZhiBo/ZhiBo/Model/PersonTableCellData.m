//
//  PersonTableCellData.m
//  ZhiBo
//
//  Created by tenny on 16/3/31.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "PersonTableCellData.h"

@implementation PersonTableCellData
-(instancetype) initWithDict:(NSDictionary *)dict {
    
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    
    return self;
}
@end
