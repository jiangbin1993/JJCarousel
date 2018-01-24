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
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        // 设置初始平移量
        self.contentOffset = CGPointMake(frame.size.width, 0);
        self.delegate = self;
    }
    return self;
}

- (void)configWithArray:(NSMutableArray *)array{
    if (array.count == 0) {
        return;
    }
    // 页面控制视图
    self.pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.origin.y + self.frame.size.height - 20, self.frame.size.width, 20)];
    _pageCtrl.numberOfPages = array.count;
    _pageCtrl.pageIndicatorTintColor = [UIColor grayColor];
    [_pageCtrl addTarget:self action:@selector(pageCtrlAction:) forControlEvents:(UIControlEventValueChanged)];
    [self.superview addSubview:_pageCtrl];
    
    self.array = [NSMutableArray arrayWithArray:array];
    [self.array addObject:array.firstObject];
    [self.array insertObject:array.lastObject atIndex:0];
    self.contentSize = CGSizeMake(self.frame.size.width * self.array.count, 0);
    
    // 滚动视图上的图片视图们
    for (int i = 0; i < self.array.count; i++) {
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
//        这里推荐使用sd_webimage框架加载图片，因为代码示范不宜加入其它框架，所以这里使用多线程加载
        [self loadImgWithImgview:imgV url:[NSURL URLWithString:self.array[i]]];
        [self addSubview:imgV];
    }
    
    
    [self setupTimer];
}

// 多线程加载图片 防止阻塞主线程造成响应问题
- (void)loadImgWithImgview:(UIImageView *)imgview url:(NSURL *)url{
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        imgview.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    });
}

// pageCtrl点击事件，pageCtrl 影响 scrollView
- (void)pageCtrlAction:(UIPageControl *)pageCtrl
{
    // 更改偏移量动画
    [self setContentOffset:CGPointMake((_pageCtrl.currentPage + 1) * self.frame.size.width, 0) animated:YES];
}

// 定时器实现循环播放
- (void)timerAction:(NSTimer *)timer
{
    _index++;
    [self setContentOffset:CGPointMake(self.frame.size.width * (_index + 1), 0) animated:YES];
    if (_index == self.array.count-2) {
        _index = 0;
        [self setContentOffset:CGPointMake(self.frame.size.width * _index, 0)];
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
    _index = self.contentOffset.x / self.frame.size.width - 1;
    
    if (_index == self.array.count - 2) {
        _index = 0;
        [self setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
    }
    if (_index == -1) {
        _index = self.array.count - 3;
        [self setContentOffset:CGPointMake((self.array.count - 2) * self.frame.size.width, 0) animated:NO];
    }
    _pageCtrl.currentPage = _index;
    // 重新开启定时器
    [self setupTimer];
}


// 创建定时器
- (void)setupTimer
{
    // 定时器：实现自动播放
    self.timer = [NSTimer scheduledTimerWithTimeInterval:_timerInterval target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}


@end
