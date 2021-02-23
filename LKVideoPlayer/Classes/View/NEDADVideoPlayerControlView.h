//
//  NEDADVideoPlayerControlView.h
//  NEDADVideoPlayer
//
//  Created by Allen Gao on 2021/2/20.
//

#import <UIKit/UIKit.h>
#import "NEDADVideoControlView.h"
#import "NEDADVideoImageCoverView.h"
#import "NEDADVideoLoadingView.h"
#import "NEDADVideoProgressView.h"
#import "NEDADVideoPlayerModel.h"
#import "NEDADVideoLockToolView.h"
@class NEDADVideoStatusModel;
@class NEDADVideoPlayerControlView;


@protocol LKPlayerControlViewDelagate <NSObject>
@optional
/** 加载失败按钮被点击 */
- (void)failButtonClick;
/** 重播按钮被点击 */
- (void)repeatButtonClick;
/** 关闭播放记录视图被点击 */
//- (void)closeWatchrRecordButtonClick;
/** 跳转播放按钮被点击 */
- (void)jumpPlayButtonClick:(NSInteger)viewTime;

- (void)controlViewDidClickUnlock:(NEDADVideoPlayerControlView *)controlView;

@end

@interface NEDADVideoPlayerControlView : UIView
+ (instancetype)playerControlViewWithStatusModel:(NEDADVideoStatusModel *)playerStatusModel;
@property (nonatomic, weak) id<LKPlayerControlViewDelagate> delegate;
/** 是否显示了控制层 */
@property (nonatomic, assign, getter=isShowing, readonly) BOOL showing;

/** 竖屏控制层的View */
@property (nonatomic, strong) NEDADVideoControlView *controlView;

@property (nonatomic, strong) NEDADVideoProgressView *progressView;

@property (nonatomic, strong) NEDADVideoLockToolView *lockToolView;
/** 上次播放至xx秒(默认0) */
@property (nonatomic, assign) NSInteger viewTime;

/** 重置controlView */
- (void)playerResetControlView;
/** 开始准备播放 */
- (void)startReadyToPlay;

/** 显示状态栏 */
- (void)showStatusBar;
/** 显示控制层 */
- (void)showControl;
/** 隐藏控制层 */
- (void)hideControl;
/** 强行设置是否显示了控制层 */
- (void)setIsShowing:(BOOL)showing;
/** 取消延时隐藏controlView的方法 */
- (void)playerCancelAutoFadeOutControlView;
/** 延迟隐藏控制层 */
- (void)autoFadeOutControlView;


/** 显示观看记录层 */
- (void)showWatchrRecordView:(NSInteger)viewTime;
/** 隐藏观看记录层 */
- (void)hideWatchrRecordView;
/** 显示快进视图 */
- (void)showFastView:(NSInteger)draggedTime totalTime:(NSInteger)totalTime isForward:(BOOL)forawrd;
/** 隐藏快进视图 */
- (void)hideFastView;


/** 准备开始播放, 隐藏loading */
- (void)readyToPlay;
/** 加载失败, 显示加载失败按钮 */
- (void)loadFailed;
/** 开始loading */
- (void)loading;
/** 播放完了, 显示重播按钮 */
- (void)playDidEnd;


/**
 *  播放完成时隐藏控制层
 */
- (void)playEndHideControlView;

@end
