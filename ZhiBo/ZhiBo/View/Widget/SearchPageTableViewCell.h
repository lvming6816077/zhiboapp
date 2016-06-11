//
//  SearchPageTableViewCell.h
//  ZhiBo
//
//  Created by lvming on 16/5/13.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchPageTableViewCellData.h"

@interface SearchPageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
-(void) setCellData:(SearchPageTableViewCellData*)data;
@end
