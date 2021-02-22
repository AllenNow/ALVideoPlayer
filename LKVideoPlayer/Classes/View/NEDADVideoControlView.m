//
//  NEDADVideoPortraitControlView.m
//  NEDADVideoPlayer
//
//  Created by Allen Gao on 2021/2/20.
//

#import "NEDADVideoControlView.h"
@import Masonry;
@import NEDMacros;
#import "NEDADVideoPlayerImage.h"
#import "NEDADVideoBottomToolBar.h"
#import "NEDADVideoPlayerImage.h"
#import "NEDADVideoTitleBar.h"

@interface NEDADVideoControlView ()<NEDADVideoBottomToolBarDelegate>
/** 播放或暂停按钮 */
@property (nonatomic, strong) UIButton *playOrPauseBtn;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) NEDADVideoTitleBar *titleBar;
@property (nonatomic, strong) NEDADVideoBottomToolBar *bottomToolBar;

@end

@implementation NEDADVideoControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 添加子控件
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.titleBar];
        [self addSubview:self.bottomToolBar];
        [self addSubview:self.playOrPauseBtn];
        
        [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        [self.titleBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(88);
        }];
        
        // 设置子控件的响应事件
        [self.bottomToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
            make.height.mas_equalTo(39);
        }];
        
        [self.playOrPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
        }];
    }
    return self;
}

#pragma mark - delegate

- (void)playPauseButtonClickAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(controlView:didChangePlayAction:)]) {
        [self.delegate controlView:self didChangePlayAction:sender.selected];
    }
}

/** 全屏按钮被点击 */
- (void)bottomToolBarDidSelectFullScreen:(UIView *)bottomToolBar {
    if ([self.delegate respondsToSelector:@selector(controlViewDidSelectFullScreen:)]) {
        [self.delegate controlViewDidSelectFullScreen:self];
    }
}

- (void)bottomToolBarDidSelectReplay:(UIView *)bottomToolBar {
    if ([self.delegate respondsToSelector:@selector(controlView:didChangePlayAction:)]) {
        [self.delegate controlView:self didChangePlayAction:YES];
    }
}

/** 进度条点击某个进度 */
- (void)bottomToolBar:(UIView *)bottomToolBar didSelectProgress:(CGFloat)progress {
    if ([self.delegate respondsToSelector:@selector(controlView:didSelectProgress:)]) {
        [self.delegate controlView:self didSelectProgress:progress];
    }
}

/** 进度条开始拖动 */
- (void)bottomToolBarDidBeginDrag:(UIView *)bottomToolBar {
    if ([self.delegate respondsToSelector:@selector(controlViewDidBeginDrag:)]) {
        [self.delegate controlViewDidBeginDrag:self];
    }
}

/** 进度结束拖动，并返回最后的值 */
- (void)bottomToolBar:(UIView *)bottomToolBar didEndDragAtProgress:(CGFloat)progress {
    if ([self.delegate respondsToSelector:@selector(controlView:didSelectProgress:)]) {
        [self.delegate controlView:self didSelectProgress:progress];
    }
}

#pragma mark - Public method
/** 重置ControlView */
- (void)playerResetControlView {
    [self.bottomToolBar reset];
    self.playOrPauseBtn.selected = YES;
    self.bottomToolBar.alpha = 1;
}

- (void)playEndHideView:(BOOL)playeEnd {
    [self.bottomToolBar showRefreshButton:YES];
    self.playOrPauseBtn.selected = NO;
}

- (void)syncplayPauseButton:(BOOL)isPlay {
    if (isPlay) {
        self.playOrPauseBtn.selected = YES;
    } else {
        self.playOrPauseBtn.selected = NO;
    }
}

- (void)syncbufferProgress:(double)progress {
    [self.bottomToolBar syncbufferProgress:progress];
}

- (void)syncplayProgress:(double)progress {
    [self.bottomToolBar syncplayProgress:progress];
}

- (void)syncplayTime:(NSInteger)time {
    [self.bottomToolBar syncplayTime:time];
}

- (void)syncDurationTime:(NSInteger)time {
    [self.bottomToolBar syncDurationTime:time];
    if (time < 0) {
        return;
    }
}

- (void)showRefreshButton:(BOOL)showed {
    [self.bottomToolBar showRefreshButton:showed];
}

#pragma mark - Other
// !!!: 将秒数时间转换成mm:ss
- (NSString *)convertTimeSecond:(NSInteger)second {
    NSInteger durMin = second / 60; // 秒
    NSInteger durSec = second % 60; // 分钟
    NSString *timeString = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
    return timeString;
}

#pragma mark - getter

- (UIButton *)playOrPauseBtn {
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playOrPauseBtn setImage:[NEDADVideoPlayerImage imageNamed:@"icon_advideo_play"] forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:[NEDADVideoPlayerImage imageNamed:@"icon_advideo_pause"] forState:UIControlStateSelected];
        [_playOrPauseBtn addTarget:self action:@selector(playPauseButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playOrPauseBtn;
}

- (NEDADVideoBottomToolBar *)bottomToolBar {
    if (!_bottomToolBar) {
        _bottomToolBar = [[NEDADVideoBottomToolBar alloc] init];
        _bottomToolBar.delegate = self;
    }
    return _bottomToolBar;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        UIImage *image = [NEDADVideoPlayerImage imageNamed:@"bg_advideo_controlview"];
        image = [image stretchableImageWithLeftCapWidth:1 topCapHeight:0];
        _backgroundImageView = [[UIImageView alloc] initWithImage:image];
    }
    return _backgroundImageView;
}

- (NEDADVideoTitleBar *)titleBar {
    if (!_titleBar) {
        _titleBar = [[NEDADVideoTitleBar alloc] init];
    }
    return _titleBar;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    
}

@end
