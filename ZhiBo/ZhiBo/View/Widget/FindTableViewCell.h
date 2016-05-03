//
//  FindTableViewCell.h
//  ZhiBo
//
//  Created by lvming on 16/5/2.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindTableViewCellData.h"
@protocol FindTableViewCellDelegate <NSObject>

- (void)didOpenImage:(UIImageView*)currentImage;

@end


@interface FindTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *textContent;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UIView *imageContentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeight;

@property(nonatomic, weak) id<FindTableViewCellDelegate> myDelegate;


-(void) setCellData:(FindTableViewCellData*)data;
-(CGFloat) heightForCell:(FindTableViewCellData*)data;
@end
