//
//  QYZYNetworkUtil.m
//  QYZY
//
//  Created by jsmaster on 9/29/22.
//

#import "QYZYNetworkUtil.h"
#import "QYZYUserModel.h"

NSDictionary * xm_get_sign_headers(NSString *url, NSDictionary *params, NSDictionary *header, BOOL isGetMethod, BOOL normal) {
    NSMutableDictionary * headers = [[NSMutableDictionary alloc] initWithDictionary:header];
    if (normal) {
        [headers setValue:@"application/json" forKey:@"Content-Type"];
    }
    [headers setValue:[UIDevice qyzy_appVersion] forKey:@"version"];
    [headers setValue:@"ios" forKey:@"client-type"];
    [headers setValue:@"source" forKey:@"0"];
    if (QYZYUserManager.shareInstance.userModel.token) {
        [headers setValue:[NSString stringWithFormat:@"%@ %@",@"Bearer",QYZYUserManager.shareInstance.userModel.token] forKey:@"Authorization"];
        [headers setValue:[NSString stringWithFormat:@"{%@%@}",@"\"uid\":",QYZYUserManager.shareInstance.userModel.uid] forKey:@"x-user-header"];
    } else {
        [headers setValue:@"Basic YXBwOmFwcA==" forKey:@"Authorization"];
        [headers setValue:[NSString stringWithFormat:@"{%@%@}",@"\"uid\":",@"0"] forKey:@"x-user-header"];
    }
    [headers setValue:@"Apple Store" forKey:@"channel"];
    
    [headers setValue:[UIDevice qyzy_getDeviceID] forKey:@"deviceId"];
    
    /// 时间戳
    NSString * milliseconds = @([NSDate qyzy_getCurrentMillisecondTimestamp]).stringValue;
    [headers setValue:milliseconds forKey:@"t"];
    /// MD5 SHA1 加密
    NSString * signValue;
    if (isGetMethod) {
        signValue = [NSString getRequestSignWithParam:params md5Key:@"9e304d4e8df1b74cfa009913198428ab" milliseconds:milliseconds];
    } else {
        signValue = [NSString postRequestSignWithParam:params md5Key:@"9e304d4e8df1b74cfa009913198428ab" milliseconds:milliseconds];
    }
    [headers setValue:signValue forKey:@"sign"];

    /// 随机数
    NSString *randomStr = [[NSString qyzy_uuid] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [headers setValue:randomStr forKey:@"r"];
    
    return headers;
}
