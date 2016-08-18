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

#import "FacePanel.h"
#import "LoginUtil.h"
#import "DateUtil.h"


#define NavigationBarHeight (self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height)

#define BottomViewHeight 44

NSString * const cellIdentifier = @"DetailTableViewCell";


@interface DetailViewController ()
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) InputFacePanel *inputBarView;
@property(nonatomic,strong) FacePanel *faceView;
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
    
    NSString *_pid;
    
    NSInteger _cellIndex;


    
}

-(instancetype) initWithDetailData:(DetailTopData*)topData bottomData:(DetailBottomData*)bottomData {

    if (self == [super init]) {
    
        self.detailTopData = topData;
        self.detailBottomData = bottomData;
        _cellIndex = 0;
    }
    
    return self;

}

-(instancetype) initWithDetailId:(NSString*)pid {
    
    if (self == [super init]) {
        
        _pid = pid;
        
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
    
    [self initInputView];
}
-(void) refeshValue {
    _start = 0;
    
    
    _imageCount = 0;
    _idmPhotos = [NSMutableArray new];
    
    self.dataList = [NSMutableArray new];
    self.heightList = [[NSMutableDictionary alloc] init];
}

-(void) initTopView{
    
    self.topView = [[DetailTopView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 152) andDetailData:self.detailTopData];
    self.tableView.tableHeaderView = self.topView;
}

-(void) initInputView {
    self.inputBarView = [[InputFacePanel alloc] initWithData:nil andFrame:CGRectMake(0, ScreenHeight-NavigationBarHeight, ScreenWidth, 50)];
    self.inputBarView.delegate = self;
    
    
    self.faceView = [[FacePanel alloc] initWithFrame:CGRectMake(0, ScreenHeight-NavigationBarHeight, ScreenWidth, 200) andOption:nil];
    

    [self.view addSubview:self.inputBarView];
    [self.view addSubview:self.faceView];
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
-(void) initTableView{
    
    // 初始化tableview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavigationBarHeight-BottomViewHeight)];
    self.tableView.separatorStyle = NO;
    [self.view addSubview:self.tableView];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // 初始化变量
    [self refeshValue];
    
    
    // 初始化cell
    UINib *cellNib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:cellIdentifier];
    
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self refeshValue];
        
        [self fetchData:@""];
        
    }];
    
    // 滚动加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _start = MAX(1, _start);
        _start = _start + 1;
        [self fetchData:@""];
        
    }];
    
    
    // 请求数据
    [self fetchData:@""];
    
    
}
-(NSString *)getParams {
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@/reply/getReplyByPost", BaseCgiUrl]];
    NSURLQueryItem *start = [NSURLQueryItem queryItemWithName:@"start" value:[NSString stringWithFormat:@"%d",  MAX(_start, 1)]];
    
    NSURLQueryItem *pid;
    if (self.detailTopData) {
        pid = [NSURLQueryItem queryItemWithName:@"pid" value:[NSString stringWithFormat:@"%d",self.detailTopData.pid]];
        _pid = [NSString stringWithFormat:@"%d",self.detailTopData.pid];
    } else {
        pid = [NSURLQueryItem queryItemWithName:@"pid" value:_pid];
    }

    
    
    components.queryItems = @[start, pid];
    
    return [components string];
}
-(void) fetchData:(NSString*)url {
    
//    url = @"http://tenny.qiniudn.com/detailJson.json";
    
    url = [self getParams];

    [[HttpUtil shareInstance] get:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject, BOOL isCache) {
        NSDictionary *dic = [responseObject valueForKeyPath:@"content"];
        
        [self dealWithData:dic];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    } cachePolicy:CachePolicyOne];
    
    
}

-(void) dealWithData:(NSDictionary*)dic {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    self.tableView.separatorStyle = YES;
    
    NSMutableArray *replyList = [[NSMutableArray alloc] initWithArray:(NSArray*)dic[@"replyList"]];
    
//    if (_start < 2) {
//        NSDictionary *postReply = @{@"reply_createtime":_detailTopData.createtime,
//                                    @"reply_content":_detailTopData.content,
//                                    @"reply_pic":_detailTopData.picList};
//        
//        [replyList insertObject:postReply atIndex:0];
//    }
    
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:replyList.count];
    for (int i = 0 ; i < replyList.count ; i++) {
        DetailTableViewCellData *data = [[DetailTableViewCellData alloc] init];
        data.replyId = [replyList[i][@"id"] integerValue];
        data.avatarImageUrl = dic[@"post"][@"user_info"][@"user_pic"];
        data.floor = replyList[i][@"reply_floor"];
        data.createtime = [DateUtil dateStr:[replyList[i][@"reply_createtime"] doubleValue] format:nil];
        data.content = replyList[i][@"reply_content"];
        data.commonList = [[NSMutableArray alloc] initWithArray:replyList[i][@"commentList"]];
        
        NSArray *picList = replyList[i][@"reply_pic"];
        data.picList = [[NSMutableArray alloc] initWithCapacity:picList.count];
        
        for(int j = 0 ; j < picList.count ; j++) {
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary*)picList[j]];
            [dic setValue:[NSNumber numberWithInteger:_imageCount]  forKey:@"imageIndex"];
            
            [data.picList addObject:dic];
            
            
            IDMPhoto *photo = [IDMPhoto photoWithURL:[NSURL URLWithString:qiuniuUrl(dic[@"key"], 1000)]];
            [_idmPhotos addObject:photo];
            
            
            _imageCount++;
            
        }
        
        [arr addObject:data];
        
    }
    if (arr.count == 0) {

        [self.tableView.mj_footer endRefreshingWithNoMoreData];

    } else {
        self.dataList = (NSMutableArray*)[self.dataList arrayByAddingObjectsFromArray:arr];
        
        
        [self.tableView reloadData];
    }


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
-(void) didOpenReply:(NSInteger) index {
    _cellIndex = index;
    self.faceView.transform = CGAffineTransformIdentity;
    [self.inputBarView focusInput:self.faceView];
}

#pragma mark - InputFacePanelDelegate
-(void) didToggleFace {
//    [UIView animateWithDuration:.5 animations:^{
//        self.faceView.transform = CGAffineTransformMakeTranslation(0, -200);
//    }];
//    [UIView animateWithDuration:.5 animations:^{
//        self.inputBarView.transform = CGAffineTransformMakeTranslation(0, -250);
//    }];
    
//    [self.inputView focusInput];
}
-(void) clickSubmit:(NSString*) str {
    
    DetailTableViewCellData *currentData = self.dataList[_cellIndex];
    [currentData.commonList addObject:@{@"comment_content":str}];
    
    NSString *key = [NSString stringWithFormat:@"%ld",(long)_cellIndex];
    [self.heightList removeObjectForKey:key];
    [self.inputBarView hideInput];
    [self.tableView reloadData];
    
    
    NSString *uid = [LoginUtil getCurrentUserId];
    NSString *rid = [NSString stringWithFormat:@"%d",currentData.replyId];
    
    if (!uid || !rid) return;
    
    NSDictionary *dic = @{
                          @"content":str,
                          @"uid":uid,
                          @"pid":_pid,
                          @"rid":rid};
    
    // send request
    [[HttpUtil shareInstance] post:[NSString stringWithFormat:@"%@/comment/createComment", BaseCgiUrl]parameters:dic formBody:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *dic = [(NSDictionary*)responseObject valueForKey:@"content"];
        NSLog(@"%@",dic);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
    
    
    
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
    currentData.index = indexPath.row;
    [cell setCellData:currentData];
    
    return cell;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    [self searchBarCancelButtonClicked:self.searchBar];
    [self.inputBarView hideInput];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
