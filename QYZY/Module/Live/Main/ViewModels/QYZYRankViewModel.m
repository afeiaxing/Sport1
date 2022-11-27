//
//  QYZYRankViewModel.m
//  QYZY
//
//  Created by jspatches on 2022/10/1.
//

#import "QYZYRankViewModel.h"

@implementation QYZYRankViewModel

//请求排行榜 豪气榜
- (void)requestRankDataWithtype:(NSNumber *)type isDay:(BOOL)isDay completion:(void(^)(NSArray <QYZYRankModel *> *array))completion {
    QYZYRankApi *api = [[QYZYRankApi alloc] init];
    api.type = type;
    api.isDay = isDay;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray *array = [NSArray yy_modelArrayWithClass:QYZYRankModel.class json:request.responseObject[@"data"]];
        !completion ?: completion(array);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !completion ?: completion(nil);
    }];
}


@end
