//
//  QYZYMatchAnalyzeFooterView.m
//  QYZY
//
//  Created by jsgordong on 2022/10/24.
//

#import "QYZYMatchAnalyzeFooterView.h"

@interface QYZYMatchAnalyzeFooterView ()
@property (nonatomic, strong) UILabel *rankLabel;
@end

@implementation QYZYMatchAnalyzeFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.rankLabel];
        [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (NSString *)handleNullStr:(NSString *)str {
    if (nil == str
        || NULL == str
        || [@"NULL" isEqualToString:str]
        || [@"<null>" isEqualToString:str]
        || [@"(null)" isEqualToString:str]
        || [@"null" isEqualToString:str]) {
        return @"-";
    }
    return str;
}

- (NSString *)handleAttributed:(QYZYSubMatchModel *)matchModel {
    if ([matchModel.sportId isEqualToString:@"1"]) {
        NSString *contentStr = [NSString stringWithFormat:@"%@胜  %@平  %@负  进 %@ 球  失 %@ 球",[self handleNullStr:matchModel.hostWinNum],[self handleNullStr:matchModel.hostDrawNum],[self handleNullStr:matchModel.hostLoseNum],[self handleNullStr:matchModel.hostScore],[self handleNullStr:matchModel.guestScore]];
        return contentStr;
    }
    
    if ([matchModel.sportId isEqualToString:@"2"]) {
        NSString *contentStr = [NSString stringWithFormat:@"%@胜  %@负  均得 %.1f 均失 %.1f",[self handleNullStr:matchModel.hostWinNum],[self handleNullStr:matchModel.hostLoseNum],[self handleNullStr:matchModel.pointsGetPerGame].floatValue,[self handleNullStr:matchModel.pointsLostPerGame].floatValue];
        return contentStr;
    }
    return @"";
}

- (void)setHistoryMatchModel:(QYZYSubMatchModel *)historyMatchModel {
    if (historyMatchModel == nil) return;
    _historyMatchModel = historyMatchModel;
    self.rankLabel.text = [self handleAttributed:historyMatchModel];
}

- (void)setHostMatchModel:(QYZYSubMatchModel *)hostMatchModel {
    if (hostMatchModel == nil) return;
    _hostMatchModel = hostMatchModel;
    self.rankLabel.text = [self handleAttributed:hostMatchModel];
}

- (void)setGuessMatchModel:(QYZYSubMatchModel *)guessMatchModel {
    if (guessMatchModel == nil) return;
    _guessMatchModel = guessMatchModel;
    self.rankLabel.text = [self handleAttributed:guessMatchModel];
}

- (UILabel *)rankLabel {
    if (!_rankLabel) {
        _rankLabel = [[UILabel alloc] init];
        _rankLabel.textColor = rgb(149, 157, 176);
        _rankLabel.text = @"排名";
        _rankLabel.font = [UIFont systemFontOfSize:10];
        _rankLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rankLabel;
}

@end
