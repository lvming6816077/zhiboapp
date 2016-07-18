//
//  BoListViewCellTableViewCell.h
//  ZhiBo
//
//  Created by tenny on 16/2/19.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoListViewCellData.h"
@interface BoListViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *FeedsLiView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *addressImageView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *createtimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property (weak, nonatomic) IBOutlet UILabel *likecountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentcountLabel;

@property (weak, nonatomic) IBOutlet UIView *imageContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageContentHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageContentMarginTop;


-(void)setCellData:(BoListViewCellData *)data;
@end
