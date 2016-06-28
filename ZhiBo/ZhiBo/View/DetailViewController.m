//
//  DetailViewController.m
//  ZhiBo
//
//  Created by tenny on 16/3/10.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "DetailViewController.h"

//#import "AFNetworking.h"
#import "HttpUtil.h"
#import "DetailTableViewCellData.h"
#import "Defines.h"
#import "MJRefresh.h"
#import "IDMPhoto.h"
#import "IDMPhotoBrowser.h"

#import "DetailTopView.h"
#import "DetailBottomView.h"

#import "DateUtil.h"


#define NavigationBarHeight (self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height)

#define BottomViewHeight 44

NSString * const cellIdentifier = @"DetailTableViewCell";


@interface DetailViewController ()
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray<DetailTableViewCellData*> *dataList;
@property(nonatomic,strong) NSMutableDictionary *heightList;
@property(nonatomic,strong) DetailTopView *topView;
@end

@implementation DetailViewController
{
    
    IDMPhotoBrowser *_browser;
    NSMutableArray *_idmPhotos;
    NSInteger _imageCount;

    NSInteger _start;


    
}

-(instancetype) initWithDetailData:(DetailTopData*)topData bottomData:(DetailBottomData*)bottomData {

    if (self == [super init]) {
    
        self.detailTopData = topData;
        self.detailBottomData = bottomData;
        
    }
    
    return self;

}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"详情页";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initTableView];
    
    [self initTopView];
    
    [self initBottomView];
}

-(void) initTopView{
    
    self.topView = [[DetailTopView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 152) andDetailData:self.detailTopData];
    self.tableView.tableHeaderView = self.topView;
}

-(void) initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavigationBarHeight-BottomViewHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    _imageCount = 0;
    _idmPhotos = [NSMutableArray new];
    
    self.dataList = [NSMutableArray new];
    self.heightList = [[NSMutableDictionary alloc] init];
    
    
    UINib *cellNib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:cellIdentifier];
    
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.dataList = nil;
        self.dataList = [NSMutableArray new];
        _start = 0;
        
        [self fetchData:@""];
        
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _start = _start + 1;
        [self fetchData:@""];
        
        
    }];
    
    _start = 0;
    [self fetchData:@""];
    [self.view addSubview:self.tableView];

    
}
-(NSString *)getParams {
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@/reply/getReplyByPost", BaseCgiUrl]];
    NSURLQueryItem *start = [NSURLQueryItem queryItemWithName:@"start" value:[NSString stringWithFormat:@"%d",MAX(_start, 1)]];
    
    NSURLQueryItem *pid = [NSURLQueryItem queryItemWithName:@"pid" value:@"7"];
    
    components.queryItems = @[start, pid];
    
    return [components string];
}
-(void) fetchData:(NSString*)url {
    
//    url = @"http://tenny.qiniudn.com/detailJson.json";
    
    url = [self getParams];
    [[HttpUtil shareInstance] get:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject, BOOL isCache) {
        NSDictionary *dic = [responseObject valueForKeyPath:@"content"];
        [self dealWithData:dic];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    } cachePolicy:CachePolicyOne];
    
    
}

-(void) dealWithData:(NSDictionary*)dic {
    NSArray *replyList = dic[@"replyList"];
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:replyList.count];
    for (int i = 0 ; i < replyList.count ; i++) {
        DetailTableViewCellData *data = [[DetailTableViewCellData alloc] init];
        data.avatarImageUrl = dic[@"post"][@"user_info"][@"user_pic"];
        data.floor = [NSString stringWithFormat:@"%d",i];
        data.createtime = [DateUtil dateStr:[replyList[i][@"reply_createtime"] doubleValue] format:nil];
        data.content = replyList[i][@"reply_content"];
        data.commonList = nil;
        
        NSArray *picList = replyList[i][@"reply_pic"];
        data.picList = [[NSMutableArray alloc] initWithCapacity:picList.count];
        
        for(int j = 0 ; j < picList.count ; j++) {
            
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary*)picList[j]];
            [dic setValue:[NSNumber numberWithInteger:_imageCount]  forKey:@"imageIndex"];
            
            [data.picList addObject:dic];
            
            
            
            IDMPhoto *photo = [IDMPhoto photoWithURL:[NSURL URLWithString:picList[j][@"url"]]];
            [_idmPhotos addObject:photo];
            
            
            _imageCount++;
            
        }
        
        [arr addObject:data];
        
    }
    self.dataList = (NSMutableArray*)[self.dataList arrayByAddingObjectsFromArray:arr];
    
    
    
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
        _browser.usePopAnimation = true;
        _browser.forceHideStatusBar = false;
    _browser.autoHideInterface = NO;
    [_browser setInitialPageIndex:currentImage.tag-100];
    //    PublishViewController *vc = (PublishViewController*)[self.superview.superview nextResponder];
        [self presentViewController:_browser animated:YES completion:nil];
    
}

    //避免循环引用
//    __weak typeof(self) weakSelf=self;


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
        DetailTableViewCellData *currentData = self.dataList[indexPath.row];
        
        DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        CGFloat height = [cell calcHeight:currentData];
        
        [self.heightList setValue:[NSString stringWithFormat:@"%g",height+75 ] forKey:key];
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
    
    DetailTableViewCellData *currentData = self.dataList[indexPath.row];
    
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.myDelegate = self;
    cell.backgroundColor = [UIColor clearColor];
    currentData.index = _imageCount;
    [cell setCellData:currentData];
    
    return cell;

}
-(void) initBottomView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-NavigationBarHeight-BottomViewHeight, ScreenWidth, BottomViewHeight)];
//        topBottomView.layer.borderWidth = 0.5;
//        self.topBottomView.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7].CGColor;
        [bottomView.layer setShadowColor:[UIColor blackColor].CGColor];
        [bottomView.layer setShadowOffset:CGSizeMake(0, 1)];
//    bottomView.layer setS
//        self.topBottomView.layer.masksToBounds = false;
//        self.topBottomView.layer.shouldRasterize = true;
        bottomView.layer.shadowOpacity = .2;
//        bottomView.layer.shadowRadius = 5;
//        self.topBottomView.clipsToBounds = true;
    bottomView.backgroundColor = [UIColor whiteColor];
    
    
    
//    DetailBottomData *bottomData = @{@"pid":[NSString stringWithFormat:@"%d",self.detailTopData.pid]};
    
    DetailBottomView *detailBottomView = [[DetailBottomView alloc] initWithData:self.detailBottomData andFrame:bottomView.bounds];
    
    [bottomView addSubview:detailBottomView];
    
    [self.view addSubview:bottomView];

    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
