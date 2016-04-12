//
//  BoListViewCellData.h
//  ZhiBo
//
//  Created by tenny on 16/2/19.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BoListViewCellData : NSObject



@property(nonatomic,strong) NSString *avatarImageUrl;
@property(nonatomic,strong) NSString *nickname;
@property(nonatomic,strong) NSString *address;
@property(nonatomic,strong) NSString *createtime;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *desc;
@property(nonatomic,assign) NSInteger likecount;
@property(nonatomic,strong) NSArray<NSString *> *picList;


-(instancetype) initWithDict:(NSDictionary *)dict;
@end
