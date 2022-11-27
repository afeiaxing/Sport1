//
//  QYZYAppointmentViewMoel.m
//  QYZY
//
//  Created by jspatches on 2022/10/1.
//

#import "QYZYAppointmentViewMoel.h"

@implementation QYZYAppointmentViewMoel

//请求我的关注
- (void)requestAttentionCompletion:(void(^)(NSArray <QYZYMyattentionModel *> *groupArray))completion {
    
    QYZYMyattentionApi *api = [[QYZYMyattentionApi alloc] init];
    

    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.responseObject);
        NSDictionary *dataDic = request.responseObject[@"data"][@"list"];
        for (QYZYMyattentionModel *model in dataDic) {
            [self.mutableArray addObject:model];
        }
        completion(self.mutableArray);
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.error);
    }];
    
}

//请求我的预约数据
- (void)requestGroupListWithCompletion:(void(^)(NSArray <QYZYMyreserModel *> *groupArray))completion {
    
    QYZYMyreservationApi *api = [[QYZYMyreservationApi alloc] init];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.responseObject);
        NSDictionary *dataDic = request.responseObject[@"data"][@"list"];
        for (QYZYMyreserModel *model in dataDic) {
            [self.mutableArray addObject:model];
        }
        completion(self.mutableArray);
        
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
