//
//  MessageSysTableViewCell.m
//  ZhiBo
//
//  Created by tenny on 16/4/10.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "MessageSysTableViewCell.h"
#import "UIKit+AFNetworking.h"
@implementation MessageSysTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.avatarImageView.layer setCornerRadius:2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}


-(void) setCellData:(MessageSysTableViewCellData *)data {
    
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:data.avatarImageUrl]];
    self.titleLabel.text = data.title;
    self.descLabel.text = data.desc;
    self.timeLabel.text = data.createTime;


}
@end
