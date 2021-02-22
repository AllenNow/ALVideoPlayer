//
//  NEDADVideoLockView.h
//  LKVideoPlayer
//
//  Created by Allen Gao on 2021/2/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NEDADVideoLockView : UIView

@property (nonatomic, assign) BOOL isPreview;

/// 有标题的类型(无标题直接使用-init)
/// @param title 视频标题内容
/// @param label 视频标签内容
- (instancetype)initWithTitle:(NSString *)title label:(NSString *)label;

@end

NS_ASSUME_NONNULL_END
