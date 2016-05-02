//
//  DetailViewController.m
//  ZhiBo
//
//  Created by tenny on 16/3/10.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "DetailViewController.h"

#import "AFNetworking.h"
#import "DetailTableViewCellData.h"
#import "Defines.h"
#import "MJRefresh.h"
#import "IDMPhoto.h"
#import "IDMPhotoBrowser.h"

#define NavigationBarHeight (self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height)

NSString * const cellIdentifier = @"DetailTableViewCell";


@interface DetailViewController ()
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray<DetailTableViewCellData*> *dataList;
@property(nonatomic,strong) NSMutableDictionary *heightList;
@end

@implementation DetailViewController
{
    
    IDMPhotoBrowser *_browser;
    NSMutableArray *_idmPhotos;
    NSInteger _imageCount;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"详情页";
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.translucent = true;
    
    [self initTableView];
}


-(void) initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavigationBarHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;

    
//    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    _imageCount = 0;
    _idmPhotos = [NSMutableArray new];
    
    self.dataList = [NSMutableArray new];
    self.heightList = [[NSMutableDictionary alloc] init];
    
    
    UINib *cellNib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:cellIdentifier];
//    [self registerClass:[BoListViewCell class] forCellReuseIdentifier:@"BoListViewCell"];
    
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.dataList = nil;
        self.dataList = [NSMutableArray new];
        
        [self fetchData:@""];
        
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{

        [self fetchData:@""];
        
        
    }];
    
    
    [self fetchData:@""];
    [self.view addSubview:self.tableView];

}
-(void) fetchData:(NSString*)url {
    
    url = @"http://tenny.qiniudn.com/detailJson.json";

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];


    [manager.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];// to do
    [manager GET:url
      parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
          
          NSDictionary *dic = [responseObject valueForKeyPath:@"result"];
          [self dealWithData:dic];
          [self.tableView.mj_header endRefreshing];
          [self.tableView.mj_footer endRefreshing];
          

      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Error: %@", error);
      }];
    
}

-(void) dealWithData:(NSDictionary*)dic{
    NSArray *posts = dic[@"posts"];
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:posts.count];
    for (int i = 0 ; i < posts.count ; i++) {
        DetailTableViewCellData *data = [[DetailTableViewCellData alloc] init];
        data.avatarImageUrl = posts[i][@"user"][@"pic"];
        data.floor = [NSString stringWithFormat:@"%d",i];
        data.createtime = @"2012-02-03";
        data.content = posts[i][@"title"];
        data.commonList = posts[i][@"common"][@"list"];
        
        NSArray *picList = posts[i][@"pic_list"];
        data.picList = [[NSMutableArray alloc] initWithCapacity:picList.count];
        
        for(int j = 0 ; j < picList.count ; j++) {
            
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary*)picList[j]];
            [dic setValue:[NSNumber numberWithInteger:_imageCount]  forKey:@"imageIndex"];
            
            [data.picList addObject:dic];
            
            
            
            IDMPhoto *photo = [IDMPhoto photoWithURL:[NSURL URLWithString:data.picList[j][@"url"]]];
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
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    
//    
//
//    
//}
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
