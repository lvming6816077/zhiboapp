//
//  ChoosePositionViewController.m
//  ZhiBo
//
//  Created by tenny on 16/3/3.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "ChoosePositionViewController.h"

#import "MJRefresh.h"
#import "Defines.h"
#import "PositionTableViewCell.h"
@interface ChoosePositionViewController ()
@property(nonatomic,strong) UISearchBar *searchBar;
@property(nonatomic,strong) NSMutableArray *dataList;
@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,strong) AMapSearchAPI *searchManager;
//@property(nonatomic,strong) BMKPoiSearch *bsearchManager;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,assign) int start;
@property(nonatomic,strong) NSString *keyword;
@property(nonatomic,assign) CLLocationCoordinate2D coordinate;
@property(nonatomic,strong) NSMutableArray *coordinateList;
@property(nonatomic,strong) UIView *maskView;
@end

@implementation ChoosePositionViewController
-(CLLocationManager*)locationManager {
    if (!_locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    return  _locationManager;

}
-(AMapSearchAPI*)searchManager {
    if (!_searchManager) {
        [AMapSearchServices sharedServices].apiKey = @"2f31f646e7f7105804aff06578095273";
        self.searchManager = [[AMapSearchAPI alloc] init];
        self.searchManager.delegate = self;
    }
    return  _searchManager;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = true;
    self.title = @"选择地理位置";
    self.dataList = [NSMutableArray new];
    [self.dataList addObject:@{@"name":@"不使用位置",@"address":@""}];
    self.start = 1;
    self.coordinateList = [NSMutableArray new];
    self.keyword = nil;
//    self.currentCellCoordinate = nil;
    [self initSearchBar];
    [self initPistionTableView];
    [self fetchPosition];
}

-(void) initSearchBar {


    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,40)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"搜索附近位置";
//    self.searchBar 
    
    
}
-(void) addMask{
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight)];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = .0;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeMask:)]];
    [self.maskView removeFromSuperview];
    [UIView animateWithDuration:.2 animations:^{
        self.maskView.alpha = .3;
    }];
    [self.tableView addSubview:self.maskView];
}
-(void) removeMask:(UITapGestureRecognizer*) recongizer {
    [self searchBarCancelButtonClicked:self.searchBar];
    
}
-(BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.tableView.frame = CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height);
    [self.navigationController setNavigationBarHidden:true animated:true];
    [self.searchBar setShowsCancelButton:true animated:true];
    [self addMask];
    self.tableView.scrollEnabled = false;
    return true;
}
-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.tableView.frame = self.view.bounds;
    [self.navigationController setNavigationBarHidden:false animated:true];
    [searchBar setShowsCancelButton:false animated:true];
    [searchBar resignFirstResponder];
    self.tableView.scrollEnabled = true;
    [self.maskView removeFromSuperview];
}
-(void) initPistionTableView {

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.tableHeaderView = self.searchBar;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tableView];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        
        self.start++;
        [self fetchPositionData];
        
        
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

-(void) fetchPosition{

    
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];

        
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
    }
    
}

-(void) fetchPositionData {
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
    //[AMapGeoPoint locationWithLatitude:39.990459 longitude:116.481476];
    request.radius = 1000;
    request.page = self.start;
    request.types = @"购物服务|生活服务|体育休闲服务|医疗保健服务|住宿服务|风景名胜|商务住宅|科教文化服务|公司企业|政府机构及社会团体|金融保险服务";
    
    request.keywords = self.keyword;
    request.sortrule = 0;
    request.requireExtension = true;
    [self.searchManager AMapPOIAroundSearch: request];
//    self.bsearchManager = [[BMKPoiSearch alloc] init];
//    self.bsearchManager.delegate = self;
//    BMKNearbySearchOption *opt = [[BMKNearbySearchOption alloc] init];
//    opt.pageIndex = self.start;
//    opt.pageCapacity = 10;
//    opt.location = self.coordinate;
//    opt.keyword = @"";
//    BOOL flag = [self.bsearchManager poiSearchNearBy:opt];
//    if (flag) {
//        NSLog(@"success");
//    
//    } else {
//        NSLog(@"error");
//    }
    
}
-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error location");
}
-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {

    
    CLLocation *location = locations[0];
    
    
    CLLocationCoordinate2D coordinate = location.coordinate;
    self.coordinate = coordinate;

    [self fetchPositionData];
    
    [manager stopUpdatingLocation];

}
//-(void) onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode {
//
//    if (errorCode == BMK_SEARCH_NO_ERROR) {
//        
//        for (BMKPoiInfo *info in poiResult.poiInfoList) {
//            NSLog(@"%@",info.name);
//            NSLog(@"%@",info.address);
//            [self.dataList addObject:info];
//        }
//        
//        [self.tableView reloadData];
//    }
//
//}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    NSLog(@"%d",response.pois.count);
    if (response.pois.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    [self.tableView.mj_footer resetNoMoreData];
    [self.maskView removeFromSuperview];
    self.tableView.scrollEnabled = true;
//    AMapPOI *first = response.pois[0];
    
//    [self.dataList insertObject:@{@"name":first.city,@"address":@""} atIndex:0];
//    [self.dataList replaceObjectAtIndex:0 withObject:@{@"name":first.city,@"address":@""}];


    for (AMapPOI *p in response.pois) {
        if (p.location.latitude && p.location.longitude) {
            NSString *latitude = [NSString stringWithFormat:@"%f",p.location.latitude];
            NSString *longitude = [NSString stringWithFormat:@"%f",p.location.longitude];
            NSDictionary *dic = @{@"name":p.name,
                                  @"address":p.address,
                                  @"latitude":latitude,
                                  @"longitude":longitude,
                                  @"city":[NSString stringWithFormat:@"%@ %@",p.city,p.district]
                                  };
            
            
            if (![self.coordinateList containsObject:[NSString stringWithFormat:@"%@,%@",latitude,longitude]]) {
                [self.coordinateList addObject:[NSString stringWithFormat:@"%@,%@",latitude,longitude]];
                [self.dataList addObject:dic];
            }
            
        }
        
    }
    

    [self.tableView reloadData];

}
#pragma mark - UISearchBarDelegate
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.keyword = searchBar.text;
    self.start = 1;
    self.dataList = [NSMutableArray new];
    [self.dataList addObject:@{@"name":@"不使用位置",@"address":@""}];
    self.coordinateList = [NSMutableArray new];
    [self fetchPositionData];
}
#pragma mark - UITableViewDataSource
//-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
//
//    CGRect frame = self.searchBar.frame;
//    frame.origin.y = MIN(0,scrollView.contentOffset.y);
//    self.searchBar.frame = frame;
//}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self searchBarCancelButtonClicked:self.searchBar];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *cellIdentifier = @"PositionViewCell";
    PositionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {

        cell = [[PositionTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];

    }
    
    [cell setCellData:self.dataList[indexPath.row] index:(int)indexPath.row currentCellCoordinate:self.currentCellCoordinate];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PositionTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;

    NSDictionary *dic = self.dataList[indexPath.row];
    if (dic[@"latitude"] && dic[@"longitude"]) {
        self.currentCellCoordinate = @{@"name":dic[@"name"],
                                       @"address":dic[@"address"],
                                       @"latitude":dic[@"latitude"],
                                       @"longitude":dic[@"longitude"]};

    } else {
        self.currentCellCoordinate = nil;
    }
    
    [self.delegate selectAddress:self.currentCellCoordinate];
    [self.navigationController popViewControllerAnimated:true];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
