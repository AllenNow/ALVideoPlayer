//
//  NEDADPalyerKit.m
//  LKVideoPlayer
//
//  Created by Allen Gao on 2021/2/23.
//

#import "NEDADPalyerKit.h"


@interface NEDADPalyerKit()<NEDADVideoPlayerDelegate>

@property (nonatomic, strong) NSMutableArray *playerArray;

@end

@implementation NEDADPalyerKit

+ (instancetype)defaultKit {
    static NEDADPalyerKit *defaultKit;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultKit = [[self alloc] init];
    });
    return defaultKit;
}

/**
 创建视频播放视图类
 @view   在正常屏幕下的视图位置
 @viewController 为当前播放视频的控制器
 */
- (NEDADVideoPlayer *)createPlayerWithView:(UIView *)view
                                  delegate:(id<NEDADVideoPlayerDelegate>)delegate
                               playerModel:(NEDADVideoPlayerModel *)playerModel
                                 indexPath:(NSIndexPath *)indexPath {
    
    
    NEDADVideoPlayer *videoPlayer = [NEDADVideoPlayer videoPlayerWithView:view delegate:self playerModel:playerModel];
    videoPlayer.indexPath = indexPath;
    
    NSInteger index = -1;
    for (NSInteger i = 0; i < self.playerArray.count; i++) {
        NEDADVideoPlayer *player = self.playerArray[i];
        if (player.indexPath == indexPath) {
            if (player.state == LKPlayerStateUnknow) {
                index = i;
            }
            if (player.state == LKPlayerStatePlaying) {
                return player;
            }
        }
    }
    
    if (index == -1) {
        [self.playerArray addObject:videoPlayer];
    } else {
        self.playerArray[index] = videoPlayer;
    }
    
    return videoPlayer;
}

- (NSMutableArray *)playerArray {
    if (!_playerArray) {
        _playerArray = [NSMutableArray array];
    }
    return _playerArray;;
}

- (void)playerDidClickCoverPlay:(NEDADVideoPlayer *)player {
    for (NSInteger i = 0; i < self.playerArray.count; i++) {
        NEDADVideoPlayer *playerTemp = self.playerArray[i];
        if (player.indexPath != playerTemp.indexPath) {
            playerTemp.state = LKPlayerStateUnknow;
        }
    }
}

@end
