//
//  QYZYQATableViewCell.m
//  QYZY
//
//  Created by jspatches on 2022/10/5.
//

#import "QYZYQATableViewCell.h"

@interface QYZYQATableViewCell()

@property (nonatomic, strong) UILabel *askLabel;
@property (nonatomic, strong) UILabel *answerLabel;
@property (nonatomic, strong) UILabel *askContentLabel;
//@property (nonatomic, strong) UILabel *answerContentLabel;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) QYZYQARouModel *model;
@property (nonatomic, assign) CGFloat yCoordinate;
 
@end

@implementation QYZYQATableViewCell

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier rowModel:(QYZYQARouModel *)model {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.model = model;
        if (@available(iOS 14.0, *)) {
            self.backgroundConfiguration = UIBackgroundConfiguration.clearConfiguration;
        } else {
            // Fallback on earlier versions
        }
        
        [self setupSubviews];

    }
    return self;
}


#pragma mark - Private Methods
- (void)setupSubviews {
    
    [self.contentView addSubview:self.askLabel];
    [self.contentView addSubview:self.answerLabel];
    [self.contentView addSubview:self.askContentLabel];
//    [self.contentView addSubview:self.answerContentLabel];
    [self.contentView addSubview:self.lineView];
    
    [self.askLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.leading.equalTo(self.contentView).offset(15);
        make.size.mas_equalTo(CGSizeMake(25, 17));
    }];
    
    self.askContentLabel.text = self.model.ask;
    [self.askContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.askLabel);
        make.leading.equalTo(self.askLabel.mas_trailing);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-15);
        make.height.mas_equalTo(20);
    }];
    
    [self.answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.askLabel.mas_bottom).offset(12);
        make.leading.equalTo(self.askLabel);
        make.size.mas_equalTo(CGSizeMake(25, 17));
    }];
    
    self.yCoordinate = 39;
    NSArray *answers = [self.model.answer componentsSeparatedByString:@"\n"];
    
    [answers enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat height = [obj getHeightWithFont:self.answerLabel.font widthLimit:SCREEN_WIDTH - 55] + 1;
        
        if (self.model.highlight && [obj containsString:self.model.highlight]) {
            YYLabel *protocolLabel = [self getHightLightLabelWithText:obj andHightLightText:self.model.highlight];
            [self addView:protocolLabel WithYCoordinate:self.yCoordinate height:height isLastView:idx == answers.count-1];
        }else {
            UILabel *answerContentLabel = [[UILabel alloc] init];
            answerContentLabel.font = self.answerLabel.font;
            answerContentLabel.textColor =  rgb(80, 80, 92);;
            answerContentLabel.numberOfLines = 0;
            answerContentLabel.text = obj;
            NSString *contentHead = [obj substringToIndex:2];
            // 文本内容不与数字对齐
            if ([contentHead containsString:@"、"]) {
                [answerContentLabel indentationWithLine:2 headIndent:20];
                
            }
            
            [self addView:answerContentLabel WithYCoordinate:self.yCoordinate height:height isLastView:idx == answers.count-1];
        }
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

- (void)addView:(UIView *)view WithYCoordinate:(NSInteger)yCoordinate height:(CGFloat)height isLastView:(BOOL)isLastView{
    
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(yCoordinate);
        make.leading.equalTo(self.answerLabel.mas_trailing);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-15);
        make.height.mas_equalTo(height);
        
        self.yCoordinate += height;
        
        if (isLastView) {
            [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.yCoordinate + 15);
            }];
        }
    }];
}

#pragma mark - Setter & Getter
- (UILabel *)askLabel {
    if (!_askLabel) {
        _askLabel = [[UILabel alloc] init];
        _askLabel.font = [UIFont systemFontOfSize:12];
        _askLabel.text = @"问:";
    }
    return _askLabel;
}

- (UILabel *)askContentLabel {
    if (!_askContentLabel) {
        _askContentLabel = [[UILabel alloc] init];
        _askContentLabel.font = self.askLabel.font;
    }
    return _askContentLabel;
}

- (UILabel *)answerLabel {
    if (!_answerLabel) {
        _answerLabel = [[UILabel alloc] init];
        _answerLabel.font = [UIFont systemFontOfSize:13];
        _answerLabel.text = @"答:";
        _answerLabel.textAlignment = NSTextAlignmentNatural;
    }
    return _answerLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
    }
    return _lineView;
}

- (YYLabel *)getHightLightLabelWithText:(NSString *)text andHightLightText:(NSString *)hightLightText {
    YYLabel *protocolLabel = [[YYLabel alloc] init];
    protocolLabel.numberOfLines = 0;
    NSRange range = [text rangeOfString:hightLightText];
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    attributeString.yy_font = [UIFont systemFontOfSize:12];
    attributeString.yy_color = rgb(80, 80, 92);
    
    weakSelf(self)
    [attributeString yy_setTextHighlightRange:range color:rgb(191, 123, 49) backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        if (self.clickSpecificationBlock) {
            self.clickSpecificationBlock();
        }
    }];
    
    protocolLabel.attributedText = attributeString;
    
    return protocolLabel;
}




@end
