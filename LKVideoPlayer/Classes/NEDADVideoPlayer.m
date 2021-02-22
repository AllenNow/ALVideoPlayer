//
//  LKVideoPlayer.m
//  IJK播放器Demo
//
//  Created by Allen on 2017/3/28.
//  Copyright © 2017年 lamiantv. All rights reserved.
//

#import "NEDADVideoPlayer.h"
#import "NEDADVideoPlayerManager.h"
#import "NEDADVideoPlayerView.h"
#import "NEDADVideoStatusModel.h"
#import "NEDADVideoBrightnessView.h"

@interface NEDADVideoPlayer () <
    LKPlayerManagerDelegate,
    LKPlayerControlViewDelagate,
    NEDADVideoControlViewDelegate,
    NEDVideoPlayerViewDelagate,
    NEDCoverControlViewDelegate
>

// 代理
@property (nonatomic, weak) id<NEDADVideoPlayerDelegate> delegate;
// 最底层的父视图
@property (nonatomic, strong) NEDADVideoPlayerView *videoPlayerView;
// AVPlayer 管理
@property (nonatomic, strong) NEDADVideoPlayerManager *playerMgr;
// 播放数据模型
@property (nonatomic, strong) NEDADVideoPlayerModel *playerModel;
/** 播放器的参数模型 */
@property (nonatomic, strong) NEDADVideoStatusModel *playerStatusModel;


/** 用来保存pan手势快进的总时长 */
@property (nonatomic, assign) CGFloat sumTime;
/** 是否被用户暂停 */
@property (nonatomic, assign) BOOL isPauseByUser;

@end

@implementation NEDADVideoPlayer

#pragma mark - public method

+ (instancetype)videoPlayerWithView:(UIView *)view delegate:(id<NEDADVideoPlayerDelegate>)delegate playerModel:(NEDADVideoPlayerModel *)playerModel {
    
    if (view == nil) {
        return nil;
    }
    
    NEDADVideoPlayer *videoPlayer = [[NEDADVideoPlayer alloc] init];
    videoPlayer.delegate = delegate;
    
    // 创建状态模型
    videoPlayer.playerStatusModel = [[NEDADVideoStatusModel alloc] init];
    [videoPlayer.playerStatusModel playerResetStatusModel];
    
    // !!!: 最底层视图创建
    videoPlayer.videoPlayerView = [NEDADVideoPlayerView videoPlayerViewWithSuperView:view delegate:videoPlayer playerStatusModel:videoPlayer.playerStatusModel];
    videoPlayer.videoPlayerView.playerControlView.delegate = videoPlayer;
    videoPlayer.videoPlayerView.playerControlView.controlView.delegate = videoPlayer;
    videoPlayer.videoPlayerView.coverControlView.delegate = videoPlayer;
    
    // !!!: 创建AVPlayer管理
    videoPlayer.playerMgr = [NEDADVideoPlayerManager playerManagerWithDelegate:videoPlayer playerStatusModel:videoPlayer.playerStatusModel];
    videoPlayer.isPauseByUser = YES;
    
    // 设置基本模型 (最后设置)
    videoPlayer.playerModel = playerModel;
    return videoPlayer;
}

// !!!: 销毁视频
- (void)destroyVideo {
    [self.playerMgr stop];
    [self.videoPlayerView removeFromSuperview];
    
    self.playerMgr = nil;
    self.videoPlayerView = nil;
}

- (void)setPlayerModel:(NEDADVideoPlayerModel *)playerModel {
    _playerModel = playerModel;
    
    // 同步一些属性
    [self.videoPlayerView.coverControlView syncCoverImageViewWithURLString:playerModel.placeholderImageURLString placeholderImage:playerModel.placeholderImage];
    self.playerMgr.seekTime = self.playerModel.seekTime;
    self.videoPlayerView.playerControlView.viewTime = self.playerModel.viewTime;
    self.videoPlayerView.playerControlView.controlView.title = self.playerModel.title;
}

/** 自动播放，默认不自动播放 */
- (void)autoPlayTheVideo {
    [self configLKPlayer];
    [self.videoPlayerView.coverControlView removeFromSuperview];
    self.videoPlayerView.loadingView.hidden = NO;
}

// 设置Player相关参数
- (void)configLKPlayer {
    // 销毁之前的视频
    if(self.playerMgr) {
        [self.playerMgr stop];
    }
    
    [self.videoPlayerView.playerControlView loading];
    [self.playerMgr initPlayerWithUrl:self.playerModel.videoURL];
    [self.videoPlayerView setPlayerLayerView:self.playerMgr.playerLayerView];
    self.isPauseByUser = NO;
}

/**
 *  重置player
 */
- (void)resetPlayer {
    // 改为为播放完
    self.playerStatusModel.playDidEnd         = NO;
    self.playerStatusModel.didEnterBackground = NO;
    self.playerStatusModel.autoPlay           = NO;
    
    if (self.playerMgr) {
        [self.playerMgr stop];
    }
    
    [self.videoPlayerView playerResetVideoPlayerView];
}

/**
 *  在当前页面，设置新的视频时候调用此方法
 */
- (void)resetToPlayNewVideo:(NEDADVideoPlayerModel *)playerModel {
    [self resetPlayer];
    self.playerModel = playerModel;
    [self configLKPlayer];
}

- (void)playVideo {
    // 如果已经播放完的情况下点击就重新开始播放， 因状态已经为stoped了
    if (self.playerMgr.state == LKPlayerStateStoped) {
        [self.playerMgr rePlay]; //
    } else {
        [self.playerMgr play];
    }
}

- (void)pauseVideo {
    [self.playerMgr pause];
}

- (void)stopVideo {
    [self.playerMgr stop];
}

#pragma mark - LMAVPlayerManagerDelegate

- (void)changePlayerState:(LKPlayerState)state {
    switch (state) {
        case LKPlayerStateReadyToPlay:{
            
            [self.videoPlayerView.playerControlView readyToPlay];
        }
            break;
        case LKPlayerStatePlaying: {
            [self.videoPlayerView.playerControlView.controlView syncplayPauseButton:YES];
            self.isPauseByUser = NO;
        }
            break;
        case LKPlayerStatePause: {
            [self.videoPlayerView.playerControlView.controlView syncplayPauseButton:NO];
            self.isPauseByUser = YES;
        }
            break;
        case LKPlayerStateStoped: {
            [self.videoPlayerView playDidEnd];
        }
            break;
        case LKPlayerStateBuffering: {
            [self.videoPlayerView.playerControlView loading];
        }
            break;
        case LKPlayerStateFailed: {
            [self.videoPlayerView loadFailed];
            self.videoPlayerView.loadingView.hidden = YES;
            
            [NEDADVideoBrightnessView sharedBrightnessView].isStartPlay = YES;
            [self.videoPlayerView.playerControlView loadFailed];
        }
            break;
        default:
            break;
    }
}

- (void)changeLoadProgress:(double)progress second:(CGFloat)second {
    
    self.videoPlayerView.playerControlView.progressView.cacheProgress = progress;
    [self.videoPlayerView.playerControlView.controlView syncbufferProgress:progress];
    
    // 如果缓冲达到俩秒以上或者缓冲完成则播放，先检测当前视频状态是否为播放
    if (progress == 1.0f ||  second >= [self.playerMgr currentTime] + 2.5) { // 当前播放位置秒数 + 2.5 小于等于 缓冲到的位置秒数
        [self didBuffer:self.playerMgr];
    }
}

- (void)changePlayProgress:(double)progress second:(CGFloat)second {
    if (self.playerStatusModel.isDragged) { // 在拖拽进度条的时候不应去更新进度条的值
        return;
    }
    
    self.videoPlayerView.playerControlView.progressView.playProgress = progress;
    [self.videoPlayerView.playerControlView.controlView syncplayProgress:progress];
    [self.videoPlayerView.playerControlView.controlView syncplayTime:second];
    [self.videoPlayerView.playerControlView.controlView syncDurationTime:self.playerMgr.duration];
}

- (void)didBuffer:(NEDADVideoPlayerManager *)playerMgr { 
    if (self.playerMgr.state == LKPlayerStateBuffering || !self.playerStatusModel.isPauseByUser) {
        [self.playerMgr play];
//        [self.videoPlayerView.playerControlView readyToPlay];
    }
}

/** 播放器准备开始播放时 */
- (void)playerReadyToPlay {
    [self.videoPlayerView startReadyToPlay];
    self.videoPlayerView.loadingView.hidden = YES;
    [NEDADVideoBrightnessView sharedBrightnessView].isStartPlay = YES;
}

#pragma mark - LKPlayerControlViewDelagate
/** 加载失败按钮被点击 */
- (void)failButtonClick {
    [self configLKPlayer];
}

/** 重播按钮被点击 */
- (void)repeatButtonClick {
    [self.playerMgr rePlay];
    
    [self.videoPlayerView repeatPlay];
    
    // 没有播放完
    self.playerStatusModel.playDidEnd = NO;
    
//    if ([self.videoURL.scheme isEqualToString:@"file"]) {
//        self.state = LKPlayerStatePlaying;
//    } else {
//        self.state = LKPlayerStateBuffering;
//    }
}

/** 跳转播放按钮被点击 */
- (void)jumpPlayButtonClick:(NSInteger)viewTime {
    if (!viewTime) {
        return;
    }
    [self.playerMgr seekToTime:viewTime completionHandler:nil];
}

#pragma mark - LKControlViewDelegate

- (void)controlView:(UIView *)controlView didChangePlayAction:(BOOL)isPlaying {
    // 延迟隐藏控制层
    [self.videoPlayerView.playerControlView autoFadeOutControlView];
    
    if (isPlaying) {
        [self.playerMgr pause];
    } else {
        // 如果已经播放完的情况下点击就重新开始播放， 因状态已经为stoped了
        if (self.playerMgr.state == LKPlayerStateStoped) {
            [self.playerMgr rePlay]; //
        } else {
            [self.playerMgr play];
        }
    }
}

- (void)controlViewDidBeginDrag:(UIView *)controlView {
    self.playerStatusModel.dragged = YES;
    [self.videoPlayerView.playerControlView playerCancelAutoFadeOutControlView];
}

- (void)controlView:(UIView *)controlView didEndDragAtProgress:(CGFloat)progress {
    //计算出拖动的当前秒数
    __weak typeof(self) wself = self;
    NSInteger dragedSeconds = floorf(self.playerMgr.duration * progress);
    [self.playerMgr seekToTime:dragedSeconds completionHandler:^(){
        self.playerStatusModel.dragged = NO;
        [wself.playerMgr play];
        // 延迟隐藏控制层
        [self.videoPlayerView.playerControlView autoFadeOutControlView];
    }];
}

- (void)controlViewDidSelectFullScreen:(UIView *)controlView {
    // 延迟隐藏控制层
    [self.videoPlayerView.playerControlView autoFadeOutControlView];
    [self.videoPlayerView shrinkOrFullScreen:YES];
    if ([_delegate respondsToSelector:@selector(portraitFullScreenButtonClick)]) {
        [_delegate portraitFullScreenButtonClick];
    }
}

//计算出拖动的当前秒数
- (void)controlView:(UIView *)controlView didSelectProgress:(CGFloat)progress {
    __weak typeof(self) wself = self;
    NSInteger dragedSeconds = floorf(self.playerMgr.duration * progress);
    [self.playerMgr seekToTime:dragedSeconds completionHandler:^(){
        self.playerStatusModel.dragged = NO;
        [wself.playerMgr play];
        // 延迟隐藏控制层
        [self.videoPlayerView.playerControlView autoFadeOutControlView];
    }];
}

#pragma mark - LKLandScapeControlViewDelegate

/** 播放暂停按钮被点击 */
- (void)landScapePlayPauseButtonClick:(BOOL)isSelected {
    // 延迟隐藏控制层
    [self.videoPlayerView.playerControlView autoFadeOutControlView];
    
    if (isSelected) {
        [self.playerMgr pause];
    } else {
        // 如果已经播放完的情况下点击就重新开始播放， 因状态已经为stoped了
        if (self.playerMgr.state == LKPlayerStateStoped) {
            [self.playerMgr rePlay]; //
        } else {
            [self.playerMgr play];
        }
    }
}

/** 发送弹幕按钮被点击 */
- (void)landScapeSendBarrageButtonClick {
    // 延迟隐藏控制层
    [self.videoPlayerView.playerControlView autoFadeOutControlView];
    
}

/** 打开关闭弹幕按钮被点击 */
- (void)landScapeOpenOrCloseBarrageButtonClick:(BOOL)isSelected {
    // 延迟隐藏控制层
    [self.videoPlayerView.playerControlView autoFadeOutControlView];
}

/** 进度条开始拖动 */
- (void)landScapeProgressSliderBeginDrag {
    self.playerStatusModel.dragged = YES;
    [self.videoPlayerView.playerControlView playerCancelAutoFadeOutControlView];
}

/** 进度结束拖动，并返回最后的值 */
- (void)landScapeProgressSliderEndDrag:(CGFloat)value {
    //计算出拖动的当前秒数
    __weak typeof(self) wself = self;
    NSInteger dragedSeconds = floorf(self.playerMgr.duration * value);
    [self.playerMgr seekToTime:dragedSeconds completionHandler:^(){
        self.playerStatusModel.dragged = NO;
        [wself.playerMgr play];
        
        // 延迟隐藏控制层
        [self.videoPlayerView.playerControlView autoFadeOutControlView];
    }];
}

/** 退出全屏按钮被点击 */
- (void)landScapeExitFullScreenButtonClick {
    // 延迟隐藏控制层
    [self.videoPlayerView.playerControlView autoFadeOutControlView];
    
    [self.videoPlayerView shrinkOrFullScreen:NO];
    if ([_delegate respondsToSelector:@selector(landScapeExitFullScreenButtonClick)]) {
        [_delegate landScapeExitFullScreenButtonClick];
    }
}

/** 进度条tap点击 */
- (void)landScapeProgressSliderTapAction:(CGFloat)value {
    //计算出拖动的当前秒数
    __weak typeof(self) wself = self;
    NSInteger dragedSeconds = floorf(self.playerMgr.duration * value);
    [self.playerMgr seekToTime:dragedSeconds completionHandler:^(){
        self.playerStatusModel.dragged = NO;
        [wself.playerMgr play];
        
        // 延迟隐藏控制层
        [self.videoPlayerView.playerControlView autoFadeOutControlView];
    }];
}

#pragma mark - LKVideoPlayerViewDelagate
/** 双击事件 */
- (void)doubleTapAction {
    if (self.playerStatusModel.isPauseByUser) {
        [self.playerMgr play];
    } else {
        [self.playerMgr pause];
    }
    if (!self.playerStatusModel.isAutoPlay) {
        self.playerStatusModel.autoPlay = YES;
        [self configLKPlayer];
    }
}

/** pan开始水平移动 */
- (void)panHorizontalBeginMoved {
    // 给sumTime初值
    self.sumTime = self.playerMgr.currentTime;
}

/** pan水平移动ing */
- (void)panHorizontalMoving:(CGFloat)value {
    // 每次滑动需要叠加时间
    self.sumTime += value / 200;
    
    // 需要限定sumTime的范围
    CGFloat totalMovieDuration = self.playerMgr.duration;
    if (self.sumTime > totalMovieDuration) { self.sumTime = totalMovieDuration;}
    if (self.sumTime < 0) { self.sumTime = 0; }
    
    BOOL style = false;
    if (value > 0) { style = YES; }
    if (value < 0) { style = NO; }
    if (value == 0) { return; }
    
    self.playerStatusModel.dragged = YES;
    
    // 改变currentLabel值
    CGFloat draggedValue = (CGFloat)self.sumTime/(CGFloat)totalMovieDuration;
    
    [self.videoPlayerView.playerControlView.controlView syncplayProgress:draggedValue];
    [self.videoPlayerView.playerControlView.controlView syncplayTime:self.sumTime];
    
    // 展示快进/快退view
    [self.videoPlayerView.playerControlView showFastView:self.sumTime totalTime:totalMovieDuration isForward:style];
    
}

/** pan结束水平移动 */
- (void)panHorizontalEndMoved {
    // 隐藏快进/快退view
    [self.videoPlayerView.playerControlView hideFastView];
    
    // seekTime
    self.playerStatusModel.pauseByUser = NO;
    [self.playerMgr seekToTime:self.sumTime completionHandler:nil];
    self.sumTime = 0;
    self.playerStatusModel.dragged = NO;
}

/** 音量改变 */
- (void)volumeValueChange:(CGFloat)value {
    [self.playerMgr changeVolume:value];
}

#pragma mark - LKLoadingViewDelegate

#pragma mark - LKCoverControlViewDelegate

/** 封面图片Tap事件 */
- (void)coverControlViewDidClick:(UIView *)controlView {
    [self autoPlayTheVideo];
}

#pragma mark - 对象释放

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self destroyVideo];
}

@end
