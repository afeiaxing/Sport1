//
//  QYZYLiveMainViewModel.m
//  QYZY
//
//  Created by jspollo on 2022/9/29.
//

#import "QYZYLiveMainViewModel.h"
#import "QYZYLiveMainGroupApi.h"
#import "QYZYLiveMainHotApi.h"
#import "QYZYLiveListApi.h"
#import "QYZYLiveBannerApi.h"

@implementation QYZYLiveMainViewModel

- (void)requestGroupListWithCompletion:(void(^)(NSArray <QYZYLiveMainGroupModel *> *groupArray ,NSString *msg))completion {
    QYZYLiveMainGroupApi *api = [[QYZYLiveMainGroupApi alloc] init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray *array = [NSArray yy_modelArrayWithClass:QYZYLiveMainGroupModel.class json:request.responseJSONObject[@"data"][@"liveGroupList"]];
        !completion ?: completion(array,nil);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !completion ?: completion(nil,request.error.localizedDescription);
    }];
}

- (void)requestHotListWithCompletion:(void (^)(NSArray<QYZYLiveMainHotModel *> * hotArray, NSString * msg))completion {
    QYZYLiveMainHotApi *api = [[QYZYLiveMainHotApi alloc] init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray *array = [NSArray yy_modelArrayWithClass:QYZYLiveMainHotModel.class json:request.responseJSONObject[@"data"]];
        !completion ?: completion(array,nil);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !completion ?: completion(nil,request.error.localizedDescription);
    }];
}

- (void)requestLiveListWithLiveGroupId:(NSString *)liveGroupId completion:(void (^)(NSArray<QYZYLiveListModel *> * liveArray, NSString * msg))completion {
    QYZYLiveListApi *api = [[QYZYLiveListApi alloc] init];
    api.liveGroupId = liveGroupId;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray *array = [NSArray yy_modelArrayWithClass:QYZYLiveListModel.class json:request.responseJSONObject[@"data"]];
        !completion ?: completion(array,nil);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !completion ?: completion(nil,request.error.localizedDescription);
    }];
}

- (void)requestLiveBannerWithCompletion:(void (^)(NSArray<QYZYLiveBannerModel *> * bannerArray, NSString * msg))completion {
    QYZYLiveBannerApi *api = [[QYZYLiveBannerApi alloc] init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray *array = [NSArray yy_modelArrayWithClass:QYZYLiveBannerModel.class json:request.responseJSONObject[@"data"]];
        !completion ?: completion(array,nil);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !completion ?: completion(nil,request.error.localizedDescription);
    }];
}

@end
