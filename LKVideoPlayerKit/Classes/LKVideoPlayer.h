//
//  LKVideoPlayer.h
//  IJK播放器Demo
//
//  Created by 李小南 on 2017/3/28.
//  Copyright © 2017年 lamiantv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKPlayerModel.h"

@class LKVideoPlayer;

@protocol LKVideoPlayerDelegate <NSObject>

@optional
/** 控制层封面点击事件的回调 */
- (void)controlViewTapAction;
/** 横屏下(编辑弹幕页面)发送弹幕按钮事件 */

- (void)playerDidEndAction;
/** 快进/快退的回掉(埋点用) */
- (void)playerSeekTimeAction;

/** 全屏按钮被点击 */
- (void)portraitFullScreenButtonClick;

/** 退出全屏按钮被点击 */
- (void)landScapeExitFullScreenButtonClick;

@end

@interface LKVideoPlayer : NSObject
/** 是否被用户暂停 */
@property (nonatomic, assign, readonly) BOOL          isPauseByUser;

/**
 创建视频播放视图类
 @view   在正常屏幕下的视图位置
 @viewController 为当前播放视频的控制器
 */
+ (instancetype)videoPlayerWithView:(UIView *)view
                           delegate:(id<LKVideoPlayerDelegate>)delegate
                        playerModel:(LKPlayerModel *)playerModel;

/**
 *  在当前页面，设置新的视频时候调用此方法
 */
- (void)resetToPlayNewVideo:(LKPlayerModel *)playerModel; 


/** 自动播放，默认不自动播放 */
- (void)autoPlayTheVideo;

/** 播放视频 */
- (void)playVideo;
/** 暂停视频播放 */
- (void)pauseVideo;
/** 停止视频播放 */
- (void)stopVideo;

/** 销毁视频 */
- (void)destroyVideo;
@end
