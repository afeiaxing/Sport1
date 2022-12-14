/**
 * Tencent is pleased to support the open source community by making QMUI_iOS available.
 * Copyright (C) 2016-2021 THL A29 Limited, a Tencent company. All rights reserved.
 * Licensed under the MIT License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://opensource.org/licenses/MIT
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
 */

//
//  UINavigationBar+QMUI.h
//  QMUIKit
//
//  Created by QMUI Team on 2018/O/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationBar (QMUI)

/**
 UINavigationBar 在 iOS 11 下所有的 item 都会由 contentView 管理，只要在 UINavigationController init 完成后就能拿到 qmui_contentView 的值
 */
@property(nonatomic, strong, readonly, nullable) UIView *qmui_contentView;

@end

NS_ASSUME_NONNULL_END
