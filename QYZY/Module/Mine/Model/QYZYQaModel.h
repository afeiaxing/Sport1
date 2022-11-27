//
//  QYZYQaModel.h
//  QYZY
//
//  Created by jspatches on 2022/10/5.
//

#import <Foundation/Foundation.h>
#import "QYZYQARouModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYQaModel : NSObject
/// 是否展开
@property (nonatomic, assign) BOOL isOpen;

@property (nonatomic, copy) NSString *question;
@property (nonatomic, strong) NSArray<QYZYQARouModel *> *answerList;
@end

NS_ASSUME_NONNULL_END
