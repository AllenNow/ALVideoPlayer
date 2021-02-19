//
//  LKVideoPlayerKit.m
//  LKVideoPlayerKit
//
//  Created by Allen Gao on 2020/4/24.
//

#import "LKVideoPlayerKit.h"
#import <AVKit/AVKit.h>
#import "LKVideoPlayerController.h"

//@router_handler($video$player) {
//    NSDictionary *video = parameters[@"video"];
//    if (!video) {
//        [promise reject:@"URL_ERROR" message:@"URL 为空" error:nil];
//        return;
//    }
//
//    NSString *url = video[@"url"];
//    if (!url) {
//        [promise reject:@"URL_ERROR" message:@"URL 为空" error:nil];
//        return;
//    }
//
//    NSString *regular = @"^(http|https)\\://\\S+\\.(mp4|m3u8|mov|MOV)$";
//    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regular];
//    if (![numberPre evaluateWithObject:url]) {
//        [promise reject:@"URL_ERROR" message:@"URL 错误或视频格式不支持" error:nil];
//        return;
//    }
//    [LKVideoPlayerKit previewVideoWithURL:url];
//    [promise resolve:@{}];
//}

@implementation LKVideoPlayerKit
+ (void)previewVideoWithURL:(NSString *)url displayingVC:(UIViewController *)displayingVC {
    LKVideoPlayerController *controller = [[LKVideoPlayerController alloc] initWithURL:url];
    if (@available(iOS 13, *)) {
        controller.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    [displayingVC presentViewController:controller animated:true completion:nil];
}
@end
