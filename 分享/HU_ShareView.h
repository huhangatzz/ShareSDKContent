//
//  HU_ShareView.h
//  分享
//
//  Created by huhang on 15/11/2.
//  Copyright (c) 2015年 huhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HU_ShareView;
@protocol ShareViewDelegate <NSObject>

- (void)shareView:(HU_ShareView *)shareView shareType:(SSDKPlatformType)shareType;

@end

@interface HU_ShareView : UIView

@property (nonatomic,assign)id<ShareViewDelegate>delegate;

+ (void)showShareView:(UIView *)otherView delegate:(id<ShareViewDelegate>)delgegate;

@end
