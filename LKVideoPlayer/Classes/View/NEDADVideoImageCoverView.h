//
//  LMCoverView.h
//  LKVideoPlayer
//
//  Created by Allen Gao on 2021/2/20.
//

#import <UIKit/UIKit.h>

@protocol NEDCoverControlViewDelegate <NSObject>
/** 封面图片Tap事件 */
- (void)coverControlViewDidClick:(UIView *)controlView;
@end

@interface NEDADVideoImageCoverView : UIView
@property (nonatomic, weak) id<NEDCoverControlViewDelegate> delegate;

- (void)syncCoverImageViewWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage;

@end
