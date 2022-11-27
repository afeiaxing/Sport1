//
//  QYZYTopBlocksModel.m
//  QYZY
//
//  Created by jsmaster on 10/1/22.
//

#import "QYZYTopBlocksModel.h"

@implementation QYZYTopBlocksModel

+ (NSDictionary *)modelCustomPropertyMapper {
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
