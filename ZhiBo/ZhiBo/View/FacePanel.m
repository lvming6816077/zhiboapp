//
//  FacePanel.m
//  ZhiBo
//
//  Created by lvming on 16/7/12.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "FacePanel.h"
#import "Defines.h"

@implementation FacePanel{
    NSArray *_dataArray;
    UIPageControl *_pageControlBottom;
    
}

-(instancetype) initWithFrame:(CGRect)frame andOption:(NSDictionary*) option {
    
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = UIColorFromRGB(0xf4f4f6);
        [self initFaceData];
        [self initFaceView];
        
    }
    return self;
}


-(void) initFaceData {

    NSString *faceData = @"😀,😬,😁,😂,😃,😄,😅,😆,😇,😉,😊,☺️,😋,😌,😍,😘,😗,😙,😚,😜,😝,😛,😎,😏,😶,😐,😑,😒,😳,😞,😟,😠,😡,😔,😕,😣,😖,😫,😩,😤,😮,😱,😨,😰,😯,😦,😧,😢,😥,😪,😓,😭,😵,😲,😷,😴,💩,😈,👹,👺,💀,👻,👽,👏,👋,👍,👎,👊,✊,✌️,👌,✋,👐,💪,🙏,☝️,👆,👇,👈,👉,🖕,🖐,🤘,🖖,✍,💅,👄,👅,👂,👃,👁,👀,👤,👥,🗣,👲,👳,👮,👷,💂,🕵,🎅,👼,👸,👰,🚶,🏃,💃,👯,👫,👬,👭,🙇,💁,🙅,🙆,🙋,🙎,🙍,💇,💆,💑,👩‍❤️‍👩,👨‍❤️‍👨,💏,👩‍❤️‍💋‍👩,👨‍❤️‍💋‍👨,👪,💍,🌂";
    
    _dataArray = [faceData componentsSeparatedByString:@","];
}
-(void) initFaceView {
    
    //collectionview:httpe://www.cnblogs.com/dsxniubility/p/4336210.html
    
    
    _pageControlBottom = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 170, [UIScreen mainScreen].bounds.size.width, 20)];
    _pageControlBottom.numberOfPages = 3;
    
    _pageControlBottom.currentPage = 0;
    // 设置非选中页的圆点颜色
    _pageControlBottom.pageIndicatorTintColor = UIColorFromRGB(0xbbbbbb);
    // 设置选中页的圆点颜色
    _pageControlBottom.currentPageIndicatorTintColor = UIColorFromRGB(0x8b8b8b);
    //collectionView布局
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //水平布局
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    //设置每个表情按钮的大小为30*30

    layout.itemSize=CGSizeMake(37 , 30);
    //计算每个分区的左右边距
    CGFloat xOffset = (self.frame.size.width-7*30-10*6)/2;
    //设置分区的内容偏移
    layout.sectionInset=UIEdgeInsetsMake(10, xOffset, 10, xOffset);
    layout.minimumLineSpacing=10;
    layout.minimumInteritemSpacing=5;
    UICollectionView * collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 160) collectionViewLayout:layout];
    
    //代理设置
    collectView.delegate=self;
    collectView.dataSource=self;
    collectView.pagingEnabled = YES;
    collectView.backgroundColor = UIColorFromRGB(0xf4f4f6);
    //注册item类型 这里使用系统的类型
    [collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"biaoqing"];
    collectView.showsHorizontalScrollIndicator = NO;
    [self addSubview:collectView];
    [self addSubview: _pageControlBottom];
    
}

#pragma mark - UICollectionViewDelegate
//每页24个表情
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 24;
    
}
//返回页数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"biaoqing" forIndexPath:indexPath];
    
    for (int i=cell.contentView.subviews.count; i>0; i--) {
        [cell.contentView.subviews[i-1] removeFromSuperview];
    }
    
//    NSLog(@"%d  %d",indexPath.row,indexPath.section);
    if ((indexPath.row+1) == 24) {
        UIImageView *deleteImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backspace"]];
        deleteImageView.frame = CGRectMake(0, 0, 22, 22);
        deleteImageView.center = cell.contentView.center;
        
//        deleteImageView.contentMode = UIViewContentModeCenter;
        [cell.contentView addSubview:deleteImageView];
    } else {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:25];
        label.text =_dataArray[indexPath.row+indexPath.section*24] ;
        [label setTextAlignment:NSTextAlignmentCenter];
        
        
        [cell.contentView addSubview:label];
    }

    
    
    return cell;
}
//翻页后对分页控制器进行更新
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat contenOffset = scrollView.contentOffset.x;
    int page = contenOffset/scrollView.frame.size.width+((int)contenOffset%(int)scrollView.frame.size.width==0?0:1);
    _pageControlBottom.currentPage = page;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //这里手动将表情符号添加到textField上
    if (indexPath.row == 23) {
        [self.delegate didBackFace];
    } else {
        NSString * str = _dataArray[indexPath.section*24+indexPath.row];
        [self.delegate didSelectFace:str];
    }
    
    
    
}
@end
