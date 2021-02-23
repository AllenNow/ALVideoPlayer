//
//  NEDADPalyerKit.h
//  LKVideoPlayer
//
//  Created by Allen Gao on 2021/2/23.
//

#import <Foundation/Foundation.h>
#import "NEDADVideoPlayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface NEDADPalyerKit : NSObject

+ (instancetype)defaultKit;

- (NEDADVideoPlayer *)createPlayerWithView:(UIView *)view
                           delegate:(id<NEDADVideoPlayerDelegate>)delegate
                               playerModel:(NEDADVideoPlayerModel *)playerModel indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
