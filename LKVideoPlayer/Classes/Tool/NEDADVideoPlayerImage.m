//
//  NEDADVideoPlayerImage.m
//  NEDADVideoPlayer
//
//  Created by Allen Gao on 2021/2/20.
//

#import "NEDADVideoPlayerImage.h"

@implementation NEDADVideoPlayerImage

+ (UIImage *)imageNamed:(NSString *)name {
    return [UIImage imageNamed:[NSString stringWithFormat:@"NEDADVideoPlayer.bundle/%@", name]];
}

@end
