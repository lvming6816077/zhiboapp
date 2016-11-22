//
//  HallTableView.m
//  ZhiBo
//
//  Created by tenny on 16/2/19.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "HallTableView.h"
#import "Defines.h"
#import "HttpUtil.h"
#import "UIKit+AFNetworking.h"
#import "MJRefresh.h"
#import "DetailViewController.h"
#import "HallViewController.h"
#import "PersonPageViewController.h"
#import "HomeViewController.h"
#import "PersonPageData.h"
#import "LoginUtil.h"
#import "DetailTopData.h"
#import "DetailBottomData.h"




@interface HallTableView ()
@property(nonatomic,strong) NSMutableDictionary *heightList;
@end


@implementation HallTableView
{
    NSInteger _start;
    NSString *cellIdentifier;
}



-(instancetype) initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.dataSource = self;
        
        self.heightList = [[NSMutableDictionary alloc] init];
        
        cellIdentifier = @"BoListViewCell";
        
        // 初始化cell
        UINib *cellNib = [UINib nibWithNibName:cellIdentifier bundle:nil];
        [self registerNib:cellNib forCellReuseIdentifier:cellIdentifier];

        
//        UINib *cellNib = [UINib nibWithNibName:@"BoListViewCell" bundle:nil];
//        [self registerNib:cellNib forCellReuseIdentifier:@"BoListViewCell"];
//        [self registerClass:[BoListViewCell class] forCellReuseIdentifier:@"BoListViewCell"];
        //self.rowHeight = UITableViewAutomaticDimension;
//        self.estimatedRowHeight = 430;
        
        // 设置分割线样式
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];

        
        self.backgroundView = nil;
        
        self.backgroundColor = UIColorFromRGB(0xefefef);

        
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

            self.dataList = nil;
            _start = 1;
            self.heightList = [[NSMutableDictionary alloc] init];
            [self fetchData:@""];
            
        }];
        self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            _start = _start + 1;
            [self fetchData:@""];
            
            
            [self.mj_footer endRefreshing];
        }];
        
        _start = 0;
        [self fetchData:@""];
        
 
    }
    
    return self;
}

-(NSString *)getParams {
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@/post/getHallList", BaseCgiUrl]];
    NSURLQueryItem *start = [NSURLQueryItem queryItemWithName:@"start" value:[NSString stringWithFormat:@"%d",MAX(_start, 1)]];
    
    NSURLQueryItem *uid = [NSURLQueryItem queryItemWithName:@"uid" value:[LoginUtil getCurrentUserId]];
    
    //    url = @"http://7jpp2v.com1.z0.glb.clouddn.com/test5.json";
    
    components.queryItems = @[start, uid];
    
    return [components string];
}

-(void) fetchData:(NSString*)url {
    
    url = [self getParams];
    
    HttpUtil *util = [HttpUtil shareInstance];

    
    [util get:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject, BOOL isCache) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSArray *array = [responseObject valueForKeyPath:@"content"];
        [self dealWithData:array];
        [self.mj_header endRefreshing];
        [self.mj_footer endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    } cachePolicy:false ? CachePolicyThree : CachePolicyOne];
    
}
-(void) dealWithData:(NSArray*) data{
    
    NSArray *arr = data;
    NSMutableArray *result = [NSMutableArray array];
    
    for(int i = 0 ; i < arr.count ; i++) {
        BoListViewCellData *ncd = [[BoListViewCellData alloc] init];
//        ncd.avatarImageUrl = @"http://q3.qlogo.cn/g?b=qq&k=eTrqpdBoJ8wbpBtCcSXxDQ&s=140&t=1455849098";
//        ncd.title = @"直播领取驾照全过程";
//        ncd.desc = @"直播领取驾照全过程直播领取驾照全过程直播领取驾照全过程";
//        ncd.likecount = 1310;
//        ncd.address = @"河南郑州";
//        ncd.nickname = @"吕小鸣";
//        ncd.createtime = @"1月1日";
//        ncd.picList = @[@"http://ugc.qpic.cn/gbar_pic/nrq5cicd8wFpuuJFTzZlR4xE4KqZjYlRtFVS4jH8qDOJ4iaNRibOpXqlQ/512",@"http://ugc.qpic.cn/gbar_pic/iaHgl1C4jmxtNJDEica7PMbZ1pXPuX440vnD8b6viaHyb6rBYIpwqbia6w/1000"];
//        NSLog(@"%@",arr[i]);
        
        
        ncd.pid = [arr[i][@"id"] integerValue];
        ncd.avatarImageUrl = arr[i][@"user_info"][@"user_pic"];
        ncd.title = arr[i][@"post_title"];
        ncd.desc = arr[i][@"post_content"];
        ncd.likecount = [arr[i][@"post_like_count"] integerValue];
        ncd.commentcount = [arr[i][@"post_comment_count"] integerValue];
        ncd.address = arr[i][@"post_address"];
        ncd.nickname = arr[i][@"user_info"][@"user_nickname"];
        ncd.createtime = arr[i][@"post_time"];
        ncd.isZan = [arr[i][@"isZan"] integerValue];
        
        NSMutableArray *pics = [NSMutableArray new];
        NSArray *detailPicList = arr[i][@"post_pic"];
        ncd.detailPicList = detailPicList;
        
        for (NSDictionary *dic in detailPicList) {
            [pics addObject:[NSString stringWithFormat:@"http://tenny.qiniudn.com/%@?imageView2/2/w/600",dic[@"key"]]];
        }
        ncd.picList = pics;
        [result addObject:ncd];
        
    }
    if (self.dataList == nil) {
        
        self.dataList = result;
    } else {
        self.dataList = (NSMutableArray*)[self.dataList arrayByAddingObjectsFromArray:result];
    }

    [self reloadData];

}
-(void) avatarClick:(UITapGestureRecognizer*) recongizer {
    
    BoListViewCellData *currentData = self.dataList[recongizer.view.tag-100];
    PersonPageViewController *personVC = [[PersonPageViewController alloc] init];

    HallViewController *vc = (HallViewController*)[self.superview nextResponder];
    personVC.hidesBottomBarWhenPushed = YES;
    NSString *bgImageUrl = @"";
    if (currentData.picList.count > 0) {
        bgImageUrl = currentData.picList[0];
    }
    PersonPageData *pdata = [[PersonPageData alloc] initWithDict:@{@"nickname":currentData.nickname,
                                                                   @"avatarImageUrl":currentData.avatarImageUrl,
                                                                   @"bgImageUrl":bgImageUrl}];
    personVC.data = pdata;
    [vc.navigationController pushViewController:personVC animated:true];
}
-(void) bindCellEvent:(BoListViewCell*)cell index:(NSInteger)index{

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarClick:)];
    
    [cell.avatarImageView setTag:100+index];
    [cell.avatarImageView addGestureRecognizer:tap];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *key = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    if ([self.heightList objectForKey:key]) {
        return [[self.heightList objectForKey:key] floatValue];
    } else {
        
        CGFloat baseHeight = 115.0f;
        
        BoListViewCellData *currentData = self.dataList[indexPath.row];
        BoListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

        
        CGFloat imageHeight = [cell heightForImage:currentData];
        CGFloat textHeight = [cell heightForText:currentData];
        
        CGFloat height = baseHeight + imageHeight + textHeight;
        

        [self.heightList setValue:[NSString stringWithFormat:@"%g",height ] forKey:key];

        return height;
        
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    BoListViewCellData *currentData = self.dataList[indexPath.row];

    BoListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];



    cell.backgroundColor = [UIColor clearColor];
    [cell setCellData:currentData];
    [self bindCellEvent:cell index:indexPath.row];
    

    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BoListViewCellData *currentData = self.dataList[indexPath.row];
    
    
    DetailTopData *detaiToplData = [[DetailTopData alloc] init];
    detaiToplData.nickname = currentData.nickname;
    detaiToplData.createtime = currentData.createtime;
    detaiToplData.title = currentData.title;
    detaiToplData.pid = currentData.pid;
    detaiToplData.avatarUrl = currentData.avatarImageUrl;
    detaiToplData.picList = currentData.detailPicList;
    detaiToplData.content = currentData.desc;
    
    DetailBottomData *detailBottomData = [[DetailBottomData alloc] init];
    detailBottomData.likecount = currentData.likecount;
    detailBottomData.pid = currentData.pid;
    detailBottomData.sharecount = 0;
    detailBottomData.savecount = 0;
    detailBottomData.isZan = currentData.isZan;
    
    
    HallViewController *vc = (HallViewController*)[self.superview nextResponder];
    DetailViewController *detail = [[DetailViewController alloc] initWithDetailData:detaiToplData bottomData:detailBottomData];

    detail.hidesBottomBarWhenPushed = YES;
    [vc.navigationController pushViewController:detail animated:true];
}
@end
