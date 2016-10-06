//
//  HU_ShareView.m
//  分享
//
//  Created by huhang on 15/11/2.
//  Copyright (c) 2015年 huhang. All rights reserved.
//

#import "HU_ShareView.h"
#import "HU_BottomView.h"

@interface HU_ShareView()<BottomViewDelegate>

@property (nonatomic,strong)HU_BottomView *bottomView;;

@end

@implementation HU_ShareView

+ (void)showShareView:(UIView *)otherView delegate:(id<ShareViewDelegate>)delgegate{

    //直接在视图里面初始化
    HU_ShareView *shareView = [[HU_ShareView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    shareView.delegate = delgegate;
    [otherView addSubview:shareView];
}

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)configUI{

    HU_BottomView *bottomView = [[[NSBundle mainBundle] loadNibNamed:@"HU_BottomView" owner:nil options:nil] lastObject];
    bottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, BOTTOM_HIEGHT);
    bottomView.delegate = self;
    [self addSubview:bottomView];
    self.bottomView = bottomView;
}

#pragma mark BottomViewDelegate
- (void)bottomView:(HU_BottomView *)bottomView button:(UIButton *)button{

    if (button.tag == 8) {
        [self dismiss];
    }else{
        [self shareBtnClick:button];
    }
}

- (void)shareBtnClick:(UIButton *)sender{

    //取消视图
    [self dismiss];
    
    //判断点击类型
    SSDKPlatformType type = SSDKPlatformTypeUnknown;
    switch (sender.tag) {
        case 0:
            type = SSDKPlatformTypeWechat;//微信
            break;
        case 1:
            type = SSDKPlatformSubTypeWechatFav;//微信收藏
            break;
        case 2:
            type = SSDKPlatformSubTypeWechatTimeline;//微信朋友圈
            break;
        case 3:
            type = SSDKPlatformTypeSMS;//短信
            break;
        case 4:
            type = SSDKPlatformTypeMail;//邮件
            break;
        case 5:
            type = SSDKPlatformTypeQQ;//QQ
            break;
        case 6:
            type = SSDKPlatformSubTypeQZone;//人人
            break;
        case 7:
            type = SSDKPlatformTypeSinaWeibo;//微博
            break;
        default:
            break;
    }
    
    if ([_delegate respondsToSelector:@selector(shareView:shareType:)]) {
        [self.delegate shareView:self shareType:type];
    }
}

#pragma mark 弹出视图
- (void)willMoveToSuperview:(UIView *)newSuperview{
    
    if (newSuperview) {
        [UIView animateWithDuration:0.6 animations:^{
            _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 250, SCREEN_WIDTH,250);
            self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        }];
    }
}

#pragma mark 视图消失
- (void)dismiss{

    [UIView animateWithDuration:0.6 animations:^{
        //其实就是控制视图的frame
        _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, BOTTOM_HIEGHT);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark 触摸开始时
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
 
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    CGRect topRect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 250);
    if (CGRectContainsPoint(topRect, location)) {
        [self dismiss];
    }
}

@end
