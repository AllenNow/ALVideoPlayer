//
//  NEDADVideoBrightnessView.h
//  NEDADVideoPlayer
//
//  Created by Allen Gao on 2021/2/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NEDADVideoBrightnessView : UIView

+ (instancetype)sharedBrightnessView;

/** 调用单例记录播放状态是否锁定屏幕方向*/
@property (nonatomic, assign) BOOL isLockScreen;
/** 是否开始过播放 */
@property (nonatomic, assign) BOOL isStartPlay;

@end

NS_ASSUME_NONNULL_END
