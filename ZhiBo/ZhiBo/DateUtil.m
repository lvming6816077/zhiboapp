//
//  DateUtil.m
//  ZhiBo
//
//  Created by lvming on 16/6/15.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil
+(NSString*) dateStr:(double) timestmp format:(NSString*) format {
    format = format ? format : @"yyyy-MM-dd";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *dateStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timestmp]];
    
    return dateStr;
}
+(NSString*) formatShortTime:(double) timestmp {
//    timestmp =1465718910;
    
    NSString *str = @"";
    double now = [[NSDate date] timeIntervalSince1970];
    
    double offset = now - timestmp;
    
    if (offset < 60) {
        str = @"刚刚";
    } else if (offset < 62) {
        str = @"1分钟前";
    } else if (offset < 60 * 60) {
        str = [NSString stringWithFormat:@"%d分钟前",(int) offset/60];
    } else if (offset < 60 * 60 * 24) {
        str = [NSString stringWithFormat:@"%d小时前",(int) offset/60/60];
    } else {
        str = [NSString stringWithFormat:@"%d天前",(int) offset/60/60/24];
    }
//    1465718910
    return str;
}
@end
