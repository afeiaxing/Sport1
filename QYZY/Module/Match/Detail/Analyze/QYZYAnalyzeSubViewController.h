//
//  QYZYAnalyzeSubViewController.h
//  QYZY
//
//  Created by jspollo on 2022/10/14.
//

#import "QYZYBaseViewController.h"
#import "QYZYMatchMainModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger ,AnalyzeSubType) {
    AnalyzeSubTypeHistory,
    AnalyzeSubTypeHost,
    AnalyzeSubTypeGuest
};

@interface QYZYAnalyzeSubViewController : QYZYBaseViewController<JXCategoryListContentViewDelegate>
@property (nonatomic ,assign) AnalyzeSubType subType;
@property (nonatomic ,strong) QYZYMatchMainModel *detailModel;
@end

NS_ASSUME_NONNULL_END
