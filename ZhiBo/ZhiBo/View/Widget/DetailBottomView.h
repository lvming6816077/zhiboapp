//
//  DetailBottomView.h
//  ZhiBo
//
//  Created by lvming on 16/6/19.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailBottomData.h"

@interface DetailBottomView : UIView
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
-(instancetype) initWithData:(DetailBottomData*)data andFrame:(CGRect) frame;
@end
