//
//  MyViewController.m
//  Wodu
//
//  Created by tenny on 15/12/27.
//  Copyright © 2015年 tenny. All rights reserved.
//

#import "MyViewController.h"
#import "MyPageTableViewCell.h"
#import "UIKit+AFNetworking.h"


@interface MyViewController ()
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataList;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initTableView];
    
}
-(void) initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 85;
    } else {
        return 40;
    }
    
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 2;
    }

}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%d",indexPath.section);
    
    if (indexPath.section == 0) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyPageTableViewCell" owner:self options:nil];
        
        MyPageTableViewCell *cell = (MyPageTableViewCell*)[nib objectAtIndex:0];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        NSDictionary *userInfo = [userDefaults valueForKey:@"user_info"];
        
        [cell.avatarImageView setImageWithURL:[NSURL URLWithString:userInfo[@"user_pic"]]];
        
        [cell.nicknameLabel setText:userInfo[@"user_nickname"]];
        
        [cell.fensiLabel setText:@"粉丝：255"];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        if (indexPath.section == 1) {
            cell.imageView.image = [UIImage imageNamed:@"shoucang"];
            
            cell.textLabel.text = @"我的收藏";
        }
        
        if (indexPath.section == 2) {
            if (indexPath.row == 0) {
            
                cell.imageView.image = [UIImage imageNamed:@"setting"];
                
                cell.textLabel.text = @"设置";
            
            } else {
                cell.imageView.image = [UIImage imageNamed:@"yijian"];
                
                cell.textLabel.text = @"反馈留言";
            }
        
        }
        
        
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        
        return cell;
    }
    
}


@end
