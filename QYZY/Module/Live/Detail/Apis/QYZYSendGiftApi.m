//
//  QYZYSendGiftApi.m
//  QYZY
//
//  Created by jspollo on 2022/10/2.
//

#import "QYZYSendGiftApi.h"

@implementation QYZYSendGiftApi
- (NSString *)requestUrl {
    if (self.anchorId && self.anchorId.length) {
        return [NSString stringWithFormat:@"/live-product/v1/gift/giveGift?%@",AFQueryStringFromParameters([self getDict])];
    } else {
        return [NSString stringWithFormat:@"/live-product/v1/scoreLive/sendGift?%@",AFQueryStringFromParameters([self getDict])];
    }
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return [self getDict];
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

- (NSDictionary *)getDict {
    if (self.anchorId && self.anchorId.length) {
        return @{
            @"anchorId":self.anchorId ,
            @"chatId":self.chatId,
            @"giftId":self.giftId,
            @"count":@1,
            @"type":@2,
            @"continuityStatus":@0
        };
    } else {
        return @{
            @"matchId":self.chatId ,
            @"chatId":self.chatId,
            @"giftId":self.giftId,
            @"count":@1,
            @"type":@2,
            @"continuityStatus":@0
        };
    }
}
@end
