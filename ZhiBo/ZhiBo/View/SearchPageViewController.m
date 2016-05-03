//
//  SearchPageViewController.m
//  ZhiBo
//
//  Created by lvming on 16/5/3.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "SearchPageViewController.h"
#import "Defines.h"

@interface SearchPageViewController ()
@property(nonatomic,strong) UISearchBar *searchBar;
@end

@implementation SearchPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self initSearchBar];
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
-(bool) searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    [self.searchBar setShowsCancelButton:true animated:true];
    
    return true;
}
-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:true completion:^{
        
    }];
    [searchBar setShowsCancelButton:false animated:true];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
