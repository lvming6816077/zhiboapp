//
//  HallTableView.m
//  ZhiBo
//
//  Created by tenny on 16/2/19.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "HallTableView.h"
#import "Defines.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "MJRefresh.h"
#import "DetailViewController.h"
#import "HallViewController.h"
#import "PersonPageViewController.h"
#import "HomeViewController.h"
#import "PersonPageData.h"
@interface HallTableView ()

@end


@implementation HallTableView



-(instancetype) initWithFrame:(CGRect)frame {
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:true];
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.dataSource = self;

        
//        UINib *cellNib = [UINib nibWithNibName:@"BoListViewCell" bundle:nil];
//        [self registerNib:cellNib forCellReuseIdentifier:@"BoListViewCell"];
//        [self registerClass:[BoListViewCell class] forCellReuseIdentifier:@"BoListViewCell"];
        self.rowHeight = UITableViewAutomaticDimension;
//        self.estimatedRowHeight = 430;

        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];

//        [self.backgroundView setBackgroundColor:UIColorFromRGB(0xcccccc)];
        
        self.backgroundView = nil;
        
        self.backgroundColor = UIColorFromRGB(0xf0f0f0);

        
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

            self.dataList = nil;

            [self fetchData:@""];
            
        }];
        self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            
            [self fetchData:@""];
            
            [self.mj_footer endRefreshing];
        }];
        

        [self fetchData:@""];
        
 
    }
    
    return self;
}





-(void) fetchData:(NSString*)url {

    url = @"http://7jpp2v.com1.z0.glb.clouddn.com/test5.json";
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript", @"text/html", nil];
    
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"http://buluo.qq.com/" forHTTPHeaderField:@"Referer"];
    [manager.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];// to do
    [manager GET:url
      parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
          
          NSDictionary *dic = [responseObject valueForKeyPath:@"result"];
          [self dealWithData:dic];
          [self.mj_header endRefreshing];
          [self.mj_footer endRefreshing];
          
//          [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Error: %@", error);
      }];
    
}
-(void) dealWithData:(NSDictionary*) data{
    
    NSArray *arr = data[@"post"];
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
        ncd.avatarImageUrl = arr[i][@"avatarImageUrl"];
        ncd.title = arr[i][@"title"];
        ncd.desc = arr[i][@"desc"];
        ncd.likecount = 1310;
        ncd.address = arr[i][@"address"];
        ncd.nickname = arr[i][@"nickname"];
        ncd.createtime = arr[i][@"createtime"];
        ncd.picList = arr[i][@"piclist"];
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

-(CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat baseHeight = 190.0f;
    BoListViewCellData *currentData = self.dataList[indexPath.row];
    
    if (currentData.picList.count == 0) {
        return baseHeight;
    } else if (currentData.picList.count == 1) {
        return baseHeight+((ScreenWidth-16)/2)+20;
    } else {
        return baseHeight+((ScreenWidth-16)/2);
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    BoListViewCellData *currentData = self.dataList[indexPath.row];
    NSString *cellIdentifier = @"BoListViewCell";
    BoListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BoListViewCell" owner:self options:nil];

        cell = (BoListViewCell*)[nib objectAtIndex:0];
        NSLog(@"%@",@"复用");
        
    }

    cell.backgroundColor = [UIColor clearColor];
    [cell setCellData:currentData];
    [self bindCellEvent:cell index:indexPath.row];
    

    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HallViewController *vc = (HallViewController*)[self.superview nextResponder];
    DetailViewController *detail = [[DetailViewController alloc] init];

    detail.hidesBottomBarWhenPushed = YES;
    [vc.navigationController pushViewController:detail animated:true];
}
@end
