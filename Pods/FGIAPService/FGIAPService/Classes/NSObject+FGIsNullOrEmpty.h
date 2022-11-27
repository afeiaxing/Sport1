//
//  NSObject+FGIsNullOrEmpty.h
//  FGIAPService
//
//  Created by FoneG on 2021/5/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (FGIsNullOrEmpty)

- (BOOL)isNSStringAndNotEmpty;
- (BOOL)isNSArrayAndNotEmpty;

@end

NS_ASSUME_NONNULL_END
