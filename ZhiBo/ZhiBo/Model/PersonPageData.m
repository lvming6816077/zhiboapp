//
//  PersonPageData.m
//  ZhiBo
//
//  Created by tenny on 16/3/27.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "PersonPageData.h"

@implementation PersonPageData
-(instancetype) initWithDict:(NSDictionary *)dict {
    
    if (self = [super init]) {
        self.bgImageUrl = @"";
        [self setValuesForKeysWithDictionary:dict];
    }
    
    return self;
}

-(NSString*) bgImageUrl {
    if (_bgImageUrl && ![_bgImageUrl isEqualToString:@""]) {
    
        return _bgImageUrl;
    } else {
        return @"http://ugc.qpic.cn/gbar_pic/S1enqicZz6ULm97IF59CGxM5AicR3MQUibVPUYG8UcJibwCzQQrPQKQQaw/";
    }


}
@end
