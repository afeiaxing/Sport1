//
//  QYZYMatchOverModel.m
//  QYZY
//
//  Created by jspollo on 2022/10/13.
//

#import "QYZYMatchOverModel.h"

@implementation QYZYMatchOverModel
- (NSString *)cnText {
    if (_cnText.length) {
        return _cnText;
    }
    else {
        return _content;
    }
}

- (NSString *)time {
    if (_time.length) {
        return _time;
    }
    else {
        if (self.isBasket) {
            NSInteger occur = _occurTime.integerValue;
            return [NSString stringWithFormat:@"%@%ld",_statusName.length ? [NSString stringWithFormat:@"%@\n",_statusName] : @"",(occur / 60)];
        }
        else {
            NSInteger occur = _occurTime.integerValue;
            return [NSString stringWithFormat:@"%ld",(occur / 60)];
        }
    }
}
@end
