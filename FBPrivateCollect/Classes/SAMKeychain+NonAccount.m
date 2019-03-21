//
//  SAMKeychain+NonAccount.m
//  AliMan
//
//  Created by waw on 2019/3/20.
//  Copyright © 2019 waw. All rights reserved.
//

#import "SAMKeychain+NonAccount.h"

@implementation SAMKeychain (NonAccount)

//储存非账号信息
+(BOOL) addKeychainForkey:(NSString*)key value:(NSString*) value{
    NSString *serviveName = [[NSBundle mainBundle] bundleIdentifier];
    key = [NSString stringWithFormat:@"PersistentStorage_%@",key];
    return  [self setPassword:value forService:serviveName account:key];
}
+(BOOL) deleteKeychainKey:(NSString*)key{
    NSString *serviveName = [[NSBundle mainBundle] bundleIdentifier];
    key = [NSString stringWithFormat:@"PersistentStorage_%@",key];
    return  [self deletePasswordForService:serviveName account:key];
}
+(NSString*) keychainForkey:(NSString*)key{
    NSString *serviveName = [[NSBundle mainBundle] bundleIdentifier];
    key = [NSString stringWithFormat:@"PersistentStorage_%@",key];
    return  [self passwordForService:serviveName account:key];
}

@end
