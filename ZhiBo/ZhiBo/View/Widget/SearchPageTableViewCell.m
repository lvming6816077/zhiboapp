//
//  SearchPageTableViewCell.m
//  ZhiBo
//
//  Created by lvming on 16/5/13.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "SearchPageTableViewCell.h"
#import "UIKit+AFNetworking.h"


@implementation SearchPageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setCellData:(SearchPageTableViewCellData *)data {
    
    [self.picImageView setImageWithURL:[NSURL URLWithString:@"http://ugc.qpic.cn/gbar_pic/tkHBSkM8s4709liaibCecouKNbhSWfTq2EpAHCvpOmuDFc3saTCXBXPQ/512"]];
    
    self.titleLabel.text = @"说到底你也只是我一场做了好久的梦提前醒来时实在难以承受眼里睁睁的有些木讷与不舍麻木到没有眼泪本想带着一腔愚勇就此一路追赶于你哪怕脱了鞋留着血也都";
    
    self.nicknameLabel.text = @"lvming";
    
    self.statusLabel.text = @"已完结";
}
@end
