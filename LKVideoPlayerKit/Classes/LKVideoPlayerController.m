//
//  LKVideoPlayerController.m
//  LKVideoPlayerKit
//
//  Created by Allen Gao on 2020/4/29.
//

#import "LKVideoPlayerController.h"
#import "LKVideoPlayerKit.h"
#import <Masonry/Masonry.h>
#import "LKVideoPlayerImage.h"

@interface LKVideoPlayerController ()<LKVideoPlayerDelegate>
@property (nonatomic, strong) LKVideoPlayer *player;
@property (nonatomic, strong) UIView *playerFatherView;
@property (nonatomic, strong) LKPlayerModel *playerModel;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) UIButton *closeButton;

/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
/** 离开页面时候是否开始过播放 */
@property (nonatomic, assign) BOOL isStartPlay;
@end

@implementation LKVideoPlayerController

- (instancetype)initWithURL:(NSString *)url {
    self = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.playerFatherView];
    [self.view addSubview:self.closeButton];
    LKPlayerModel *model = [[LKPlayerModel alloc] init];
    model.videoURL = [NSURL URLWithString:self.url];
    LKVideoPlayer *player = [LKVideoPlayer videoPlayerWithView:self.playerFatherView delegate:self playerModel:model];
    self.player = player;
    
    [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.mas_equalTo(0);
       make.leading.trailing.mas_equalTo(0);
       make.bottom.mas_equalTo(0);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(20);
        make.width.height.mas_equalTo(44);
    }];
    [self.closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)closeButtonAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    // pop回来时候是否自动播放
    if (self.player && self.isPlaying) {
        self.isPlaying = NO;
        [self.player playVideo];
    }
    LKBrightnessViewShared.isStartPlay = self.isStartPlay;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    if (self.player && !self.player.isPauseByUser) {    // push出下一级页面时候暂停
        self.isPlaying = YES;
        [self.player pauseVideo];
    }
    
    LKBrightnessViewShared.isStartPlay = NO;
}


- (void)dealloc {
    [self.player destroyVideo];
}

#pragma mark - delegate

/** 控制层封面点击事件的回调 */
- (void)controlViewTapAction {
    if (_player) {
        [self.player autoPlayTheVideo];
        self.isStartPlay = YES;
    }
}

//- (void)portraitFullScreenButtonClick {
//    [self setSupportedOrientation:UIInterfaceOrientationMaskLandscape defaultOrientation:UIInterfaceOrientationLandscapeLeft];
//    self.navigationBar.hidden = YES;
//    [self.view.superview bringSubviewToFront:self.view];
//}
//
//- (void)landScapeExitFullScreenButtonClick {
//    [self setSupportedOrientation:UIInterfaceOrientationMaskPortrait defaultOrientation:UIInterfaceOrientationPortrait];
//    self.navigationBar.hidden = NO;
//}

#pragma mark - getter

- (UIView *)playerFatherView {
    if (!_playerFatherView) {
        _playerFatherView = [[UIView alloc] init];
    }
    return _playerFatherView;
}

- (LKPlayerModel *)playerModel {
    if (!_playerModel) {
        _playerModel = [[LKPlayerModel alloc] init];
    }
    return _playerModel;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[LKVideoPlayerImage imageNamed:@"btn_close"] forState:UIControlStateNormal];
        _closeButton = button;
    }
    return _closeButton;
}

@end
