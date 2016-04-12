//
//  HomeTarBarView.h
//  ZhiBo
//
//  Created by tenny on 16/2/17.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HomeTabBarDelegate <NSObject>

- (void)didSelect:(NSInteger)pageIndex;
- (void)publishClick;


@end
@interface HomeTarBarView : UIView
@property(nonatomic, weak) id<HomeTabBarDelegate> myDelegate;

@end
