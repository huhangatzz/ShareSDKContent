//
//  ViewController.m
//  分享
//
//  Created by huhang on 15/10/28.
//  Copyright (c) 2015年 huhang. All rights reserved.
//

#import "ViewController.h"
#import "HU_shareManager.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake((SCREEN_WIDTH - 100) / 2, 100, 100, 100);
    button.backgroundColor = [UIColor cyanColor];
    [button setTitle:@"分享" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonAction:(UIButton *)sender{

    NSLog(@"%s",__func__);
    
    HU_shareModel *shareModel = [[HU_shareModel alloc]init];
    shareModel.title = @"分享标题";
    shareModel.imageURL = @"http://pic26.nipic.com/20121223/11350592_111420143000_2.jpg";
    shareModel.content = @"";
    shareModel.detailURL = @"https://github.com/huhangatzz";
    
    HU_shareManager *manager = [HU_shareManager defaultManger];
    
    [manager shareManagerInViewController:self shareContent:shareModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
