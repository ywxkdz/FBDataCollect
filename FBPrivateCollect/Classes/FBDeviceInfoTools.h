//
//  FBDeviceInfoTools.h
//  AliMan
//
//  Created by waw on 2019/3/20.
//  Copyright © 2019 waw. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBDeviceInfoTools : NSObject

+(NSString*) userAccount;

+(NSString*) userPhoneNum;

+(NSString*) appVersion;
+(NSString*) appDisplayName;

+(NSString*) idfa;
+(NSString*) idfv;

//MAC地址
+(NSString*) macAddress;

+(CGFloat)   screenWidth;
+(CGFloat)   screenHeight;

//剩余电量
+(CGFloat)   powerLeft;
//屏幕亮度
+(CGFloat)   screenBrightness;
//声音
+(CGFloat)   volume;
//运营商
+(NSString*) mobileOperator;
//系统版本
+(NSString*) osVersion;
//网络n类型
+(NSString*) connectionType;

//设备型号 iPad1,1
+(NSString*) platformVersion;
//设备     iPhone X
+(NSString*) platform;

+(NSString*) mccmnc;
+(NSString*) ssid;
+(NSString*) bssid;

@end

NS_ASSUME_NONNULL_END
