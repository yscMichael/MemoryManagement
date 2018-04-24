//
//  SDWebImageBasicController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/17.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "SDWebImageBasicController.h"

@interface SDWebImageBasicController ()

@end

@implementation SDWebImageBasicController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

}

//问题1:SDWebImage缓存机制
//答案:主要分为内存缓存和硬盘缓存
//主要流程如下:
//1.入口setImageWithURL:placeholderImage:options:
//  会先把placeholderImage显示,然后SDWebImageManager根据URL开始处理图片
//
//2.进入SDWebImageManager类中downloadWithURL:delegate:options:userInfo:交给SDImageCache从缓存查找图片是否已经下载
//
//3.先从内存图片缓存查找是否有图片,如果内存中已经有图片缓存,SDImageCacheDelegate回调 imageCache:didFindImage:forKey:userInfo:到SDWebImageManager
//
//4.如果内存缓存中没有,生成'NSOperation'
//  添加到队列,开始从硬盘查找图片是否已经缓存
//
//5.根据URL的MD5值Key在硬盘缓存目录下尝试读取图片文件.这一步是在NSOperation进行的操作,
//  所以回主线程进行结果回调notifyDelegate:
//
//6.如果上一操作从硬盘读取到了图片,将图片添加到内存缓存中
//
//7.如果从硬盘缓存目录读取不到图片,说明所有缓存都不存在该图片,需要下载图片,回调 imageCache:didNotFindImageForKey:userInfo:
//
//8.共享或重新生成一个下载器SDWebImageDownloader开始下载图片
//
//9.图片下载由NSURLConnection来做
//
//10.图片解码处理在一个NSOperationQueue完成,不会拖慢主线程UI.
//   如果有需要对下载的图片进行二次处理,最好也在这里完成,效率会好很多
//
//
//问题2:SDWebImage内存升高问题
//1、问题存在于sd_imageWithData:
//   image = [[UIImage alloc]initWithData:data];(方法中代码)
//   发现这里面对图片的处理是直接按照原大小进行的,如果几千是分辨率这里导致占用了大量内存
//   所以我们需要在这里对图片做一次等比的压缩.
//
//2、UIImageJPEGRepresentation:等比例压缩
//   [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];//清除缓存
//
//
//
//问题3:SDWebImage下载一个10G的图片
//目前没有定论
//参考答案:使用URLConnnection和imageIO完成渐进加载图片


//参考文章:
//1、SDWebImage原理和缓存机制
//   https://www.jianshu.com/p/7dea5b081d24
//
//



@end
