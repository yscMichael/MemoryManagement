//
//  NSCodingMethodController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/18.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "NSCodingMethodController.h"
#import "Movie.h"

@interface NSCodingMethodController ()

@end

@implementation NSCodingMethodController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    Movie *movie = [[Movie alloc] init];
    movie.movieId = @"movieIdmovieId";
    movie.movieName = @"movieNamemovieName";
    movie.pic_url = @"pic_urlpic_url";
    //归档
    //指定路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //获得文件的全路径
    NSString *path = [doc stringByAppendingPathComponent:@"stu.data"];
    [NSKeyedArchiver archiveRootObject:movie toFile:path];

    //解档
    Movie *tempMovie = [[Movie alloc] init];
    tempMovie = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSLog(@"tempMovie = %@",tempMovie.movieId);
}


@end


