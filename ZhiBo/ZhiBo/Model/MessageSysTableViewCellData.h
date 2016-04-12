//
//  MessageSysTableViewCellData.h
//  ZhiBo
//
//  Created by tenny on 16/4/10.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageSysTableViewCellData : UITableView
@property(nonatomic,strong) NSString *avatarImageUrl;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *desc;
@property(nonatomic,strong) NSString *createTime;
@end
