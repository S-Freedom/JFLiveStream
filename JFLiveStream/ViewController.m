//
//  ViewController.m
//  JFLiveStream
//
//  Created by huangpengfei on 2018/6/5.
//  Copyright © 2018年 huangpengfei. All rights reserved.
//

#import "ViewController.h"
#import "JFLiveViewController.h"
@interface ViewController ()
@property (nonatomic,copy) NSString *ipAddress;
@property (nonatomic,copy) NSString *myRoom;
@property (nonatomic, copy) NSString *othersRoom;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setButton];
    
}

- (void)setButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"跳转到视频聊天界面" forState:UIControlStateNormal];
    button.frame = CGRectMake(100, 100, 200, 50);
    button.center = self.view.center;
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonClick{
    //弹出输入框
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Info" message:@"请输入详细信息" preferredStyle:UIAlertControllerStyleAlert];
//    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.placeholder = @"192.168.1.122";
//    }];
//    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.placeholder = @"请输入你的房间号";
//    }];
//    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.placeholder = @"请输入对方的房间号";
//    }];
//    //点击确定按钮跳转界面
//    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        //                        @"192.168.15.32"
//        //取到文本数据传值
//        JFLiveViewController *viewController = [[JFLiveViewController alloc] initWithIPAddress:[alert.textFields[0] text] MyRoom:[alert.textFields[1] text] othersRoom:[alert.textFields[2] text]];
//        [self.navigationController pushViewController:viewController animated:YES];
//    }];
//    //取消按钮
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    [alert addAction:sure];
//    [alert addAction:cancel];
//    [self presentViewController:alert animated:YES completion:nil];

    JFLiveViewController *viewController = [[JFLiveViewController alloc] initWithIPAddress:@"" MyRoom:@"" othersRoom:@""];
    [self.navigationController pushViewController:viewController animated:YES];
    
    
}
@end
