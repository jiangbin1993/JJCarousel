//
//  ViewController.m
//  Carousel
//
//  Created by 斌 on 2017/12/19.
//  Copyright © 2017年 斌. All rights reserved.
//

#import "ViewController.h"
#import "JJCarousel.h"

@interface ViewController () <JJCarouselDelegate>

@property(nonatomic,strong) NSMutableArray *array;

@property (nonatomic, weak) JJCarousel * carousel;

@end

@implementation ViewController

- (NSMutableArray *)array{
    if(!_array){
        _array = [NSMutableArray array];
    }
    return _array;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    JJCarousel *carousel = [[JJCarousel alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 200)];
//    修改自动滚动间隔时间
    carousel.timerInterval = 1;
    carousel.delegate = self;
    [self.view addSubview:carousel];
    self.carousel = carousel;
    
//    模拟数据
    [self loadData];
//    加载图片数组
    [carousel configWithArray:self.array];
    
//    修改页签的样式
    carousel.pageCtrl.pageIndicatorTintColor = [UIColor blueColor];
    carousel.pageCtrl.currentPageIndicatorTintColor = [UIColor greenColor];
}

- (void)loadData{
    [self.array addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1513682718121&di=d60e518a700bad6a6b06c0de999795b1&imgtype=0&src=http%3A%2F%2Fscimg.jb51.net%2Fallimg%2F161013%2F106-161013162P5a8.jpg"];
    [self.array addObject:@"a"];
    [self.array addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1513682930654&di=92338ecb020a8fb4882322873385dca7&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F11%2F16%2F28%2F22J58PICIKD.jpg"];
    [self.array addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1513682944228&di=4b865c92560703dcf87c9b0e6a69aac7&imgtype=0&src=http%3A%2F%2Fimg5q.duitang.com%2Fuploads%2Fitem%2F201502%2F21%2F20150221151214_AdKvv.jpeg"];
}

#pragma mark -----------JJCarousel代理方法--------
- (void)clickCarouselWithIndex:(NSInteger)index {
    NSLog(@"点击了第%ld页",index);
}

- (void)dealloc {
    [self.carousel destroy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
