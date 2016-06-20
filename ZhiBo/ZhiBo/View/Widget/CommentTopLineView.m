//
//  CommentTopLineView.m
//  ZhiBo
//
//  Created by lvming on 16/6/17.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "CommentTopLineView.h"

@implementation CommentTopLineView


-(void)drawRect:(CGRect)rect {
//    CGContextRef ref = UIGraphicsGetCurrentContext();
//    CGContextSetRGBStrokeColor(ref, 0.5, 0.5, 0.5, 1.0);
//    CGContextSetLineWidth(ref, 1.0); // 让线条变粗
//    CGPoint points[] = { // 设置四个点画三条线让线连起来
//        CGPointMake(100, 100),
//        CGPointMake(50, 300),
//        CGPointMake(300, 500),
//        CGPointMake(100, 100),
//    };
//    CGContextAddLines(ref, points, sizeof(points) / sizeof(points[0]));
//    CGFloat redColor[4] = {1.0, 0, 0, 1.0};
//    CGContextSetFillColor(ref, redColor); // 填充颜色，这两句可使用[[UIColor redColor] setFill];
//    CGContextDrawPath(ref, kCGPathFillStroke); // 画填充的图案
//    self.backgroundColor = [UIColor clearColor];
//     获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    CGContextClearRect(context, rect);
//    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);//背景色
    
//    CGContextFillRect(context, rect);
    // 设置宽度
    CGContextSetLineWidth(context, 1.0);
    
    
//    CGContextSetRGBStrokeColor(context, 0.314, 0.486, 0.859, 1.0);

    ;
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:200/255.0 green:199/255.0 blue:204/255.0 alpha:1.0].CGColor);
    
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, 0, rect.size.height);
    
    CGContextAddLineToPoint(context,40, rect.size.height);
//    CGContextSetLineWidth(context, 1.0);
//    CGContextSetLineWidth(context, .8);
    CGContextAddLineToPoint(context,50, 0);
//    CGContextSetLineWidth(context, .8);
//    CGContextSetLineWidth(context, 1.0);
    CGContextAddLineToPoint(context,60, rect.size.height);
    
    CGContextAddLineToPoint(context,rect.size.width, rect.size.height);
    
//    CGContextStrokePath(context);
    CGContextDrawPath(context, kCGPathStroke); // 画填充的图案
}

@end
