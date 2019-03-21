//
//  FBSensorInfoTools.m
//  AliMan
//
//  Created by waw on 2019/3/21.
//  Copyright © 2019 waw. All rights reserved.
//

#import "FBSensorInfoTools.h"



@interface FBSensorInfoTools ()<CLLocationManagerDelegate>

@property(nonatomic,strong) CLLocationManager          *locationManager;
@property(nonatomic,copy)   DataCollectLocationCallback locationCallback;

@end

@implementation FBSensorInfoTools

-(CMAccelerometerData *)pullAccelerometer{
    
    CMMotionManager *manager = [[CMMotionManager alloc] init];
    //判断加速度计可不可用，判断加速度计是否开启
    if ([manager isAccelerometerAvailable] && ![manager isAccelerometerActive]){
        //更新频率是10Hz
        manager.accelerometerUpdateInterval = 0.1;
        //开始更新，后台线程开始运行。这是Pull方式。
        [manager startAccelerometerUpdates];
    }
    //获取并处理加速度计数据
    CMAccelerometerData *newestAccel = manager.accelerometerData;
    NSLog(@"X = %.04f",newestAccel.acceleration.x);
    NSLog(@"Y = %.04f",newestAccel.acceleration.y);
    NSLog(@"Z = %.04f",newestAccel.acceleration.z);
    [manager stopAccelerometerUpdates];
    return newestAccel;
}

-(CMGyroData *)pullGyroData{
    
    CMMotionManager *manager = [[CMMotionManager alloc] init];
    if ([manager isGyroAvailable] && ![manager isGyroActive]){
        manager.accelerometerUpdateInterval = 0.1;
        [manager startGyroUpdates];
    }
    CMGyroData *gyroData = manager.gyroData;
    NSLog(@"Gyro Rotation x = %.04f", gyroData.rotationRate.x);
    NSLog(@"Gyro Rotation y = %.04f", gyroData.rotationRate.y);
    NSLog(@"Gyro Rotation z = %.04f", gyroData.rotationRate.z);
    [manager stopGyroUpdates];
    return gyroData;
}

-(void)collectLocation:(DataCollectLocationCallback)callback{
    
    self.locationCallback = callback;
    [self setUpLocationCollect];
}

-(void) setUpLocationCollect{
    
    CLLocationManager *locationManager=[[CLLocationManager alloc]init];
    self.locationManager=locationManager;
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"设备尚未打开定位服务");
        
        if (self.locationCallback) {
            self.locationCallback(NO,nil,nil);
        }
        return;
    }
    [locationManager requestWhenInUseAuthorization];
    locationManager.delegate        = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    //开始启动定位
    [locationManager startUpdatingLocation];
}

#pragma mark -  CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    if (locations.count == 0) {
        return;
    }
    CLLocation *location = [locations firstObject];
    CLLocationCoordinate2D coordinate=location.coordinate;
    NSLog(@"您的当前位置:经度：%f,纬度：%f,海拔：%f,航向：%f,速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    [self clGeocoderByLocation:location callback:^(CLPlacemark *address) {
        
        if (self.locationCallback) {
            self.locationCallback(YES,location,address);
        }
    }];
    [_locationManager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    if (self.locationCallback) {
        self.locationCallback(NO,nil,nil);
    }
    [_locationManager stopUpdatingLocation];
}

#pragma

/**
 地理位置反码
 @param location CLLocation

 */
-(void) clGeocoderByLocation:(CLLocation*)location callback:(void(^)(CLPlacemark *address))callback{
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc]init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (placemarks.count >0) {
            CLPlacemark * placeMark = placemarks[0];
            
#if DEBUG
            NSString *currentCity   = placeMark.locality;
            if (!currentCity) {
                currentCity = placeMark.administrativeArea;
            }
            NSString * lastAddress  = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",placeMark.country,placeMark.locality,placeMark.subLocality,placeMark.thoroughfare,placeMark.name];
            NSLog(@"%@",lastAddress);
#endif
            if (callback) {
                callback(placeMark);
            }
        }
    }];
}

-(void)dealloc{
    
}


@end
