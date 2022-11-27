//
//  QYZYFootballViewModel.m
//  QYZY
//
//  Created by jspatches on 2022/9/30.
//

#import "QYZYFootballViewModel.h"
#import "QYZYappointmentApi.h"

@implementation QYZYFootballViewModel

//预约请求
- (void)requestappointmenttothegameCompletion:(void (^)(NSString * _Nullable msg))completion isBook:(BOOL)isBook
{
    QYZYappointmentApi *api = [[QYZYappointmentApi alloc]init];
    api.leagueId = self.leagueId;
    api.isBook = isBook;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.responseObject[@"msg"]);
        !completion ? : completion(nil);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.error);
        !completion ? : completion(request.error.localizedDescription);
    }];
}

//查询赛程数据
- (void)requestGroupListWithCompletion:(void(^)(NSArray <QYZYMatchListInfoDetailModel *> *groupArray))completion {
    
    QYZYFootballApi *api = [[QYZYFootballApi alloc] init];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.responseObject);
       NSArray *array = [NSArray yy_modelArrayWithClass:[QYZYMatchListInfoDetailModel class] json:[request.responseObject objectForKey:@"data"]];
        NSLog(@"%@",array);
        completion(array);
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.error);
    }];
    
}

- (NSMutableArray *)mutableArray
{
    if (!_mutableArray) {
        _mutableArray = [[NSMutableArray alloc]init];
    }
    return _mutableArray;
}
     

@end
