//
//  HU_shareManager.h
//  分享
//
//  Created by huhang on 15/11/2.
//  Copyright (c) 2015年 huhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HU_shareModel.h"

@interface HU_shareManager : NSObject

//创建单例
+ (instancetype)defaultManger;

//注册分享
- (void)registShare;

//初始化分享方法
- (void)shareManagerInViewController:(UIViewController *)controller shareContent:(HU_shareModel *)shareModel;

@end
