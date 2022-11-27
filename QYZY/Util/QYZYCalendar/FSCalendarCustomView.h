//
//  FSCalendarCustomView.h
//  XMSport
//
//  Created by jsarcherr on 2021/12/4.
//  Copyright © 2021 XMSport. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^FSCalendarCustomViewCancelBlock)(void);
typedef void (^FSCalendarCustomViewConformBlock)(void);

@interface FSCalendarCustomView : UIView

@property (nonatomic, copy) FSCalendarCustomViewCancelBlock cancelBlock;
@property (nonatomic, copy) FSCalendarCustomViewConformBlock conformBlock;

@end

NS_ASSUME_NONNULL_END
