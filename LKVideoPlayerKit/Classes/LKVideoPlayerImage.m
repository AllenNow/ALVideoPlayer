//
//  LuckinSurveillanceImage.m
//  LuckinEmployee
//
//  Created by Allen Gao on 2020/3/22.
//  Copyright © 2020 Luckin Coffee Ltd,. All rights reserved.
//

#import "LKVideoPlayerImage.h"

@implementation LKVideoPlayerImage
+ (UIImage *)imageNamed:(NSString *)name {
    NSString *filePath = [self filePath:name];
    return [UIImage imageWithContentsOfFile:filePath];
}

+ (NSString *)filePath:(NSString *)name {
    NSBundle *bundle = [NSBundle bundleForClass:[LKVideoPlayerImage class]];
    NSURL *url = [bundle URLForResource:@"LKVideoPlayerKit" withExtension:@"bundle"];
    NSBundle *imageBundle = [NSBundle bundleWithURL:url];
    return  [imageBundle pathForResource:name ofType:@"png"];
}


@end
