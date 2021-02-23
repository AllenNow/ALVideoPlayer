//
//  NEDADVideoPlayerModel.h
//  LKVideoPlayer
//
//  Created by Allen Gao on 2021/2/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NEDADVideoPlayerModel : NSObject

///视频标题
@property (nonatomic, copy) NSString *title;
//// 视频标签 如：热门 精彩推荐
@property (nonatomic, copy) NSString *videoLabel;
///视频URL
@property (nonatomic, copy) NSString *videoURLString;
///视频封面
@property (nonatomic, copy) NSString *videoCoverImageURLString;
///视频需要解锁的时间 为-1，不需要解锁，为0则一开始就需要解锁 , 单位秒
@property (nonatomic, assign) NSInteger lockTime;

@end
