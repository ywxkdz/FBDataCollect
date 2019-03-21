//
//  FBSensorInfoTools.h
//  AliMan
//
//  Created by waw on 2019/3/21.
//  Copyright © 2019 waw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>


typedef void(^DataCollectLocationCallback)(BOOL isSuccess,CLLocation *location,CLPlacemark *address);

NS_ASSUME_NONNULL_BEGIN

@interface FBSensorInfoTools : NSObject

-(void) collectLocation:(DataCollectLocationCallback)callback;

//加速计
-(CMAccelerometerData *) pullAccelerometer;
//陀螺仪
-(CMGyroData*)           pullGyroData;


@end

NS_ASSUME_NONNULL_END
