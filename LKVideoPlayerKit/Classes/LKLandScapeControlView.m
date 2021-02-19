//
//  LKLandScapeControlView.m
//  拉面视频Demo
//
//  Created by 李小南 on 16/9/1.
//  Copyright © 2016年 lamiantv. All rights reserved.
//  

#import "LKLandScapeControlView.h"
@import Masonry;
#import "UIColor+Hex.h"
#import "LKVideoPlayerImage.h"

@interface LKLandScapeControlView ()
/** 顶部工具栏 */
@property (nonatomic, strong) UIView *topToolView;
/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 底部工具栏 */
@property (nonatomic, strong) UIView *bottomToolView;
/** 播放或暂停按钮(小) */
@property (nonatomic, strong) UIButton *playOrPauseSmallBtn;
/** 播放的当前时间label */
@property (nonatomic, strong) UILabel *currentTimeLabel;
/** 滑杆 */
@property (nonatomic, strong) UISlider *videoSlider;
/** 缓冲进度条 */
@property (nonatomic, strong) UIProgressView *progressView;
/** 视频总时间 */
@property (nonatomic, strong) UILabel *totalTimeLabel;
/** 退出全屏按钮 */
@property (nonatomic, strong) UIButton *exitFullScreenBtn;

/** 状态栏的背景View */
@property (nonatomic, strong) UIView *statusBackgrundViewView;

@property (nonatomic, assign) double durationTime;
@end

@implementation LKLandScapeControlView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 添加子控件
        [self addSubview:self.topToolView];
        [self.topToolView addSubview:self.titleLabel];
        [self addSubview:self.bottomToolView];
        [self.bottomToolView addSubview:self.playOrPauseSmallBtn];
        [self.bottomToolView addSubview:self.currentTimeLabel];
        [self.bottomToolView addSubview:self.progressView];
        [self.bottomToolView addSubview:self.videoSlider];
        [self.bottomToolView addSubview:self.totalTimeLabel];
        [self.bottomToolView addSubview:self.exitFullScreenBtn];
        [self addSubview:self.statusBackgrundViewView];
        
        // 设置子控件的响应事件
        [self makeSubViewsAction];
        
        // 添加子控件的约束
        [self makeSubViewsConstraints];
        
    }
    return self;
}

- (void)makeSubViewsAction {
    [self.playOrPauseSmallBtn addTarget:self action:@selector(playPauseButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.exitFullScreenBtn addTarget:self action:@selector(exitFullScreenButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSliderAction:)];
    [self.videoSlider addGestureRecognizer:sliderTap];
    
    // slider开始滑动事件
    [self.videoSlider addTarget:self action:@selector(progressSliderTouchBeganAction:) forControlEvents:UIControlEventTouchDown];
    // slider滑动中事件
    [self.videoSlider addTarget:self action:@selector(progressSliderValueChangedAction:) forControlEvents:UIControlEventValueChanged];
    // slider结束滑动事件
    [self.videoSlider addTarget:self action:@selector(progressSliderTouchEndedAction:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
}

#pragma mark - action
- (void)playPauseButtonClickAction:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(landScapePlayPauseButtonClick:)]){
        [self.delegate landScapePlayPauseButtonClick:sender.selected];
    }
}

- (void)sendBarrageButtonClickAction:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(landScapeSendBarrageButtonClick)]){
        [self.delegate landScapeSendBarrageButtonClick];
    }
}

- (void)openOrCloseBarrageButtonClickAction:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(landScapeOpenOrCloseBarrageButtonClick:)]){
        [self.delegate landScapeOpenOrCloseBarrageButtonClick:sender.selected];
    }
}

- (void)exitFullScreenButtonClickAction:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(landScapeExitFullScreenButtonClick)]){
        [self.delegate landScapeExitFullScreenButtonClick];
    }
}

- (void)progressSliderTouchBeganAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(landScapeProgressSliderBeginDrag)]) {
        [self.delegate landScapeProgressSliderBeginDrag];
    }
}

- (void)progressSliderValueChangedAction:(UISlider *)sender {
    // 拖拽过程中修改playTime
    [self syncplayTime:(sender.value * self.durationTime)];
}

- (void)progressSliderTouchEndedAction:(UISlider *)sender {
    if ([self.delegate respondsToSelector:@selector(landScapeProgressSliderEndDrag:)]) {
        [self.delegate landScapeProgressSliderEndDrag:sender.value];
    }
}

- (void)tapSliderAction:(UITapGestureRecognizer *)tap
{
    if ([tap.view isKindOfClass:[UISlider class]] && [self.delegate respondsToSelector:@selector(landScapeProgressSliderTapAction:)]) {
        UISlider *slider = (UISlider *)tap.view;
        CGPoint point = [tap locationInView:slider];
        CGFloat length = slider.frame.size.width;
        // 视频跳转的value
        CGFloat tapValue = point.x / length;
        
        [self.delegate landScapeProgressSliderTapAction:tapValue];
    }
}

#pragma mark - 添加子控件的约束
- (void)makeSubViewsConstraints {
    
    CGFloat margin = 9; // label左右的间距
    
    [self.topToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top).offset(20);
        make.height.mas_equalTo(38); // ?
    }];
    
    [self.bottomToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(38);
    }];
    
    [self.playOrPauseSmallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(28);
        make.leading.equalTo(self.bottomToolView.mas_leading).offset(10);
        make.centerY.equalTo(self.bottomToolView.mas_centerY);
    }];
    
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.playOrPauseSmallBtn.mas_trailing).offset(4);
        make.centerY.equalTo(self.playOrPauseSmallBtn.mas_centerY);
        make.width.mas_equalTo(48);
    }];
    
    [self.exitFullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(32.5);
        make.trailing.equalTo(self.bottomToolView.mas_trailing).offset(-10);
        make.centerY.equalTo(self.playOrPauseSmallBtn.mas_centerY);
    }];
    
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.exitFullScreenBtn.mas_leading).offset(-4);
        make.centerY.equalTo(self.playOrPauseSmallBtn.mas_centerY);
        make.width.mas_equalTo(48);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(margin);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-margin);
        make.centerY.equalTo(self.playOrPauseSmallBtn.mas_centerY);
    }];
    
    [self.videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(margin);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-margin);
        make.centerY.equalTo(self.playOrPauseSmallBtn.mas_centerY).offset(-1);
        make.height.mas_equalTo(30);
    }];

    [self.statusBackgrundViewView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_offset(20);
    }];
}

#pragma mark - Public method
/** 重置ControlView */
- (void)playerResetControlView {
    self.videoSlider.value           = 0;
    self.progressView.progress       = 0;
    self.currentTimeLabel.text       = @"00:00";
    self.totalTimeLabel.text         = @"00:00";
    self.backgroundColor             = [UIColor clearColor];
    self.playOrPauseSmallBtn.selected = YES;
    self.titleLabel.text = @"";
    
    self.topToolView.alpha = 1;
    self.bottomToolView.alpha = 1;
    self.statusBackgrundViewView.alpha = 1;
}

- (void)playEndHideView:(BOOL)playeEnd {
    self.topToolView.alpha = playeEnd;
    self.statusBackgrundViewView.alpha = playeEnd;
    self.bottomToolView.alpha = 0;
}

/** 更新标题 */
- (void)syncTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)syncplayPauseButton:(BOOL)isPlay {
    if (isPlay) {
        self.playOrPauseSmallBtn.selected = YES;
    } else {
        self.playOrPauseSmallBtn.selected = NO;
    }
}

- (void)syncbufferProgress:(double)progress {
    self.progressView.progress = progress;
}

- (void)syncplayProgress:(double)progress {
    self.videoSlider.value = progress;
}

- (void)syncplayTime:(NSInteger)time {
    
    if (time < 0) {
        return;
    }
    NSString *progressTimeString = [self convertTimeSecond:time];
    self.currentTimeLabel.text = progressTimeString;
}

- (void)syncDurationTime:(NSInteger)time {
    
    if (time < 0) {
        return;
    }
    
    self.durationTime = time;
    NSString *durationTimeString = [self convertTimeSecond:time];
    self.totalTimeLabel.text = durationTimeString;
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
- (UIView *)topToolView {
    if (!_topToolView) {
        _topToolView = [[UIView alloc] init];
        
        _topToolView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return _topToolView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
        
        _titleLabel.text = @"从零开始的异世界生活 -- 狗粮已送到";
    }
    return _titleLabel;
}

- (UIView *)bottomToolView {
    if (!_bottomToolView) {
        _bottomToolView = [[UIView alloc] init];
        
        _bottomToolView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return _bottomToolView;
}

- (UIButton *)playOrPauseSmallBtn {
    if (!_playOrPauseSmallBtn) {
        _playOrPauseSmallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playOrPauseSmallBtn setImage:[LKVideoPlayerImage imageNamed:@"play"] forState:UIControlStateNormal];
        [_playOrPauseSmallBtn setImage:[LKVideoPlayerImage imageNamed:@"pause"] forState:UIControlStateSelected];
    }
    return _playOrPauseSmallBtn;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        _currentTimeLabel.font = [UIFont systemFontOfSize:14.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        
        _currentTimeLabel.text = @"00:00";
    }
    return _currentTimeLabel;
}

- (UISlider *)videoSlider {
    if (!_videoSlider) {
        _videoSlider = [[UISlider alloc] init];
        _videoSlider.maximumValue = 1;
        _videoSlider.minimumTrackTintColor = [UIColor colorWithHexString:@"3143ae"];
        _videoSlider.maximumTrackTintColor = [UIColor clearColor];
        [_videoSlider setThumbImage:[LKVideoPlayerImage imageNamed:@"slider_thumb"] forState:UIControlStateNormal];
        
    }
    return _videoSlider;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progressTintColor = [UIColor colorWithHexString:@"efefef"];
        _progressView.trackTintColor = [UIColor colorWithHexString:@"a5a5a5"];
        _progressView.tintColor = [UIColor colorWithHexString:@"3143ae"];
    }
    return _progressView;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        _totalTimeLabel.font = [UIFont systemFontOfSize:14.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        
        _totalTimeLabel.text = @"00:00";
    }
    return _totalTimeLabel;
}

- (UIButton *)exitFullScreenBtn {
    if (!_exitFullScreenBtn) {
        _exitFullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exitFullScreenBtn setImage:[LKVideoPlayerImage imageNamed:@"eixt_full"] forState:UIControlStateNormal];
    }
    return _exitFullScreenBtn;
}

- (UIView *)statusBackgrundViewView {
    if (!_statusBackgrundViewView) {
        _statusBackgrundViewView = [[UIView alloc] init];
        _statusBackgrundViewView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return _statusBackgrundViewView;
}
@end
