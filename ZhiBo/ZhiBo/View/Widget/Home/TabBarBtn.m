//
//  TabBarBtn.m
//  ZhiBo
//
//  Created by tenny on 16/2/18.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "TabBarBtn.h"

@implementation TabBarBtn


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    // Center image
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width/2;
    center.y = self.imageView.frame.size.height/2 + 7;
    self.imageView.center = center;
    
    //Center text
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = self.imageView.frame.size.height + 12;
    newFrame.size.width = self.frame.size.width;
    
    self.titleLabel.frame = newFrame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}
@end
