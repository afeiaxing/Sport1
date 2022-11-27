//
//  QYZYLiveDetailViewModel.m
//  QYZY
//
//  Created by jspollo on 2022/9/30.
//

#import "QYZYLiveDetailViewModel.h"
#import "QYZYDetailPullInfoApi.h"
#import "QYZYDetailBaseInfoApi.h"
#import "QYZYDetailMoreApi.h"
#import "QYZYLiveRankDayApi.h"
#import "QYZYLiveChatFilterApi.h"
#import "QYZYLiveGetGiftApi.h"
#import "QYZYSendGiftApi.h"
#import "QYZYAmountwithApi.h"

@implementation QYZYLiveDetailViewModel
- (void)requestPullInfoWithAnchorId:(NSString *)anchorId completion:(void(^)(NSDictionary *pullInfo))completion {
    QYZYDetailPullInfoApi *api = [[QYZYDetailPullInfoApi alloc] init];
    api.anchorId = anchorId;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *pullInfo = request.responseObject[@"data"];
        !completion ?: completion(pullInfo);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !completion ?: completion(nil);
    }];
}
- (void)requestBaseInfoWithAnchorId:(NSString *)anchorId completion:(void(^)(NSDictionary *baseInfo))completion {
    QYZYDetailBaseInfoApi *api = [[QYZYDetailBaseInfoApi alloc] init];
    api.anchorId = anchorId;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *baseInfo = request.responseObject[@"data"];
        !completion ?: completion(baseInfo);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !completion ?: completion(nil);
    }];
}

- (void)requestMoreLiveWithAnchorId:(NSString *)anchorId completion:(void(^)(NSArray <QYZYLiveListModel *> *array))completion {
    QYZYDetailMoreApi *api = [[QYZYDetailMoreApi alloc] init];
    api.anchorId = anchorId;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray *array = [NSArray yy_modelArrayWithClass:QYZYLiveListModel.class json:request.responseJSONObject[@"data"]];
        !completion ?: completion(array);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !completion ?: completion(nil);
    }];
}

- (void)requestRankDataWithAnchorId:(NSString *)anchorId isDay:(BOOL)isDay completion:(void(^)(NSArray <QYZYLiveRankModel *> *array))completion {
    QYZYLiveRankDayApi *api = [[QYZYLiveRankDayApi alloc] init];
    api.anchorId = anchorId;
    api.isDay = isDay;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray *array = [NSArray yy_modelArrayWithClass:QYZYLiveRankModel.class json:request.responseObject[@"data"]];
        !completion ?: completion(array);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !completion ?: completion(nil);
    }];
}

- (void)requestFilterDataWithContent:(NSString *)content completion:(void(^)(QYZYLiveChatFilterModel *filterModel))completion {
    QYZYLiveChatFilterApi *api = [[QYZYLiveChatFilterApi alloc] init];
    api.content = content;
    
    QYZYLiveChatFilterModel *model = [[QYZYLiveChatFilterModel alloc] init];
    model.userId = QYZYUserManager.shareInstance.userModel.uid.stringValue;
    model.nickname = QYZYUserManager.shareInstance.userModel.nickName;
    model.content = content;
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *temp = request.responseJSONObject[@"data"];
        model.content = [temp objectForKey:@"content"];
        model.sign = [temp objectForKey:@"sign"];
        model.pushTime = [temp objectForKey:@"pushTime"];
        model.success = [[temp objectForKey:@"success"] boolValue];
        model.desc = [temp objectForKey:@"desc"];
        !completion ?: completion(model);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !completion ?: completion(nil);
    }];
}

- (void)requestGetGiftWithCompletion:(void(^)(NSArray <QYZYChatGiftModel *> *giftArray))completion {
    QYZYLiveGetGiftApi *api = [[QYZYLiveGetGiftApi alloc] init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSMutableArray *temp = [NSMutableArray array];
        NSArray <QYZYChatGiftModel *>*array = [NSArray yy_modelArrayWithClass:QYZYChatGiftModel.class json:request.responseObject[@"data"]];
        [array enumerateObjectsUsingBlock:^(QYZYChatGiftModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.type isEqualToString:@"2"]) {
                [temp addObject:obj];
            }
        }];
        !completion ?: completion(temp);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !completion ?: completion(nil);
    }];
}

- (void)requestSendGiftWithAnchorId:(NSString *)anchorId giftId:(NSString *)giftId chatId:(NSString *)chatId completion:(void(^)(NSString * msg))completion {
    QYZYSendGiftApi *api = [[QYZYSendGiftApi alloc] init];
    api.anchorId = anchorId;
    api.giftId = giftId;
    api.chatId = chatId;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        !completion ?: completion(nil);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !completion ?: completion(request.error.localizedDescription);
    }];
}

- (void)requestBalanceWithCompletion:(void(^)(QYZYAmountwithModel *model))completion {
    QYZYAmountwithApi *amountApi = [QYZYAmountwithApi new];
    [amountApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        QYZYAmountwithModel *model = [QYZYAmountwithModel yy_modelWithJSON:[request.responseObject objectForKey:@"data"]];
        
        QYZYUserModel *userModel = QYZYUserManager.shareInstance.userModel;
        userModel.balance = model.balance;
        [QYZYUserManager.shareInstance saveUserModel:userModel];
        
        !completion ? : completion(model);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !completion ? : completion(nil);
    }];
}
@end
