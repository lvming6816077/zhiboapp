//
//  MyPageTableViewCell.m
//  ZhiBo
//
//  Created by lvming on 16/4/17.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "MyPageTableViewCell.h"

@implementation MyPageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.avatarImageView.layer setCornerRadius:self.avatarImageView.frame.size.width/2];
    self.avatarImageView.clipsToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
