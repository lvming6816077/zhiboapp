//
//  SearchPageViewController.m
//  ZhiBo
//
//  Created by lvming on 16/5/3.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "SearchPageViewController.h"
#import "Defines.h"
#import "SearchPageTableViewCell.h"
#import "SearchPageTableViewCellData.h"

#define NavigationBarHeight (self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height)

@interface SearchPageViewController ()
@property(nonatomic,strong) UISearchBar *searchBar;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataList;
@end

NSString * const  cellIndetifier = @"SearchPageTableViewCell";


@implementation SearchPageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self initSearchBar];
    
    
    [self initTableView];
}

-(void) initSearchBar{
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0,ScreenWidth,44.0f)];
    self.searchBar.delegate = self;
    [self.searchBar setPlaceholder:@"搜索"];
    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
    
    searchField.backgroundColor = UIColorFromRGB(0xe3e4e6);
    
    self.navigationItem.titleView = self.searchBar;
    
    [self.searchBar becomeFirstResponder];
}
-(BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    
    [self.searchBar setShowsCancelButton:true animated:true];
    
    [self.searchBar setTintColor:UIColorFromRGB(0x0078CD)];
    
    return true;
}
-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:true completion:^{
        
    }];
    [searchBar setShowsCancelButton:false animated:true];
    
}
-(void) initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-0)];
    
    [self.view addSubview:self.tableView];
    
    
    self.dataList = [NSMutableArray new];
    
    
    UINib *cellNib = [UINib nibWithNibName:cellIndetifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:cellIndetifier];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    for (int i = 0 ; i < 10; i++) {
        [self.dataList addObject:@""];
    }
    
    
    [self.tableView reloadData];
    
    
    
}
#pragma mark - UITableViewDelegate
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 92;
    
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.dataList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
     SearchPageTableViewCellData *currentData = self.dataList[indexPath.row];
    
    SearchPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier forIndexPath:indexPath];
    
//    cell.myDelegate = self;
    [cell setCellData:currentData];
    
    return cell;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
