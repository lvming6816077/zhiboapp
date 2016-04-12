//
//  BoListViewCellData.m
//  ZhiBo
//
//  Created by tenny on 16/2/19.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "BoListViewCellData.h"

@implementation BoListViewCellData
-(instancetype) initWithDict:(NSDictionary *)dict {
    
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    
    return self;
}
@end
