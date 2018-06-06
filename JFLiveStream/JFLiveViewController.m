//
//  JFLiveViewController.m
//  JFLiveStream
//
//  Created by huangpengfei on 2018/6/6.
//  Copyright © 2018年 huangpengfei. All rights reserved.
//

#import "JFLiveViewController.h"
#import "LFLiveSession.h"
@interface JFLiveViewController () <LFLiveSessionDelegate>
//当前区域网所在IP地址
@property (nonatomic,copy) NSString *ipAddress;
//我的房间号
@property (nonatomic,copy) NSString *myRoom;
//别人的房间号
@property (nonatomic,copy) NSString *othersRoom;
//ip后缀(如果用本地服务器,则为在nginx.conf文件中写的rtmplive)
@property (nonatomic, copy) NSString *suffix;
//大视图
@property (nonatomic,strong) UIView *bigView;
//小视图
@property (nonatomic,strong) UIView *smallView;
//播放器
//@property (nonatomic,strong) IJKFFMoviePlayerController *player;
//推流会话
@property (nonatomic,strong) LFLiveSession *session;

@property (nonatomic, copy) NSString *urlStr;
@end

@implementation JFLiveViewController

- (instancetype)initWithIPAddress:(NSString *)ipAddress MyRoom:(NSString *)myRoom othersRoom:(NSString *)othersRoom{
    
    if(self = [super init]){
        self.ipAddress = ipAddress;
        self.myRoom = myRoom;
        self.othersRoom = othersRoom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.smallView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 667)];
    [self.view addSubview:self.smallView];
    
    // 推流端
    [self requesetAccessForMedio];
    [self requesetAccessForVideo];
    [self startLive];
    
//    self.bigView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 667)];
//    [self.view addSubview:self.bigView];
//    // 拉流端
//    [self initPlayerObserver];
//    [self.player play];
    
}

- (void)startLive{
    LFLiveStreamInfo *streamInfo = [[LFLiveStreamInfo alloc] init];
    self.urlStr = [NSString stringWithFormat:@"rtmp://192.168.1.122:1935/mylive/room"];
    streamInfo.url = self.urlStr;
    [self.session startLive:streamInfo];
}

- (void)stopLive{
    [self.session stopLive];
}

/**
 *  请求摄像头资源
 */
- (void)requesetAccessForVideo{
    __weak typeof(self) weakSelf = self;
    //判断授权状态
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            //发起授权请求
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //运行会话
                        [weakSelf.session setRunning:YES];
                    });
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            //已授权则继续
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.session setRunning:YES];
            });
            break;
        }
        default:
            break;
    }
}

/**
 *  请求音频资源
 */
- (void)requesetAccessForMedio{
    __weak typeof(self) weakSelf = self;
    //判断授权状态
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            //发起授权请求
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //运行会话
                        [weakSelf.session setRunning:YES];
                    });
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            //已授权则继续
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.session setRunning:YES];
            });
            break;
        }
        default:
            break;
    }
}

/** live status changed will callback */
- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange:(LFLiveState)state{
    NSLog(@"%s",__func__);
}
/** live debug info callback */
- (void)liveSession:(nullable LFLiveSession *)session debugInfo:(nullable LFLiveDebug *)debugInfo{
    NSLog(@"%s",__func__);
}
/** callback socket errorcode */
- (void)liveSession:(nullable LFLiveSession *)session errorCode:(LFLiveSocketErrorCode)errorCode{
    NSLog(@"%s",__func__);
    //弹出警告
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"连接错误,请检查IP地址后重试" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:sure];
    [self presentViewController:alert animated:YES completion:nil];
}
//
//- (void)initPlayerObserver{
//    //监听网络状态改变
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStateDidChange:) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:self.player];
//    //监听播放网络状态改变
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playStateDidChange:) name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:self.player];
//}
////网络状态改变通知响应
//- (void)loadStateDidChange:(NSNotification *)notification{
//    IJKMPMovieLoadState loadState = self.player.loadState;
//    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
//        NSLog(@"LoadStateDidChange: 可以开始播放的状态: %d\\n",(int)loadState);
//    }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
//        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\\n", (int)loadState);
//    } else {
//        NSLog(@"loadStateDidChange: ???: %d\\n", (int)loadState);
//    }
//}
////播放状态改变通知响应
//- (void)playStateDidChange:(NSNotification *)notification{
//    switch (_player.playbackState) {
//
//        case IJKMPMoviePlaybackStateStopped:
//            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
//            break;
//
//        case IJKMPMoviePlaybackStatePlaying:
//            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
//            break;
//
//        case IJKMPMoviePlaybackStatePaused:
//            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
//            break;
//
//        case IJKMPMoviePlaybackStateInterrupted:
//            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
//            break;
//
//        case IJKMPMoviePlaybackStateSeekingForward:
//        case IJKMPMoviePlaybackStateSeekingBackward: {
//            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
//            break;
//        }
//
//        default: {
//            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
//            break;
//        }
//    }
//}
- (LFLiveSession *)session{
    if(!_session){
        _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_High1]];
        _session.preView = self.smallView;
        _session.delegate = self;
        _session.showDebugInfo = YES;
    }
    return _session;
}

//- (IJKFFMoviePlayerController *)player{
//    if(!_player){
//        IJKFFOptions *options = [IJKFFOptions optionsByDefault];
//        _player = [[IJKFFMoviePlayerController alloc] initWithContentURLString:self.urlStr withOptions:options];
//        _player.scalingMode = IJKMPMovieScalingModeFill;
//        _player.view.frame = self.bigView.bounds;
//        [self.bigView addSubview:_player.view];
//        _player.shouldAutoplay = YES;
//        [_player prepareToPlay];
//    }
//    return _player;
//}

@end
