//
//  NEDADVideoPortraitControlView.h
//  NEDADVideoPlayer
//
//  Created by Allen Gao on 2021/2/20.
//

#import <UIKit/UIKit.h>

@protocol NEDADVideoControlViewDelegate <NSObject>

///** 播放暂停按钮被点击, 是否选中，选中时当前为播发，按钮为暂停的 */
- (void)portraitPlayPauseButtonClick:(BOOL)isSelected;
///** 进度条开始拖动 */
//- (void)portraitProgressSliderBeginDrag;
///** 进度结束拖动，并返回最后的值 */
//- (void)portraitProgressSliderEndDrag:(CGFloat)value;
///** 全屏按钮被点击 */
//- (void)portraitFullScreenButtonClick;
///** 进度条tap点击 */
//- (void)portraitProgressSliderTapAction:(CGFloat)value;

/** 播放暂停按钮被点击, 是否选中，选中时当前为播发，按钮为暂停的 */
- (void)controlView:(UIView *)controlView didChangePlayAction:(BOOL)isPlaying;

/** 全屏按钮被点击 */
- (void)controlViewDidSelectFullScreen:(UIView *)controlView;

/** 进度条点击某个进度 */
- (void)controlView:(UIView *)controlView didSelectProgress:(CGFloat)progress;

/** 进度条开始拖动 */
- (void)controlViewDidBeginDrag:(UIView *)controlView;

/** 进度结束拖动，并返回最后的值 */
- (void)controlView:(UIView *)controlView didEndDragAtProgress:(CGFloat)progress;

@end

@interface NEDADVideoControlView : UIView
@property (nonatomic, weak) id<NEDADVideoControlViewDelegate> delegate;
@property (nonatomic, copy) NSString *title;


/** 重置ControlView */
- (void)playerResetControlView;
- (void)playEndHideView:(BOOL)playeEnd;

/** 更新播放/暂停按钮显示 */
- (void)syncplayPauseButton:(BOOL)isPlay;

/** 更新缓冲进度 */
- (void)syncbufferProgress:(double)progress;

/** 更新播放进度 */
- (void)syncplayProgress:(double)progress;

/** 更新当前播放时间 */
- (void)syncplayTime:(NSInteger)time;

/** 更新视频时长 */
- (void)syncDurationTime:(NSInteger)time;

@end
