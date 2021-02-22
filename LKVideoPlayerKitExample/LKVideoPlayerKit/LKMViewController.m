//
//  LKViewController.m
//  LKVideoPlayerKit
//
//  Created by allennow@126.com on 04/24/2020.
//  Copyright (c) 2020 allennow@126.com. All rights reserved.
//

#import "LKMViewController.h"
#import <Masonry/Masonry.h>
#import <LKVideoPlayer/NEDADVideoPlayerImage.h>
#import <LKVideoPlayer/NEDADVideoPlayer.h>
#import <LKVideoPlayer/NEDADVideoBrightnessView.h>

@interface LKMViewController ()<NEDADVideoPlayerDelegate>
@property (nonatomic, strong) NEDADVideoPlayer *player;
@property (nonatomic, strong) UIView *playerFatherView;
@property (nonatomic, strong) UIView *playerFatherView2;
@property (nonatomic, strong) NEDADVideoPlayerModel *playerModel;
@property (nonatomic, strong) NSString *url;

/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
/** 离开页面时候是否开始过播放 */
@property (nonatomic, assign) BOOL isStartPlay;

@end

@implementation LKMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.url = @"http://xiyou.sc.diyixin.com/dev-video-xiyou/20190823/15665420442175.mp4";
    [self.view addSubview:self.playerFatherView];
    
    NEDADVideoPlayerModel *model = [[NEDADVideoPlayerModel alloc] init];
    model.videoURL = [NSURL URLWithString:self.url];
    
    NEDADVideoPlayer *player = [NEDADVideoPlayer videoPlayerWithView:self.playerFatherView delegate:self playerModel:model];
    self.player = player;
    
    [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(88);
        make.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(UIScreen.mainScreen.bounds.size.width / 16 * 9);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    // pop回来时候是否自动播放
    if (self.player && self.isPlaying) {
        self.isPlaying = NO;
        [self.player playVideo];
    }
    [NEDADVideoBrightnessView sharedBrightnessView].isStartPlay = self.isStartPlay;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    if (self.player && !self.player.isPauseByUser) {    // push出下一级页面时候暂停
        self.isPlaying = YES;
        [self.player pauseVideo];
    }
    
    [NEDADVideoBrightnessView sharedBrightnessView].isStartPlay = NO;
}

#pragma mark - getter

- (UIView *)playerFatherView {
    if (!_playerFatherView) {
        _playerFatherView = [[UIView alloc] init];
    }
    return _playerFatherView;
}

- (NEDADVideoPlayerModel *)playerModel {
    if (!_playerModel) {
        _playerModel = [[NEDADVideoPlayerModel alloc] init];
    }
    return _playerModel;
}

@end
