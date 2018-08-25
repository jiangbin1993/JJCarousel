//
//  JJCarousel.m
//  Carousel
//
//  Created by 斌 on 2017/12/19.
//  Copyright © 2017年 斌. All rights reserved.
//

#import "JJCarousel.h"

@implementation JJCarousel

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.timerInterval = 3;
        self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.scroll.pagingEnabled = YES;
        self.scroll.showsHorizontalScrollIndicator = NO;
        // 设置初始平移量
        self.scroll.contentOffset = CGPointMake(frame.size.width, 0);
        self.scroll.delegate = self;
        [self addSubview:self.scroll];
    }
    return self;
}

- (void)configWithArray:(NSMutableArray *)array{
    if (array.count == 0) {
        return;
    }
    // 页面控制视图
    [self.pageCtrl removeFromSuperview];
    self.pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 20)];
    _pageCtrl.numberOfPages = array.count;
    _pageCtrl.pageIndicatorTintColor = [UIColor grayColor];
    [_pageCtrl addTarget:self action:@selector(pageCtrlAction:) forControlEvents:(UIControlEventValueChanged)];
    [self addSubview:_pageCtrl];
    
    self.array = [NSMutableArray arrayWithArray:array];
    [self.array addObject:array.firstObject];
    [self.array insertObject:array.lastObject atIndex:0];
    self.scroll.contentSize = CGSizeMake(self.scroll.frame.size.width * self.array.count, 0);
    
    // 滚动视图上的图片视图们
    for (int i = 0; i < self.array.count; i++) {
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(self.scroll.frame.size.width * i, 0, self.scroll.frame.size.width, self.scroll.frame.size.height)];
        [self loadImgWithImgview:imgV urlStr:self.array[i]];
        [self.scroll addSubview:imgV];
    }
    
    
    [self setupTimer];
}


- (void)loadImgWithImgview:(UIImageView *)imgview urlStr:(NSString *)urlStr{
    // 多线程加载图片 防止阻塞主线程造成响应问题（如果使用SD_WebImage加载图片，则去除此多线程）
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 判断是网络图片还是本地工程内图片
        if ([urlStr hasPrefix:@"http"]) {
//        这里推荐使用SD_WebImage框架加载图片，因为代码示范不宜加入其它框架，所以这里使用多线程加载
         imgview.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]]];
        }else{
            imgview.image = [UIImage imageNamed:urlStr];
        }
    });
}

// pageCtrl点击事件，pageCtrl 影响 scrollView
- (void)pageCtrlAction:(UIPageControl *)pageCtrl
{
    // 更改偏移量动画
    [self.scroll setContentOffset:CGPointMake((_pageCtrl.currentPage + 1) * self.scroll.frame.size.width, 0) animated:YES];
}

// 定时器实现循环播放
- (void)timerAction:(NSTimer *)timer
{
    _index++;
    [self.scroll setContentOffset:CGPointMake(self.frame.size.width * (_index + 1), 0) animated:YES];
    if (_index == self.array.count-2) {
        _index = 0;
        [self.scroll setContentOffset:CGPointMake(self.scroll.frame.size.width * _index, 0)];
    }
    _pageCtrl.currentPage = _index;
}

// 对应定时器开关安全的处理
// 开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 失效
    [_timer invalidate];
    _timer = nil;
}

// 结束减速代理，scrollView 影响 pageCtrl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // scrollView 滑动偏移量 contantOffset
    // pageCtrl 当前小圆点索引 currentPage
    _index = self.scroll.contentOffset.x / self.scroll.frame.size.width - 1;
    
    if (_index == self.array.count - 2) {
        _index = 0;
        [self.scroll setContentOffset:CGPointMake(self.scroll.frame.size.width, 0) animated:NO];
    }
    if (_index == -1) {
        _index = self.array.count - 3;
        [self.scroll setContentOffset:CGPointMake((self.array.count - 2) * self.scroll.frame.size.width, 0) animated:NO];
    }
    _pageCtrl.currentPage = _index;
    // 重新开启定时器
    [self setupTimer];
}


// 创建定时器
- (void)setupTimer
{
    [self.timer invalidate];
    self.timer = nil;
    // 定时器：实现自动播放
    self.timer = [NSTimer scheduledTimerWithTimeInterval:_timerInterval target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}


@end
