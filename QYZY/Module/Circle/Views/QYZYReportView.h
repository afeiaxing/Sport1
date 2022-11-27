//
//  QYZYReportView.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ActionClickBlock)(NSInteger selectIndex);

@interface QYZYReportView : UIView

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, copy) ActionClickBlock actionBlock;

- (instancetype)initWithSafeArea:(CGFloat)safeArea;

- (void)showView;


@end

NS_ASSUME_NONNULL_END
