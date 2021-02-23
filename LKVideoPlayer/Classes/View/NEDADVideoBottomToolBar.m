//
//  NEDADBottomToolBar.m
//  LKVideoPlayer
//
//  Created by Allen Gao on 2021/2/20.
//

#import "NEDADVideoBottomToolBar.h"
#import "NEDADVideoPlayerImage.h"
@import Masonry;
@import NEDMacros;

@interface NEDADVideoBottomToolBar ()

@property (nonatomic, strong) UISlider *videoSlider;
/** 缓冲进度条 */
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *currentTimeLabel;
@property (nonatomic, strong) UILabel *totalTimeLabel;
/** 刷新按钮 */
@property (nonatomic, strong) UIButton *refreshButton;
/** 全屏按钮 */
@property (nonatomic, strong) UIButton *fullScreenBtn;

@property (nonatomic, assign) double durationTime;

@end

@implementation NEDADVideoBottomToolBar

- (instancetype)init {
    self = [super init];
    if (self) {
        [self __setupSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self __setupSubviews];
    }
    return self;
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

// !!!: 将秒数时间转换成mm:ss
- (NSString *)convertTimeSecond:(NSInteger)second {
    NSInteger durMin = second / 60; // 秒
    NSInteger durSec = second % 60; // 分钟
    NSString *timeString = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
    return timeString;
}

- (void)__setupSubviews {
    self.backgroundColor = UIAlphaColorFromRGB(0x000000, 0.3);
    [self addSubview:self.currentTimeLabel];
    [self addSubview:self.progressView];
    [self addSubview:self.videoSlider];
    [self addSubview:self.totalTimeLabel];
    [self addSubview:self.fullScreenBtn];
    [self addSubview:self.refreshButton];
    
    CGFloat margin = 9; // label左右的间距
    
    [self.refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(28);
        make.trailing.mas_equalTo(-10);
        make.centerY.equalTo(self.currentTimeLabel.mas_centerY);
    }];
    
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.fullScreenBtn.mas_leading).offset(-4);
        make.centerY.equalTo(self.currentTimeLabel.mas_centerY);
        make.width.mas_equalTo(48);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(margin);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-margin);
        make.centerY.equalTo(self.currentTimeLabel.mas_centerY);
    }];
    
    [self.videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.centerY.equalTo(self.progressView);
//        make.height.mas_equalTo(30);
    }];
    
    [self.fullScreenBtn addTarget:self action:@selector(fullScreenButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];

    UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSliderAction:)];
    [self.videoSlider addGestureRecognizer:sliderTap];

    // slider开始滑动事件
    [self.videoSlider addTarget:self action:@selector(progressSliderTouchBeganAction:) forControlEvents:UIControlEventTouchDown];
    // slider滑动中事件
    [self.videoSlider addTarget:self action:@selector(progressSliderValueChangedAction:) forControlEvents:UIControlEventValueChanged];
    // slider结束滑动事件
    [self.videoSlider addTarget:self action:@selector(progressSliderTouchEndedAction:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
}


- (void)progressSliderTouchBeganAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(bottomToolBarDidBeginDrag:)]) {
        [self.delegate bottomToolBarDidBeginDrag:self];
    }
}

- (void)progressSliderTouchEndedAction:(UISlider *)sender {
    if ([self.delegate respondsToSelector:@selector(bottomToolBar:didEndDragAtProgress:)]) {
        [self.delegate bottomToolBar:self didEndDragAtProgress:sender.value];
    }
}

- (void)fullScreenButtonClickAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(bottomToolBarDidSelectFullScreen:)]) {
        [self.delegate bottomToolBarDidSelectFullScreen:self];
    }
}

- (void)replayAction {
    if ([self.delegate respondsToSelector:@selector(bottomToolBarDidSelectReplay:)]) {
        [self.delegate bottomToolBarDidSelectReplay:self];
    }
}

- (void)tapSliderAction:(UITapGestureRecognizer *)tap {
    if ([tap.view isKindOfClass:[UISlider class]] && [self.delegate respondsToSelector:@selector(bottomToolBar:didSelectProgress:)]) {
        UISlider *slider = (UISlider *)tap.view;
        CGPoint point = [tap locationInView:slider];
        CGFloat length = slider.frame.size.width;
        // 视频跳转的value
        CGFloat tapValue = point.x / length;
        [self.delegate bottomToolBar:self didSelectProgress:tapValue];
    }
}

- (void)progressSliderValueChangedAction:(UISlider *)sender {
    // 拖拽过程中修改playTime
    [self syncplayTime:(sender.value * self.durationTime)];
}

- (void)showRefreshButton:(BOOL)showed {
    self.refreshButton.hidden = !showed;
    UIView *currentTimeLabelLeftRelativeView = nil;
    CGFloat relativeMargin = 0;
    if (showed) {
        currentTimeLabelLeftRelativeView = self.refreshButton;
        relativeMargin = 38;
    } else {
        currentTimeLabelLeftRelativeView = self;
        relativeMargin = 16;
    }
    
    [self.currentTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(currentTimeLabelLeftRelativeView).offset(relativeMargin);
        make.centerY.mas_equalTo(self);
    }];
}

- (void)reset {
    self.videoSlider.value           = 0;
    self.progressView.progress       = 0;
    self.currentTimeLabel.text       = @"00:00";
    self.totalTimeLabel.text         = @"00:00";
    self.backgroundColor             = [UIColor clearColor];
}


- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.textColor = UIColorFromRGB(0xffffff);
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
        _videoSlider.minimumTrackTintColor =  [UIColor whiteColor];;
        _videoSlider.maximumTrackTintColor = [UIColor colorWithWhite:1 alpha:0.4];
        _videoSlider.tintColor = [UIColor whiteColor];
        [_videoSlider setThumbImage:[NEDADVideoPlayerImage imageNamed:@"icon_advideo_slider_thumb"] forState:UIControlStateNormal];
    }
    return _videoSlider;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progressTintColor =  UIColorFromRGB(0xefefef);
        _progressView.trackTintColor =UIColorFromRGB(0xa5a5a5);
        _progressView.tintColor =UIColorFromRGB(0x3143ae);
        _progressView.hidden = YES;
    }
    return _progressView;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.textColor = UIColorFromRGB(0xffffff);
        _totalTimeLabel.font = [UIFont systemFontOfSize:14.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        _totalTimeLabel.text = @"00:00";
    }
    return _totalTimeLabel;
}

- (UIButton *)fullScreenBtn {
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:[NEDADVideoPlayerImage imageNamed:@"icon_advideo_fullscreen"] forState:UIControlStateNormal];
        [_fullScreenBtn setImage:[NEDADVideoPlayerImage imageNamed:@"icon_advideo_exit_fullscreen"] forState:UIControlStateSelected];
    }
    return _fullScreenBtn;
}

- (UIButton *)refreshButton {
    if (!_refreshButton) {
        _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshButton setImage:[NEDADVideoPlayerImage imageNamed:@"icon_advideo_refresh"] forState:UIControlStateNormal];
        _refreshButton.hidden = YES;
        [_refreshButton addTarget:self action:@selector(replayAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshButton;
}


@end
