//
//  MessageSysTableViewCell.h
//  ZhiBo
//
//  Created by tenny on 16/4/10.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageSysTableViewCellData.h"
@interface MessageSysTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

-(void)setCellData:(MessageSysTableViewCellData *)data;
@end
