//
//  QYZYCuestomRequestFilter.m
//  QYZY
//
//  Created by jsmaster on 9/29/22.
//

#import "QYZYCustomRequestFilter.h"
#import "QYZYCDNTool.h"
#import "QYZYNetworkUtil.h"
#import "QYZYDomain.h"
#import "QYZYDomainProvider.h"
#import "QYZYAppConfig.h"
#import "QYZYSetNullTool.h"

NSString * const QYZYUserExitNotification = @"com.qyzy.user.exit";
NSString * const QYZYUserExitNotificationInfoKey = @"com.qyzy.user.exit.info.key";;

@implementation QYZYCustomRequestFilter

- (NSString *)filterUrl:(NSString *)originUrl withRequest:(YTKBaseRequest *)request {
    // 1. 添加_tt参数
    NSString *urlStr = originUrl;
    NSString *keyStr = @"_tt";

    if (![urlStr containsString:keyStr]) {
        NSUInteger randomValue = arc4random(); //随机数字
        if ([urlStr containsString:@"?"]) {
            urlStr = [NSString stringWithFormat:@"%@&%@=%zd", urlStr, keyStr, randomValue];
        } else {
            urlStr = [NSString stringWithFormat:@"%@?%@=%zd", urlStr, keyStr, randomValue];
        }
    };

    // 2. 业务加签
    NSDictionary *header = xm_get_sign_headers(originUrl, [request requestArgument] , [request requestHeaderFieldValueDictionary], [request requestMethod] == YTKRequestMethodGET, request.constructingBodyBlock == nil);
    request.requestHeaderFieldValues = header;
    
    return urlStr;
    
}

- (NSMutableURLRequest *)customRequestWithOriginRequest:(NSMutableURLRequest *)request {
    // 1. 构造新的请求
    NSMutableURLRequest *newReuqest = [request mutableCopy];
    NSURL *originURL = newReuqest.URL;
    NSString *domain = [NSString stringWithFormat:@"%@://%@", originURL.scheme, originURL.host];
#if EnableRequestEncrpt
    NSString *newURLString = [domain stringByAppendingFormat:@"/api/v1/%@", [NSString qyzy_uuid]];
    NSMutableString *httpHeaderString = [NSMutableString string];
    NSMutableData *httpRequestData = [NSMutableData data];
    NSString *httpFirstLine = [NSString stringWithFormat:@"%@ %@ HTTP/1.1\n", request.HTTPMethod, [originURL.absoluteString substringFromIndex:domain.length]];
    [httpHeaderString appendString:httpFirstLine];
    [request.allHTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [httpHeaderString appendFormat:@"%@: %@\n", key, obj];
    }];
    [httpHeaderString appendString:@"\n"];
    [httpRequestData appendData: [httpHeaderString dataUsingEncoding:NSUTF8StringEncoding]];
    if (request.HTTPBody) {
        [httpRequestData appendData:request.HTTPBody];
    }

    newReuqest.HTTPBody = [QYZYDomain aci_encryptWithAESData:[httpRequestData copy]];
    newReuqest.HTTPMethod = @"POST";
#else
    NSString *newURLString = originURL.absoluteString;
#endif

    
    // 2. CDN加签
    QYZYDomain *domainModel = [QYZYDomainProvider.shareInstance getDomainModelWithURL:domain];
    if (domainModel.CDNType != XMDomainCDNTypeFunnull && domainModel.openFlag == true) {
        if ([domainModel.authType isEqualToString:@"B"]) {
            newURLString = [QYZYCDNTool signatureTypeBCDNWithURL:newURLString token:domainModel.CDNToken typeValue:domainModel.CDNType];
        } else {
            newURLString = [QYZYCDNTool signatureTypeACDNWithURL:newURLString token:domainModel.CDNToken typeValue:domainModel.CDNType];
        }
    }
    
    newReuqest.URL = [NSURL URLWithString:newURLString];
    
    return newReuqest;
}

- (NSData *)customResponseDataWithOriginResponseData:(NSData *)responseData {
    // 1. 业务数据解密
#if EnableRequestEncrpt
    return [QYZYDomain aci_decryptWithAESData:responseData];
#else
    return responseData;
#endif
    
}

- (BOOL)validateResponseObject:(YTKBaseRequest *)request error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    if ([request responseSerializerType] == YTKResponseSerializerTypeJSON && ![request.requestUrl isEqualToString:@"/qiutx-pay/api/pay/recharge"] && ![request.requestUrl isEqualToString:@"/qiutx-pay/api/pay/iosVerify"]) {
        id res = request.responseObject;
        if ([res isKindOfClass:NSDictionary.class]) {
            NSInteger code = [res[@"code"] integerValue];
            if (code != 200) {
                if (code == 9527 || code == 9528 || code == 9529 || code == 9530) {
                    dispatch_main_async_safe(^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:QYZYUserExitNotification object:nil userInfo:@{QYZYUserExitNotificationInfoKey: res[@"msg"] ?: @"网络错误，请稍后重试!"}];
                    });
                }
                *error = [NSError errorWithDomain:YTKRequestValidationErrorDomain code:[res[@"code"] integerValue] userInfo:@{NSLocalizedDescriptionKey: res[@"msg"] ?: @"网络错误，请稍后重试!"}];;
                return false;
            }
        } else {
            *error = [NSError errorWithDomain:YTKRequestValidationErrorDomain code:YTKRequestValidationErrorInvalidJSONFormat userInfo:@{NSLocalizedDescriptionKey: @"网络错误，请稍后重试!"}];
            return false;
        }
    }
    return true;
}

- (id)responseObjectWithOriginResponseObject:(id)responseObject {
    return [QYZYSetNullTool changeNullTypeWithValue:responseObject];
}

- (void)customResponseError:(YTKBaseRequest *)request error:(NSError * _Nullable __autoreleasing *)error {
    *error = [NSError errorWithDomain:(*error).domain code:(*error).code userInfo:@{NSLocalizedDescriptionKey: @"网络错误，请稍后重试!"}];
    if (![request.requestUrl containsString:@"qiutx-support/domains/v2/pull"]) {
        dispatch_main_async_safe(^{
            YTKNetworkConfig.sharedConfig.baseUrl = [QYZYDomainProvider.shareInstance getDomainInstantlyForWeight:false].domain;
        });
    }
}

@end
