//
//  QYZYQaSectionView.h
//  QYZY
//
//  Created by jspatches on 2022/10/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QYZYQaSectionView,QYZYQaModel;
@protocol QYZYQaSectionViewDelegate <NSObject>


- (void)clickedSection:(QYZYQaSectionView *)sectionView;

@end

@interface QYZYQaSectionView : UIView

@property (nonatomic, weak) id<QYZYQaSectionViewDelegate> delegate;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) QYZYQaModel *model;

@end

NS_ASSUME_NONNULL_END
