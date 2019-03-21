//
//  FBDeviceInfoTools.m
//  AliMan
//
//  Created by waw on 2019/3/20.
//  Copyright © 2019 waw. All rights reserved.
//

#import "FBDeviceInfoTools.h"
#import "SAMKeychain+NonAccount.h"

//idfa idfv
#import <AdSupport/ASIdentifierManager.h>

//macaddress
#import <sys/sysctl.h>
#import <sys/ioctl.h>
#import <sys/socket.h>
#import <net/if.h>
#import <net/if_dl.h>

//mobileOperator
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

//volume
#import <AVFoundation/AVFoundation.h>

#import <Reachability/Reachability.h>

//ssid
#import <SystemConfiguration/CaptiveNetwork.h>


static NSString * SAMKeychain_KeyForidfa = @"keyForidfa";



@implementation FBDeviceInfoTools

+(NSString *)userAccount{
    //TODO:
    return @"";
}

+(NSString *)userPhoneNum{
    //TODO:
    return @"";
}


+(NSString *)appVersion{
    return  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+(NSString *)appDisplayName{
    
    return  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

+(NSString *)idfv{
    NSString *idfv = [SAMKeychain keychainForkey:SAMKeychain_KeyForidfa];
    if (idfv.length) {
        return idfv;
    }
    idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    if (idfv.length) {
        [SAMKeychain addKeychainForkey:SAMKeychain_KeyForidfa value:idfv];
    }else{
        return @"";
    }
    return idfv;
}


+(NSString *)idfa{
    
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    if (idfa.length == 0 || [idfa isEqualToString:@"00000000-0000-0000-0000-000000000000"]) {
        return @"";
    }
    return idfa;
}


+(NSString *)macAddress{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if(sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. Rrror!\n");
        return NULL;
    }
    
    if(sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}


+(NSString *)mobileOperator{
    
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier           = [info subscriberCellularProvider];
    
    //    [info serviceSubscriberCellularProviders];
    //TODO:confirm double sim card
    
    if (carrier == nil) {
        return 0;
    }
    NSString *code = [carrier mobileNetworkCode];
    
    if ([code isEqualToString:@"00"] || [code isEqualToString:@"02"] || [code isEqualToString:@"07"]) {
        return @"中国移动";
    } else if ([code isEqualToString:@"01"] || [code isEqualToString:@"06"]) {
        return @"中国联通";
    } else if ([code isEqualToString:@"03"] || [code isEqualToString:@"05"]) {
        return @"中国电信";
    }
    return @"";
}


+(CGFloat)screenWidth{
    return [[UIScreen mainScreen] bounds].size.width;
}

+(CGFloat)screenHeight{
    return [[UIScreen mainScreen] bounds].size.height;
}

+(CGFloat)powerLeft{
    return [UIDevice currentDevice].batteryLevel * 100;
}

+(CGFloat)screenBrightness{
    return  [UIScreen mainScreen].brightness;
}

+(CGFloat)volume{
    return  [AVAudioSession sharedInstance].outputVolume;
}


+(NSString *)osVersion{
    return [UIDevice currentDevice].systemVersion;
}

+(NSString *)platformVersion{
    
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}


+(NSString *)platform{
    
    NSString * platformVersion = [self platformVersion];
    NSString * platform        = nil;
    
    if ([self isIpad]) {
        NSDictionary *ipadSeries = [self iphoneSeries];
        platform    = ipadSeries[platformVersion];
    }else{
        NSDictionary *iphoneSeries = [self iphoneSeries];
        platform    = iphoneSeries[platformVersion];
    }
    return platform?:@"unknown";
}




+(NSString*)connectionType{
    
    NSString *netconnType = @"";
    Reachability *reach   = [Reachability reachabilityWithHostName:@"www.apple.com"];
    
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            return   @"No Network";
        case ReachableViaWiFi://Wifi
            return   @"WLAN";
        case ReachableViaWWAN://蜂窝
        {
            // 获取手机网络类型
            CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
            NSString *currentStatus = info.currentRadioAccessTechnology;
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
                return  @"2G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
                return  @"2G";  //2.75G EDGE
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
                return  @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
                return  @"3G"; //3.5G HSDPA
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
                return @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
                return @"2G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
                return @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
                return @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
                return @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
                return @"3G"; //HRPD
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
                netconnType = @"4G";
            }
        }
        default:
            break;
    }
    return @"UnKnown";
}


+(NSString *)mccmnc{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *mcc = [carrier mobileCountryCode]; // 国家码 如：460
    NSString *mnc = [carrier mobileNetworkCode]; // 网络码 如：01
    return [NSString stringWithFormat:@"%@%@",mcc,mnc];
}


+(NSString *)ssid{
    NSString *ssid = nil;
    NSArray *ifs   = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        
        if (info[@"SSID"]) {
            ssid = info[@"SSID"];
        }
    }
    return ssid;
}

+(NSString*)bssid{
    NSString * bssid = nil;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info[@"BSSID"]) {
            bssid = info[@"BSSID"];
        }
    }
    return bssid;
}

#pragma mark  - Ext

+(BOOL) isIpad{
    return  UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}


+(NSDictionary*) ipadSeries{
    
    return @{
             @"iPad7,6"    :     @"iPad 6",
             @"iPad7,5"    :     @"iPad 6",
             @"iPad7,4"    :     @"iPad Pro 10.5-inch",
             @"iPad7,3"    :     @"iPad Pro 10.5-inch",
             @"iPad7,2"    :     @"iPad Pro 12.9-inch 2nd-gen",
             @"iPad7,1"    :     @"iPad Pro 12.9-inch 2nd-gen",
             @"iPad6,12"   :     @"iPad 5",
             @"iPad6,11"   :     @"iPad 5",
             @"iPad6,8"    :     @"iPad Pro 12.9-inch",
             @"iPad6,7"    :     @"iPad Pro 12.9-inch",
             @"iPad6,4"    :     @"iPad Pro 9.7-inch",
             @"iPad6,3"    :     @"iPad Pro 9.7-inch",
             @"iPad5,4"    :     @"iPad Air 2",
             @"iPad5,3"    :     @"iPad Air 2",
             @"iPad5,2"    :     @"iPad Mini 4",
             @"iPad5,1"    :     @"iPad Mini 4",
             @"iPad4,9"    :     @"iPad Mini 3",
             @"iPad4,8"    :     @"iPad Mini 3",
             @"iPad4,7"    :     @"iPad Mini 3",
             @"iPad4,6"    :     @"iPad Mini Retina",
             @"iPad4,5"    :     @"iPad Mini Retina",
             @"iPad4,4"    :     @"iPad Mini Retina",
             @"iPad4,3"    :     @"iPad Air",
             @"iPad4,2"    :     @"iPad Air",
             @"iPad4,1"    :     @"iPad Air",
             @"iPad3,6"    :     @"iPad 4",
             @"iPad3,5"    :     @"iPad 4",
             @"iPad3,4"    :     @"iPad 4",
             @"iPad3,3"    :     @"iPad 3",
             @"iPad3,2"    :     @"iPad 3",
             @"iPad3,1"    :     @"iPad 3",
             @"iPad2,7"    :     @"iPad Mini",
             @"iPad2,6"    :     @"iPad Mini",
             @"iPad2,5"    :     @"iPad Mini",
             @"iPad2,4"    :     @"iPad 2",
             @"iPad2,3"    :     @"iPad 2",
             @"iPad2,2"    :     @"iPad 2",
             @"iPad2,1"    :     @"iPad 2",
             @"iPad1,1"    :     @"iPad",
             };
}


+(NSDictionary*) iphoneSeries{
    
    return @{
             
             @"iPhone4,1"    :   @"iPhone 4s",
             
             @"iPhone5,1"    :   @"iPhone 5",
             @"iPhone5,2"    :   @"iPhone 5",
             @"iPhone5,3"    :   @"iPhone 5c",
             @"iPhone5,4"    :   @"iPhone 5c",
             
             @"iPhone6,1"    :   @"iPhone 5s",
             @"iPhone6,2"    :   @"iPhone 5s",
             
             @"iPhone7,1"    :   @"iPhone 6 Plus",
             @"iPhone7,2"    :   @"iPhone 6",
             
             @"iPhone8,1"    :   @"iPhone 6s",
             @"iPhone8,2"    :   @"iPhone 6s Plus",
             @"iPhone8,4"    :   @"iPhone se",
             
             @"iPhone9,1"    :   @"iPhone 7",
             @"iPhone9,2"    :   @"iPhone 7 Plus",
             
             @"iPhone10,1"   :   @"iPhone 8",
             @"iPhone10,2"   :   @"iPhone 8 Plus",
             @"iPhone10,3"   :   @"iPhone X",
             @"iPhone10,4"   :   @"iPhone 8",
             @"iPhone10,5"   :   @"iPhone 8 Plus",
             @"iPhone10,6"   :   @"iPhone X",
             
             @"iPhone11,1"   :   @"iPhone XR",
             @"iPhone11,2"   :   @"iPhone XS",
             @"iPhone11,3"   :   @"iPhone XS",
             @"iPhone11,4"   :   @"iPhone XS Max",
             @"iPhone11,5"   :   @"iPhone XS Max",
             @"iPhone11,6"   :   @"iPhone XS Max",
             @"iPhone11,8"   :   @"iPhone XR",
             
             @"i386"         :   @"iphone Simulator",
             @"x86_64"       :   @"iphone Simulator"
             
             };
    
}

@end
