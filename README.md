闲来无事封装一个轮播图，方便以后项目直接使用。

github下载地址： https://github.com/jiangbin1993/JJCarousel.git

看看效果图

![carousel.gif](http://upload-images.jianshu.io/upload_images/2541004-3095e655c4a165e7.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



轮播图会自动播放滚动，默认每隔3秒滚动一页，间隔时间可修改。在手动滑动时，定时器会停止，滑动结束定时器自动开始。


如何使用：

将下载下来的工程文件夹JJCarousel内文件导入工程中

![图片.png](http://upload-images.jianshu.io/upload_images/2541004-381999f544105299.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


代码：

```
// 创建滚图
JJCarousel *carousel = [[JJCarousel alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 200)];
// 设置滚图自动滚动时间间隔（单位秒 默认为3秒钟）
    carousel.timerInterval = 1;
    [self.view addSubview:carousel];
// 为轮播图添加图片数组（数组里是图片的url链接字符串或者是工程内图片名。demo里的图片数组就是url连接和工程内图片名称混合。注意：工程内的图片名称不要以http开头！）
[carousel configWithArray:self.array];
```

在封装的轮播图`- (void)configWithArray:(NSMutableArray *)array;`方法里,为imageView加载图片我使用的是多线程方式加载图片，这是为了防止在弱网情况下加载网络图片阻塞了主线程。但是推荐使用SD_WebImage框架为imageView加载图片，使用该框架不仅不会阻塞主线程，还能将图片下载到本地数据库保存，下次直接可以使用数据库中图片，节省流量和时间。

![加载图片代码图.png](http://upload-images.jianshu.io/upload_images/2541004-a6119f7678b4c64d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


可以修改轮播图的基本样式

```
//    修改页签的样式(默认没选中的页签为灰色，选中的为白色)
    carousel.pageCtrl.pageIndicatorTintColor = [UIColor blueColor];
    carousel.pageCtrl.currentPageIndicatorTintColor = [UIColor greenColor];
```







