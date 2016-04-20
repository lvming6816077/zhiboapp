//
//  HomeTarBarView.m
//  ZhiBo
//
//  Created by tenny on 16/2/17.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "HomeTarBarView.h"
#import "Defines.h"
#import "TabBarBtn.h"

@implementation HomeTarBarView

NSMutableArray<TabBarBtn *> *arr;


-(id) initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        // top border
        CALayer *topBorder = [CALayer layer];
        topBorder.frame = CGRectMake(0, 0, self.frame.size.width, 0.5f);
        topBorder.backgroundColor = UIColorFromRGB(0xb2b2b2).CGColor;
        [self.layer addSublayer:topBorder];
        
        
        self.backgroundColor = UIColorFromRGB(0xf8f8f8);
        
        
        NSString *configFile = [[NSBundle mainBundle] pathForResource:@"TabBarItem" ofType:@"plist"];
        NSArray *pageConfigs = [NSArray arrayWithContentsOfFile:configFile];
        arr = [[NSMutableArray alloc] initWithCapacity:pageConfigs.count];
        
        CGFloat tabbarWidth = ScreenWidth / pageConfigs.count;
        for (int i = 0 ; i < pageConfigs.count ; i++) {
            NSDictionary *dic = pageConfigs[i];
            
            if (i == 2) {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i*tabbarWidth+2.5, -7, tabbarWidth-5, HomeTabViewHeight)];
                [view.layer setCornerRadius:3];
                view.backgroundColor = UIColorFromRGB(0x127aca);
                UIImageView *publishView = [[UIImageView alloc] init];
                [publishView.layer setCornerRadius:publishView.frame.size.width/2];
                publishView.clipsToBounds = true;
                publishView.frame = CGRectMake((tabbarWidth-5)/2 - 16, 8, 32, 32);
                [publishView setImage:[UIImage imageNamed:dic[@"Image"]]];
                [view addSubview:publishView];
                [self addSubview:view];
                
                [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(publishClick:)]];
                
            } else {

                
                TabBarBtn *itemBtn = [[TabBarBtn alloc] init];
                
                itemBtn.frame = CGRectMake(i*tabbarWidth, 0, tabbarWidth, HomeTabViewHeight);
                
                itemBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
                [itemBtn setTitle:dic[@"Title"] forState:UIControlStateNormal];
                [itemBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
                [itemBtn setImage:[UIImage imageNamed:dic[@"Image"]] forState:UIControlStateNormal];
                
                
                [itemBtn setTitle:dic[@"Title"] forState:UIControlStateHighlighted];
                [itemBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateHighlighted];
                [itemBtn setImage:[UIImage imageNamed:dic[@"Image"]] forState:UIControlStateHighlighted];
                
                [itemBtn setTitle:dic[@"Title"] forState:UIControlStateSelected];
                [itemBtn setTitleColor:UIColorFromRGB(0x127aca) forState:UIControlStateSelected];
                [itemBtn setImage:[UIImage imageNamed:dic[@"SelectImage"]] forState:UIControlStateSelected];
                
                
                [itemBtn setTitle:dic[@"Title"] forState:UIControlStateSelected | UIControlStateHighlighted];
                [itemBtn setTitleColor:UIColorFromRGB(0x127aca) forState:UIControlStateSelected | UIControlStateHighlighted];
                [itemBtn setImage:[UIImage imageNamed:dic[@"SelectImage"]] forState:UIControlStateSelected | UIControlStateHighlighted];
                
                [itemBtn addTarget:self action:@selector(tabBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                if (i > 2) {
                    [itemBtn setTag:i-1 + 100];
                } else {
                    [itemBtn setTag:i + 100];
                }
                
                [arr addObject:itemBtn];
                [self addSubview:itemBtn];
            }
            

            
        }
    }
    return self;
}

-(void) tabBtnClick:(UIButton *)btn {
    
    for(UIButton *btn in arr) {

        btn.selected = false;
    
    }
    btn.selected = true;
    [self.myDelegate didSelect:btn.tag-100];
}

-(void) publishClick:(UITapGestureRecognizer*) recongizer {

    [self.myDelegate publishClick];
}

@end
