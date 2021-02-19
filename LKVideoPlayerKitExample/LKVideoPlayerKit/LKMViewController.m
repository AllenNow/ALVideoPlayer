//
//  LKViewController.m
//  LKVideoPlayerKit
//
//  Created by allennow@126.com on 04/24/2020.
//  Copyright (c) 2020 allennow@126.com. All rights reserved.
//

#import "LKMViewController.h"
#import <LKVideoPlayerKit/LKVideoPlayerKit.h>

@interface LKMViewController ()

@end

@implementation LKMViewController

- (IBAction)videoPreviewAction:(UIButton *)sender {
    [LKVideoPlayerKit previewVideoWithURL:@"http://xiyou.sc.diyixin.com/dev-video-xiyou/20190823/15665420442175.mp4" displayingVC:self];
}

@end
