//
//  MessageTableView.m
//  ZhiBo
//
//  Created by tenny on 16/4/10.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "MessageTableView.h"
#import "MessageSysTableViewCell.h"
#import "MessageSysTableViewCellData.h"
@interface MessageTableView()
@property(nonatomic,strong) NSMutableArray<MessageSysTableViewCellData*> *dataList;


@end


@implementation MessageTableView

-(instancetype) initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self initTableView];
    
    }
    return self;
}

-(void) initTableView{
    self.delegate = self;
    self.dataSource = self;
    self.dataList = [NSMutableArray new];
    for (int i = 0 ; i < 4 ; i++) {
        MessageSysTableViewCellData *data = [[MessageSysTableViewCellData alloc] init];
        data.avatarImageUrl = @"http://p.qlogo.cn/gbar_heads/Q3auHgzwzM5QOCk4O6rFic3TxDBzbPPLbZ3pHvpbf891hKwKOacGCzA/";
        data.title = @"直播推荐";
        data.desc = @"直播大神，直播大神直播大神，直播大神直播大神，直播大神";
        data.createTime = @"2014-01-11";
        [self.dataList addObject:data];
    }

}

#pragma mark - UITableViewDelegate
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsZero];
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageSysTableViewCellData *currentData = self.dataList[indexPath.row];
    NSString *cellIdentifier = @"MessageTableViewCell";

    MessageSysTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageSysTableViewCell" owner:self options:nil];
        
        cell = (MessageSysTableViewCell*)[nib objectAtIndex:0];
        NSLog(@"%@",@"复用");
        
    }
    
    [cell setCellData:currentData];
    
    
    return cell;
}
@end
