//
//  XMDomainProvider.m
//  XMSport
//
//  Created by jsmaster on 8/20/22.
//  Copyright © 2022 XMSport. All rights reserved.
//

#import "QYZYDomainProvider.h"
#import "QYZYCDNTool.h"
#import "QYZYSetNullTool.h"
#import "DCTar.h"
#import "QYZYNetworkUtil.h"
#import "QYZYPullDomainsApi.h"

NSString * const XMDomainAvaliableNotification = @"com.domain.provider.avaliable";
NSString * const XMDomainAvaliableNotificationDomainKey = @"com.domain.provider.avaliable.domain";
NSString * const XMDomainArchiveFileName = @"com.domain.provider.domain.file";

static dispatch_queue_t xm_save_cache_domains_queue() {
    static dispatch_queue_t xm_save_cache_domains_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        xm_save_cache_domains_queue = dispatch_queue_create("com.domain.provider.domain.save", DISPATCH_QUEUE_SERIAL);
    });

    return xm_save_cache_domains_queue;
}

static NSDictionary * xm_get_common_headers() {
    static NSDictionary *dict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString * value = [NSString stringWithFormat:@"{ \"client-type\": \"ios-qiutx\",\"version\": \"%@\",\"deviceId\": \"%@\"}",[UIDevice qyzy_appVersion], [UIDevice qyzy_getDeviceID]];
        dict = @{@"http-header":value};
    });

    return dict;
}


@interface QYZYDomainProvider ()

@property (nonatomic, strong) NSMutableArray <QYZYDomainDowngradeModel *> *domainDowngradeModels;
@property (nonatomic, strong) NSMutableArray <QYZYDomain *> *domains;
@property (nonatomic, strong) QYZYDomain *currentDomain;
@property (nonatomic, strong) AFNetworkReachabilityManager *reachabilityManager;
@property (nonatomic, strong) AFHTTPSessionManager * httpJsonManager;
@property (nonatomic, strong) AFHTTPSessionManager * httpManager;

/// 域名检测中
@property (nonatomic, assign) BOOL isChecking;

/// 正在正在更多域名中
@property (nonatomic, assign) BOOL isMoreRequesting;

@end

@implementation QYZYDomainProvider

+ (instancetype)shareInstance {
    static QYZYDomainProvider *httpJsonManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpJsonManager = [[self alloc] init];
    });
    return httpJsonManager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.reachabilityManager = [AFNetworkReachabilityManager manager];
        [self.reachabilityManager startMonitoring];
        [self readCacheDomains];
        
        self.httpJsonManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        AFSecurityPolicy *securityPolice = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [securityPolice setValidatesDomainName:NO];
        securityPolice.allowInvalidCertificates = YES;
        self.httpJsonManager.securityPolicy = securityPolice;
        self.httpJsonManager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.httpJsonManager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.httpJsonManager.requestSerializer.timeoutInterval = 5;
        
        self.httpManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        self.httpManager.securityPolicy = securityPolice;
        self.httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.httpManager.requestSerializer.timeoutInterval = 5;
    }
    return self;
}

- (NSString *)domianProviderUserDefaultPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentFilePath = paths.firstObject  ;
    NSString *filePath = [documentFilePath stringByAppendingPathComponent:XMDomainArchiveFileName];
    return filePath;
}

- (void)readCacheDomains {
    NSArray <QYZYDomain *> *domains = [NSKeyedUnarchiver unarchiveObjectWithFile:[self domianProviderUserDefaultPath]];
    if (domains && domains.count > 0) {
        [self addDomains:domains];
    }
}

- (void)saveCacheDomains {
    BOOL suc = [NSKeyedArchiver archiveRootObject:self.domains toFile:[self domianProviderUserDefaultPath]];
    if (!suc) {
        
    }
}

- (void)removeCacheDomains {
    dispatch_async(xm_save_cache_domains_queue(), ^{
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:[self domianProviderUserDefaultPath] error:&error];
        if (error) {
            
        }
    });
}

- (void)addDomains:(NSArray<QYZYDomain *> *)domains {
    if (domains.count == 0) {
        return;
    }
   
    for (QYZYDomain *dom in domains) {
        if ([self.domains containsObject:dom]) {
            self.domains[[self.domains indexOfObject:dom]].openFlag = dom.openFlag;
            self.domains[[self.domains indexOfObject:dom]].weight = dom.weight;
        } else {
            [self.domains addObject:dom];
        }
        
    }
    
    self.domains = [[self.domains sortedArrayUsingComparator:^NSComparisonResult(QYZYDomain * obj1, QYZYDomain * obj2) {
        return obj1.timeConsume > obj2.timeConsume;
    }] mutableCopy];
    
    // 归档本地
    [self saveCacheDomains];
    
}

- (void)clearMemoryAndFile {
    [self.domains removeAllObjects];
    [self removeCacheDomains];
}

- (void)addDomainDowngradeModels:(NSArray<QYZYDomainDowngradeModel *> *)models {
    if (models.count == 0) {
        return;
    }
    
    [self.domainDowngradeModels addObjectsFromArray:models];
    self.domainDowngradeModels = [[self.domainDowngradeModels sortedArrayUsingComparator:^NSComparisonResult(QYZYDomainDowngradeModel  *obj1, QYZYDomainDowngradeModel *obj2) {
        return obj1.rank > obj2.rank;
    }] mutableCopy];

}

- (QYZYDomain *)getDomainInstantlyForWeight:(BOOL)forWeight {
    NSAssert(self.domains.count > 0, @"请先添加域名!");
    NSAssert(self.domainDowngradeModels.count > 0, @"请设置域名降级模型!");
    
    if (forWeight) {
        QYZYDomain *domain = [self.domains qyzy_findFirstWithFilterBlock:^BOOL(QYZYDomain *domain) {
            return domain.weightCnt < domain.weight && domain.timeConsume <= XMDeaultDomainTimeConsume;
        }];
        if (domain) {
            domain.weightCnt = ++domain.weightCnt;
        } else {
            NSArray <QYZYDomain *> *validDomains = [self.domains qyzy_filterByBlock:^BOOL(QYZYDomain *domain) {
                return domain.timeConsume <= XMDeaultDomainTimeConsume;
            }];
            if (validDomains.count > 0) {
                [validDomains enumerateObjectsUsingBlock:^(QYZYDomain *domain, NSUInteger idx, BOOL * _Nonnull stop) {
                    domain.weightCnt = 0;
                }];
                domain = validDomains.firstObject;
            } else {
                domain = self.domains.firstObject;
            }
        }
        
        return domain;
        
    } else {
        // 没有网络直接返回第一个域名
        if (self.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
            return self.domains.firstObject;
        }
        
        // 设置超时时间， 并移到队尾
        if (self.currentDomain != nil) {
            self.currentDomain.timeConsume = XMDeaultFailDomainTimeConsume;
            [self.domains removeObject:self.currentDomain];
            [self.domains addObject:self.currentDomain];
        }
        
        QYZYDomain *domain = [self.domains qyzy_findFirstWithFilterBlock:^BOOL(QYZYDomain * obj) {
            return obj != self.currentDomain;
        }];
        if (domain) {
            self.currentDomain = domain;
        } else {
            domain = self.currentDomain;
        }
        
        // 域名检测
        [self checkDomains];
        
        return domain;
    }
}

- (QYZYDomain *)getDomainModelWithURL:(NSString *)URL {
    return [self.domains qyzy_findFirstWithFilterBlock:^BOOL(QYZYDomain  *obj) {
        return [obj.domain isEqualToString:URL];
    }];
}

/// 域名检测
- (void)checkDomains {
    if (self.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable || self.isChecking) {
        return;
    }
    
    self.isChecking = true;
    
    dispatch_group_t group = dispatch_group_create();
    
    for (QYZYDomain *domain in self.domains) {
        dispatch_group_enter(group);
       
        NSString *url = [NSString stringWithFormat:@"%@/ping", domain.domain];
        
        if (domain.CDNType != XMDomainCDNTypeFunnull && domain.openFlag == true) {
            if ([domain.authType isEqualToString: @"B"]) {
                url = [QYZYCDNTool signatureTypeBCDNWithURL:url token:domain.CDNToken typeValue:domain.CDNType];
            } else {
                url = [QYZYCDNTool signatureTypeACDNWithURL:url token:domain.CDNToken typeValue:domain.CDNType];
            }
        }
        
        NSMutableDictionary *headers = [xm_get_sign_headers(url, @{}, xm_get_common_headers(), true, true) mutableCopy];
        [headers setValue:domain.domainID forKey:@"requst-id"];
        [self.httpJsonManager GET:url parameters:nil headers:[headers copy] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        __weak typeof(self) weakSelf = self;
        [self.httpJsonManager setTaskDidFinishCollectingMetricsBlock:^(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLSessionTaskMetrics * _Nullable metrics) {
            dispatch_main_async_safe(^{
                __strong __typeof(weakSelf) self = weakSelf;
                NSString *domainID = task.currentRequest.allHTTPHeaderFields[@"requst-id"] ?: @"";
                QYZYDomain *domain = [self.domains qyzy_findFirstWithFilterBlock:^BOOL(QYZYDomain *domain) {
                    return  [domainID isEqualToString: domain.domainID];
                }];
                if (domainID.length > 0 && domain != nil) {
                    NSIndexSet *sucIndexset = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)];
                    if ([task.response isKindOfClass:NSHTTPURLResponse.class] && [sucIndexset containsIndex: [(NSHTTPURLResponse *)task.response statusCode]]) {
                        domain.timeConsume = [@(metrics.taskInterval.duration * 1000) integerValue];
                    } else {
                        domain.timeConsume = XMDeaultFailDomainTimeConsume;
                    }
                    if (domain.timeConsume < 1000) {
                        
                            [[NSNotificationCenter defaultCenter] postNotificationName:XMDomainAvaliableNotification object:nil userInfo:@{XMDomainAvaliableNotificationDomainKey: domain}];
                        
                    }
                    
                    dispatch_group_leave(group);
                }
            })
            
            
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        self.domains = [[self.domains sortedArrayUsingComparator:^NSComparisonResult(QYZYDomain * obj1, QYZYDomain * obj2) {
            return obj1.timeConsume > obj2.timeConsume;
        }] mutableCopy];
        self.isChecking = false;
        
        // 归档本地
        [self saveCacheDomains];
        
        [self requestMoreDomains];
    });
    
}

- (void)requestMoreDomains {
    if (self.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable || self.isMoreRequesting) {
        return;
    }
    
    self.isMoreRequesting = true;
    
    [self requestMoreDomainsWithIndex:0];
    
}

- (void)requestMoreDomainsWithIndex:(NSInteger)index {
    if (index >= self.domainDowngradeModels.count) {
        self.isMoreRequesting = false;
        return;
    }
    __block NSInteger nextIndex = index;
    QYZYDomainDowngradeModel *model = self.domainDowngradeModels[index];
    switch (model.type) {
        case XMDomainDowngradeTypeService: {
            // 刚检测， 默认第一次最快
            QYZYDomain *domain = self.domains[0];
            NSString *url = [NSString stringWithFormat:@"%@%@", domain.domain, model.url];

            QYZYPullDomainsApi *api = [QYZYPullDomainsApi new];
            api.fullURL = url;
            [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                NSArray <QYZYDomain *> *domains = [self getResponseDomains:request.responseObject];
                if (domains.count > 0) {
                    [self addDomains:domains];
                    self.isMoreRequesting = false;
                } else {
                    [self requestMoreDomainsWithIndex:++nextIndex];
                }
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                [self requestMoreDomainsWithIndex:++nextIndex];
            }];
    
        }
            break;
        case XMDomainDowngradeTypeOBS: {
            [self.httpManager GET:model.url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSArray <QYZYDomain *> *domains = [self getResponseDomainsWithBase64DataResponseObject:responseObject];
                if (domains.count > 0) {
                    [self addDomains:domains];
                    self.isMoreRequesting = false;
                } else {
                    [self requestMoreDomainsWithIndex:++nextIndex];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self requestMoreDomainsWithIndex:++nextIndex];
            }];
        }
            
            break;
        case XMDomainDowngradeTypeNpm: {
            
            [self.httpJsonManager GET:model.url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if ([responseObject isKindOfClass:NSDictionary.class] && [responseObject[@"dist-tags"] isKindOfClass:NSDictionary.class]) {
                    
                    responseObject = [QYZYSetNullTool changeNullTypeWithValue:responseObject];
                    NSString *version = responseObject[@"dist-tags"][@"latest"];
                    
                    if (version != nil && [version isKindOfClass:NSString.class]) {
                        if ([responseObject[@"versions"] isKindOfClass:NSDictionary.class] && [responseObject[@"versions"][version] isKindOfClass:NSDictionary.class] && [responseObject[@"versions"][version][@"dist"] isKindOfClass:NSDictionary.class]) {
                            
                            NSString *tarball = responseObject[@"versions"][version][@"dist"][@"tarball"];
                            if (tarball != nil) {
                                [self.httpManager GET:tarball parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    
                                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                        
                                        NSString *unzip = [self getNpmDownloadPath:[NSString qyzy_uuid]];
                                        BOOL success = [DCTar decompressData:responseObject toPath:unzip error:nil];
                                        if (success) {
                                            NSString *destPath = [unzip stringByAppendingPathComponent:@"index.js"];
                                            if ([[NSFileManager defaultManager] fileExistsAtPath:destPath]) {
        
                                                dispatch_main_async_safe(^{
                                                    NSArray <QYZYDomain *> *domains = [self getResponseDomainsWithBase64DataResponseObject:[NSData dataWithContentsOfFile:destPath]];
                                                    if (domains.count > 0) {
                                                        [self addDomains:domains];
                                                        self.isMoreRequesting = false;
                                                    } else {
                                                        [self requestMoreDomainsWithIndex:++nextIndex];
                                                    }
                                                })
                                                return;
                                            }
                                        }
                                       
                                         [[NSFileManager defaultManager] removeItemAtPath:unzip error:nil];
                                        dispatch_main_async_safe(^{
                                            [self requestMoreDomainsWithIndex:++nextIndex];
                                        })
                                    });
                                                                
                                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    [self requestMoreDomainsWithIndex:++nextIndex];
                                }];
                                return;
                            }
                        }
                    }
                }
                
                [self requestMoreDomainsWithIndex:++nextIndex];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self requestMoreDomainsWithIndex:++nextIndex];
            }];
        
        }
            break;
    }
    
}

- (NSString *)getNpmDownloadPath:(NSString *)fileName {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"download/npm"];
    documentPath = [documentPath stringByAppendingPathComponent: fileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:documentPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return documentPath;
}

- (NSArray <QYZYDomain *> *)getResponseDomainsWithBase64DataResponseObject:(id _Nullable)responseObject {
    if (responseObject == nil) {
        return nil;
    }
    
    NSString *originStr = [[NSString alloc] initWithData:responseObject encoding:kCFStringEncodingUTF8];
    if (originStr == nil) {
        return nil;
    }
    
    return [self getResponseDomainsWithBase64DataResponseString:originStr];
}

- (NSArray <QYZYDomain *> *)getResponseDomainsWithBase64DataResponseString:(NSString *)responseString {
    if (responseString == nil) {
        return nil;
    }
    
    NSData *temp = [[NSData alloc] initWithBase64EncodedString:responseString options:0];
    if (temp == nil) {
        return nil;
    }
    
    id responseObject = [NSJSONSerialization JSONObjectWithData:temp options:NSJSONReadingMutableContainers error:nil];
    
    return [self getResponseDomains:responseObject];
}

- (NSArray <QYZYDomain *> *)getResponseDomains:(id)responseObject {
    
    NSMutableArray * validArray = [NSMutableArray array];
    if ([responseObject isKindOfClass:NSDictionary.class]) {
        responseObject = [QYZYSetNullTool changeNullTypeWithValue:responseObject];
        NSArray *dataArray = responseObject[@"data"];
        
        [dataArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            NSInteger weight = [obj[@"weight"] integerValue];
            weight = weight < 1 ? 1 : weight;
            
            BOOL openFlag = [obj[@"openFlag"] boolValue];
            NSString *domainUrl = obj[@"domain"];
            NSString *authType = obj[@"signType"];
            NSString *token = obj[@"token"];

            QYZYDomain *domain = [QYZYDomain domainWithDomain:domainUrl enCryptedCDNType:obj[@"cdn"] CDNToken:token authType:authType openFlag:openFlag weight:weight];
            [validArray addObject:domain];
        }];
    }
   
    return [validArray copy];
}

- (NSMutableArray<QYZYDomain *> *)domains {
    if (_domains == nil) {
        _domains = [NSMutableArray array];
    }
    return _domains;
}

- (NSMutableArray<QYZYDomainDowngradeModel *> *)domainDowngradeModels {
    if (_domainDowngradeModels == nil) {
        _domainDowngradeModels = [NSMutableArray array];
    }
    return _domainDowngradeModels;
}

- (NSUInteger)getDomainCount {
    return self.domains.count;
}

@end
