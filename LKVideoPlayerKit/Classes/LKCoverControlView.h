//
//  LMCoverView.h
//  拉面视频Demo
//
//  Created by 李小南 on 16/9/26.
//  Copyright © 2016年 lamiantv. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LKCoverControlViewDelegate <NSObject>
/** 封面图片Tap事件 */
- (void)coverControlViewBackgroundImageViewTapAction;
@end

@interface LKCoverControlView : UIView
@property (nonatomic, weak) id<LKCoverControlViewDelegate> delegate;
- (void)syncCoverImageViewWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage;
@end
