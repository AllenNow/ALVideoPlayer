//
//  NEDADVideoPlayer.h
//  NEDADVideoPlayer
//
//  Created by Allen Gao on 2021/2/20.
//

#import <UIKit/UIKit.h>
#import "NEDADVideoPlayerModel.h"
#import "NEDADVideoPlayerManager.h"

@class NEDADVideoPlayer;

@protocol NEDADVideoPlayerDelegate <NSObject>

@optional
/** 控制层封面点击事件的回调 */
- (void)controlViewTapAction;
/** 横屏下(编辑弹幕页面)发送弹幕按钮事件 */

- (void)playerDidEndAction;
/** 快进/快退的回掉(埋点用) */
- (void)playerSeekTimeAction;

/** 全屏按钮被点击 */
- (void)playerEnterFullScreen:(NEDADVideoPlayer *)player;

/** 退出全屏按钮被点击 */
- (void)playerExitFullScreen:(NEDADVideoPlayer *)player;

/// 视频需要打开广告
/// @param player 播放器
- (void)playerWillOpenAD:(NEDADVideoPlayer *)player;

- (void)playerDidClickCoverPlay:(NEDADVideoPlayer *)player;


@end

@interface NEDADVideoPlayer : NSObject
/** 是否被用户暂停 */
@property (nonatomic, assign, readonly) BOOL isPauseByUser;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) UIView *playerSuperView;
/** 获取当前状态 */
@property (nonatomic, assign) LKPlayerState state;

/**
 创建视频播放视图类
 @view   在正常屏幕下的视图位置
 @viewController 为当前播放视频的控制器
 */
+ (instancetype)videoPlayerWithView:(UIView *)view
                           delegate:(id<NEDADVideoPlayerDelegate>)delegate
                        playerModel:(NEDADVideoPlayerModel *)playerModel;

/**
 *  在当前页面，设置新的视频时候调用此方法
 */
- (void)resetToPlayNewVideo:(NEDADVideoPlayerModel *)playerModel; 


/** 自动播放，默认不自动播放 */
- (void)autoPlayTheVideo;

/** 播放视频 */
- (void)playVideo;

/** 解锁视频 */
- (void)unLockVideo;

/** 暂停视频播放 */
- (void)pauseVideo;

/** 停止视频播放 */
- (void)stopVideo;

/** 销毁视频 */
- (void)destroyVideo;
@end
