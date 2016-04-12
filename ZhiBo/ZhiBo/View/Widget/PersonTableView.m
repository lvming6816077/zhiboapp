//
//  PersonTableView.m
//  ZhiBo
//
//  Created by tenny on 16/3/27.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "PersonTableView.h"
#import "PersonTopView.h"
#import "Defines.h"
#import "PersonPageViewController.h"
#import "PersonTableCellData.h"
#import "PersonTableViewCell.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "MJRefresh.h"
#define topViewHeight 280
@interface PersonTableView()
@property(nonatomic,strong) NSMutableArray *dataList;
@property(nonatomic,strong) NSMutableArray<NSMutableArray*> *dataGroup;
@property(nonatomic,strong) NSMutableArray<NSString*> *titleList;
@property(nonatomic,strong) PersonTopView *personTopView;

//@property(nonatomic,strong) PersonPageViewController *personVC;

@end

@implementation PersonTableView
{
    PersonPageViewController *_personVC;
    CGRect _frame;
    PersonPageData *_data;
}

-(instancetype) initWithFrame:(CGRect)frame withData:(PersonPageData*)data{
    
    if(self = [super initWithFrame:frame style:UITableViewStylePlain]) {
        self.delegate = self;
        self.dataSource = self;
        self.dataList = [NSMutableArray new];
        self.titleList = [NSMutableArray new];
        _data = data;

        [self fetchData:@""];
        [self initPullRefresh];
        [self initTop];
    }
    
    return self;

}
-(void) initPullRefresh{
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        
        [self fetchData:@""];
        
        [self.mj_footer endRefreshing];
    }];
}
-(void) fetchData:(NSString*)url {
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:true];
    url = @"http://1.lvming6816077.sinaapp.com/testaa/person2.json";

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"http://buluo.qq.com/" forHTTPHeaderField:@"Referer"];
    [manager GET:url
      parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
          
          NSDictionary *dic = [responseObject valueForKeyPath:@"result"];
          [self dealWithData:dic];

          
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Error: %@", error);
      }];
    
}
-(void) dealWithData:(NSDictionary*)dic {
    NSArray *arr = dic[@"post"];
    NSMutableArray *result = [NSMutableArray array];
    
    for(int i = 0 ; i < arr.count ; i++) {
        PersonTableCellData *ncd = [[PersonTableCellData alloc] init];
        
//        ncd.picList = arr[i][@"avatarImageUrl"];
        ncd.postTitle = arr[i][@"title"];
//        ncd.desc = arr[i][@"desc"];
        ncd.likecount = 1310;
        ncd.tagList = @[@"生活",@"aaa"];
        ncd.createtime = [self dateStr:[arr[i][@"createtime"] doubleValue]];
        
        ncd.picList = arr[i][@"piclist"];
        ncd.avatarList = arr[i][@"avatarlist"];
        ncd.status = arr[i][@"status"];
        [result addObject:ncd];
        
    }

    
    self.dataList = (NSMutableArray*)[self.dataList arrayByAddingObjectsFromArray:result];
    
    [self groupData];
    [self reloadData];

}
-(NSString*) dateStr:(double) timestmp {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timestmp]];

    return dateStr;
}
-(void) groupData{
    NSMutableDictionary<NSString*,NSMutableArray*> *dataDic = [NSMutableDictionary new];
    for (int i = 0; i< self.dataList.count; i++) {
        PersonTableCellData *data = self.dataList[i];
        NSMutableArray *array = [dataDic objectForKey:data.createtime];
        if (array.count > 0) {
            [array addObject:data];

        } else {
            [self.titleList addObject:data.createtime];
            [dataDic setValue:[NSMutableArray arrayWithObject:data] forKey:data.createtime];
        }


    }
    
    self.dataGroup = [NSMutableArray arrayWithCapacity:dataDic.count];
    
    for (NSString *key in dataDic) {
        [self.dataGroup addObject:dataDic[key]];
    }

}
-(void) initTop {
//    _personVC = (PersonPageViewController*)[self.superview nextResponder];
    self.personTopView = [[PersonTopView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, topViewHeight) withData:_data];
    self.tableHeaderView = self.personTopView;
    
    self.backgroundColor = [UIColor clearColor];
    self.personTopView.topImageView.alpha = 0;
    
}
-(void) scaleTopImage:(CGFloat)offsetY{
    
//    NSLog(@"%f",self.contentInset.top);
    if (offsetY <= topViewHeight-64) {

        if (offsetY <= 0) {
            CGRect rect = self.tableHeaderView.frame;
            CGFloat delta = fabs(MIN(0.0f, offsetY));
            rect.origin.y -= delta;
            rect.size.height += delta;
            [self.personTopView.topImageView setFrame:rect];
            self.personTopView.topImageView.alpha = 1;
            
            self.personTopView.clipsToBounds = false;
            
            self.contentInset = UIEdgeInsetsMake(0, 0, self.contentInset.bottom, 0);
        } else {

            self.personTopView.topImageView.alpha = 0;
            self.personTopView.clipsToBounds =true;
            self.contentInset = UIEdgeInsetsMake(64, 0, self.contentInset.bottom, 0);
        }
    } else {
        self.contentInset = UIEdgeInsetsMake(64, 0, self.contentInset.bottom, 0);
    }
    
}

-(void) alphTopView:(CGFloat)offsetY {
    

    if(offsetY > 0) {
        
        if (offsetY >= topViewHeight-64) {

            [self.personTopView.topAvatarImageView setAlpha:0];
            [self.personTopView.topAddressBtn setAlpha:0];
            [self.personTopView.topNicknameLabel setAlpha:0];
            [self.personTopView.topBottomView setAlpha:0];
            [self.personTopView.topDescLabel setAlpha:0];
            
        } else {
            CGFloat alpha = 1-(offsetY/(topViewHeight-64));
            [self.personTopView.topAvatarImageView setAlpha:alpha];
            [self.personTopView.topAddressBtn setAlpha:alpha];
            [self.personTopView.topNicknameLabel setAlpha:alpha];
            [self.personTopView.topBottomView setAlpha:alpha];
            [self.personTopView.topDescLabel setAlpha:alpha];
            
        }
        
        
    } else {
        [self.personTopView.topAvatarImageView setAlpha:1];
        [self.personTopView.topAddressBtn setAlpha:1];
        [self.personTopView.topNicknameLabel setAlpha:1];
        [self.personTopView.topBottomView setAlpha:1];
        [self.personTopView.topDescLabel setAlpha:1];
    }
    

}
#pragma mark - UITableViewDelegate
-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
//    offsetY = offsetY + 64;
    // todo
    _personVC = (PersonPageViewController*)[self.superview nextResponder];
    
    [_personVC alphaNavigationBar:offsetY];
    
    [self scaleTopImage:offsetY];
    
    [self alphTopView:offsetY];
    

}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.titleList[section];

}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataGroup.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataGroup[section].count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PersonTableCellData *currentData = self.dataList[indexPath.row];
    NSString *cellIdentifier = @"PersonTableViewCell";
    PersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PersonTableViewCell" owner:self options:nil];
        
        cell = (PersonTableViewCell*)[nib objectAtIndex:0];
        NSLog(@"%@",@"复用");
        
    }
    
    cell.backgroundColor = UIColorFromRGB(0xfcfcfc);
    [cell setCellData:currentData];
    
    
    
    return cell;
}
@end
