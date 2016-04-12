//
//  PositionTableViewCell.m
//  ZhiBo
//
//  Created by tenny on 16/3/3.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "PositionTableViewCell.h"
#import "Defines.h"
#import <AMapSearchKit/AMapSearchKit.h>
@implementation PositionTableViewCell
{
    NSIndexPath *_indexPath;
}

- (void)awakeFromNib {
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self initBottomView];

    }

    return self;
}
-(void) initBottomView {


    UIView *separator = nil;
    separator = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height+5, ScreenWidth, .5)];
    

    separator.backgroundColor = UIColorFromRGB(0xc8c7cc);
    
    [self.contentView addSubview:separator];


}
-(void) setCellData:(id)data index:(int)index currentCellCoordinate:(NSDictionary*)currentCellCoordinate{
    NSDictionary *p = (NSDictionary*)data;
    [self.textLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self.textLabel setTextColor:[UIColor blackColor]];
    if (index == 0) {
        self.textLabel.text = [p objectForKey:@"name"];
        [self.textLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [self.textLabel setTextColor:[UIColor grayColor]];
        self.detailTextLabel.text = nil;
        self.imageView.image = nil;
    } else {
        self.textLabel.text = [p objectForKey:@"name"];
        self.imageView.image = [UIImage imageNamed:@"locationIcon"];
        self.detailTextLabel.text = [NSString stringWithFormat:@"%@,%@,%@",[p objectForKey:@"address"],[p objectForKey:@"latitude"],[p objectForKey:@"longitude"]];
        [self.detailTextLabel setTextColor:[UIColor grayColor]];
        
    }

    if (currentCellCoordinate) {
        if ([data[@"latitude"] isEqualToString:currentCellCoordinate[@"latitude"]] && [data[@"longitude"] isEqualToString:currentCellCoordinate[@"longitude"]]) {
            self.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            self.accessoryType = UITableViewCellAccessoryNone;
        }
    
    }else {
        if (index == 0) {
            self.accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
            self.accessoryType = UITableViewCellAccessoryNone;
        }
    }
}
@end
