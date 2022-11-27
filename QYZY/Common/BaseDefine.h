//
//  BaseDefine.h
//  QYZY
//
//  Created by jspollo on 2022/9/29.
//

#ifndef BaseDefine_h
#define BaseDefine_h

typedef NS_ENUM(NSInteger ,QYZYMatchType) {
    QYZYMatchTypeFootball = 1,
    QYZYMatchTypeBasketball = 2
};

#define ScreenWidth UIScreen.mainScreen.bounds.size.width
#define ScreenHeight UIScreen.mainScreen.bounds.size.height

#define rgba(r,g,b,a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:a]
#define rgb(r,g,b) rgba(r,g,b,1)

#define weakSelf(type)  __weak typeof(type) weak##type = type;
#define strongSelf(type)  __strong typeof(weak##type) type = weak##type;

// 宽度比例适配
#define QYZY_SCALE(value)           ceil(1.0 * (value) * SCREEN_WIDTH / 375.0)

// 高度比例适配
#define QYZY_HEIGHT_SCALE(value)    ceil(1.0 * (value) * SCREEN_HEIGHT / 667.0)

#define QYZY_DEFAULT_AVATAR [UIImage imageNamed:@"avatar_placeholder"]
#define QYZY_DEFAULT_LOGO [UIImage imageNamed:@"logo_placeholder"]

#define ReadLoginAgreementKey @"ReadLoginAgreementKey"

#define QYZYNetworkingFirstAvaliableNotification @"com.domain.networking.first.avaliable"

#endif /* BaseDefine_h */


#ifndef EnableRequestEncrpt
#define EnableRequestEncrpt 1
#endif

