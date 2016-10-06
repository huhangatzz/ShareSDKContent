//
//  HU_BottomView.h
//  分享
//
//  Created by huhang on 15/10/28.
//  Copyright (c) 2015年 huhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HU_BottomView;
@protocol BottomViewDelegate <NSObject>

- (void)bottomView:(HU_BottomView *)bottomView button:(UIButton *)button;

@end

@interface HU_BottomView : UIView

@property (nonatomic,assign)id<BottomViewDelegate>delegate;

@end
