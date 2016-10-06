//
//  HU_shareManager.m
//  分享
//
//  Created by huhang on 15/11/2.
//  Copyright (c) 2015年 huhang. All rights reserved.
//

#import "HU_shareManager.h"
#import "HU_ShareView.h"
#import "UIView+Toast.h"

//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝ShareSDK头文件＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//＝＝＝＝＝＝＝＝＝＝以下是各个平台SDK的头文件，根据需要继承的平台添加＝＝＝＝＝＝＝＝＝＝
//腾讯开放平台
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//人人SDK头文件
#import <RennSDK/RennSDK.h>

//支付宝SDK头文件
#import "APOpenAPI.h"

//使用自己公司的appkey
static NSString *appkey = @"13338793ba668";

@interface HU_shareManager ()<ShareViewDelegate,WXApiDelegate>

/** 数据模型 */
@property (nonatomic,strong)HU_shareModel *shareModel;
/** 窗口视图 */
@property (nonatomic,strong)UIWindow *keyWindow;

@end

@implementation HU_shareManager

+ (instancetype)defaultManger{
  
    static HU_shareManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HU_shareManager alloc]init];
    });
    return manager;
}

#pragma mark - 注册shareSDK
- (void)registShare{
    
    //根据需求添加类型
    NSArray *platforms = @[@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformTypeTencentWeibo),@(SSDKPlatformTypeRenren),@(SSDKPlatformTypeMail),@(SSDKPlatformTypeSMS),@(SSDKPlatformTypeAliPaySocial),@(SSDKPlatformTypeWechat),@(SSDKPlatformTypeQQ)];
    
    [ShareSDK registerApp:appkey activePlatforms:platforms onImport:^(SSDKPlatformType platformType) {
        
        [self initializePlat:platformType];
        
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        
        [self initializePlatForTrusteeship:platformType appInfo:appInfo];
        
    }];
}

#pragma mark 初始化方法
- (void)shareManagerInViewController:(UIViewController *)controller shareContent:(HU_shareModel *)shareModel{
    //分享模型数据
    self.shareModel = shareModel;
    //初始化分享视图
    [HU_ShareView showShareView:controller.view delegate:self];
}

#pragma mark ShareViewDelegate
- (void)shareView:(HU_ShareView *)shareView shareType:(SSDKPlatformType)shareType{

    //创建分享参数
    NSString *text = self.shareModel.content;
    NSURL *url = [NSURL URLWithString:self.shareModel.detailURL];
    NSString *title = self.shareModel.title;
    NSArray *images = @[[UIImage imageNamed:@"shareImg.png"]];
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    //使用客户端分享
    [shareParams SSDKEnableUseClientShare];
    
    //设置分享参数
    [shareParams SSDKSetupShareParamsByText:text images:images url:url title:title type:SSDKContentTypeAuto];
    
    //开始分享
    [ShareSDK share:shareType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        [self showShareResult:shareType state:state error:error];
    }];
}

#pragma mark 显示分享成功与否
- (void)showShareResult:(SSDKPlatformType)type state:(SSDKResponseState)state error:(NSError *)error{
    
    //类型未知
    if (type == SSDKPlatformTypeUnknown) return;
    
    //返回分享的名字
    NSString *name = [self platformName:type];
    NSString *tips = nil;
    
    if (state == SSDKResponseStateBegin) {  //分享开始
        tips = (type == SSDKPlatformSubTypeWechatTimeline ? [NSString stringWithFormat:@"开始%@",name] : [NSString stringWithFormat:@"开始%@分享",name]);
    }else if (state == SSDKResponseStateSuccess){//分享成功
        tips = (type == SSDKPlatformSubTypeWechatTimeline ? [NSString stringWithFormat:@"%@成功",name] : [NSString stringWithFormat:@"%@分享成功",name]);
    }else if (state == SSDKResponseStateCancel){//取消分享
        tips = (type == SSDKPlatformSubTypeWechatTimeline ? [NSString stringWithFormat:@"取消%@",name] : [NSString stringWithFormat:@"取消%@分享",name]);
    }else if (state == SSDKResponseStateFail){//分享失败
        tips = (type == SSDKPlatformSubTypeWechatTimeline ? [NSString stringWithFormat:@"%@失败",name] : [NSString stringWithFormat:@"%@分享失败",name]);
    }
    
    //显示信息
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (error) {
        if (type == SSDKPlatformSubTypeQQFriend) {
            [keyWindow makeToast:@"尚未安装QQ或者QQ空间客户"];
        }else{
            [keyWindow makeToast:@"分享失败"];
        }
    }else{
        [keyWindow makeToast:tips];
    }
    self.keyWindow = keyWindow;
}

#pragma mark - 初始化社交平台
- (void)initializePlat:(SSDKPlatformType)platformType{
    
    switch (platformType) {
        case SSDKPlatformTypeWechat://微信
            [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
            break;
            
        case SSDKPlatformTypeQQ://QQ
            [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
            break;
            
        case SSDKPlatformTypeRenren://人人
            [ShareSDKConnector connectRenren:[RennClient class]];
            break;
            
        case SSDKPlatformTypeAliPaySocial://支付宝
            [ShareSDKConnector connectAliPaySocial:[APOpenAPI class]];
            break;
            
        default:
            break;
    }
}

- (void)initializePlatForTrusteeship:(SSDKPlatformType)platformType appInfo:(NSMutableDictionary *)appInfo{
    
    switch (platformType) {
        case SSDKPlatformTypeSinaWeibo://微博
            //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
            [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243" appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3" redirectUri:@"http://www.sharesdk.cn" authType:SSDKAuthTypeBoth];
            break;
        case SSDKPlatformTypeWechat://微信
            [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
                                  appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
            break;
        case SSDKPlatformTypeRenren://人人
            [appInfo SSDKSetupRenRenByAppId:@"226427" appKey:@"fc5b8aed373c4c27a05b712acba0f8c3" secretKey:@"f29df781abdd4f49beca5a2194676ca4" authType:SSDKAuthTypeBoth];
            break;
        case SSDKPlatformTypeTencentWeibo://腾讯微博
            //设置腾讯微博应用信息，其中authType设置为只用Web形式授权
            [appInfo SSDKSetupTencentWeiboByAppKey:@"801307650"
                                         appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
                                       redirectUri:@"http://www.sharesdk.cn"];
            break;
        case SSDKPlatformTypeQQ://QQ
            [appInfo SSDKSetupQQByAppId:@"100371282"
                                 appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                               authType:SSDKAuthTypeBoth];
            break;
        case SSDKPlatformTypeAliPaySocial://支付宝
            [appInfo SSDKSetupAliPaySocialByAppId:@"2015072400185895"];
            break;
            
        default:
            break;
    }
}

#pragma mark - 返回字符串
- (NSString *)platformName:(SSDKPlatformType)type{
    
    switch (type) {
        case SSDKPlatformTypeSinaWeibo:
            return @"新浪微博";
            break;
        case SSDKPlatformTypeTencentWeibo:
            return @"腾讯微博";
            break;
        case SSDKPlatformTypeQQ:
            return @"QQ";
            break;
        case SSDKPlatformTypeWechat:
            return @"微信";
            break;
        case SSDKPlatformTypeAliPaySocial:
            return @"支付宝好友";
            break;
        case SSDKPlatformSubTypeWechatTimeline:
            return @"微信朋友圈";
            break;
        case SSDKPlatformSubTypeWechatSession:
            return @"微信好友";
            break;
        case SSDKPlatformTypeRenren:
            return @"人人网";
            break;
        case SSDKPlatformTypeMail:
            return @"邮件";
            break;
        case SSDKPlatformTypeSMS:
            return @"短信";
            break;
        default:
            return nil;
            break;
    }
}

@end
