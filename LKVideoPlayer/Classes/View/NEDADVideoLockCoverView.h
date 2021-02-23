//
//  NEDADVideoLockView.h
//  LKVideoPlayer
//
//  Created by Allen Gao on 2021/2/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NEDADVideoLockCoverView : UIView

@property (nonatomic, assign) BOOL isPreview;

- (instancetype)initWithAction:(void (^)(void))action;

/// 有标题的类型(无标题直接使用-init)
/// @param title 视频标题内容
/// @param label 视频标签内容
- (void)updateTitle:(nullable NSString  *)title label:(nullable NSString  *)label;

- (void)hide;
- (void)show;

@end

NS_ASSUME_NONNULL_END
