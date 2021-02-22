//
//  NEDADVideoStatusModel.h
//  NEDADVideoPlayer
//
//  Created by Allen Gao on 2021/2/20.
//

#import <Foundation/Foundation.h>

@interface NEDADVideoStatusModel : NSObject
/** 是否自动播放 */
@property (nonatomic, assign, getter=isAutoPlay) BOOL autoPlay;
/** 是否被用户暂停 */
@property (nonatomic, assign, getter=isPauseByUser) BOOL pauseByUser;
/** 播放完了 */
@property (nonatomic, assign, getter=isPlayDidEnd) BOOL playDidEnd;
/** 进入后台 */
@property (nonatomic, assign, getter=isDidEnterBackground) BOOL didEnterBackground;
/** 是否正在拖拽进度条 */
@property (nonatomic, assign, getter=isDragged) BOOL dragged;


// ------------我是分割线-------------

/** 是否全屏 */
@property (nonatomic, assign, getter=isFullScreen) BOOL fullScreen;

// ------------我是分割线-------------

/**
 重置状态模型属性
 */
- (void)playerResetStatusModel;

@end
