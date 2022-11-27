//
//  XMDomainDowngradeModel.h
//  XMSport
//
//  Created by jsmaster on 8/20/22.
//  Copyright © 2022 XMSport. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 方式1. 从华为云的OBS获取域名列表（已有）
 方式2. 从https://unpkg.com/@elton.bfw/cloud 获取域名列表，返回的数据结构和接口/qiutx-support/domains/v1/pull 相同
 方式3. 从国内NPM镜像仓库获取域名列表，我们会将域名列表数据塞进一个npm包中，npm包是一个标准的tgz包，解压后结构如下所示：
 根目录
 ├─package.json
 ├─index.js

 其中index.js存放了域名列表，数据结构示例
 {
     "code": 200,
     "msg": "操作成功",
     "data": [
         {
             "domain": "https://api.hzmgrn.com",
             "itemList": [
                 {
                     "token": "JmQ8uEKn6g96nSsWccw",
                     "cdn": "aliyun",
                     "openFlag": true
                 }
             ],
             "weight": 50,
             "signType": "A"
         },
         {
             "domain": "https://api.k396w.com",
             "itemList": [
                 {
                     "token": "JmQ8uEKn6g96nSsWccw",
                     "cdn": "aliyun",
                     "openFlag": true
                 }
             ],
             "weight": 50,
             "signType": "A"
         }
     ]
 }


 可以通过下面这些国内npm镜像仓库获取到这个npm包，优先级自上而下，一旦获取到域名列表数据，则结束此流程。
 cnpm    ---  https://r.cnpmjs.org/@elton.bfw/cloud/
 taobao  --- https://registry.npmmirror.com/@elton.bfw/cloud/
 tencent ---  https://mirrors.cloud.tencent.com/npm/@elton.bfw/cloud/
 yarn   ---  https://registry.yarnpkg.com/@elton.bfw/cloud/

 但这种方式相对方式1、方式2较麻烦。

 因为npm的固有特性，我们无法通过一个固定的链接获取到最新版本的包。我们需要先访问这个npm包的元数据，
 比如：https://r.cnpmjs.org/@elton.bfw/cloud/，这个链接会返回类似下面这样的json数据

 {
   "dist-tags": {
     "latest": "1.0.2"
   },
   "name": "@elton.bfw/cloud",
   ...
   "versions": {
     "1.0.2": {
       "name": "@elton.bfw/cloud",
       "version": "1.0.2",
       "_id": "@elton.bfw/cloud@1.0.2",
       "_nodeVersion": "18.7.0",
       "_npmVersion": "8.15.0",
       "dist": {
         "tarball": "https://r.cnpmjs.org/@elton.bfw/cloud/-/cloud-1.0.2.tgz",
         "fileCount": 2,
         "unpackedSize": 804,
     ...
         "size": 383
       },
     ...
     },
     ...
     "1.0.0": {
     ...
     }
   },
   ...
 }

 通过dist-tags.latest提取出这个包的最新版本，然后在versions.$version.dist.tarbll获取到最新的tgz包的链接，将其下载完成后，对这个资源进行解压。
 */

typedef NS_ENUM(NSUInteger, XMDomainDowngradeType) {
    XMDomainDowngradeTypeService = 0, // 从业务服务拉取更多域名
    XMDomainDowngradeTypeOBS = 1, // 从云存储下载站获取
    XMDomainDowngradeTypeNpm = 2, // 从npm获取
};

NS_ASSUME_NONNULL_BEGIN

@interface QYZYDomainDowngradeModel : NSObject


/// 域名降级等级， 越小代表优先级越高
@property (nonatomic, assign) NSInteger rank;

/// 请求更多域名的业务服务接口路径， OBS地址/unpkg， npm地址
@property (nonatomic, copy) NSString *url;

/// 域名降级类型
@property (nonatomic, assign) XMDomainDowngradeType type;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (instancetype)initWithRank:(NSInteger)rank url:(NSString *)url type:(XMDomainDowngradeType)type;

@end

NS_ASSUME_NONNULL_END

