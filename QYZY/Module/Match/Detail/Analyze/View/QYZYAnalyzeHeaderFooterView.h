//
//  QYZYAnalyzeHeaderFooterView.h
//  QYZY
//
//  Created by jsgordong on 2022/10/24.
//

#import <UIKit/UIKit.h>
#import "QYZYAnalyzeSectionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYAnalyzeHeaderFooterView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *matchBtn;
@property (weak, nonatomic) IBOutlet UIButton *homeAwayBtn;

@property (nonatomic, strong) QYZYAnalyzeSectionModel *model;

@property (nonatomic, copy) void(^ matchBlock)(UIButton *btn);
@property (nonatomic, copy) void(^ hostGuessBlock)(UIButton *btn);

@end

NS_ASSUME_NONNULL_END
