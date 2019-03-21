//
//  FBDeviceInfo.h
//  AliMan
//
//  Created by waw on 2019/3/20.
//  Copyright © 2019 waw. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBDeviceInfo : NSObject

@property(nonatomic,copy) NSString *userAccount;
@property(nonatomic,copy) NSString *userPhoneNum;

@property(nonatomic,copy) NSString *appVersion;
@property(nonatomic,copy) NSString *appDisplayName;
@property(nonatomic,copy) NSString *idfa;
@property(nonatomic,copy) NSString *idfv;
@property(nonatomic,copy) NSString *macAddress;
@property(nonatomic,copy) NSString *mobileOperator;
@property(nonatomic,copy) NSString *osVersion;
@property(nonatomic,copy) NSString *connectionType;
@property(nonatomic,copy) NSString *platformVersion;
@property(nonatomic,copy) NSString *platform;
@property(nonatomic,copy) NSString *mccmnc;
@property(nonatomic,copy) NSString *ssid;
@property(nonatomic,copy) NSString *bssid;

@property(nonatomic,assign) CGFloat screenWidth;
@property(nonatomic,assign) CGFloat screenHeight;
@property(nonatomic,assign) CGFloat powerLeft;
@property(nonatomic,assign) CGFloat screenBrightness;
@property(nonatomic,assign) CGFloat volume;


@end

NS_ASSUME_NONNULL_END
