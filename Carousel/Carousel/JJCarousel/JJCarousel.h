//
//  JJCarousel.h
//  Carousel
//
//  Created by 斌 on 2017/12/19.
//  Copyright © 2017年 斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JJCarouselDelegate <NSObject>

@optional
/**
 * 点击轮播图的第几页
 */
- (void)clickCarouselWithIndex:(NSInteger)index;

@end

@interface JJCarousel : UIView <UIScrollViewDelegate>

// 滚图
@property (nonatomic, strong) UIScrollView *scroll;
// 定时器
@property (nonatomic, strong) NSTimer *timer;
// 定时器间隔时间(默认3秒 可修改)
@property (nonatomic, assign) CGFloat timerInterval;
// 页签
@property (nonatomic, strong) UIPageControl *pageCtrl;
// 页签序号
@property (nonatomic, assign) NSInteger index;
// 图片数组
@property (nonatomic, strong) NSMutableArray *array;
// 代理
@property (nullable, nonatomic, weak) id <JJCarouselDelegate> delegate;


/**
 * 图片数组配置轮播图
 */
- (void)configWithArray:(NSMutableArray *)array;

/**
 * 销毁，释放自己 不调用会导致内存泄漏
 */
- (void)destroy;

@end
