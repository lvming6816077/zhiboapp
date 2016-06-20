//
//  DateUtil.h
//  ZhiBo
//
//  Created by lvming on 16/6/15.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject
+(NSString*) dateStr:(double) timestmp format:(NSString*) format;
+(NSString*) formatShortTime:(double) timestmp;
@end
