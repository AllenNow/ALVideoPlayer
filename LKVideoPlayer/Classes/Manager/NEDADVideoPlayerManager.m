//
//  NEDADVideoPlayerManager.m
//  NEDADVideoPlayer
//
//  Created by Allen Gao on 2021/2/20.
//

#import "NEDADVideoPlayerManager.h"
#import <AVFoundation/AVFoundation.h>
#import "NEDADVideoStatusModel.h"
#import "NEDADVideoPlayerView.h"
@import IJKMediaFramework;

@interface NEDADVideoPlayerManager ()
@property (nonatomic, weak) id<LKPlayerManagerDelegate> delegate;
/** 视频/直播 播放器 */
@property (nonatomic, strong) IJKFFMoviePlayerController *player;
/** 获取当前状态 */
@property (nonatomic, assign) LKPlayerState state;
/** 定时器 */
@property (nonatomic, weak) NSTimer *timer;
/** 播放器的参数模型 */
@property (nonatomic, strong) NEDADVideoStatusModel *playerStatusModel;
/** 声音滑杆 */
@property (nonatomic, strong) UISlider *volumeViewSlider;

/** 是否初始化播放过 */
@property (nonatomic, assign, getter=isInitReadyToPlay) BOOL initReadyToPlay;
@end

@implementation NEDADVideoPlayerManager

- (void)updateManagerDelegate:(id <LKPlayerManagerDelegate>)delegate playerStatusModel:(NEDADVideoStatusModel *)playerStatusModel {
    self.delegate = delegate;
    self.playerStatusModel = playerStatusModel;
}

+ (instancetype)manager {
    static NEDADVideoPlayerManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
    [self removeMovieNotificationObservers];
    [self removeBackgroundNotificationObservers];
}

/**
 根据视频url初始化player

 @param urlString 视频连接
 */
- (void)initPlayerWithUrl:(NSString *)urlString {
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL: [NSURL URLWithString:urlString] withOptions:options];
    [self configureVolume];
    [self addPlayerNotificationObservers];
    [self addBackgroundNotificationObservers];
    
    self.player.shouldAutoplay = YES;
    [self.player setScalingMode:IJKMPMovieScalingModeAspectFit];
    self->_playerLayerView = self.player.view;
    [self.player prepareToPlay];
    
    self.playerStatusModel.autoPlay = YES;
    self.initReadyToPlay = NO;
    self.playerStatusModel.pauseByUser = NO;
}


#pragma mark - 应用进入后台
- (void)addBackgroundNotificationObservers {
    // app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    // app进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayGround) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)removeBackgroundNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)appWillEnterBackground {
    self.playerStatusModel.didEnterBackground = YES;
    [self.player pause];
    self.state = LKPlayerStatePause;
}

- (void)appDidEnterPlayGround {
    self.playerStatusModel.didEnterBackground = NO;
    if (!self.playerStatusModel.isPauseByUser) {
        self.state = LKPlayerStatePlaying;
        self.playerStatusModel.pauseByUser = NO;
        [self play];
    }
}

#pragma mark - getter

- (double)duration {
    return self.player.duration;
}

- (double)currentTime {
    return self.player.currentPlaybackTime;
}

#pragma mark - setter
- (void)setState:(LKPlayerState)state {
    _state = state;
    
    if ([self.delegate respondsToSelector:@selector(changePlayerState:)]) {
        [self.delegate changePlayerState:state];
    }
}

#pragma mark - 更新方法
- (void)update {
    double playProgress = self.player.currentPlaybackTime / self.player.duration;
    [self.delegate changePlayProgress:playProgress second:self.player.currentPlaybackTime];
    
    double loadProgress = self.player.playableDuration / self.player.duration;
    
    [self.delegate changeLoadProgress:loadProgress second:self.player.playableDuration];
}

#pragma mark-加载状态改变
/**
 视频加载状态改变了
 IJKMPMovieLoadStateUnknown == 0
 IJKMPMovieLoadStatePlayable == 1
 IJKMPMovieLoadStatePlaythroughOK == 2
 IJKMPMovieLoadStateStalled == 4
 */
- (void)loadStateDidChange:(NSNotification*)notification {
    IJKMPMovieLoadState loadState = self.player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        // 加载完成，即将播放，停止加载的动画，并将其移除
        NSLog(@"加载完成, 自动播放了 LoadStateDidChange: IJKMovieLoadStatePlayThroughOK: %d\n",(int)loadState);
        
        self.state = LKPlayerStateReadyToPlay;
        if (!self.isInitReadyToPlay) {
            self.initReadyToPlay = YES;
            if ([self.delegate respondsToSelector:@selector(playerReadyToPlay)]) {
                [self.delegate playerReadyToPlay];
            }
            
            if (self.seekTime) {
                self.player.currentPlaybackTime = self.seekTime;
                self.seekTime = 0; // 滞空, 防止下次播放出错
                [self.player play];
            }
        }
    }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        // 可能由于网速不好等因素导致了暂停，重新添加加载的动画
        
        NSLog(@"自动暂停了，loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
        self.state = LKPlayerStateBuffering;
        // 当缓冲好的时候可能达到继续播放时
        [self.delegate didBuffer:self];
        
    } else if ((loadState & IJKMPMovieLoadStatePlayable) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStatePlayable: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: %d\n", (int)loadState);
    }
}

#pragma mark - 播放状态改变
- (void)moviePlayBackFinish:(NSNotification*)notification {
    int reason =[[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: 播放完毕: %d\n", reason);
            
            self.state = LKPlayerStateStoped;
            
            if (!self.playerStatusModel.isDragged) { // 如果不是拖拽中，直接结束播放
                self.playerStatusModel.playDidEnd = YES;
            }
            
            
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: 用户退出播放: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: 播放出现错误: %d\n", reason);
            
            self.state = LKPlayerStateFailed;
            
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

// 准备开始播放了
- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    NSLog(@"mediaIsPrepareToPlayDidChange\n");
}

// 播放状态改变
- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    
    if (self.player.playbackState == IJKMPMoviePlaybackStatePlaying) {
        //视频开始播放的时候开启计时器
        if (!self.timer) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(update) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
        
    }
    
    switch (_player.playbackState) {
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            // 这里的回调也会来多次(一次播放完成, 会回调三次), 所以, 这里不设置
            _state = LKPlayerStateStoped;
            
            break;
            
        case IJKMPMoviePlaybackStatePlaying:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            _state = LKPlayerStatePlaying;
            
            break;
            
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            _state = LKPlayerStatePause;
            
            break;
            
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
            
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}


#pragma mark-观察视频播放状态
/**
 准备播放             IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification;
 尺寸改变发出的通知     IJKMPMoviePlayerScalingModeDidChangeNotification;
 播放完成或者用户退出   IJKMPMoviePlayerPlaybackDidFinishNotification;
 播放完成或者用户退出的原因（key） IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey; // NSNumber (IJKMPMovieFinishReason)
 播放状态改变了        IJKMPMoviePlayerPlaybackStateDidChangeNotification;
 加载状态改变了        IJKMPMoviePlayerLoadStateDidChangeNotification;
 目前不知道这个代表啥          IJKMPMoviePlayerIsAirPlayVideoActiveDidChangeNotification;
 **/
- (void)addPlayerNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
    
}

- (void)removeMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:_player];
    
}

#pragma mark - Public method
- (void)play {
    if (self.state == LKPlayerStateReadyToPlay || self.state == LKPlayerStatePause || self.state == LKPlayerStateBuffering) {
        [self.player play];
        self.playerStatusModel.pauseByUser = NO;
        if (self.player.playbackRate > 0) {
            self.state = LKPlayerStatePlaying;
        }
    }
}

- (void)rePlay {
    self.initReadyToPlay = NO;
    [self.player prepareToPlay];
    [self.player play];
    
    self.playerStatusModel.playDidEnd = NO;
}

//暂停播放
- (void)pause {
    if (self.state == LKPlayerStatePlaying || self.state == LKPlayerStateBuffering) {
        [self.player pause];
        self.playerStatusModel.pauseByUser = YES;
        self.state = LKPlayerStatePause;
    }
}

- (void)stop {
    [self.player setPlaybackRate:0.0];
    [self.player shutdown];
    
    [self removeMovieNotificationObservers];
    [self removeBackgroundNotificationObservers];
    [self.timer invalidate];
    self.timer = nil;
    
    UIView *superView = self.playerLayerView.superview;
    if ([superView isKindOfClass:[NEDADVideoPlayerView class]]) {
        ((NEDADVideoPlayerView *)superView).coverControlView.hidden = NO;
    }
    [self.playerLayerView removeFromSuperview];
    _playerLayerView = nil;
    self.player = nil;
    self.initReadyToPlay = NO;
}

- (void)seekToTime:(NSInteger)dragedSeconds completionHandler:(void (^)(void))completionHandler {
    
    [self.player pause];
    
    
    // 只要快进, 那么就不是被用户暂停
    self.playerStatusModel.pauseByUser = NO;
    
    
    self.player.currentPlaybackTime = dragedSeconds;
    // 视频跳转回调
    if (completionHandler) { completionHandler(); }
    
    [self.player play];
}

/**
 *  改变音量
 */
- (void)changeVolume:(CGFloat)value {
    self.volumeViewSlider.value -= value / 10000;
}

#pragma mark - 系统音量相关
/**
 *  获取系统音量
 */
- (void)configureVolume {
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    _volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    
    // 使用这个category的应用不会随着手机静音键打开而静音，可在手机静音下播放声音
    NSError *setCategoryError = nil;
    BOOL success = [[AVAudioSession sharedInstance]
                    setCategory: AVAudioSessionCategoryPlayback
                    error: &setCategoryError];
    
    if (!success) { /* handle the error in setCategoryError */ }
    
    // 监听耳机插入和拔掉通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:nil];
}

/**
 *  耳机插入、拔出事件
 */
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (routeChangeReason) {
            
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            // 耳机插入
            break;
            
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        {
            // 耳机拔掉
            // 拔掉耳机继续播放
            [self play];
        }
            break;
            
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}



@end
