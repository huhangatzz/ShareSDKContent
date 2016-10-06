//
//  HU_shareModel.h
//  分享
//
//  Created by huhang on 2016/10/4.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HU_shareModel : NSObject

/** 分享标题 */
@property (nonatomic,copy)NSString *title;
/** 分享内容 */
@property (nonatomic,copy)NSString *content;
/** 分享图片url */
@property (nonatomic,copy)NSString *imageURL;
/** 点击时url */
@property (nonatomic,copy)NSString *detailURL;

@end
