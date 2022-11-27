//
//  QYZYNewsDetailCurrentNewsModel.m
//  QYZY
//
//  Created by jsgordong on 2022/10/2.
//

#import "QYZYNewsDetailCurrentNewsModel.h"

@implementation QYZYNewsDetailCurrentNewsModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
        @"ID": @"id"
    };
}

- (NSString *)newsId {
    if (!_newsId) {
        _newsId = _ID;
    }
    return _newsId;
}

@end
