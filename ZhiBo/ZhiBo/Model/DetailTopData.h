//
//  DetailTopData.h
//  ZhiBo
//
//  Created by lvming on 16/6/20.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailTopData : NSObject
@property(nonatomic,assign) NSInteger pid;
@property(nonatomic,strong) NSString *avatarUrl;
@property(nonatomic,strong) NSString *nickname;
@property(nonatomic,strong) NSString *gender;
@property(nonatomic,strong) NSString *status;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSString *createtime;
@property(nonatomic,strong) NSString *tagname;
@property(nonatomic,strong) NSArray *picList;
@end
