//
//  FindViewController.m
//  ZhiBo
//
//  Created by tenny on 16/2/17.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "FindViewController.h"
#import "Defines.h"
#import "UIKit+AFNetworking.h"

#import "AFNetworking.h"
#import "MJRefresh.h"
#import "IDMPhoto.h"
#import "IDMPhotoBrowser.h"
#import "SearchPageViewController.h"

#define NavigationBarHeight (self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height)


@interface FindViewController ()
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) NSMutableArray *dataList;
@property(nonatomic,strong) NSMutableDictionary *heightList; // cache cell height
@end

NSString * const xcellIdentifier = @"FindTableViewCell"; // to do why must be x cellidentifier


@implementation FindViewController
{
    
    IDMPhotoBrowser *_browser;
    NSMutableArray *_idmPhotos;
    NSInteger _imageCount;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发现";
    self.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
    
    [self initNavBtn];
    
    [self initTopView];
    
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initNavBtn{
    
    //set right btn
    UIBarButtonItem *btnRight = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"searchIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(searchClick)];
    btnRight.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = btnRight;
    
}
-(void) searchClick {
    SearchPageViewController *searchVC = [[SearchPageViewController alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:searchVC];
    navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:navController animated:YES completion:nil];
    
}
-(void) initTopView{
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, -8, ScreenWidth, 192)];
    self.topView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    UIView *borderBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 191.5, ScreenWidth, .5)];
    borderBottom.backgroundColor = UIColorFromRGB(0xcccccc);
    [self.topView addSubview:borderBottom];
    
    UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 16, 60, 20)];
    categoryLabel.text = @"热门标签";
    [categoryLabel setFont:[UIFont systemFontOfSize:15.0]];
    [categoryLabel setTextColor:UIColorFromRGB(0x333333)];
    [self.topView addSubview:categoryLabel];
    
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-70, 23, 70, 20)];
    moreLabel.text = @"查看更多>>";
    [moreLabel setFont:[UIFont systemFontOfSize:11.0]];
    [moreLabel setTextColor:UIColorFromRGB(0x333333)];
    [moreLabel setTextAlignment:NSTextAlignmentCenter];
    [self.topView addSubview:moreLabel];
    
    
    NSArray *result = [[NSArray alloc] initWithObjects:
    @{@"imageUrl":@"http://p.qpic.cn/qqconadmin/0/40e95ff9007e46198c3a1b7b0bf340a1/0",@"text":@"旅行"},
    @{@"imageUrl":@"http://p.qlogo.cn/gbar_heads/Q3auHgzwzM5ZkIv23UzTuDibBLO2BkIzNwHanQicpmTI31fcl9W85Jqw/",@"text":@"拍景"},
    @{@"imageUrl":@"http://p.qpic.cn/qqconadmin/0/4cfa3abc98a14d1083d28cd59734960a/0",@"text":@"超级女声"},
    @{@"imageUrl":@"http://p.qpic.cn/qqconadmin/0/a7d24efdfd11423180d444b8a12c8430/0",@"text":@"小说"},
    @{@"imageUrl":@"http://p.qlogo.cn/gbar_heads/Q3auHgzwzM4hQCQSI2FQ12Uqzf4gZgQDJp6yCAzSjXNQFNfdDnHRLw/",@"text":@"头条新闻"},
    @{@"imageUrl":@"http://p.qpic.cn/qqconadmin/0/4d0435950c8a41cfbeac33e73d2bc94f/0",@"text":@"火影忍者"},
    @{@"imageUrl":@"http://p.qpic.cn/qqconadmin/0/e6716c203a70455ab0953f3f0652872c/0",@"text":@"美食"},
    nil];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(8, 52, ScreenWidth-8, 100)];
    scrollView.showsHorizontalScrollIndicator = NO;
    CGFloat imageWidth = 70;
    
    for (int i = 0 ; i < result.count ; i++) {
        CGFloat x = i*imageWidth+(i*13);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, imageWidth, imageWidth)];
        UILabel *imageLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, imageWidth+5, 70, 20)];
        
        
        [imageView setImageWithURL:[NSURL URLWithString:result[i][@"imageUrl"]] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
        [imageView.layer setCornerRadius:5.0f];
        imageView.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
        imageView.layer.borderWidth = .5;
        imageView.clipsToBounds = YES;
        
        imageLabel.text = result[i][@"text"];
        [imageLabel setFont:[UIFont systemFontOfSize:13.0]];
        [imageLabel setTextColor:UIColorFromRGB(0x333333)];
        [imageLabel setTextAlignment:NSTextAlignmentCenter];
        
        
        [scrollView addSubview:imageView];
        [scrollView addSubview:imageLabel];
        
        
    }
    [scrollView setContentSize:CGSizeMake(7*imageWidth+7*10, 0)];
    
    
    [self.topView addSubview:scrollView];
    
    UILabel *aroundLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 160, 60, 20)];
    aroundLabel.text = @"附近直播";
    [aroundLabel setFont:[UIFont systemFontOfSize:15.0]];
    [aroundLabel setTextColor:UIColorFromRGB(0x333333)];
    [self.topView addSubview:aroundLabel];
    
}
-(void) resetTableViewConfig{
    self.dataList = nil;
    self.dataList = [NSMutableArray new];
    
    
    _imageCount = 0;
    _idmPhotos = [NSMutableArray new];
    
    self.heightList = [[NSMutableDictionary alloc] init];
}
-(void) initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-NavigationBarHeight)];
    self.tableView.tableHeaderView = self.topView;
    
    [self resetTableViewConfig];
    
    
    
    UINib *cellNib = [UINib nibWithNibName:xcellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:xcellIdentifier];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self resetTableViewConfig];
        
        [self fetchData:@""];
        
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self fetchData:@""];
        
        
    }];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self fetchData:@""];
    
    
    [self.view addSubview:self.tableView];
    
}

-(void) fetchData:(NSString*)url {
    
    
    NSString *requestUrl = [NSString stringWithFormat:@"http://buluo.qq.com/cgi-bin/bar/post/get_post_by_page?bid=%@%@",@"10050",@"&start=0&num=10"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"http://buluo.qq.com/" forHTTPHeaderField:@"Referer"];
    
    [manager.requestSerializer setCachePolicy:NSURLRequestUseProtocolCachePolicy];// to do
    [manager GET:requestUrl
      parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
          
          NSDictionary *dic = [responseObject valueForKeyPath:@"result"];
          [self dealWithData:dic];
          [self.tableView.mj_header endRefreshing];
          [self.tableView.mj_footer endRefreshing];
          
          
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Error: %@", error);
      }];
    
}
-(void) dealWithData:(NSDictionary*)dic {
    NSArray *posts = dic[@"posts"];
//    NSArray *list = array;
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:posts.count];
    for (int i = 0 ; i < posts.count ; i++) {
        FindTableViewCellData *data = [[FindTableViewCellData alloc] init];
        data.avatarImageUrl = posts[i][@"user"][@"pic"];
        data.nickname = posts[i][@"user"][@"nick_name"];
        data.distance = @"小于100m";
        data.tagName = @"小说";
        data.content = posts[i][@"post"][@"content"];
        @try {
            
            data.picDic = posts[i][@"post"][@"pic_list"][0];
            
        } @catch (NSException *exception) {
            data.picDic = nil;
        } @finally {
            
        }
        
        if (data.picDic) {
            IDMPhoto *photo = [IDMPhoto photoWithURL:[NSURL URLWithString:data.picDic[@"url"]]];
            [_idmPhotos addObject:photo];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary*)data.picDic];
            [dic setValue:[NSNumber numberWithInteger:_imageCount] forKey:@"imageCount"];
            data.picDic = dic;
            _imageCount++;
        }
        
        [result addObject:data];
    
    }
    
    self.dataList = (NSMutableArray*)[self.dataList arrayByAddingObjectsFromArray:result];
    [self.tableView reloadData];
    
    
}
#pragma mark - DetailTableViewCellDelegate
-(void) didOpenImage:(UIImageView*)currentImage {
    _browser = [[IDMPhotoBrowser alloc] initWithPhotos:_idmPhotos animatedFromView:currentImage];
    
    
    _browser.scaleImage = currentImage.image;
    _browser.displayCounterLabel = YES;
    _browser.displayActionButton = NO;
    _browser.displayDoneButton = NO;
    _browser.displayArrowButton = NO;
    _browser.disableVerticalSwipe = YES;
    _browser.usePopAnimation = YES;
    _browser.forceHideStatusBar = NO;
    _browser.autoHideInterface = NO;
    [_browser setInitialPageIndex:currentImage.tag-100];

    [self presentViewController:_browser animated:YES completion:nil ];
    
}
#pragma mark - UITableViewDelegate
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    if ([self.heightList objectForKey:key]) {
        return [[self.heightList objectForKey:key] floatValue];
    } else {
        FindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:xcellIdentifier];
        
        FindTableViewCellData *currentData = self.dataList[indexPath.row];
        
        CGFloat height = [cell heightForCell:currentData];

        
        [self.heightList setValue:[NSString stringWithFormat:@"%g",height ] forKey:key];
        return height;
        
    }
    
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.dataList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    FindTableViewCellData *currentData = self.dataList[indexPath.row];

    FindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:xcellIdentifier forIndexPath:indexPath];

    cell.myDelegate = self;
    [cell setCellData:currentData];
    
    return cell;
    
}
@end
