//
//  SAMKeychain+NonAccount.h
//  AliMan
//
//  Created by waw on 2019/3/20.
//  Copyright © 2019 waw. All rights reserved.
//

#import <SAMKeychain/SAMKeychain.h>

NS_ASSUME_NONNULL_BEGIN

@interface SAMKeychain (NonAccount)


//储存非账号信息
+(BOOL) addKeychainForkey:(NSString*)key value:(NSString*) value;
+(BOOL) deleteKeychainKey:(NSString*)key;
+(NSString*) keychainForkey:(NSString*)key;

@end

NS_ASSUME_NONNULL_END
