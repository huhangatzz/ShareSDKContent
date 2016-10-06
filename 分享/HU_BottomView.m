//
//  HU_BottomView.m
//  分享
//
//  Created by huhang on 15/10/28.
//  Copyright (c) 2015年 huhang. All rights reserved.
//

#import "HU_BottomView.h"

@implementation HU_BottomView

//有xib时使用这个方法
//就是从xib文件中唤醒对象，完成对每一个对象的实例化或与xib文件的关联
- (void)awakeFromNib{
    [super awakeFromNib];
    for (UIView *view in self.subviews) {
        
        if ([view isKindOfClass:[UIButton class]]) {
            
            UIButton *button = (UIButton *)view;
            [button addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

//点击事件
- (void)clickBtnAction:(UIButton *)sender{

    if ([self.delegate respondsToSelector:@selector(bottomView:button:)]) {
        [self.delegate bottomView:self button:sender];
    }
}

@end
