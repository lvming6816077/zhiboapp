//
//  PersonTableCellData.h
//  ZhiBo
//
//  Created by tenny on 16/3/31.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonTableCellData : NSObject
@property(nonatomic,strong) NSMutableArray *picList;
@property(nonatomic,strong) NSString *postTitle;
@property(nonatomic,strong) NSMutableArray<NSString *> *tagList;
@property(nonatomic,strong) NSMutableArray<NSString *> *avatarList;
@property(nonatomic,strong) NSString *status;
@property(nonatomic,assign) NSInteger likecount;
@property(nonatomic,strong) NSString *createtime;
@end
