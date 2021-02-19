
//
//  LKPlayer.h
//  LMIJKPlayer
//
//  Created by 李小南 on 2017/4/6.
//  Copyright © 2017年 LMIJKPlayer. All rights reserved.
//


// 屏幕尺寸
#define LM_SCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width
#define LM_SCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height
#define LM_SCREEN_BOUNDS  [UIScreen mainScreen].bounds
// 机型
#define SCREEN_MAX_LENGTH (MAX(LM_SCREEN_WIDTH, LM_SCREEN_HEIGHT))
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_4  (IS_IPHONE && SCREEN_MAX_LENGTH == 480.0)


#import "LKVideoPlayer.h"
#import "LKPlayerModel.h"
#import "LKPlayerStatusModel.h"
#import "LKBrightnessView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LKVideoPlayerKit : NSObject
+ (void)previewVideoWithURL:(NSString *)url displayingVC:(UIViewController *)displayingVC ;
@end

NS_ASSUME_NONNULL_END
