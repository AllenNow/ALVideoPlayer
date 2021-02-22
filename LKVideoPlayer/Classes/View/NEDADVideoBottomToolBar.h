//
//  NEDADBottomToolBar.h
//  LKVideoPlayer
//
//  Created by Allen Gao on 2021/2/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NEDADVideoBottomToolBarDelegate <NSObject>

/** 全屏按钮被点击 */
- (void)bottomToolBarDidSelectFullScreen:(UIView *)bottomToolBar;

- (void)bottomToolBarDidSelectReplay:(UIView *)bottomToolBar;

/** 进度条点击某个进度 */
- (void)bottomToolBar:(UIView *)bottomToolBar didSelectProgress:(CGFloat)progress;

/** 进度条开始拖动 */
- (void)bottomToolBarDidBeginDrag:(UIView *)bottomToolBar;

/** 进度结束拖动，并返回最后的值 */
- (void)bottomToolBar:(UIView *)bottomToolBar didEndDragAtProgress:(CGFloat)progress;

@end

@interface NEDADVideoBottomToolBar : UIView

@property (nonatomic, weak) id<NEDADVideoBottomToolBarDelegate> delegate;

- (void)reset;

/** 更新缓冲进度 */
- (void)syncbufferProgress:(double)progress;

/** 更新播放进度 */
- (void)syncplayProgress:(double)progress;

/** 更新当前播放时间 */
- (void)syncplayTime:(NSInteger)time;

/** 更新视频时长 */
- (void)syncDurationTime:(NSInteger)time;

- (void)showRefreshButton:(BOOL)showed;

@end

NS_ASSUME_NONNULL_END
