//
//  PersonTableViewCell.h
//  ZhiBo
//
//  Created by tenny on 16/3/31.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonTableCellData.h"
@interface PersonTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *imageWraperView;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


-(void)setCellData:(PersonTableCellData *)data;
@end
