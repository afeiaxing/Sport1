//
//  QYZYMatchAnalyzeFooterView.h
//  QYZY
//
//  Created by jsgordong on 2022/10/24.
//

#import <UIKit/UIKit.h>
#import "QYZYMatchViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYMatchAnalyzeFooterView : UIView
@property (nonatomic, strong) QYZYSubMatchModel *historyMatchModel;
@property (nonatomic, strong) QYZYSubMatchModel *hostMatchModel;
@property (nonatomic, strong) QYZYSubMatchModel *guessMatchModel;
@end

NS_ASSUME_NONNULL_END
